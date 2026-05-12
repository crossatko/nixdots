local host = require("hyprland.host")
local is_battlestation = host.is_battlestation
local is_workstation = host.is_workstation
local monitors = require("hyprland.monitors")

local monitor2 = monitors.secondary

hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

if is_battlestation then
	hl.window_rule({
		name = "cb-pip",
		float = true,
		pin = true,
		opaque = true,
		no_dim = true,
		monitor = monitor2.output,
		move = "(monitor_w-1568) (monitor_h-914)",
		size = "1568 882",
		match = { initial_title = "Picture in picture" },
	})

	hl.window_rule({
		name = "cb-mpv",
		float = true,
		pin = true,
		no_dim = true,
		monitor = monitor2.output,
		move = "(monitor_w-1568) (monitor_h-914)",
		size = "1568 882",
		match = { initial_class = "^(mpv)$" },
	})
elseif is_workstation then
	hl.window_rule({
		name = "cw-pip",
		float = true,
		pin = true,
		no_initial_focus = true,
		opacity = "1 override 1 override",
		no_dim = true,
		group = "barred",
		monitor = monitor2.output,
		move = "0 1245",
		size = "1200 675",
		match = { title = "^(Picture in picture)$" },
	})

	hl.window_rule({
		name = "cw-mpv",
		float = true,
		pin = true,
		no_initial_focus = true,
		no_dim = true,
		monitor = monitor2.output,
		move = "0 1245",
		size = "1200 675",
		match = { initial_class = "^(mpv)$" },
	})
end

hl.window_rule({
	name = "jellyfin-media-player",
	no_dim = true,
	opaque = true,
	workspace = "12",
	match = { class = "^(org.jellyfin.JellyfinDesktop)$" },
})

hl.window_rule({
	name = "memento",
	no_dim = true,
	opaque = true,
	monitor = monitor2.output,
	match = { class = "^(memento)$" },
})

hl.window_rule({
	name = "obs",
	no_dim = true,
	opacity = "1 override 1 override",
	match = { class = "obs" },
})

hl.window_rule({
	name = "pinned",
	border_size = 0,
	no_initial_focus = true,
	focus_on_activate = false,
	match = { pin = true },
})

hl.window_rule({
	name = "fullscreen",
	border_size = 0,
	opacity = "1 override 1 override",
	no_dim = true,
	idle_inhibit = "fullscreen",
	match = { fullscreen = true },
})

hl.window_rule({
	name = "steam-input-osk",
	float = true,
	pin = true,
	center = true,
	no_dim = true,
	opaque = true,
	match = {
		class = "^steam",
		title = "^(Steam Input On-screen Keyboard)$",
	},
})

hl.window_rule({
	name = "steam",
	workspace = "2",
	match = {
		class = "^steam$",
		title = "^(Steam)$",
	},
})
hl.window_rule({
	name = "steam-game",
	workspace = "2",
	float = true,
	fullscreen = true,
	no_dim = true,
	opaque = true,
	match = { class = "^steam_app_\\d+$" },
})
hl.window_rule({
	name = "gamescope",
	workspace = "2",
	float = true,
	fullscreen = true,
	no_dim = true,
	opaque = true,
	match = { class = "^gamescope" },
})

hl.window_rule({
	name = "pavucontrol",
	float = true,
	size = "1000 900",
	center = true,
	match = { class = "^(org.pulseaudio.pavucontrol)$" },
})

hl.window_rule({
	name = "portal-stuff",
	float = true,
	size = "1000 900",
	center = true,
	match = { class = "xdg-desktop-portal-gtk" },
})

hl.window_rule({
	name = "savefile",
	float = true,
	size = "1000 900",
	center = true,
	match = { title = "^(Save File)$" },
})
hl.window_rule({
	name = "openfile",
	float = true,
	size = "1000 900",
	center = true,
	match = { title = "^(Open File)$" },
})
hl.window_rule({
	name = "blueman",
	float = true,
	size = "1000 900",
	center = true,
	match = { class = "^(.blueman-manager-wrapped)$" },
})

hl.window_rule({
	name = "discord",
	workspace = "7",
	match = { class = "discord" },
})
hl.window_rule({ name = "thunderbird", workspace = "8", match = { class = "thunderbird" } })
hl.window_rule({ name = "whatsapp", workspace = "7", match = { class = "^(brave-web\\.whatsapp\\.com__-Default)$" } })
hl.window_rule({ name = "messages", workspace = "7", match = { class = "^(brave-messages\\.google\\.com__-Default)$" } })
hl.window_rule({ name = "signal", workspace = "7", match = { class = "^(org\\.signal\\.Signal)$" } })

hl.window_rule({
	name = "tuifin-mpv",
	workspace = "11",
	float = false,
	fullscreen = false,
	match = { class = "^(tuifin-mpv)$" },
	no_dim = true,
	opaque = true,
})

hl.window_rule({
	name = "blender-save-file",
	float = true,
	fullscreen = false,
	size = "1400 1000",
	center = true,
	no_dim = true,
	opaque = true,
	match = {
		class = "^(blender)$",
		initial_title = "^(File Browser)$",
	},
})
