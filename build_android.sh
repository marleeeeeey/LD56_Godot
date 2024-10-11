#!/bin/bash

# Check if Godot is installed
if ! command -v godot &>/dev/null; then
    echo "Error: Godot is not installed. Please install it first."
    exit 1
fi

# Variables
EXPORT_NAME="android"
RELEASE_FOLDER="./releases"
EXPORT_PATH="${RELEASE_FOLDER}/${EXPORT_NAME}"
APK_NAME="MiteBlaster.apk"

clean() {
    echo "Cleaning build directory..."
    rm -rf "${EXPORT_PATH}"
    mkdir -p "${EXPORT_PATH}"
}

build() {
    echo "Building APK for Android..."
    godot --export-debug --headless "Android" "${EXPORT_PATH}/${APK_NAME}"
}

echo "Starting Android build process..."
clean
build

echo "Android build process completed."
echo "Your Android APK is now available in ${EXPORT_PATH}/${APK_NAME}"
