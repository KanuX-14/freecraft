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
		local p = self.object:get_pos()
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

		local pos = self.object:get_pos()
		local vec = self.object:get_velocity()
		local node = minetest.get_node_or_nil(pos)
		local under_node = minetest.get_node_or_nil({x=pos.x, y=pos.y-1, z=pos.z})

		-- Check if position/node are nil
		if pos == nil then
			return
		elseif not node then
			return
		elseif not under_node then
			return
		end

		if minetest.get_item_group(node.name, "water") > 0 then
			vec.x = 0
			vec.y = 0.14
			vec.z = 0
			self.object:set_acceleration(vec)
		elseif minetest.get_item_group(under_node.name, "water") > 0 and minetest.get_item_group(node.name, "water") < 1 then
			vec.x = 0
			vec.y = -1
			vec.z = 0
			self.object:set_acceleration(vec)
		end

		if self.flammable then
			-- flammable, check for igniters every 10 s
			self.ignite_timer = (self.ignite_timer or 0) + dtime
			if self.ignite_timer > 10 then
				self.ignite_timer = 0

				-- Immediately burn up flammable items in lava
				if minetest.get_item_group(node.name, "lava") > 0 then
					self:burn_up()
				else
					--  otherwise there'll be a chance based on its igniter value
					local burn_chance = self.flammable
						* minetest.get_item_group(node.name, "igniter")
					if burn_chance > 0 and math.random(0, burn_chance) ~= 0 then
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
