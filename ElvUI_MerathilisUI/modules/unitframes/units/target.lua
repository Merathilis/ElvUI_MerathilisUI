local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule("muiUnits")
local UF = E:GetModule("UnitFrames")

-- Cache global variables
-- Lua functions
local _G = _G
local select = select
-- WoW API / Variables
local UnitClass = UnitClass
local UnitIsPlayer = UnitIsPlayer
local UnitReaction = UnitReaction
local hooksecurefunc = hooksecurefunc
-- GLOBALS:

function module:RecolorTargetInfoPanel()
	local frame = _G["ElvUF_Target"]
	if E.db.mui.unitframes.infoPanel.style ~= true then return end
	if not frame.USE_INFO_PANEL then return end

	local targetClass = select(2, UnitClass("target"));

	do
		local r, g, b
		local panel = frame.InfoPanel
		local isPlayer = UnitIsPlayer("target")
		local classColor =  E:ClassColor(targetClass)
		local reaction = UnitReaction('target', 'player')

		if isPlayer then
			r, g, b = classColor.r, classColor.g, classColor.b
		else
			if reaction then
				local tpet = ElvUF.colors.reaction[reaction]
				r, g, b = tpet[1], tpet[2], tpet[3]
			end
		end

		panel.color:SetVertexColor(r, g, b, 1)
	end
end

function module:PLAYER_TARGET_CHANGED()
	self:ScheduleTimer("RecolorTargetInfoPanel", 0.02)
end

function module:InitTarget()
	if not E.db.unitframe.units.target.enable then return end

	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	hooksecurefunc(UF, "Update_TargetFrame", module.RecolorTargetInfoPanel)
end
