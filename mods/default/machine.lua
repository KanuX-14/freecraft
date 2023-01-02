-- default/machine.lua

-- Support for game translation
local S = default.get_translator

-- Register dryer node
local function register_dryer(nodetype)
    local name = ""
    local drop = ""
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
        drop = name
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
                         drop = drop, sounds = sounds, on_construct = on_construct,
                         on_timer = on_timer, recipe = recipe }
    local c_parameters = { output = name, recipe = recipe }
    local f_parameters = { type = "fuel", recipe = name, burntime = 4 }
    engine.register_node(name, parameters)
    engine.register_craft(c_parameters)
    engine.register_craft(f_parameters)
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