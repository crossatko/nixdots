local apps = require("hyprland.apps")
local monitors = require("hyprland.monitors")
local host = require("hyprland.host")

local monitor1 = monitors.primary
local monitor2 = monitors.secondary
local tv = monitors.tv

local is_battlestation = host.is_battlestation
local is_workstation = host.is_workstation

local mediaWorkspaceOutput = monitor1.output
if tv ~= nil and tv.output ~= nil and hl.get_monitor(tv.output) ~= nil then
	mediaWorkspaceOutput = tv.output
end

local workspaces = {
	{ id = "1", key = "a", monitor = monitor1.output },
	{ id = "2", key = "s", monitor = monitor1.output },
	{ id = "3", key = "d", monitor = monitor1.output, app = apps.browser, default = true },
	{ id = "4", key = "f", monitor = monitor1.output, app = apps.terminal },

	{ id = "5", key = "q", monitor = monitor2.output },
	{ id = "6", key = "w", monitor = monitor2.output },
	{ id = "7", key = "e", monitor = monitor2.output, app = apps.discord, default = true },
	{ id = "8", key = "r", monitor = monitor2.output, app = apps.mail },

	{ id = "9", key = "z", monitor = mediaWorkspaceOutput },
	{ id = "10", key = "x", monitor = mediaWorkspaceOutput },
	{ id = "11", key = "c", monitor = mediaWorkspaceOutput },
	{ id = "12", key = "v", monitor = mediaWorkspaceOutput },
}

for _, ws in ipairs(workspaces) do
	hl.workspace_rule({
		workspace = ws.id,
		monitor = ws.monitor,
		on_created_empty = ws.app,
		default = ws.default or false,
		persistent = ws.persistent or false,
	})
end

if is_battlestation then
	hl.workspace_rule({
		workspace = "m[" .. monitor2.output .. "]w[p1-9]",
		gaps_out = {
			top = 12,
			bottom = 12,
			left = 12,
			right = 1588,
		},
	})
end
-- Both monitors' reservations for pinned PiP/mpv windows are now handled
-- dynamically at runtime via reserved_area (hyprland/monitors.lua), toggled
-- by scripts/pip-orientation.lua - not static per-workspace gaps.

return {
	workspaces = workspaces,
}
