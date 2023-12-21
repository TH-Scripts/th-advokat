CreateThread(function()
	local blip = AddBlipForCoord(Config.JobTarget) -- ændrer disse koordinater

	SetBlipSprite(blip, 351)
	SetBlipDisplay(blip, 4)
	SetBlipColour(blip, 5)
	SetBlipScale(blip, 1.0)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName('Advokat')
	EndTextCommandSetBlipName(blip)
end)
