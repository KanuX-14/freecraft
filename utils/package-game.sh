#!/bin/bash

BUILD_PATH="$(pwd)/build"
GAME_PATH="$(pwd)/.."
MENU="$GAME_PATH/menu"
MODS="$GAME_PATH/mods"
CONF="$GAME_PATH/*.conf"
SETTINGS="$GAME_PATH/settingtypes.txt"
SCREENSHOT="$GAME_PATH/screenshot.png"
README="$GAME_PATH/README.md"
LICENSE="$GAME_PATH/LICENSE.txt"

mkdir -pv $BUILD_PATH
cp -rv $MENU $MODS $CONF $SETTINGS $SCREENSHOT $README $LICENSE $BUILD_PATH
mv -v $BUILD_PATH freecraft

zip -9r freecraft.zip freecraft
mv -v freecraft $BUILD_PATH