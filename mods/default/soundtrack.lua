-- default/soundtrack.lua

local function play_music(name, properties)
    minetest.sound_play(name, properties)
end

local raw_music_volume = tonumber(minetest.settings:get("music_volume")) or 5
local music_volume = raw_music_volume / 100

minetest.register_globalstep(function(dtime)
    if (music_volume > 0) then
        for _, player in ipairs(minetest.get_connected_players()) do
            local pos = default.get_real_entity_position(player, "int")
            local time = math.floor(minetest.get_timeofday()*24000)
            local name = ""
            local properties = {
                pos = pos,
                max_hear_distance = 1,
                gain = music_volume,
                pitch = 1.0,
            }

            if (time > 6500) and (time < 6502) then
                default.time_of_day = math.random(1, 2)
            end

            default.switch(default.time_of_day, {
                [1] = function()
                    default.playDay = true
                    default.playNight = false
                end,
                [2] = function()
                    default.playDay = false
                    default.playNight = true
                end
            })

            if (pos.y > 0) then
                if (time > 7000) and (time < 19000) and default.playDay then
                    local music = math.random(1, 5)
                    default.switch(music, {
                        [1] = function()
                            name = "ambient_1_day"
                        end,
                        [2] = function()
                            name = "ambient_2_day"
                        end,
                        [3] = function()
                            name = "ambient_3_day"
                        end,
                        [4] = function()
                            name = "ambient_4_day"
                        end,
                        [5] = function()
                            name = "ambient_5_day"
                        end
                    })
                    default.playDay = false
                    default.time_of_day = 0
                elseif (time > 19000) and default.playNight then
                    local music = math.random(1, 4)
                    default.switch(music, {
                        [1] = function()
                            name = "ambient_1_night"
                        end,
                        [2] = function()
                            name = "ambient_2_night"
                        end,
                        [3] = function()
                            name = "ambient_3_night"
                        end,
                        [4] = function()
                            name = "ambient_4_night"
                        end
                    })
                    default.playNight = false
                    default.time_of_day = 0
                end

                if not (name == "") then
                    play_music(name, properties)
                end
            else
                -- TODO: Play cave sound effects
                return
            end

            print(default.time_of_day, default.playDay, default.playNight, name)
        end
    end
end)
