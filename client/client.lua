ESX = exports["es_extended"]:getSharedObject()


function getPlayers()
    ESX.TriggerServerCallback('th-advokat:getOnlinePlayers', function(players)
        local elements = {}

        for i=1, #players, 1 do
            if players[i].name ~= GetPlayerName(PlayerId()) then
                table.insert(elements, {
                    title = 'Borger id: '..players[i].source,
                    description = 'Fornavn: '..players[i].firstname.. '\n Efternavn '.. players[i].lastname.. '\n Telefonnummer: '..players[i].phoneNumber.. "\n Tryk for at ændre personen's navn",
                    icon = 'hashtag',
                    onSelect = function()
                        changesSomKanForetages(players)
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


function changesSomKanForetages(players)
    lib.registerContext({
        id = 'player_foretages',
        title = 'Foretag et valg',
        options = {
          {
            title = 'Skift navn',
            description = 'Tryk her hvis du ønsker at skifte navn på personen',
            icon = 'pen-to-square',
            onSelect = function()
                navnSkiftDialog()
            end
          },
          {
            title = 'Køretøjslist',
            description = 'Tryk her for at få vist køretøjer',
            icon = 'pen-to-square',
            onSelect = function()
                getVehicleMenu()
            end
          }
        }
      })
      lib.showContext('player_foretages')
end

function getVehicleMenu()


    ESX.TriggerServerCallback('th-advokat:getVehicles', function(vehicles) 
       local elements = {}
       
        for i=1, #vehicles, 1 do
            vehicles[i].vehicle = json.decode(vehicles[i].vehicle)
            local hashVehicule = vehicles[i].vehicle.model
            local aheadVehName = GetDisplayNameFromVehicleModel(hashVehicule)
            local vehicleName = GetLabelText(aheadVehName)
            if vehicles[i].parked == "1" then
                table.insert(elements, {
                    title = vehicleName..' - '..vehicles[i].plate,
                    description = vehicles[i]
                })
            else
                table.insert(elements, {
                    title = vehicleName..' - '..vehicles[i].plate,
                    description = vehicles[i]
                })
            end
        end

        lib.registerContext({
            id = 'list_vehicles',
            title = 'Køretøjsliste',
            options = elements
        })

        lib.showContext('list_vehicles')

    end)
end

function navnSkiftDialog()

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
    
        TriggerServerEvent('th-advokat:changeName', firstName, lastName, _source)
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

function givebill()
    local input = lib.inputDialog('Giv en faktura', {
        {type = 'number', label = 'Pris', description = 'Angiv størrelsen på fakturaen', required = true},
        {type = 'number', label = 'Id', description = 'Angiv IDet på den person du gerne vil sende en faktura til', required = true}
    })

    TriggerServerEvent('esx_billing:sendBill', input[2], '', '', input[1])
end