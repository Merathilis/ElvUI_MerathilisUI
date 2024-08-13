local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Actionbars")
local AB = E:GetModule("ActionBars")

local _G = _G
local sub = string.sub

local function colorizeKey(text, colorHex)
	if #text > 1 then
		local baseText = text:sub(1, #text - 1)
		local lastChar = text:sub(-1)

		-- check if the last character is a known character
		if lastChar:match("[ß´]") then
			baseText = text:sub(1, #text - 2)
			lastChar = text:sub(-2)
		elseif not lastChar:match("[%w%s%p]") then
			-- check for alphanumeric character & remove unknown characters (boxes/asccicode?)
			lastChar = ""
		end

		local coloredText = "|cff" .. colorHex .. baseText .. "|r" .. lastChar
		return coloredText
	else
		return text
	end
end

function module:ColorKeybinds(button)
	local text = button.HotKey:GetText()
	local colorHex = "b3b3b3"
	if E.myclass ~= "PRIEST" then
		colorHex = sub(E:ClassColor(E.myclass, true).colorStr, 3)
	end

	if text and text ~= _G.RANGE_INDICATOR and #text > 1 then
		text = colorizeKey(text, colorHex)
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
