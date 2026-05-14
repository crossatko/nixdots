local host = require("hyprland.host")
local monitors = require("hyprland.monitors")

hl.on("hyprland.start", function()
	hl.exec_cmd("dbus-update-activation-environment --systemd --all")
	hl.exec_cmd(
		"systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE XDG_RUNTIME_DIR"
	)
	hl.exec_cmd("systemctl --user start hyprpolkitagent")
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("1password --silent")
	hl.exec_cmd("waybar")
	hl.exec_cmd("swaync")
	hl.exec_cmd("hyprctl setcursor Oxygen-White 24")
	hl.exec_cmd("nm-applet --indicator &")
	hl.exec_cmd("blueman-applet &")

	if host.is_battlestation then
		hl.exec_cmd("env LD_PRELOAD=/usr/lib32/libextest.so /usr/bin/steam %U -silent")
	end
end)
