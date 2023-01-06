--
-- Global
--

-- Check valid values. Skips when no valid value is found.
function default.check_nil(...)
	local argument = ...
	if (argument == nil) then return false end
	if (type(argument) == "table") then
		for i,v in pairs(argument) do
			if (v == nil) then return false end
		end
	end
	return true
end

-- Get game version
function default.get_version(engine)
	local version
	if (engine_name == "freecraft") then return ""
	elseif(engine_version == "5.7.0-dev") then
		local game = Settings(engine.get_game_info().path .. "/game.conf")
		version = game:get("title")
	else version = "FreeCraft v0.1.4 (alpha)" end

	return version
end

-- Switch function
function default.switch(parameter, table)
	if not parameter then return nil end
	if not table then return nil end
	local func = table[parameter]
	if (func) then
		return func()
	else
		return nil
	end
end

-- Returns a float/int position, based on the desired mode.
function default.get_real_entity_position(entity, mode)
	if not entity then return nil end
	local pos = entity:get_pos()
	if not default.check_nil(pos) then return nil end
	pos.y = pos.y + 1
	if (mode == "int") then
		pos.x = math.floor(pos.x)
		pos.y = math.floor(pos.y)
		pos.z = math.floor(pos.z)
	end
	return pos
end

-- Get a random pitch for a sound
function default.random_pitch()
	local randomPitch = math.random(0, 4)
	if (randomPitch == 0) then
		randomPitch = 0.75
	elseif (randomPitch == 1) then
		randomPitch = 0.95
	elseif (randomPitch == 2) then
		randomPitch = 1
	elseif (randomPitch == 3) then
		randomPitch = 1.05
	else
		randomPitch = 1.25
	end
	return randomPitch
end

--
-- General node
--

-- Return a table of position in range
function default.get_range(pos, range)
	local r = range or 1
	local pos_in_range = {
		top = {x=pos.x, y=pos.y+r, z=pos.z},
		bottom = {x=pos.x, y=pos.y-r, z=pos.z},
		north = {x=pos.x, y=pos.y, z=pos.z+r},
		south = {x=pos.x, y=pos.y, z=pos.z-r},
		east = {x=pos.x+r, y=pos.y, z=pos.z},
		west = {x=pos.x-r, y=pos.y, z=pos.z}
	}
	return pos_in_range
end

-- Get node direction where it is pointing at
function default.get_node_dir(pos, mode)
	local node = engine.get_node(vector.new(pos))
	local dir = engine.facedir_to_dir(node.param2 % 4)

	local face_pos = {}

	if (mode == "back") then
		if (dir.z == 1) then face_pos={x=pos.x,y=pos.y,z=pos.z-1} elseif (dir.z == -1) then face_pos={x=pos.x,y=pos.y,z=pos.z+1}
		elseif (dir.x == -1) then face_pos={x=pos.x+1,y=pos.y,z=pos.z} else face_pos={x=pos.x-1,y=pos.y,z=pos.z} end
	-- elseif (mode == "top") then
	-- 	if (dir.z == 1) then face_pos={x=pos.x+1,y=pos.y,z=pos.z} elseif (dir.z == -1) then face_pos={x=pos.x-1,y=pos.y,z=pos.z}
	-- 	elseif (dir.x == -1) then face_pos={x=pos.x,y=pos.y,z=pos.z+1} else face_pos={x=pos.x,y=pos.y,z=pos.z-1} end
	-- elseif (mode == "bottom") then
	-- 	if (dir.z == 1) then face_pos={x=pos.x-1,y=pos.y,z=pos.z} elseif (dir.z == -1) then face_pos={x=pos.x+1,y=pos.y,z=pos.z}
	-- 	elseif (dir.x == -1) then face_pos={x=pos.x,y=pos.y,z=pos.z-1} else face_pos={x=pos.x,y=pos.y,z=pos.z+1} end
	else
		if (dir.z == 1) then face_pos={x=pos.x,y=pos.y,z=pos.z+1} elseif (dir.z == -1) then face_pos={x=pos.x,y=pos.y,z=pos.z-1}
		elseif (dir.x == -1) then face_pos={x=pos.x-1,y=pos.y,z=pos.z} else face_pos={x=pos.x+1,y=pos.y,z=pos.z} end
	end

	return face_pos
end

-- Get empty
function default.get_empty(pos, player)
	local meta = engine.get_meta(pos);
	local inv = meta:get_inventory()
	return inv:is_empty("main")
end

-- Place soil and flood
function default.place_and_flood(pos, nodename)
	local check_box = default.get_range(pos)

	-- Check for water in range
	for i,npos in pairs(check_box) do
		if (i ~= "bottom") then
			local n = engine.get_node_or_nil(npos)

			if default.check_nil(n) then
				if (engine.get_item_group(n.name, "water") > 0) then
					engine.swap_node(pos, {name = nodename})
					return
				end
			end
		end
	end
end

-- Automate the energy table process
function default.get_energy_table(pos)
	local node = engine.get_node_or_nil(pos)
	if not default.check_nil(node) then return nil end

	local meta = engine.get_meta(pos)
	local energy = meta:get_int("fc_energy") or 0
	local g_energy = engine.get_item_group(node.name, "energy")
	local is_cable = engine.get_item_group(node.name, "cable")
	local resistance = engine.get_item_group(node.name, "resistance")
	local max_energy = engine.get_item_group(node.name, "max_energy")
	local energy_flow = is_cable

	if (is_cable < 1) then energy_flow = resistance end
	if (resistance < 1) and (is_cable < 1) then energy_flow = energy end

	local table = {name=node.name, meta=meta, energy=energy, cable=is_cable, g_energy=g_energy,
				   resistance=resistance, max_energy=max_energy, energy_flow=energy_flow}
	return table
end

-- Handles the flow of energy, according with the given mode:
--		0 = constant.
--		1 = input.
--		2 = output.
--		3 = one way.
-- Both input/output need to be a node.
function default.energy_flow(mode, input, output, is_one_way)
	if not default.check_nil(mode, input, output) then return end
	local i_node = default.get_energy_table(input)
	local o_node = default.get_energy_table(output)
	if not default.check_nil(mode, i_node, o_node) then return end

	if (mode == 0) and (i_node.cable < 1) then return end

	if (o_node.name ~= "default:cobble") then
		if (i_node.g_energy < 1) or
		   (o_node.g_energy < 1) then return end
	end

	if (i_node.energy < 0) then
		i_node.meta:set_int("fc_energy", 0)
		i_node.energy = 0
	end
	if (o_node.energy < 0) then
		o_node.meta:set_int("fc_energy", 0)
		o_node.energy = 0
	end

	if (o_node.name ~= "default:cobble") then
		if (i_node.energy > i_node.max_energy) then
			i_node.meta:set_int("fc_energy", i_node.max_energy)
			i_node.energy = i_node.max_energy
		end
		if (o_node.energy > o_node.max_energy) then
			o_node.meta:set_int("fc_energy", o_node.max_energy)
			o_node.energy = o_node.max_energy
		end
	end

	default.switch(mode, {
		[0] = function()
			if (i_node.energy > o_node.energy) then
				i_node.meta:set_int("fc_energy", i_node.energy - i_node.energy_flow)
				o_node.meta:set_int("fc_energy", o_node.energy + i_node.energy_flow)
			end
		end,
		[1] = function()
			if (o_node.energy > 0) then
				i_node.meta:set_int("fc_energy", i_node.energy + o_node.energy_flow)
				o_node.meta:set_int("fc_energy", o_node.energy - o_node.energy_flow)
			end
		end,
		[2] = function()
			if (i_node.energy > 0) then
				i_node.meta:set_int("fc_energy", i_node.energy - i_node.energy_flow)
				o_node.meta:set_int("fc_energy", o_node.energy + i_node.energy_flow - 1)
			end
		end,
		[3] = function()
			if (i_node.energy > 0) and is_one_way then
				i_node.meta:set_int("fc_energy", i_node.energy - i_node.energy_flow)
				o_node.meta:set_int("fc_energy", o_node.energy + i_node.energy_flow - 1)
			end
		end
	})
end

-- Step function for functional nodes
function default.on_node_step(pos, elapsed, mode, interval)
	local update = interval or 1
	local timer = engine.get_node_timer(pos)
	local meta = engine.get_meta(pos)
	local energy = meta:get_int("fc_energy") or 0
	local buzz = energy / 100
	local sound = { name = "default_machine_buzz",
					parameters = { pos = pos, max_hear_distance = 3,
					   			   gain = buzz, pitch = 1.0}}
	-- Dryer transforms mud into clay.
	if (mode == "dryer") then
		local i_pos = {x=pos.x, y=pos.y+1, z=pos.z}
		local i_node = engine.get_node_or_nil(i_pos)
		if default.check_nil(i_node) and (engine.get_item_group(i_node.name, "dry") > 0) then
			local i_meta = engine.get_meta(i_pos)
			local dry_timer = i_meta:get_int("dry_timer") or 0
			local dry_max_timer = engine.get_item_group(i_node.name, "dry")
			i_meta:set_int("dry_timer", dry_timer + 1)
			if (dry_timer >= dry_max_timer) then engine.set_node(i_pos, {name = "default:clay"}) end
		end
	-- Water mill generates torque from water flowing
	elseif (mode == "watermill") then
		local flowing_water = default.get_range(pos, 1)
		local i_count = 0
		sound.name = "default_watermill"
		sound.parameters.gain = 1.0
		if (energy > 0) then engine.sound_play(sound.name, sound.parameters) end
		for _,position in pairs(flowing_water) do
			local i_node = engine.get_node_or_nil(position)
			if (i_node ~= nil) then
				if (engine.get_item_group(i_node.name, "water")) and (i_node.name == "default:water_flowing") then
					i_count = i_count + 1
					energy = i_count
					meta:set_int("fc_energy", energy)
				end
			end
		end
	-- Heater melt stones into lava
	elseif (mode == "heater") then
		local face_pos = default.get_node_dir(pos)
		local back_pos = default.get_node_dir(pos, "back")
		local face_node = engine.get_node_or_nil(face_pos)
		default.energy_flow(1, pos, back_pos)
		if (face_node ~= nil) and (face_node.name == "default:cobble") then
			if (energy > 0) then engine.sound_play(sound.name, sound.parameters) end
			default.energy_flow(2, pos, face_pos)
			local face_node_energy = engine.get_meta(face_pos):get_int("fc_energy") or 0
			if (face_node_energy > 500) then
				engine.swap_node(face_pos, {name = "default:lava_source"})
				engine.sound_play("default_cool_lava", {pos=face_pos,max_hear_distance=8,gain=0.8,pitch=1.0})
			end
		end
	-- Generator gives energy.
	elseif (mode == "generator") then
		local cables = default.get_range(pos, 1)
		if (energy > 0) then engine.sound_play(sound.name, sound.parameters) end
		for _,position in pairs(cables) do default.energy_flow(2, pos, position) end
	-- Cable spread the energy, but do not do anything if there is no energy.
	elseif (mode == "cable") then
		if (energy > 0) then
			local cables = default.get_range(pos, 1)
			engine.sound_play(sound.name, sound.parameters)
			for _,position in pairs(cables) do default.energy_flow(0, pos, position) end
		end
	-- Battery receives energy (top) and gives energy (bottom).
	elseif (mode == "battery") then
		local face_pos = default.get_node_dir(pos)
		local back_pos = default.get_node_dir(pos, "back")
		if (energy > 0) then engine.sound_play(sound.name, sound.parameters) end
		default.energy_flow(1, pos, face_pos)
		default.energy_flow(2, pos, back_pos)
	-- Diode blocks the output from flowing to the input.
	elseif (mode == "diode") then
		local face_pos = default.get_node_dir(pos)
		local back_pos = default.get_node_dir(pos, "back")
		if (energy > 0) then engine.sound_play(sound.name, sound.parameters) end
		default.energy_flow(3, back_pos, face_pos, true)
	-- Coil transforms kinetic energy to electric energy
	elseif (mode == "coil") then
		local face_pos = default.get_node_dir(pos)
		local back_pos = default.get_node_dir(pos, "back")
		if (energy > 0) then engine.sound_play(sound.name, sound.parameters) end
		default.energy_flow(3, face_pos, back_pos, true)
	end
	-- Repeat the step. Update interval is marked by seconds.
	timer:start(update)
end

--
-- Sounds
--

function default.node_sound_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "", gain = 1.0}
	table.dug = table.dug or
			{name = "default_dug_node", gain = 0.25}
	table.place = table.place or
			{name = "default_place_node_hard", gain = 1.0}
	return table
end

function default.node_sound_stone_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_hard_footstep", gain = 0.2}
	table.dug = table.dug or
			{name = "default_hard_footstep", gain = 1.0}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_dirt_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_dirt_footstep", gain = 0.25}
	table.dig = table.dig or
			{name = "default_dig_crumbly", gain = 0.4}
	table.dug = table.dug or
			{name = "default_dirt_footstep", gain = 1.0}
	table.place = table.place or
			{name = "default_place_node", gain = 1.0}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_sand_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_sand_footstep", gain = 0.05}
	table.dug = table.dug or
			{name = "default_sand_footstep", gain = 0.15}
	table.place = table.place or
			{name = "default_place_node", gain = 1.0}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_gravel_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_gravel_footstep", gain = 0.25}
	table.dig = table.dig or
			{name = "default_gravel_dig", gain = 0.35}
	table.dug = table.dug or
			{name = "default_gravel_dug", gain = 1.0}
	table.place = table.place or
			{name = "default_place_node", gain = 1.0}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_wood_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_wood_footstep", gain = 0.15}
	table.dig = table.dig or
			{name = "default_dig_choppy", gain = 0.4}
	table.dug = table.dug or
			{name = "default_wood_footstep", gain = 1.0}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_leaves_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_grass_footstep", gain = 0.45}
	table.dug = table.dug or
			{name = "default_grass_footstep", gain = 0.7}
	table.place = table.place or
			{name = "default_place_node", gain = 1.0}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_glass_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_glass_footstep", gain = 0.3}
	table.dig = table.dig or
			{name = "default_glass_footstep", gain = 0.5}
	table.dug = table.dug or
			{name = "default_break_glass", gain = 1.0}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_ice_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_ice_footstep", gain = 0.15}
	table.dig = table.dig or
			{name = "default_ice_dig", gain = 0.5}
	table.dug = table.dug or
			{name = "default_ice_dug", gain = 0.5}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_metal_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_metal_footstep", gain = 0.2}
	table.dig = table.dig or
			{name = "default_dig_metal", gain = 0.5}
	table.dug = table.dug or
			{name = "default_dug_metal", gain = 0.5}
	table.place = table.place or
			{name = "default_place_node_metal", gain = 0.5}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_water_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_water_footstep", gain = 0.2}
	default.node_sound_defaults(table)
	return table
end

function default.node_sound_snow_defaults(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "default_snow_footstep", gain = 0.2}
	table.dig = table.dig or
			{name = "default_snow_footstep", gain = 0.3}
	table.dug = table.dug or
			{name = "default_snow_footstep", gain = 0.3}
	table.place = table.place or
			{name = "default_place_node", gain = 1.0}
	default.node_sound_defaults(table)
	return table
end


--
-- Lavacooling
--

default.cool_lava = function(pos, node)
	if node.name == "default:lava_source" then
		engine.set_node(pos, {name = "default:obsidian"})
	else -- Lava flowing
		engine.set_node(pos, {name = "default:stone"})
	end
	engine.sound_play("default_cool_lava",
		{pos = pos, max_hear_distance = 16, gain = 0.2}, true)
end

if engine.settings:get_bool("enable_lavacooling") ~= false then
	engine.register_abm({
		label = "Lava cooling",
		nodenames = {"default:lava_source", "default:lava_flowing"},
		neighbors = {"group:cools_lava", "group:water"},
		interval = 2,
		chance = 2,
		catch_up = false,
		action = function(...)
			default.cool_lava(...)
		end,
	})
end


--
-- Optimized helper to put all items in an inventory into a drops list
--

function default.get_inventory_drops(pos, inventory, drops)
	local inv = engine.get_meta(pos):get_inventory()
	local n = #drops
	for i = 1, inv:get_size(inventory) do
		local stack = inv:get_stack(inventory, i)
		if stack:get_count() > 0 then
			drops[n+1] = stack:to_table()
			n = n + 1
		end
	end
end


--
-- Papyrus and cactus growing
--

-- Wrapping the functions in ABM action is necessary to make overriding them possible

function default.grow_cactus(pos, node)
	if node.param2 >= 4 then
		return
	end
	pos.y = pos.y - 1
	if engine.get_item_group(engine.get_node(pos).name, "sand") == 0 then
		return
	end
	pos.y = pos.y + 1
	local height = 0
	while node.name == "default:cactus" and height < 4 do
		height = height + 1
		pos.y = pos.y + 1
		node = engine.get_node(pos)
	end
	if height == 4 or node.name ~= "air" then
		return
	end
	if engine.get_node_light(pos) < 13 then
		return
	end
	engine.set_node(pos, {name = "default:cactus"})
	return true
end

function default.grow_papyrus(pos, node)
	pos.y = pos.y - 1
	local name = engine.get_node(pos).name
	if name ~= "default:dirt" and
			name ~= "default:dirt_with_grass" and
			name ~= "default:dirt_with_dry_grass" and
			name ~= "default:dirt_with_rainforest_litter" and
			name ~= "default:dry_dirt" and
			name ~= "default:dry_dirt_with_dry_grass" then
		return
	end
	if not engine.find_node_near(pos, 3, {"group:water"}) then
		return
	end
	pos.y = pos.y + 1
	local height = 0
	while node.name == "default:papyrus" and height < 4 do
		height = height + 1
		pos.y = pos.y + 1
		node = engine.get_node(pos)
	end
	if height == 4 or node.name ~= "air" then
		return
	end
	if engine.get_node_light(pos) < 13 then
		return
	end
	engine.set_node(pos, {name = "default:papyrus"})
	return true
end

engine.register_abm({
	label = "Grow cactus",
	nodenames = {"default:cactus"},
	neighbors = {"group:sand"},
	interval = 12,
	chance = 83,
	action = function(...)
		default.grow_cactus(...)
	end
})

engine.register_abm({
	label = "Grow papyrus",
	nodenames = {"default:papyrus"},
	-- Grows on the dirt and surface dirt nodes of the biomes papyrus appears in,
	-- including the old savanna nodes.
	-- 'default:dirt_with_grass' is here only because it was allowed before.
	neighbors = {
		"default:dirt",
		"default:dirt_with_grass",
		"default:dirt_with_dry_grass",
		"default:dirt_with_rainforest_litter",
		"default:dry_dirt",
		"default:dry_dirt_with_dry_grass",
	},
	interval = 14,
	chance = 71,
	action = function(...)
		default.grow_papyrus(...)
	end
})


--
-- Dig upwards
--

function default.dig_up(pos, node, digger)
	if digger == nil then return end
	local np = {x = pos.x, y = pos.y + 1, z = pos.z}
	local nn = engine.get_node(np)
	if nn.name == node.name then
		engine.node_dig(np, nn, digger)
	end
end


--
-- Fence registration helper
--
local fence_collision_extra = engine.settings:get_bool("enable_fence_tall") and 3/8 or 0

function default.register_fence(name, def)
	engine.register_craft({
		output = name .. " 4",
		recipe = {
			{ def.material, 'group:stick', def.material },
			{ def.material, 'group:stick', def.material },
		}
	})

	local fence_texture = "default_fence_overlay.png^" .. def.texture ..
			"^default_fence_overlay.png^[makealpha:255,126,126"
	-- Allow almost everything to be overridden
	local default_fields = {
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "connected",
			fixed = {-1/8, -1/2, -1/8, 1/8, 1/2, 1/8},
			-- connect_top =
			-- connect_bottom =
			connect_front = {{-1/16,  3/16, -1/2,   1/16,  5/16, -1/8 },
				         {-1/16, -5/16, -1/2,   1/16, -3/16, -1/8 }},
			connect_left =  {{-1/2,   3/16, -1/16, -1/8,   5/16,  1/16},
				         {-1/2,  -5/16, -1/16, -1/8,  -3/16,  1/16}},
			connect_back =  {{-1/16,  3/16,  1/8,   1/16,  5/16,  1/2 },
				         {-1/16, -5/16,  1/8,   1/16, -3/16,  1/2 }},
			connect_right = {{ 1/8,   3/16, -1/16,  1/2,   5/16,  1/16},
				         { 1/8,  -5/16, -1/16,  1/2,  -3/16,  1/16}}
		},
		collision_box = {
			type = "connected",
			fixed = {-1/8, -1/2, -1/8, 1/8, 1/2 + fence_collision_extra, 1/8},
			-- connect_top =
			-- connect_bottom =
			connect_front = {-1/8, -1/2, -1/2,  1/8, 1/2 + fence_collision_extra, -1/8},
			connect_left =  {-1/2, -1/2, -1/8, -1/8, 1/2 + fence_collision_extra,  1/8},
			connect_back =  {-1/8, -1/2,  1/8,  1/8, 1/2 + fence_collision_extra,  1/2},
			connect_right = { 1/8, -1/2, -1/8,  1/2, 1/2 + fence_collision_extra,  1/8}
		},
		connects_to = {"group:fence", "group:wood", "group:tree", "group:wall"},
		inventory_image = fence_texture,
		wield_image = fence_texture,
		tiles = {def.texture},
		sunlight_propagates = true,
		is_ground_content = false,
		groups = {},
	}
	for k, v in pairs(default_fields) do
		if def[k] == nil then
			def[k] = v
		end
	end

	-- Always add to the fence group, even if no group provided
	def.groups.fence = 1

	def.texture = nil
	def.material = nil

	engine.register_node(name, def)
end


--
-- Fence rail registration helper
--

function default.register_fence_rail(name, def)
	engine.register_craft({
		output = name .. " 16",
		recipe = {
			{ def.material, def.material },
			{ "", ""},
			{ def.material, def.material },
		}
	})

	local fence_rail_texture = "default_fence_rail_overlay.png^" .. def.texture ..
			"^default_fence_rail_overlay.png^[makealpha:255,126,126"
	-- Allow almost everything to be overridden
	local default_fields = {
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "connected",
			fixed = {{-1/16,  3/16, -1/16, 1/16,  5/16, 1/16},
				 {-1/16, -3/16, -1/16, 1/16, -5/16, 1/16}},
			-- connect_top =
			-- connect_bottom =
			connect_front = {{-1/16,  3/16, -1/2,   1/16,  5/16, -1/16},
				         {-1/16, -5/16, -1/2,   1/16, -3/16, -1/16}},
			connect_left =  {{-1/2,   3/16, -1/16, -1/16,  5/16,  1/16},
				         {-1/2,  -5/16, -1/16, -1/16, -3/16,  1/16}},
			connect_back =  {{-1/16,  3/16,  1/16,  1/16,  5/16,  1/2 },
				         {-1/16, -5/16,  1/16,  1/16, -3/16,  1/2 }},
			connect_right = {{ 1/16,  3/16, -1/16,  1/2,   5/16,  1/16},
		                         { 1/16, -5/16, -1/16,  1/2,  -3/16,  1/16}}
		},
		collision_box = {
			type = "connected",
			fixed = {-1/8, -1/2, -1/8, 1/8, 1/2 + fence_collision_extra, 1/8},
			-- connect_top =
			-- connect_bottom =
			connect_front = {-1/8, -1/2, -1/2,  1/8, 1/2 + fence_collision_extra, -1/8},
			connect_left =  {-1/2, -1/2, -1/8, -1/8, 1/2 + fence_collision_extra,  1/8},
			connect_back =  {-1/8, -1/2,  1/8,  1/8, 1/2 + fence_collision_extra,  1/2},
			connect_right = { 1/8, -1/2, -1/8,  1/2, 1/2 + fence_collision_extra,  1/8}
		},
		connects_to = {"group:fence", "group:wall"},
		inventory_image = fence_rail_texture,
		wield_image = fence_rail_texture,
		tiles = {def.texture},
		sunlight_propagates = true,
		is_ground_content = false,
		groups = {},
	}
	for k, v in pairs(default_fields) do
		if def[k] == nil then
			def[k] = v
		end
	end

	-- Always add to the fence group, even if no group provided
	def.groups.fence = 1

	def.texture = nil
	def.material = nil

	engine.register_node(name, def)
end

--
-- Mese post registration helper
--

function default.register_mesepost(name, def)
	engine.register_craft({
		output = name .. " 4",
		recipe = {
			{'', 'default:glass', ''},
			{'default:mese_crystal', 'default:mese_crystal', 'default:mese_crystal'},
			{'', def.material, ''},
		}
	})

	local post_texture = def.texture .. "^default_mese_post_light_side.png^[makealpha:0,0,0"
	local post_texture_dark = def.texture .. "^default_mese_post_light_side_dark.png^[makealpha:0,0,0"
	-- Allow almost everything to be overridden
	local default_fields = {
		wield_image = post_texture,
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-2 / 16, -8 / 16, -2 / 16, 2 / 16, 8 / 16, 2 / 16},
			},
		},
		paramtype = "light",
		tiles = {def.texture, def.texture, post_texture_dark, post_texture_dark, post_texture, post_texture},
		use_texture_alpha = "opaque",
		light_source = default.LIGHT_MAX,
		sunlight_propagates = true,
		is_ground_content = false,
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
		sounds = default.node_sound_wood_defaults(),
	}
	for k, v in pairs(default_fields) do
		if def[k] == nil then
			def[k] = v
		end
	end

	def.texture = nil
	def.material = nil

	engine.register_node(name, def)
end

--
-- Leafdecay
--

-- Prevent decay of placed leaves

default.after_place_leaves = function(pos, placer, itemstack, pointed_thing)
	if placer and placer:is_player() then
		local node = engine.get_node(pos)
		node.param2 = 1
		engine.set_node(pos, node)
	end
end

-- Leafdecay
local function leafdecay_after_destruct(pos, oldnode, def)
	for _, v in pairs(engine.find_nodes_in_area(vector.subtract(pos, def.radius),
			vector.add(pos, def.radius), def.leaves)) do
		local node = engine.get_node(v)
		local timer = engine.get_node_timer(v)
		if node.param2 ~= 1 and not timer:is_started() then
			timer:start(math.random(20, 120) / 10)
		end
	end
end

local movement_gravity = tonumber(
	engine.settings:get("movement_gravity")) or 9.81

local function leafdecay_on_timer(pos, def)
	if engine.find_node_near(pos, def.radius, def.trunks) then
		return false
	end

	local node = engine.get_node(pos)
	local drops = engine.get_node_drops(node.name)
	for _, item in ipairs(drops) do
		local is_leaf
		for _, v in pairs(def.leaves) do
			if v == item then
				is_leaf = true
			end
		end
		if engine.get_item_group(item, "leafdecay_drop") ~= 0 or
				not is_leaf then
			engine.add_item({
				x = pos.x - 0.5 + math.random(),
				y = pos.y - 0.5 + math.random(),
				z = pos.z - 0.5 + math.random(),
			}, item)
		end
	end

	engine.remove_node(pos)
	engine.check_for_falling(pos)

	-- spawn a few particles for the removed node
	engine.add_particlespawner({
		amount = 8,
		time = 0.001,
		minpos = vector.subtract(pos, {x=0.5, y=0.5, z=0.5}),
		maxpos = vector.add(pos, {x=0.5, y=0.5, z=0.5}),
		minvel = vector.new(-0.5, -1, -0.5),
		maxvel = vector.new(0.5, 0, 0.5),
		minacc = vector.new(0, -movement_gravity, 0),
		maxacc = vector.new(0, -movement_gravity, 0),
		minsize = 0,
		maxsize = 0,
		node = node,
	})
end

function default.register_leafdecay(def)
	assert(def.leaves)
	assert(def.trunks)
	assert(def.radius)
	for _, v in pairs(def.trunks) do
		engine.override_item(v, {
			after_destruct = function(pos, oldnode)
				leafdecay_after_destruct(pos, oldnode, def)
			end,
		})
	end
	for _, v in pairs(def.leaves) do
		engine.override_item(v, {
			on_timer = function(pos)
				leafdecay_on_timer(pos, def)
			end,
		})
	end
end


--
-- Convert default:dirt to something that fits the environment
--

engine.register_abm({
	label = "Grass spread",
	nodenames = {"default:dirt"},
	neighbors = {
		"air",
		"group:grass",
		"group:dry_grass",
		"default:snow",
	},
	interval = 6,
	chance = 50,
	catch_up = false,
	action = function(pos, node)
		-- Check for darkness: night, shadow or under a light-blocking node
		-- Returns if ignore above
		local above = {x = pos.x, y = pos.y + 1, z = pos.z}
		if (engine.get_node_light(above) or 0) < 13 then
			return
		end

		-- Look for spreading dirt-type neighbours
		local p2 = engine.find_node_near(pos, 1, "group:spreading_dirt_type")
		if p2 then
			local n3 = engine.get_node(p2)
			engine.set_node(pos, {name = n3.name})
			return
		end

		-- Else, any seeding nodes on top?
		local name = engine.get_node(above).name
		-- Snow check is cheapest, so comes first
		if name == "default:snow" then
			engine.set_node(pos, {name = "default:dirt_with_snow"})
		elseif engine.get_item_group(name, "grass") ~= 0 then
			engine.set_node(pos, {name = "default:dirt_with_grass"})
		elseif engine.get_item_group(name, "dry_grass") ~= 0 then
			engine.set_node(pos, {name = "default:dirt_with_dry_grass"})
		end
	end
})


--
-- Grass and dry grass removed in darkness
--

engine.register_abm({
	label = "Grass covered",
	nodenames = {"group:spreading_dirt_type", "default:dry_dirt_with_dry_grass"},
	interval = 8,
	chance = 50,
	catch_up = false,
	action = function(pos, node)
		local above = {x = pos.x, y = pos.y + 1, z = pos.z}
		local name = engine.get_node(above).name
		local nodedef = engine.registered_nodes[name]
		if name ~= "ignore" and nodedef and not ((nodedef.sunlight_propagates or
				nodedef.paramtype == "light") and
				nodedef.liquidtype == "none") then
			if node.name == "default:dry_dirt_with_dry_grass" then
				engine.set_node(pos, {name = "default:dry_dirt"})
			else
				engine.set_node(pos, {name = "default:dirt"})
			end
		end
	end
})


--
-- Moss growth on cobble near water
--

local moss_correspondences = {
	["default:cobble"] = "default:mossycobble",
	["stairs:slab_cobble"] = "stairs:slab_mossycobble",
	["stairs:stair_cobble"] = "stairs:stair_mossycobble",
	["stairs:stair_inner_cobble"] = "stairs:stair_inner_mossycobble",
	["stairs:stair_outer_cobble"] = "stairs:stair_outer_mossycobble",
	["walls:cobble"] = "walls:mossycobble",
}
engine.register_abm({
	label = "Moss growth",
	nodenames = {"default:cobble", "stairs:slab_cobble", "stairs:stair_cobble",
		"stairs:stair_inner_cobble", "stairs:stair_outer_cobble",
		"walls:cobble"},
	neighbors = {"group:water"},
	interval = 16,
	chance = 200,
	catch_up = false,
	action = function(pos, node)
		node.name = moss_correspondences[node.name]
		if node.name then
			engine.set_node(pos, node)
		end
	end
})

--
-- Register a craft to copy the metadata of items
--

function default.register_craft_metadata_copy(ingredient, result)
	engine.register_craft({
		type = "shapeless",
		output = result,
		recipe = {ingredient, result}
	})

	engine.register_on_craft(function(itemstack, player, old_craft_grid, craft_inv)
		if itemstack:get_name() ~= result then
			return
		end

		local original
		local index
		for i = 1, #old_craft_grid do
			if old_craft_grid[i]:get_name() == result then
				original = old_craft_grid[i]
				index = i
			end
		end
		if not original then
			return
		end
		local copymeta = original:get_meta():to_table()
		itemstack:get_meta():from_table(copymeta)
		-- put the book with metadata back in the craft grid
		craft_inv:set_stack("craft", index, original)
	end)
end

--
-- Log API / helpers
--

local log_non_player_actions = engine.settings:get_bool("log_non_player_actions", false)

local is_pos = function(v)
	return type(v) == "table" and
		type(v.x) == "number" and type(v.y) == "number" and type(v.z) == "number"
end

function default.log_player_action(player, ...)
	local msg = player:get_player_name()
	if player.is_fake_player or not player:is_player() then
		if not log_non_player_actions then
			return
		end
		msg = msg .. "(" .. (type(player.is_fake_player) == "string"
			and player.is_fake_player or "*") .. ")"
	end
	for _, v in ipairs({...}) do
		-- translate pos
		local part = is_pos(v) and engine.pos_to_string(v) or v
		-- no leading spaces before punctuation marks
		msg = msg .. (string.match(part, "^[;,.]") and "" or " ") .. part
	end
	engine.log("action",  msg)
end

function default.set_inventory_action_loggers(def, name)
	def.on_metadata_inventory_move = function(pos, from_list, from_index,
			to_list, to_index, count, player)
		default.log_player_action(player, "moves stuff in", name, "at", pos)
	end
	def.on_metadata_inventory_put = function(pos, listname, index, stack, player)
		default.log_player_action(player, "moves", stack:get_name(), "to", name, "at", pos)
	end
	def.on_metadata_inventory_take = function(pos, listname, index, stack, player)
		default.log_player_action(player, "takes", stack:get_name(), "from", name, "at", pos)
	end
end

--
-- NOTICE: This method is not an official part of the API yet.
-- This method may change in future.
--

function default.can_interact_with_node(player, pos)
	if player and player:is_player() then
		if engine.check_player_privs(player, "protection_bypass") then
			return true
		end
	else
		return false
	end

	local meta = engine.get_meta(pos)
	local owner = meta:get_string("owner")

	if not owner or owner == "" or owner == player:get_player_name() then
		return true
	end

	-- Is player wielding the right key?
	local item = player:get_wielded_item()
	if engine.get_item_group(item:get_name(), "key") == 1 then
		local key_meta = item:get_meta()

		if key_meta:get_string("secret") == "" then
			local key_oldmeta = item:get_metadata()
			if key_oldmeta == "" or not engine.parse_json(key_oldmeta) then
				return false
			end

			key_meta:set_string("secret", engine.parse_json(key_oldmeta).secret)
			item:set_metadata("")
		end

		return meta:get_string("key_lock_secret") == key_meta:get_string("secret")
	end

	return false
end

--
-- Things that bugged out
--

function default.get_hotbar_bg(x,y)
	local out = ""
	for i=0,8,1 do
		out = out .."image["..x+i..",8;1,1;gui_hb_bg.png]"
	end
	return out
end