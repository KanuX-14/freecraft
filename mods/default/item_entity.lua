-- mods/default/item_entity.lua

local builtin_item = minetest.registered_entities["__builtin:item"]

local item = {
	set_item = function(self, itemstring)
		builtin_item.set_item(self, itemstring)

		local stack = ItemStack(itemstring)
		local itemdef = minetest.registered_items[stack:get_name()]
		if itemdef and itemdef.groups.flammable ~= 0 then
			self.flammable = itemdef.groups.flammable
		end
	end,

	burn_up = function(self)
		-- disappear in a smoke puff
		local p = default.get_real_entity_position(self.object, "int")
		self.object:remove()
		minetest.sound_play("default_item_smoke", {
			pos = p,
			gain = 1.0,
			max_hear_distance = 8,
		}, true)
		minetest.add_particlespawner({
			amount = 3,
			time = 0.1,
			minpos = {x = p.x - 0.1, y = p.y + 0.1, z = p.z - 0.1 },
			maxpos = {x = p.x + 0.1, y = p.y + 0.2, z = p.z + 0.1 },
			minvel = {x = 0, y = 2.5, z = 0},
			maxvel = {x = 0, y = 2.5, z = 0},
			minacc = {x = -0.15, y = -0.02, z = -0.15},
			maxacc = {x = 0.15, y = -0.01, z = 0.15},
			minexptime = 4,
			maxexptime = 6,
			minsize = 5,
			maxsize = 5,
			collisiondetection = true,
			texture = "default_item_smoke.png"
		})
	end,

	on_step = function(self, dtime, ...)
		builtin_item.on_step(self, dtime, ...)

		local pos = default.get_real_entity_position(self.object, "int")
		local vec = self.object:get_velocity()

		-- Check if position/node are nil
		if pos == nil then return end
		local node = minetest.get_node_or_nil(pos)
		local under_node = minetest.get_node_or_nil({x=pos.x, y=pos.y-1, z=pos.z})
		if not node then return end
		if not under_node then return end

		-- Check nearest player position to pick the item
		for _, player in ipairs(minetest.get_connected_players()) do
			if (player:get_hp() > 0) then
				local player_name = player:get_player_name()
				local inv = minetest.get_inventory({type="player", name=player_name})
				local randomPitch = default.random_pitch()

				for _, object in ipairs(minetest.get_objects_inside_radius(pos, 2)) do
					if object:is_player() and inv and inv:room_for_item("main", ItemStack(self.itemstring)) then
						if (self.itemstring ~= "") and (self.age > 1) then
							inv:add_item("main", ItemStack(self.itemstring))
							minetest.sound_play("default_item_pickup", {pos=pos, max_hear_distance=3, gain=0.15, pitch=randomPitch})
							self.itemstring = ""
							self.object:remove()
						end
					end
				end
			end
		end

		if (minetest.get_item_group(node.name, "water") > 0) then
			vec.x = 0
			vec.y = 0.14
			vec.z = 0
			self.object:set_acceleration(vec)
		elseif (minetest.get_item_group(under_node.name, "water") > 0) and (minetest.get_item_group(node.name, "water") < 1) then
			vec.x = 0
			vec.y = -0.28
			vec.z = 0
			self.object:set_acceleration(vec)
		end

		if self.flammable then
			-- flammable, check for igniters every 10 s
			self.ignite_timer = (self.ignite_timer or 0) + dtime
			if (self.ignite_timer > 10) then
				self.ignite_timer = 0

				-- Immediately burn up flammable items in lava
				if minetest.get_item_group(node.name, "lava") > 0 then
					self:burn_up()
				else
					--  otherwise there'll be a chance based on its igniter value
					local burn_chance = self.flammable * minetest.get_item_group(node.name, "igniter")
					if (burn_chance > 0) and (math.random(0, burn_chance) ~= 0) then
						self:burn_up()
					end
				end
			end
		end
	end,
}

-- set defined item as new __builtin:item, with the old one as fallback table
setmetatable(item, { __index = builtin_item })
minetest.register_entity(":__builtin:item", item)
