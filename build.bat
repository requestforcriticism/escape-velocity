@echo off

echo "Deleting Old Build"

del docs\* /Q

echo "Building Web Files"

..\bin\godot\Godot_v4.3-stable_win64.exe --export-debug Web --no-window

PAUSE