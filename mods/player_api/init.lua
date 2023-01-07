-- player_api/init.lua

dofile(engine.get_modpath("player_api") .. "/api.lua")

engine.register_entity("player_api:wielded_item", player_api.create_dummy())

local function tobool(char)
	if (char == "true") then return true
	elseif (char == "false") then return false
	else return nil end
end

-- Default player appearance
player_api.register_model("character.b3d", {
	animation_speed = 30,
	textures = {"character.png"},
	animations = {
		-- Stand --
		stand     		= 		{x = 0,   y = 79},
		-- Walk --
		walk      		= 		{x = 80, y = 99},
		walk_mine 		= 		{x = 100, y = 119},
		-- Run --
		sprint      	= 		{x = 120, y = 139},
		sprint_mine 	= 		{x = 140, y = 159},
		-- Mine --
		mine      		= 		{x = 160, y = 179},
		-- Duck --
		duck       		= 		{x = 180,  y = 259, eye_height = 1.2, 	override_local = true, 	collisionbox = {-0.2, 0.0, -0.2, 0.2, 1.2, 0.2}},
		duck_mine       = 		{x = 260,  y = 279, eye_height = 1.2, 	override_local = true, 	collisionbox = {-0.2, 0.0, -0.2, 0.2, 1.2, 0.2}},
		duck_walk  		= 		{x = 280,  y = 299, eye_height = 1.2, 	override_local = true, 	collisionbox = {-0.2, 0.0, -0.2, 0.2, 1.2, 0.2}},
		duck_walk_mine	= 		{x = 300,  y = 319, eye_height = 1.2, 	override_local = true, 	collisionbox = {-0.2, 0.0, -0.2, 0.2, 1.2, 0.2}},
		-- Prone --
		prone	       	= 		{x = 320, y = 320, 	eye_height = 0.3, 	override_local = true, 	collisionbox = {-0.2, 0.0, -0.2, 0.2, 0.3, 0.2}},
		prone_walk      = 		{x = 320, y = 334, 	eye_height = 0.3, 	override_local = true, 	collisionbox = {-0.2, 0.0, -0.2, 0.2, 0.3, 0.2}},
		prone_mine	    = 		{x = 335, y = 354, 	eye_height = 0.3, 	override_local = true, 	collisionbox = {-0.2, 0.0, -0.2, 0.2, 0.3, 0.2}},
		prone_walk_mine	= 		{x = 355, y = 369, 	eye_height = 0.3, 	override_local = true, 	collisionbox = {-0.2, 0.0, -0.2, 0.2, 0.3, 0.2}},
		-- Swim --
		swim	       	= 		{x = 370, y = 389, 	eye_height = 0.3, 	override_local = true, 	collisionbox = {-0.2, 0.0, -0.2, 0.2, 0.3, 0.2}},
		-- Sit --
		sit       		= 		{x = 390, y = 469, 	eye_height = 0.8, 	override_local = true, 	collisionbox = {-0.3, 0.0, -0.3, 0.3, 0.9, 0.3}},
		-- Lay --
		lay       		= 		{x = 470, y = 470, 	eye_height = 0.3, 	override_local = true, 	collisionbox = {-0.6, 0.0, -0.6, 0.6, 0.3, 0.6}}
	},
	collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
	stepheight = 0.6,
	eye_height = 1.47,
})

-- Update player variables when joined
engine.register_on_joinplayer(function(player)
	player_api.set_model(player, "character.b3d")
	player_api.set_player_metadata(player, "has_wield", "false")

	player:hud_add({
		hud_elem_type	=	"text",
		position      	=	{x = 0,		y = 0.98},
		offset        	=	{x = 10,	y = -10},
		scale         	=	{x = 100,	y = 100},
		alignment		=	{x = 1,		y = 1},
		direction		=	0,
		text          	=	default.get_version(engine),
		number		  	=	0xFFFFFF
   	})

	player:hud_add({
		hud_elem_type	=	"statbar",
		position		=	{x = 0.5, y = 1},
		offset			=	{x = (-10*24) - 25, y = -(48 + 24 + 16)},
		size			=	{x = 24, y = 24},
		direction		=	0,
		text			=	"heart_background.png",
		number			=	core.PLAYER_MAX_HP_DEFAULT or 20
	})

	engine.hud_replace_builtin("breath", {
		hud_elem_type	=	"statbar",
		position		=	{x = 0.5, y = 1},
		offset			=	{x = (-10*24) - 25, y = -(48 + 48 + 16)},
		size			=	{x = 24, y = 24},
		direction		=	0,
		text			=	"bubble.png",
		number			=	player:get_breath() * 2
	})

	player:hud_add({
		hud_elem_type	=	"statbar",
		position		=	{x = 0.5, y = 1},
		offset			=	{x = (10*24), y = -(48 + 24 + 16)},
		size			=	{x = 24, y = 24},
		direction		=	1,
		text			=	"hunger_background.png",
		number			=	20
	})

	saturation_hud = player:hud_add({
		hud_elem_type	=	"statbar",
		position		=	{x = 0.5, y = 1},
		offset			=	{x = (10*24), y = -(48 + 24 + 16)},
		size			=	{x = 24, y = 24},
		direction		=	1,
		text			=	"hunger.png",
		number			=	saturation or 20
	})

	player:hud_add({
		hud_elem_type	=	"statbar",
		position		=	{x = 0.5, y = 1},
		offset			=	{x = (10*24), y = -(48 + 48 + 16)},
		size			=	{x = 24, y = 24},
		direction		=	1,
		text			=	"thirst_background.png",
		number			=	20
	})

	thirst_hud = player:hud_add({
		hud_elem_type	=	"statbar",
		position		=	{x = 0.5, y = 1},
		offset			=	{x = (10*24), y = -(48 + 48 + 16)},
		size			=	{x = 24, y = 24},
		direction		=	1,
		text			=	"thirst.png",
		number			=	thirst or 20
	})
end)

-- Increase player's saturation. Yummy P:
engine.register_on_item_eat(function(hp_change, replace_with_item, itemstack, user, pointed_thing)
	local pos = user:get_pos()
	local saturation = tonumber(player_api.get_player_metadata(user, "saturation"))
	local thirst = tonumber(player_api.get_player_metadata(user, "thirst"))
	local item = itemstack:get_name()
	local item_count = itemstack:get_count()
	local item_group = {
		saturation = engine.get_item_group(item, "food"),
		thirst = engine.get_item_group(item, "water")
	}
	local pitch = default.random_pitch()
	local hasUsed = false
	if (item_group.saturation > 0) and (saturation ~= 20) then
		player_api.saturation(user, item_group.saturation)
		if (item == "default:apple") then engine.sound_play("default_apple_bite", {pos=pos, max_hear_distance=8, gain=1.0, pitch=pitch})
		else engine.sound_play("default_eat", {pos=pos, max_hear_distance=8, gain=1.0, pitch=pitch}) end
		hasUsed = true
	end
	if (item_group.thirst > 0) and (thirst ~= 20) then
		player_api.thirst(user, item_group.thirst)
		if (item == "default:apple") then engine.sound_play("default_apple_bite", {pos=pos, max_hear_distance=8, gain=1.0, pitch=pitch}) end
		hasUsed = true
	end
	if not hasUsed then itemstack:set_count(item_count+1) end
end)

-- Update player's information
engine.register_globalstep(function(dtime)
	for _, player in ipairs(engine.get_connected_players()) do
		local name 				= 	player:get_player_name()
		local pos 				=  	default.get_real_entity_position(player)
		local vec 				=  	player:get_velocity()
		local controls 			= 	player:get_player_control()
		local physics 			= 	player:get_physics_override()
		local fov 				= 	player:get_fov()
		local animation			=	player_api.get_animation(player)
		local vertical_look 	= 	-math.deg(player:get_look_vertical())
		local horizontal_look 	= 	-math.deg(player:get_look_horizontal())
		local health			=	player:get_hp()
		local wield			 	= 	{bone = "Arm_Right", pos = {x=0, y=5.5, z=3}, rot = {x=-90, y=225, z=90}, scale = {x=0.225, y=0.225}}
		local isWalking			=	tobool(player_api.get_player_metadata(player, "isWalking")) or false
		local isRunning			=	tobool(player_api.get_player_metadata(player, "isRunning")) or false
		local isBlockedAbove	=	tobool(player_api.get_player_metadata(player, "isBlockedAbove")) or false
		local onWater			=	tobool(player_api.get_player_metadata(player, "onWater")) or false
		local onDuck			=	tobool(player_api.get_player_metadata(player, "onDuck")) or false
		local onProne			=	tobool(player_api.get_player_metadata(player, "onProne")) or false
		local isDashing			=	tobool(player_api.get_player_metadata(player, "isDashing")) or false
		local has_wield			=	tobool(player_api.get_player_metadata(player, "has_wield")) or false
		local saturation		=	tonumber(player_api.get_player_metadata(player, "saturation")) or 20
		local saturation_timer	=	tonumber(player_api.get_player_metadata(player, "saturation_timer")) or 700
		local thirst			=	tonumber(player_api.get_player_metadata(player, "thirst")) or 20
		local thirst_timer		=	tonumber(player_api.get_player_metadata(player, "thirst_timer")) or 1400

		local normal_physics = { speed = 1, jump = 1, gravity = 1,
								 sneak = true, sneak_glitch = false,
								 new_move = true
							   }
		physics.speed = normal_physics.speed

		-- Check if position/rotation/nodes are nil
		if not default.check_nil(pos) then return end
		pos.y					=	math.floor(pos.y)
		local node				=	engine.get_node_or_nil(pos)
		local under_node		=	engine.get_node_or_nil({x=pos.x, y=pos.y-1, z=pos.z})
		local above_node		=	engine.get_node_or_nil({x=pos.x, y=pos.y+1, z=pos.z})
		if not default.check_nil(node, under_node, above_node) then return end

		--
		-- Handle player controls
		--

		-- Walking
		if controls.up or controls.down or controls.left or controls.right and not
		   controls.sneak and not controls.aux1 and not controls.aux2 and not controls.zoom and not isBlockedAbove then
			isWalking = true
		else isWalking = false end
		-- Running
		if controls.up and controls.aux1 and not
		   controls.down and not controls.sneak and not controls.aux2 and not controls.zoom and not (saturation < 5) and not (thirst < 5) and not isBlockedAbove then
			isRunning = true
		else isRunning = false end
		-- Ducking
		if controls.sneak and not
		   controls.aux1 and not controls.aux2 and not controls.zoom then
			onDuck = true
		elseif not isBlockedAbove then onDuck = false end
		-- Proning
		if controls.aux2 or controls.zoom and not
		   controls.sneak and not controls.aux1 then
			onProne = true
		elseif not isBlockedAbove then onProne = false end

		--
		-- Update player physics
		--

		-- Check if on water
		if (engine.get_item_group(node.name, "water") > 0) then onWater = true
		else onWater = false end

		-- Check if under a block
		if not (above_node.name == "air") and not (engine.get_item_group(above_node.name, "water") > 0) and not (engine.get_item_group(above_node.name, "notop") > 0) then
			isBlockedAbove = true
		else isBlockedAbove = false end

		-- Update speed based on behaviour
		if not onWater then
			if isRunning then
				physics.speed = physics.speed + 0.5
				fov = 90
				saturation_timer = saturation_timer - 3
				thirst_timer = thirst_timer - 3
			elseif onDuck and not (engine.get_item_group(node.name, "ladder") > 0) then
				if not isBlockedAbove then physics.speed = physics.speed - 0.3
				else physics.speed = physics.speed - 0.7 end
			elseif onProne then physics.speed = physics.speed - 0.5 end
		else
			if isRunning then
				physics.speed = physics.speed + 0.2
				fov = 90
				saturation_timer = saturation_timer - 1
				thirst_timer = thirst_timer - 1
				player_api.apply_direction_speed(player, vertical_look)
			elseif onDuck and not (engine.get_item_group(node.name, "ladder") > 0) then
				physics.speed = physics.speed - 0.5
			else physics.speed = physics.speed - 0.1 end
		end

		--
		-- Handle player properties
		--

		-- Calculate health/saturation/thirst
		local human_needs = {
			food = {
				name = "saturation",
				hud = saturation_hud,
				value = saturation,
				timer = saturation_timer
			},
			water = {
				name = "thirst",
				hud = thirst_hud,
				value = thirst,
				timer = thirst_timer
			}
		}
		for i,resource in pairs(human_needs) do
			local timer = resource.timer

			if (health == 0) then resource.value = 0
			elseif (health < 20) and (resource.value > 5) then
				timer = timer - 1
				if (timer > 150) then timer = 150 end
			end

			if (timer <= 0) then
				if (resource.name == "saturation") then timer = 700
				else timer = 1400 end
				if (resource.value > 0) then resource.value = resource.value - 1 end
				if (resource.value == 0) then
					if (resource.name == "saturation") then health = health - 1
					else health = health - 2 end
				elseif (health < 20) and (resource.value > 5) then
					if (resource.name == "saturation") then health = health + 1
					else health = health + 2 end
				end
			end

			if (resource.name == "saturation") then
				saturation = resource.value
				saturation_timer = timer
			else
				thirst = resource.value
				thirst_timer = timer
			end

			player:hud_change(resource.hud, "number", resource.value)
		end
		player:set_hp(health)

		-- Get ride look, if there is one
		local ride_look = 0
		if (player:get_attach() ~= nil) then
			ride_look = horizontal_look+180
			if (ride_look < -80) then ride_look = -80
			elseif (ride_look > 80) then ride_look = 80 end
		end

		-- Set strafe body positioning
		local bufferDegree
		if controls.left then bufferDegree = -30
		elseif controls.right then bufferDegree = 30
		else bufferDegree = 0 end

		-- Update body/head position
		local head = {
			pos = {x=0, y=6.25, z=0},
			rot = {x=vertical_look,	y=-(bufferDegree)+ride_look, z=0}
		}
		local body = {
			pos = {x=0, y=6.25, z=0},
			rot = {x=0,	y=bufferDegree, z=0}
		}
		if not onWater then
			if onDuck then
				head.rot={x=vertical_look+20,	y=head.rot.y,			z=-(bufferDegree)/3}
				body.rot={x=-20,				y=bufferDegree+180,		z=body.rot.z}
			elseif onProne then
				body.pos={x=body.pos.x,			y=1.25,					z=body.pos.z}
				head.rot={x=vertical_look+90,	y=head.rot.y,			z=-(bufferDegree)}
				body.rot={x=-90,				y=bufferDegree+180,		z=body.rot.z}
			elseif (animation == "lay") then
				body.pos={x=body.pos.x,			y=1.25,					z=body.pos.z}
				head.rot={x=vertical_look,		y=head.rot.y,			z=head.rot.z}
				body.rot={x=90,					y=180,					z=body.rot.z}
			end
		else
			if isRunning or onProne then
				body.pos={x=body.pos.x,			y=1.25,					z=body.pos.z}
				head.rot={x=vertical_look+90,	y=head.rot.y,			z=-(bufferDegree)}
				body.rot={x=vertical_look-90,	y=bufferDegree+180,		z=body.rot.z}
			elseif onDuck then
				head.rot={x=vertical_look+20,	y=head.rot.y,			z=-(bufferDegree)/3}
				body.rot={x=-20,				y=bufferDegree+180,		z=body.rot.z}
			elseif (animation == "lay") then
				body.pos={x=body.pos.x,			y=1.25,					z=body.pos.z}
				head.rot={x=vertical_look,		y=head.rot.y,			z=head.rot.z}
				body.rot={x=90,					y=180,					z=body.rot.z}
			end
		end
		player:set_bone_position("Head", head.pos, head.rot)
		player:set_bone_position("Body", body.pos, body.rot)

		-- Render item on hand
		if not has_wield then
			object = engine.add_entity(pos, "player_api:wielded_item", name)
			has_wield = true
		else
			local playerStack = player:get_wielded_item()
			local itemName = playerStack:get_name()
			if (itemName == "") then wield.scale = {x=0, y=0} end
			object:set_attach(player, wield.bone, wield.pos, wield.rot)
			object:set_properties({
				collisionbox = {-0.125,-0.125,-0.125,0.125,0.125,0.125},
				textures = {itemName},
				visual_size = wield.scale,
			})
		end

		-- Apply motion values
		if not (animation == "lay") then
			if not (physics.speed == normal_physics.speed) then
				player:set_physics_override(physics)
				if isRunning then player:set_fov(fov, false, 1) end
			else
				player:set_physics_override(normal_physics)
				player:set_fov(0, false, 1)
			end
		end
		
		-- Save variables
		player_api.set_player_metadata(player, "isWalking", isWalking)
		player_api.set_player_metadata(player, "isRunning", isRunning)
		player_api.set_player_metadata(player, "isBlockedAbove", isBlockedAbove)
		player_api.set_player_metadata(player, "onWater", onWater)
		player_api.set_player_metadata(player, "onDuck", onDuck)
		player_api.set_player_metadata(player, "onProne", onProne)
		-- player_api.set_player_metadata(player, "isDashing", isDashing)
		player_api.set_player_metadata(player, "has_wield", has_wield)
		player_api.set_player_metadata(player, "saturation", saturation)
		player_api.set_player_metadata(player, "saturation_timer", saturation_timer)
		player_api.set_player_metadata(player, "thirst", thirst)
		player_api.set_player_metadata(player, "thirst_timer", thirst_timer)
	end
end)