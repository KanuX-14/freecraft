-- farming/nodes.lua

-- support for MT game translation.
local S = farming.get_translator

engine.override_item("default:dirt", {
  soil = {
    base = "default:dirt",
    dry = "farming:soil",
    wet = "farming:soil_wet"
  }
})

engine.override_item("default:dirt_with_grass", {
  soil = {
    base = "default:dirt_with_grass",
    dry = "farming:soil",
    wet = "farming:soil_wet"
  }
})

engine.override_item("default:dirt_with_dry_grass", {
  soil = {
    base = "default:dirt_with_dry_grass",
    dry = "farming:soil",
    wet = "farming:soil_wet"
  }
})

engine.override_item("default:dirt_with_rainforest_litter", {
  soil = {
    base = "default:dirt_with_rainforest_litter",
    dry = "farming:soil",
    wet = "farming:soil_wet"
  }
})

engine.override_item("default:dirt_with_coniferous_litter", {
  soil = {
    base = "default:dirt_with_coniferous_litter",
    dry = "farming:soil",
    wet = "farming:soil_wet"
  }
})

engine.override_item("default:dry_dirt", {
  soil = {
    base = "default:dry_dirt",
    dry = "farming:dry_soil",
    wet = "farming:dry_soil_wet"
  }
})

engine.override_item("default:dry_dirt_with_dry_grass", {
  soil = {
    base = "default:dry_dirt_with_dry_grass",
    dry = "farming:dry_soil",
    wet = "farming:dry_soil_wet"
  }
})

engine.register_node("farming:soil", {
  description = S("Soil"),
  tiles = {"default_dirt.png^farming_soil.png", "default_dirt.png"},
  drop = "default:dirt",
  groups = {crumbly=3, not_in_creative_inventory=1, soil=2, grassland = 1, field = 1},
  sounds = default.node_sound_dirt_defaults(),
  soil = {
    base = "default:dirt",
    dry = "farming:soil",
    wet = "farming:soil_wet"
  }
})

engine.register_node("farming:soil_wet", {
  description = S("Wet Soil"),
  tiles = {"default_dirt.png^farming_soil_wet.png", "default_dirt.png^farming_soil_wet_side.png"},
  drop = "default:dirt",
  groups = {crumbly=3, not_in_creative_inventory=1, soil=3, wet = 1, grassland = 1, field = 1},
  sounds = default.node_sound_dirt_defaults(),
  soil = {
    base = "default:dirt",
    dry = "farming:soil",
    wet = "farming:soil_wet"
  }
})

engine.register_node("farming:dry_soil", {
  description = S("Savanna Soil"),
  tiles = {"default_dry_dirt.png^farming_soil.png", "default_dry_dirt.png"},
  drop = "default:dry_dirt",
  groups = {crumbly=3, not_in_creative_inventory=1, soil=2, grassland = 1, field = 1},
  sounds = default.node_sound_dirt_defaults(),
  soil = {
    base = "default:dry_dirt",
    dry = "farming:dry_soil",
    wet = "farming:dry_soil_wet"
  }
})

engine.register_node("farming:dry_soil_wet", {
  description = S("Wet Savanna Soil"),
  tiles = {"default_dry_dirt.png^farming_soil_wet.png", "default_dry_dirt.png^farming_soil_wet_side.png"},
  drop = "default:dry_dirt",
  groups = {crumbly=3, not_in_creative_inventory=1, soil=3, wet = 1, grassland = 1, field = 1},
  sounds = default.node_sound_dirt_defaults(),
  soil = {
    base = "default:dry_dirt",
    dry = "farming:dry_soil",
    wet = "farming:dry_soil_wet"
  }
})

engine.override_item("default:desert_sand", {
  groups = {crumbly=3, falling_node=1, sand=1, soil = 1},
  soil = {
    base = "default:desert_sand",
    dry = "farming:desert_sand_soil",
    wet = "farming:desert_sand_soil_wet"
  }
})
engine.register_node("farming:desert_sand_soil", {
  description = S("Desert Sand Soil"),
  drop = "default:desert_sand",
  tiles = {"farming_desert_sand_soil.png", "default_desert_sand.png"},
  groups = {crumbly=3, not_in_creative_inventory = 1, falling_node=1, sand=1, soil = 2, desert = 1, field = 1},
  sounds = default.node_sound_sand_defaults(),
  soil = {
    base = "default:desert_sand",
    dry = "farming:desert_sand_soil",
    wet = "farming:desert_sand_soil_wet"
  }
})

engine.register_node("farming:desert_sand_soil_wet", {
  description = S("Wet Desert Sand Soil"),
  drop = "default:desert_sand",
  tiles = {"farming_desert_sand_soil_wet.png", "farming_desert_sand_soil_wet_side.png"},
  groups = {crumbly=3, falling_node=1, sand=1, not_in_creative_inventory=1, soil=3, wet = 1, desert = 1, field = 1},
  sounds = default.node_sound_sand_defaults(),
  soil = {
    base = "default:desert_sand",
    dry = "farming:desert_sand_soil",
    wet = "farming:desert_sand_soil_wet"
  }
})

engine.register_node("farming:straw", {
  description = S("Straw"),
  tiles = {"farming_straw.png"},
  is_ground_content = false,
  groups = {snappy=3, flammable=4, fall_damage_add_percent=-30},
  sounds = default.node_sound_leaves_defaults(),
})

-- Registered before the stairs so the stairs get fuel recipes.
engine.register_craft({
  type = "fuel",
  recipe = "farming:straw",
  burntime = 3,
})

do
  local recipe = "farming:straw"
  local groups = {snappy = 3, flammable = 4}
  local images = {"farming_straw.png"}
  local sounds = default.node_sound_leaves_defaults()

  stairs.register_stair("straw", recipe, groups, images, S("Straw Stair"),
    sounds, true)
  stairs.register_stair_inner("straw", recipe, groups, images, "",
    sounds, true, S("Inner Straw Stair"))
  stairs.register_stair_outer("straw", recipe, groups, images, "",
    sounds, true, S("Outer Straw Stair"))
  stairs.register_slab("straw", recipe, groups, images, S("Straw Slab"),
    sounds, true)
end

engine.register_abm({
  label = "Farming soil",
  nodenames = {"group:field"},
  interval = 15,
  chance = 4,
  action = function(pos, node)
    local n_def = engine.registered_nodes[node.name] or nil
    local wet = n_def.soil.wet or nil
    local base = n_def.soil.base or nil
    local dry = n_def.soil.dry or nil
    if not n_def or not n_def.soil or not wet or not base or not dry then
      return
    end

    pos.y = pos.y + 1
    local nn = engine.get_node_or_nil(pos)
    if not nn or not nn.name then
      return
    end
    local nn_def = engine.registered_nodes[nn.name] or nil
    pos.y = pos.y - 1

    if nn_def and nn_def.walkable and engine.get_item_group(nn.name, "plant") == 0 then
      engine.set_node(pos, {name = base})
      return
    end
    -- check if there is water nearby
    local wet_lvl = engine.get_item_group(node.name, "wet")
    if engine.find_node_near(pos, 5, {"group:water"}) then
      -- if it is dry soil and not base node, turn it into wet soil
      if wet_lvl == 0 then
        engine.set_node(pos, {name = wet})
      end
    else
      -- only turn back if there are no unloaded blocks (and therefore
      -- possible water sources) nearby
      if not engine.find_node_near(pos, 3, {"ignore"}) then
        -- turn it back into base if it is already dry
        if wet_lvl == 0 then
          -- only turn it back if there is no plant/seed on top of it
          if engine.get_item_group(nn.name, "plant") == 0 and engine.get_item_group(nn.name, "seed") == 0 then
            engine.set_node(pos, {name = base})
          end

        -- if its wet turn it back into dry soil
        elseif wet_lvl == 1 then
          engine.set_node(pos, {name = dry})
        end
      end
    end
  end,
})


-- Make different plants occasionally drop seed

for i = 1, 5 do
  if (i <= 3) then
    engine.override_item("default:fern_"..i, {drop = {
      max_items = 1,
      items = {
        {items = {"farming:seed_cotton"}, rarity = 10},
      }
    }})
    engine.override_item("default:marram_grass_"..i, {drop = {
      max_items = 1,
      items = {
        {items = {"farming:seed_wheat"}, rarity = 15},
      }
    }})
  end
  engine.override_item("default:grass_"..i, {drop = {
    max_items = 1,
    items = {
      {items = {"farming:seed_wheat"}, rarity = 5},
    }
  }})
  engine.override_item("default:dry_grass_"..i, {drop = {
    max_items = 1,
    items = {
      {items = {"farming:seed_wheat"}, rarity = 10},
    }
  }})
end
-- Junglegrass is the old source of cotton seeds that makes no sense. It is a leftover
-- from Mapgen V6 where junglegrass was the only plant available to be a source.
-- This source is kept for now to avoid disruption but should probably be
-- removed in future as players get used to the new source.
engine.override_item("default:junglegrass", {drop = {
  max_items = 1,
  items = {
    {items = {"farming:seed_cotton"}, rarity = 5},
  }
}})

-- Wild cotton as a source of cotton seed

engine.register_node("farming:cotton_wild", {
  description = S("Wild Cotton"),
  drawtype = "plantlike",
  waving = 1,
  tiles = {"farming_cotton_wild.png"},
  inventory_image = "farming_cotton_wild.png",
  wield_image = "farming_cotton_wild.png",
  paramtype = "light",
  sunlight_propagates = true,
  walkable = false,
  buildable_to = true,
  groups = {snappy = 3, attached_node = 1, flammable = 4, dig_immediate = 3, notop = 1},
  drop = {
    max_items = 1,
    items = {
      {items = {"farming:seed_cotton", rarity = 2}}
    }
  },
  sounds = default.node_sound_leaves_defaults(),
  selection_box = {
    type = "fixed",
    fixed = {-6 / 16, -8 / 16, -6 / 16, 6 / 16, 5 / 16, 6 / 16},
  },
})
