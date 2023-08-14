--
-- Aliases for map generators
--

-- All mapgens

engine.register_alias("mapgen_stone", "default:stone")
engine.register_alias("mapgen_water_source", "default:water_source")
engine.register_alias("mapgen_river_water_source", "default:river_water_source")

-- Additional aliases needed for mapgen v6

engine.register_alias("mapgen_lava_source", "default:lava_source")
engine.register_alias("mapgen_dirt", "default:dirt")
engine.register_alias("mapgen_dirt_with_grass", "default:dirt_with_grass")
engine.register_alias("mapgen_sand", "default:sand")
engine.register_alias("mapgen_gravel", "default:gravel")
engine.register_alias("mapgen_desert_stone", "default:desert_stone")
engine.register_alias("mapgen_desert_sand", "default:desert_sand")
engine.register_alias("mapgen_dirt_with_snow", "default:dirt_with_snow")
engine.register_alias("mapgen_snowblock", "default:snowblock")
engine.register_alias("mapgen_snow", "default:snow")
engine.register_alias("mapgen_ice", "default:ice")

engine.register_alias("mapgen_tree", "default:tree")
engine.register_alias("mapgen_leaves", "default:leaves")
engine.register_alias("mapgen_apple", "default:apple")
engine.register_alias("mapgen_jungletree", "default:jungle_tree")
engine.register_alias("mapgen_jungleleaves", "default:jungle_leaves")
engine.register_alias("mapgen_junglegrass", "default:jungle_grass")
engine.register_alias("mapgen_pine_tree", "default:pine_tree")
engine.register_alias("mapgen_pine_needles", "default:pine_needles")

engine.register_alias("mapgen_cobble", "default:cobble")
engine.register_alias("mapgen_stair_cobble", "stairs:stair_cobble")
engine.register_alias("mapgen_mossycobble", "default:mossycobble")
engine.register_alias("mapgen_stair_desert_stone", "stairs:stair_desert_stone")


--
-- Register ores
--

-- Mgv6

function default.register_mgv6_ores()

  -- Blob ore
  -- These first to avoid other ores in blobs

  -- Clay
  -- This first to avoid clay in sand blobs

  engine.register_ore({
    ore_type        = "blob",
    ore             = "default:clay",
    wherein         = {"default:sand"},
    clust_scarcity  = 16 * 16 * 16,
    clust_size      = 5,
    y_max           = 0,
    y_min           = -15,
    noise_threshold = 0.0,
    noise_params    = {
      offset = 0.5,
      scale = 0.2,
      spread = {x = 5, y = 5, z = 5},
      seed = -316,
      octaves = 1,
      persist = 0.0
    },
  })

  -- Sand

  engine.register_ore({
    ore_type        = "blob",
    ore             = "default:sand",
    wherein         = {"default:stone", "default:desert_stone"},
    clust_scarcity  = 16 * 16 * 16,
    clust_size      = 5,
    y_max           = 0,
    y_min           = -31,
    noise_threshold = 0.0,
    noise_params    = {
      offset = 0.5,
      scale = 0.2,
      spread = {x = 5, y = 5, z = 5},
      seed = 2316,
      octaves = 1,
      persist = 0.0
    },
  })

  -- Dirt

  engine.register_ore({
    ore_type        = "blob",
    ore             = "default:dirt",
    wherein         = {"default:stone"},
    clust_scarcity  = 16 * 16 * 16,
    clust_size      = 5,
    y_max           = 31000,
    y_min           = -31,
    noise_threshold = 0.0,
    noise_params    = {
      offset = 0.5,
      scale = 0.2,
      spread = {x = 5, y = 5, z = 5},
      seed = 17676,
      octaves = 1,
      persist = 0.0
    },
  })

  -- Gravel

  engine.register_ore({
    ore_type        = "blob",
    ore             = "default:gravel",
    wherein         = {"default:stone"},
    clust_scarcity  = 16 * 16 * 16,
    clust_size      = 5,
    y_max           = 31000,
    y_min           = -31000,
    noise_threshold = 0.0,
    noise_params    = {
      offset = 0.5,
      scale = 0.2,
      spread = {x = 5, y = 5, z = 5},
      seed = 766,
      octaves = 1,
      persist = 0.0
    },
  })

  -- Scatter ores

  -- Coal

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_coal",
    wherein        = "default:stone",
    clust_scarcity = 8 * 8 * 8,
    clust_num_ores = 9,
    clust_size     = 3,
    y_max          = 31000,
    y_min          = 1025,
  })

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_coal",
    wherein        = "default:stone",
    clust_scarcity = 8 * 8 * 8,
    clust_num_ores = 8,
    clust_size     = 3,
    y_max          = 64,
    y_min          = -31000,
  })

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_coal",
    wherein        = "default:stone",
    clust_scarcity = 24 * 24 * 24,
    clust_num_ores = 27,
    clust_size     = 6,
    y_max          = 0,
    y_min          = -31000,
  })

  -- Iron

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_iron",
    wherein        = "default:stone",
    clust_scarcity = 9 * 9 * 9,
    clust_num_ores = 12,
    clust_size     = 3,
    y_max          = 31000,
    y_min          = 1025,
  })

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_iron",
    wherein        = "default:stone",
    clust_scarcity = 7 * 7 * 7,
    clust_num_ores = 5,
    clust_size     = 3,
    y_max          = 0,
    y_min          = -31000,
  })

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_iron",
    wherein        = "default:stone",
    clust_scarcity = 24 * 24 * 24,
    clust_num_ores = 27,
    clust_size     = 6,
    y_max          = -64,
    y_min          = -31000,
  })

  -- Copper

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_copper",
    wherein        = "default:stone",
    clust_scarcity = 9 * 9 * 9,
    clust_num_ores = 5,
    clust_size     = 3,
    y_max          = 31000,
    y_min          = 1025,
  })

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_copper",
    wherein        = "default:stone",
    clust_scarcity = 12 * 12 * 12,
    clust_num_ores = 4,
    clust_size     = 3,
    y_max          = -16,
    y_min          = -63,
  })

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_copper",
    wherein        = "default:stone",
    clust_scarcity = 9 * 9 * 9,
    clust_num_ores = 5,
    clust_size     = 3,
    y_max          = -64,
    y_min          = -31000,
  })

  -- Tin

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_tin",
    wherein        = "default:stone",
    clust_scarcity = 10 * 10 * 10,
    clust_num_ores = 5,
    clust_size     = 3,
    y_max          = 31000,
    y_min          = 1025,
  })

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_tin",
    wherein        = "default:stone",
    clust_scarcity = 13 * 13 * 13,
    clust_num_ores = 4,
    clust_size     = 3,
    y_max          = -32,
    y_min          = -127,
  })

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_tin",
    wherein        = "default:stone",
    clust_scarcity = 10 * 10 * 10,
    clust_num_ores = 5,
    clust_size     = 3,
    y_max          = -128,
    y_min          = -31000,
  })

  -- Gold

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_gold",
    wherein        = "default:stone",
    clust_scarcity = 13 * 13 * 13,
    clust_num_ores = 5,
    clust_size     = 3,
    y_max          = 31000,
    y_min          = 1025,
  })

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_gold",
    wherein        = "default:stone",
    clust_scarcity = 15 * 15 * 15,
    clust_num_ores = 3,
    clust_size     = 2,
    y_max          = -64,
    y_min          = -255,
  })

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_gold",
    wherein        = "default:stone",
    clust_scarcity = 13 * 13 * 13,
    clust_num_ores = 5,
    clust_size     = 3,
    y_max          = -256,
    y_min          = -31000,
  })

  -- Mese crystal

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_mese",
    wherein        = "default:stone",
    clust_scarcity = 14 * 14 * 14,
    clust_num_ores = 5,
    clust_size     = 3,
    y_max          = 31000,
    y_min          = 1025,
  })

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_mese",
    wherein        = "default:stone",
    clust_scarcity = 18 * 18 * 18,
    clust_num_ores = 3,
    clust_size     = 2,
    y_max          = -64,
    y_min          = -255,
  })

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_mese",
    wherein        = "default:stone",
    clust_scarcity = 14 * 14 * 14,
    clust_num_ores = 5,
    clust_size     = 3,
    y_max          = -256,
    y_min          = -31000,
  })

  -- Diamond

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_diamond",
    wherein        = "default:stone",
    clust_scarcity = 15 * 15 * 15,
    clust_num_ores = 4,
    clust_size     = 3,
    y_max          = 31000,
    y_min          = 1025,
  })

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_diamond",
    wherein        = "default:stone",
    clust_scarcity = 17 * 17 * 17,
    clust_num_ores = 4,
    clust_size     = 3,
    y_max          = -128,
    y_min          = -255,
  })

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_diamond",
    wherein        = "default:stone",
    clust_scarcity = 15 * 15 * 15,
    clust_num_ores = 4,
    clust_size     = 3,
    y_max          = -256,
    y_min          = -31000,
  })

  -- Mese block

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:mese",
    wherein        = "default:stone",
    clust_scarcity = 36 * 36 * 36,
    clust_num_ores = 3,
    clust_size     = 2,
    y_max          = 31000,
    y_min          = 1025,
  })

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:mese",
    wherein        = "default:stone",
    clust_scarcity = 36 * 36 * 36,
    clust_num_ores = 3,
    clust_size     = 2,
    y_max          = -1024,
    y_min          = -31000,
  })
end


-- All mapgens except mgv6

function default.register_ores()

  -- Stratum ores.
  -- These obviously first.

  -- Silver sandstone

  engine.register_ore({
    ore_type        = "stratum",
    ore             = "default:silver_sandstone",
    wherein         = {"default:stone"},
    clust_scarcity  = 1,
    y_max           = 46,
    y_min           = 10,
    noise_params    = {
      offset = 28,
      scale = 16,
      spread = {x = 128, y = 128, z = 128},
      seed = 90122,
      octaves = 1,
    },
    stratum_thickness = 4,
    biomes = {"cold_desert"},
  })

  engine.register_ore({
    ore_type        = "stratum",
    ore             = "default:silver_sandstone",
    wherein         = {"default:stone"},
    clust_scarcity  = 1,
    y_max           = 42,
    y_min           = 6,
    noise_params    = {
      offset = 24,
      scale = 16,
      spread = {x = 128, y = 128, z = 128},
      seed = 90122,
      octaves = 1,
    },
    stratum_thickness = 2,
    biomes = {"cold_desert"},
  })

  -- Desert sandstone

  engine.register_ore({
    ore_type        = "stratum",
    ore             = "default:desert_sandstone",
    wherein         = {"default:desert_stone"},
    clust_scarcity  = 1,
    y_max           = 46,
    y_min           = 10,
    noise_params    = {
      offset = 28,
      scale = 16,
      spread = {x = 128, y = 128, z = 128},
      seed = 90122,
      octaves = 1,
    },
    stratum_thickness = 4,
    biomes = {"desert"},
  })

  engine.register_ore({
    ore_type        = "stratum",
    ore             = "default:desert_sandstone",
    wherein         = {"default:desert_stone"},
    clust_scarcity  = 1,
    y_max           = 42,
    y_min           = 6,
    noise_params    = {
      offset = 24,
      scale = 16,
      spread = {x = 128, y = 128, z = 128},
      seed = 90122,
      octaves = 1,
    },
    stratum_thickness = 2,
    biomes = {"desert"},
  })

  -- Sandstone

  engine.register_ore({
    ore_type        = "stratum",
    ore             = "default:sandstone",
    wherein         = {"default:desert_stone"},
    clust_scarcity  = 1,
    y_max           = 39,
    y_min           = 3,
    noise_params    = {
      offset = 21,
      scale = 16,
      spread = {x = 128, y = 128, z = 128},
      seed = 90122,
      octaves = 1,
    },
    stratum_thickness = 2,
    biomes = {"desert"},
  })

  -- Blob ore.
  -- These before scatter ores to avoid other ores in blobs.

  -- Clay

  engine.register_ore({
    ore_type        = "blob",
    ore             = "default:clay",
    wherein         = {"default:sand"},
    clust_scarcity  = 16 * 16 * 16,
    clust_size      = 5,
    y_max           = 0,
    y_min           = -15,
    noise_threshold = 0.0,
    noise_params    = {
      offset = 0.5,
      scale = 0.2,
      spread = {x = 5, y = 5, z = 5},
      seed = -316,
      octaves = 1,
      persist = 0.0
    },
  })

  -- Silver sand

  engine.register_ore({
    ore_type        = "blob",
    ore             = "default:silver_sand",
    wherein         = {"default:stone"},
    clust_scarcity  = 16 * 16 * 16,
    clust_size      = 5,
    y_max           = 31000,
    y_min           = -31000,
    noise_threshold = 0.0,
    noise_params    = {
      offset = 0.5,
      scale = 0.2,
      spread = {x = 5, y = 5, z = 5},
      seed = 2316,
      octaves = 1,
      persist = 0.0
    },
  })

  -- Dirt

  engine.register_ore({
    ore_type        = "blob",
    ore             = "default:dirt",
    wherein         = {"default:stone"},
    clust_scarcity  = 16 * 16 * 16,
    clust_size      = 5,
    y_max           = 31000,
    y_min           = -31,
    noise_threshold = 0.0,
    noise_params    = {
      offset = 0.5,
      scale = 0.2,
      spread = {x = 5, y = 5, z = 5},
      seed = 17676,
      octaves = 1,
      persist = 0.0
    },
    -- Only where default:dirt is present as surface material
    biomes = {"taiga", "snowy_grassland", "grassland", "coniferous_forest",
        "deciduous_forest", "deciduous_forest_shore", "rainforest",
        "rainforest_swamp"}
  })

  -- Gravel

  engine.register_ore({
    ore_type        = "blob",
    ore             = "default:gravel",
    wherein         = {"default:stone"},
    clust_scarcity  = 16 * 16 * 16,
    clust_size      = 5,
    y_max           = 31000,
    y_min           = -31000,
    noise_threshold = 0.0,
    noise_params    = {
      offset = 0.5,
      scale = 0.2,
      spread = {x = 5, y = 5, z = 5},
      seed = 766,
      octaves = 1,
      persist = 0.0
    },
  })

  -- Scatter ores

  -- Coal

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_coal",
    wherein        = "default:stone",
    clust_scarcity = 8 * 8 * 8,
    clust_num_ores = 9,
    clust_size     = 3,
    y_max          = 31000,
    y_min          = 1025,
  })

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_coal",
    wherein        = "default:stone",
    clust_scarcity = 8 * 8 * 8,
    clust_num_ores = 8,
    clust_size     = 3,
    y_max          = 64,
    y_min          = -127,
  })

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_coal",
    wherein        = "default:stone",
    clust_scarcity = 12 * 12 * 12,
    clust_num_ores = 30,
    clust_size     = 5,
    y_max          = -128,
    y_min          = -31000,
  })

  -- Tin

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_tin",
    wherein        = "default:stone",
    clust_scarcity = 10 * 10 * 10,
    clust_num_ores = 5,
    clust_size     = 3,
    y_max          = 31000,
    y_min          = 1025,
  })

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_tin",
    wherein        = "default:stone",
    clust_scarcity = 13 * 13 * 13,
    clust_num_ores = 4,
    clust_size     = 3,
    y_max          = -64,
    y_min          = -127,
  })

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_tin",
    wherein        = "default:stone",
    clust_scarcity = 10 * 10 * 10,
    clust_num_ores = 5,
    clust_size     = 3,
    y_max          = -128,
    y_min          = -31000,
  })

  -- Copper

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_copper",
    wherein        = "default:stone",
    clust_scarcity = 9 * 9 * 9,
    clust_num_ores = 5,
    clust_size     = 3,
    y_max          = 31000,
    y_min          = 1025,
  })

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_copper",
    wherein        = "default:stone",
    clust_scarcity = 12 * 12 * 12,
    clust_num_ores = 4,
    clust_size     = 3,
    y_max          = -64,
    y_min          = -127,
  })

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_copper",
    wherein        = "default:stone",
    clust_scarcity = 9 * 9 * 9,
    clust_num_ores = 5,
    clust_size     = 3,
    y_max          = -128,
    y_min          = -31000,
  })

  -- Iron

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_iron",
    wherein        = "default:stone",
    clust_scarcity = 9 * 9 * 9,
    clust_num_ores = 12,
    clust_size     = 3,
    y_max          = 31000,
    y_min          = 1025,
  })

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_iron",
    wherein        = "default:stone",
    clust_scarcity = 7 * 7 * 7,
    clust_num_ores = 5,
    clust_size     = 3,
    y_max          = -128,
    y_min          = -255,
  })

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_iron",
    wherein        = "default:stone",
    clust_scarcity = 12 * 12 * 12,
    clust_num_ores = 29,
    clust_size     = 5,
    y_max          = -256,
    y_min          = -31000,
  })

  -- Gold

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_gold",
    wherein        = "default:stone",
    clust_scarcity = 13 * 13 * 13,
    clust_num_ores = 5,
    clust_size     = 3,
    y_max          = 31000,
    y_min          = 1025,
  })

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_gold",
    wherein        = "default:stone",
    clust_scarcity = 15 * 15 * 15,
    clust_num_ores = 3,
    clust_size     = 2,
    y_max          = -256,
    y_min          = -511,
  })

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_gold",
    wherein        = "default:stone",
    clust_scarcity = 13 * 13 * 13,
    clust_num_ores = 5,
    clust_size     = 3,
    y_max          = -512,
    y_min          = -31000,
  })

  -- Mese crystal

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_mese",
    wherein        = "default:stone",
    clust_scarcity = 14 * 14 * 14,
    clust_num_ores = 5,
    clust_size     = 3,
    y_max          = 31000,
    y_min          = 1025,
  })

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_mese",
    wherein        = "default:stone",
    clust_scarcity = 18 * 18 * 18,
    clust_num_ores = 3,
    clust_size     = 2,
    y_max          = -512,
    y_min          = -1023,
  })

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_mese",
    wherein        = "default:stone",
    clust_scarcity = 14 * 14 * 14,
    clust_num_ores = 5,
    clust_size     = 3,
    y_max          = -1024,
    y_min          = -31000,
  })

  -- Diamond

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_diamond",
    wherein        = "default:stone",
    clust_scarcity = 15 * 15 * 15,
    clust_num_ores = 4,
    clust_size     = 3,
    y_max          = 31000,
    y_min          = 1025,
  })

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_diamond",
    wherein        = "default:stone",
    clust_scarcity = 17 * 17 * 17,
    clust_num_ores = 4,
    clust_size     = 3,
    y_max          = -1024,
    y_min          = -2047,
  })

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:stone_with_diamond",
    wherein        = "default:stone",
    clust_scarcity = 15 * 15 * 15,
    clust_num_ores = 4,
    clust_size     = 3,
    y_max          = -2048,
    y_min          = -31000,
  })

  -- Mese block

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:mese",
    wherein        = "default:stone",
    clust_scarcity = 36 * 36 * 36,
    clust_num_ores = 3,
    clust_size     = 2,
    y_max          = 31000,
    y_min          = 1025,
  })

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:mese",
    wherein        = "default:stone",
    clust_scarcity = 36 * 36 * 36,
    clust_num_ores = 3,
    clust_size     = 2,
    y_max          = -2048,
    y_min          = -4095,
  })

  engine.register_ore({
    ore_type       = "scatter",
    ore            = "default:mese",
    wherein        = "default:stone",
    clust_scarcity = 28 * 28 * 28,
    clust_num_ores = 5,
    clust_size     = 3,
    y_max          = -4096,
    y_min          = -31000,
  })
end


--
-- Register biomes
--

-- All mapgens except mgv6

function default.register_biomes()

  -- Icesheet

  engine.register_biome({
    name = "icesheet",
    node_dust = "default:snowblock",
    node_top = "default:snowblock",
    depth_top = 1,
    node_filler = "default:snowblock",
    depth_filler = 3,
    node_stone = "default:cave_ice",
    node_water_top = "default:ice",
    depth_water_top = 10,
    node_river_water = "default:ice",
    node_riverbed = "default:gravel",
    depth_riverbed = 2,
    node_dungeon = "default:ice",
    node_dungeon_stair = "stairs:stair_ice",
    y_max = 31000,
    y_min = -8,
    heat_point = 0,
    humidity_point = 73,
  })

  engine.register_biome({
    name = "icesheet_ocean",
    node_dust = "default:snowblock",
    node_top = "default:sand",
    depth_top = 1,
    node_filler = "default:sand",
    depth_filler = 3,
    node_water_top = "default:ice",
    depth_water_top = 10,
    node_cave_liquid = "default:water_source",
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    y_max = -9,
    y_min = -255,
    heat_point = 0,
    humidity_point = 73,
  })

  engine.register_biome({
    name = "icesheet_under",
    node_cave_liquid = {"default:water_source", "default:lava_source"},
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    y_max = -256,
    y_min = -31000,
    heat_point = 0,
    humidity_point = 73,
  })

  -- Tundra

  engine.register_biome({
    name = "tundra_highland",
    node_dust = "default:snow",
    node_riverbed = "default:gravel",
    depth_riverbed = 2,
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    y_max = 31000,
    y_min = 47,
    heat_point = 0,
    humidity_point = 40,
  })

  engine.register_biome({
    name = "tundra",
    node_top = "default:permafrost_with_stones",
    depth_top = 1,
    node_filler = "default:permafrost",
    depth_filler = 1,
    node_riverbed = "default:gravel",
    depth_riverbed = 2,
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    vertical_blend = 4,
    y_max = 46,
    y_min = 2,
    heat_point = 0,
    humidity_point = 40,
  })

  engine.register_biome({
    name = "tundra_beach",
    node_top = "default:gravel",
    depth_top = 1,
    node_filler = "default:gravel",
    depth_filler = 2,
    node_riverbed = "default:gravel",
    depth_riverbed = 2,
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    vertical_blend = 1,
    y_max = 1,
    y_min = -3,
    heat_point = 0,
    humidity_point = 40,
  })

  engine.register_biome({
    name = "tundra_ocean",
    node_top = "default:sand",
    depth_top = 1,
    node_filler = "default:sand",
    depth_filler = 3,
    node_riverbed = "default:gravel",
    depth_riverbed = 2,
    node_cave_liquid = "default:water_source",
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    vertical_blend = 1,
    y_max = -4,
    y_min = -255,
    heat_point = 0,
    humidity_point = 40,
  })

  engine.register_biome({
    name = "tundra_under",
    node_cave_liquid = {"default:water_source", "default:lava_source"},
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    y_max = -256,
    y_min = -31000,
    heat_point = 0,
    humidity_point = 40,
  })

  -- Taiga

  engine.register_biome({
    name = "taiga",
    node_dust = "default:snow",
    node_top = "default:dirt_with_snow",
    depth_top = 1,
    node_filler = "default:dirt",
    depth_filler = 3,
    node_riverbed = "default:sand",
    depth_riverbed = 2,
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    y_max = 31000,
    y_min = 4,
    heat_point = 25,
    humidity_point = 70,
  })

  engine.register_biome({
    name = "taiga_ocean",
    node_dust = "default:snow",
    node_top = "default:sand",
    depth_top = 1,
    node_filler = "default:sand",
    depth_filler = 3,
    node_riverbed = "default:sand",
    depth_riverbed = 2,
    node_cave_liquid = "default:water_source",
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    vertical_blend = 1,
    y_max = 3,
    y_min = -255,
    heat_point = 25,
    humidity_point = 70,
  })

  engine.register_biome({
    name = "taiga_under",
    node_cave_liquid = {"default:water_source", "default:lava_source"},
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    y_max = -256,
    y_min = -31000,
    heat_point = 25,
    humidity_point = 70,
  })

  -- Snowy grassland

  engine.register_biome({
    name = "snowy_grassland",
    node_dust = "default:snow",
    node_top = "default:dirt_with_snow",
    depth_top = 1,
    node_filler = "default:dirt",
    depth_filler = 1,
    node_riverbed = "default:sand",
    depth_riverbed = 2,
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    y_max = 31000,
    y_min = 4,
    heat_point = 20,
    humidity_point = 35,
  })

  engine.register_biome({
    name = "snowy_grassland_ocean",
    node_dust = "default:snow",
    node_top = "default:sand",
    depth_top = 1,
    node_filler = "default:sand",
    depth_filler = 3,
    node_riverbed = "default:sand",
    depth_riverbed = 2,
    node_cave_liquid = "default:water_source",
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    vertical_blend = 1,
    y_max = 3,
    y_min = -255,
    heat_point = 20,
    humidity_point = 35,
  })

  engine.register_biome({
    name = "snowy_grassland_under",
    node_cave_liquid = {"default:water_source", "default:lava_source"},
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    y_max = -256,
    y_min = -31000,
    heat_point = 20,
    humidity_point = 35,
  })

  -- Grassland

  engine.register_biome({
    name = "grassland",
    node_top = "default:dirt_with_grass",
    depth_top = 1,
    node_filler = "default:dirt",
    depth_filler = 1,
    node_riverbed = "default:sand",
    depth_riverbed = 2,
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    y_max = 31000,
    y_min = 6,
    heat_point = 50,
    humidity_point = 35,
  })

  engine.register_biome({
    name = "grassland_dunes",
    node_top = "default:sand",
    depth_top = 1,
    node_filler = "default:sand",
    depth_filler = 2,
    node_riverbed = "default:sand",
    depth_riverbed = 2,
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    vertical_blend = 1,
    y_max = 5,
    y_min = 4,
    heat_point = 50,
    humidity_point = 35,
  })

  engine.register_biome({
    name = "grassland_ocean",
    node_top = "default:sand",
    depth_top = 1,
    node_filler = "default:sand",
    depth_filler = 3,
    node_riverbed = "default:sand",
    depth_riverbed = 2,
    node_cave_liquid = "default:water_source",
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    y_max = 3,
    y_min = -255,
    heat_point = 50,
    humidity_point = 35,
  })

  engine.register_biome({
    name = "grassland_under",
    node_cave_liquid = {"default:water_source", "default:lava_source"},
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    y_max = -256,
    y_min = -31000,
    heat_point = 50,
    humidity_point = 35,
  })

  -- Coniferous forest

  engine.register_biome({
    name = "coniferous_forest",
    node_top = "default:dirt_with_coniferous_litter",
    depth_top = 1,
    node_filler = "default:dirt",
    depth_filler = 3,
    node_riverbed = "default:sand",
    depth_riverbed = 2,
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    y_max = 31000,
    y_min = 6,
    heat_point = 45,
    humidity_point = 70,
  })

  engine.register_biome({
    name = "coniferous_forest_dunes",
    node_top = "default:sand",
    depth_top = 1,
    node_filler = "default:sand",
    depth_filler = 3,
    node_riverbed = "default:sand",
    depth_riverbed = 2,
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    vertical_blend = 1,
    y_max = 5,
    y_min = 4,
    heat_point = 45,
    humidity_point = 70,
  })

  engine.register_biome({
    name = "coniferous_forest_ocean",
    node_top = "default:sand",
    depth_top = 1,
    node_filler = "default:sand",
    depth_filler = 3,
    node_riverbed = "default:sand",
    depth_riverbed = 2,
    node_cave_liquid = "default:water_source",
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    y_max = 3,
    y_min = -255,
    heat_point = 45,
    humidity_point = 70,
  })

  engine.register_biome({
    name = "coniferous_forest_under",
    node_cave_liquid = {"default:water_source", "default:lava_source"},
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    y_max = -256,
    y_min = -31000,
    heat_point = 45,
    humidity_point = 70,
  })

  -- Deciduous forest

  engine.register_biome({
    name = "deciduous_forest",
    node_top = "default:dirt_with_grass",
    depth_top = 1,
    node_filler = "default:dirt",
    depth_filler = 3,
    node_riverbed = "default:sand",
    depth_riverbed = 2,
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    y_max = 31000,
    y_min = 1,
    heat_point = 60,
    humidity_point = 68,
  })

  engine.register_biome({
    name = "deciduous_forest_shore",
    node_top = "default:dirt",
    depth_top = 1,
    node_filler = "default:dirt",
    depth_filler = 3,
    node_riverbed = "default:sand",
    depth_riverbed = 2,
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    y_max = 0,
    y_min = -1,
    heat_point = 60,
    humidity_point = 68,
  })

  engine.register_biome({
    name = "deciduous_forest_ocean",
    node_top = "default:sand",
    depth_top = 1,
    node_filler = "default:sand",
    depth_filler = 3,
    node_riverbed = "default:sand",
    depth_riverbed = 2,
    node_cave_liquid = "default:water_source",
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    vertical_blend = 1,
    y_max = -2,
    y_min = -255,
    heat_point = 60,
    humidity_point = 68,
  })

  engine.register_biome({
    name = "deciduous_forest_under",
    node_cave_liquid = {"default:water_source", "default:lava_source"},
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    y_max = -256,
    y_min = -31000,
    heat_point = 60,
    humidity_point = 68,
  })

  -- Desert

  engine.register_biome({
    name = "desert",
    node_top = "default:desert_sand",
    depth_top = 1,
    node_filler = "default:desert_sand",
    depth_filler = 1,
    node_stone = "default:desert_stone",
    node_riverbed = "default:sand",
    depth_riverbed = 2,
    node_dungeon = "default:desert_stone",
    node_dungeon_stair = "stairs:stair_desert_stone",
    y_max = 31000,
    y_min = 4,
    heat_point = 92,
    humidity_point = 16,
  })

  engine.register_biome({
    name = "desert_ocean",
    node_top = "default:sand",
    depth_top = 1,
    node_filler = "default:sand",
    depth_filler = 3,
    node_stone = "default:desert_stone",
    node_riverbed = "default:sand",
    depth_riverbed = 2,
    node_cave_liquid = "default:water_source",
    node_dungeon = "default:desert_stone",
    node_dungeon_stair = "stairs:stair_desert_stone",
    vertical_blend = 1,
    y_max = 3,
    y_min = -255,
    heat_point = 92,
    humidity_point = 16,
  })

  engine.register_biome({
    name = "desert_under",
    node_cave_liquid = {"default:water_source", "default:lava_source"},
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    y_max = -256,
    y_min = -31000,
    heat_point = 92,
    humidity_point = 16,
  })

  -- Sandstone desert

  engine.register_biome({
    name = "sandstone_desert",
    node_top = "default:sand",
    depth_top = 1,
    node_filler = "default:sand",
    depth_filler = 1,
    node_stone = "default:sandstone",
    node_riverbed = "default:sand",
    depth_riverbed = 2,
    node_dungeon = "default:sandstonebrick",
    node_dungeon_stair = "stairs:stair_sandstone_block",
    y_max = 31000,
    y_min = 4,
    heat_point = 60,
    humidity_point = 0,
  })

  engine.register_biome({
    name = "sandstone_desert_ocean",
    node_top = "default:sand",
    depth_top = 1,
    node_filler = "default:sand",
    depth_filler = 3,
    node_stone = "default:sandstone",
    node_riverbed = "default:sand",
    depth_riverbed = 2,
    node_cave_liquid = "default:water_source",
    node_dungeon = "default:sandstonebrick",
    node_dungeon_stair = "stairs:stair_sandstone_block",
    y_max = 3,
    y_min = -255,
    heat_point = 60,
    humidity_point = 0,
  })

  engine.register_biome({
    name = "sandstone_desert_under",
    node_cave_liquid = {"default:water_source", "default:lava_source"},
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    y_max = -256,
    y_min = -31000,
    heat_point = 60,
    humidity_point = 0,
  })

  -- Cold desert

  engine.register_biome({
    name = "cold_desert",
    node_top = "default:silver_sand",
    depth_top = 1,
    node_filler = "default:silver_sand",
    depth_filler = 1,
    node_riverbed = "default:sand",
    depth_riverbed = 2,
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    y_max = 31000,
    y_min = 4,
    heat_point = 40,
    humidity_point = 0,
  })

  engine.register_biome({
    name = "cold_desert_ocean",
    node_top = "default:sand",
    depth_top = 1,
    node_filler = "default:sand",
    depth_filler = 3,
    node_riverbed = "default:sand",
    depth_riverbed = 2,
    node_cave_liquid = "default:water_source",
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    vertical_blend = 1,
    y_max = 3,
    y_min = -255,
    heat_point = 40,
    humidity_point = 0,
  })

  engine.register_biome({
    name = "cold_desert_under",
    node_cave_liquid = {"default:water_source", "default:lava_source"},
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    y_max = -256,
    y_min = -31000,
    heat_point = 40,
    humidity_point = 0,
  })

  -- Savanna

  engine.register_biome({
    name = "savanna",
    node_top = "default:dry_dirt_with_dry_grass",
    depth_top = 1,
    node_filler = "default:dry_dirt",
    depth_filler = 1,
    node_riverbed = "default:sand",
    depth_riverbed = 2,
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    y_max = 31000,
    y_min = 1,
    heat_point = 89,
    humidity_point = 42,
  })

  engine.register_biome({
    name = "savanna_shore",
    node_top = "default:dry_dirt",
    depth_top = 1,
    node_filler = "default:dry_dirt",
    depth_filler = 3,
    node_riverbed = "default:sand",
    depth_riverbed = 2,
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    y_max = 0,
    y_min = -1,
    heat_point = 89,
    humidity_point = 42,
  })

  engine.register_biome({
    name = "savanna_ocean",
    node_top = "default:sand",
    depth_top = 1,
    node_filler = "default:sand",
    depth_filler = 3,
    node_riverbed = "default:sand",
    depth_riverbed = 2,
    node_cave_liquid = "default:water_source",
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    vertical_blend = 1,
    y_max = -2,
    y_min = -255,
    heat_point = 89,
    humidity_point = 42,
  })

  engine.register_biome({
    name = "savanna_under",
    node_cave_liquid = {"default:water_source", "default:lava_source"},
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    y_max = -256,
    y_min = -31000,
    heat_point = 89,
    humidity_point = 42,
  })

  -- Rainforest

  engine.register_biome({
    name = "rainforest",
    node_top = "default:dirt_with_rainforest_litter",
    depth_top = 1,
    node_filler = "default:dirt",
    depth_filler = 3,
    node_riverbed = "default:sand",
    depth_riverbed = 2,
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    y_max = 31000,
    y_min = 1,
    heat_point = 86,
    humidity_point = 65,
  })

  engine.register_biome({
    name = "rainforest_swamp",
    node_top = "default:dirt",
    depth_top = 1,
    node_filler = "default:dirt",
    depth_filler = 3,
    node_riverbed = "default:sand",
    depth_riverbed = 2,
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    y_max = 0,
    y_min = -1,
    heat_point = 86,
    humidity_point = 65,
  })

  engine.register_biome({
    name = "rainforest_ocean",
    node_top = "default:sand",
    depth_top = 1,
    node_filler = "default:sand",
    depth_filler = 3,
    node_riverbed = "default:sand",
    depth_riverbed = 2,
    node_cave_liquid = "default:water_source",
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    vertical_blend = 1,
    y_max = -2,
    y_min = -255,
    heat_point = 86,
    humidity_point = 65,
  })

  engine.register_biome({
    name = "rainforest_under",
    node_cave_liquid = {"default:water_source", "default:lava_source"},
    node_dungeon = "default:cobble",
    node_dungeon_alt = "default:mossycobble",
    node_dungeon_stair = "stairs:stair_cobble",
    y_max = -256,
    y_min = -31000,
    heat_point = 86,
    humidity_point = 65,
  })
end


--
-- Register decorations
--

-- Mgv6

function default.register_mgv6_decorations()

  -- Papyrus

  engine.register_decoration({
    name = "default:papyrus",
    deco_type = "simple",
    place_on = {"default:dirt_with_grass"},
    sidelen = 16,
    noise_params = {
      offset = -0.3,
      scale = 0.7,
      spread = {x = 100, y = 100, z = 100},
      seed = 354,
      octaves = 3,
      persist = 0.7
    },
    y_max = 1,
    y_min = 1,
    decoration = "default:papyrus",
    height = 2,
    height_max = 4,
    spawn_by = "default:water_source",
    num_spawn_by = 1,
  })

  -- Cacti

  engine.register_decoration({
    name = "default:cactus",
    deco_type = "simple",
    place_on = {"default:desert_sand"},
    sidelen = 16,
    noise_params = {
      offset = -0.012,
      scale = 0.024,
      spread = {x = 100, y = 100, z = 100},
      seed = 230,
      octaves = 3,
      persist = 0.6
    },
    y_max = 30,
    y_min = 1,
    decoration = "default:cactus",
    height = 3,
          height_max = 4,
  })

  -- Long grasses

  for length = 1, 5 do
    engine.register_decoration({
      name = "default:grass_"..length,
      deco_type = "simple",
      place_on = {"default:dirt_with_grass"},
      sidelen = 16,
      noise_params = {
        offset = 0,
        scale = 0.007,
        spread = {x = 100, y = 100, z = 100},
        seed = 329,
        octaves = 3,
        persist = 0.6
      },
      y_max = 30,
      y_min = 1,
      decoration = "default:grass_"..length,
    })
  end

  -- Dry shrubs

  engine.register_decoration({
    name = "default:dry_shrub",
    deco_type = "simple",
    place_on = {"default:desert_sand", "default:dirt_with_snow"},
    sidelen = 16,
    noise_params = {
      offset = 0,
      scale = 0.035,
      spread = {x = 100, y = 100, z = 100},
      seed = 329,
      octaves = 3,
      persist = 0.6
    },
    y_max = 30,
    y_min = 1,
    decoration = "default:dry_shrub",
    param2 = 4,
  })
end


-- All mapgens except mgv6

local function register_grass_decoration(offset, scale, length)
  engine.register_decoration({
    name = "default:grass_" .. length,
    deco_type = "simple",
    place_on = {"default:dirt_with_grass"},
    sidelen = 16,
    noise_params = {
      offset = offset,
      scale = scale,
      spread = {x = 200, y = 200, z = 200},
      seed = 329,
      octaves = 3,
      persist = 0.6
    },
    biomes = {"grassland", "deciduous_forest"},
    y_max = 31000,
    y_min = 1,
    decoration = "default:grass_" .. length,
  })
end

local function register_dry_grass_decoration(offset, scale, length)
  engine.register_decoration({
    name = "default:dry_grass_" .. length,
    deco_type = "simple",
    place_on = {"default:dry_dirt_with_dry_grass"},
    sidelen = 16,
    noise_params = {
      offset = offset,
      scale = scale,
      spread = {x = 200, y = 200, z = 200},
      seed = 329,
      octaves = 3,
      persist = 0.6
    },
    biomes = {"savanna"},
    y_max = 31000,
    y_min = 1,
    decoration = "default:dry_grass_" .. length,
  })
end

local function register_fern_decoration(seed, length)
  engine.register_decoration({
    name = "default:fern_" .. length,
    deco_type = "simple",
    place_on = {"default:dirt_with_coniferous_litter"},
    sidelen = 16,
    noise_params = {
      offset = 0,
      scale = 0.2,
      spread = {x = 100, y = 100, z = 100},
      seed = seed,
      octaves = 3,
      persist = 0.7
    },
    biomes = {"coniferous_forest"},
    y_max = 31000,
    y_min = 6,
    decoration = "default:fern_" .. length,
  })
end


function default.register_decorations()
  -- Savanna bare dirt patches.
  -- Must come before all savanna decorations that are placed on dry grass.
  -- Noise is similar to long dry grass noise, but scale inverted, to appear
  -- where long dry grass is least dense and shortest.

  engine.register_decoration({
    deco_type = "simple",
    place_on = {"default:dry_dirt_with_dry_grass"},
    sidelen = 4,
    noise_params = {
      offset = -1.5,
      scale = -1.5,
      spread = {x = 200, y = 200, z = 200},
      seed = 329,
      octaves = 4,
      persist = 1.0
    },
    biomes = {"savanna"},
    y_max = 31000,
    y_min = 1,
    decoration = "default:dry_dirt",
    place_offset_y = -1,
    flags = "force_placement",
  })

  -- Apple tree and log

  engine.register_decoration({
    name = "default:apple_tree",
    deco_type = "schematic",
    place_on = {"default:dirt_with_grass"},
    sidelen = 16,
    noise_params = {
      offset = 0.024,
      scale = 0.015,
      spread = {x = 250, y = 250, z = 250},
      seed = 2,
      octaves = 3,
      persist = 0.66
    },
    biomes = {"deciduous_forest"},
    y_max = 31000,
    y_min = 1,
    schematic = engine.get_modpath("default") .. "/schematics/apple_tree.mts",
    flags = "place_center_x, place_center_z",
    rotation = "random",
  })

  engine.register_decoration({
    name = "default:apple_log",
    deco_type = "schematic",
    place_on = {"default:dirt_with_grass"},
    place_offset_y = 1,
    sidelen = 16,
    noise_params = {
      offset = 0.0012,
      scale = 0.0007,
      spread = {x = 250, y = 250, z = 250},
      seed = 2,
      octaves = 3,
      persist = 0.66
    },
    biomes = {"deciduous_forest"},
    y_max = 31000,
    y_min = 1,
    schematic = engine.get_modpath("default") .. "/schematics/apple_log.mts",
    flags = "place_center_x",
    rotation = "random",
    spawn_by = "default:dirt_with_grass",
    num_spawn_by = 8,
  })

  -- Emergent jungle tree
  -- Due to 32 node height, altitude is limited and prescence depends on chunksize

  local chunksize = tonumber(engine.get_mapgen_setting("chunksize"))
  if chunksize >= 5 then
    engine.register_decoration({
      name = "default:emergent_jungle_tree",
      deco_type = "schematic",
      place_on = {"default:dirt_with_rainforest_litter"},
      sidelen = 80,
      noise_params = {
        offset = 0.0,
        scale = 0.0025,
        spread = {x = 250, y = 250, z = 250},
        seed = 2685,
        octaves = 3,
        persist = 0.7
      },
      biomes = {"rainforest"},
      y_max = 32,
      y_min = 1,
      schematic = engine.get_modpath("default") ..
          "/schematics/emergent_jungle_tree.mts",
      flags = "place_center_x, place_center_z",
      rotation = "random",
      place_offset_y = -4,
    })
  end

  -- Jungle tree and log

  engine.register_decoration({
    name = "default:jungle_tree",
    deco_type = "schematic",
    place_on = {"default:dirt_with_rainforest_litter"},
    sidelen = 80,
    fill_ratio = 0.1,
    biomes = {"rainforest"},
    y_max = 31000,
    y_min = 1,
    schematic = engine.get_modpath("default") .. "/schematics/jungle_tree.mts",
    flags = "place_center_x, place_center_z",
    rotation = "random",
  })

  -- Swamp jungle trees

  engine.register_decoration({
    name = "default:jungle_tree(swamp)",
    deco_type = "schematic",
    place_on = {"default:dirt"},
    sidelen = 16,
    -- Noise tuned to place swamp trees where papyrus is absent
    noise_params = {
      offset = 0.0,
      scale = -0.1,
      spread = {x = 200, y = 200, z = 200},
      seed = 354,
      octaves = 1,
      persist = 0.5
    },
    biomes = {"rainforest_swamp"},
    y_max = 0,
    y_min = -1,
    schematic = engine.get_modpath("default") .. "/schematics/jungle_tree.mts",
    flags = "place_center_x, place_center_z",
    rotation = "random",
  })

  engine.register_decoration({
    name = "default:jungle_log",
    deco_type = "schematic",
    place_on = {"default:dirt_with_rainforest_litter"},
    place_offset_y = 1,
    sidelen = 80,
    fill_ratio = 0.005,
    biomes = {"rainforest"},
    y_max = 31000,
    y_min = 1,
    schematic = engine.get_modpath("default") .. "/schematics/jungle_log.mts",
    flags = "place_center_x",
    rotation = "random",
    spawn_by = "default:dirt_with_rainforest_litter",
    num_spawn_by = 8,
  })

  -- Taiga and temperate coniferous forest pine tree, small pine tree and log

  engine.register_decoration({
    name = "default:pine_tree",
    deco_type = "schematic",
    place_on = {"default:dirt_with_snow", "default:dirt_with_coniferous_litter"},
    sidelen = 16,
    noise_params = {
      offset = 0.010,
      scale = 0.048,
      spread = {x = 250, y = 250, z = 250},
      seed = 2,
      octaves = 3,
      persist = 0.66
    },
    biomes = {"taiga", "coniferous_forest"},
    y_max = 31000,
    y_min = 4,
    schematic = engine.get_modpath("default") .. "/schematics/pine_tree.mts",
    flags = "place_center_x, place_center_z",
  })

  engine.register_decoration({
    name = "default:small_pine_tree",
    deco_type = "schematic",
    place_on = {"default:dirt_with_snow", "default:dirt_with_coniferous_litter"},
    sidelen = 16,
    noise_params = {
      offset = 0.010,
      scale = -0.048,
      spread = {x = 250, y = 250, z = 250},
      seed = 2,
      octaves = 3,
      persist = 0.66
    },
    biomes = {"taiga", "coniferous_forest"},
    y_max = 31000,
    y_min = 4,
    schematic = engine.get_modpath("default") .. "/schematics/small_pine_tree.mts",
    flags = "place_center_x, place_center_z",
  })

  engine.register_decoration({
    name = "default:pine_log",
    deco_type = "schematic",
    place_on = {"default:dirt_with_snow", "default:dirt_with_coniferous_litter"},
    place_offset_y = 1,
    sidelen = 80,
    fill_ratio = 0.0018,
    biomes = {"taiga", "coniferous_forest"},
    y_max = 31000,
    y_min = 4,
    schematic = engine.get_modpath("default") .. "/schematics/pine_log.mts",
    flags = "place_center_x",
    rotation = "random",
    spawn_by = {"default:dirt_with_snow", "default:dirt_with_coniferous_litter"},
    num_spawn_by = 8,
  })

  -- Acacia tree and log

  engine.register_decoration({
    name = "default:acacia_tree",
    deco_type = "schematic",
    place_on = {"default:dry_dirt_with_dry_grass"},
    sidelen = 16,
    noise_params = {
      offset = 0,
      scale = 0.002,
      spread = {x = 250, y = 250, z = 250},
      seed = 2,
      octaves = 3,
      persist = 0.66
    },
    biomes = {"savanna"},
    y_max = 31000,
    y_min = 1,
    schematic = engine.get_modpath("default") .. "/schematics/acacia_tree.mts",
    flags = "place_center_x, place_center_z",
    rotation = "random",
  })

  engine.register_decoration({
    name = "default:acacia_log",
    deco_type = "schematic",
    place_on = {"default:dry_dirt_with_dry_grass"},
    place_offset_y = 1,
    sidelen = 16,
    noise_params = {
      offset = 0,
      scale = 0.001,
      spread = {x = 250, y = 250, z = 250},
      seed = 2,
      octaves = 3,
      persist = 0.66
    },
    biomes = {"savanna"},
    y_max = 31000,
    y_min = 1,
    schematic = engine.get_modpath("default") .. "/schematics/acacia_log.mts",
    flags = "place_center_x",
    rotation = "random",
    spawn_by = "default:dry_dirt_with_dry_grass",
    num_spawn_by = 8,
  })

  -- Aspen tree and log

  engine.register_decoration({
    name = "default:aspen_tree",
    deco_type = "schematic",
    place_on = {"default:dirt_with_grass"},
    sidelen = 16,
    noise_params = {
      offset = 0.0,
      scale = -0.015,
      spread = {x = 250, y = 250, z = 250},
      seed = 2,
      octaves = 3,
      persist = 0.66
    },
    biomes = {"deciduous_forest"},
    y_max = 31000,
    y_min = 1,
    schematic = engine.get_modpath("default") .. "/schematics/aspen_tree.mts",
    flags = "place_center_x, place_center_z",
  })

  engine.register_decoration({
    name = "default:aspen_log",
    deco_type = "schematic",
    place_on = {"default:dirt_with_grass"},
    place_offset_y = 1,
    sidelen = 16,
    noise_params = {
      offset = 0.0,
      scale = -0.0008,
      spread = {x = 250, y = 250, z = 250},
      seed = 2,
      octaves = 3,
      persist = 0.66
    },
    biomes = {"deciduous_forest"},
    y_max = 31000,
    y_min = 1,
    schematic = engine.get_modpath("default") .. "/schematics/aspen_log.mts",
    flags = "place_center_x",
    rotation = "random",
    spawn_by = "default:dirt_with_grass",
    num_spawn_by = 8,
  })

  -- Large cactus

  engine.register_decoration({
    name = "default:large_cactus",
    deco_type = "schematic",
    place_on = {"default:desert_sand"},
    sidelen = 16,
    noise_params = {
      offset = -0.0003,
      scale = 0.0009,
      spread = {x = 200, y = 200, z = 200},
      seed = 230,
      octaves = 3,
      persist = 0.6
    },
    biomes = {"desert"},
    y_max = 31000,
    y_min = 4,
    schematic = engine.get_modpath("default") .. "/schematics/large_cactus.mts",
    flags = "place_center_x, place_center_z",
    rotation = "random",
  })

  -- Cactus

  engine.register_decoration({
    name = "default:cactus",
    deco_type = "simple",
    place_on = {"default:desert_sand"},
    sidelen = 16,
    noise_params = {
      offset = -0.0003,
      scale = 0.0009,
      spread = {x = 200, y = 200, z = 200},
      seed = 230,
      octaves = 3,
      persist = 0.6
    },
    biomes = {"desert"},
    y_max = 31000,
    y_min = 4,
    decoration = "default:cactus",
    height = 2,
    height_max = 5,
  })

  -- Papyrus

  -- Dirt version for rainforest swamp

  engine.register_decoration({
    name = "default:papyrus_on_dirt",
    deco_type = "schematic",
    place_on = {"default:dirt"},
    sidelen = 16,
    noise_params = {
      offset = -0.3,
      scale = 0.7,
      spread = {x = 200, y = 200, z = 200},
      seed = 354,
      octaves = 3,
      persist = 0.7
    },
    biomes = {"rainforest_swamp"},
    y_max = 0,
    y_min = 0,
    schematic = engine.get_modpath("default") .. "/schematics/papyrus_on_dirt.mts",
  })

  -- Dry dirt version for savanna shore

  engine.register_decoration({
    name = "default:papyrus_on_dry_dirt",
    deco_type = "schematic",
    place_on = {"default:dry_dirt"},
    sidelen = 16,
    noise_params = {
      offset = -0.3,
      scale = 0.7,
      spread = {x = 200, y = 200, z = 200},
      seed = 354,
      octaves = 3,
      persist = 0.7
    },
    biomes = {"savanna_shore"},
    y_max = 0,
    y_min = 0,
    schematic = engine.get_modpath("default") ..
      "/schematics/papyrus_on_dry_dirt.mts",
  })

  -- Bush

  engine.register_decoration({
    name = "default:bush",
    deco_type = "schematic",
    place_on = {"default:dirt_with_grass"},
    sidelen = 16,
    noise_params = {
      offset = -0.004,
      scale = 0.01,
      spread = {x = 100, y = 100, z = 100},
      seed = 137,
      octaves = 3,
      persist = 0.7,
    },
    biomes = {"grassland", "deciduous_forest"},
    y_max = 31000,
    y_min = 1,
    schematic = engine.get_modpath("default") .. "/schematics/bush.mts",
    flags = "place_center_x, place_center_z",
  })

  -- Blueberry bush

  engine.register_decoration({
    name = "default:blueberry_bush",
    deco_type = "schematic",
    place_on = {"default:dirt_with_grass", "default:dirt_with_snow"},
    sidelen = 16,
    noise_params = {
      offset = -0.004,
      scale = 0.01,
      spread = {x = 100, y = 100, z = 100},
      seed = 697,
      octaves = 3,
      persist = 0.7,
    },
    biomes = {"grassland", "snowy_grassland"},
    y_max = 31000,
    y_min = 1,
    place_offset_y = 1,
    schematic = engine.get_modpath("default") .. "/schematics/blueberry_bush.mts",
    flags = "place_center_x, place_center_z",
  })

  -- Acacia bush

  engine.register_decoration({
    name = "default:acacia_bush",
    deco_type = "schematic",
    place_on = {"default:dry_dirt_with_dry_grass"},
    sidelen = 16,
    noise_params = {
      offset = -0.004,
      scale = 0.01,
      spread = {x = 100, y = 100, z = 100},
      seed = 90155,
      octaves = 3,
      persist = 0.7,
    },
    biomes = {"savanna"},
    y_max = 31000,
    y_min = 1,
    schematic = engine.get_modpath("default") .. "/schematics/acacia_bush.mts",
    flags = "place_center_x, place_center_z",
  })

  -- Pine bush

  engine.register_decoration({
    name = "default:pine_bush",
    deco_type = "schematic",
    place_on = {"default:dirt_with_snow"},
    sidelen = 16,
    noise_params = {
      offset = -0.004,
      scale = 0.01,
      spread = {x = 100, y = 100, z = 100},
      seed = 137,
      octaves = 3,
      persist = 0.7,
    },
    biomes = {"taiga", "snowy_grassland"},
    y_max = 31000,
    y_min = 4,
    schematic = engine.get_modpath("default") .. "/schematics/pine_bush.mts",
    flags = "place_center_x, place_center_z",
  })

  -- Grasses

  register_grass_decoration(-0.03,  0.09,  5)
  register_grass_decoration(-0.015, 0.075, 4)
  register_grass_decoration(0,      0.06,  3)
  register_grass_decoration(0.015,  0.045, 2)
  register_grass_decoration(0.03,   0.03,  1)

  -- Dry grasses

  register_dry_grass_decoration(0.01, 0.05,  5)
  register_dry_grass_decoration(0.03, 0.03,  4)
  register_dry_grass_decoration(0.05, 0.01,  3)
  register_dry_grass_decoration(0.07, -0.01, 2)
  register_dry_grass_decoration(0.09, -0.03, 1)

  -- Ferns

  register_fern_decoration(14936, 3)
  register_fern_decoration(801,   2)
  register_fern_decoration(5,     1)

  -- Junglegrass

  engine.register_decoration({
    name = "default:jungle_grass",
    deco_type = "simple",
    place_on = {"default:dirt_with_rainforest_litter"},
    sidelen = 80,
    fill_ratio = 0.1,
    biomes = {"rainforest"},
    y_max = 31000,
    y_min = 1,
    decoration = "default:jungle_grass",
  })

  -- Dry shrub

  engine.register_decoration({
    name = "default:dry_shrub",
    deco_type = "simple",
    place_on = {"default:desert_sand",
      "default:sand", "default:silver_sand"},
    sidelen = 16,
    noise_params = {
      offset = 0,
      scale = 0.02,
      spread = {x = 200, y = 200, z = 200},
      seed = 329,
      octaves = 3,
      persist = 0.6
    },
    biomes = {"desert", "sandstone_desert", "cold_desert"},
    y_max = 31000,
    y_min = 2,
    decoration = "default:dry_shrub",
    param2 = 4,
  })

  -- Marram grass

  engine.register_decoration({
    name = "default:marram_grass",
    deco_type = "simple",
    place_on = {"default:sand"},
    sidelen = 4,
    noise_params = {
      offset = -0.7,
      scale = 4.0,
      spread = {x = 16, y = 16, z = 16},
      seed = 513337,
      octaves = 1,
      persist = 0.0,
      flags = "absvalue, eased"
    },
    biomes = {"coniferous_forest_dunes", "grassland_dunes"},
    y_max = 6,
    y_min = 4,
    decoration = {
      "default:marram_grass_1",
      "default:marram_grass_2",
      "default:marram_grass_3",
    },
  })

  -- Tundra moss

  engine.register_decoration({
    deco_type = "simple",
    place_on = {"default:permafrost_with_stones"},
    sidelen = 4,
    noise_params = {
      offset = -0.8,
      scale = 2.0,
      spread = {x = 100, y = 100, z = 100},
      seed = 53995,
      octaves = 3,
      persist = 1.0
    },
    biomes = {"tundra"},
    y_max = 50,
    y_min = 2,
    decoration = "default:permafrost_with_moss",
    place_offset_y = -1,
    flags = "force_placement",
  })

  -- Tundra patchy snow

  engine.register_decoration({
    deco_type = "simple",
    place_on = {
      "default:permafrost_with_moss",
      "default:permafrost_with_stones",
      "default:stone",
      "default:gravel"
    },
    sidelen = 4,
    noise_params = {
      offset = 0,
      scale = 1.0,
      spread = {x = 100, y = 100, z = 100},
      seed = 172555,
      octaves = 3,
      persist = 1.0
    },
    biomes = {"tundra", "tundra_beach"},
    y_max = 50,
    y_min = 1,
    decoration = "default:snow",
  })

  -- Coral reef

  engine.register_decoration({
    name = "default:corals",
    deco_type = "simple",
    place_on = {"default:sand"},
    place_offset_y = -1,
    sidelen = 4,
    noise_params = {
      offset = -4,
      scale = 4,
      spread = {x = 50, y = 50, z = 50},
      seed = 7013,
      octaves = 3,
      persist = 0.7,
    },
    biomes = {
      "desert_ocean",
      "savanna_ocean",
      "rainforest_ocean",
    },
    y_max = -2,
    y_min = -8,
    flags = "force_placement",
    decoration = {
      "default:coral_green", "default:coral_pink",
      "default:coral_cyan", "default:coral_brown",
      "default:coral_orange", "default:coral_skeleton",
    },
  })

  -- Kelp

  engine.register_decoration({
    name = "default:kelp",
    deco_type = "simple",
    place_on = {"default:sand"},
    place_offset_y = -1,
    sidelen = 16,
    noise_params = {
      offset = -0.04,
      scale = 0.1,
      spread = {x = 200, y = 200, z = 200},
      seed = 87112,
      octaves = 3,
      persist = 0.7
    },
    biomes = {
      "taiga_ocean",
      "snowy_grassland_ocean",
      "grassland_ocean",
      "coniferous_forest_ocean",
      "deciduous_forest_ocean",
      "sandstone_desert_ocean",
      "cold_desert_ocean"},
    y_max = -5,
    y_min = -10,
    flags = "force_placement",
    decoration = "default:sand_with_kelp",
    param2 = 48,
    param2_max = 96,
  })
end


--
-- Detect mapgen to select functions
--

engine.clear_registered_biomes()
engine.clear_registered_ores()
engine.clear_registered_decorations()

local mg_name = engine.get_mapgen_setting("mg_name")

if mg_name == "v6" then
  default.register_mgv6_ores()
  default.register_mgv6_decorations()
else
  default.register_biomes()
  default.register_ores()
  default.register_decorations()
end
