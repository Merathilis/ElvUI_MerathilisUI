local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Tooltip")

local format = format
local find = string.find
local select = select
local type = type

local GetAchievementInfo = GetAchievementInfo
local hooksecurefunc = hooksecurefunc
local UnitGUID = UnitGUID

local function SetHyperlink(tooltip, refString)
	if not E.db.mui.tooltip.achievement or tooltip:IsForbidden() then
		return
	end

	-- A secret link can't be searched
	if E:IsSecretValue(refString) or type(refString) ~= "string" then
		return
	end

	if select(3, find(refString, "(%a-):")) ~= "achievement" then
		return
	end

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

-- Hooked on first enable only, the hook checks the setting from then on
function module:InitializeAchievement()
	if self.achievementHooked or not E.db.mui.tooltip.achievement then
		return
	end
	self.achievementHooked = true

	hooksecurefunc(GameTooltip, "SetHyperlink", SetHyperlink)
	hooksecurefunc(ItemRefTooltip, "SetHyperlink", SetHyperlink)
end
