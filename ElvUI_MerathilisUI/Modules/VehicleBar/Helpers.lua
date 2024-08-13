local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_VehicleBar")
local AB = MER:GetModule("MER_Actionbars")

local sub = string.utf8sub
local len = strlenutf8

local C_UIWidgetManager = C_UIWidgetManager
local GetPlayerAuraBySpellID = C_UnitAuras.GetPlayerAuraBySpellID
local GetPowerBarWidgetSetID = C_UIWidgetManager.GetPowerBarWidgetSetID
local GetAllWidgetsBySetID = C_UIWidgetManager.GetAllWidgetsBySetID
local GetFillUpFramesWidgetVisualizationInfo = C_UIWidgetManager.GetFillUpFramesWidgetVisualizationInfo

function module:IsVigorAvailable()
	if F.IsSkyriding() then
		return true
	else
		return false
	end
end

function module:GetWidgetInfo()
	local widgetSetID = GetPowerBarWidgetSetID()
	local widgets = GetAllWidgetsBySetID(widgetSetID)

	local widgetInfo = nil
	for _, w in pairs(widgets) do
		local tempInfo = GetFillUpFramesWidgetVisualizationInfo(w.widgetID)
		if tempInfo and tempInfo.shownState == 1 then
			widgetInfo = tempInfo
		end
	end

	return widgetInfo
end

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
	local text = self:FixKeybindText(keybind)

	if text and text ~= _G.RANGE_INDICATOR and len(text) > 1 and E.db.mui.actionbars.colorModifier then
		local colorHex = sub(E:ClassColor(E.myclass, true).colorStr, 3)
		text = AB:ColorizeKey(text, colorHex)
		return text
	else
		return text
	end
end

function module:ColorSpeedText(msg)
	local thrillActive = GetPlayerAuraBySpellID(377234)
	if thrillActive then
		local r, g, b = self.vdb.thrillColor.r, self.vdb.thrillColor.g, self.vdb.thrillColor.b

		return F.String.Color(msg, F.String.FastRGB(r, g, b))
	else
		return msg
	end
end
