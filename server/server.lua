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

RegisterNetEvent('th-advokat:changeName', function(firstName, lastName, playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)  -- Assuming you're using ESX framework
    local navn = xPlayer.getName()

end)


RegisterNetEvent('th-advokat:EditCase', function(desc, id)
    local xPlayer = ESX.GetPlayerFromId(source)
    print(desc)

    MySQL.update.await('UPDATE advokat_sager SET beskrivelse = ? WHERE id = ?', {
        desc, id
    })

    MySQL.update.await('UPDATE advokat_sager SET underskrift = ? WHERE id = ?', {
        ESX.getName(), id
    })
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