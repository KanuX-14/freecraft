dofile(minetest.get_modpath("player_api") .. "/api.lua")

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
	isWalking				=	false
	isRunning 				= 	false
	isBlockedAbove		 	= 	false
	onWater 				= 	false
	onDuck 					= 	false
	onProne 				= 	false
end)

-- Update player's physics
minetest.register_globalstep(function(dtime)
	for _, player in ipairs(minetest.get_connected_players()) do
		local name 	= 	player:get_player_name()
		local pos 	=  	player:get_pos()
		local vec 	=  	player:get_velocity()
		local controls = player:get_player_control()
		local physics = player:get_physics_override()
		local fov = player_fov
		local vertical_look = -math.deg(player:get_look_vertical())
		local horizontal_look = -math.deg(player:get_look_horizontal())
		local lastdir = {}

		-- Check if position/nodes are nil
		if pos == nil then return end
		-- If position exists, change it's level
		pos.y = math.floor(pos.y) + 1
		local node = minetest.get_node_or_nil(pos)
		local under_node = minetest.get_node_or_nil({x=pos.x, y=pos.y-1, z=pos.z})
		local above_node = minetest.get_node_or_nil({x=pos.x, y=pos.y+1, z=pos.z})
		if not node then return end
		if not under_node then return end
		if not above_node then return end

		-- Look to camera animation
		if onDuck then
			player:set_bone_position("Head", {x = 0, y = 6.25, z = 0}, {x = vertical_look + 20, y = 0, z = 0})
		elseif onProne then
			player:set_bone_position("Head", {x = 0, y = 6.25, z = 0}, {x = vertical_look + 90, y = 0, z = 0})
		else
			player:set_bone_position("Head", {x = 0, y = 6.25, z = 0}, {x = vertical_look, y = 0, z = 0})
		end

		-- Move body after the head
		-- player:set_bone_position("Body", {x = 0, y = 6.25, z = 0}, {x = 0, y = horizontal_look, z = 0})

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
		-- if controls.jump and controls.aux1 then
		-- 	player:add_velocity({x=0, y=0, z=-1})
		-- end
		if controls.aux1 and controls.up and not controls.down then
			if onWater and not onProne then
				physics.speed = 0.9
			elseif onWater and onProne then
				physics.speed = 1.2
			elseif not onWater and not onProne then
				physics.speed = 1.5
				fov = 90
			end
			isRunning = true
		elseif controls.sneak and not controls.aux1 and not controls.zoom then
			if not onWater then
				physics.speed = 0.7
			else
				physics.speed = 0.5
			end
			onDuck = true
		elseif controls.zoom and not controls.aux1 then
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

		-- Apply motion values
		if isRunning then
			player:set_physics_override(physics)
			player:set_fov(fov, false, 1)
		else
			if onWater or onDuck or onProne or isBlockedAbove then
				player:set_physics_override(physics)
			else
				player:set_physics_override(player_physics)
			end
			player:set_fov(player_fov, false, 1)
		end

		-- Print variables for debug
		-- print("Current position", pos)
		-- print("isWalking", isWalking)
		-- print("isRunning", isRunning)
		-- print("onWater", onWater)
		-- print("onDuck", onDuck)
		-- print("onProne", onProne)
		-- print("isBlockedAbove", isBlockedAbove)
		-- print("Speed", physics.speed)
		-- print("FOV", fov)
		-- print("Current node", node.name)
		-- print("Under node", under_node.name)
		-- print("Above node", above_node.name)
		-- print("")
	end
end)

minetest.register_on_leaveplayer(function(player)
	lastdir[player:get_player_name()] = nil
end)