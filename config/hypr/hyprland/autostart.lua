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
	hl.exec_cmd("hyprctl setcursor Bibata-Modern-Classic 24")
	hl.exec_cmd("nm-applet --indicator &")
	hl.exec_cmd("blueman-applet &")

	if host.is_battlestation then
		hl.exec_cmd("steam -silent")
	end

	if host.is_battlestation and monitors.tv and monitors.tv.output then
		hl.exec_cmd(
			"systemctl --user set-environment STEAM_BP_TV_OUTPUT=" .. monitors.tv.output .. " STEAM_BP_DDC_BUS=8"
		)
		hl.exec_cmd("systemctl --user restart steam-bigpicture-ddc.service")
	end
end)
