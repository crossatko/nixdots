local host = require("hyprland.host")
local monitors = require("hyprland.monitors")

local TV_OUTPUT = monitors.tv.output
local RESTORE_BRIGHTNESS = 80
local DIM_BRIGHTNESS = 1
local DIM_WALLPPAPER = "~/.config/hypr/black.png"
local DEFAULT_WALLPAPER = "~/.config/hypr/nier.jpg"

local ddc_buses = {}
if host.is_battlestation then
	ddc_buses = { 8, 9 }
elseif host.is_workstation then
	ddc_buses = { 8, 6 }
end

local dimmed = false

local function command_succeeds(cmd)
	local ok = os.execute(cmd .. " >/dev/null 2>&1")
	if type(ok) == "boolean" then
		return ok
	end
	if type(ok) == "number" then
		return ok == 0
	end
	return false
end

local function set_external_brightness(level)
	for _, bus in ipairs(ddc_buses) do
		os.execute("ddcutil --bus " .. bus .. " setvcp 0x10 " .. level .. " >/dev/null 2>&1")
	end
end

local function restart_hypridle()
	os.execute("systemctl --user restart hypridle >/dev/null 2>&1")
end

local function is_tv_connected()
	return hl.get_monitor(TV_OUTPUT) ~= nil
end

local function is_big_picture_active()
	if command_succeeds("pgrep -af -- '-gamepadui|steamwebhelper.*steamdeck|SteamTenfoot'") then
		return true
	end

	for _, win in ipairs(hl.get_windows()) do
		local class = (win.class or ""):lower()
		local title = (win.title or ""):lower()
		if class:find("steam", 1, true) ~= nil then
			if title:find("big picture", 1, true) ~= nil or title:find("gamepadui", 1, true) ~= nil then
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

local function sync_dim_state()
	if #ddc_buses == 0 then
		return
	end

	local should_dim = is_tv_connected() and is_big_picture_active()

	if should_dim and not dimmed then
		set_external_brightness(DIM_BRIGHTNESS)
		set_wallpaper(DIM_WALLPPAPER)

		dimmed = true
		hl.notification.create({
			text = "Steam Big Picture on TV: dimmed other displays",
			timeout = 2500,
		})
		return
	end

	if not should_dim and dimmed then
		set_external_brightness(RESTORE_BRIGHTNESS)
		restart_hypridle()
		set_wallpaper(DEFAULT_WALLPAPER)

		dimmed = false
		hl.notification.create({
			text = "Restored display brightness + restarted hypridle",
			timeout = 2500,
		})
	end
end

hl.on("hyprland.start", function()
	sync_dim_state()
end)

hl.on("monitor.added", function()
	sync_dim_state()
end)

hl.on("monitor.removed", function()
	sync_dim_state()
end)

hl.on("window.open", function()
	sync_dim_state()
end)

hl.on("window.close", function()
	sync_dim_state()
end)

hl.timer(function()
	sync_dim_state()
end, { timeout = 3000, type = "repeat" })
