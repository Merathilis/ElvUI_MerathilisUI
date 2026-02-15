local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_ColorModifiers") ---@class ColorModifiers
local AB = E:GetModule("ActionBars")

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

-- Taken from ElvUI, see AB:FixKeybindText
function module:FixKeybindText(text)
	if text and text ~= _G.RANGE_INDICATOR then
		text = gsub(text, "SHIFT%-", L["KEY_SHIFT"])
		text = gsub(text, "ALT%-", L["KEY_ALT"])
		text = gsub(text, "CTRL%-", L["KEY_CTRL"])
		text = gsub(text, "META%-", L["KEY_META"])
		text = gsub(text, "BUTTON", L["KEY_MOUSEBUTTON"])
		text = gsub(text, "MOUSEWHEELUP", L["KEY_MOUSEWHEELUP"])
		text = gsub(text, "MOUSEWHEELDOWN", L["KEY_MOUSEWHEELDOWN"])
		text = gsub(text, "NUMPAD", L["KEY_NUMPAD"])
		text = gsub(text, "PAGEUP", L["KEY_PAGEUP"])
		text = gsub(text, "PAGEDOWN", L["KEY_PAGEDOWN"])
		text = gsub(text, "SPACE", L["KEY_SPACE"])
		text = gsub(text, "INSERT", L["KEY_INSERT"])
		text = gsub(text, "HOME", L["KEY_HOME"])
		text = gsub(text, "DELETE", L["KEY_DELETE"])
		text = gsub(text, "NDIVIDE", L["KEY_NDIVIDE"])
		text = gsub(text, "NMULTIPLY", L["KEY_NMULTIPLY"])
		text = gsub(text, "NMINUS", L["KEY_NMINUS"])
		text = gsub(text, "NPLUS", L["KEY_NPLUS"])
		text = gsub(text, "NEQUALS", L["KEY_NEQUALS"])

		return text
	end
end

function module:FormatKeybind(keybind)
	local text = module:FixKeybindText(keybind)

	if text and text ~= _G.RANGE_INDICATOR and strlenutf8(text) > 1 and E.db.mui.colorModifiers.enable then
		local colorHex = string.utf8sub(E:ClassColor(E.myclass, true).colorStr, 3)
		text = module:ColorizeKey(text, colorHex)
		return text
	else
		return text
	end
end

function module:ColorKeybinds(button)
	local text = button.HotKey:GetText()
	local colorHex = sub(E:ClassColor(E.myclass, true).colorStr, 3)

	-- Set keybind width same as button
	button.HotKey:Width(button:GetWidth())

	if text and text ~= _G.RANGE_INDICATOR and len(text) > 1 then
		text = module:ColorizeKey(text, colorHex)
		button.HotKey:SetText(text)
	end
end

function module:Enable()
	if self.isHooked then
		return
	end
	hooksecurefunc(AB, "FixKeybindText", module.ColorKeybinds)
	AB:UpdateButtonSettings()
	self.isHooked = true
end

function module:DatabaseUpdate()
	self.db = F.GetDBFromPath("mui.colorModifiers")

	if self.db and self.db.enable and E.private.actionbar.enable then
		self:Enable()
	end
end

function module:Initialize()
	if self.Initialized then
		return
	end

	-- Register for updates
	F.Event.RegisterOnceCallback("MER.InitializedSafe", F.Event.GenerateClosure(self.DatabaseUpdate, self))
	F.Event.RegisterCallback("MER.DatabaseUpdate", self.DatabaseUpdate, self)

	-- We are done, hooray!
	self.Initialized = true
end

MER:RegisterModule(module:GetName())
