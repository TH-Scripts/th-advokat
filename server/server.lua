ESX = exports["es_extended"]:getSharedObject()
TriggerEvent('esx_society:registerSociety', 'lawyer', 'lawyer', 'society_lawyer', 'society_lawyer', 'society_lawyer', { type = 'public' })

ESX.RegisterServerCallback('th-advokat:getPlayers', function(source, cb, closestPlayers)
    local players = {}

    for _, id in ipairs(closestPlayers) do
        local xPlayer = ESX.GetPlayerFromId(id)
        if xPlayer then
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
    end

    cb(players)
end)

ESX.RegisterServerCallback('th-advokat:changeName', function(src, cb, firstName, lastName, playerId)
    local xPlayer = ESX.GetPlayerFromId(src)

    if not HasAccessToJob(src) then
        return
    end

    local tPlayer = ESX.GetPlayerFromId(playerId)

    if not tPlayer then
        return cb({
            error = 'Kunne ikke finde spilleren'
        })
    end

    if #(xPlayer.getCoords(true) - tPlayer.getCoords(true)) > 3.0 then
        return cb({
            error = 'Spilleren er for langt væk'
        })
    end

    local didUserUpdate = MySQL.update.await('UPDATE users SET firstname = ?, lastname = ? WHERE identifier = ?', {
        firstName, lastName, tPlayer.identifier
    })

    if didUserUpdate == 0 then
        return cb({
            error = 'Kunne ikke finde spilleren'
        })
    end

    tPlayer.set('firstName', firstName)
    tPlayer.set('lastName', lastName)

    cb({
        success = 'Du har ændret navnet på ' .. tPlayer.getName() .. ' til ' .. firstName .. ' ' .. lastName .. ''
    })

    TriggerClientEvent('ox_lib:notify', playerId, ({
        id = 'namechange_true',
        title = 'Navneskift',
        description = 'Dit navn er blevet ændret til: ' .. firstName .. ' ' .. lastName .. '',
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

ESX.RegisterServerCallback('th-advokat:getVehicles', function(source, cb, playerId)
    if not HasAccessToJob(source) then
        return
    end

    local tPlayer = ESX.GetPlayerFromId(playerId)

    if not tPlayer then
        return
    end

    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner', {
        ['@owner'] = tPlayer.identifier
    }, function(result)
        cb(result)
    end)
end)

ESX.RegisterServerCallback("th-advokat:editCase", function(src, cb, desc, id)
    local xPlayer = ESX.GetPlayerFromId(src)

    if not HasAccessToJob(src) then
        return cb({ error = 'Du har ikke adgang til denne handling' })
    end

    MySQL.update.await('UPDATE advokat_sager SET beskrivelse = ? WHERE id = ?', {
        desc, id
    })
    MySQL.update.await('UPDATE advokat_sager SET underskrift = ? WHERE id = ?', {
        xPlayer.getName(), id
    })

    cb({ success = 'Du har opdateret sagen' })
end)

ESX.RegisterServerCallback('th-advokat:createCase', function(src, cb, id, desc, name, check, date)
    local xPlayer = ESX.GetPlayerFromId(src)

    if HasAccessToJob(source) then
        return cb({ error = 'Du har ikke adgang til denne handling' })
    end

    local caseFound = MySQL.single.await('SELECT `id` FROM `advokat_sager` WHERE `id` = ? LIMIT 1', {
        id
    })

    if caseFound then
        return cb({ error = 'Denne sag eksistere allerede' })
    end

    local name2 = xPlayer.getName()
    MySQL.insert.await('INSERT INTO `advokat_sager` (id, clientname, beskrivelse, underskrift, dato) VALUES (?, ?, ?, ?, ?)', {
        id, desc, name, name2, date
    })

    cb({ success = 'Du har oprettet sagen' })
end)

RegisterNetEvent('th-advokat:removeCase', function(caseId)
    if not HasAccessToJob(source) then
        return
    end

    MySQL.Async.execute('DELETE FROM advokat_sager WHERE id = @id', {
        ['@id'] = caseId,
    })

    TriggerClientEvent('ox_lib:notify', source, ({
        id = 'case_removed',
        title = 'Sag fjernet',
        description = 'Du har fjernet en sag',
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

ESX.RegisterServerCallback('th-advokat:getCases', function(src, cb)
    if not HasAccessToJob(src) then
        return
    end

    local table = MySQL.Sync.fetchAll('SELECT id, clientname, beskrivelse, dato, underskrift FROM advokat_sager')
    cb(table)
end)

-- Function to check if player has access to the job
function HasAccessToJob(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if not xPlayer then
        return false
    end

    if xPlayer.job.name == Config.AdvokatJob then
        return true
    end

    -- Probably a cheater, perfect place for a ban/log, but I'll leave that up to you
    -- DropPlayer(playerId, 'Cheating')
    print(('th-advokat: %s attempted to trigger an action!'):format(xPlayer.identifier))

    return false
end
