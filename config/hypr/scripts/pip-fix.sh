#!/bin/bash

PIP_ADDRESS=""
SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

socat -U - UNIX-CONNECT:"$SOCKET" | while read -r line; do

  if [[ "$line" =~ ^openwindow.*,,.*Picture\ in\ picture ]]; then
    temp="${line#*>>}"
    PIP_ADDRESS="${temp%%,*}"

    sleep 0.05
    hyprctl reload

  elif [[ -n "$PIP_ADDRESS" && "$line" == "closewindow>>$PIP_ADDRESS" ]]; then
    hyprctl reload
    PIP_ADDRESS=""
  fi
done
