#!/usr/bin/env bash

pkill -f waybar >/dev/null 2>&1

sleep 2

waybar &
