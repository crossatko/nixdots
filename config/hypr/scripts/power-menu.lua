local actions = {
	sleep = "systemctl suspend",
	shutdown = "hyprshutdown -t 'Shutting down...' --post-cmd 'shutdown now'",
	reboot = "hyprshutdown -t 'Restarting...' --post-cmd 'reboot'",
	["exit hyprland"] = "hyprshutdown",
}

local options = {
	"sleep",
	"shutdown",
	"reboot",
	"exit hyprland",
}

local function shell_quote(value)
	return "'" .. tostring(value):gsub("'", "'\\''") .. "'"
end

local function build_menu_command()
	local quoted_options = {}
	local case_branches = {}

	for _, option in ipairs(options) do
		table.insert(quoted_options, shell_quote(option))
		table.insert(case_branches, shell_quote(option) .. ") " .. actions[option] .. " ;;")
	end

	return "choice=$(printf '%s\\n' "
		.. table.concat(quoted_options, " ")
		.. " | tofi --prompt-text 'Power: '); case \"$choice\" in "
		.. table.concat(case_branches, " ")
		.. " esac"
end

local function show_power_menu()
	-- Do not use io.popen here. Running tofi synchronously from the Hyprland Lua
	-- callback blocks Hyprland's event loop and can freeze the whole desktop.
	hl.exec_cmd("sh -c " .. shell_quote(build_menu_command()))
end

return {
	actions = actions,
	show_power_menu = show_power_menu,
}
