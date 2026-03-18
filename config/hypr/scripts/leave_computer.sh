#!/bin/bash
flatpak kill com.discordapp.Discord &
pkill -x brave &
pkill -x thunderbird &
docker stop $(docker ps -q) 2>/dev/null &
docker kill $(docker ps -q) 2>/dev/null &
sleep 0.5
loginctl lock-session
