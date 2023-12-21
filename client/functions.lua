function CallLawyer()
    exports["lb-phone"]:SendCompanyMessage('Advokat', 'Jeg skal bruge en advokat, ved kontoret', false)
end

function CreateCase()
    local input = lib.inputDialog('Opret ny sag ', {
        { type = 'number',   icon = 'hashtag',        label = 'Sags ID',      description = 'Angiv et sags id',                   placeholder = 'Giv sagen en unikt id', min = 1,         required = true },
        { type = 'input',    icon = 'file-signature', label = 'Klient navn',  placeholder = 'Skriv klientens fulde navn',         description = 'Navnet på klienten',    required = true },
        { type = 'textarea', icon = 'comment',        label = 'Beskrivelse',  placeholder = 'Giv en beskrivelse på max 250 tegn', min = 1,                               max = 30,        description = 'Lav en kort beskrivelse af sagen', required = true },
        { type = 'checkbox', icon = 'signature',      label = 'Underskriv',   required = true },
        { type = 'date',     label = 'Angiv dato',    icon = 'calendar-days', format = 'DD/MM/YYYY',                              default = true,                        disabled = true, returnString = true },
    })

    if input == nil then
        lib.showContext('advokat_sager')
        return
    end

    ESX.TriggerServerCallback('th-advokat:createCase', function(response)
        if response.success then
            lib.notify({
                title = 'Sag oprettet',
                description = response.success,
            })
            GetCases()
        elseif response.error then
            lib.notify({
                title = 'Sag oprettelse',
                description = response.error,
                type = 'error',
            })
            lib.showContext('advokat_sager')
        end
    end, input[1], input[2], input[3], input[4], input[5])
end

function GetCases()
    ESX.TriggerServerCallback('th-advokat:getCases', function(data)
        local options = {}

        for _, v in pairs(data) do
            local caseId = v.id
            table.insert(options, {
                title = 'SagsID: ' .. v.id .. '',
                description = "Fulde navn: \n" .. v.clientname .. '\n\nBeskrivelse: \n' .. v.beskrivelse .. '\n\nAdvokat: \n' .. v.underskrift .. '\n\nDato: \n' .. v.dato .. '\n\nTryk for at ændre sagens indhold',
                onSelect = function()
                    lib.registerContext({
                        id = 'advokatsag_menu',
                        title = 'Advokat Sag',
                        menu = 'sager',
                        onBack = function()
                        end,
                        options = {
                            {
                                title = 'Beskrivelse',
                                description = 'Ændre sagens beskrivelse',
                                icon = 'comment',
                                onSelect = function()
                                    ChangeDescription(caseId)
                                end
                            },
                            {
                                title = 'Fjern',
                                description = 'Fjern denne sag',
                                icon = 'circle-minus',
                                onSelect = function()
                                    DeleteCase(caseId)
                                end
                            }
                        }
                    })
                    lib.showContext('advokatsag_menu')
                end
            })
        end

        lib.registerContext({
            id = 'sager',
            title = 'Advokat Sager',
            menu = 'advokat_sager',
            options = options,
        })

        lib.showContext('sager')
    end)
end

function ChangeDescription(id)
    local input = lib.inputDialog("Ændre sagen med id'et " .. id .. "", {
        { type = 'textarea', label = 'Opdateret tekst', required = true },
    })

    if input == nil then
        lib.showContext('advokatsag_menu')
        return
    end

    TriggerServerEvent('th-advokat:editCase', input[1], id)

    ESX.TriggerServerCallback("th-advokat:editCase", function(response)
        if response.success then
            lib.notify({
                title = 'Sag opdateret',
                description = response.success,
            })
        elseif response.error then
            lib.notify({
                title = 'Sag opdatering',
                description = response.error,
            })
        end
        GetCases()
    end, input[1], id)
end

function DeleteCase(id)
    local input = lib.inputDialog("Vil du slette sagen med id'et " .. id .. "?", {
        { type = 'checkbox', label = 'Bekræft', required = true },
    })

    if input == nil then
        lib.showContext('advokatsag_menu')
        return
    end

    TriggerServerEvent('th-advokat:removeCase', id)
end

function GiveBill(playerId)
    local input = lib.inputDialog('Giv en faktura', {
        { type = 'number', label = 'Pris', description = 'Angiv størrelsen på fakturaen', required = true },
    })

    if input == nil then
        return
    end

    TriggerServerEvent('esx_billing:sendBill', playerId, Config.AdvokatJob, 'Advokat Transaktion', input[1])
end
