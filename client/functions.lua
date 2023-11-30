function callLawyer()
    exports["lb-phone"]:SendCompanyMessage('Advokat', 'Jeg skal bruge en advokat, ved kontoret', false)
end

function CreateCase()
    local input = lib.inputDialog('Opret ny sag ', {
        {type = 'number', icon = 'hashtag', label = 'Sags ID', description = 'Angiv et sags id', placeholder = 'Giv sagen en unikt id', min = 1, max = 100, required = true},
        {type = 'input',icon = 'file-signature', label = 'Klient navn', placeholder = 'Skriv klientens fulde navn', description = 'Navnet på klienten', required = true},
        {type = 'textarea', icon = 'comment', label = 'Beskrivelse', placeholder = 'Giv en beskrivelse på max 250 tegn', min = 1, max = 30, description = 'Lav en kort beskrivelse af sagen', required = true},
        {type = 'checkbox', icon = 'signature', label = 'Underskriv', required = true},
        {type = 'date', label = 'Angiv dato', icon = 'calendar-days', format = 'DD/MM/YYYY', default = true, disabled = true, returnString = true},
    })

    TriggerServerEvent('th-advokat:CreateCase', input[1], input[2], input[3], input[4], input[5])
end

function GetCases()
    ESX.TriggerServerCallback('th-advokat:getcases', function(data)
        options = {}
        for _,v in pairs(data) do
            print(v.dato)
            table.insert(options, {
                title = 'SagsID: ' ..v.id .. '',
                description = "FULDE NAVN: \n" .. v.clientname .. '\n\n BESKRIVELSE: \n' .. v.beskrivelse .. '\n\n ADVOKAT: \n' .. v.underskrift .. '\n\n DATO: \n' .. v.dato .. '\n\n Tryk for at ændre sagens indhold',
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