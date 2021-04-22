-- Optimizations
local showMap, showBars, showArmor, showOxygen, isOpen, cinematicHud, isPaused
local pulseHealth, pulseShield, pulseStamina, pulseOxygen
local healthActive, shieldActive, staminaActive, oxygenActive, microphoneActive, timeActive, cinematicActive, idActive
local healthSwitch, shieldSwitch, staminaSwitch, oxygenSwitch, microphoneSwitch, timeSwitch, cinematicSwitch, idSwitch

-- Variables

local whisper, normal, shout = 33, 66, 100 
local microphone = normal -- Change this for default

-- Main Thread
CreateThread(function()
	while true do
        local health 			= nil
		local ped 				= PlayerPedId()
		local pedId 			= PlayerId()
		local oxygen 			= GetPlayerUnderwaterTimeRemaining(pedId) * Config.oxygenMax
		local stamina 			= 100 - GetPlayerSprintStaminaRemaining(pedId)
		local armor, id 		= GetPedArmour(ped), GetPlayerServerId(pedId)
		local minutes, hours 	= GetClockMinutes(), GetClockHours()
		local players 			= #GetActivePlayers() * 100 / Config.maxPlayers

		if IsEntityDead(ped) then
			health = 0
		else
			health = GetEntityHealth(ped) - 100
		end
		if (oxygen <= 0) then
			oxygen = 0
		end
		if (minutes <= 9) then
			minutes = "0" .. minutes
		end
		if (hours <= 9) then
			hours = "0" .. hours
		end
		
		if Config.hideArmor and not cinematicHud and not isPaused then
			if (armor <= 0) then
				if not shieldSwitch then
					SendNUIMessage({action = 'armorHide'})
					shieldActive = false
					showArmor = false
				else
					SendNUIMessage({action = 'armorShow'})
					shieldActive = true
					showArmor = true
				end
			else
				SendNUIMessage({action = 'armorShow'})
				shieldActive = true
				showArmor = true
			end
		end
		if Config.hideOxygen and not cinematicHud and not isPaused then
			if IsEntityInWater(ped) then
				SendNUIMessage({action = 'oxygenShow'})
				oxygenActive = true
				showOxygen = true
			else
				SendNUIMessage({action = 'oxygenHide'})
				oxygenActive = false
				showOxygen = false
			end
		end
		if Config.pulseHud then
			if (health <= 35) and not (health == 0) then
				if not pulseHealth then
					SendNUIMessage({action = 'healthStart'})
					pulseHealth = true
				else 
					SendNUIMessage({action = 'healthStop'})
					pulseHealth = false
				end
			end
			if (armor <= 35) and not (armor == 0) then
				if not pulseShield then
					SendNUIMessage({action = 'armorStart'})
					pulseShield = true
				else
					SendNUIMessage({action = 'armorStop'})
					pulseShield = false
				end
			end
			if (stamina <= 35) then 
				if not pulseStamina then
					SendNUIMessage({action = 'staminaStart'})
					pulseStamina = true
				else
					SendNUIMessage({action = 'staminaStop'})
					pulseStamina = false
				end
			end
			if (oxygen <= 35) and not (oxygen == 0) then 
				if not pulseOxygen then
					SendNUIMessage({action = 'oxygenStart'})
					pulseOxygen = true
				else
					SendNUIMessage({action = 'oxygenStop'})
					pulseOxygen = false
				end
			end
		end
		if IsPauseMenuActive() and not isPaused and not isOpen then
			if not healthActive then
				healthActive = true
				SendNUIMessage({action = 'healthHide'})
			end
			if not shieldActive then
				shieldActive = true
				SendNUIMessage({action = 'armorHide'})
			end
			if not staminaActive then
				staminaActive = true
				SendNUIMessage({action = 'staminaHide'})
			end
			if oxygenActive then
				oxygenActive = false
				SendNUIMessage({action = 'oxygenHide'})
			end
			if microphoneActive then
				microphoneActive = false
				SendNUIMessage({action = 'microphoneHide'})
			end
			if timeActive then
				timeActive = false
				SendNUIMessage({action = 'timeHide'})
			end
			if idActive then
				idActive = false
				SendNUIMessage({action = 'idHide'})
			end
			if cinematicActive then
				cinematicActive = false
				SendNUIMessage({action = 'cinematicHide'})
			end
			isPaused = true
		elseif not IsPauseMenuActive() and isPaused and not cinematicHud then
			if healthActive and not healthSwitch then
				healthActive = false
				SendNUIMessage({action = 'healthShow'})
			end
			if shieldActive and not shieldSwitch and not showArmor then
				shieldActive = false
				SendNUIMessage({action = 'armorShow'})
			end
			if staminaActive and not staminaSwitch then
				staminaActive = false
				SendNUIMessage({action = 'staminaShow'})
			end
			if not oxygenActive and oxygenSwitch and showOxygen then
				oxygenActive = true
				SendNUIMessage({action = 'oxygenShow'})
			end
			if not microphoneActive and microphoneSwitch then
				microphoneActive = true
				SendNUIMessage({action = 'microphoneShow'})
			end
			if not timeActive and timeSwitch then
				timeActive = true
				SendNUIMessage({action = 'timeShow'})
			end
			if not cinematicActive and cinematicSwitch then
				cinematicActive = true
				SendNUIMessage({action = 'cinematicShow'})
			end
			if not idActive and idSwitch then
				idActive = true
				SendNUIMessage({action = 'idShow'})
			end
			isPaused = false
		elseif not IsPauseMenuActive() and cinematicHud and isPaused then
			if not healthActive then
				healthActive = true
				SendNUIMessage({action = 'healthHide'})
			end
			if not shieldActive then
				shieldActive = true
				SendNUIMessage({action = 'armorHide'})
			end
			if not staminaActive then
				staminaActive = true
				SendNUIMessage({action = 'staminaHide'})
			end
			if oxygenActive then
				oxygenActive = false
				SendNUIMessage({action = 'oxygenHide'})
			end
			if microphoneActive then
				microphoneActive = false
				SendNUIMessage({action = 'microphoneHide'})
			end
			if timeActive then
				timeActive = false
				SendNUIMessage({action = 'timeHide'})
			end
			if idActive then
				idActive = false
				SendNUIMessage({action = 'idHide'})
			end
			cinematicActive = true
			SendNUIMessage({action = 'cinematicShow'})
			isPaused = false
		end
		SendNUIMessage({
			action = "hud",
			health = health,
			armor = armor,
			stamina = stamina,
			oxygen = oxygen,
			id = id,
			players = players,
			time = hours .. " : " .. minutes
		})
		Wait(420)
	end
end)

CreateThread(function()
    while isOpen do
        Wait(100)
        DisableControlAction(0, 322, true)
    end
end)

-- NUI + Events
RegisterNUICallback('close', function(event)
	SendNUIMessage({ action = 'hide' })
	SetNuiFocus(false, false)
	isOpen = false
end)

RegisterNUICallback('change', function(data)
    TriggerEvent('PE:change', data.action)
end)

RegisterNetEvent('PE:change')
AddEventHandler('PE:change', function(action)
    if action == "health" then
		if not healthActive then
			healthActive = true
			healthSwitch = true
			SendNUIMessage({action = 'healthHide'})
		else
			healthActive = false
			healthSwitch = false
			SendNUIMessage({action = 'healthShow'})
		end
    elseif action == "armor" then
		if not shieldActive then
			shieldActive = true
			shieldSwitch = true
			SendNUIMessage({action = 'armorHide'})
		else
			shieldActive = false
			shieldSwitch = false
			SendNUIMessage({action = 'armorShow'})
		end
    elseif action == "stamina" then
		if not staminaActive then
			staminaActive = true
			staminaSwitch = true
			SendNUIMessage({action = 'staminaHide'})
		else
			staminaActive = false
			staminaSwitch = false
			SendNUIMessage({action = 'staminaShow'})
		end
	elseif action == "oxygen" then
		if not oxygenActive then
			oxygenActive = true
			oxygenSwitch = true
			SendNUIMessage({action = 'oxygenShow'})
		else
			oxygenActive = false
			oxygenSwitch = false
			SendNUIMessage({action = 'oxygenHide'})
		end
	elseif action == "id" then
		if not idActive then
			idActive = true
			idSwitch = true
			SendNUIMessage({action = 'idShow'})
		else
			idActive = false
			idSwitch = false
			SendNUIMessage({action = 'idHide'})
		end
	elseif action == "map" then
		if not showMap then
			showMap = true
			DisplayRadar(true)
		else
			showMap = false
			DisplayRadar(false)
		end
	elseif action == "cinematic" then
		if not cinematicActive then
			cinematicActive = true
			cinematicSwitch = true
			cinematicHud = true
			if not healthActive then
				healthActive = true
				SendNUIMessage({action = 'healthHide'})
			end
			if not shieldActive then
				shieldActive = true
				SendNUIMessage({action = 'armorHide'})
			end
			if not staminaActive then
				staminaActive = true
				SendNUIMessage({action = 'staminaHide'})
			end
			if oxygenActive then
				oxygenActive = false
				SendNUIMessage({action = 'oxygenHide'})
			end
			if microphoneActive then
				microphoneActive = false
				SendNUIMessage({action = 'microphoneHide'})
			end
			if timeActive then
				timeActive = false
				SendNUIMessage({action = 'timeHide'})
			end
			if idActive then
				idActive = false
				SendNUIMessage({action = 'idHide'})
			end
			SendNUIMessage({action = 'cinematicShow'})
		else
			cinematicActive = false
			cinematicSwitch = false
			cinematicHud = false
			if healthActive and not healthSwitch then
				healthActive = false
				SendNUIMessage({action = 'healthShow'})
			end
			if shieldActive and not shieldSwitch and not showArmor then
				shieldActive = false
				SendNUIMessage({action = 'armorShow'})
			end
			if staminaActive and not staminaSwitch then
				staminaActive = false
				SendNUIMessage({action = 'staminaShow'})
			end
			if not oxygenActive and oxygenSwitch and showOxygen then
				oxygenActive = true
				SendNUIMessage({action = 'oxygenShow'})
			end
			if not microphoneActive and microphoneSwitch then
				microphoneActive = true
				SendNUIMessage({action = 'microphoneShow'})
			end
			if not timeActive and timeSwitch then
				timeActive = true
				SendNUIMessage({action = 'timeShow'})
			end
			if not cinematicActive and cinematicSwitch then
				cinematicActive = true
				SendNUIMessage({action = 'cinematicShow'})
			end
			if not idActive and idSwitch then
				idActive = true
				SendNUIMessage({action = 'idShow'})
			end
			SendNUIMessage({action = 'cinematicHide'})
		end
	elseif action == "time" then
		if not timeActive then
			timeActive = true
			timeSwitch = true
			SendNUIMessage({action = 'timeShow'})
		else
			timeActive = false
			timeSwitch = false
			SendNUIMessage({action = 'timeHide'})
		end
	elseif action == "microphone" then
		if not microphoneActive then
			microphoneActive = true
			microphoneSwitch = true
			SendNUIMessage({action = 'microphoneShow'})
		else
			microphoneActive = false
			microphoneSwitch = false
			SendNUIMessage({action = 'microphoneHide'})
		end
    end
end)

-- Opening Menu
RegisterCommand('hud', function()
	if not isOpen then
		isOpen = true
		SendNUIMessage({ action = 'show' })
		SetNuiFocus(true, true)
	end
end)

RegisterCommand('+levelVoice', function()
	if (microphone == 33) then
		microphone = normal
		SendNUIMessage({
			action = "microphone",
			microphone = microphone
		})
	elseif (microphone == 66) then
		microphone = shout
		SendNUIMessage({
			action = "microphone",
			microphone = microphone
		})
	elseif (microphone == 100) then
		microphone = whisper
		SendNUIMessage({
			action = "microphone",
			microphone = microphone
		})
	end
end)

RegisterKeyMapping('hud', 'Open the hud menu', 'keyboard', Config.openKey)

RegisterKeyMapping('+levelVoice', 'Do not use', 'keyboard', Config.voiceChange)

-- Handler
AddEventHandler('playerSpawned', function()
	DisplayRadar(false)
end)
