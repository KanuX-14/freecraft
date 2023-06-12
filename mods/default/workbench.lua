-- default/workbench.lua

local function check_inventory(pos, player)
	local meta = engine.get_meta(pos);
	local inv = meta:get_inventory()
	return inv:is_empty("main")
end

local function get_workbench()
	local _formspec = {
		type 		= "formspec",
		info		=	"infotext",
		layout 	= "size[9,9]" ..
							"list[current_player;craft;1.75,0.5;3,3;]" ..
							"list[current_player;craftpreview;5.75,1.5;1,1;]" ..
							"list[current_player;main;0,8;9,1;]" ..
							"list[current_player;main;0,5;9,3;9]" ..
							"image[4.75,1.5;1,1;sfinv_crafting_arrow.png]" ..
							"listring[current_player;main]" ..
							"listring[current_player;craft]"
	}
	
	local _workbench = {
		name = "default:workbench",
		description = "Workbench",
		tiles = {
			"default_workbench_top.png",
			"default_wood.png",
			"default_workbench_side.png"
		},
		groups = {
			workbench = 1, choppy = 1,
			oddly_breakable_by_hand = 2
		},
		sounds = default.node_sound_wood_defaults(),
		paramtype2 = "facedir",
		can_dig = check_inventory,
		on_construct = function(pos)
			local meta = engine.get_meta(pos)
			meta:set_string(_formspec.info, description)
			meta:set_string(_formspec.type, _formspec.layout)
		end,
	}

	return _workbench
end

local ingredients = {
	Acacia 	= "default:acacia_wood",	Apple 		= "default:wood",
	Aspen 	= "default:aspen_wood",		Jungle 		= "default:junglewood",
	Pine 		= "default:pine_wood"
}

for wood, name in pairs(ingredients) do
	local l_wood = string.lower(wood)
	local _workbench = get_workbench()

	if (l_wood ~= "apple") then
		_workbench.name = "default:" .. l_wood .. "_workbench"
		_workbench.description = wood .. " Workbench"
		_workbench.tiles = {
			"default_" .. l_wood .. "_workbench_top.png",
			"default_" .. l_wood .. "_wood.png",
			"default_" .. l_wood .. "_workbench_side.png"
		}
	end
	local X = name

	engine.register_node(_workbench.name, _workbench)
	engine.register_craft({output = _workbench.name,
												 recipe = {{X, X},
																	 {X, X}}
												})
end
