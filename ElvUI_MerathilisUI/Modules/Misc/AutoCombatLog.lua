local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc") ---@class Misc

local _G = _G

local CreateFrame = CreateFrame
local GetCVar = GetCVar
local GetInstanceInfo = GetInstanceInfo
local LoggingCombat = LoggingCombat
local SetCVar = SetCVar
local C_Timer_After = C_Timer.After
local C_Timer_NewTimer = C_Timer.NewTimer

local ZONE_DELAY = 2 -- GetInstanceInfo still reports the old difficulty right after the zone events
local STOP_DELAY = 60 -- long enough that releasing and running back in keeps the same log going

-- Difficulty IDs are unique across raids and dungeons, so one table covers both
local SETTING_BY_DIFFICULTY = {
	[8] = "mythicPlus",
	[14] = "raidNormal",
	[15] = "raidHeroic",
	[16] = "raidMythic",
	[17] = "raidFinder",
	[23] = "mythicDungeon",
}

local eventFrame
local stopTimer

---@return boolean
local function IsWanted()
	local db = E.db.mui.misc.autoCombatLog
	if not db.enable then
		return false
	end

	local _, _, difficultyID = GetInstanceInfo()
	local setting = SETTING_BY_DIFFICULTY[difficultyID]
	return setting and db[setting] or false
end

local function Stop()
	stopTimer = nil
	if IsWanted() then
		return
	end

	E.private.mui.autoCombatLog.started = false
	if LoggingCombat() then
		LoggingCombat(false)
		F.Print(_G.COMBATLOGDISABLED)
	end
end

-- The started flag lives in the private db so a /reload inside the instance doesn't forget it.
-- A log the player started by hand never gets it and is left alone.
local function Update()
	if IsWanted() then
		if stopTimer then
			stopTimer:Cancel()
			stopTimer = nil
		end

		if not LoggingCombat() then
			if E.db.mui.misc.autoCombatLog.advanced and GetCVar("advancedCombatLogging") ~= "1" then
				SetCVar("advancedCombatLogging", "1")
			end

			LoggingCombat(true)
			E.private.mui.autoCombatLog.started = true
			F.Print(_G.COMBATLOGENABLED)
		end
	elseif E.private.mui.autoCombatLog.started and not stopTimer then
		stopTimer = C_Timer_NewTimer(STOP_DELAY, Stop)
	end
end

local function OnEvent()
	C_Timer_After(ZONE_DELAY, Update)
end

function module:AutoCombatLog()
	if E.db.mui.misc.autoCombatLog.enable then
		if not eventFrame then
			eventFrame = CreateFrame("Frame")
			eventFrame:SetScript("OnEvent", OnEvent)
		end

		eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
		eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		if not E.Forever then
			eventFrame:RegisterEvent("CHALLENGE_MODE_START")
		end
	elseif eventFrame then
		eventFrame:UnregisterAllEvents()
	end

	OnEvent()
end

module:AddCallback("AutoCombatLog")
