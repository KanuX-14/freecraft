-- mods/default/crafting.lua

engine.register_craft({
	output = "default:wood 4",
	recipe = {
		{"default:tree"},
	}
})

engine.register_craft({
	output = "default:jungle_wood 4",
	recipe = {
		{"default:jungle_tree"},
	}
})

engine.register_craft({
	output = "default:pine_wood 4",
	recipe = {
		{"default:pine_tree"},
	}
})

engine.register_craft({
	output = "default:acacia_wood 4",
	recipe = {
		{"default:acacia_tree"},
	}
})

engine.register_craft({
	output = "default:aspen_wood 4",
	recipe = {
		{"default:aspen_tree"},
	}
})

engine.register_craft({
	output = "default:wood",
	recipe = {
		{"default:bush_stem"},
	}
})

engine.register_craft({
	output = "default:acacia_wood",
	recipe = {
		{"default:acacia_bush_stem"},
	}
})

engine.register_craft({
	output = "default:pine_wood",
	recipe = {
		{"default:pine_bush_stem"},
	}
})

engine.register_craft({
	output = "default:sign_wall_steel 3",
	recipe = {
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
		{"", "group:stick", ""},
	}
})

engine.register_craft({
	output = "default:sign_wall_wood 3",
	recipe = {
		{"group:wood", "group:wood", "group:wood"},
		{"group:wood", "group:wood", "group:wood"},
		{"", "group:stick", ""},
	}
})

engine.register_craft({
	output = "default:coalblock",
	recipe = {
		{"default:coal_lump", "default:coal_lump", "default:coal_lump"},
		{"default:coal_lump", "default:coal_lump", "default:coal_lump"},
		{"default:coal_lump", "default:coal_lump", "default:coal_lump"},
	}
})

engine.register_craft({
	output = "default:ironblock",
	recipe = {
		{"default:iron_ingot", "default:iron_ingot", "default:iron_ingot"},
		{"default:iron_ingot", "default:iron_ingot", "default:iron_ingot"},
		{"default:iron_ingot", "default:iron_ingot", "default:iron_ingot"},
	}
})

engine.register_craft({
	output = "default:steelblock",
	recipe = {
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
	}
})

engine.register_craft({
	output = "default:copperblock",
	recipe = {
		{"default:copper_ingot", "default:copper_ingot", "default:copper_ingot"},
		{"default:copper_ingot", "default:copper_ingot", "default:copper_ingot"},
		{"default:copper_ingot", "default:copper_ingot", "default:copper_ingot"},
	}
})

engine.register_craft({
	output = "default:tinblock",
	recipe = {
		{"default:tin_ingot", "default:tin_ingot", "default:tin_ingot"},
		{"default:tin_ingot", "default:tin_ingot", "default:tin_ingot"},
		{"default:tin_ingot", "default:tin_ingot", "default:tin_ingot"},
	}
})

engine.register_craft({
	output = "default:bronzeblock",
	recipe = {
		{"default:bronze_ingot", "default:bronze_ingot", "default:bronze_ingot"},
		{"default:bronze_ingot", "default:bronze_ingot", "default:bronze_ingot"},
		{"default:bronze_ingot", "default:bronze_ingot", "default:bronze_ingot"},
	}
})

engine.register_craft({
	output = "default:bronze_ingot 9",
	recipe = {
		{"default:bronzeblock"},
	}
})

engine.register_craft({
	output = "default:goldblock",
	recipe = {
		{"default:gold_ingot", "default:gold_ingot", "default:gold_ingot"},
		{"default:gold_ingot", "default:gold_ingot", "default:gold_ingot"},
		{"default:gold_ingot", "default:gold_ingot", "default:gold_ingot"},
	}
})

engine.register_craft({
	output = "default:diamondblock",
	recipe = {
		{"default:diamond", "default:diamond", "default:diamond"},
		{"default:diamond", "default:diamond", "default:diamond"},
		{"default:diamond", "default:diamond", "default:diamond"},
	}
})

engine.register_craft({
	output = "default:sandstone",
	recipe = {
		{"default:sand", "default:sand"},
		{"default:sand", "default:sand"},
	}
})

engine.register_craft({
	output = "default:sand 4",
	recipe = {
		{"default:sandstone"},
	}
})

engine.register_craft({
	output = "default:sandstonebrick 4",
	recipe = {
		{"default:sandstone", "default:sandstone"},
		{"default:sandstone", "default:sandstone"},
	}
})

engine.register_craft({
	output = "default:sandstone_block 9",
	recipe = {
		{"default:sandstone", "default:sandstone", "default:sandstone"},
		{"default:sandstone", "default:sandstone", "default:sandstone"},
		{"default:sandstone", "default:sandstone", "default:sandstone"},
	}
})

engine.register_craft({
	output = "default:desert_sandstone",
	recipe = {
		{"default:desert_sand", "default:desert_sand"},
		{"default:desert_sand", "default:desert_sand"},
	}
})

engine.register_craft({
	output = "default:desert_sand 4",
	recipe = {
		{"default:desert_sandstone"},
	}
})

engine.register_craft({
	output = "default:desert_sandstone_brick 4",
	recipe = {
		{"default:desert_sandstone", "default:desert_sandstone"},
		{"default:desert_sandstone", "default:desert_sandstone"},
	}
})

engine.register_craft({
	output = "default:desert_sandstone_block 9",
	recipe = {
		{"default:desert_sandstone", "default:desert_sandstone", "default:desert_sandstone"},
		{"default:desert_sandstone", "default:desert_sandstone", "default:desert_sandstone"},
		{"default:desert_sandstone", "default:desert_sandstone", "default:desert_sandstone"},
	}
})

engine.register_craft({
	output = "default:silver_sandstone",
	recipe = {
		{"default:silver_sand", "default:silver_sand"},
		{"default:silver_sand", "default:silver_sand"},
	}
})

engine.register_craft({
	output = "default:silver_sand 4",
	recipe = {
		{"default:silver_sandstone"},
	}
})

engine.register_craft({
	output = "default:silver_sandstone_brick 4",
	recipe = {
		{"default:silver_sandstone", "default:silver_sandstone"},
		{"default:silver_sandstone", "default:silver_sandstone"},
	}
})

engine.register_craft({
	output = "default:silver_sandstone_block 9",
	recipe = {
		{"default:silver_sandstone", "default:silver_sandstone", "default:silver_sandstone"},
		{"default:silver_sandstone", "default:silver_sandstone", "default:silver_sandstone"},
		{"default:silver_sandstone", "default:silver_sandstone", "default:silver_sandstone"},
	}
})

engine.register_craft({
	output = "default:clay",
	recipe = {
		{"default:clay_lump", "default:clay_lump"},
		{"default:clay_lump", "default:clay_lump"},
	}
})

engine.register_craft({
	output = "default:brick",
	recipe = {
		{"default:clay_brick", "default:clay_brick"},
		{"default:clay_brick", "default:clay_brick"},
	}
})

engine.register_craft({
	output = "default:bookshelf",
	recipe = {
		{"group:wood", "group:wood", "group:wood"},
		{"default:book", "default:book", "default:book"},
		{"group:wood", "group:wood", "group:wood"},
	}
})

engine.register_craft({
	output = "default:ladder_wood 5",
	recipe = {
		{"group:stick", "", "group:stick"},
		{"group:stick", "group:stick", "group:stick"},
		{"group:stick", "", "group:stick"},
	}
})

engine.register_craft({
	output = "default:ladder_steel 15",
	recipe = {
		{"default:steel_ingot", "", "default:steel_ingot"},
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
		{"default:steel_ingot", "", "default:steel_ingot"},
	}
})

engine.register_craft({
	output = "default:mese",
	recipe = {
		{"default:mese_crystal", "default:mese_crystal", "default:mese_crystal"},
		{"default:mese_crystal", "default:mese_crystal", "default:mese_crystal"},
		{"default:mese_crystal", "default:mese_crystal", "default:mese_crystal"},
	}
})

engine.register_craft({
	output = "default:meselamp",
	recipe = {
		{"default:glass"},
		{"default:mese_crystal"},
	}
})

engine.register_craft({
	output = "default:obsidian",
	recipe = {
		{"default:obsidian_shard", "default:obsidian_shard", "default:obsidian_shard"},
		{"default:obsidian_shard", "default:obsidian_shard", "default:obsidian_shard"},
		{"default:obsidian_shard", "default:obsidian_shard", "default:obsidian_shard"},
	}
})

engine.register_craft({
	output = "default:obsidianbrick 4",
	recipe = {
		{"default:obsidian", "default:obsidian"},
		{"default:obsidian", "default:obsidian"}
	}
})

engine.register_craft({
	output = "default:obsidian_block 9",
	recipe = {
		{"default:obsidian", "default:obsidian", "default:obsidian"},
		{"default:obsidian", "default:obsidian", "default:obsidian"},
		{"default:obsidian", "default:obsidian", "default:obsidian"},
	}
})

engine.register_craft({
	output = "default:stonebrick 4",
	recipe = {
		{"default:stone", "default:stone"},
		{"default:stone", "default:stone"},
	}
})

engine.register_craft({
	output = "default:stone_block 9",
	recipe = {
		{"default:stone", "default:stone", "default:stone"},
		{"default:stone", "default:stone", "default:stone"},
		{"default:stone", "default:stone", "default:stone"},
	}
})

engine.register_craft({
	output = "default:desert_stonebrick 4",
	recipe = {
		{"default:desert_stone", "default:desert_stone"},
		{"default:desert_stone", "default:desert_stone"},
	}
})

engine.register_craft({
	output = "default:desert_stone_block 9",
	recipe = {
		{"default:desert_stone", "default:desert_stone", "default:desert_stone"},
		{"default:desert_stone", "default:desert_stone", "default:desert_stone"},
		{"default:desert_stone", "default:desert_stone", "default:desert_stone"},
	}
})

engine.register_craft({
	output = "default:snowblock",
	recipe = {
		{"default:snow", "default:snow", "default:snow"},
		{"default:snow", "default:snow", "default:snow"},
		{"default:snow", "default:snow", "default:snow"},
	}
})

engine.register_craft({
	output = "default:snow 9",
	recipe = {
		{"default:snowblock"},
	}
})

engine.register_craft({
	output = "default:emergent_jungle_sapling",
	recipe = {
		{"default:jungle_sapling", "default:jungle_sapling", "default:jungle_sapling"},
		{"default:jungle_sapling", "default:jungle_sapling", "default:jungle_sapling"},
		{"default:jungle_sapling", "default:jungle_sapling", "default:jungle_sapling"},
	}
})

engine.register_craft({
	output = "default:large_cactus_seedling",
	recipe = {
		{"", "default:cactus", ""},
		{"default:cactus", "default:cactus", "default:cactus"},
		{"", "default:cactus", ""},
	}
})


--
-- Crafting (tool repair)
--

engine.register_craft({
	type = "toolrepair",
	additional_wear = -0.02,
})


--
-- Cooking recipes
--

engine.register_craft({
	type = "cooking",
	output = "default:glass",
	recipe = "group:sand",
})

engine.register_craft({
	type = "cooking",
	output = "default:obsidian_glass",
	recipe = "default:obsidian_shard",
})

engine.register_craft({
	type = "cooking",
	output = "default:stone",
	recipe = "default:cobble",
})

engine.register_craft({
	type = "cooking",
	output = "default:stone",
	recipe = "default:mossycobble",
})

engine.register_craft({
	type = "cooking",
	output = "default:desert_stone",
	recipe = "default:desert_cobble",
})

engine.register_craft({
	type = "cooking",
	cooktime = 7,
	output = "default:crumbled_clay",
	recipe = "default:clay",
})

--
-- Fuels
--

-- Support use of group:tree, includes default:tree which has the same burn time
engine.register_craft({
	type = "fuel",
	recipe = "group:tree",
	burntime = 30,
})

-- Burn time for all woods are in order of wood density,
-- which is also the order of wood colour darkness:
-- aspen, pine, apple, acacia, jungle

engine.register_craft({
	type = "fuel",
	recipe = "default:aspen_tree",
	burntime = 22,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:pine_tree",
	burntime = 26,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:acacia_tree",
	burntime = 34,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:jungle_tree",
	burntime = 38,
})


-- Support use of group:wood, includes default:wood which has the same burn time
engine.register_craft({
	type = "fuel",
	recipe = "group:wood",
	burntime = 7,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:aspen_wood",
	burntime = 5,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:pine_wood",
	burntime = 6,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:acacia_wood",
	burntime = 8,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:jungle_wood",
	burntime = 9,
})


-- Support use of group:sapling, includes default:sapling which has the same burn time
engine.register_craft({
	type = "fuel",
	recipe = "group:sapling",
	burntime = 5,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:bush_sapling",
	burntime = 3,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:acacia_bush_sapling",
	burntime = 4,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:pine_bush_sapling",
	burntime = 2,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:aspen_sapling",
	burntime = 4,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:pine_sapling",
	burntime = 5,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:acacia_sapling",
	burntime = 6,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:jungle_sapling",
	burntime = 6,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:emergent_jungle_sapling",
	burntime = 7,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:fence_aspen_wood",
	burntime = 5,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:fence_pine_wood",
	burntime = 6,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:fence_wood",
	burntime = 7,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:fence_acacia_wood",
	burntime = 8,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:fence_junglewood",
	burntime = 9,
})


engine.register_craft({
	type = "fuel",
	recipe = "default:fence_rail_aspen_wood",
	burntime = 3,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:fence_rail_pine_wood",
	burntime = 4,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:fence_rail_wood",
	burntime = 5,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:fence_rail_acacia_wood",
	burntime = 6,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:fence_rail_junglewood",
	burntime = 7,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:bush_stem",
	burntime = 7,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:acacia_bush_stem",
	burntime = 8,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:pine_bush_stem",
	burntime = 6,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:jungle_grass",
	burntime = 3,
})

engine.register_craft({
	type = "fuel",
	recipe = "group:leaves",
	burntime = 4,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:cactus",
	burntime = 15,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:large_cactus_seedling",
	burntime = 5,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:papyrus",
	burntime = 3,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:bookshelf",
	burntime = 30,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:ladder_wood",
	burntime = 7,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:lava_source",
	burntime = 60,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:sign_wall_wood",
	burntime = 10,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:coalblock",
	burntime = 370,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:grass_1",
	burntime = 2,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:dry_grass_1",
	burntime = 2,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:fern_1",
	burntime = 2,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:marram_grass_1",
	burntime = 2,
})

engine.register_craft({
	type = "fuel",
	recipe = "default:dry_shrub",
	burntime = 2,
})
