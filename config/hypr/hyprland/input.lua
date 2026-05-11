hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",
		follow_mouse = 1,
		sensitivity = 0,
		touchpad = {
			natural_scroll = false,
		},
	},
})

hl.device({ name = "hid-054c:0ce6-touchpad", enabled = false })
hl.device({ name = "sony-interactive-entertainment-dualsense-wireless-controller-touchpad", enabled = false })
hl.device({ name = "dualsense-wireless-controller-touchpad", enabled = false })
