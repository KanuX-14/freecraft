local function can_dig(pos, player)
	local meta = minetest.get_meta(pos);
	local inv = meta:get_inventory()
	return inv:is_empty("main")
end

-- Acacia Workbench
minetest.register_node("default:acacia_workbench", {
	description = "A indispensable block.",
	tiles = {
		"default_acacia_workbench_top.png",
		"default_acacia_wood.png",
		"default_acacia_workbench_side.png"
	},
	groups = {workbench = 1, choppy = 2, oddly_breakable_by_hand = 2},
	sounds = default.node_sound_wood_defaults(),
	paramtype2 = "facedir",
	can_dig = can_dig,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "Workbench")
		meta:set_string("formspec", "size[9,9]"..
						"list[context;input;1.75,0.5;3,3;]"..
						"list[current_player;craftpreview;5.75,1.5;1,1;]"..
						"list[current_player;main;0,8;9,1;]"..
						"list[current_player;main;0,5;9,3;9]"..
						"image[4.75,1.5;1,1;sfinv_crafting_arrow.png]"..
						"listring[current_player;main]"..
						"listring[current_player;craft]")
	end,

})

minetest.register_craft({
	output = "default:acacia_workbench",
	recipe = {
		{"default:acacia_wood", "default:acacia_wood"},
		{"default:acacia_wood", "default:acacia_wood"},
	}
})

-- Aspen Workbench
minetest.register_node("default:aspen_workbench", {
	description = "A indispensable block.",
	tiles = {
		"default_aspen_workbench_top.png",
		"default_aspen_wood.png",
		"default_aspen_workbench_side.png"
	},
	groups = {workbench = 1, choppy = 2, oddly_breakable_by_hand = 2},
	sounds = default.node_sound_wood_defaults(),
	paramtype2 = "facedir",
	can_dig = can_dig,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "Workbench")
		meta:set_string("formspec", "size[9,9]"..
						"list[current_player;craft;1.75,0.5;3,3;]"..
						"list[current_player;craftpreview;5.75,1.5;1,1;]"..
						"list[current_player;main;0,8;9,1;]"..
						"list[current_player;main;0,5;9,3;9]"..
						"image[4.75,1.5;1,1;sfinv_crafting_arrow.png]"..
						"listring[current_player;main]"..
						"listring[current_player;craft]")
	end,

})

minetest.register_craft({
	output = "default:aspen_workbench",
	recipe = {
		{"default:aspen_wood", "default:aspen_wood"},
		{"default:aspen_wood", "default:aspen_wood"},
	}
})

-- Jungle Workbench
minetest.register_node("default:jungle_workbench", {
	description = "A indispensable block.",
	tiles = {
		"default_jungle_workbench_top.png",
		"default_junglewood.png",
		"default_jungle_workbench_side.png"
	},
	groups = {workbench = 1, choppy = 2, oddly_breakable_by_hand = 2},
	sounds = default.node_sound_wood_defaults(),
	paramtype2 = "facedir",
	can_dig = can_dig,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "Workbench")
		meta:set_string("formspec", "size[9,9]"..
						"list[current_player;craft;1.75,0.5;3,3;]"..
						"list[current_player;craftpreview;5.75,1.5;1,1;]"..
						"list[current_player;main;0,8;9,1;]"..
						"list[current_player;main;0,5;9,3;9]"..
						"image[4.75,1.5;1,1;sfinv_crafting_arrow.png]"..
						"listring[current_player;main]"..
						"listring[current_player;craft]")
	end,

})

minetest.register_craft({
	output = "default:jungle_workbench",
	recipe = {
		{"default:junglewood", "default:junglewood"},
		{"default:junglewood", "default:junglewood"},
	}
})

-- Pine Workbench
minetest.register_node("default:pine_workbench", {
	description = "A indispensable block.",
	tiles = {
		"default_pine_workbench_top.png",
		"default_pine_wood.png",
		"default_pine_workbench_side.png"
	},
	groups = {workbench = 1, choppy = 2, oddly_breakable_by_hand = 2},
	sounds = default.node_sound_wood_defaults(),
	paramtype2 = "facedir",
	can_dig = can_dig,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "Workbench")
		meta:set_string("formspec", "size[9,9]"..
						"list[current_player;craft;1.75,0.5;3,3;]"..
						"list[current_player;craftpreview;5.75,1.5;1,1;]"..
						"list[current_player;main;0,8;9,1;]"..
						"list[current_player;main;0,5;9,3;9]"..
						"image[4.75,1.5;1,1;sfinv_crafting_arrow.png]"..
						"listring[current_player;main]"..
						"listring[current_player;craft]")
	end,

})

minetest.register_craft({
	output = "default:pine_workbench",
	recipe = {
		{"default:pine_wood", "default:pine_wood"},
		{"default:pine_wood", "default:pine_wood"},
	}
})

-- Apple Tree Workbench
minetest.register_node("default:workbench", {
	description = "A indispensable block.",
	tiles = {
		"default_workbench_top.png",
		"default_wood.png",
		"default_workbench_side.png"
	},
	groups = {workbench = 1, choppy = 2, oddly_breakable_by_hand = 2},
	sounds = default.node_sound_wood_defaults(),
	paramtype2 = "facedir",
	can_dig = can_dig,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "Workbench")
		meta:set_string("formspec", "size[9,9]"..
						"list[current_player;craft;1.75,0.5;3,3;]"..
						"list[current_player;craftpreview;5.75,1.5;1,1;]"..
						"list[current_player;main;0,8;9,1;]"..
						"list[current_player;main;0,5;9,3;9]"..
						"image[4.75,1.5;1,1;sfinv_crafting_arrow.png]"..
						"listring[current_player;main]"..
						"listring[current_player;craft]")
	end,
})

minetest.register_craft({
	output = "default:workbench",
	recipe = {
		{"default:wood", "default:wood"},
		{"default:wood", "default:wood"},
	}
})