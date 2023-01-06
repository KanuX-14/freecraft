-- default/instruments.lua

-- support for MT game translation.
local S = default.get_translator

-- Register guitar item
local function register_guitar()
	local description = "Guitar"
	local inventory_image = "guitar.png"
	local force = 3
	local interval = 1
    local level = 1
	local durability = 10
	local danger = 2
	local scale = {x=1.4,y=1.4,z=1}
	local snappy = {times={[1]=3.00, [2]=1.50, [3]=0.40}, uses=0, maxlevel=1}
	local oddly_breakable_by_hand = {times={[1]=3.50,[2]=2.00,[3]=0.70}, uses=0}
	local cracky = {times={[1]=80.00, [2]=50.00, [3]=20.00}, uses=0, maxlevel=1}
	local crumbly = {times={[1]=7.00, [2]=3.00, [3]=0.70}, uses=0, maxlevel=1}
    local on_secondary_use = function(itemstack, user, pointed_thing)
                                local pitch = -math.sin(user:get_look_vertical())+1
                                local pos = user:get_pos()
                                engine.sound_play("default_guitar_note", {pos=pos, max_hear_distance=16, gain=1.0, pitch=pitch})
    end
	local on_place = on_secondary_use

	local table = {
		description = S(description),
		inventory_image = inventory_image,
		wield_scale = scale,
		tool_capabilities = {
            cracky = cracky,
            crumbly = crumbly,
            snappy = snappy,
            oddly_breakable_by_hand = oddly_breakable_by_hand,
			full_punch_interval = interval,
			max_drop_level = level,
			damage_groups = {fleshy = danger},
		},
		sound = {breaks = "default_tool_breaks"},
		groups = {guitar = 1, flammable = 2},
        on_secondary_use = on_secondary_use,
		on_place = on_place,
	}

    engine.register_tool("default:guitar", table)
    engine.register_craft({output = "default:guitar",
		                   recipe = {{"", "", "default:wood"},
									 {"default:wood", "farming:string", ""},
									 {"default:wood", "default:wood", ""}}
	                     })
end

register_guitar()