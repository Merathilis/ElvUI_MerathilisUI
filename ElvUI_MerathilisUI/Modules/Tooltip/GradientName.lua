local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local T = MER:GetModule("MER_Tooltip")
local TT = E:GetModule("Tooltip")

local _G = _G

local GetItemInfo = GetItemInfo
local GetItemQualityColor = GetItemQualityColor
local hooksecurefunc = hooksecurefunc
local TooltipDataType = Enum.TooltipDataType
local AddTooltipPostCall = TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall
local UnitClass = UnitClass
local UnitIsPlayer = UnitIsPlayer
local UnitReaction = UnitReaction

local function TooltipGradientName(unit)
	if not unit then
		return
	end

	local _, classunit = UnitClass(unit)
	local reaction = UnitReaction(unit, "player")

	local text = _G["GameTooltipTextLeft1"]:GetText()
	local tooltipName = text and E:StripString(text)

	local colorDB = E.db.mui.gradient

	if tooltipName and classunit and reaction then
		if UnitIsPlayer(unit) and classunit then
			if colorDB.enable and colorDB.customColor.enableClass then
				_G["GameTooltipTextLeft1"]:SetText(F.GradientNameCustom(tooltipName, classunit))
			else
				_G["GameTooltipTextLeft1"]:SetText(F.GradientName(tooltipName, classunit))
			end
		else
			if reaction and reaction >= 5 then
				if colorDB.customColor.enable then
					_G["GameTooltipTextLeft1"]:SetText(F.GradientNameCustom(tooltipName, "NPCFRIENDLY"))
				else
					_G["GameTooltipTextLeft1"]:SetText(F.GradientName(tooltipName, "NPCFRIENDLY"))
				end
			elseif reaction and reaction == 4 then
				if colorDB.customColor.enable then
					_G["GameTooltipTextLeft1"]:SetText(F.GradientNameCustom(tooltipName, "NPCNEUTRAL"))
				else
					_G["GameTooltipTextLeft1"]:SetText(F.GradientName(tooltipName, "NPCNEUTRAL"))
				end
			elseif reaction and reaction == 3 then
				if colorDB.customColor.enable then
					_G["GameTooltipTextLeft1"]:SetText(F.GradientNameCustom(tooltipName, "NPCUNFRIENDLY"))
				else
					_G["GameTooltipTextLeft1"]:SetText(F.GradientName(tooltipName, "NPCUNFRIENDLY"))
				end
			elseif reaction and reaction == 2 or reaction == 1 then
				if colorDB.customColor.enable then
					_G["GameTooltipTextLeft1"]:SetText(F.GradientNameCustom(tooltipName, "NPCHOSTILE"))
				else
					_G["GameTooltipTextLeft1"]:SetText(F.GradientName(tooltipName, "NPCHOSTILE"))
				end
			end
		end
	end
end

function T:ApplyTooltipStyle()
	local db = E.db.mui.gradient
	if not db.enable or not E.db.mui.tooltip.gradientName then
		return
	end

	if _G.GameTooltip and _G.GameTooltip:IsForbidden() then
		return
	end

	local _, unitId = _G.GameTooltip:GetUnit()
	if unitId then
		TooltipGradientName(unitId)
	end

	if not self.IsHooked then
		AddTooltipPostCall(TooltipDataType.Item, function(tt)
			if tt then
				local name, itemLink = GameTooltip:GetItem()
				if not name or not itemLink then
					return
				end

				local _, _, itemQuality = GetItemInfo(itemLink)
				if not itemQuality then
					return
				end

				local r2, g2, b2 = GetItemQualityColor(itemQuality)

				local r1 = r2 + -0.2
				r1 = F:Interval(r1, 0, 1)

				local g1 = g2 + -0.2
				g1 = F:Interval(g1, 0, 1)

				local b1 = b2 + -0.2
				b1 = F:Interval(b1, 0, 1)
				r2 = r2 + 0.2
				r2 = F:Interval(r2, 0, 1)
				g2 = g2 + 0.2
				g2 = F:Interval(g2, 0, 1)
				b2 = b2 + 0.2
				b2 = F:Interval(b2, 0, 1)

				if _G["GameTooltipTextLeft1"]:GetText() ~= nil then
					local icon = strmatch(_G["GameTooltipTextLeft1"]:GetText(), "^.-|t")
					if icon then
						_G["GameTooltipTextLeft1"]:SetText(icon .. " " .. E:TextGradient(name, r1, g1, b1, r2, g2, b2))
					else
						_G["GameTooltipTextLeft1"]:SetText(E:TextGradient(name, r1, g1, b1, r2, g2, b2))
					end
				else
					_G["GameTooltipTextLeft1"]:SetText(E:TextGradient(name, r1, g1, b1, r2, g2, b2))
				end
			end
		end)

		self.IsHooked = true
	end
end

hooksecurefunc(TT, "AddTargetInfo", T.ApplyTooltipStyle)
hooksecurefunc(TT, "GameTooltip_OnTooltipSetUnit", T.ApplyTooltipStyle)
hooksecurefunc(TT, "MODIFIER_STATE_CHANGED", T.ApplyTooltipStyle)
