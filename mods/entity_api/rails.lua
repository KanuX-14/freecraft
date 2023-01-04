-- entity_api/rails.lua

-- support for MT game translation.
local S = entity_api.translation

local function register_rail(name, def_overwrite, railparams)
	local def = { drawtype = "raillike", paramtype = "light", sunlight_propagates = true,
				  is_ground_content = false, walkable = false,
				  selection_box = { type = "fixed",
									fixed = {-1/2, -1/2, -1/2, 1/2, -1/2+1/16, 1/2},
								  },
				  sounds = default.node_sound_metal_defaults()
				}

	for k, v in pairs(def_overwrite) do def[k] = v end

	if not def.inventory_image then
		def.wield_image = def.tiles[1]
		def.inventory_image = def.tiles[1]
	end

	if railparams then entity_api.railparams[name] = table.copy(railparams) end

	engine.register_node(name, def)
end

local function get_rail_groups(additional_groups)
	-- Get the default rail groups and add more when a table is given
	local groups = {
		dig_immediate = 2,
		attached_node = 1,
		rail = 1,
		connect_to_raillike = engine.raillike_group("rail")
	}
	if type(additional_groups) == "table" then
		for k, v in pairs(additional_groups) do
			groups[k] = v
		end
	end
	return groups
end

register_rail("entity_api:rail", {
	description = S("Rail"),
	tiles = {
		"carts_rail_straight.png", "carts_rail_curved.png",
		"carts_rail_t_junction.png", "carts_rail_crossing.png"
	},
	inventory_image = "carts_rail_straight.png",
	wield_image = "carts_rail_straight.png",
	groups = get_rail_groups(),
}, {})

engine.register_craft({
	output = "entity_api:rail 18",
	recipe = {
		{"default:iron_ingot", "group:wood", "default:iron_ingot"},
		{"default:iron_ingot", "", "default:iron_ingot"},
		{"default:iron_ingot", "group:wood", "default:iron_ingot"},
	}
})

engine.register_alias("default:rail", "entity_api:rail")


register_rail("entity_api:powerrail", {
	description = S("Powered Rail"),
	tiles = {
		"carts_rail_straight_pwr.png", "carts_rail_curved_pwr.png",
		"carts_rail_t_junction_pwr.png", "carts_rail_crossing_pwr.png"
	},
	groups = get_rail_groups(),
}, {acceleration = 5})

engine.register_craft({
	output = "entity_api:powerrail 18",
	recipe = {
		{"default:iron_ingot", "group:wood", "default:iron_ingot"},
		{"default:iron_ingot", "default:mese_crystal", "default:iron_ingot"},
		{"default:iron_ingot", "group:wood", "default:iron_ingot"},
	}
})


register_rail("entity_api:brakerail", {
	description = S("Brake Rail"),
	tiles = {
		"carts_rail_straight_brk.png", "carts_rail_curved_brk.png",
		"carts_rail_t_junction_brk.png", "carts_rail_crossing_brk.png"
	},
	groups = get_rail_groups(),
}, {acceleration = -3})

engine.register_craft({
	output = "entity_api:brakerail 18",
	recipe = {
		{"default:iron_ingot", "group:wood", "default:iron_ingot"},
		{"default:iron_ingot", "default:coal_lump", "default:iron_ingot"},
		{"default:iron_ingot", "group:wood", "default:iron_ingot"},
	}
})
