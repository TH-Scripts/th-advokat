ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback('th-advokat:getOnlinePlayers', function(source, cb)
	local xPlayers = ESX.GetPlayers()
	local players = {}

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.get('firstName') then
            if Config.LBPhone then
                table.insert(players, {
                    source = xPlayer.source,
                    identifier = xPlayer.identifier,
                    name = xPlayer.name,
                    firstname = xPlayer.get('firstName'),
                    lastname = xPlayer.get('lastName'),
                    phoneNumber = exports["lb-phone"]:GetEquippedPhoneNumber(source)
                })
            end
        end
	end
	cb(players)
end)

RegisterNetEvent('th-advokat:getVehicle', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(_source)

    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner', {
        ['@owner'] = xPlayer.identifier
    }, function(result)
        TriggerClientEvent('')
    end)
end)

ESX.RegisterServerCallback('th-advokat:getVehicles', function(source, cb, _source)
    local xPlayer = ESX.GetPlayerFromId(_source)

    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner', {
        ['@owner'] = xPlayer.identifier
    }, function(result)
        cb(result)
    end)
end)

RegisterNetEvent('th-advokat:EditCase', function(desc, id)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.execute('UPDATE advokat_sager SET `beskrivelse` = @desc WHERE id = @id', {
        ['@desc'] = desc
    })

    MySQL.Async.execute('UPDATE advokat_sager SET `underskrift` = @underskrift WHERE id = @id', {
        ['@underskrift'] = xPlayer.getName()
    })
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

RegisterNetEvent('th-advokat:CreateCase', function(id, desc, name, check, date)
    local xPlayer = ESX.GetPlayerFromId(source)

    local name2 = xPlayer.getName()

    MySQL.insert.await('INSERT INTO `advokat_sager` (id, clientname, beskrivelse, underskrift, dato) VALUES (?, ?, ?, ?, ?)', {
        id, desc, name, name2, date
    })
end)

ESX.RegisterServerCallback('th-advokat:getcases', function(src, cb) 
    local table = MySQL.Sync.fetchAll('SELECT id, clientname, beskrivelse, dato, underskrift FROM advokat_sager')
    cb(table)
end)