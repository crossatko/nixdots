#!/usr/bin/env python3
import subprocess
import json
import sys
import argparse

def get_hyprctl_json(command):
    try:
        output = subprocess.check_output(["hyprctl", command, "-j"])
        return json.loads(output)
    except Exception as e:
        print(f"Error executing {command}: {e}")
        sys.exit(1)

def get_monitor_offset(mon_name_or_id):
    monitors = get_hyprctl_json("monitors")
    
    for mon in monitors:
        if str(mon["id"]) == str(mon_name_or_id) or mon["name"] == str(mon_name_or_id):
            return (mon["x"], mon["y"])
            
    print(f"Warning: Monitor '{mon_name_or_id}' not found. Using 0,0.")
    return (0, 0)

def main():
    parser = argparse.ArgumentParser(description="Move Hyprland windows by address with monitor awareness")
    
    parser.add_argument("--resize", nargs=2, metavar=('W', 'H'), type=int, help="Width and Height")
    parser.add_argument("--move", nargs=2, metavar=('X', 'Y'), type=int, help="X and Y coordinates (relative to monitor)")
    parser.add_argument("--monitor", help="Target monitor (name or ID)")
    
    parser.add_argument("--float", action="store_true", help="Set window to floating")
    parser.add_argument("--pin", action="store_true", help="Pin the window")
    parser.add_argument("--group", action="store_true", help="Toggle group")
    
    args = parser.parse_args()

    active_window = get_hyprctl_json("activewindow")
    addr = active_window["address"]
    addr_tag = f",address:{addr}"

    final_x, final_y = None, None
    
    if args.move:
        req_x, req_y = args.move
        
        if args.monitor:
            off_x, off_y = get_monitor_offset(args.monitor)
            final_x = off_x + req_x
            final_y = off_y + req_y
        else:
            final_x = req_x
            final_y = req_y

    cmds = []

    if args.float:
        cmds.append(f"dispatch setfloating address:{addr}")

    if args.resize:
        w, h = args.resize
        cmds.append(f"dispatch resizewindowpixel exact {w} {h}{addr_tag}")

    if final_x is not None and final_y is not None:
        cmds.append(f"dispatch movewindowpixel exact {final_x} {final_y}{addr_tag}")

    if args.group:
        cmds.append("dispatch togglegroup")

    if args.pin:
        cmds.append(f"dispatch pin address:{addr}")

    if cmds:
        batch_cmd = " ; ".join(cmds)
        subprocess.run(["hyprctl", "--batch", batch_cmd])

if __name__ == "__main__":
    main()
