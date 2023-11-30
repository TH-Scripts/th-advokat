lib.registerContext({
    id = 'advokat_menu',
    title = 'Advokat Menu',
    options = {
      {
        title = 'Navnskifte',
        description = "Skift en borger's navn vha. denne handling",
        icon = 'pen-to-square',
        onSelect = function()
          getPlayers()
        end
      },
      {
        title = 'Køretøjer',
        description = 'Se handlinger vedr. køretøjer for borgere',
        icon = 'car-side',
        onSelect = function()
          inputVehiclePlayerID()
        end
      },
      {
        title = 'Advokat sager',
        description = 'Se/opret advokat sager',
        icon = 'folder',
        menu = 'advokat_sager'
      }
    }
})

lib.registerContext({
  id = 'advokat_sager',
  title = 'Advokat Menu',
  menu = 'advokat_menu',
  onBack = function()
  end,
  options = {
    {
      title = 'Opret sag',
      description = 'Opret en advokat sag',
      icon = 'folder',
      onSelect = function()
        CreateCase()
      end
    },
    {
      title = 'Alle sager',
      description = 'Se en database over alle gemte sager',
      icon = 'database',
      onSelect = function()
        GetCases()
      end
    }
  }
})



