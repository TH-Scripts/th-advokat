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
        options2 = {}
        for _,v in pairs(data) do
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
            menu = 'advokat_sager',
            onBack = function()
    
            end,
            options = options,
        })

        lib.showContext('sager')
    end)
end

function deletecase(id)
    local input = lib.inputDialog("Ændre sagen med id'et ".. id .. "", {
        {type = 'textarea', label = 'Opdateret tekst', required = true},
    })

    TriggerServerEvent('th-advokat:EditCase', input[1], id)
end