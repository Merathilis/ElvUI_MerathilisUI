local MER, E, L, V, P, G = unpack(select(2, ...))
local MUF = E:GetModule("muiUnits")
local UF = E:GetModule("UnitFrames")

-- Cache global variables
-- Lua functions
local _G = _G
local select = select
-- WoW API / Variables
local CreateFrame = CreateFrame
local UnitClass = UnitClass
local UnitPowerMax = UnitPowerMax
local UnitIsPlayer = UnitIsPlayer
local UnitPowerType = UnitPowerType
local UnitReaction = UnitReaction
-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: hooksecurefunc, ElvUF, CUSTOM_CLASS_COLORS, CUSTOM_CLASS_COLORS, RAID_CLASS_COLORS

function MUF:Construct_TargetFrame()
	local frame = _G["ElvUF_Target"]

	if not frame.Portrait.backdrop.shadow then
		frame.Portrait.backdrop:CreateShadow()
		frame.Portrait.backdrop.shadow:Hide()
	end

	local f = CreateFrame("Frame", nil, frame)
	frame.portraitmover = f

	self:ArrangeTarget()
end

local r, g, b = 0, 0, 0

function MUF:RecolorTargetDetachedPortraitStyle()
	local frame = _G["ElvUF_Target"]
	local db = E.db["unitframe"]["units"].target

	if E.db.mui.unitframes.target.portraitStyle ~= true or db.portrait.overlay == true then return end

	local targetClass = select(2, UnitClass("target"));

	do
		local portrait = frame.Portrait
		local power = frame.Power

		if frame.USE_PORTRAIT and portrait.backdrop.style and E.db.mui.unitframes.target.portraitStyle then
			local maxValue = UnitPowerMax("target")
			local _, pToken, altR, altG, altB = UnitPowerType("target")
			local mu = power.bg.multiplier or 1
			local color = ElvUF["colors"].power[pToken]
			local isPlayer = UnitIsPlayer("target")
			local classColor = (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[targetClass] or RAID_CLASS_COLORS[targetClass])

			if not power.colorClass then
				if maxValue > 0 then
					if color then
						r, g, b = color[1], color[2], color[3]
					else
						r, g, b = altR, altG, altB
					end
				else
					if color then
						r, g, b = color[1] * mu, color[2] * mu, color[3] * mu
					end
				end
			else
				local reaction = UnitReaction("target", "player")
				if maxValue > 0 then
					if isPlayer then
						r, g, b = classColor.r, classColor.g, classColor.b
					else
						if reaction then
							local tpet = ElvUF.colors.reaction[reaction]
							r, g, b = tpet[1], tpet[2], tpet[3]
						end
					end
				else
					if reaction then
						local t = ElvUF.colors.reaction[reaction]
						r, g, b = t[1] * mu, t[2] * mu, t[3] * mu
					end
				end
			end
			portrait.backdrop.style:SetBackdropColor(r, g, b, (E.db.mui.colors.styleAlpha or 1))
		end
	end
end

function MUF:ArrangeTarget()
	local frame = _G["ElvUF_Target"]
	local db = E.db["unitframe"]["units"].target

	do
		frame.PORTRAIT_DETACHED = E.db.mui.unitframes.target.detachPortrait
		frame.PORTRAIT_TRANSPARENCY = E.db.mui.unitframes.target.portraitTransparent
		frame.PORTRAIT_SHADOW = E.db.mui.unitframes.target.portraitShadow

		frame.PORTRAIT_STYLING = E.db.mui.unitframes.target.portraitStyle
		frame.PORTRAIT_STYLING_HEIGHT = E.db.mui.unitframes.target.portraitStyleHeight
		frame.DETACHED_PORTRAIT_WIDTH = E.db.mui.unitframes.target.getPlayerPortraitSize and E.db.mui.unitframes.player.portraitWidth or E.db.mui.unitframes.target.portraitWidth
		frame.DETACHED_PORTRAIT_HEIGHT = E.db.mui.unitframes.target.getPlayerPortraitSize and E.db.mui.unitframes.player.portraitHeight or E.db.mui.unitframes.target.portraitHeight
		frame.DETACHED_PORTRAIT_STRATA = E.db.mui.unitframes.target.portraitFrameStrata

		frame.PORTRAIT_AND_INFOPANEL = E.db.mui.unitframes.infoPanel.fixInfoPanel and frame.USE_INFO_PANEL and frame.PORTRAIT_WIDTH 
		frame.POWER_VERTICAL = db.power.vertical
	end

	-- Portrait
	MUF:Configure_Portrait(frame, false)

	frame:UpdateAllElements("mUI_UpdateAllElements")
end

function MUF:PLAYER_TARGET_CHANGED()
	self:ScheduleTimer("RecolorTargetDetachedPortraitStyle", 0.02)
end

function MUF:InitTarget()
	if not E.db.unitframe.units.target.enable then return end

	self:Construct_TargetFrame()
	hooksecurefunc(UF, "Update_TargetFrame", MUF.ArrangeTarget)
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	hooksecurefunc(UF, "Update_TargetFrame", MUF.RecolorTargetDetachedPortraitStyle)

	-- Needed for some post updates
	hooksecurefunc(UF, "Configure_Portrait", function(self, frame)
		local unitframeType = frame.unitframeType

		if unitframeType == "target" then
			MUF:Configure_Portrait(frame, false)
		end
	end)
end