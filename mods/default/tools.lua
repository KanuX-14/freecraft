-- mods/default/tools.lua

-- support for MT game translation.
local S = default.get_translator

-- Get 'farming' functions

farming = {}
farming.path = minetest.get_modpath("farming")
dofile(farming.path .. "/api.lua")

-- Handle attributes
local function get_tool_attribute(tool, material, handle)
	local description = ""
	local inventory_image = ""
	local force = 0
	local interval = 0
	local level = 0
	local durability = 0
	local danger = 0
	local scale = {x=1.4,y=1.4,z=1}
	local snappy = {}
	local choppy = {}
	local cracky = {}
	local crumbly = {}

	local tool_description = ""
	local material_name = ""
	local material_description = ""
	local material_force = 0
	local material_interval = 0
	local material_level = 0
	local material_durability = 0
	local material_danger = 0
	local handle_name = ""
	local handle_interval = 0
	local handle_durability = 0

	-- Define Front-End name
	if (tool == "sword") then
		tool_description = " Sword"
	elseif (tool == "pick") then
		tool_description = " Pickaxe"
	elseif (tool == "shovel") then
		tool_description = " Shovel"
	elseif (tool == "axe") then
		tool_description = " Axe"
	elseif (tool == "hoe") then
		tool_description = " Hoe"
	else
		return
	end

	-- Define head material
	if (material == "default:acacia_wood") then
		material_name = "acacia_"
		material_description = "Acacia"
		material_force = 0.9
		material_interval = 0.8
		material_level = 1
		material_durability = 5
		material_danger = 2
	elseif (material == "default:wood") then
		material_name = "apple_"
		material_description = "Apple"
		material_force = 0.9
		material_interval = 0.8
		material_level = 1
		material_durability = 6
		material_danger = 2
	elseif (material == "default:aspen_wood") then
		material_name = "aspen_"
		material_description = "Aspen"
		material_force = 0.8
		material_interval = 0.75
		material_level = 1
		material_durability = 5
		material_danger = 1
	elseif (material == "default:junglewood") then
		material_name = "jungle_"
		material_description = "Jungle"
		material_force = 0.95
		material_interval = 0.95
		material_level = 1
		material_durability = 7
		material_danger = 3
	elseif (material == "default:pine_wood") then
		material_name = "pine_"
		material_description = "Pine"
		material_force = 1
		material_interval = 0.9
		material_level = 1
		material_durability = 8
		material_danger = 3
	elseif (material == "default:cobble") then
		material_name = "cobble_"
		material_description = "Cobble"
		material_force = 0.85
		material_interval = 1
		material_level = 1
		material_durability = 11
		material_danger = 4
	elseif (material == "default:tin_ingot") then
		material_name = "tin_"
		material_description = "Tin"
		material_force = 0.8
		material_interval = 1.1
		material_level = 1
		material_durability = 10
		material_danger = 4
	elseif (material == "default:copper_ingot") then
		material_name = "copper_"
		material_description = "Copper"
		material_force = 0.825
		material_interval = 1.2
		material_level = 1
		material_durability = 12
		material_danger = 4
	elseif (material == "default:iron_ingot") then
		material_name = "iron_"
		material_description = "Iron"
		material_force = 0.75
		material_interval = 1.25
		material_level = 2
		material_durability = 14
		material_danger = 5
	elseif (material == "default:steel_ingot") then
		material_name = "steel_"
		material_description = "Steel"
		material_force = 0.6
		material_interval = 1.5
		material_level = 3
		material_durability = 15
		material_danger = 6
	elseif (material == "default:bronze_ingot") then
		material_name = "bronze_"
		material_description = "Bronze"
		material_force = 0.95
		material_interval = 1.4
		material_level = 2
		material_durability = 12
		material_danger = 5
	elseif (material == "default:mese_crystal") then
		material_name = "mese_"
		material_description = "Mese"
		material_force = 0.55
		material_interval = 1.55
		material_level = 3
		material_durability = 16
		material_danger = 6
	elseif (material == "default:diamond") then
		material_name = "diamond_"
		material_description = "Diamond"
		material_force = 0.5
		material_interval = 1.8
		material_level = 4
		material_durability = 18
		material_danger = 8
	else
		return
	end

	-- Define handle material
	if (handle == "default:acacia_stick") and (material_name ~= "acacia_") then
		handle_name = "acacia_"
		handle_interval = 0.15
		handle_durability = 3
	elseif (handle == "default:apple_stick") and (material_name ~= "apple_") then
		handle_name = "apple_"
		handle_interval = 0.2
		handle_durability = 2
	elseif (handle == "default:aspen_stick") and (material_name ~= "aspen_") then
		handle_name = "aspen_"
		handle_interval = 0.1
		handle_durability = 1
	elseif (handle == "default:jungle_stick") and (material_name ~= "jungle_") then
		handle_name = "jungle_"
		handle_interval = 0.3
		handle_durability = 4
	elseif (handle == "default:stick") and (material_name ~= "pine_") then
		handle_name = "pine_"
		handle_interval = 0.25
		handle_durability = 5
	end

	description = material_description .. tool_description
	inventory_image = "default_tool_" .. material_name .. handle_name .. tool .. ".png"
	force = material_force
	interval = material_interval+handle_interval
	level = material_level
	durability = material_durability+handle_durability
	danger = material_danger

	local table = {
		description = S(description),
		inventory_image = inventory_image,
		wield_scale = scale,
		tool_capabilities = {
			full_punch_interval = interval,
			max_drop_level = level,
			damage_groups = {fleshy = danger},
		},
		sound = {breaks = "default_tool_breaks"},
		groups = {pickaxe = 1, flammable = 2},
	}

	-- Define forces
	if (tool == "sword") then
		table.tool_capabilities.groupcaps = {snappy = {times={[1]=force*3, [2]=force*2, [3]=force}, uses=durability, maxlevel=level},}
	elseif (tool == "axe") then
		table.tool_capabilities.groupcaps = {choppy = {times={[1]=force*3, [2]=force*2, [3]=force}, uses=durability, maxlevel=level},}
	elseif (tool == "pick") then
		table.tool_capabilities.groupcaps = {cracky = {times={[1]=force*3, [2]=force*2, [3]=force}, uses=durability, maxlevel=level},}
	elseif (tool == "shovel") then
		table.tool_capabilities.groupcaps = {crumbly = {times={[1]=force*3, [2]=force*2, [3]=force}, uses=durability, maxlevel=level},}
	elseif (tool == "hoe") then
		table.tool_capabilities.groupcaps = {snappy = {times={[1]=force*3, [2]=force*2, [3]=force}, uses=durability, maxlevel=level},}
		durability = durability*10
		table.on_place = function(itemstack, placer, pointed_thing)
			local placerStack = placer:get_wielded_item()
			farming.hoe_on_use(itemstack, placer, pointed_thing, durability)
		end
	end

	return table
end

-- The hand
-- Override the hand item registered in the engine in builtin/game/register.lua
minetest.override_item("", {
	wield_scale = {x=1.15,y=2,z=4.35},
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level = 0,
		groupcaps = {
			cracky = {times={[1]=80.00, [2]=50.00, [3]=20.00}, uses=0, maxlevel=1},
			crumbly = {times={[1]=7.00, [2]=3.00, [3]=0.70}, uses=0, maxlevel=1},
			snappy = {times={[1]=3.00, [2]=1.50, [3]=0.40}, uses=0, maxlevel=1},
			oddly_breakable_by_hand = {times={[1]=3.50,[2]=2.00,[3]=0.70}, uses=0}
		},
		damage_groups = {fleshy=1},
	}
})


--
-- Register tools
--

local tools = {
	sword = "default:sword",
	pick = "default:pick",
	shovel = "default:shovel",
	axe = "default:axe",
	hoe = "default:hoe"
}

for name, tool in pairs(tools) do
	-- Acacia handle
	minetest.register_tool(tool.."_acacia", get_tool_attribute(name, "default:acacia_wood", "default:acacia_stick"))
	minetest.register_tool(tool.."_apple_acacia", get_tool_attribute(name, "default:wood", "default:acacia_stick"))
	minetest.register_tool(tool.."_aspen_acacia", get_tool_attribute(name, "default:aspen_wood", "default:acacia_stick"))
	minetest.register_tool(tool.."_jungle_acacia", get_tool_attribute(name, "default:junglewood", "default:acacia_stick"))
	minetest.register_tool(tool.."_pine_acacia", get_tool_attribute(name, "default:pine_wood", "default:acacia_stick"))
	minetest.register_tool(tool.."_stone_acacia", get_tool_attribute(name, "default:cobble", "default:acacia_stick"))
	minetest.register_tool(tool.."_copper_acacia", get_tool_attribute(name, "default:copper_ingot", "default:acacia_stick"))
	minetest.register_tool(tool.."_tin_acacia", get_tool_attribute(name, "default:tin_ingot", "default:acacia_stick"))
	minetest.register_tool(tool.."_bronze_acacia", get_tool_attribute(name, "default:bronze_ingot", "default:acacia_stick"))
	minetest.register_tool(tool.."_iron_acacia", get_tool_attribute(name, "default:iron_ingot", "default:acacia_stick"))
	minetest.register_tool(tool.."_steel_acacia", get_tool_attribute(name, "default:steel_ingot", "default:acacia_stick"))
	minetest.register_tool(tool.."_mese_acacia", get_tool_attribute(name, "default:mese_crystal", "default:acacia_stick"))
	minetest.register_tool(tool.."_diamond_acacia", get_tool_attribute(name, "default:diamond", "default:acacia_stick"))

	-- Apple handle
	minetest.register_tool(tool.."_acacia_apple", get_tool_attribute(name, "default:acacia_wood", "default:apple_stick"))
	minetest.register_tool(tool.."_apple", get_tool_attribute(name, "default:wood", "default:apple_stick"))
	minetest.register_tool(tool.."_aspen_apple", get_tool_attribute(name, "default:aspen_wood", "default:apple_stick"))
	minetest.register_tool(tool.."_jungle_apple", get_tool_attribute(name, "default:junglewood", "default:apple_stick"))
	minetest.register_tool(tool.."_pine_apple", get_tool_attribute(name, "default:pine_wood", "default:apple_stick"))
	minetest.register_tool(tool.."_stone_apple", get_tool_attribute(name, "default:cobble", "default:apple_stick"))
	minetest.register_tool(tool.."_copper_apple", get_tool_attribute(name, "default:copper_ingot", "default:apple_stick"))
	minetest.register_tool(tool.."_tin_apple", get_tool_attribute(name, "default:tin_ingot", "default:apple_stick"))
	minetest.register_tool(tool.."_bronze_apple", get_tool_attribute(name, "default:bronze_ingot", "default:apple_stick"))
	minetest.register_tool(tool.."_iron_apple", get_tool_attribute(name, "default:iron_ingot", "default:apple_stick"))
	minetest.register_tool(tool.."_steel_apple", get_tool_attribute(name, "default:steel_ingot", "default:apple_stick"))
	minetest.register_tool(tool.."_mese_apple", get_tool_attribute(name, "default:mese_crystal", "default:apple_stick"))
	minetest.register_tool(tool.."_diamond_apple", get_tool_attribute(name, "default:diamond", "default:apple_stick"))

	-- Aspen handle
	minetest.register_tool(tool.."_acacia_aspen", get_tool_attribute(name, "default:acacia_wood", "default:aspen_stick"))
	minetest.register_tool(tool.."_apple_aspen", get_tool_attribute(name, "default:wood", "default:aspen_stick"))
	minetest.register_tool(tool.."_aspen", get_tool_attribute(name, "default:aspen_wood", "default:aspen_stick"))
	minetest.register_tool(tool.."_jungle_aspen", get_tool_attribute(name, "default:junglewood", "default:aspen_stick"))
	minetest.register_tool(tool.."_pine_aspen", get_tool_attribute(name, "default:pine_wood", "default:aspen_stick"))
	minetest.register_tool(tool.."_stone_aspen", get_tool_attribute(name, "default:cobble", "default:aspen_stick"))
	minetest.register_tool(tool.."_copper_aspen", get_tool_attribute(name, "default:copper_ingot", "default:aspen_stick"))
	minetest.register_tool(tool.."_tin_aspen", get_tool_attribute(name, "default:tin_ingot", "default:aspen_stick"))
	minetest.register_tool(tool.."_bronze_aspen", get_tool_attribute(name, "default:bronze_ingot", "default:aspen_stick"))
	minetest.register_tool(tool.."_iron_aspen", get_tool_attribute(name, "default:iron_ingot", "default:aspen_stick"))
	minetest.register_tool(tool.."_steel_aspen", get_tool_attribute(name, "default:steel_ingot", "default:aspen_stick"))
	minetest.register_tool(tool.."_mese_aspen", get_tool_attribute(name, "default:mese_crystal", "default:aspen_stick"))
	minetest.register_tool(tool.."_diamond_aspen", get_tool_attribute(name, "default:diamond", "default:aspen_stick"))

	-- Jungle handle
	minetest.register_tool(tool.."_acacia_jungle", get_tool_attribute(name, "default:acacia_wood", "default:jungle_stick"))
	minetest.register_tool(tool.."_apple_jungle", get_tool_attribute(name, "default:wood", "default:jungle_stick"))
	minetest.register_tool(tool.."_aspen_jungle", get_tool_attribute(name, "default:aspen_wood", "default:jungle_stick"))
	minetest.register_tool(tool.."_jungle", get_tool_attribute(name, "default:junglewood", "default:jungle_stick"))
	minetest.register_tool(tool.."_pine_jungle", get_tool_attribute(name, "default:pine_wood", "default:jungle_stick"))
	minetest.register_tool(tool.."_stone_jungle", get_tool_attribute(name, "default:cobble", "default:jungle_stick"))
	minetest.register_tool(tool.."_copper_jungle", get_tool_attribute(name, "default:copper_ingot", "default:jungle_stick"))
	minetest.register_tool(tool.."_tin_jungle", get_tool_attribute(name, "default:tin_ingot", "default:jungle_stick"))
	minetest.register_tool(tool.."_bronze_jungle", get_tool_attribute(name, "default:bronze_ingot", "default:jungle_stick"))
	minetest.register_tool(tool.."_iron_jungle", get_tool_attribute(name, "default:iron_ingot", "default:jungle_stick"))
	minetest.register_tool(tool.."_steel_jungle", get_tool_attribute(name, "default:steel_ingot", "default:jungle_stick"))
	minetest.register_tool(tool.."_mese_jungle", get_tool_attribute(name, "default:mese_crystal", "default:jungle_stick"))
	minetest.register_tool(tool.."_diamond_jungle", get_tool_attribute(name, "default:diamond", "default:jungle_stick"))

	-- Pine handle
	minetest.register_tool(tool.."_acacia_pine", get_tool_attribute(name, "default:acacia_wood", "default:stick"))
	minetest.register_tool(tool.."_apple_pine", get_tool_attribute(name, "default:wood", "default:stick"))
	minetest.register_tool(tool.."_aspen_pine", get_tool_attribute(name, "default:aspen_wood", "default:stick"))
	minetest.register_tool(tool.."_jungle_pine", get_tool_attribute(name, "default:junglewood", "default:stick"))
	minetest.register_tool(tool.."_pine", get_tool_attribute(name, "default:pine_wood", "default:stick"))
	minetest.register_tool(tool.."_stone_pine", get_tool_attribute(name, "default:cobble", "default:stick"))
	minetest.register_tool(tool.."_copper_pine", get_tool_attribute(name, "default:copper_ingot", "default:stick"))
	minetest.register_tool(tool.."_tin_pine", get_tool_attribute(name, "default:tin_ingot", "default:stick"))
	minetest.register_tool(tool.."_bronze_pine", get_tool_attribute(name, "default:bronze_ingot", "default:stick"))
	minetest.register_tool(tool.."_iron_pine", get_tool_attribute(name, "default:iron_ingot", "default:stick"))
	minetest.register_tool(tool.."_steel_pine", get_tool_attribute(name, "default:steel_ingot", "default:stick"))
	minetest.register_tool(tool.."_mese_pine", get_tool_attribute(name, "default:mese_crystal", "default:stick"))
	minetest.register_tool(tool.."_diamond_pine", get_tool_attribute(name, "default:diamond", "default:stick"))
end

--
-- Register Craft Recipies
--

local craft_ingreds = {
	acacia = "default:acacia_wood",
	apple = "default:wood",
	aspen = "default:aspen_wood",
	jungle = "default:junglewood",
	pine = "default:pine_wood"
}

-- Primary wood tools
for name, mat in pairs(craft_ingreds) do
	local stick = "default:stick"
	if (mat == "default:acacia_wood") then
		stick = "default:acacia_stick"
	elseif (mat == "default:wood") then
		stick = "default:apple_stick"
	elseif (mat == "default:aspen_wood") then
		stick = "default:aspen_stick"
	elseif (mat == "default:junglewood") then
		stick = "default:jungle_stick"
	end
	minetest.register_craft({
		output = "default:pick_".. name,
		recipe = {
			{mat, mat, mat},
			{"", stick, ""},
			{"", stick, ""}
		}
	})
	minetest.register_craft({
		output = "default:shovel_".. name,
		recipe = {
			{mat},
			{stick},
			{stick}
		}
	})
	minetest.register_craft({
		output = "default:axe_".. name,
		recipe = {
			{mat, mat},
			{mat, stick},
			{"", stick}
		}
	})
	minetest.register_craft({
		output = "default:sword_".. name,
		recipe = {
			{mat},
			{mat},
			{stick}
		}
	})
	minetest.register_craft({
		output = "default:hoe_".. name,
		recipe = {
			{mat, mat},
			{"", stick},
			{"", stick}
		}
	})
end

local craft_ingreds = {
	stone = "default:cobble",
	tin = "default:tin_ingot",
	copper = "default:copper_ingot",
	iron = "default:iron_ingot",
	steel = "default:steel_ingot",
	bronze = "default:bronze_ingot",
	mese = "default:mese_crystal",
	diamond = "default:diamond"
}

-- Acacia handle
for name, mat in pairs(craft_ingreds) do
	minetest.register_craft({
		output = "default:pick_".. name .. "_acacia",
		recipe = {
			{mat, mat, mat},
			{"", "default:acacia_stick", ""},
			{"", "default:acacia_stick", ""}
		}
	})
	minetest.register_craft({
		output = "default:shovel_".. name .. "_acacia",
		recipe = {
			{mat},
			{"default:acacia_stick"},
			{"default:acacia_stick"}
		}
	})
	minetest.register_craft({
		output = "default:axe_".. name .. "_acacia",
		recipe = {
			{mat, mat},
			{mat, "default:acacia_stick"},
			{"", "default:acacia_stick"}
		}
	})
	minetest.register_craft({
		output = "default:sword_".. name .. "_acacia",
		recipe = {
			{mat},
			{mat},
			{"default:acacia_stick"}
		}
	})
	minetest.register_craft({
		output = "default:hoe_".. name .. "_acacia",
		recipe = {
			{mat, mat},
			{"", "default:acacia_stick"},
			{"", "default:acacia_stick"}
		}
	})
end

-- Apple handle
for name, mat in pairs(craft_ingreds) do
	minetest.register_craft({
		output = "default:pick_".. name .. "_apple",
		recipe = {
			{mat, mat, mat},
			{"", "default:apple_stick", ""},
			{"", "default:apple_stick", ""}
		}
	})

	minetest.register_craft({
		output = "default:shovel_".. name .. "_apple",
		recipe = {
			{mat},
			{"default:apple_stick"},
			{"default:apple_stick"}
		}
	})

	minetest.register_craft({
		output = "default:axe_".. name .. "_apple",
		recipe = {
			{mat, mat},
			{mat, "default:apple_stick"},
			{"", "default:apple_stick"}
		}
	})

	minetest.register_craft({
		output = "default:sword_".. name .. "_apple",
		recipe = {
			{mat},
			{mat},
			{"default:apple_stick"}
		}
	})
	minetest.register_craft({
		output = "default:hoe_".. name .. "_apple",
		recipe = {
			{mat, mat},
			{"", "default:apple_stick"},
			{"", "default:apple_stick"}
		}
	})
end

-- Aspen handle
for name, mat in pairs(craft_ingreds) do
	minetest.register_craft({
		output = "default:pick_".. name .. "_aspen",
		recipe = {
			{mat, mat, mat},
			{"", "default:aspen_stick", ""},
			{"", "default:aspen_stick", ""}
		}
	})

	minetest.register_craft({
		output = "default:shovel_".. name .. "_aspen",
		recipe = {
			{mat},
			{"default:aspen_stick"},
			{"default:aspen_stick"}
		}
	})

	minetest.register_craft({
		output = "default:axe_".. name .. "_aspen",
		recipe = {
			{mat, mat},
			{mat, "default:aspen_stick"},
			{"", "default:aspen_stick"}
		}
	})

	minetest.register_craft({
		output = "default:sword_".. name .. "_aspen",
		recipe = {
			{mat},
			{mat},
			{"default:aspen_stick"}
		}
	})
	minetest.register_craft({
		output = "default:hoe_".. name .. "_aspen",
		recipe = {
			{mat, mat},
			{"", "default:aspen_stick"},
			{"", "default:aspen_stick"}
		}
	})
end

-- Jungle handle
for name, mat in pairs(craft_ingreds) do
	minetest.register_craft({
		output = "default:pick_".. name .. "_jungle",
		recipe = {
			{mat, mat, mat},
			{"", "default:jungle_stick", ""},
			{"", "default:jungle_stick", ""}
		}
	})

	minetest.register_craft({
		output = "default:shovel_".. name .. "_jungle",
		recipe = {
			{mat},
			{"default:jungle_stick"},
			{"default:jungle_stick"}
		}
	})

	minetest.register_craft({
		output = "default:axe_".. name .. "_jungle",
		recipe = {
			{mat, mat},
			{mat, "default:jungle_stick"},
			{"", "default:jungle_stick"}
		}
	})

	minetest.register_craft({
		output = "default:sword_".. name .. "_jungle",
		recipe = {
			{mat},
			{mat},
			{"default:jungle_stick"}
		}
	})
	minetest.register_craft({
		output = "default:hoe_".. name .. "_jungle",
		recipe = {
			{mat, mat},
			{"", "default:jungle_stick"},
			{"", "default:jungle_stick"}
		}
	})
end

-- Pine handle
for name, mat in pairs(craft_ingreds) do
	minetest.register_craft({
		output = "default:pick_".. name .. "_pine",
		recipe = {
			{mat, mat, mat},
			{"", "default:stick", ""},
			{"", "default:stick", ""}
		}
	})

	minetest.register_craft({
		output = "default:shovel_".. name .. "_pine",
		recipe = {
			{mat},
			{"default:stick"},
			{"default:stick"}
		}
	})

	minetest.register_craft({
		output = "default:axe_".. name .. "_pine",
		recipe = {
			{mat, mat},
			{mat, "default:stick"},
			{"", "default:stick"}
		}
	})

	minetest.register_craft({
		output = "default:sword_".. name .. "_pine",
		recipe = {
			{mat},
			{mat},
			{"default:stick"}
		}
	})
	minetest.register_craft({
		output = "default:hoe_".. name .. "_pine",
		recipe = {
			{mat, mat},
			{"", "default:stick"},
			{"", "default:stick"}
		}
	})
end

-- minetest.register_craft({
-- 	type = "fuel",
-- 	recipe = "default:pick_wood",
-- 	burntime = 6,
-- })

-- minetest.register_craft({
-- 	type = "fuel",
-- 	recipe = "default:shovel_wood",
-- 	burntime = 4,
-- })

-- minetest.register_craft({
-- 	type = "fuel",
-- 	recipe = "default:axe_wood",
-- 	burntime = 6,
-- })

-- minetest.register_craft({
-- 	type = "fuel",
-- 	recipe = "default:sword_wood",
-- 	burntime = 5,
-- })
