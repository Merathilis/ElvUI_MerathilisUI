local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Actionbars")
local AB = E:GetModule("ActionBars")

local _G = _G
local sub = string.utf8sub
local len = strlenutf8

function module:ColorizeKey(text, colorHex)
	if len(text) > 1 then
		local baseText, lastChar

		-- Check if the last characters are digits
		local lastDigitMatch = text:match("(%d+)$")

		if lastDigitMatch and len(lastDigitMatch) > 1 then
			-- If there is more than one digit, treat all digits as lastChar
			baseText = sub(text, 1, len(text) - #lastDigitMatch)
			lastChar = lastDigitMatch
		else
			-- Otherwise, the last character is just the last character
			baseText = sub(text, 1, len(text) - 1)
			lastChar = sub(text, -1)
		end

		-- Colorize the baseText, leave lastChar as is
		local coloredText = "|cff" .. colorHex .. baseText .. "|r" .. lastChar
		return coloredText
	else
		return text
	end
end

function module:ColorKeybinds(button)
	local text = button.HotKey:GetText()
	local colorHex = sub(E:ClassColor(E.myclass, true).colorStr, 3)

	-- Set keybind width same as button
	if button.GetWidth then
		button.HotKey:Width(button:GetWidth())
	end

	if text and text ~= _G.RANGE_INDICATOR and len(text) > 1 then
		text = module:ColorizeKey(text, colorHex)
		button.HotKey:SetText(text)
	end
end

function module:ColorModifiers()
	local db = E.db.mui.actionbars.colorModifier

	if db and not db.enable then
		return
	end

	if self.isHooked then
		return
	end

	hooksecurefunc(AB, "FixKeybindText", module.ColorKeybinds)
	AB:UpdateButtonSettings()

	self.isHooked = true
end
