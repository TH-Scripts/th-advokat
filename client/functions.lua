function callLawyer()
    exports["lb-phone"]:SendCompanyMessage('Advokat', 'Jeg skal bruge en advokat, ved kontoret', false)
end

function CreateCase()
    local input = lib.inputDialog('Opret ny sag', {
        {type = 'number', label = 'Sags ID', description = 'Angiv et sags id', min = 1, max = 100, required = true},
        {type = 'input', label = 'Klient navn', description = 'Navnet på klienten', required = true},
        {type = 'textarea', label = 'Beskrivelse', description = 'Lav en kort beskrivelse af sagen', required = true},
        {type = 'checkbox', label = 'Underskriv', required = true},
        {type = 'date', label = 'Angiv dato', format = 'DD/MM/YYYY', default = true, disabled = true, returnString = true},
    })

    print(input[5])

    

    TriggerServerEvent('th-advokat:CreateCase', input[1], input[2], input[3], input[4], input[5])
end

function GetCases()
    ESX.TriggerServerCallback('th-advokat:getcases', function(data)
        options = {}
        for _,v in pairs(data) do
            print(v.dato)
            table.insert(options, {
                title = 'SagsID: ' ..v.id .. '',
                description = 'Klient: ' .. v.clientname .. ' beskrivelse: ' .. v.beskrivelse .. ' underskrift: ' .. v.underskrift .. ' Dato: ' .. v.dato .. '',
                onSelect = function()
                    deletecase(v.id)
                end
            })
        end

        lib.registerContext({
            id = 'sager',
            title = 'Advokat Sager',
            options = options,
        })

        lib.showContext('sager')
    end)
end

function deletecase(id)
    local alert = lib.alertDialog({
        header = 'Slet sag',
        content = 'Ønsker du at slette sagen med id`et ' .. id .. '? Dette kan ikke laves om !',
        centered = true,
        cancel = true,
    })

    if alert == 'confirm' then
        lib.notify({
            title = 'Success',
            description = 'Du slettede sagen med id`et ' .. id .. '',
            type = 'inform'
        })
    else
        lib.notify({
            title = 'Annulleret',
            description = 'Du annullerede sletning af sagen',
            type = 'warning',
        })
    end
end