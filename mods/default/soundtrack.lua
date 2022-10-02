-- default/soundtrack.lua

local function play_music(name, properties)
    minetest.sound_play(name, properties)
end

local music_volume = tonumber(minetest.settings:get("music_volume"))

minetest.register_globalstep(function(dtime)
	for _, player in ipairs(minetest.get_connected_players()) do
        local pos = player:get_pos()
        local time = math.floor(minetest.get_timeofday()*24000)
        local name = ""
        local properties = {
            pos = pos,
            max_hear_distance = 1,
            gain = music_volume,
            pitch = 1.0,
        }

        if (time > 6500) and (time < 6510) then
            default.time_of_day = math.random(1, 3)
        end

        default.switch(default.time_of_day, {
            [1] = function()
                default.playDay = true
                default.playEvening = false
                default.playNight = false
            end,
            [2] = function()
                default.playDay = false
                default.playEvening = true
                default.playNight = false
            end,
            [3] = function()
                default.playDay = false
                default.playEvening = false
                default.playNight = true
            end
        })

        if (time > 8000) and (time < 8010) and default.playDay then
            local music = math.random(1, 4)
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
                end
            })
            default.playDay = false
            default.time_of_day = 3 -- Continue to night soundtrack
        elseif (time > 14000) and (time < 14010) and default.playEvening then
            local music = math.random(1, 1)
            default.switch(music, {
                [1] = function()
                    name = "ambient_1_evening"
                end
            })
            default.playEvening = false
            default.time_of_day = 0
        elseif (time > 22000) and (time < 22010) and default.playNight then
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
    end
end)