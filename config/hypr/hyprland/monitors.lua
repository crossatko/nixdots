local host = require("hyprland.host")

local monitor1 = {
	output = "DP-2",
	mode = "2560x1440@360",
	position = "0x1440",
	scale = 1.0,
	bitdepth = 10,
	vrr = 2,
	-- cm = "dcip3",
	supports_hdr = 1,
	supports_wide_color = 1,
	sdrbrightness = 3,
	sdrsaturation = 1.2,
}

local monitor2 = {
	output = "DP-3",
	mode = "2560x1440@60",
	position = "0x0",
	cm = "srgb",
	scale = 1.0,
}

local tv = {
	output = "HDMI-A-2",
	mode = "3840x2160@60",
	position = "2560x720",
	scale = 1.0,
	-- vrr = 1,
}

if host.is_archlinux or host.is_nix_vm then
	monitor1 = {
		output = "Virtual-1",
		mode = "2560x1440",
		position = "0x0",
		scale = 1.0,
	}
	monitor2 = monitor1
elseif host.is_workstation then
	monitor1 = {
		output = "DP-2",
		mode = "3440x1440@100",
		position = "0x0",
		scale = 1.0,
		-- reserved_area = {
		-- 	top = 0,
		-- 	right = 880,
		-- 	bottom = 0,
		-- 	left = 0,
		-- },
	}
	monitor2 = {
		output = "HDMI-A-1",
		mode = "1920x1200@60",
		transform = 1,
		position = "-1200x-300",
		scale = 1.0,
	}
end

hl.monitor(monitor1)
hl.monitor(monitor2)
hl.monitor(tv)

return {
	primary = monitor1,
	secondary = monitor2,
	tv = tv,
}
