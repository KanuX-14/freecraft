dofile(minetest.get_modpath("player_api") .. "/api.lua")

minetest.register_entity("player_api:wielded_item", player_api.create_dummy())

local function tobool(char)
	local bool = false
	if (char == "true") then
		bool = true
	elseif not (char == "false") then
		return nil
	end
	return bool
end

-- Default player appearance
player_api.register_model("character.b3d", {
	animation_speed = 30,
	textures = {"character.png"},
	animations = {
		-- Standard animations.
		-- Stand --
		stand     		= 		{x = 0,   y = 79},
		-- Walk --
		walk      		= 		{x = 80, y = 99},
		walk_mine 		= 		{x = 100, y = 119},
		-- Run --
		sprint      	= 		{x = 120, y = 139},
		sprint_mine 	= 		{x = 140, y = 159},
		-- -- Mine --
		mine      		= 		{x = 160, y = 179},
		-- -- Duck --
		duck       		= 		{x = 180,  y = 259, eye_height = 1.2, 	override_local = true, 	collisionbox = {-0.2, 0.0, -0.2, 0.2, 1.2, 0.2}},
		duck_mine       = 		{x = 260,  y = 279, eye_height = 1.2, 	override_local = true, 	collisionbox = {-0.2, 0.0, -0.2, 0.2, 1.2, 0.2}},
		duck_walk  		= 		{x = 280,  y = 299, eye_height = 1.2, 	override_local = true, 	collisionbox = {-0.2, 0.0, -0.2, 0.2, 1.2, 0.2}},
		duck_walk_mine	= 		{x = 300,  y = 319, eye_height = 1.2, 	override_local = true, 	collisionbox = {-0.2, 0.0, -0.2, 0.2, 1.2, 0.2}},
		-- -- Prone --
		prone	       	= 		{x = 320, y = 320, 	eye_height = 0.3, 	override_local = true, 	collisionbox = {-0.2, 0.0, -0.2, 0.2, 0.3, 0.2}},
		prone_walk      = 		{x = 320, y = 334, 	eye_height = 0.3, 	override_local = true, 	collisionbox = {-0.2, 0.0, -0.2, 0.2, 0.3, 0.2}},
		prone_mine	    = 		{x = 335, y = 354, 	eye_height = 0.3, 	override_local = true, 	collisionbox = {-0.2, 0.0, -0.2, 0.2, 0.3, 0.2}},
		prone_walk_mine	= 		{x = 355, y = 369, 	eye_height = 0.3, 	override_local = true, 	collisionbox = {-0.2, 0.0, -0.2, 0.2, 0.3, 0.2}},
		-- -- Swim --
		swim	       	= 		{x = 370, y = 389, 	eye_height = 0.3, 	override_local = true, 	collisionbox = {-0.2, 0.0, -0.2, 0.2, 0.3, 0.2}},
		-- -- Sit --
		sit       		= 		{x = 390, y = 469, 	eye_height = 0.8, 	override_local = true, 	collisionbox = {-0.3, 0.0, -0.3, 0.3, 0.9, 0.3}},
		-- -- Lay --
		lay       		= 		{x = 470, y = 470, 	eye_height = 0.3, 	override_local = true, 	collisionbox = {-0.6, 0.0, -0.6, 0.6, 0.3, 0.6}}
	},
	collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
	stepheight = 0.6,
	eye_height = 1.47,
})

-- Update player variables when joined
minetest.register_on_joinplayer(function(player)
	player_api.set_model(player, "character.b3d")
	player_physics 			= 	player:get_physics_override()
	player_fov 				= 	player:get_fov()
	player_api.set_player_metadata(player, "has_wield", "false")

	player:hud_add({
		hud_elem_type = "text",
		position      = {x = 0, y = 0},
		offset        = {x = (2.5*24),   y = (39.5*24)},
		text          = "FreeCraft v0.1.1",
		alignment     = {x = 0, y = 0},
		scale         = {x = 100, y = 100},
		number		  = 0xFFFFFF,
   	})

	minetest.hud_replace_builtin("breath", {
		hud_elem_type = "statbar",
		position = {x = 0.5, y = 1},
		text = "bubble.png",
		number = player:get_breath() + 10,
		direction = 1,
		size = {x = 24, y = 24},
		offset = {x = (10*24), y = -(48 + 48 + 16)}     
	})

	player:hud_add({
		hud_elem_type = "statbar",
		position = {x = 0.5, y = 1},
		text = "heart_background.png",
		number = core.PLAYER_MAX_HP_DEFAULT or 20,
		direction = 0,
		size = {x = 24, y = 24},
		offset = {x = (-10*24) - 25, y = -(48 + 24 + 16)}     
	})

	player:hud_add({
		hud_elem_type = "statbar",
		position = {x = 0.5, y = 1},
		text = "hunger_background.png",
		number = 20,
		direction = 1,
		size = {x = 24, y = 24},
		offset = {x = (10*24), y = -(48 + 24 + 16)}     
	})

	saturation_hud = player:hud_add({
		hud_elem_type = "statbar",
		position = {x = 0.5, y = 1},
		text = "hunger.png",
		number = saturation or 20,
		direction = 1,
		size = {x = 24, y = 24},
		offset = {x = (10*24), y = -(48 + 24 + 16)}     
	})
end)

-- Increase player's saturation. Yummy P:
minetest.register_on_item_eat(function(hp_change, replace_with_item, itemstack, user, pointed_thing)
	local item = itemstack:get_name()
	if (item == "default:apple") then
		player_api.saturation(user, 2)
	elseif (item == "default:blueberries") then
		player_api.saturation(user, 2)
	elseif (item == "farming:bread") then
		player_api.saturation(user, 5)
	end
end)

-- Update player's information
minetest.register_globalstep(function(dtime)
	for _, player in ipairs(minetest.get_connected_players()) do
		local name 				= 	player:get_player_name()
		local pos 				=  	player:get_pos()
		local vec 				=  	player:get_velocity()
		local controls 			= 	player:get_player_control()
		local physics 			= 	player:get_physics_override()
		local fov 				= 	player_fov
		local vertical_look 	= 	-math.deg(player:get_look_vertical())
		local horizontal_look 	= 	-math.deg(player:get_look_horizontal())
		local health			=	player:get_hp()
		local wield			 	= 	{bone = "Arm_Right", pos = {x=0, y=5.5, z=3}, rot = {x=-90, y=225, z=90}, scale = {x=0.225, y=0.225}}
		local isWalking			=	tobool(player_api.get_player_metadata(player, "isWalking"))
		local isRunning			=	tobool(player_api.get_player_metadata(player, "isRunning"))
		local isBlockedAbove	=	tobool(player_api.get_player_metadata(player, "isBlockedAbove"))
		local onWater			=	tobool(player_api.get_player_metadata(player, "onWater"))
		local onDuck			=	tobool(player_api.get_player_metadata(player, "onDuck"))
		local onProne			=	tobool(player_api.get_player_metadata(player, "onProne"))
		local isDashing			=	tobool(player_api.get_player_metadata(player, "isDashing"))
		local has_wield			=	tobool(player_api.get_player_metadata(player, "has_wield"))
		local saturation		=	tonumber(player_api.get_player_metadata(player, "saturation"))
		local saturation_timer	=	tonumber(player_api.get_player_metadata(player, "saturation_timer"))

		-- Extra check to minimize 'if' usage, since Lua does not have switch().
		if (isWalking == nil) and (isRunning == nil) and (isBlockedAbove == nil) and
		   (onWater == nil) and (onProne == nil) and (isDashing == nil) and
		   (saturation == nil) and (saturation_timer == nil) then
			if (isWalking == nil) then
				isWalking = false
			end
			if (isRunning == nil) then
				isRunning = false
			end
			if (isBlockedAbove == nil) then
				isBlockedAbove = false
			end
			if (onWater == nil) then
				onWater = false
			end
			if (onProne == nil) then
				onProne = false
			end
			if (isDashing == nil) then
				isDashing = false
			end
			if (saturation == nil) then
				saturation = 20
			end
			if (saturation_timer == nil) then
				saturation_timer = 350
			end
		end

		-- Check if position/rotation/nodes are nil
		if (pos == nil) then return end
		-- If position exists, change it's level
		pos.y = math.floor(pos.y) + 1
		local node = minetest.get_node_or_nil(pos)
		local under_node = minetest.get_node_or_nil({x=pos.x, y=pos.y-1, z=pos.z})
		local above_node = minetest.get_node_or_nil({x=pos.x, y=pos.y+1, z=pos.z})
		if not node then return end
		if not under_node then return end
		if not above_node then return end

		-- Update player physics
		if node.name == "default:ladder_wood" or under_node.name == "default:ladder_wood" then
			if not controls.jump and not controls.sneak then
				player:add_velocity({x=0, y=-0.7, z=0})
			end
		elseif minetest.get_item_group(node.name, "water") > 0 or minetest.get_item_group(under_node.name, "water") > 0 then
			onWater = true
			if minetest.get_item_group(above_node.name, "water") > 0 then
				isBlockedAbove = true
				onProne = true
			else
				isBlockedAbove = false
				onProne = false
			end
		else
			isBlockedAbove = false
			onWater = false
		end
		
		-- Handle player controls
		if controls.up or controls.down or controls.left or controls.right and not controls.sneak and not controls.aux1 and not controls.zoom then
			if onWater then
				physics.speed = 0.7
			end
			isWalking = true
		else
			isWalking = false
		end
		-- if not isDashing and controls.up and controls.aux1 and controls.jump then
		-- 	local xVec = math.ceil(vec.x / 10)
		-- 	local zVec = math.ceil(vec.z / 10)
		-- 	if (vec.x > 0) then
		-- 		player:add_velocity({x=xVec, y=0, z=0})
		-- 	else
		-- 		player:add_velocity({x=-(xVec), y=0, z=0})
		-- 	end
		-- 	if (vec.z > 0) then
		-- 		player:add_velocity({x=0, y=0, z=zVec})
		-- 	else
		-- 		player:add_velocity({x=0, y=0, z=-(zVec)})
		-- 	end
		-- 	isDashing = true
		-- elseif isDashing and under_node.name == "air" then
		-- 	isDashing = false
		-- end
		if controls.aux1 and controls.up and not controls.down and not (saturation <= 5) then
			if onWater and not onProne then
				physics.speed = 0.9
			elseif onWater and onProne then
				physics.speed = 1.2
			elseif not onWater and not onProne then
				physics.speed = 1.5
				fov = 90
			end
			if not onProne then
				isRunning = true
			end
			saturation_timer = saturation_timer - 3
		elseif controls.sneak and not controls.aux1 and not controls.zoom then
			if not onWater then
				physics.speed = 0.7
			else
				physics.speed = 0.5
			end
			if not onProne then
				onDuck = true
			end
		elseif controls.zoom or controls.aux2 and not controls.aux1 then
			if not onWater then
				physics.speed = 0.5
			else
				physics.speed = 0.7
			end
			onProne = true
		elseif not (above_node.name == "air") and onDuck then
				physics.speed = 0.7
			isBlockedAbove = true
		elseif not (above_node.name == "air") and onProne then
				physics.speed = 0.5
			isBlockedAbove = true
		else
			isRunning = false
			onDuck = false
			onProne = false
		end

		-- Handle health
		if (health == 0) then
			saturation_timer = saturation_timer - 50
		elseif (health < 20) then
			saturation_timer = saturation_timer - 3
		end

		-- Calculate saturation
		if (saturation_timer <= 0) then
			saturation_timer = 350
			if not (saturation <= 0) then
				saturation = saturation - 1
			end
			if (saturation == 0) then
				health = health - 1
			elseif (health < 20) then
				health = health + 1
			end
		end
		player:hud_change(saturation_hud, "number", saturation)
		player:set_hp(health)

		-- Apply motion values
		if isRunning then
			player:set_physics_override(physics)
			player:set_fov(fov, false, 1)
			saturation_timer = saturation_timer - 1
 		else
			if onWater or onDuck or onProne or isBlockedAbove then
				player:set_physics_override(physics)
			else
				player:set_physics_override(player_physics)
			end
			player:set_fov(player_fov, false, 1)
		end

		-- Set the Y degree
		local bufferDegree
		if controls.left then
			bufferDegree = -30
		elseif controls.right then
			bufferDegree = 30
		else
			bufferDegree = 0
		end

		-- Move body after the head
		if onDuck then
			player:set_bone_position("Body", {x = 0, y = 6.25, z = 0}, {x = -20, y = bufferDegree+180, z = 0})
		elseif onProne or onWater then
			player:set_bone_position("Body", {x = 0, y = 1.25, z = 0}, {x = -90, y = bufferDegree+180, z = 0})
		else
			player:set_bone_position("Body", {x = 0, y = 6.25, z = 0}, {x = 0, y = bufferDegree, z = 0})
		end

		-- Look to camera animation
		if onDuck then
			player:set_bone_position("Head", {x = 0, y = 6.25, z = 0}, {x = vertical_look + 20, y = -(bufferDegree), z = -(bufferDegree)/3})
		elseif onProne or isBlockedAbove then
			player:set_bone_position("Head", {x = 0, y = 6.25, z = 0}, {x = vertical_look + 90, y = -(bufferDegree), z = -(bufferDegree)})
		else
			player:set_bone_position("Head", {x = 0, y = 6.25, z = 0}, {x = vertical_look, y = -(bufferDegree), z = 0})
		end

		-- Render item on hand
		if not has_wield then
			object = minetest.add_entity(pos, "player_api:wielded_item", name)
			has_wield = true
		else
			local playerStack = player:get_wielded_item()
			local itemName = playerStack:get_name()
			local size = wield.scale
			if (itemName == "") then
				size = {x=0,y=0}
			end
			object:set_attach(player, wield.bone, wield.pos, wield.rot)
			object:set_properties({
				collisionbox = {-0.125,-0.125,-0.125,0.125,0.125,0.125},
				textures = {itemName},
				visual_size = size,
			})
		end

		-- Save variables
		player_api.set_player_metadata(player, "isWalking", isWalking)
		player_api.set_player_metadata(player, "isRunning", isRunning)
		player_api.set_player_metadata(player, "isBlockedAbove", isBlockedAbove)
		player_api.set_player_metadata(player, "onWater", onWater)
		player_api.set_player_metadata(player, "onDuck", onDuck)
		player_api.set_player_metadata(player, "onProne", onProne)
		player_api.set_player_metadata(player, "isDashing", isDashing)
		player_api.set_player_metadata(player, "has_wield", has_wield)
		player_api.set_player_metadata(player, "saturation", saturation)
		player_api.set_player_metadata(player, "saturation_timer", saturation_timer)
	end
end)