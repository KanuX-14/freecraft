-- default/soundtrack.lua

local function localize_music(type)
  local name = ""
  default.switch(type,
  {
    -- Day
    [0] = function()
      local record = math.random(1, 5)
      name = "ambient_" .. record .. "_day"
    end,
    -- Night
    [1] = function()
      local record = math.random(1, 4)
      name = "ambient_" .. record .. "_night"
    end
  })
  return name
end

local function play_music(name, properties)
  local handle = engine.sound_play(name, properties)
  return handle
end

local function stop_music(handle)
  engine.sound_stop(handle)
end

local function tobool(char)
  if (char == "true") then return true
  elseif (char == "false") then return false
  else return nil end
end

local function btoi(bool)
  if (bool) then return 1
  else return 0 end
end

local function itob(int)
  if (int == 0) then return false
  else return true end
end

local raw_music_volume = tonumber(engine.settings:get("music_volume")) or 50
local music_volume = raw_music_volume * 0.0015
local music_single = tobool(engine.settings:get("music_single")) or false
local music_intensity = tonumber(engine.settings:get("music_intensity")) or 5
local handle = nil

if (music_intensity > 6) then
  music_single = true
end

engine.register_globalstep(function(dtime)
  if (music_volume > 0) then
    for _, player in ipairs(engine.get_connected_players()) do
      local pos = default.get_real_entity_position(player, "int")
      local time = math.floor(engine.get_timeofday()*24000)
      local time_play = time % (music_intensity * 2000)
      local name = ""
      local properties =
      {
        pos = pos,
        max_hear_distance = 3,
        gain = music_volume,
        pitch = 1.0,
      }

      if (music_single) then
        if (time > 6500) and (time < 6502) then
          default.time_of_day = math.random(1, 2)
          default.switch(default.time_of_day,
          {
            [1] = function()
              default.playDay = true
              default.playNight = false
            end,
            [2] = function()
              default.playDay = false
              default.playNight = true
            end
          })
        end
      elseif not (itob(time_play)) then
        if (time > 7000) and (time < 19000) then default.playDay = true
        elseif ((time > 19000) or (time > 0) and (time < 7000)) then default.playNight = true end
      end

      if (pos.y > 0) then
        if (time > 7000) and (time < 19000) and (default.playDay) then
          name = localize_music(0)
          default.playDay = false
          default.time_of_day = 0
        elseif ((time > 19000) or (time > 0) and (time < 7000)) and (default.playNight) then
          name = localize_music(1)
          default.playNight = false
          default.time_of_day = 0
        end
      else
        -- TODO: Play cave sound effects
        return
      end

      if not (name == "") then
        if not (handle == nil) then
          stop_music(handle)
          handle = nil
        end
        handle = play_music(name, properties)
      end
    end
  end
end)
