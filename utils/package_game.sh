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
PATCHNOTES="$GAME_PATH/patchnotes.txt"
ZIP_NAME="freecraft.zip"

isSafeMode=false
for i; do
    case $i in
        --safe-mode|-s)
            isSafeMode=true
            ZIP_NAME="freecraft_safe.zip"
            shift
            ;;
    esac
done

rm -fv $ZIP_NAME 2&>/dev/null
mkdir -pv $BUILD_PATH
cp -rv $MENU $MODS $CONF $SETTINGS $SCREENSHOT $README $LICENSE $PATCHNOTES $BUILD_PATH

if $isSafeMode; then
    rm -rfv $BUILD_PATH/mods/default/sounds/music
    printf 'music_volume = 0\n' >> $BUILD_PATH/freecraft.conf
    printf 'music_volume = 0\n' >> $BUILD_PATH/minetest.conf
fi

mv -v $BUILD_PATH freecraft

zip -9r $ZIP_NAME freecraft
mv -v freecraft $BUILD_PATH