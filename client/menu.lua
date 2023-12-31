lib.registerContext({
  id = 'advokat_menu',
  title = 'Advokat Menu',
  options = {
    {
      title = 'Liste over borgere',
      description = "Få en liste over borgere i nærheden",
      icon = 'pen-to-square',
      onSelect = function()
        GetPlayers()
      end
    },
    -- {
    --   title = 'Køretøjer',
    --   description = 'Se handlinger vedr. køretøjer for borgere',
    --   icon = 'car-side',
    --   onSelect = function()
    --     inputVehiclePlayerID()
    --   end
    -- },
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
