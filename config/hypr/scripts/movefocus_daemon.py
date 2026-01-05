#!/usr/bin/env python3
import sys, json, socket, os, math, time, glob

PIPE_PATH = "/tmp/hypr_focus_pipe"
LOG_PATH = "/tmp/hypr_daemon.log"

def log(msg):
    try:
        with open(LOG_PATH, "a") as f:
            f.write(f"{time.strftime('%H:%M:%S')} - {msg}\n")
    except:
        pass

def get_socket_path():
    sig = os.environ.get("HYPRLAND_INSTANCE_SIGNATURE")
    xdg_runtime = os.environ.get("XDG_RUNTIME_DIR", f"/run/user/{os.getuid()}")

    possible_paths = []
    
    if sig:
        possible_paths.append(f"{xdg_runtime}/hypr/{sig}/.socket.sock")
        possible_paths.append(f"/tmp/hypr/{sig}/.socket.sock")

    search_globs = [
        f"{xdg_runtime}/hypr/*/.socket.sock",
        "/tmp/hypr/*/.socket.sock"
    ]
    
    for pattern in search_globs:
        found = glob.glob(pattern)
        if found:
            found.sort(key=os.path.getmtime, reverse=True)
            possible_paths.extend(found)

    for path in possible_paths:
        if os.path.exists(path):
            return path
            
    log(f"Could not find socket. Tried: {possible_paths}")
    return None

def send_hypr_command(command):
    sock_path = get_socket_path()
    if not sock_path:
        return ""
    
    try:
        with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as s:
            s.connect(sock_path)
            s.sendall(command.encode('utf-8'))
            
            data = b""
            while True:
                chunk = s.recv(4096)
                if not chunk:
                    break
                data += chunk
            
            return data.decode('utf-8')
    except Exception as e:
        log(f"Socket Error ({sock_path}): {e}")
        return ""

def handle_focus(direction):
    try:
        active_raw = send_hypr_command("j/activewindow")
        monitors_raw = send_hypr_command("j/monitors")
        clients_raw = send_hypr_command("j/clients")

        if not active_raw or not monitors_raw or not clients_raw:
            return

        active = json.loads(active_raw)
        monitors = json.loads(monitors_raw)
        clients = json.loads(clients_raw)

        ax = active['at'][0] + active['size'][0] / 2
        ay = active['at'][1] + active['size'][1] / 2
        visible_ws_ids = [m['activeWorkspace']['id'] for m in monitors]

        candidates = []
        for c in clients:
            if c['workspace']['id'] not in visible_ws_ids and not c['pinned']: continue
            if c['address'] == active['address']: continue

            if c.get('hidden', False): continue

            cx = c['at'][0] + c['size'][0] / 2
            cy = c['at'][1] + c['size'][1] / 2

            match = False
            if   direction == 'l' and cx < ax: match = True
            elif direction == 'r' and cx > ax: match = True
            elif direction == 'u' and cy < ay: match = True
            elif direction == 'd' and cy > ay: match = True

            if match:
                dx = cx - ax
                dy = cy - ay

                weight_x = 1.0
                weight_y = 1.0

                PENALTY = 2.5 
                if direction in ['u', 'd']:
                    weight_x = PENALTY
                elif direction in ['l', 'r']:
                    weight_y = PENALTY

                base_dist = math.hypot(dx * weight_x, dy * weight_y)

                w_area = c['size'][0] * c['size'][1]
                size_bonus = math.sqrt(w_area) * 0.8

                final_score = base_dist - size_bonus

                candidates.append((final_score, c['address']))

        if candidates:
            candidates.sort(key=lambda x: x[0])
            send_hypr_command(f"dispatch focuswindow address:{candidates[0][1]}")
        else:
            send_hypr_command(f"dispatch movefocus {direction}")

    except Exception as e:
        log(f"Logic Crash: {e}")

def main():
    if os.path.exists(PIPE_PATH):
        try:
            os.remove(PIPE_PATH)
        except: pass

    try:
        os.mkfifo(PIPE_PATH)
    except: pass

    log("Daemon started (v4 - NixOS Fix).")
    
    while True:
        try:
            with open(PIPE_PATH, "r") as pipe:
                while True:
                    line = pipe.read()
                    if not line: break
                    cmd = line.strip()
                    if cmd in ['l', 'r', 'u', 'd']:
                        handle_focus(cmd)
        except Exception as e:
            log(f"Pipe Error: {e}")
            time.sleep(1)

if __name__ == "__main__":
    main()
