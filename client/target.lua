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

exports.ox_target:addSphereZone({
    coords = Config.FrontTarget,
    radius = 1,
    debug = drawZones,
    options = {
        {
            icon = 'fa-solid fa-gavel',
            label = 'Tilkald En Advokat',
            --groups = Config.AdvokatJob,
            onSelect = function()
                callLawyer()
            end
        },
    }
})