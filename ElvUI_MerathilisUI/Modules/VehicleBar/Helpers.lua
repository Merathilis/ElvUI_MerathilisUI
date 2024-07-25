local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_VehicleBar")

local C_UIWidgetManager = C_UIWidgetManager

local GetPlayerAuraBySpellID = C_UnitAuras and C_UnitAuras.GetPlayerAuraBySpellID
local GetPowerBarWidgetSetID = C_UIWidgetManager and C_UIWidgetManager.GetPowerBarWidgetSetID
local GetAllWidgetsBySetID = C_UIWidgetManager and C_UIWidgetManager.GetAllWidgetsBySetID
local GetFillUpFramesWidgetVisualizationInfo = C_UIWidgetManager
	and C_UIWidgetManager.GetFillUpFramesWidgetVisualizationInfo

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

function module:FormatKeybind(keybind)
	local modifier, key = keybind:match("^(%w)-(.+)$")
	if modifier and key then
		return modifier:upper() .. key
	else
		return keybind
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
