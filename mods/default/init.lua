-- FreeCraft 0.4 mod: default
-- See README.txt for licensing and other information.

-- The API documentation in here was moved into game_api.txt

-- Load files
default = {}
default.path = minetest.get_modpath("default")
dofile(default.path .. "/functions.lua")

-- Load support for MT game translation.
local S = engine.get_translator("default")

-- Definitions made by this mod that other mods can use too

default.LIGHT_MAX = 14
default.get_translator = S
default.time_of_day = 0
default.playDay = false
default.playEvening = false
default.playNight = false

-- Check for engine features required by MTG
-- This provides clear error behaviour when MTG is newer than the installed engine
-- and avoids obscure, hard to debug runtime errors.
-- This section should be updated before release and older checks can be dropped
-- when newer ones are introduced.
if ItemStack("").add_wear_by_uses == nil then
	error("\nThis version of FreeCraft Game is incompatible with your engine version "..
		"(which is too old). You should download a version of FreeCraft Game that "..
		"matches the installed engine version.\n")
end

-- GUI related stuff
engine.register_on_joinplayer(function(player)
	-- Set formspec prepend
	local formspec = [[
			bgcolor[#080808BB;true]
			listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF] ]]
	local name = player:get_player_name()
	local info = engine.get_player_information(name)
	local inv =  player:get_inventory()

	if info.formspec_version > 1 then
		formspec = formspec .. "background9[5,5;1,1;gui_formbg.png;true;10]"
	else
		formspec = formspec .. "background[5,5;1,1;gui_formbg.png;true]"
	end

	player:set_formspec_prepend(formspec)

	-- Set hotbar textures
	player:hud_set_hotbar_itemcount(9)
	player:hud_set_hotbar_image("gui_hotbar.png")
	player:hud_set_hotbar_selected_image("gui_hotbar_selected.png")

	inv:set_size("main", 36)
	inv:set_size("craft", 9)
end)

default.gui_survival_form = "size[9,9]"..
			"list[current_player;main;0,4.25;9,1;]"..
			"list[current_player;main;0,5.5;9,4;9]"..
			"list[current_player;craft;2.75,1;2,1;0;]"..
			"list[current_player;craft;2.75,1;2,1;3;]"..
			"list[current_player;craftpreview;5.75,1.5;1,1;]"..
			"image[4.75,1.5;1,1;gui_furnace_arrow_bg.png^[transformR270]"..
			"listring[current_player;main]"..
			"listring[current_player;craft]"..
			default.get_hotbar_bg(0,4.25)

dofile(default.path.."/trees.lua")
dofile(default.path.."/nodes.lua")
dofile(default.path.."/chests.lua")
dofile(default.path.."/furnace.lua")
dofile(default.path.."/torch.lua")
dofile(default.path.."/tools.lua")
dofile(default.path.."/item_entity.lua")
dofile(default.path.."/craftitems.lua")
dofile(default.path.."/crafting.lua")
dofile(default.path.."/mapgen.lua")
dofile(default.path.."/aliases.lua")
dofile(default.path.."/legacy.lua")
dofile(default.path.."/workbench.lua")
dofile(default.path.."/soundtrack.lua")
