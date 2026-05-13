local apps = require("hyprland.apps")
local monitors = require("hyprland.monitors")

local monitor1 = monitors.primary
local monitor2 = monitors.secondary

local workspaces = {
	{ id = "1", key = "a", monitor = monitor1.output },
	{ id = "2", key = "s", monitor = monitor1.output },
	{ id = "3", key = "d", monitor = monitor1.output, app = apps.browser, default = true },
	{ id = "4", key = "f", monitor = monitor1.output, app = apps.terminal },

	{ id = "5", key = "q", monitor = monitor2.output },
	{ id = "6", key = "w", monitor = monitor2.output },
	{ id = "7", key = "e", monitor = monitor2.output, app = apps.discord, default = true },
	{ id = "8", key = "r", monitor = monitor2.output, app = apps.mail },

	{ id = "9", key = "z", monitor = monitor1.output },
	{ id = "10", key = "x", monitor = monitor1.output },
	{ id = "11", key = "c", monitor = monitor1.output },
	{ id = "12", key = "v", monitor = monitor1.output },
}

for _, ws in ipairs(workspaces) do
	hl.workspace_rule({
		workspace = ws.id,
		monitor = ws.monitor,
		on_created_empty = ws.app,
		default = ws.default or false,
	})
end

return {
	workspaces = workspaces,
}
