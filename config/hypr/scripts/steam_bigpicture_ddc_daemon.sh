#!/usr/bin/env bash
# Dim MSI brightness while Steam Big Picture is running, restore on exit.
# Usage: steam_bigpicture_ddc_daemon.sh <tv_output> [ddc_bus]
# Example: steam_bigpicture_ddc_daemon.sh HDMI-A-2 8

set -u

TV_OUTPUT="${1:-HDMI-A-2}"
DDC_BUS="${2:-8}"
RESTORE_LEVEL="80"
SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

log() {
  echo "[steam-bigpicture-ddc] $*"
}

is_tv_connected() {
  hyprctl monitors all -j 2>/dev/null | python3 -c 'import json,sys
out=sys.argv[1]
try:
    ms=json.load(sys.stdin)
except Exception:
    print("0")
    raise SystemExit(0)
print("1" if any((m.get("name")==out and not m.get("disabled",False)) for m in ms) else "0")
' "$TV_OUTPUT"
}

set_brightness() {
  local level="$1"
  ddcutil --bus "$DDC_BUS" setvcp 0x10 "$level" >/dev/null 2>&1
}

dim_display() {
  set_brightness 0 || set_brightness 1
}

restore_display() {
  set_brightness "$RESTORE_LEVEL"
}

declare -A bp_windows=()
active_bp_count=0
dimmed=0

apply_state() {
  local tv_connected
  tv_connected="$(is_tv_connected)"

  if [[ "$active_bp_count" -gt 0 && "$tv_connected" == "1" ]]; then
    if [[ "$dimmed" -eq 0 ]]; then
      if dim_display; then
        dimmed=1
        log "dim on bus $DDC_BUS"
      fi
    fi
  else
    if [[ "$dimmed" -eq 1 ]]; then
      if restore_display; then
        dimmed=0
        log "restore $RESTORE_LEVEL on bus $DDC_BUS"
      fi
    fi
  fi
}

is_bp_window() {
  local cls="$1"
  local title="$2"
  shopt -s nocasematch
  [[ "$cls" == "steam" && "$title" =~ big[[:space:]]*picture ]]
}

clear_bp_state() {
  bp_windows=()
  active_bp_count=0
  apply_state
}

on_openwindow() {
  local payload="$1"
  local addr rest cls title

  addr="${payload%%,*}"
  rest="${payload#*,}"
  rest="${rest#*,}"
  cls="${rest%%,*}"
  title="${rest#*,}"

  if is_bp_window "$cls" "$title"; then
    if [[ -z "${bp_windows[$addr]+x}" ]]; then
      bp_windows[$addr]=1
      active_bp_count=$((active_bp_count + 1))
      apply_state
    fi
    return
  fi

  if [[ "${cls,,}" == "steam" && "$active_bp_count" -gt 0 ]]; then
    clear_bp_state
  fi
}

on_closewindow() {
  local addr="$1"
  if [[ -n "${bp_windows[$addr]+x}" ]]; then
    unset 'bp_windows[$addr]'
    if [[ "$active_bp_count" -gt 0 ]]; then
      active_bp_count=$((active_bp_count - 1))
    fi
    apply_state
  fi
}

init_state_from_clients() {
  while IFS= read -r addr; do
    if [[ -n "$addr" && -z "${bp_windows[$addr]+x}" ]]; then
      bp_windows[$addr]=1
      active_bp_count=$((active_bp_count + 1))
    fi
  done < <(
    hyprctl clients -j 2>/dev/null | python3 -c 'import json,re,sys
try:
    cs=json.load(sys.stdin)
except Exception:
    raise SystemExit(0)
for c in cs:
    if (c.get("class") or "").lower()=="steam" and re.search(r"big\\s*picture", c.get("title") or "", re.IGNORECASE):
        print(c.get("address") or "")
'
  )

  apply_state
}

cleanup() {
  if [[ "$dimmed" -eq 1 ]]; then
    restore_display
  fi
}

trap cleanup EXIT INT TERM
init_state_from_clients

while IFS= read -r line; do
  case "${line-}" in
    openwindow\>\>*)
      on_openwindow "${line#openwindow>>}"
      ;;
    closewindow\>\>*)
      on_closewindow "${line#closewindow>>}"
      ;;
    fullscreen\>\>0)
      if [[ "$active_bp_count" -gt 0 ]]; then
        clear_bp_state
      fi
      ;;
  esac
done < <(
  python3 -c 'import socket,sys
sock=socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
sock.connect(sys.argv[1])
with sock, sock.makefile("r", encoding="utf-8", errors="ignore") as f:
    for raw in f:
        print(raw.strip(), flush=True)
' "$SOCKET"
)
