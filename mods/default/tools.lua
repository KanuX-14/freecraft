-- mods/default/tools.lua

-- support for MT game translation.
local S = default.get_translator

-- Get 'farming' functions

farming = {}
farming.path = engine.get_modpath("farming")
dofile(farming.path .. "/api.lua")

-- Handle attributes
local function get_tool_attribute(tool, head, handle)
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
	local head_name = ""
	local head_description = ""
	local head_force = 0
	local head_interval = 0
	local head_level = 0
	local head_durability = 0
	local head_danger = 0
	local handle_name = ""
	local handle_interval = 0
	local handle_durability = 0

	-- Define Front-End name
	if 		 (tool == "sword"	) then tool_description = " Sword"
	elseif (tool == "pick"	) then tool_description = " Pickaxe"
	elseif (tool == "shovel") then tool_description = " Shovel"
	elseif (tool == "axe"		) then tool_description = " Axe"
	elseif (tool == "hoe"		) then tool_description = " Hoe"
	else return
	end

	-- Define head head
	if (head == "default:acacia_wood") then
		head_name = "acacia_"; 	head_description = "Acacia"
		head_force = 0.75; 			head_interval = 0.8
		head_level = 1; 				head_durability = 5
		head_danger = 2
	elseif (head == "default:wood") then
		head_name = "apple_"; 	head_description = "Apple"
		head_force = 0.75; 			head_interval = 0.8
		head_level = 1; 				head_durability = 6
		head_danger = 2
	elseif (head == "default:aspen_wood") then
		head_name = "aspen_"; 	head_description = "Aspen"
		head_force = 0.8; 			head_interval = 0.75
		head_level = 1; 				head_durability = 5
		head_danger = 1
	elseif (head == "default:junglewood") then
		head_name = "jungle_"; 	head_description = "Jungle"
		head_force = 0.7; 			head_interval = 0.95
		head_level = 1; 				head_durability = 7
		head_danger = 3
	elseif (head == "default:pine_wood") then
		head_name = "pine_"; 		head_description = "Pine"
		head_force = 0.6; 			head_interval = 0.9
		head_level = 1; 				head_durability = 8
		head_danger = 3
	elseif (head == "default:cobble") then
		head_name = "cobble_"; 	head_description = "Cobble"
		head_force = 0.65; 			head_interval = 1
		head_level = 1; 				head_durability = 11
		head_danger = 4
	elseif (head == "default:tin_ingot") then
		head_name = "tin_"; 		head_description = "Tin"
		head_force = 0.6; 			head_interval = 1.1
		head_level = 1; 				head_durability = 10
		head_danger = 4
	elseif (head == "default:copper_ingot") then
		head_name = "copper_"; 	head_description = "Copper"
		head_force = 0.625; 		head_interval = 1.2
		head_level = 1; 				head_durability = 12
		head_danger = 4
	elseif (head == "default:iron_ingot") then
		head_name = "iron_"; 		head_description = "Iron"
		head_force = 0.55; 			head_interval = 1.25
		head_level = 2; 				head_durability = 14
		head_danger = 5
	elseif (head == "default:steel_ingot") then
		head_name = "steel_"; 	head_description = "Steel"
		head_force = 0.4; 			head_interval = 1.5
		head_level = 3; 				head_durability = 15
		head_danger = 6
	elseif (head == "default:bronze_ingot") then
		head_name = "bronze_"; 	head_description = "Bronze"
		head_force = 0.75; 			head_interval = 1.4
		head_level = 2; 				head_durability = 12
		head_danger = 5
	elseif (head == "default:mese_crystal") then
		head_name = "mese_"; 		head_description = "Mese"
		head_force = 0.35; 			head_interval = 1.55
		head_level = 3; 				head_durability = 16
		head_danger = 6
	elseif (head == "default:diamond") then
		head_name = "diamond_"; head_description = "Diamond"
		head_force = 0.3; 			head_interval = 1.8
		head_level = 4; 				head_durability = 18
		head_danger = 8
	else return
	end

	-- Define handle head
	if 			(handle == "default:acacia_stick") 	and (head_name ~= "acacia_") then
		handle_name = "acacia_"; 	handle_interval = 0.15; handle_durability = 3
	elseif 	(handle == "default:apple_stick") 	and (head_name ~= "apple_") then
		handle_name = "apple_"; 	handle_interval = 0.2; 	handle_durability = 2
	elseif 	(handle == "default:aspen_stick") 	and (head_name ~= "aspen_") then
		handle_name = "aspen_"; 	handle_interval = 0.1; 	handle_durability = 1
	elseif 	(handle == "default:jungle_stick") 	and (head_name ~= "jungle_") then
		handle_name = "jungle_"; 	handle_interval = 0.3; 	handle_durability = 4
	elseif 	(handle == "default:stick") 				and (head_name ~= "pine_") then
		handle_name = "pine_"; 		handle_interval = 0.25; handle_durability = 5
	end

	description 		= head_description .. tool_description
	inventory_image = "default_tool_" .. head_name .. handle_name .. tool .. ".png"
	force 					= head_force
	interval 				= head_interval + handle_interval
	level 					= head_level
	durability 			= head_durability + handle_durability
	danger 					= head_danger

	local table = {
		description 		= S(description),
		inventory_image = inventory_image,
		wield_scale 		= scale,
		tool_capabilities = {
			full_punch_interval = interval,
			max_drop_level 			= level,
			damage_groups 			= {fleshy = danger},
		},
		sound 	= {breaks = "default_tool_breaks"},
		groups 	= {pickaxe = 1, flammable = 2},
	}

	-- Define forces
	if (tool == "sword") then
		table.tool_capabilities.groupcaps = {
			snappy = {
				times = { [1]=force*3, [2]=force*1.9, [3]=force*1.4 },
				uses=durability,
				maxlevel=level
			},
		}
	elseif (tool == "axe") then
		table.tool_capabilities.groupcaps = {
			choppy = {
				times = { [1]=force*2.35, [2]=force*1.5, [3]=force*1.1 },
				uses=durability,
				maxlevel=level
			},
		}
	elseif (tool == "pick") then
		table.tool_capabilities.groupcaps = {
			cracky = {
				times = { [1]=force*2.5, [2]=force*1.75, [3]=force*1.2 },
				uses=durability,
				maxlevel=level
			},
		}
	elseif (tool == "shovel") then
		table.tool_capabilities.groupcaps = {
			crumbly = {
				times = { [1]=force*1.25, [2]=force*0.95, [3]=force*0.75 },
				uses=durability,
				maxlevel=level
			},
		}
	elseif (tool == "hoe") then
		table.tool_capabilities.groupcaps = {
			snappy = {
				times={ [1]=force*2, [2]=force, [3]=force*0.85 },
				uses=durability,
				maxlevel=level
			},
		}
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
engine.override_item("", {
	wield_scale = {x=1.15,y=2,z=4.35},
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level = 0,
		groupcaps = {
			cracky 	= 								{times={[1]=80.00, [2]=50.00, [3]=20.00}, uses=0, maxlevel=1},
			crumbly = 								{times={[1]=7.00,  [2]=3.00, 	[3]=0.70}, 	uses=0, maxlevel=1},
			snappy 	= 								{times={[1]=3.00,  [2]=1.50, 	[3]=0.40}, 	uses=0, maxlevel=1},
			oddly_breakable_by_hand = {times={[1]=3.50,	 [2]=2.00,	[3]=0.70}, 	uses=0}
		},
		damage_groups = {fleshy=1},
	}
})

--
-- Register tools and craft Recipies
--

local tools = {
	[0] = { sword = "default:sword" },
	[1] = { pick = "default:pick" },
	[2] = { shovel = "default:shovel" },
	[3] = { axe = "default:axe" },
	[4] = { hoe = "default:hoe" }
}

local handle_ingredients = {
	acacia 	=	"default:acacia_stick",	apple		=	"default:apple_stick",
	aspen		=	"default:aspen_stick",	jungle	=	"default:jungle_stick",
	pine		=	"default:stick"
}

local head_ingredients = {
	acacia 	= "default:acacia_wood",	apple 		= "default:wood",
	aspen 	= "default:aspen_wood",		jungle 		= "default:junglewood",
	pine 		= "default:pine_wood",		stone 		= "default:cobble",
	tin 		= "default:tin_ingot",		copper 		= "default:copper_ingot",
	iron 		= "default:iron_ingot",		steel 		= "default:steel_ingot",
	bronze 	= "default:bronze_ingot",	mese 			= "default:mese_crystal",
	diamond = "default:diamond"
}

-- Free space to make crafting look good.
local _ = ""

-- Craft given tools.
for handle, I in pairs(handle_ingredients) do
	for head, X in pairs(head_ingredients) do
		local extended_name = "_" .. head .. "_" .. handle
		if (handle == head) then extended_name = "_" .. head end

		for id, _table in pairs(tools) do
			default.switch(id, {
				[0] = function()
					local tool_name = "sword"
					_table.sword = "default:" .. tool_name .. extended_name
					engine.register_tool(_table.sword, get_tool_attribute(tool_name, X, I))
					engine.register_craft({ output = _table.sword, recipe = {{X},
																																	 {X},
																																	 {I}}})
					if (handle == head) then
						engine.register_craft({ type = "fuel", recipe = _table.sword, burntime = 5, })
					end
				end,
				[1] = function()
					local tool_name = "pick"
					_table.pick = "default:" .. tool_name .. extended_name
					engine.register_tool(_table.pick, get_tool_attribute(tool_name, X, I))
					engine.register_craft({ output = _table.pick, recipe = {{X, X, X},
																																	{_, I, _},
																																	{_, I, _}}})
					if (handle == head) then
						engine.register_craft({ type = "fuel", recipe = _table.pick, burntime = 6, })
					end
				end,
				[2] = function()
					local tool_name = "shovel"
					_table.shovel = "default:" .. tool_name.. extended_name
					engine.register_tool(_table.shovel, get_tool_attribute(tool_name, X, I))
					engine.register_craft({ output = _table.shovel, recipe = {{X},
																																		{I},
																																		{I}}})
					if (handle == head) then
						engine.register_craft({ type = "fuel", recipe = _table.shovel, burntime = 4, })
					end
				end,
				[3] = function()
					local tool_name = "axe"
					_table.axe = "default:" .. tool_name .. extended_name
					engine.register_tool(_table.axe, get_tool_attribute(tool_name, X, I))
					engine.register_craft({ output = _table.axe,recipe = {{X, X},
																																{X, I},
																																{_, I}}})
					if (handle == head) then
						engine.register_craft({ type = "fuel", recipe = _table.axe, burntime = 6, })
					end
				end,
				[4] = function()
					local tool_name = "hoe"
					_table.hoe = "default:" .. tool_name .. extended_name
					engine.register_tool(_table.hoe, get_tool_attribute(tool_name, X, I))
					engine.register_craft({ output = _table.hoe, recipe = {{X, X},
																																 {_, I},
																																 {_, I}}})
					if (handle == head) then
						engine.register_craft({ type = "fuel", recipe = _table.hoe, burntime = 5, })
					end
				end
			})
		end
	end
end
