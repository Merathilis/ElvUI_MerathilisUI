local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_VehicleBar")

local C_UIWidgetManager = C_UIWidgetManager

local GetPlayerAuraBySpellID = C_UnitAuras and C_UnitAuras.GetPlayerAuraBySpellID
local GetFillUpFramesWidgetVisualizationInfo = C_UIWidgetManager
	and C_UIWidgetManager.GetFillUpFramesWidgetVisualizationInfo

function module:IsVigorAvailable()
	if E:IsDragonRiding() or (IsMounted() and HasBonusActionBar()) then
		return true
	else
		return false
	end
end

function module:GetWidgetInfo()
	local widgetInfo

	for _, widget in pairs(UIWidgetPowerBarContainerFrame.widgetFrames) do
		if widget then
			if widget.widgetType == 24 and widget.widgetSetID == 283 then
				local tempInfo = GetFillUpFramesWidgetVisualizationInfo(widget.widgetID)
				if tempInfo and tempInfo.shownState == 1 then
					widgetInfo = tempInfo
				end
				widget:Hide()
				widget = nil
			end
		end
	end

	return (IsMounted() and HasBonusActionBar()) and widgetInfo
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
		local r, g, b = self.db.thrillColor.r, self.db.thrillColor.g, self.db.thrillColor.b

		return F.String.Color(msg, F.String.FastRGB(r, g, b))
	else
		return msg
	end
end
