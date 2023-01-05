-- default/energy.lua

-- Support for game translation
local S = default.get_translator

-- Register cable node
local function register_cable(nodetype)
    local name = ""
    local description = ""
    local tiles = {}
    local recipe = {}
    local paramtype = "light"
    local drawtype = "nodebox"
	local node_box = { type = "connected",
		               fixed = {-0.1, -0.1, -0.1, 0.1, 0.1, 0.1},
                       connect_top = {-0.075, -0.075, -0.075, 0.075, 0.5, 0.075 },
                       connect_bottom = {-0.075, -0.5, -0.075, 0.075, 0.075, 0.075 },
                       connect_front = {-0.075, -0.075, -0.5, 0.075, 0.075, 0.075 },
                       connect_left = {-0.5, -0.075, -0.075, 0.075, 0.075, 0.075 },
                       connect_back = {-0.075, -0.075, -0.075, 0.075, 0.075, 0.5 },
                       connect_right = {-0.075, -0.075, -0.075, 0.5, 0.075, 0.075 }
	                 }
	local collision_box = { type = "connected",
                            fixed = {-0.1, -0.1, -0.1, 0.1, 0.1, 0.1},
                            connect_top = {-0.075, -0.075, -0.075, 0.075, 0.5, 0.075 },
                            connect_bottom = {-0.075, -0.5, -0.075, 0.075, 0.075, 0.075 },
                            connect_front = {-0.075, -0.075, -0.5, 0.075, 0.075, 0.075 },
                            connect_left = {-0.5, -0.075, -0.075, 0.075, 0.075, 0.075 },
                            connect_back = {-0.075, -0.075, -0.075, 0.075, 0.075, 0.5 },
                            connect_right = {-0.075, -0.075, -0.075, 0.5, 0.075, 0.075 }
	                      }
    local connects_to = {"group:energy"}
    local sunlight_propagates = true
    local is_ground_content = false
    local groups = {energy = 1, cable = 1, cracky = 2, oddly_breakable_by_hand = 3}
    local sounds = default.node_sound_metal_defaults()
    local on_construct = function(pos)
                                  local timer = engine.get_node_timer(pos)
                                  timer:start(1)
    end
    local on_timer = function(pos, elapsed)
                              default.on_node_step(pos, elapsed, "cable", 1)
    end
    if (nodetype ~= nil) then
        local l_nodetype = string.lower(nodetype)
        name = "default:" .. l_nodetype .. "_" .. "cable"
        description = nodetype .. " Cable"
        tiles = { "default" .. "_" .. l_nodetype .. "_" .. "block.png" }
        local recipe_name = "default:" .. l_nodetype .. "_" .. "ingot"
        local x = recipe_name
        recipe = { {x, x, x}, }
    end
    local parameters = { description = description, tiles = tiles, paramtype = paramtype,
                         drawtype = drawtype, node_box = node_box, collision_box = collision_box,
                         groups = groups, sounds = sounds, connects_to = connects_to,
                         sunlight_propagates = sunlight_propagates, is_ground_content = is_ground_content,
                         on_construct = on_construct, on_timer = on_timer, recipe = recipe }
    local c_parameters = { output = name .. " 48", recipe = recipe }
    engine.register_node(name, parameters)
    engine.register_craft(c_parameters)
end

-- Register battery node
local function register_battery(nodetype)
    local name = ""
    local description = ""
    local tiles = {}
    local recipe = {}
    local groups = {energy = 1, battery = 1, choppy = 2, oddly_breakable_by_hand = 2}
    local sounds = default.node_sound_wood_defaults()
    local on_construct = function(pos)
                                  local timer = engine.get_node_timer(pos)
                                  timer:start(1)
    end
    local on_timer = function(pos, elapsed)
                              default.on_node_step(pos, elapsed, "battery", 1)
    end
    local on_place = engine.rotate_node
    local paramtype2 = "facedir"
    if (nodetype ~= nil) then
        local l_nodetype = string.lower(nodetype)
        name = "default:" .. l_nodetype .. "_" .. "battery"
        description = nodetype .. " Battery"
        tiles = { l_nodetype .. "_" .. "battery_top.png", l_nodetype .. "_" .. "battery_side.png", l_nodetype .. "_" .. "battery_side.png",
                  l_nodetype .. "_" .. "battery_side.png", l_nodetype .. "_" .. "battery_front.png", l_nodetype .. "_" .. "battery_back.png" }
        local recipe_name = "default:" .. l_nodetype .. "_" .. "wood"
        local x = recipe_name
        local i = "default:iron_ingot"
        local e = "default:mese_crystal"
        recipe = { {x, i, x},
                   {x, e, x},
                {   x, i, x}, }
    else
        name = "default:battery"
        description = "Battery"
        tiles = { "battery_top.png", "battery_side.png", "battery_side.png",
                  "battery_side.png", "battery_front.png", "battery_back.png"}
        local recipe_name = "default:wood"
        local x = recipe_name
        local i = "default:iron_ingot"
        local e = "default:mese_crystal"
        recipe = { {x, i, x},
                   {x, e, x},
                   {x, i, x}, }
    end
    local parameters = { description = description, tiles = tiles, groups = groups,
                         sounds = sounds, on_construct = on_construct, on_timer = on_timer,
                         on_place = on_place, recipe = recipe, paramtype2 = paramtype2 }
    local c_parameters = { output = name, recipe = recipe }
    engine.register_node(name, parameters)
    engine.register_craft(c_parameters)
end

-- Register diode node
local function register_diode(nodetype)
    local name = ""
    local description = ""
    local tiles = {}
    local recipe = {}
    local groups = {energy = 1, diode = 1, oddly_breakable_by_hand = 3}
    local sounds = default.node_sound_defaults()
    local on_construct = function(pos)
                                  local timer = engine.get_node_timer(pos)
                                  timer:start(1)
    end
    local on_timer = function(pos, elapsed)
                              default.on_node_step(pos, elapsed, "diode", 1)
    end
    local on_place = engine.rotate_node
    local paramtype2 = "facedir"
    name = "default:diode"
    description = "Diode"
    tiles = { "diode_top.png", "diode_bottom.png", "diode_side.png",
              "diode_side_inverted.png", "diode_front.png", "diode_back.png" }
    local x = "wool:black"
    local i = "default:iron_ingot"
    local s = "default:steel_ingot"
    local c = "default:coal_lump"
    recipe = { {x, s, x},
               {x, c, x},
               {x, i, x}, }
    local parameters = { description = description, tiles = tiles, groups = groups,
                         sounds = sounds, on_construct = on_construct, on_timer = on_timer,
                         on_place = on_place, recipe = recipe, paramtype2 = paramtype2 }
    local c_parameters = { output = name, recipe = recipe }
    engine.register_node(name, parameters)
    engine.register_craft(c_parameters)
end

-- Register coil node
local function register_coil(nodetype)
    local name = ""
    local description = ""
    local tiles = {}
    local recipe = {}
    local groups = {energy = 1, coil = 1, cracky = 2, oddly_breakable_by_hand = 1}
    local sounds = default.node_sound_metal_defaults()
    local on_construct = function(pos)
                                  local timer = engine.get_node_timer(pos)
                                  timer:start(1)
    end
    local on_timer = function(pos, elapsed)
                              default.on_node_step(pos, elapsed, "coil", 1)
    end
    local on_place = engine.rotate_node
    local paramtype2 = "facedir"
    name = "default:coil"
    description = "Coil"
    tiles = { "coil_plate.png", "coil_plate.png", "coil_plate.png",
              "coil_plate.png", "coil_gear.png", "coil_gear.png" }
    local x = "default:iron_ingot"
    local c = "default:copper_ingot"
    recipe = { {x, x, x},
               {x, c, x},
               {x, x, x}, }
    local parameters = { description = description, tiles = tiles, groups = groups,
                         sounds = sounds, on_construct = on_construct, on_timer = on_timer,
                         on_place = on_place, recipe = recipe, paramtype2 = paramtype2 }
    local c_parameters = { output = name, recipe = recipe }
    engine.register_node(name, parameters)
    engine.register_craft(c_parameters)
end

--
-- Register energy nodes
--

-- Cables
register_cable("Tin")
register_cable("Iron")
register_cable("Copper")
register_cable("Gold")
register_cable("Diamond")

-- Batteries
register_battery()
register_battery("Acacia")
register_battery("Aspen")
register_battery("Jungle")
register_battery("Pine")

-- Diode
register_diode()

-- Coil
register_coil()