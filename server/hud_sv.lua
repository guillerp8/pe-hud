local players = {}
local name, file = 'pe-hud', './html/js/players.json'
local loadFile = LoadResourceFile(name, file)

RegisterCommand('get', function(source)
    TriggerEvent('PE:getColors', source)
end)

-- Events
RegisterNetEvent('PE:getColors')
AddEventHandler('PE:getColors', function(source)
    local identifier = GetPlayerIdentifier(source, identifier)
    if players[identifier] then
        local colorsData = players[identifier]
        TriggerClientEvent('PE:setData', source, colorsData)
        print("Obtained colors")
    else
        insertColors(identifier, Config.default)
        print("Data default")
    end
end)

RegisterNetEvent('PE:saveColors') -- Still can't get it to work
AddEventHandler('PE:saveColors', function(default, colors) -- bool, colors from client
    local source = source
    local identifier = GetPlayerIdentifier(source, -1)
    local information = {healthColor = '#9DE112', shieldColor = '#3585DA', staminaColor = '#FFC100', oxygenColor = '#A636ED', timeColor = '#CCC', microphoneColor = '#ff6f00', idColor = '#FF0046'}
    if default then
        insertColors(identifier, Config.default)
        print("Colors in default")
    else
        insertColors(identifier, colors)
        print("Found colors")
    end
end)

-- Function
function insertColors(identifier, colors)
    players[identifier] = colors
    SaveResourceFile(name, file, json.encode(players), -1)
end

-- Handler
AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        players = json.decode(loadFile) or {}
    end
end)