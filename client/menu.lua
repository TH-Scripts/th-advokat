lib.registerContext({
    id = 'advokat_menu',
    title = 'Advokat Menu',
    options = {
      {
        title = 'Navnskifte',
        description = "Skift en borger's navn vha. denne handling",
        icon = 'pen-to-square',
        iconColor = '#2997cf',
        onSelect = function()
          getPlayers()
        end
      },
      {
        title = 'Køretøjer',
        description = 'Se handlinger vedr. køretøjer for borgere',
        icon = 'car-side',
        iconColor = '#870c1d',
        onSelect = function()
            print('en menu som viser folks køretøjer, og gør det muligt at fjerne dem.')
        end
      },
    }
})