#!/bin/bash

clean() {
    echo "Cleaning web export directory..."
    rm -rf ./releases/web/*
    rm -rf ./releases/godot_web_export.tar.gz
    mkdir ./releases/web
}

build() {
    echo "Building Godot project for web export..."
    godot --headless --export-debug "Web" ./releases/web/index.html
}

compress() {
    echo "Compressing web export files..."
    cd ./releases
    tar -czvf godot_web_export.tar.gz web
    cd ..
    rm -rf ./releases/web/
}

echo "Starting Godot web export process..."
clean
build
compress

echo "Godot web export build process completed!"
echo "Your web export is now available in ./releases/godot_web_export.tar.gz"
