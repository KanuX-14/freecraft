dofile(minetest.get_modpath("player_api") .. "/api.lua")

-- Default player appearance
player_api.register_model("character.b3d", {
	animation_speed = 30,
	textures = {"character.png"},
	animations = {
		-- Standard animations.
		stand     = {x = 0,   y = 79},
		lay       = {x = 162, y = 166, eye_height = 0.3, override_local = true,
			collisionbox = {-0.6, 0.0, -0.6, 0.6, 0.3, 0.6}},
		walk      = {x = 168, y = 187},
		mine      = {x = 189, y = 198},
		walk_mine = {x = 200, y = 219},
		sit       = {x = 81,  y = 160, eye_height = 0.8, override_local = true,
			collisionbox = {-0.3, 0.0, -0.3, 0.3, 0.9, 0.3}},
		duck       		= {x = 221,  y = 241, eye_height = 1.17, override_local = true,
			collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.4, 0.3}},
		duck_walk  		= {x = 168,  y = 187, eye_height = 1.17, override_local = true,
			collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.4, 0.3}},
		duck_walk_mine	= {x = 200,  y = 219, eye_height = 1.17, override_local = true,
			collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.4, 0.3}},
		prone       = {x = 242, y = 262, eye_height = 0.3, override_local = true,
			collisionbox = {-0.2, 0.0, -0.2, 0.2, 0.3, 0.2}}
	},
	collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
	stepheight = 0.6,
	eye_height = 1.47,
})

-- Update appearance when the player joins
minetest.register_on_joinplayer(function(player)
	player_api.set_model(player, "character.b3d")
	player_physics = 			player:get_physics_override()
	player_fov = 				player:get_fov()
end)

-- Update player's physics
minetest.register_globalstep(function(dtime)
	for _, player in ipairs(minetest.get_connected_players()) do
		local name = player:get_player_name()
		local pos =  player:get_pos()
		local vec =  player:get_velocity()
		local node = minetest.get_node(pos)
		pos.y = pos.y - 1
		local under_node = minetest.get_node(pos)
		pos.y = pos.y + 2
		local above_node = minetest.get_node(pos)

		local controls = player:get_player_control()
		local physics = player:get_physics_override()
		local ldeg = -math.deg(player:get_look_vertical())
		local lastdir = {}

		local onWater = false

		-- https://github.com/LoneWolfHT/headanim
		if math.abs((lastdir[name] or 0) - ldeg) > 4 then
			lastdir[name] = ldeg
			player:set_bone_position("Head", {x = 0, y = 6.25, z = 0}, {x = ldeg, y = 0, z = 0})
		end

		if node.name == "default:ladder_wood" or under_node.name == "default:ladder_wood" then
			if not controls.jump then
				pos.y = pos.y - 0.07
				player:set_pos(pos)
			end
		elseif minetest.get_item_group(node.name, "water") > 0 or minetest.get_item_group(under_node.name, "water") > 0 then
			physics.speed = 0.7
			onWater = true
		elseif not (above_node.name == "air" ) or controls.zoom and not controls.aux1 then
			physics.speed = 0.5
		end

		if controls.aux1 and not controls.down and not onWater then
			physics.speed = 1.5
			fov = 110
			player:set_fov(fov, false, 1)
			player:set_physics_override(physics)
		elseif controls.aux1 and not controls.down and onWater then
			physics.speed = 0.9
			fov = 110
			player:set_fov(fov, false, 1)
			player:set_physics_override(physics)
		elseif onWater or not (above_node.name == "air" ) or controls.zoom and not controls.aux1 then
			player:set_physics_override(physics)
			player:set_fov(player_fov, false, 1)
		else
			player:set_physics_override(player_physics)
			player:set_fov(player_fov, false, 1)
		end
	end
end)

minetest.register_on_leaveplayer(function(player)
	lastdir[player:get_player_name()] = nil
end)