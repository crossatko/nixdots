local apps = require("hyprland.apps")
local monitors = require("hyprland.monitors")

local monitor1 = monitors.primary
local monitor2 = monitors.secondary

hl.workspace_rule({ workspace = "1", monitor = monitor1.output })
hl.workspace_rule({ workspace = "2", monitor = monitor1.output })
hl.workspace_rule({ workspace = "3", monitor = monitor1.output, on_created_empty = apps.browser, default = true })
hl.workspace_rule({ workspace = "4", monitor = monitor1.output, on_created_empty = apps.terminal })

hl.workspace_rule({ workspace = "5", monitor = monitor2.output })
hl.workspace_rule({ workspace = "6", monitor = monitor2.output })
hl.workspace_rule({ workspace = "7", monitor = monitor2.output, on_created_empty = apps.discord, default = true })
hl.workspace_rule({ workspace = "8", monitor = monitor2.output, on_created_empty = apps.mail })

hl.workspace_rule({ workspace = "9", monitor = monitor1.output })
hl.workspace_rule({ workspace = "10", monitor = monitor1.output })
hl.workspace_rule({ workspace = "11", monitor = monitor1.output })
hl.workspace_rule({ workspace = "12", monitor = monitor1.output, on_created_empty = apps.jellyfin })
