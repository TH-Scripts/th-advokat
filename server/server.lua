ESX = exports["es_extended"]:getSharedObject()
TriggerEvent('esx_society:registerSociety', 'lawyer', 'lawyer', 'society_lawyer', 'society_lawyer', 'society_lawyer', {type = 'public'})

ESX.RegisterServerCallback('th-advokat:getOnlinePlayers', function(source, cb, closePlayer)
	local xPlayer = ESX.GetPlayerFromId(closePlayer)
	local players = {}

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
        else
            table.insert(players, {
                source = xPlayer.source,
                identifier = xPlayer.identifier,
                name = xPlayer.name,
                firstname = xPlayer.get('firstName'),
                lastname = xPlayer.get('lastName'),
            })
        end
    end
	cb(players)
end)


RegisterNetEvent('th-advokat:changeName', function(firstName, lastName, playerId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(playerId) 
    local navn = xPlayer.getName()

    MySQL.Async.execute('UPDATE users SET `firstname` = @firstname WHERE identifier = @identifier', {
		['@firstname'] = firstName,
		['@identifier'] = xPlayer.identifier
	})

    MySQL.Async.execute('UPDATE users SET `lastname` = @lastname WHERE identifier = @identifier', {
		['@lastname'] = lastName,
		['@identifier'] = xPlayer.identifier
	})

    TriggerClientEvent('ox_lib:notify', src, ({
        id = 'namechange_true',
        title = 'Navneskift',
        description = 'Du har ændret navnet til: '..firstName.. ' '..lastName..'',
        position = 'top',
        style = {
            backgroundColor = '#141517',
            color = '#C1C2C5',
            ['.description'] = {
              color = '#909296'
            }
        },
        icon = 'thumbs-up',
        iconColor = '#35fc17'
    }))


end)


ESX.RegisterServerCallback('th-advokat:getVehicles', function(source, cb, myArgument)
    local xPlayer = ESX.GetPlayerFromId(myArgument)

    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner', {
        ['@owner'] = xPlayer.identifier
    }, function(result)
        cb(result)
    end)
end)




RegisterNetEvent('th-advokat:EditCase', function(desc, id)
    local xPlayer = ESX.GetPlayerFromId(source)
    print(desc)

    MySQL.update.await('UPDATE advokat_sager SET beskrivelse = ? WHERE id = ?', {
        desc, id
    })

    MySQL.update.await('UPDATE advokat_sager SET underskrift = ? WHERE id = ?', {
        xPlayer.getName(), id
    })
end)

RegisterNetEvent('th-advokat:CreateCase', function(id, desc, name, check, date)
    local xPlayer = ESX.GetPlayerFromId(source)

    local name2 = xPlayer.getName()

    MySQL.insert.await('INSERT INTO `advokat_sager` (id, clientname, beskrivelse, underskrift, dato) VALUES (?, ?, ?, ?, ?)', {
        id, desc, name, name2, date
    })
end)

RegisterNetEvent('th-advokat:removeCase', function(sagId)
    local id = sagId

    MySQL.Async.execute('DELETE FROM advokat_sager WHERE id = @id', {
        ['@id'] = id,
    })
end)

ESX.RegisterServerCallback('th-advokat:getcases', function(src, cb) 
    local table = MySQL.Sync.fetchAll('SELECT id, clientname, beskrivelse, dato, underskrift FROM advokat_sager')
    cb(table)
end)