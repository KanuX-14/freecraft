-- default/machine.lua

-- Support for game translation
local S = default.get_translator

-- Register dryer node
local function register_dryer(nodetype)
    local name = ""
    local description = ""
    local tiles = {}
    local groups = {dryer = 1, choppy = 2, oddly_breakable_by_hand = 2}
    local sounds = default.node_sound_wood_defaults()
    local on_construct = function(pos)
        local timer = engine.get_node_timer(pos)
        timer:start(1)
    end
    local on_timer = function(pos, elapsed)
        default.on_node_step(pos, elapsed, "dryer")
    end
    local recipe = {}
    local r_name = ""
    local burntime = 4

    if (nodetype ~= nil) then
        local l_nodetype = string.lower(nodetype)
        name = "default:" .. l_nodetype .. "_" .. "dryer"
        description = nodetype .. " Dryer"
        tiles = {
            l_nodetype .. "_" .. "dryer_top.png",
            l_nodetype .. "_" .. "dryer_bottom.png",
            l_nodetype .. "_" .. "dryer_side.png"
        }
        r_name = "default:" .. l_nodetype .. "_" .. "wood"
        recipe = {
            {r_name, "", r_name},
            {r_name, "", r_name},
            {r_name, r_name, r_name},
        }
    else
        name = "default:dryer"
        description = "Dryer"
        tiles = {
            "dryer_top.png",
            "dryer_bottom.png",
            "dryer_side.png"
        }
        r_name = "default:wood"
        recipe = {
            {r_name, "", r_name},
            {r_name, "", r_name},
            {r_name, r_name, r_name},
        }
    end

    local parameters = {
        description = description,
        tiles = tiles,
        groups = groups,
        sounds = sounds,
        on_construct = on_construct,
        on_timer = on_timer
    }
    
    local craft = {
        output = name,
        recipe = recipe
    }
    
    local fuel = {
        type = "fuel",
        recipe = name,
        burntime = burntime
    }

    engine.register_node(name, parameters)
    engine.register_craft(craft)
    engine.register_craft(fuel)
end

--
-- Register machines
--

register_dryer()
register_dryer("Acacia")
register_dryer("Aspen")
register_dryer("Jungle")
register_dryer("Pine")