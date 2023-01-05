-- default/machine.lua

-- Support for game translation
local S = default.get_translator

-- Register dryer node
local function register_dryer(nodetype)
    local name = ""
    local description = ""
    local tiles = {}
    local recipe = {}
    local groups = {dryer = 1, choppy = 2, oddly_breakable_by_hand = 2}
    local sounds = default.node_sound_wood_defaults()
    local on_construct = function(pos)
                                  local timer = engine.get_node_timer(pos)
                                  timer:start(1)
    end
    local on_timer = function(pos, elapsed)
                              default.on_node_step(pos, elapsed, "dryer", 1)
    end
    if (nodetype ~= nil) then
        local l_nodetype = string.lower(nodetype)
        name = "default:" .. l_nodetype .. "_" .. "dryer"
        description = nodetype .. " Dryer"
        tiles = { l_nodetype .. "_" .. "dryer_top.png",
                  l_nodetype .. "_" .. "dryer_bottom.png",
                  l_nodetype .. "_" .. "dryer_side.png" }
        local recipe_name = "default:" .. l_nodetype .. "_" .. "wood"
        local x = recipe_name
        recipe = { {x, "", x},
                   {x, "", x},
                   {x, x, x}, }
    else
        name = "default:dryer"
        description = "Dryer"
        tiles = { "dryer_top.png",
                  "dryer_bottom.png",
                  "dryer_side.png" }
        local recipe_name = "default:wood"
        local x = recipe_name
        recipe = { {x, "", x},
                   {x, "", x},
                   {x, x, x}, }
    end
    local parameters = { description = description, tiles = tiles, groups = groups,
                         sounds = sounds, on_construct = on_construct, on_timer = on_timer,
                         recipe = recipe }
    local c_parameters = { output = name, recipe = recipe }
    local f_parameters = { type = "fuel", recipe = name, burntime = 4 }
    engine.register_node(name, parameters)
    engine.register_craft(c_parameters)
    engine.register_craft(f_parameters)
end

-- Register watermill node
local function register_watermill(nodetype)
    local name = ""
    local description = ""
    local tiles = {}
    local recipe = {}
    local groups = {energy = 1, watermill = 1, choppy = 2, oddly_breakable_by_hand = 2}
    local sounds = default.node_sound_wood_defaults()
    local on_construct = function(pos)
                                  local timer = engine.get_node_timer(pos)
                                  timer:start(1)
    end
    local on_timer = function(pos, elapsed)
                              default.on_node_step(pos, elapsed, "watermill", 1)
    end
    local on_place = engine.rotate_node
    local paramtype2 = "facedir"
    if (nodetype ~= nil) then
        local l_nodetype = string.lower(nodetype)
        name = "default:" .. l_nodetype .. "_" .. "watermill"
        description = nodetype .. " Watermill"
        tiles = { l_nodetype .. "_" .. "watermill_horizontal_gear.png", l_nodetype .. "_" .. "watermill_horizontal_gear.png", l_nodetype .. "_" .. "watermill_vertical_gear.png",
                  l_nodetype .. "_" .. "watermill_vertical_gear.png", l_nodetype .. "_" .. "watermill_front.png", l_nodetype .. "_" .. "watermill_back.png" }
        local recipe_name = "default:" .. l_nodetype .. "_" .. "wood"
        local x = recipe_name
        local i = "default:iron_ingot"
        recipe = { {x, x, x},
                   {x, i, x},
                {   x, x, x}, }
    else
        name = "default:watermill"
        description = "Watermill"
        tiles = { "watermill_horizontal_gear.png", "watermill_horizontal_gear.png", "watermill_vertical_gear.png",
                  "watermill_vertical_gear.png", "watermill_front.png", "watermill_back.png"}
        local recipe_name = "default:wood"
        local x = recipe_name
        local i = "default:iron_ingot"
        recipe = { {x, x, x},
                   {x, i, x},
                   {x, x, x}, }
    end
    local parameters = { description = description, tiles = tiles, groups = groups,
                         sounds = sounds, on_construct = on_construct, on_timer = on_timer,
                         on_place = on_place, recipe = recipe, paramtype2 = paramtype2 }
    local c_parameters = { output = name, recipe = recipe }
    engine.register_node(name, parameters)
    engine.register_craft(c_parameters)
end

--
-- Register machines
--

-- Dryers
register_dryer()
register_dryer("Acacia")
register_dryer("Aspen")
register_dryer("Jungle")
register_dryer("Pine")

-- Watermills
register_watermill()
register_watermill("Acacia")
register_watermill("Aspen")
register_watermill("Jungle")
register_watermill("Pine")