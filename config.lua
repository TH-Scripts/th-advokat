Config = {}

Config.Debug = false

Config.FrontTarget = vec3(-1570.7935, -574.9966, 108.5228)
Config.JobTarget = vec3(-1556.65, -575.87, 108.53)

Config.PedSpawn = vec4(-1570.7935, -574.9966, 108.5228 - 1, 37.4979)
Config.PedModel = 'a_f_y_femaleagent'

Config.LBPhone = false

Config.AdvokatJob = 'lawyer'
Config.AmountToPay = 5000


Config.Elevators = {
    Advokat = {
        [1] = {
            coords = vec3(-1579.6760, -561.1122, 108.5229),
            heading = 300.8177,
            title = 'Advokat Kontor',
            description = 'Tilgå advokat kontoret',
            target = {
                width = 5,
                length = 4
            }
        },
        [2] = {
            coords = vec3(-1581.3550, -558.2264, 34.9531),
            heading = 199.6223,
            title = 'Udgang',
            description = 'Tilgå udgangen',
            target = {
                width = 5,
                length = 4
            }
        },
    },
}
