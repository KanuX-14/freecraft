-- farming/hoes.lua

-- support for MT game translation.
local S = farming.get_translator

farming.register_hoe(":farming:hoe_wood", {
	description = S("Wooden Hoe"),
	inventory_image = "farming_tool_woodhoe.png",
	wield_scale = {x = 1.4, y = 1.4, z = 1},
	max_uses = 30,
	material = "group:wood",
	groups = {hoe = 1, flammable = 2},
})

farming.register_hoe(":farming:hoe_stone", {
	description = S("Stone Hoe"),
	inventory_image = "farming_tool_stonehoe.png",
	wield_scale = {x = 1.4, y = 1.4, z = 1},
	max_uses = 90,
	material = "group:stone",
	groups = {hoe = 1}
})

farming.register_hoe(":farming:hoe_copper", {
	description = S("Copper Hoe"),
	inventory_image = "farming_tool_copperhoe.png",
	wield_scale = {x = 1.4, y = 1.4, z = 1},
	max_uses = 120,
	material = "default:copper_ingot",
	groups = {hoe = 1}
})

farming.register_hoe(":farming:hoe_iron", {
	description = S("Iron Hoe"),
	inventory_image = "farming_tool_ironhoe.png",
	wield_scale = {x = 1.4, y = 1.4, z = 1},
	max_uses = 350,
	material = "default:iron_ingot",
	groups = {hoe = 1}
})

farming.register_hoe(":farming:hoe_steel", {
	description = S("Steel Hoe"),
	inventory_image = "farming_tool_steelhoe.png",
	wield_scale = {x = 1.4, y = 1.4, z = 1},
	max_uses = 550,
	material = "default:steel_ingot",
	groups = {hoe = 1}
})

-- The following are deprecated by removing the 'material' field to prevent
-- crafting and removing from creative inventory, to cause them to eventually
-- disappear from worlds. The registrations should be removed in a future
-- release.

farming.register_hoe(":farming:hoe_bronze", {
	description = S("Bronze Hoe"),
	inventory_image = "farming_tool_bronzehoe.png",
	wield_scale = {x = 1.4, y = 1.4, z = 1},
	max_uses = 220,
	groups = {hoe = 1, not_in_creative_inventory = 1},
})

farming.register_hoe(":farming:hoe_mese", {
	description = S("Mese Hoe"),
	inventory_image = "farming_tool_mesehoe.png",
	wield_scale = {x = 1.4, y = 1.4, z = 1},
	max_uses = 650,
	groups = {hoe = 1, not_in_creative_inventory = 1},
})

farming.register_hoe(":farming:hoe_diamond", {
	description = S("Diamond Hoe"),
	inventory_image = "farming_tool_diamondhoe.png",
	wield_scale = {x = 1.4, y = 1.4, z = 1},
	max_uses = 800,
	groups = {hoe = 1, not_in_creative_inventory = 1},
})
