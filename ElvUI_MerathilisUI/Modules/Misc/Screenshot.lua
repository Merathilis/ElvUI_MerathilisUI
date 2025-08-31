local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc") ---@class Misc

function module:TakeScreenshot(event, delay)
	local db = E.db.mui.misc.screenshot

	if db and db.printMsg then
		F.Print(format("%s %s", L["taking screenshot"], event .. " " .. date()))
	end

	if db and db.hideUI then
		E.UIParent:Hide()
		E:Delay(0.5, Screenshot())
		E:Delay(0.55, E.UIParent:Show())
	else
		E:Delay(delay, Screenshot())
	end
end

function module:PlayerStartMoving(event) -- debug
	module:TakeScreenshot(event)
end

function module:AchievementEarned(event, achievementID, alreadyEarned)
	if alreadyEarned then
		return
	end

	module:TakeScreenshot(event)
end

function module:ChallengeModeCompleted(event)
	ChallengeModeCompleteBanner:HookScript("OnShow", function()
		module:TakeScreenshot(event, 3)
	end)
end

function module:PlayerLevelUp(event)
	module:TakeScreenshot(event)
end

function module:PlayerDead(event)
	module:TakeScreenshot(event)
end

function module:UpdateConfig()
	local db = E.db.mui.misc.screenshot

	if db.enable and db.playerStartedMoving then
		MER:RegisterEvent("PLAYER_STARTED_MOVING", module.PlayerStartMoving)
	else
		MER:UnregisterEvent("PLAYER_STARTED_MOVING", module.PlayerStartMoving)
	end

	if db.enable and db.achievementEarned then
		MER:RegisterEvent("ACHIEVEMENT_EARNED", module.AchievementEarned)
	else
		MER:UnregisterEvent("ACHIEVEMENT_EARNED", module.AchievementEarned)
	end

	if db.enable and db.challengeModeCompleted then
		MER:RegisterEvent("CHALLENGE_MODE_COMPLETED", module.ChallengeModeCompleted)
	else
		MER:UnregisterEvent("CHALLENGE_MODE_COMPLETED", module.ChallengeModeCompleted)
	end

	if db.enable and db.playerLevelUp then
		MER:RegisterEvent("PLAYER_LEVEL_UP", module.PlayerLevelUp)
	else
		MER:UnregisterEvent("PLAYER_LEVEL_UP", module.PlayerLevelUp)
	end

	if db.enable and db.playerDead then
		MER:RegisterEvent("PLAYER_DEAD", module.PlayerDead)
	else
		MER:UnregisterEvent("PLAYER_DEAD", module.PlayerDead)
	end
end

function module:Screenshot()
	self.db = F.GetDBFromPath("mui.misc.screenshot")
	if not self.db and not self.db.enable then
		return
	end

	module:UpdateConfig()
end

module:AddCallback("Screenshot")
