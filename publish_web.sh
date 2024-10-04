#!/bin/bash

# Run the build script
./build_web.sh

# Check if the build was successful
if [ $? -ne 0 ]; then
    echo "Build failed. Aborting publish."
    exit 1
fi

ITCH_USERNAME="jscommander"
ITCH_GAME_NAME="ld-56"

GAME_ZIP="./releases/web.zip"

# Check if the ZIP file exists
if [ ! -f "$GAME_ZIP" ]; then
    echo "ZIP file not found at $GAME_ZIP. Aborting publish."
    exit 1
fi

# Run Butler to publish the game
butler push "$GAME_ZIP" "$ITCH_USERNAME/$ITCH_GAME_NAME:web"

# Check if Butler was successful
if [ $? -eq 0 ]; then
    echo "Game successfully published to itch.io!"
else
    echo "Failed to publish game to itch.io."
    exit 1
fi
