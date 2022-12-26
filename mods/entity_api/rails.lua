-- entity_api/rails.lua

-- support for MT game translation.
local S = entity_api.translation

entity_api.register_rail("entity_api:rail", {
	description = S("Rail"),
	tiles = {
		"carts_rail_straight.png", "carts_rail_curved.png",
		"carts_rail_t_junction.png", "carts_rail_crossing.png"
	},
	inventory_image = "carts_rail_straight.png",
	wield_image = "carts_rail_straight.png",
	groups = entity_api.get_rail_groups(),
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


entity_api.register_rail("entity_api:powerrail", {
	description = S("Powered Rail"),
	tiles = {
		"carts_rail_straight_pwr.png", "carts_rail_curved_pwr.png",
		"carts_rail_t_junction_pwr.png", "carts_rail_crossing_pwr.png"
	},
	groups = entity_api.get_rail_groups(),
}, {acceleration = 5})

engine.register_craft({
	output = "entity_api:powerrail 18",
	recipe = {
		{"default:iron_ingot", "group:wood", "default:iron_ingot"},
		{"default:iron_ingot", "default:mese_crystal", "default:iron_ingot"},
		{"default:iron_ingot", "group:wood", "default:iron_ingot"},
	}
})


entity_api.register_rail("entity_api:brakerail", {
	description = S("Brake Rail"),
	tiles = {
		"carts_rail_straight_brk.png", "carts_rail_curved_brk.png",
		"carts_rail_t_junction_brk.png", "carts_rail_crossing_brk.png"
	},
	groups = entity_api.get_rail_groups(),
}, {acceleration = -3})

engine.register_craft({
	output = "entity_api:brakerail 18",
	recipe = {
		{"default:iron_ingot", "group:wood", "default:iron_ingot"},
		{"default:iron_ingot", "default:coal_lump", "default:iron_ingot"},
		{"default:iron_ingot", "group:wood", "default:iron_ingot"},
	}
})
