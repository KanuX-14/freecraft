-- entity_api/init.lua

-- Global entity API namespaces
entity_api = {}
entity_api.path = engine.get_modpath("entity_api")
entity_api.translation = engine.get_translator("entity_api")
entity_api.railparams = {}
entity_api.speed_max = 7
entity_api.punch_speed_max = 5
entity_api.path_distance_max = 3

-- Load files
dofile(entity_api.path.."/api.lua")
dofile(entity_api.path.."/boat.lua")
dofile(entity_api.path.."/cart.lua")
dofile(entity_api.path.."/rails.lua")

-- Register rails as dungeon loot
if engine.global_exists("dungeon_loot") then
  dungeon_loot.register({
    name = "entity_api:rail", chance = 0.35, count = {1, 6}
  })
end
