#!/bin/bash
# Toggle HDR on/off for the primary monitor
# Usage: hdr_toggle.sh on|off

MONITOR="DP-2"

case "$1" in
  on)
    hyprctl --batch "\
      keyword monitorv2:output:${MONITOR}:supports_hdr 1;\
      keyword render:direct_scanout 1"
    ;;
  off)
    hyprctl --batch "\
      keyword monitorv2:output:${MONITOR}:supports_hdr 0;\
      keyword render:direct_scanout 0"
    ;;
  *)
    echo "Usage: $0 {on|off}"
    exit 1
    ;;
esac
