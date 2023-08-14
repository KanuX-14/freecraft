-- carts/cart.lua

-- support for MT game translation.
local S = entity_api.translation

local cart = { name = "cart", initial_properties = { physical = false,
                           collisionbox = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
                           visual = "mesh", mesh = "carts_cart.b3d", visual_size = {x=1, y=1},
                           textures = {"carts_cart.png"},
                           },

         driver = nil, v = 0, last_v = 0,
         punched = false, velocity = {x=0, y=0, z=0},
         old_dir = {x=1, y=0, z=0}, old_pos = nil,
         old_switch = 0, railtype = nil, attached_items = {} }

-- Local functions
local function is_rail(pos, railtype)
  local node = engine.get_node(pos).name
  if node == "ignore" then
    local vm = engine.get_velocityoxel_manip()
    local emin, emax = vm:read_from_map(pos, pos)
    local area = VoxelArea:new{ MinEdge = emin, MaxEdge = emax, }
    local data = vm:get_data()
    local vi = area:indexp(pos)
    node = engine.get_name_from_content_id(data[vi])
  end
  if (engine.get_item_group(node, "rail") == 0) then return false end
  if not railtype then return true end
  return (engine.get_item_group(node, "connect_to_raillike") == railtype)
end

local function check_front_up_down(pos, dir_, check_up, railtype)
  local dir = vector.new(dir_)
  local cur

  -- Front
  dir.y = 0
  cur = vector.add(pos, dir)
  if is_rail(cur, railtype) then return dir end
  -- Up
  if check_up then
    dir.y = 1
    cur = vector.add(pos, dir)
    if is_rail(cur, railtype) then return dir end
  end
  -- Down
  dir.y = -1
  cur = vector.add(pos, dir)
  if is_rail(cur, railtype) then return dir end
  return nil
end

local function get_rail_direction(pos_, dir, ctrl, old_switch, railtype)
  local pos = vector.round(pos_)
  local cur
  local left_check, right_check = true, true

  -- Check left and right
  local left = {x=0, y=0, z=0}
  local right = {x=0, y=0, z=0}
  if (dir.z ~= 0) and (dir.x == 0) then
    left.x = -dir.z
    right.x = dir.z
  elseif (dir.x ~= 0) and (dir.z == 0) then
    left.z = dir.x
    right.z = -dir.x
  end

  local straight_priority = ctrl and (dir.y ~= 0)

  -- Normal, to disallow rail switching up- & downhill
  if straight_priority then
    cur = check_front_up_down(pos, dir, true, railtype)
    if cur then return cur end
  end

  if ctrl then
    if (old_switch == 1) then left_check = false
    elseif (old_switch == 2) then right_check = false end
    if ctrl.left and left_check then
      cur = check_front_up_down(pos, left, false, railtype)
      if cur then return cur, 1 end
      left_check = false
    end
    if ctrl.right and right_check then
      cur = check_front_up_down(pos, right, false, railtype)
      if cur then return cur, 2 end
      right_check = true
    end
  end

  -- Normal
  if not straight_priority then
    cur = check_front_up_down(pos, dir, true, railtype)
    if cur then return cur end
  end
  -- Left, if not already checked
  if left_check then
    cur = check_front_up_down(pos, left, false, railtype)
    if cur then return cur end
  end
  -- Right, if not already checked
  if right_check then
    cur = check_front_up_down(pos, right, false, railtype)
    if cur then return cur end
  end
  -- Backwards
  if not old_switch then
    cur = check_front_up_down(pos, {x=-dir.x, y=dir.y, z=-dir.z}, true, railtype)
    if cur then return cur end
  end

  return {x=0, y=0, z=0}
end

local function rail_pathfinder(pos_, old_pos, old_dir, distance, ctrl, pf_switch, railtype)
  local pos = vector.round(pos_)
  if vector.equals(old_pos, pos) then return end

  local pf_pos = vector.round(old_pos)
  local pf_dir = vector.new(old_dir)
  distance = math.min(entity_api.path_distance_max, math.floor(distance + 1))

  for i = 1, distance do
    pf_dir, pf_switch = get_rail_direction(pf_pos, pf_dir, ctrl, pf_switch or 0, railtype)
    -- No way forwards
    if vector.equals(pf_dir, {x=0, y=0, z=0}) then return pf_pos, pf_dir end

    pf_pos = vector.add(pf_pos, pf_dir)
    -- Success! Cart moved on correctly
    if vector.equals(pf_pos, pos) then return end
  end
  -- Not found. Put cart to predicted position
  return pf_pos, pf_dir
end

local function rail_on_step_event(handler, obj, dtime)
  if handler then
    handler(obj, dtime)
  end
end

-- sound refresh interval = 1.0sec
local function rail_sound(self, dtime)
  if not self.sound_ttl then self.sound_ttl = 1.0 return
  elseif self.sound_ttl > 0 then self.sound_ttl = self.sound_ttl - dtime return end

  self.sound_ttl = 1.0
  if self.sound_handle then
    local handle = self.sound_handle
    self.sound_handle = nil
    engine.after(0.2, engine.sound_stop, handle)
  end
  local vel = self.object:get_velocity()
  local speed = vector.length(vel)
  if (speed > 0) then
    self.sound_handle = engine.sound_play( "carts_cart_moving", {
                                   object = self.object,
                                   gain = (speed / entity_api.speed_max) / 2,
                                   loop = true,
                                  }
                       )
  end
end

local function get_railparams(pos)
  local node = engine.get_node(pos)
  return entity_api.railparams[node.name] or {}
end

local v3_len = vector.length
local function rail_on_step(self, dtime)
  local vel = self.object:get_velocity()
  if self.punched then
    vel = vector.add(vel, self.velocity)
    self.object:set_velocity(vel)
    self.old_dir.y = 0
  elseif vector.equals(vel, {x=0, y=0, z=0}) then return end

  local pos = self.object:get_pos()
  local dir = entity_api.velocity_to_dir(vel)
  local dir_changed = not vector.equals(dir, self.old_dir)
  local update = {}

  if self.old_pos and not self.punched and not dir_changed then
    local flo_pos = vector.round(pos)
    local flo_old = vector.round(self.old_pos)
    -- Do not check one node multiple times
    if vector.equals(flo_pos, flo_old) then return end
  end

  local ctrl, player

  -- Get player controls
  if self.driver then
    player = engine.get_player_by_name(self.driver)
    if player then ctrl = player:get_player_control() end
  end

  local stop_wiggle = false
  if self.old_pos and not dir_changed then
    -- Detection for "skipping" nodes (perhaps use average dtime?)
    -- It's sophisticated enough to take the acceleration in account
    local acc = self.object:get_acceleration()
    local distance = dtime * (v3_len(vel) + 0.5 * dtime * v3_len(acc))

    local new_pos, new_dir = rail_pathfinder(
                         pos, self.old_pos, self.old_dir, distance, ctrl,
                         self.old_switch, self.railtype
                        )

    if new_pos then
      -- No rail found: set to the expected position
      pos = new_pos
      update.pos = true
      dir = new_dir
    end
  -- Stop wiggle
  elseif self.old_pos and (self.old_dir.y ~= 1) and not self.punched then stop_wiggle = true end

  local railparams

  -- dir:         New moving direction of the cart
  -- switch_keys: Currently pressed L(1) or R(2) key,
  --              used to ignore the key on the next rail node
  local switch_keys
  dir, switch_keys = get_rail_direction(
                      pos, dir, ctrl, self.old_switch, self.railtype
                     )
  dir_changed = not vector.equals(dir, self.old_dir)

  local acc = 0
  if stop_wiggle or vector.equals(dir, {x=0, y=0, z=0}) then
    dir = vector.new(self.old_dir)
    vel = {x=0, y=0, z=0}
    local pos_r = vector.round(pos)
    if not is_rail(pos_r, self.railtype) and self.old_pos then pos = self.old_pos
    elseif not stop_wiggle then
      -- End of rail: Smooth out.
      pos = pos_r
      dir_changed = false
      dir.y = 0
    else pos.y = math.floor(pos.y + 0.5) end
    update.pos = true
    update.vel = true
  else
    -- Direction change detected
    if dir_changed then
      vel = vector.multiply(dir, math.abs(vel.x + vel.z))
      update.vel = true
      if (dir.y ~= self.old_dir.y) then
        pos = vector.round(pos)
        update.pos = true
      end
    end
    -- Center on the rail
    if (dir.z ~= 0) and (math.floor(pos.x + 0.5) ~= pos.x) then
      pos.x = math.floor(pos.x + 0.5)
      update.pos = true
    end
    if (dir.x ~= 0) and (math.floor(pos.z + 0.5) ~= pos.z) then
      pos.z = math.floor(pos.z + 0.5)
      update.pos = true
    end

    -- Slow down or speed up..
    acc = dir.y * -4.0
    -- Get rail for corrected position
    railparams = get_railparams(pos)
    -- no need to check for railparams == nil since we always make it exist.
    local speed_mod = railparams.acceleration
    -- Try to make it similar to the original carts mod
    if speed_mod and speed_mod ~= 0 then acc = acc + speed_mod
    else
      -- Handbrake or coast
      if ctrl and ctrl.down then acc = acc - 3
      else acc = acc - 0.4 end
    end
  end

  -- Limit cart speed
  local vel_len = vector.length(vel)
  if (vel_len > entity_api.speed_max) then
    vel = vector.multiply(vel, entity_api.speed_max / vel_len)
    update.vel = true
  end
  if (vel_len >= entity_api.speed_max) and (acc > 0) then acc = 0 end

  self.object:set_acceleration(vector.multiply(dir, acc))

  self.old_pos = vector.round(pos)
  self.old_dir = vector.new(dir)
  self.old_switch = switch_keys

  if self.punched then
    -- Collect dropped items
    for _, obj_ in pairs(engine.get_objects_inside_radius(pos, 1)) do
      local ent = obj_:get_luaentity()
      -- Careful here: physical_state and disable_physics are item-internal APIs
      if ent and ent.name == "__builtin:item" and ent.physical_state then
        ent:disable_physics()
        obj_:set_attach(self.object, "", {x=0, y=0, z=0}, {x=0, y=0, z=0})
        self.attached_items[#self.attached_items + 1] = obj_
      end
    end
    self.punched = false
    update.vel = true
  end

  railparams = railparams or get_railparams(pos)

  if not (update.vel or update.pos) then rail_on_step_event(railparams.on_step, self, dtime) return end

  local yaw = 0
  if (dir.x < 0) then yaw = 0.5
  elseif (dir.x > 0) then yaw = 1.5
  elseif (dir.z < 0) then yaw = 1 end
  self.object:set_yaw(yaw * math.pi)

  local anim = {x=0, y=0}
  if (dir.y == -1) then anim = {x=1, y=1}
  elseif (dir.y == 1) then anim = {x=2, y=2} end
  self.object:set_animation(anim, 1, 0)

  if update.vel then self.object:set_velocity(vel) end

  if update.pos then
    if dir_changed then self.object:set_pos(pos)
    else self.object:move_to(pos) end
  end

  -- call event handler
  rail_on_step_event(railparams.on_step, self, dtime)
end

-- Step functions
function cart.on_rightclick(self, clicker) entity_api.click(self, clicker) end
function cart.on_activate(self, staticdata, dtime_s) entity_api.activate(self, staticdata, dtime_s) end
function cart.get_staticdata(self) entity_api.get_staticdata(self) end
function cart.on_detach_child(self, child) entity_api.detach_child(self, child) end
function cart.on_punch(self, puncher, time_from_last_punch, tool_capabilities, direction)
  local pos = self.object:get_pos()
  local vel = self.object:get_velocity()
  if not self.railtype or vector.equals(vel, {x=0, y=0, z=0}) then
    local node = engine.get_node(pos).name
    self.railtype = engine.get_item_group(node, "connect_to_raillike")
  end
  -- Punched by non-player
  if not puncher or not puncher:is_player() then
    local cart_dir = get_rail_direction(pos, self.old_dir, nil, nil, self.railtype)
    if vector.equals(cart_dir, {x=0, y=0, z=0}) then
      return
    end
    self.velocity = vector.multiply(cart_dir, 2)
    self.punched = true
    return
  end
  -- Player digs cart by sneak-punch
  entity_api.punch(self, puncher)
  -- Player punches cart to alter velocity
  if puncher:get_player_name() == self.driver then
    if math.abs(vel.x + vel.z) > entity_api.punch_speed_max then
      return
    end
  end

  local punch_dir = entity_api.velocity_to_dir(puncher:get_look_dir())
  punch_dir.y = 0
  local cart_dir = get_rail_direction(pos, punch_dir, nil, nil, self.railtype)
  if vector.equals(cart_dir, {x=0, y=0, z=0}) then
    return
  end

  local punch_interval = 1
  -- Faulty tool registrations may cause the interval to be set to 0 !
  if tool_capabilities and (tool_capabilities.full_punch_interval or 0) > 0 then
    punch_interval = tool_capabilities.full_punch_interval
  end
  time_from_last_punch = math.min(time_from_last_punch or punch_interval, punch_interval)
  local f = 2 * (time_from_last_punch / punch_interval)

  self.velocity = vector.multiply(cart_dir, f)
  self.old_dir = cart_dir
  self.punched = true
end

function cart.on_step(self, dtime)
  rail_on_step(self, dtime)
  rail_sound(self, dtime)
  entity_api.step(self, dtime)
end

engine.register_entity("entity_api:cart", cart)

engine.register_craftitem("entity_api:cart", {
  description = S("Cart") .. "\n" .. S("(Sneak+Click to pick up)"),
  inventory_image = engine.inventorycube("carts_cart_top.png", "carts_cart_front.png", "carts_cart_side.png"),
  wield_image = "carts_cart_front.png",
  on_place = function(itemstack, placer, pointed_thing)
    local under = pointed_thing.under
    local node = engine.get_node(under)
    local udef = engine.registered_nodes[node.name]

    if udef and udef.on_rightclick and not (placer and placer:is_player() and placer:get_player_control().sneak) then
      return udef.on_rightclick(under, node, placer, itemstack, pointed_thing) or itemstack
    end
    if pointed_thing.type ~= "node" then return end
    if is_rail(pointed_thing.under) then engine.add_entity(pointed_thing.under, "entity_api:cart")
    elseif is_rail(pointed_thing.above) then engine.add_entity(pointed_thing.above, "entity_api:cart")
    else return end

    engine.sound_play({name = "default_place_node_metal", gain = 0.5}, {pos = pointed_thing.above}, true)

    if not engine.is_creative_enabled(placer:get_player_name()) then itemstack:take_item() end
    
    return itemstack
  end,
})

engine.register_craft({
  output = "entity_api:cart",
  recipe = {
    {"default:steel_ingot", "", "default:steel_ingot"},
    {"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
  },
})
