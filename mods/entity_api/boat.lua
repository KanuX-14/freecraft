-- entity_apí/boat.lua

-- Load support for FC game translation
local S = entity_api.translation

--
-- Boat entity
--

local boat = { name = "boat", initial_properties = { physical = true,
                           collisionbox = {-0.5, -0.35, -0.5, 0.5, 0.3, 0.5},
                             visual = "mesh", mesh = "boat.obj",
                           textures = {"default_wood.png"},
                           },
         driver = nil, v = 0, last_v = 0,
         removed = false, auto = false }

function boat.on_rightclick(self, clicker) entity_api.click(self, clicker) end
function boat.on_detach_child(self, child) entity_api.detach_child(self, child) end
function boat.on_activate(self, staticdata, dtime_s) entity_api.activate(self, staticdata, dtime_s) end
function boat.get_staticdata(self) entity_api.get_staticdata(self) end
function boat.on_punch(self, puncher) entity_api.punch(self, puncher) end
function boat.on_step(self, dtime)
  entity_api.run(self, dtime)
  entity_api.step(self, dtime)
end

engine.register_entity("entity_api:boat", boat)

engine.register_craftitem("entity_api:boat", {
  description = S("Boat"),
  inventory_image = "apple_boat.png",
  wield_image = "apple_boat.png",
  wield_scale = {x = 2, y = 2, z = 1},
  liquids_pointable = true,
  groups = {flammable = 2},

  on_place = function(itemstack, placer, pointed_thing)
    local under = pointed_thing.under
    local node = engine.get_node(under)
    local udef = engine.registered_nodes[node.name]

    if udef and udef.on_rightclick and not (placer and placer:is_player() and placer:get_player_control().sneak) then
      return udef.on_rightclick(under, node, placer, itemstack, pointed_thing) or itemstack
    end
    if pointed_thing.type ~= "node" then return itemstackend end
    if not entity_api.is_water(pointed_thing.under) then return itemstack end

    pointed_thing.under.y = pointed_thing.under.y + 0.5
    boat = engine.add_entity(pointed_thing.under, "entity_api:boat")
    if boat then
      if placer then boat:set_yaw(placer:get_look_horizontal()) end

      local player_name = placer and placer:get_player_name() or ""
      if not engine.is_creative_enabled(player_name) then itemstack:take_item() end
    end

    return itemstack
  end,
})

engine.register_craft({
  output = "entity_api:boat",
  recipe = {
    {"group:wood", "",           "group:wood"},
    {"group:wood", "group:wood", "group:wood"},
  },
})

engine.register_craft({
  type = "fuel",
  recipe = "entity_api:boat",
  burntime = 20,
})
