local pip_address = ""

hl.on("window.open", function(window)
	if window.title == "Picture in picture" then
		pip_address = window.address
		-- hl.notification.create({ text = "PiP Open: " .. pip_address, timeout = 3000 })
		hl.exec_cmd("hyprctl reload")
	end
end)

hl.on("window.close", function(window)
	if window.address == pip_address or window.title == "Picture in picture" then
		-- hl.notification.create({ text = "PiP Closed" .. pip_address, timeout = 3000 })
		hl.exec_cmd("hyprctl reload")
		pip_address = ""
	end
end)
