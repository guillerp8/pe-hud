local name = "[^4pe-hud^7]"

AddEventHandler('onResourceStart', function(resourceName)
	if GetCurrentResourceName() == resourceName then
		function checkVersion(error, latestVersion, headers)
			local currentVersion = LoadResourceFile(resourceName, "./server/version")
			if currentVersion ~= latestVersion and tonumber(currentVersion) < tonumber(latestVersion) then
				print(name .. " ^1is outdated.\nCurrent version: ^8" .. currentVersion .. "\nNewest version: ^2".. latestVersion .. "\n^3Update^7: https://github.com/Project-Entity/pe-hud/tree/dev")
			elseif tonumber(currentVersion) > tonumber(latestVersion) then
				print(name .. " has skipped the latest version ^2" .. latestVersion .."Either Github is offline or ./server/version has been changed")
			else
				print(name .. " is updated. ^3Settings saved values to players...")
				Wait(3000)
				print("^2Finished")
			end
		end
	
		PerformHttpRequest("https://raw.githubusercontent.com/Project-Entity/pe-hud/dev//version", checkVersion, "GET")
	end
end)