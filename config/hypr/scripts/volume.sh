#!/bin/bash
LOCK="/tmp/vol.lock"
STEP="$1"

(
  flock -n 9 || exit 0
  wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ "${STEP}"
  sleep 0.05
) 9>"$LOCK"
