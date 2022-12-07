-- entity_api/functions.lua

-- Load support for FC game translation
local S = entity_api.translation

function entity_api.is_water(pos)
	local nn = minetest.get_node(pos).name
	return minetest.get_item_group(nn, "water") ~= 0
end

function entity_api.get_velocity(v, yaw, y)
	local x = -math.sin(yaw) * v
	local z =  math.cos(yaw) * v
	return {x = x, y = y, z = z}
end

function entity_api.get_v(v)
	return math.sqrt(v.x ^ 2 + v.z ^ 2)
end

function entity_api.click(entity, clicker)
	if not clicker or not clicker:is_player() then
		return
	end
	local name = clicker:get_player_name()
	if entity.driver and name == entity.driver then
		-- Cleanup happens in boat.on_detach_child
		clicker:set_detach()

		player_api.set_animation(clicker, "stand", 30)
		local pos = clicker:get_pos()
		pos = {x = pos.x, y = pos.y + 0.2, z = pos.z}
		minetest.after(0.1, function()
			clicker:set_pos(pos)
		end)
	elseif not entity.driver then
		clicker:set_attach(entity.object, "",
			{x = 0.5, y = 1, z = -3}, {x = 0, y = 0, z = 0})

		entity.driver = name
		player_api.player_attached[name] = true

		minetest.after(0.2, function()
			player_api.set_animation(clicker, "sit", 30)
		end)
		clicker:set_look_horizontal(entity.object:get_yaw())
	end
end

-- If driver leaves server while driving
function entity_api.detach_child(entity, child)
	if child and child:get_player_name() == entity.driver then
		player_api.player_attached[child:get_player_name()] = false

		entity.driver = nil
		entity.auto = false
	end
end

function entity_api.activate(entity, staticdata, dtime_s)
	entity.object:set_armor_groups({immortal = 1})
	if staticdata then
		entity.v = tonumber(staticdata)
	end
	entity.last_v = entity.v
end

function entity_api.get_staticdata(entity)
	return tostring(entity.v)
end

function entity_api.punch(entity, puncher)
	if not puncher or not puncher:is_player() or entity.removed then
		return
	end

	local name = puncher:get_player_name()
	if entity.driver and name == entity.driver then
		entity.driver = nil
		puncher:set_detach()
		player_api.player_attached[name] = false
	end
	if not entity.driver then
		entity.removed = true
		local inv = puncher:get_inventory()
		if not minetest.is_creative_enabled(name)
				or not inv:contains_item("main", "entity_api."..entity) then
			local leftover = inv:add_item("main", "entity_api."..entity)
			-- if no room in inventory add a replacement boat to the world
			if not leftover:is_empty() then
				minetest.add_item(entity.object:get_pos(), leftover)
			end
		end
		-- delay remove to ensure player is detached
		minetest.after(0.1, function()
			entity.object:remove()
		end)
	end
end

function entity_api.run(entity, dtime)
	entity.v = entity_api.get_v(entity.object:get_velocity()) * math.sign(entity.v)
	if entity.driver then
		local driver_objref = minetest.get_player_by_name(entity.driver)
		if driver_objref then
			local ctrl = driver_objref:get_player_control()
			if ctrl.up and ctrl.down then
				if not entity.auto then
					entity.auto = true
					minetest.chat_send_player(entity.driver, S("Boat cruise mode on"))
				end
			elseif ctrl.down then
				entity.v = entity.v - dtime * 2.0
				if entity.auto then
					entity.auto = false
					minetest.chat_send_player(entity.driver, S("Boat cruise mode off"))
				end
			elseif ctrl.up or entity.auto then
				entity.v = entity.v + dtime * 7.0
			end
			if ctrl.left then
				if entity.v < -0.001 then
					entity.object:set_yaw(entity.object:get_yaw() - dtime * 0.9)
				else
					entity.object:set_yaw(entity.object:get_yaw() + dtime * 0.9)
				end
			elseif ctrl.right then
				if entity.v < -0.001 then
					entity.object:set_yaw(entity.object:get_yaw() + dtime * 0.9)
				else
					entity.object:set_yaw(entity.object:get_yaw() - dtime * 0.9)
				end
			end
		end
	end
	local velo = entity.object:get_velocity(entity)
	if not entity.driver and
			entity.v == 0 and velo.x == 0 and velo.y == 0 and velo.z == 0 then
		entity.object:set_pos(entity.object:get_pos())
		return
	end
	-- We need to preserve velocity sign to properly apply drag force
	-- while moving backward
	local drag = dtime * math.sign(entity.v) * (0.01 + 0.0796 * entity.v * entity.v)
	-- If drag is larger than velocity, then stop horizontal movement
	if math.abs(entity.v) <= math.abs(drag) then
		entity.v = 0
	else
		entity.v = entity.v - drag
	end

	local p = entity.object:get_pos(entity)
	p.y = p.y - 0.5
	local new_velo
	local new_acce = {x = 0, y = 0, z = 0}
	if not entity_api.is_water(p) then
		local nodedef = minetest.registered_nodes[minetest.get_node(p).name]
		if (not nodedef) or nodedef.walkable then
			entity.v = 0
			new_acce = {x = 0, y = 1, z = 0}
		else
			new_acce = {x = 0, y = -9.8, z = 0}
		end
		new_velo = entity_api.get_velocity(entity.v, entity.object:get_yaw(),
			entity.object:get_velocity().y)
		entity.object:set_pos(entity.object:get_pos())
	else
		p.y = p.y + 1
		if entity_api.is_water(p) then
			local y = entity.object:get_velocity().y
			if y >= 5 then
				y = 5
			elseif y < 0 then
				new_acce = {x = 0, y = 20, z = 0}
			else
				new_acce = {x = 0, y = 5, z = 0}
			end
			new_velo = entity_api.get_velocity(entity.v, entity.object:get_yaw(), y)
			entity.object:set_pos(entity.object:get_pos())
		else
			new_acce = {x = 0, y = 0, z = 0}
			if math.abs(entity.object:get_velocity().y) < 1 then
				local pos = entity.object:get_pos()
				pos.y = math.floor(pos.y) + 0.5
				entity.object:set_pos(pos)
				new_velo = entity_api.get_velocity(entity.v, entity.object:get_yaw(), 0)
			else
				new_velo = entity_api.get_velocity(entity.v, entity.object:get_yaw(),
					entity.object:get_velocity().y)
				entity.object:set_pos(entity.object:get_pos())
			end
		end
	end
	entity.object:set_velocity(new_velo)
	entity.object:set_acceleration(new_acce)
end

function entity_api.get_sign(z)
	if z == 0 then
		return 0
	else
		return z / math.abs(z)
	end
end

function entity_api.manage_attachment(player, obj)
	if not player then
		return
	end
	local status = obj ~= nil
	local player_name = player:get_player_name()
	if obj and player:get_attach() == obj then
		return
	end
	player_api.player_attached[player_name] = status

	if status then
		player:set_attach(obj, "", {x=0, y=-4.5, z=0}, {x=0, y=0, z=0})
		player:set_eye_offset({x=0, y=-4, z=0},{x=0, y=-4, z=0})

		-- player_api does not update the animation
		-- when the player is attached, reset to default animation
		player_api.set_animation(player, "stand")
	else
		player:set_detach()
		player:set_eye_offset({x=0, y=0, z=0},{x=0, y=0, z=0})
	end
end

function entity_api.velocity_to_dir(v)
	if math.abs(v.x) > math.abs(v.z) then
		return {x=entity_api.get_sign(v.x), y=entity_api.get_sign(v.y), z=0}
	else
		return {x=0, y=entity_api.get_sign(v.y), z=entity_api.get_sign(v.z)}
	end
end

function entity_api.is_rail(pos, railtype)
	local node = minetest.get_node(pos).name
	if node == "ignore" then
		local vm = minetest.get_voxel_manip()
		local emin, emax = vm:read_from_map(pos, pos)
		local area = VoxelArea:new{
			MinEdge = emin,
			MaxEdge = emax,
		}
		local data = vm:get_data()
		local vi = area:indexp(pos)
		node = minetest.get_name_from_content_id(data[vi])
	end
	if minetest.get_item_group(node, "rail") == 0 then
		return false
	end
	if not railtype then
		return true
	end
	return minetest.get_item_group(node, "connect_to_raillike") == railtype
end

function entity_api.check_front_up_down(pos, dir_, check_up, railtype)
	local dir = vector.new(dir_)
	local cur

	-- Front
	dir.y = 0
	cur = vector.add(pos, dir)
	if entity_api.is_rail(cur, railtype) then
		return dir
	end
	-- Up
	if check_up then
		dir.y = 1
		cur = vector.add(pos, dir)
		if entity_api.is_rail(cur, railtype) then
			return dir
		end
	end
	-- Down
	dir.y = -1
	cur = vector.add(pos, dir)
	if entity_api.is_rail(cur, railtype) then
		return dir
	end
	return nil
end

function entity_api.get_rail_direction(pos_, dir, ctrl, old_switch, railtype)
	local pos = vector.round(pos_)
	local cur
	local left_check, right_check = true, true

	-- Check left and right
	local left = {x=0, y=0, z=0}
	local right = {x=0, y=0, z=0}
	if dir.z ~= 0 and dir.x == 0 then
		left.x = -dir.z
		right.x = dir.z
	elseif dir.x ~= 0 and dir.z == 0 then
		left.z = dir.x
		right.z = -dir.x
	end

	local straight_priority = ctrl and dir.y ~= 0

	-- Normal, to disallow rail switching up- & downhill
	if straight_priority then
		cur = self:check_front_up_down(pos, dir, true, railtype)
		if cur then
			return cur
		end
	end

	if ctrl then
		if old_switch == 1 then
			left_check = false
		elseif old_switch == 2 then
			right_check = false
		end
		if ctrl.left and left_check then
			cur = self:check_front_up_down(pos, left, false, railtype)
			if cur then
				return cur, 1
			end
			left_check = false
		end
		if ctrl.right and right_check then
			cur = self:check_front_up_down(pos, right, false, railtype)
			if cur then
				return cur, 2
			end
			right_check = true
		end
	end

	-- Normal
	if not straight_priority then
		cur = self:check_front_up_down(pos, dir, true, railtype)
		if cur then
			return cur
		end
	end

	-- Left, if not already checked
	if left_check then
		cur = entity_api.check_front_up_down(pos, left, false, railtype)
		if cur then
			return cur
		end
	end

	-- Right, if not already checked
	if right_check then
		cur = entity_api.check_front_up_down(pos, right, false, railtype)
		if cur then
			return cur
		end
	end

	-- Backwards
	if not old_switch then
		cur = entity_api.check_front_up_down(pos, {
				x = -dir.x,
				y = dir.y,
				z = -dir.z
			}, true, railtype)
		if cur then
			return cur
		end
	end

	return {x=0, y=0, z=0}
end

function entity_api.pathfinder(pos_, old_pos, old_dir, distance, ctrl,
		pf_switch, railtype)

	local pos = vector.round(pos_)
	if vector.equals(old_pos, pos) then
		return
	end

	local pf_pos = vector.round(old_pos)
	local pf_dir = vector.new(old_dir)
	distance = math.min(entity_api.path_distance_max,
		math.floor(distance + 1))

	for i = 1, distance do
		pf_dir, pf_switch = self:get_rail_direction(
			pf_pos, pf_dir, ctrl, pf_switch or 0, railtype)

		if vector.equals(pf_dir, {x=0, y=0, z=0}) then
			-- No way forwards
			return pf_pos, pf_dir
		end

		pf_pos = vector.add(pf_pos, pf_dir)

		if vector.equals(pf_pos, pos) then
			-- Success! Cart moved on correctly
			return
		end
	end
	-- Not found. Put cart to predicted position
	return pf_pos, pf_dir
end

function entity_api.register_rail(name, def_overwrite, railparams)
	local def = {
		drawtype = "raillike",
		paramtype = "light",
		sunlight_propagates = true,
		is_ground_content = false,
		walkable = false,
		selection_box = {
			type = "fixed",
			fixed = {-1/2, -1/2, -1/2, 1/2, -1/2+1/16, 1/2},
		},
		sounds = default.node_sound_metal_defaults()
	}
	for k, v in pairs(def_overwrite) do
		def[k] = v
	end
	if not def.inventory_image then
		def.wield_image = def.tiles[1]
		def.inventory_image = def.tiles[1]
	end

	if railparams then
		entity_api.railparams[name] = table.copy(railparams)
	end

	minetest.register_node(name, def)
end

function entity_api.get_rail_groups(additional_groups)
	-- Get the default rail groups and add more when a table is given
	local groups = {
		dig_immediate = 2,
		attached_node = 1,
		rail = 1,
		connect_to_raillike = minetest.raillike_group("rail")
	}
	if type(additional_groups) == "table" then
		for k, v in pairs(additional_groups) do
			groups[k] = v
		end
	end
	return groups
end