exports.ox_target:addSphereZone({
    coords = Config.JobTarget,
    radius = 1,
    debug = Config.Debug,
    drawSprite = true,
    options = {
        {
            icon = 'fa-solid fa-gavel',
            label = 'Åben advokat menu',
            groups = Config.AdvokatJob,
            onSelect = function()
                lib.showContext('advokat_menu')
            end
        },
    }
})

if Config.LBPhone then
    exports.ox_target:addSphereZone({
        coords = Config.FrontTarget,
        radius = 1,
        debug = Config.Debug,
        drawSprite = true,
        options = {
            {
                icon = 'fa-solid fa-gavel',
                label = 'Tilkald En Advokat',
                onSelect = function()
                    CallLawyer()
                end
            },
        }
    })
end
