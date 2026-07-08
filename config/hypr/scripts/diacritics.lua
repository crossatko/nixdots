-- Czech diacritics corrector (via OpenRouter Python script)
-- Super+Ctrl+V → reads clipboard, adds Czech diacritics, copies back

hl.bind("SUPER + CTRL + V", function()
	hl.exec_cmd("python3 " .. os.getenv("HOME") .. "/.config/hypr/scripts/diacritics.py")
end)
