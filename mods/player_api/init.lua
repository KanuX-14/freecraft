dofile(minetest.get_modpath("player_api") .. "/api.lua")

-- Default player appearance
player_api.register_model("character.b3d", {
	animation_speed = 30,
	textures = {"character.png"},
	animations = {
		-- Standard animations.
		stand     		= 		{x = 0,   y = 79},
		lay       		= 		{x = 162, y = 166, 	eye_height = 0.3, 	override_local = true, 	collisionbox = {-0.6, 0.0, -0.6, 0.6, 0.3, 0.6}},
		walk      		= 		{x = 168, y = 187},
		mine      		= 		{x = 189, y = 198},
		walk_mine 		= 		{x = 200, y = 219},
		sit       		= 		{x = 81,  y = 160, 	eye_height = 0.8, 	override_local = true, 	collisionbox = {-0.3, 0.0, -0.3, 0.3, 0.9, 0.3}},
		duck       		= 		{x = 221,  y = 221, eye_height = 1.2, 	override_local = true, 	collisionbox = {-0.2, 0.0, -0.2, 0.2, 1.2, 0.2}},
		duck_walk  		= 		{x = 226,  y = 236, eye_height = 1.2, 	override_local = true, 	collisionbox = {-0.2, 0.0, -0.2, 0.2, 1.2, 0.2}},
		duck_walk_mine	= 		{x = 200,  y = 219, eye_height = 1.2, 	override_local = true, 	collisionbox = {-0.2, 0.0, -0.2, 0.2, 1.2, 0.2}},
		prone	       	= 		{x = 242, y = 242, 	eye_height = 0.3, 	override_local = true, 	collisionbox = {-0.2, 0.0, -0.2, 0.2, 0.3, 0.2}},
		prone_walk      = 		{x = 242, y = 262, 	eye_height = 0.3, 	override_local = true, 	collisionbox = {-0.2, 0.0, -0.2, 0.2, 0.3, 0.2}}
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
		local node = minetest.get_node(pos)
		local under_node = minetest.get_node(pos)
		local above_node = minetest.get_node(pos)
		local controls = player:get_player_control()
		local physics = player:get_physics_override()
		local ldeg = -math.deg(player:get_look_vertical())
		local lastdir = {}

		-- Check if position/nodes are nil
		if pos == nil then
			return
		end
		if not node then
			return
		end
		if not under_node then
			return
		end
		if not above_node then
			return
		end

		-- LoneWorfHT function with some changes (https://github.com/LoneWolfHT/headanim)
		-- Look to camera animation
		if math.abs((lastdir[name] or 0) - ldeg) > 4 then
			lastdir[name] = ldeg
			if onDuck then
				player:set_bone_position("Head", {x = 0, y = 6.25, z = 0}, {x = ldeg + 20, y = 0, z = 0})
			elseif onProne then
				player:set_bone_position("Head", {x = 0, y = 6.25, z = 0}, {x = ldeg + 90, y = 0, z = 0})
			else
				player:set_bone_position("Head", {x = 0, y = 6.25, z = 0}, {x = ldeg, y = 0, z = 0})
			end
		end

		under_node = minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z})
		above_node = minetest.get_node({x=pos.x, y=pos.y+1, z=pos.z})

		-- Update player physics
		if node.name == "default:ladder_wood" or under_node.name == "default:ladder_wood" then
			if not controls.jump then
				pos.y = pos.y - 0.07
				player:set_pos(pos)
			end
		elseif minetest.get_item_group(node.name, "water") > 0 or minetest.get_item_group(under_node.name, "water") > 0 then
			physics.speed = 0.7
			isBlockedAbove = true
			onWater = true
			if minetest.get_item_group(node.name, "water") > 0 then
				onProne = true
			end
		else
			isBlockedAbove = false
			onWater = false
		end
		
		-- Handle player controls
		if controls.aux1 and controls.up and not controls.down then
			if onWater and not onProne then
				physics.speed = 0.9
			elseif onWater and onProne then
				physics.speed = 1.2
			elseif not onWater and not onProne then
				physics.speed = 1.5
				fov = 110
				isRunning = true
			end
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
	end
end)

minetest.register_on_leaveplayer(function(player)
	lastdir[player:get_player_name()] = nil
end)