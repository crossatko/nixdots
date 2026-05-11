hl.config({ render = { direct_scanout = 0 } })
hl.config({ ecosystem = { no_donation_nag = true } })
hl.config({ cursor = { no_warps = true, no_hardware_cursors = true } })
hl.config({ xwayland = { force_zero_scaling = true } })

hl.config({
	general = {
		gaps_in = 0,
		gaps_out = 0,
		border_size = 0,
		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle",
	},
})

hl.config({
	group = {
		groupbar = {
			render_titles = false,
			height = 0,
			stacked = false,
			gaps_in = 0,
			gaps_out = 0,
		},
	},
})

hl.config({
	decoration = {
		rounding = 0,
		rounding_power = 0,
		active_opacity = 1.0,
		inactive_opacity = 0.75,
		dim_inactive = true,
		dim_strength = 0.5,
		shadow = { enabled = false },
		blur = {
			enabled = true,
			size = 6,
			passes = 3,
			xray = true,
			new_optimizations = true,
			vibrancy = 0.1696,
		},
	},
})

hl.config({ animations = { enabled = false } })

hl.config({
	dwindle = {
		preserve_split = true,
		force_split = 2,
		split_width_multiplier = 1.3,
	},
})

hl.config({ master = { new_status = "master" } })
hl.config({ scrolling = { fullscreen_on_one_column = true } })
hl.config({ misc = { force_default_wallpaper = -1, disable_hyprland_logo = true } })
