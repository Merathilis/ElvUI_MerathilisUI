local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local T = MER:GetModule('MER_Tooltip')
local TT = E:GetModule('Tooltip')

local _G = _G
local gsub = string.gsub

local UnitClass = UnitClass
local UnitIsPlayer = UnitIsPlayer
local UnitReaction = UnitReaction
local hooksecurefunc = hooksecurefunc

local function TooltipGradientName(unit)
	if not unit then return end

	local _, classunit = UnitClass(unit)
	local reaction = UnitReaction(unit, 'player')

	local text = _G['GameTooltipTextLeft1']:GetText()
	local tooltipName = text and E:StripString(text)

	local colorDB = E.db.mui.gradient

	if tooltipName and classunit and reaction then
		if UnitIsPlayer(unit) and classunit then
			if colorDB.customColor.enable then
				_G["GameTooltipTextLeft1"]:SetText(F.GradientNameCustom(tooltipName, classunit))
			else
				_G["GameTooltipTextLeft1"]:SetText(F.GradientName(tooltipName, classunit))
			end
		else
			if reaction and reaction >= 5 then
				if colorDB.customColor.enable then
					_G["GameTooltipTextLeft1"]:SetText(F.GradientNameCustom(tooltipName, 'NPCFRIENDLY'))
				else
					_G["GameTooltipTextLeft1"]:SetText(F.GradientName(tooltipName, 'NPCFRIENDLY'))
				end
			elseif reaction and reaction == 4 then
				if colorDB.customColor.enable then
					_G["GameTooltipTextLeft1"]:SetText(F.GradientNameCustom(tooltipName, 'NPCNEUTRAL'))
				else
					_G["GameTooltipTextLeft1"]:SetText(F.GradientName(tooltipName, 'NPCNEUTRAL'))
				end
			elseif reaction and reaction == 3 then
				if colorDB.customColor.enable then
					_G["GameTooltipTextLeft1"]:SetText(F.GradientNameCustom(tooltipName, 'NPCUNFRIENDLY'))
				else
					_G["GameTooltipTextLeft1"]:SetText(F.GradientName(tooltipName, 'NPCUNFRIENDLY'))
				end
			elseif reaction and reaction == 2 or reaction == 1 then
				if colorDB.customColor.enable then
					_G["GameTooltipTextLeft1"]:SetText(F.GradientNameCustom(tooltipName, 'NPCHOSTILE'))
				else
					_G["GameTooltipTextLeft1"]:SetText(F.GradientName(tooltipName, 'NPCHOSTILE'))
				end
			end
		end
	end
end

function T:ApplyTooltipStyle(tt)
	if not tt then return end
	local db = E.db.mui.gradient
	if not db.enable then
		return
	end
	if _G.GameTooltip and _G.GameTooltip:IsForbidden() then return end

	local _, unitId = _G.GameTooltip:GetUnit()
	if unitId then
		TooltipGradientName(unitId)
	end
end

hooksecurefunc(TT, 'AddTargetInfo', T.ApplyTooltipStyle)
hooksecurefunc(TT, 'GameTooltip_OnTooltipSetUnit', T.ApplyTooltipStyle)
hooksecurefunc(TT, 'MODIFIER_STATE_CHANGED', T.ApplyTooltipStyle)
