local function can_dig(pos, player)
	local meta = minetest.get_meta(pos);
	local inv = meta:get_inventory()
	return inv:is_empty("main")
end

minetest.register_node("default:workbench", {
	description = "A indispensable block.",
	tiles = {
		"default_workbench_top.png",
		"default_workbench_bottom.png",
		"default_pine_tree.png"
	},
	groups = {workbench = 1, choppy = 2},
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
		-- local inv = meta:get_inventory()
		-- inv:set_size("input", 1)
	end,

})

minetest.register_craft({
	output = "default:workbench",
	recipe = {
		{"group:wood", "group:wood"},
		{"group:wood", "group:wood"},
	}
})