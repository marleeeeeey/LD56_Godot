#!/bin/bash

# Check if Godot is installed
if ! command -v godot &>/dev/null; then
    echo "Error: Godot is not installed. Please install it first."
    exit 1
fi

# Define variables
EXPORT_NAME="web"
RELEASE_FOLDER="./releases"
EXPORT_PATH="${RELEASE_FOLDER}/web"
EXPORT_ZIP="${EXPORT_NAME}.zip"

clean() {
    echo "Cleaning web export directory..."
    rm -rf "${EXPORT_PATH}"/*
    rm -rf "${RELEASE_FOLDER}/${EXPORT_ZIP}"
    mkdir -p "${EXPORT_PATH}"
}

build() {
    echo "Building Godot project for web export..."
    godot --headless --export-debug "Web" "${EXPORT_PATH}/index.html"
}

compress() {
    echo "Compressing web export files..."
    cd "${RELEASE_FOLDER}"
    zip -r "${EXPORT_ZIP}" web
    cd ..
    rm -rf "${EXPORT_PATH}"
}

echo "Starting Godot web export process..."
clean
build
compress

echo "Godot web export build process completed!"
echo "Your web export is now available in ${RELEASE_FOLDER}/${EXPORT_ZIP}"
