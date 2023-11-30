ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback('th-advokat:getOnlinePlayers', function(source, cb)
	local xPlayers = ESX.GetPlayers()
	local players = {}

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.get('firstName') then
            table.insert(players, {
                source = xPlayer.source,
                identifier = xPlayer.identifier,
                name = xPlayer.name,
                firstname = xPlayer.get('firstName'),
                lastname = xPlayer.get('lastName')
            })
        end
	end
	cb(players)
end)

ESX.RegisterServerCallback('th-advokat:getVehicles', function(source, cb, _source)
    local xPlayer = ESX.GetPlayerFromId(_source)

    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner', {
        ['@owner'] = xPlayer.identifier
    }, function(result)
        cb(result)
    end)
end)


RegisterNetEvent('th-advokat:changeName', function(firstName, lastName)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.execute('UPDATE users SET `firstname` = @firstname WHERE identifier = @identifier', {
		['@firstname'] = firstName,
		['@identifier'] = xPlayer.identifier
	})

    MySQL.Async.execute('UPDATE users SET `lastname` = @lastname WHERE identifier = @identifier', {
		['@lastname'] = lastName,
		['@identifier'] = xPlayer.identifier
	})

    TriggerClientEvent('ox_lib:notify', source, ({
        id = 'navn_gemmenført',
        title = 'Navnskifte',
        description = 'Du har ændret navnet til: '..firstName.. ' '..lastName,
        position = 'right-top',
        style = {
            backgroundColor = '#141517',
            color = '#C1C2C5',
            ['.description'] = {
              color = '#909296'
            }
        },
        icon = 'thumbs-up',
        iconColor = '#0fd12c'
    }))
end)