hl.config({ render = { direct_scanout = 0 } })
hl.config({ ecosystem = { no_donation_nag = true } })
hl.config({ cursor = { no_warps = true, no_hardware_cursors = true } })
hl.config({ xwayland = { force_zero_scaling = true } })

hl.config({
	general = {
		gaps_in = 6,
		gaps_out = 12,
		border_size = 4,
		col = {
			active_border = {
				colors = {
					"0xaa050505",
					"0x66222222",
					"0x44888888",
					"0x88bbbbbb",
					"0x44888888",
					"0x66222222",
					"0xaa050505",
				},
				angle = 45,
			},
			inactive_border = "0x22000000",
		},
		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle",
	},
})

hl.config({
	group = {
		col = {
			border_active = {
				colors = {
					"0xaa050505",
					"0x66222222",
					"0x44888888",
					"0x88bbbbbb",
					"0x44888888",
					"0x66222222",
					"0xaa050505",
				},
				angle = 45,
			},
			border_inactive = "0x22000000",
			border_locked_active = "0xaa050505",
			border_locked_inactive = "0x22000000",
		},
		groupbar = {
			enabled = true,
			gradients = true,
			render_titles = false,
			height = 6,
			indicator_height = 0,
			stacked = false,
			gaps_in = 2,
			gaps_out = 3,
			keep_upper_gap = true,
			rounding = 8,
			rounding_power = 2,
			gradient_rounding = 8,
			gradient_rounding_power = 2,
			round_only_edges = true,
			gradient_round_only_edges = true,
			col = {
				active = "0xaa050505",
				inactive = "0x22000000",
				locked_active = "0xaa050505",
				locked_inactive = "0x22111111",
			},
		},
	},
})

hl.config({
	decoration = {
		rounding = 10,
		rounding_power = 10,
		active_opacity = 1.0,
		inactive_opacity = 0.75,
		dim_inactive = true,
		dim_strength = 0.5,
		shadow = {
			enabled = true,
			range = 24,
			render_power = 3,
			color = "0x66000000",
			offset = "3 3",
		},
		blur = {
			enabled = true,
			size = 4,
			passes = 2,
			xray = true,
			new_optimizations = true,
			vibrancy = 0.1696,
		},
	},
})

hl.config({
	animations = {
		enabled = true,
		workspace_wraparound = false,
	},
})

-- Current Hyprland (0.55) animation syntax (wiki/default style)
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global", enabled = true, speed = 0.5, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 0.5, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 0.5, bezier = "quick" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 0.5, bezier = "quick" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 0.5, bezier = "quick", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 0.5, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 0.5, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 0.5, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 0.5, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 0.5, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 0.5, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 0.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 0.5, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 0.5, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 0.5, bezier = "almostLinear", style = "slidefade 5%" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 0.5, bezier = "almostLinear", style = "slidefade 5%" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 0.5, bezier = "almostLinear", style = "slidefade 5%" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 0.5, bezier = "quick" })

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
