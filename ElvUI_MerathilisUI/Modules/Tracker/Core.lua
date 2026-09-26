local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Tracker")
local WS = W:GetModule("Skins")

-- Credit: EllesmereUI, by EllesmereGaming

local ipairs, format, gsub, unpack, tostring = ipairs, format, gsub, unpack, tostring

local C_ChallengeMode = C_ChallengeMode
local C_Timer = C_Timer
local CreateFrame = CreateFrame
local GetInstanceInfo = GetInstanceInfo
local IsEncounterInProgress = IsEncounterInProgress

local TEST_DURATION = 20

-------------------------------------------------------------------------------
--  Helpers
-------------------------------------------------------------------------------
function module.IsSecret(value)
	return E:IsSecretValue(value)
end

-- Secret values can not be turned into a string, so debug output names them instead.
function module.Describe(value)
	if module.IsSecret(value) then
		return "|cffff9900secret|r"
	end
	return tostring(value)
end

function module.SetFont(object, db)
	local style = db.style or "OUTLINE"
	local shadow = style:find("SHADOW") ~= nil
	style = gsub(style, "SHADOW", "")
	if style == "NONE" then
		style = ""
	end

	object:SetFont(F.GetFontPath(db.name), db.size or 14, style)
	if shadow then
		object:SetShadowColor(0, 0, 0, 1)
		object:SetShadowOffset(1, -1)
	else
		object:SetShadowOffset(0, 0)
	end
end

local function ActiveKeystone()
	-- Only true while the key timer runs, not just for having a keystone in a dungeon.
	return C_ChallengeMode.IsChallengeModeActive() and (C_ChallengeMode.GetActiveKeystoneInfo() or 0) > 0
end

-------------------------------------------------------------------------------
--  Shared widgets
-------------------------------------------------------------------------------
-- Remaining times are always drawn by the Cooldown widget itself: the engine can
-- render times that are secret for Lua, readable ones look the same.
function module:CreateCountdown(parent, fontName)
	local cooldown = CreateFrame("Cooldown", nil, parent, "CooldownFrameTemplate")
	cooldown:SetDrawEdge(false)
	cooldown:SetDrawBling(false)
	cooldown:SetHideCountdownNumbers(false)
	cooldown:SetCountdownFont(fontName)
	cooldown.noCooldownCount = true -- OmniCC
	cooldown.noOCC = true
	cooldown:SetMinimumCountdownDuration(0)
	cooldown:SetCountdownMillisecondsThreshold(0)
	-- "4:14" instead of "5m" for anything below an hour
	cooldown:SetCountdownAbbrevThreshold(3600)
	return cooldown
end

function module:CreateIcon(parent)
	local iconFrame = CreateFrame("Frame", nil, parent)
	iconFrame:SetTemplate()
	WS:CreateShadow(iconFrame)
	iconFrame:SetAllPoints()
	iconFrame.icon = iconFrame:CreateTexture(nil, "ARTWORK")
	iconFrame.icon:SetInside()
	iconFrame.icon:SetTexCoord(unpack(E.TexCoords))
	return iconFrame
end

function module:CreateTrackerMover(frame, name, text, db)
	E:CreateMover(
		frame,
		name,
		MER.Title .. text,
		nil,
		nil,
		nil,
		"ALL,PARTY,RAID,MERATHILISUI",
		function()
			return not (module.db and module.db[db].enable)
		end,
		"mui,modules,tracker"
	)
end

-------------------------------------------------------------------------------
--  Debug
--  Shows the trackers everywhere with their real data and prints every change
--  of that data and of the visibility state to the chat.
-------------------------------------------------------------------------------
function module:IsDebug()
	return self.db and self.db.debug
end

function module:DebugPrint(...)
	if self:IsDebug() then
		F.Print("|cff00c0fa[Tracker]|r", ...)
	end
end

function module:DebugState(reason)
	if not self:IsDebug() then
		return
	end

	local _, instanceType, difficultyID = GetInstanceInfo()
	self:DebugPrint(
		format(
			"%s: instance %s (difficulty %s), keystone %s, raid encounter %s, battle res shown %s, bloodlust shown %s",
			reason,
			tostring(instanceType),
			tostring(difficultyID),
			tostring(self.inKeystone),
			tostring(self.inRaidEncounter),
			tostring(self.battleResFrame and self.battleResFrame:IsShown()),
			tostring(self.bloodlustFrame and self.bloodlustFrame:IsShown())
		)
	)
end

-------------------------------------------------------------------------------
--  Visibility
-------------------------------------------------------------------------------
function module:RefreshInstanceState()
	local _, instanceType = GetInstanceInfo()
	self.inRaidEncounter = IsEncounterInProgress() and instanceType == "raid"
	self.inKeystone = ActiveKeystone()
end

-- Common gates of both trackers. visibility: MPLUS_AND_RAID, MPLUS or RAID
function module:ShouldShowTracker(db)
	if not db.enable then
		return false
	end

	if self.testMode or self.db.debug then
		return true
	end

	-- Hard gate, so a stuck state can never leave a tracker up in the open world
	local _, instanceType = GetInstanceInfo()
	if instanceType ~= "party" and instanceType ~= "raid" then
		return false
	end

	local visibility = db.visibility
	if visibility ~= "RAID" and self.inKeystone then
		return true
	end

	if visibility ~= "MPLUS" and self.inRaidEncounter then
		return true
	end

	return false
end

function module:UpdateVisibility(reason)
	self:UpdateBattleRes()
	self:UpdateBloodlust()

	if reason then
		self:DebugState(reason)
	end
end

-------------------------------------------------------------------------------
--  Test mode
-------------------------------------------------------------------------------
function module:ToggleTestMode()
	self.testMode = not self.testMode
	if self.testTimer then
		self.testTimer:Cancel()
		self.testTimer = nil
	end

	if self.testMode then
		self.testTimer = C_Timer.NewTimer(TEST_DURATION, function()
			self.testTimer = nil
			if self.testMode then
				self:ToggleTestMode()
			end
		end)
	end

	self:ResetBattleResTest()
	self:UpdateVisibility()
	E.Libs.AceConfigRegistry:NotifyChange("ElvUI")
end

-------------------------------------------------------------------------------
--  Events
-------------------------------------------------------------------------------
local EVENTS = {
	"PLAYER_ENTERING_WORLD",
	"ENCOUNTER_START",
	"ENCOUNTER_END",
	"CHALLENGE_MODE_START",
	"CHALLENGE_MODE_COMPLETED",
	"CHALLENGE_MODE_RESET",
	"WORLD_STATE_TIMER_START",
	"WORLD_STATE_TIMER_STOP",
}

function module:PLAYER_ENTERING_WORLD(event)
	self:RefreshInstanceState()
	self:ResetBloodlustOnZone()
	self:UpdateVisibility(event)
end

function module:ENCOUNTER_START(event)
	local _, instanceType = GetInstanceInfo()
	self.inRaidEncounter = instanceType == "raid"
	self:UpdateVisibility(event)
end

function module:ENCOUNTER_END(event)
	self.inRaidEncounter = false
	self:UpdateVisibility(event)
end

function module:KeystoneStarted(event)
	self.inKeystone = ActiveKeystone()
	self:UpdateVisibility(event)
end

function module:KeystoneStopped(event)
	self.inKeystone = false
	self:UpdateVisibility(event)
end

module.CHALLENGE_MODE_START = module.KeystoneStarted
module.WORLD_STATE_TIMER_START = module.KeystoneStarted
module.CHALLENGE_MODE_COMPLETED = module.KeystoneStopped
module.CHALLENGE_MODE_RESET = module.KeystoneStopped
module.WORLD_STATE_TIMER_STOP = module.KeystoneStopped

-------------------------------------------------------------------------------
--  Lifecycle
-------------------------------------------------------------------------------
local function SetMoverEnabled(name, enabled)
	if enabled then
		E:EnableMover(name)
	else
		E:DisableMover(name)
	end
end

function module:IsAnyTrackerEnabled()
	return self.db.battleRes.enable or self.db.bloodlust.enable
end

function module:EnableTrackers()
	self:CreateBattleResFrames()
	self:CreateBloodlustFrames()
	SetMoverEnabled("MER_TrackerBattleResMover", self.db.battleRes.enable)
	SetMoverEnabled("MER_TrackerBloodlustMover", self.db.bloodlust.enable)

	for _, event in ipairs(EVENTS) do
		self:RegisterEvent(event)
	end
	self:EnableBloodlust()

	self:RefreshInstanceState()
	self:UpdateBattleResLayout()
	self:UpdateBloodlustLayout()
	-- Print the current data again, e.g. right after the debug mode was turned on
	self.lastDebugLine = nil
	self:UpdateVisibility("Settings")
end

function module:DisableTrackers()
	self:UnregisterAllEvents()
	self:DisableBloodlust()
	if self.testMode then
		self:ToggleTestMode()
	end

	if self.battleResFrame then
		E:DisableMover("MER_TrackerBattleResMover")
		E:DisableMover("MER_TrackerBloodlustMover")
		self:UpdateVisibility()
	end
end

-- Called by the options after any setting changed.
function module:SettingsUpdate()
	if not self.db then
		return
	end

	if self:IsAnyTrackerEnabled() then
		self:EnableTrackers()
	else
		self:DisableTrackers()
	end
end

function module:Initialize()
	self.db = E.db.mui.tracker

	if self:IsAnyTrackerEnabled() then
		self:EnableTrackers()
	end
end

function module:ProfileUpdate()
	self.db = E.db.mui.tracker
	self:SettingsUpdate()
end

MER:RegisterModule(module:GetName())
