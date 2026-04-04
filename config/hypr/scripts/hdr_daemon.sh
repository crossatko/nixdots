#!/bin/bash
# HDR Daemon - automatically disables HDR when the last game window closes
# Listens on Hyprland IPC socket2 for window events

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
HDR_TOGGLE="$SCRIPT_DIR/hdr_toggle.sh"

has_game_windows() {
  hyprctl clients -j | grep -q '"class": "steam_app_'
}

socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do
  case "$line" in
    closewindow\>\>*)
      # Short delay to let Hyprland update its client list
      sleep 0.5
      if ! has_game_windows; then
        "$HDR_TOGGLE" off
      fi
      ;;
  esac
done
