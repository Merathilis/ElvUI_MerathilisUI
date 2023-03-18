local MER, F, E, L, V, P, G = unpack((select(2, ...)))

local format = format
local find = string.find
local select = select

local GetAchievementInfo = GetAchievementInfo
local UnitGUID = UnitGUID

local function SetHyperlink(tooltip, refString)
	if E.db.mui.tooltip.achievement ~= true then return end
	if tooltip:IsForbidden() then return; end
	if select(3, find(refString, "(%a-):")) ~= "achievement" then return end

	local _, _, achievementID = find(refString, ":(%d+):")
	local _, _, GUID = find(refString, ":%d+:(.-):")

	if GUID == UnitGUID("player") then
		tooltip:Show()
		return
	end

	tooltip:AddLine(" ")
	local _, _, _, completed, _, _, _, _, _, _, _, _, wasEarnedByMe, earnedBy = GetAchievementInfo(achievementID)

	if completed then
		if earnedBy then
			if earnedBy ~= "" then
				tooltip:AddLine(format(ACHIEVEMENT_EARNED_BY, earnedBy))
			end
			if not wasEarnedByMe then
				tooltip:AddLine(format(ACHIEVEMENT_NOT_COMPLETED_BY, E.myname))
			elseif E.myname ~= earnedBy then
				tooltip:AddLine(format(ACHIEVEMENT_COMPLETED_BY, E.myname))
			end
		end
	end
	tooltip:Show()
end

hooksecurefunc(GameTooltip, "SetHyperlink", SetHyperlink)
hooksecurefunc(ItemRefTooltip, "SetHyperlink", SetHyperlink)
