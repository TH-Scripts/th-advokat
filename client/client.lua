ESX = exports["es_extended"]:getSharedObject()

exports.ox_target:addSphereZone({
    coords = Config.target,
    radius = 1,
    debug = drawZones,
    options = {
        {
            icon = 'fa-solid fa-gavel',
            label = 'Åben advokat menu',
            --groups = Config.AdvokatJob,
            onSelect = function()
                lib.showContext('advokat_menu')
            end
        },
    }
})


function getPlayers()
    ESX.TriggerServerCallback('huh_advokat:getOnlinePlayers', function(players)
        local elements = {}

        for i=1, #players, 1 do
            if players[i].name ~= GetPlayerName(PlayerId()) then
                table.insert(elements, {
                    title = 'Borger id: '..players[i].source,
                    description = 'Fornavn: '..players[i].firstname.. '\n Efternavn '.. players[i].lastname.. "\n Telefonnummer: \n Tryk for at ændre personen's navn",
                    icon = 'hashtag',
                    onSelect = function()
                        inputDialog()
                    end
                })
            end
        end

        lib.registerContext({
            id = 'list_players',
            title = 'Borgerliste',
            options = elements
        })

        lib.showContext('list_players')

    end)
end


function inputDialog()

    local alert = lib.alertDialog({
        header = 'Navnskifte',
        content = "Ønsker du fortsat at ændre personen's navn?",
        centered = true,
        cancel = true,
        labels = {
            confirm = 'Ja, ændre navn',
            cancel = 'Fortryd',
        }
    })

    if alert == 'confirm' then
        local input = lib.inputDialog('Navneformular', {
            {type = 'input', label = 'Fornavn', description = "Indskriv personen's nye fornavn", icon = 'pen-to-square', required = true, max = 15},
            {type = 'input', label = 'Efternavn', description = "Indskriv personen's nye efternavn", icon = 'pen-to-square', required = true, max = 15},
        })

        
        local firstName  = input[1]
        local lastName   = input[2]
    
        TriggerServerEvent('huh_advokat:changeName', firstName, lastName)
    else
        lib.notify({
            id = 'fortydelse_navn',
            title = 'Navnskifte',
            description = 'Du har fortrydt, at skifte navnet',
            position = 'right-top',
            style = {
                backgroundColor = '#141517',
                color = '#C1C2C5',
                ['.description'] = {
                  color = '#909296'
                }
            },
            icon = 'circle-xmark',
            iconColor = '#C53030'
        })
    end
end

spawnped = false

Citizen.CreateThread(function()
    while true do
        if spawnped == false then
            spawnped = true
            RequestModel(GetHashKey(Config.PEDModel))
            while not HasModelLoaded(GetHashKey(Config.PEDModel)) do
                Wait(1)
            end
  
            ped1 = CreatePed(4, GetHashKey(Config.PEDModel), Config.PEDSpawn, false, true) -- ændrer disse koordinater
            FreezeEntityPosition(ped1, true)
            SetEntityInvincible(ped1, true)
            SetBlockingOfNonTemporaryEvents(ped1, true)
        end
        Citizen.Wait(10000)
    end
end)