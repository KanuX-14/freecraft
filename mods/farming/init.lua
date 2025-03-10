-- farming/init.lua

-- Load support for MT game translation.
local S = engine.get_translator("farming")

-- Global farming namespace

farming = {}
farming.path = engine.get_modpath("farming")
farming.get_translator = S

-- Load files

dofile(farming.path .. "/api.lua")
dofile(farming.path .. "/nodes.lua")


-- Wheat

farming.register_plant("farming:wheat", {
  description = S("Wheat Seed"),
  harvest_description = S("Wheat"),
  paramtype2 = "meshoptions",
  inventory_image = "farming_wheat_seed.png",
  steps = 8,
  minlight = 13,
  maxlight = default.LIGHT_MAX,
  fertility = {"grassland"},
  groups = {food_wheat = 1, flammable = 4, notop = 1},
  place_param2 = 3,
})

engine.register_craftitem("farming:flour", {
  description = S("Flour"),
  inventory_image = "farming_flour.png",
  groups = {food_flour = 1, flammable = 1},
})

engine.register_craftitem("farming:bread", {
  description = S("Bread"),
  inventory_image = "farming_bread.png",
  on_secondary_use = engine.item_eat(0),
  groups = {food_bread = 1, flammable = 2, food = 5},
})

engine.register_craft({
  type = "shapeless",
  output = "farming:flour",
  recipe = {"farming:wheat", "farming:wheat", "farming:wheat", "farming:wheat"}
})

engine.register_craft({
  type = "cooking",
  cooktime = 15,
  output = "farming:bread",
  recipe = "farming:flour"
})


-- Cotton

farming.register_plant("farming:cotton", {
  description = S("Cotton Seed"),
  harvest_description = S("Cotton"),
  inventory_image = "farming_cotton_seed.png",
  steps = 8,
  minlight = 13,
  maxlight = default.LIGHT_MAX,
  fertility = {"grassland", "desert"},
  groups = {flammable = 4},
})

engine.register_decoration({
  name = "farming:cotton_wild",
  deco_type = "simple",
  place_on = {"default:dry_dirt_with_dry_grass"},
  sidelen = 16,
  noise_params = {
    offset = -0.1,
    scale = 0.1,
    spread = {x = 50, y = 50, z = 50},
    seed = 4242,
    octaves = 3,
    persist = 0.7
  },
  biomes = {"savanna"},
  y_max = 31000,
  y_min = 1,
  decoration = "farming:cotton_wild",
})

engine.register_craftitem("farming:string", {
  description = S("String"),
  inventory_image = "farming_string.png",
  groups = {flammable = 2},
})

engine.register_craft({
  output = "wool:white",
  recipe = {
    {"farming:cotton", "farming:cotton"},
    {"farming:cotton", "farming:cotton"},
  }
})

engine.register_craft({
  output = "wool:white",
  recipe = {
    {"farming:string", "farming:string"},
    {"farming:string", "farming:string"},
  }
})

engine.register_craft({
  output = "farming:string 2",
  recipe = {
    {"farming:cotton"},
    {"farming:cotton"},
  }
})


-- Straw

engine.register_craft({
  output = "farming:straw 3",
  recipe = {
    {"farming:wheat", "farming:wheat", "farming:wheat"},
    {"farming:wheat", "farming:wheat", "farming:wheat"},
    {"farming:wheat", "farming:wheat", "farming:wheat"},
  }
})

engine.register_craft({
  output = "farming:wheat 3",
  recipe = {
    {"farming:straw"},
  }
})


-- Fuels

engine.register_craft({
  type = "fuel",
  recipe = "farming:wheat",
  burntime = 1,
})

engine.register_craft({
  type = "fuel",
  recipe = "farming:cotton",
  burntime = 1,
})

engine.register_craft({
  type = "fuel",
  recipe = "farming:string",
  burntime = 1,
})

engine.register_craft({
  type = "fuel",
  recipe = "farming:hoe_wood",
  burntime = 5,
})


-- Register farming items as dungeon loot

if engine.global_exists("dungeon_loot") then
  dungeon_loot.register({
    {name = "farming:string", chance = 0.5, count = {1, 8}},
    {name = "farming:wheat", chance = 0.5, count = {2, 5}},
    {name = "farming:seed_cotton", chance = 0.4, count = {1, 4},
      types = {"normal"}},
  })
end
