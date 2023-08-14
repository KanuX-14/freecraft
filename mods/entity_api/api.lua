-- entity_api/functions.lua

-- Load support for FC game translation
local S = entity_api.translation

function entity_api.is_water(pos)
  local node_name = engine.get_node(pos).name
  return (engine.get_item_group(node_name, "water") ~= 0)
end

function entity_api.calculate_velocity(v, yaw, y)
  local vel = {x=-math.sin(yaw)*v, y=y, z=math.cos(yaw)*v}
  return vel
end

function entity_api.get_velocity(v) return math.sqrt(v.x^2+v.z^2) end

function entity_api.manage_ride(player, entity)
  if not player or entity and (player:get_attach() == entity.object) then return end

  local status = (entity ~= nil)
  local player_name = player:get_player_name()
  local player_pos = player:get_pos()
  local entity_pos = player_pos
  local entity_rot = {x=0, y=0, z=0}
  local fpp_camera_pos = {x=0, y=0, z=0}
  local tps_camera_pos = fpp_camera_pos
  player_api.player_attached[player_name] = status

  -- Attach player to entity
  if status then
    if (entity.name == "entity_api:boat") then
      entity_pos = {x=0.5, y=-4.5, z=-3}
      fpp_camera_pos = {x=0, y=1, z=0}
      tps_camera_pos = fpp_camera_pos
    elseif (entity.name == "entity_api:cart") then
      entity_pos = {x=0, y=-5, z=-2.5}
      fpp_camera_pos = {x=0, y=3, z=0}
      tps_camera_pos = fpp_camera_pos
    end

    player:set_attach(entity.object, "", entity_pos, entity_rot)
    player:set_eye_offset(fpp_camera_pos, tps_camera_pos)
    player:set_look_horizontal(entity.object:get_yaw())

    entity.driver = player_name
    player_api.set_animation(player, "sit", 30)
  -- Detach player from entity
  else
    player:set_detach()
    player:set_eye_offset({x=0, y=0, z=0},{x=0, y=0, z=0})
    player:set_pos({x=player_pos.x,y=player_pos.y+0.2,z=player_pos.z})

    player_api.set_animation(player, "stand", 30)
  end
end

-- After right click
function entity_api.click(entity, clicker)
  if not clicker or not clicker:is_player() then return end

  local player_name = clicker:get_player_name()
  -- If driver exists
  if entity.driver and (player_name == entity.driver) then
    entity.driver = nil
    entity_api.manage_ride(clicker, nil)
  -- If driver does not exist
  elseif not entity.driver then entity_api.manage_ride(clicker, entity) end
end

function entity_api.activate(entity, staticdata, dtime_s)
  entity.object:set_armor_groups({immortal = 1})
  if staticdata then entity.v = tonumber(staticdata) end
  entity.last_v = entity.v
end

-- If driver leaves server while driving
function entity_api.detach_child(entity, child)
  if child and (child:get_player_name() == entity.driver) then
    entity_api.manage_ride(clicker, nil)
    entity.driver = nil
    entity.auto = false
  end
end

function entity_api.get_staticdata(entity)
  local data
  if (entity.name == "entity_api:boat") then data = tostring(entity.v)
  elseif (entity.name == "entity_api:cart") then data = engine.serialize({railtype = entity.railtype, old_dir = entity.old_dir}) end
  return data
end

function entity_api.apply_movement(option)
  default.switch(option, {
    [0] = function()
      -- TODO
    end,
    [1] = function()
      -- TODO
    end,
    [2] = function()
      -- TODO
    end,
    [3] = function()
      -- TODO
    end,
    [4] = function()
      -- TODO
    end,
    [5] = function()
      -- TODO
    end
  })
end

function entity_api.get_child_keys(child)
  local controls = child:get_player_control()
  if controls.up then entity_api.apply_movement(0)
  elseif controls.down then entity_api.apply_movement(1)
  elseif controls.left then entity_api.apply_movement(2)
  elseif controls.right then entity_api.apply_movement(3)
  elseif controls.sneak then entity_api.apply_movement(4)
  elseif controls.jump then entity_api.apply_movement(5) end
end

function entity_api.punch(entity, puncher)
  if not puncher or not puncher:is_player() or entity.removed then return end

  if (entity.name == "entity_api:cart") and not puncher:get_player_control().sneak then return end

  local puncher_name = puncher:get_player_name()
  -- Stop object's sound
  if entity.sound_handle then engine.sound_stop(entity.sound_handle) end
  -- Detach child after object break
  if entity.driver and (puncher_name == entity.driver) then
    entity.driver = nil
    entity_api.manage_ride(puncher, nil)
  end
  -- Give item
  if not entity.driver then
    entity.removed = true
    local inv = puncher:get_inventory()
    if not engine.is_creative_enabled(puncher_name) or not inv:contains_item("main", entity.name) then
      local leftover = inv:add_item("main", entity.name)
      -- if no room in inventory add a replacement boat to the world
      if not leftover:is_empty() then engine.add_item(entity.object:get_pos(), leftover) end
    end
    -- delay remove to ensure player is detached
    engine.after(0.1, function()
      entity.object:remove()
    end)
  end
end

-- TODO: Join both 'entity_api.step()' and 'entity_api.run()' since both have same purpose.
function entity_api.run(entity, dtime)
  entity.v = entity_api.get_velocity(entity.object:get_velocity()) * math.sign(entity.v)
  if entity.driver then
    local driver_objref = engine.get_player_by_name(entity.driver)
    if driver_objref then
      local ctrl = driver_objref:get_player_control()
      if ctrl.up and ctrl.down then
        if not entity.auto then
          entity.auto = true
          engine.chat_send_player(entity.driver, S("Boat cruise mode on"))
        end
      elseif ctrl.down then
        entity.v = entity.v - dtime * 2.0
        if entity.auto then
          entity.auto = false
          engine.chat_send_player(entity.driver, S("Boat cruise mode off"))
        end
      elseif ctrl.up or entity.auto then
        entity.v = entity.v + dtime * 7.0
      end
      if ctrl.left then
        if entity.v < -0.001 then
          entity.object:set_yaw(entity.object:get_yaw() - dtime * 0.9)
        else
          entity.object:set_yaw(entity.object:get_yaw() + dtime * 0.9)
        end
      elseif ctrl.right then
        if entity.v < -0.001 then
          entity.object:set_yaw(entity.object:get_yaw() + dtime * 0.9)
        else
          entity.object:set_yaw(entity.object:get_yaw() - dtime * 0.9)
        end
      end
    end
  end
  local velo = entity.object:get_velocity(entity)
  if not entity.driver and
      entity.v == 0 and velo.x == 0 and velo.y == 0 and velo.z == 0 then
    entity.object:set_pos(entity.object:get_pos())
    return
  end
  -- We need to preserve velocity sign to properly apply drag force
  -- while moving backward
  local drag = dtime * math.sign(entity.v) * (0.01 + 0.0796 * entity.v * entity.v)
  -- If drag is larger than velocity, then stop horizontal movement
  if math.abs(entity.v) <= math.abs(drag) then
    entity.v = 0
  else
    entity.v = entity.v - drag
  end

  local p = entity.object:get_pos(entity)
  p.y = p.y - 0.5
  local new_velo
  local new_acce = {x = 0, y = 0, z = 0}
  if not entity_api.is_water(p) then
    local nodedef = engine.registered_nodes[engine.get_node(p).name]
    if (not nodedef) or nodedef.walkable then
      entity.v = 0
      new_acce = {x = 0, y = 1, z = 0}
    else
      new_acce = {x = 0, y = -9.8, z = 0}
    end
    new_velo = entity_api.calculate_velocity(entity.v, entity.object:get_yaw(),
      entity.object:get_velocity().y)
    entity.object:set_pos(entity.object:get_pos())
  else
    p.y = p.y + 1
    if entity_api.is_water(p) then
      local y = entity.object:get_velocity().y
      if y >= 5 then
        y = 5
      elseif y < 0 then
        new_acce = {x = 0, y = 20, z = 0}
      else
        new_acce = {x = 0, y = 5, z = 0}
      end
      new_velo = entity_api.calculate_velocity(entity.v, entity.object:get_yaw(), y)
      entity.object:set_pos(entity.object:get_pos())
    else
      new_acce = {x = 0, y = 0, z = 0}
      if math.abs(entity.object:get_velocity().y) < 1 then
        local pos = entity.object:get_pos()
        pos.y = math.floor(pos.y) + 0.5
        entity.object:set_pos(pos)
        new_velo = entity_api.calculate_velocity(entity.v, entity.object:get_yaw(), 0)
      else
        new_velo = entity_api.calculate_velocity(entity.v, entity.object:get_yaw(),
          entity.object:get_velocity().y)
        entity.object:set_pos(entity.object:get_pos())
      end
    end
  end
  entity.object:set_velocity(new_velo)
  entity.object:set_acceleration(new_acce)
end

function entity_api.get_sign(z)
  if z == 0 then
    return 0
  else
    return z / math.abs(z)
  end
end

function entity_api.velocity_to_dir(v)
  if math.abs(v.x) > math.abs(v.z) then
    return {x=entity_api.get_sign(v.x), y=entity_api.get_sign(v.y), z=0}
  else
    return {x=0, y=entity_api.get_sign(v.y), z=entity_api.get_sign(v.z)}
  end
end

function entity_api.step(entity, dtime)
  for _, player in ipairs(engine.get_connected_players()) do
    local name = player:get_player_name()
    local controls = player:get_player_control()
    local attach = player:get_attach()
    
    if not attach then return
    else
      if (attach == entity.object) then
        if controls.jump or controls.sneak then entity_api.manage_ride(player, nil) end
      end
    end
  end
end
