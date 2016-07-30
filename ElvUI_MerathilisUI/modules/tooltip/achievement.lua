local E, L, V, P, G = unpack(ElvUI);

-- Cache global variables
-- Lua functions
local find, format, sub = string.find, string.format, string.sub
local select = select
local date = date
-- WoW API / Variables
local GetAchievementCriteriaInfo = GetAchievementCriteriaInfo
local GetAchievementInfo = GetAchievementInfo
local GetAchievementNumCriteria = GetAchievementNumCriteria
local GetLocale = GetLocale
local IsAddOnLoaded = IsAddOnLoaded
local UnitGUID = UnitGUID
local UnitName = UnitName
local ACHIEVEMENT_EARNED_BY = ACHIEVEMENT_EARNED_BY
local ACHIEVEMENT_NOT_COMPLETED_BY = ACHIEVEMENT_NOT_COMPLETED_BY
local ACHIEVEMENT_COMPLETED_BY = ACHIEVEMENT_COMPLETED_BY
-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: GameTooltip, hooksecurefunc, ItemRefTooltip

-- Credits: Enhanced Achievements by Syzgyn
if IsAddOnLoaded("Enhanced Achievements") then return; end

local colors = {
	["GREEN"] = {
		["r"] = 0.25,
		["g"] = 0.75,
		["b"] = 0.25,
	},
	["GRAY"] = {
		["r"] = 0.5,
		["g"] = 0.5,
		["b"] = 0.5,
	},
}

local function SetHyperlink(tooltip, refString)
	local output = {[0] = {}, [1] = {}}
	if select(3, find(refString, "(%a-):")) ~= "achievement" then return end

	local _, _, achievementID = find(refString, ":(%d+):")
	local numCriteria = GetAchievementNumCriteria(achievementID)
	local _, _, GUID = find(refString, ":%d+:(.-):")
	local Name = UnitName("player")

	if GUID == UnitGUID("player") then
		tooltip:Show()
		return
	end

	tooltip:AddLine(" ")
	local _, _, _, completed, month, day, year, _, _, _, _, _, wasEarnedByMe, earnedBy = GetAchievementInfo(achievementID)

	if completed then
		if year < 10 then year = "0"..year end

		if GetLocale() == "ruRU" or "deDE" then
			tooltip:AddLine(L["Your Status: Completed on "]..day.."/"..month.."/"..year, 0, 1, 0)
		else
			tooltip:AddLine(L["Your Status: Completed on "]..month.."/"..day.."/"..year, 0, 1, 0)
		end

		if earnedBy then
			if earnedBy ~= "" then
				tooltip:AddLine(format(ACHIEVEMENT_EARNED_BY, earnedBy))
			end
			if not wasEarnedByMe then
				tooltip:AddLine(format(ACHIEVEMENT_NOT_COMPLETED_BY, Name))
			elseif Name ~= earnedBy then
				tooltip:AddLine(format(ACHIEVEMENT_COMPLETED_BY, Name))
			end
		end
	elseif numCriteria == 0 then
		tooltip:AddLine(L["Your Status: Incomplete"])
	else
		tooltip:AddLine(L["Your Status:"])
		for i = 1, numCriteria, 2 do
			for a = 0, 1 do
				output[a].text = nil
				output[a].color = nil
				if i + a <= numCriteria then
					local name, _, completed, quantity, reqQuantity = GetAchievementCriteriaInfo(achievementID, i + a)
					if completed then
						output[a].text = name
						output[a].color = "GREEN"
					else
						if quantity < reqQuantity and reqQuantity > 1 then
							output[a].text = name.." ("..quantity.."/"..reqQuantity..")"
							output[a].color = "GRAY"
						else
							output[a].text = name
							output[a].color = "GRAY"
						end
					end
				else
					output[a].text = nil
				end
			end
			if output[1].text == nil then
				tooltip:AddLine(output[0].text, colors[output[0].color].r, colors[output[0].color].g, colors[output[0].color].b)
			else
				tooltip:AddDoubleLine(output[0].text, output[1].text, colors[output[0].color].r, colors[output[0].color].g, colors[output[0].color].b, colors[output[1].color].r, colors[output[1].color].g, colors[output[1].color].b)
			end
			output = {[0] = {}, [1] = {}}
		end
	end
	tooltip:Show()
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event)
	if E.db.mui.misc.Tooltip ~= true then return; end
	if event == "PLAYER_ENTERING_WORLD" then
		hooksecurefunc(GameTooltip, "SetHyperlink", SetHyperlink)
		hooksecurefunc(ItemRefTooltip, "SetHyperlink", SetHyperlink)
		f:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
end)