local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local module = MER:GetModule('MER_Actionbars')
local AB = E:GetModule("ActionBars")

local _G = _G
local find = string.find
local gsub = string.gsub
local sub = string.sub

local keysToColorize = {
	"KEY_SHIFT",
	"KEY_ALT",
	"KEY_CTRL",
	"KEY_META",
	"KEY_MOUSEBUTTON",
	"KEY_MOUSEWHEELUP",
	"KEY_MOUSEWHEELDOWN",
	"KEY_NUMPAD",
	"KEY_PAGEUP",
	"KEY_PAGEDOWN",
	"KEY_SPACE",
	"KEY_INSERT",
	"KEY_HOME",
	"KEY_DELETE",
	"KEY_NDIVIDE",
	"KEY_NMULTIPLY",
	"KEY_NMINUS",
	"KEY_NPLUS",
	"KEY_NEQUALS",
}

local function colorizeKey(text, key, colorHex)
	local coloredKey = "|cff" .. colorHex .. key .. "|r"

	-- Check if the key is already colored
	if not find(text, coloredKey, 1, true) then
		local escapedKey = key:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
		local newText = gsub(text, escapedKey, coloredKey)
		return newText
	end

	return text
end

function module:ColorKeybinds(button)
	local text = button.HotKey:GetText()
	local colorHex = "b3b3b3"
	if E.myclass ~= "PRIEST" then colorHex = sub(E:ClassColor(E.myclass, true).colorStr, 3) end

	if text and text ~= _G.RANGE_INDICATOR then
		for _, keyName in ipairs(keysToColorize) do
			local keyValue = L[keyName]
			if keyValue and type(keyValue) == "string" then text = colorizeKey(text, keyValue, colorHex) end
		end

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
