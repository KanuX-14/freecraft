Template
========
```
<details><summary>Version (x.y.z-patch_name)</summary>
 
<b>Additions</b>:
- Action.

<b>Removed</b>:
- Action.

<b>Changes</b>:
- Action.

<b>Bug fixes</b>:
- Action.

<b>Developer notes</b>:
- Notes.

</details>
```

Versions
========

<details><summary>v0.1.0</summary>

- Added/Changed some game sounds.
- Added Charcoal. Burn value of 35.
- Added duck with less height. It is possible to go under slabs now.
- Added Workbench.
- Boat crafting changed.
- Boat velocity increased.
- Crafting size changed to 2 rows per column.
- Drop value changed to 'drop'. All player's items will drop if gets eliminated.
- Farms will now wet the soil with water node within 5 of range.
- Fences and Walls can not be climbable.
- Header changed.
- Icon changed.
- Inventory size changed to 9 rows per column.
- Items will float while in water.
- New animations.
- Player can pick up near items.
- Player can run. It will give a 50% boost and a small FOV improvement.
- Player model changed. Very original, don't you think?
- Player will automatically come down the stairs.
- Screenshot changed.
- Sticks now will be crafted using 2 woods.
- Swim is now possible and is faster than walking.
- TNT is enabled for all circumstances.
- TNT radius increased to '5'.
- Walk on the water now slows the player down.

</details>

<details><summary>v0.1.1</summary>

- Added hunger bar.
- Added version watermark.
- Implemented player rotation based on controls.
- Iron now matches with it's ore.
- Steel got a recipe as result of burning iron ingot.
- Copper and Iron tools added.
- Iron tools have the same properties as old Steel tools.
- Steel tools have greater properties.
- Wielded tools scale raised to 1.4x1.4x1.
- Grey texture for Papyrus with code colouring.
- Fixed crash upon logout of a player.
- Fixed standing while on prone under a block.
- Random pitch for every item pickup.
- Implemented wielded items.
- Implemented variable storage.
- Finished basic hunger function.
- Fix Acacia Workbench not displaying crafting grid.
- Stem bushes can no longer be obtained by hand.

</details>

<details><summary>v0.1.2</summary>

- Changed ladder collision box.
>> Tools overhaul. Materials can compose from:
 - All available woods;
 - All available metals;
 - Cobble.
- Every wood has their own separated sticks.
- The use of the farming tool changed from 'LMB' to 'RMB'.
- Wielded hand size increased.
- Changed hunger texture.
- Ladder no longer will drag the player down. (too buggy)
>> Soundtrack:
 - Ambient tracks by Scott Buckley.
 - Organized sound files inside 'sounds' folder.
 - Music volume can be changed within FreeCraft game settings.
 - Music will be turned off if volume is set to 0.
 - Music can only be played above sea level. Otherwise cave effects will take the place.
- Fixed eat function using 'break' as eat key.
- Fixed some vegetation breaking value.
- Stone can be breakable by hand.
- Dry grass will give wheat seed with double rarity as normal grass.
- Floating item in water will behave smoothly.
- Pickup item radius changed from '1.5' to '2'.
- Pickup item gain reduced from '0.3' to '0.15'.
>> For developers:
 - Added switch(parameter, table) function.
   Parameter means the variable, and table the functions.
 - Added get_real_entity_position(entity, mode) function.
   Entity means the node/entity/player, and mode the return value (float, int). Defaults to float.

</details>

<details><summary>v0.1.3</summary>

<b>Additions</b>:
- check_nil(...), get_real_entity_position(entity, node), get_engine(mode), get_version() functions.
- Entity API created.
- Player body rotates while swimming.
- Automatic version detection.
- 'notop' group for blocks without a top model.
- FreeCraft configuration.
- Thirst.
- Automated hunger/thirst behaviour.
- XCF template for thirst icon.
- Packaging utily tool.

<b>Removed</b>:
- default/legacy.lua (Why was it even here?)

<b>Changes</b>:
- Updated player behaviour.
- Swimming consumes less saturation.
- Rails now are crafted using iron ingots.
- Better music volume range and loudness reduction.
- Better music directory organisation.
- Plant drops and some blocks behaviour.
- Better code for bone positioning/rotating.
- Simplified and organised animation set.
- Translated all mod's engine calls to a detected project.
- Default textures organisation.
- Get engine version without calling a path.

<b>Bug fixes</b>:
- Crash if music_volume is nil.
- Breath meter breaking while refilling.
- Object getting picked up by host only (multiplayer).
- Speed animation not getting updated based on behaviour.
- Soundtrack not playing all the musics.
- Bush leaves not waving.
- get_animation(player) function.
- Movement and animation while on bed.
- Not getting saturation refilled after death.
- Food consuming after having full saturation.
- Saturation decreasing to 0 if player's health is bellow the normal.
- Workbench name.

</details>

<details><summary>v0.1.4</summary>

<b>Additions</b>:
- Dryers and Mud.
- Basic energy.
- Instruments.
- Food and water sounds.
- Wooden tools can be used as fuel.
- Workbench can be used as fuel.
- Added Crumbled Iron and Iron Nuggets.

<b>Removed</b>:
- Game version will not be displayed while in-game (FreeCraft engine only).

<b>Changes</b>:
- Organised Workbench textures.
- Jumping and Ducking can be used to exit from a entity-object.
- Liquid will not be renewed after being collected.
- Increased tool force by 0.2.
- Packaging script receives 'safe mode'.
- Organised wood textures.
- New FreeCraft logo.
- Automated tool registration.
- Tool's force will match hand's.
- Automated Workbench registration.
- Renamed jungle nodes/items.

<b>Bug fixes</b>:
- Boat breaking leading to crash.
- Cart breaking leading to crash.
- Head not moving while riding a entity-object.
- Wrong camera positioning while riding a entity-object.
- check_nil() function returning wrong value.
- Not all tools being registered.

<b>Developer notes</b>:
- check_nil() function now checks literal values.

</details>

Welcome to FreeCraft!
=====================