local host = require("hyprland.host")
local monitors = require("hyprland.monitors")

local TV_OUTPUT = monitors.tv.output
local RESTORE_BRIGHTNESS = 80
local DIM_BRIGHTNESS = 1
local DIM_WALLPAPER = "~/.config/hypr/black.png"
local DEFAULT_WALLPAPER = "~/.config/hypr/nier.jpg"

local ddc_buses = {}
if host.is_battlestation then
	ddc_buses = { 8, 9 }
elseif host.is_workstation then
	ddc_buses = { 8, 6 }
end

local dimmed = nil
local last_gate_reason = nil

local function read_file(path)
	local f = io.open(path, "r")
	if not f then
		return ""
	end
	local out = f:read("*a") or ""
	f:close()
	return out
end

local function pid_list(name)
	local p = io.popen("pgrep -x " .. name .. " 2>/dev/null")
	if not p then
		return {}
	end

	local pids = {}
	for pid in p:read("*a"):gmatch("%d+") do
		table.insert(pids, pid)
	end
	p:close()
	return pids
end

local function process_has_flag(name, flags)
	for _, pid in ipairs(pid_list(name)) do
		local cmdline = read_file("/proc/" .. pid .. "/cmdline")
		for _, flag in ipairs(flags) do
			if cmdline:find(flag, 1, true) then
				return true
			end
		end
	end
	return false
end

local function set_external_brightness(level)
	for _, bus in ipairs(ddc_buses) do
		hl.exec_cmd("ddcutil --bus " .. bus .. " setvcp 0x10 " .. level .. " >/dev/null 2>&1")
	end
end

local function restart_hypridle()
	hl.exec_cmd("systemctl --user restart hypridle >/dev/null 2>&1")
end

local function is_tv_connected()
	return hl.get_monitor(TV_OUTPUT) ~= nil
end

local function is_big_picture_active()
	if process_has_flag("steam", { "-gamepadui", "-steamos3", "-tenfoot" }) then
		return true
	end

	if process_has_flag("steamwebhelper", { "steamdeck", "-gamepadui" }) then
		return true
	end

	for _, win in ipairs(hl.get_windows()) do
		local class = (win.class or ""):lower()
		local title = (win.title or ""):lower()
		if class:find("steam", 1, true) then
			if title:find("big picture", 1, true) or title:find("gamepadui", 1, true) then
				return true
			end
		end
	end

	return false
end

local function set_wallpaper(wallpaper)
	for _, mon in pairs(monitors) do
		hl.exec_cmd('hyprctl hyprpaper wallpaper "' .. mon.output .. "," .. wallpaper .. '"')
	end
end

local function set_gate_reason(reason)
	if reason == last_gate_reason then
		return
	end
	last_gate_reason = reason

	-- if reason then
	-- 	hl.notification.create({ text = "steam-tv-dim idle: " .. reason, timeout = 3000 })
	-- end
end

local function apply_dim()
	set_external_brightness(DIM_BRIGHTNESS)
	set_wallpaper(DIM_WALLPAPER)
	hl.notification.create({ text = "Steam Big Picture on TV: dimmed other displays", timeout = 2500 })
end

local function apply_restore(show_notification)
	set_external_brightness(RESTORE_BRIGHTNESS)
	restart_hypridle()
	set_wallpaper(DEFAULT_WALLPAPER)
	if show_notification then
		hl.notification.create({ text = "Restored display brightness + restarted hypridle", timeout = 2500 })
	end
end

local function sync_dim_state()
	if #ddc_buses == 0 then
		set_gate_reason("no ddc buses configured (host='" .. (host.raw or "") .. "')")
		return
	end

	local tv = is_tv_connected()
	local big_picture = tv and is_big_picture_active() or false
	local should_dim = tv and big_picture

	if should_dim then
		set_gate_reason(nil)
		if dimmed ~= true then
			apply_dim()
			dimmed = true
		end
		return
	end

	set_gate_reason("tv=" .. tostring(tv) .. ", big_picture=" .. tostring(big_picture))
	if dimmed ~= false then
		apply_restore(dimmed == true)
		dimmed = false
	end
end

hl.on("hyprland.start", sync_dim_state)
hl.on("monitor.added", sync_dim_state)
hl.on("monitor.removed", sync_dim_state)
hl.on("window.open", sync_dim_state)
hl.on("window.close", sync_dim_state)

hl.timer(sync_dim_state, { timeout = 3000, type = "repeat" })
