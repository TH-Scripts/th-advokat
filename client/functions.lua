function callLawyer()
    exports["lb-phone"]:SendCompanyMessage('Advokat', 'Jeg skal bruge en advokat, ved kontoret', false)
end

function CreateCase()
    local input = lib.inputDialog('Opret ny sag', {
        {type = 'number', label = 'Sags ID', description = 'Angiv et sags id', min = 1, max = 100, required = true},
        {type = 'input', label = 'Klient navn', description = 'Navnet på klienten', required = true},
        {type = 'textarea', label = 'Beskrivelse', description = 'Lav en kort beskrivelse af sagen', required = true},
        {type = 'checkbox', label = 'Underskriv', required = true},
    })

    print(input[3])

    TriggerServerEvent('th-advokat:CreateCase', input[1], input[2], input[3], input[4])
end