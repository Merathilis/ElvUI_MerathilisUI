local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_BattleRes")
local WS = W:GetModule("Skins")

-- Credit: EllesmereUI, by EllesmereGaming

local ipairs, format, gsub, max, ceil, unpack, tostring = ipairs, format, gsub, math.max, math.ceil, unpack, tostring

local C_ChallengeMode = C_ChallengeMode
local C_Spell = C_Spell
local C_Timer = C_Timer
local CreateFont = CreateFont
local CreateFrame = CreateFrame
local GetInstanceInfo = GetInstanceInfo
local GetTime = GetTime
local IsEncounterInProgress = IsEncounterInProgress

-- Rebirth: inside a raid encounter or an active keystone every battle res of the
-- group draws from one shared pool, and this spell reports that pool.
local BREZ_SPELL_ID = 20484
local POLL_INTERVAL = 0.5
local TEST_DURATION = 20
local TEST_RECHARGE = 90

-------------------------------------------------------------------------------
--  Helpers
-------------------------------------------------------------------------------
local function IsSecret(value)
	return E:IsSecretValue(value)
end

-- Secret values can not be turned into a string, so debug output names them instead.
local function Describe(value)
	if IsSecret(value) then
		return "|cffff9900secret|r"
	end
	return tostring(value)
end

local function SetFont(object, db)
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
--  Frames
-------------------------------------------------------------------------------
-- The remaining recharge time is always drawn by the Cooldown widget itself: the
-- engine can render times that are secret for Lua, readable ones look the same.
local timeFont = CreateFont("MER_BattleResTimeFont")
timeFont:SetFont(E.media.normFont, 14, "OUTLINE")

function module:CreateFrames()
	if self.frame then
		return
	end

	local frame = CreateFrame("Frame", "MER_BattleRes", E.UIParent)
	frame:Size(40)
	frame:Point("CENTER", E.UIParent, "CENTER", 0, 200)
	frame:Hide()

	frame.iconFrame = CreateFrame("Frame", nil, frame)
	frame.iconFrame:SetTemplate()
	WS:CreateShadow(frame.iconFrame)
	frame.iconFrame:SetAllPoints()
	frame.icon = frame.iconFrame:CreateTexture(nil, "ARTWORK")
	frame.icon:SetInside()
	frame.icon:SetTexCoord(unpack(E.TexCoords))
	frame.icon:SetTexture(C_Spell.GetSpellTexture(BREZ_SPELL_ID) or 136080)

	local cooldown = CreateFrame("Cooldown", nil, frame, "CooldownFrameTemplate")
	cooldown:SetDrawEdge(false)
	cooldown:SetDrawBling(false)
	cooldown:SetHideCountdownNumbers(false)
	cooldown:SetCountdownFont("MER_BattleResTimeFont")
	cooldown:SetFrameLevel(frame.iconFrame:GetFrameLevel() + 2)
	cooldown.noCooldownCount = true -- OmniCC
	cooldown.noOCC = true
	cooldown:SetMinimumCountdownDuration(0)
	cooldown:SetCountdownMillisecondsThreshold(0)
	-- "4:14" instead of "5m" for anything below an hour
	cooldown:SetCountdownAbbrevThreshold(3600)
	frame.cooldown = cooldown
	frame.timeText = cooldown:GetCountdownFontString()

	-- Charges sit above the swipe
	frame.overlay = CreateFrame("Frame", nil, frame)
	frame.overlay:SetAllPoints()
	frame.overlay:SetFrameLevel(cooldown:GetFrameLevel() + 1)
	frame.count = frame.overlay:CreateFontString(nil, "OVERLAY")
	frame.separator = frame.overlay:CreateFontString(nil, "OVERLAY")

	self.frame = frame

	E:CreateMover(
		frame,
		"MER_BattleResMover",
		MER.Title .. L["Battle Res"],
		nil,
		nil,
		nil,
		"ALL,PARTY,RAID,MERATHILISUI",
		function()
			return not (module.db and module.db.enable)
		end,
		"mui,modules,battleRes"
	)
end

function module:UpdateLayout()
	local frame = self.frame
	if not frame then
		return
	end

	local db = self.db
	local isText = db.displayMode == "TEXT"
	self.isText = isText

	SetFont(frame.count, db.countFont)
	frame.count:SetTextColor(db.countColor.r, db.countColor.g, db.countColor.b)
	SetFont(frame.separator, db.countFont)
	SetFont(timeFont, db.timeFont)
	if frame.timeText then
		frame.timeText:SetFontObject(timeFont)
		frame.timeText:SetTextColor(db.timeColor.r, db.timeColor.g, db.timeColor.b)
	end

	frame.iconFrame:SetShown(not isText)
	frame.separator:SetShown(isText)
	frame.cooldown:SetDrawSwipe(not isText)
	frame.cooldown:ClearAllPoints()
	frame.count:ClearAllPoints()
	frame.separator:ClearAllPoints()
	if frame.timeText then
		frame.timeText:ClearAllPoints()
	end

	if isText then
		-- "2 | 4:14": both parts get a fixed width, so the line does not jump
		-- while the timer counts down and the charges can stay secret.
		local countWidth = ceil(db.countFont.size * 0.8)
		local timeWidth = ceil(db.timeFont.size * 2.6)
		frame.separator:SetText("|cffa6a6a6|||r")
		local gap = max(3, ceil(db.countFont.size * 0.3))
		local sepWidth = ceil(frame.separator:GetStringWidth())

		frame:Size(countWidth + sepWidth + timeWidth + gap * 2 + 4, max(db.countFont.size, db.timeFont.size) + 6)

		frame.count:SetJustifyH("RIGHT")
		frame.count:SetWidth(countWidth)
		frame.count:Point("LEFT", frame, "LEFT", 2, 0)
		frame.separator:Point("LEFT", frame.count, "RIGHT", gap, 0)
		frame.cooldown:SetAllPoints()
		if frame.timeText then
			frame.timeText:SetJustifyH("LEFT")
			frame.timeText:Point("LEFT", frame.separator, "RIGHT", gap, 0)
		end
	else
		frame:Size(db.iconSize)
		frame.cooldown:SetInside(frame.iconFrame)

		frame.count:SetJustifyH("RIGHT")
		frame.count:SetWidth(0)
		frame.count:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
		if frame.timeText then
			frame.timeText:SetJustifyH("CENTER")
			frame.timeText:Point("CENTER", frame, "CENTER", 0, 0)
		end
	end

	-- Force the next poll to repaint with the new colors
	self.lastCount = nil
	self.lastZero = nil
	self.lastStart = nil
	self.lastDuration = nil
end

-------------------------------------------------------------------------------
--  Display
-------------------------------------------------------------------------------
function module:SetCount(charges)
	local frame = self.frame

	-- A secret count can still be displayed, it just can not be compared.
	if IsSecret(charges) then
		frame.count:SetText(charges)
		self.lastCount = nil
		return
	end

	if charges ~= self.lastCount then
		frame.count:SetText(charges and tostring(charges) or "")
		self.lastCount = charges
	end

	local isZero = charges == 0
	if isZero ~= self.lastZero then
		self.lastZero = isZero
		local color = self.db.countColor
		if isZero then
			frame.count:SetTextColor(1, 0.2, 0.2)
		else
			frame.count:SetTextColor(color.r, color.g, color.b)
		end
		frame.icon:SetDesaturated(isZero and self.db.desaturate)
	end
end

function module:SetRecharge(start, duration)
	if start == self.lastStart and duration == self.lastDuration then
		return
	end

	self.lastStart, self.lastDuration = start, duration
	local active = start and duration and duration > 0
	if active then
		self.frame.cooldown:SetCooldown(start, duration)
	else
		self.frame.cooldown:Clear()
	end
	-- Just "2" instead of "2 |" while the pool is full
	self.frame.separator:SetShown(self.isText and active)
end

function module:Poll()
	if not self.frame then
		return
	end

	if self.testMode then
		local now = GetTime()
		if not self.testStart or now - self.testStart >= TEST_RECHARGE then
			self.testStart = now
		end
		self:SetCount(2)
		self:SetRecharge(self.testStart, TEST_RECHARGE)
		return
	end

	local info = C_Spell.GetSpellCharges(BREZ_SPELL_ID)
	self:DebugPoll(info)
	if not info then
		self:SetCount(nil)
		self:SetRecharge(nil)
		return
	end

	self:SetCount(info.currentCharges)

	if IsSecret(info.cooldownStartTime) or IsSecret(info.cooldownDuration) then
		-- Let the engine feed the swipe and the timer
		local duration = C_Spell.GetSpellChargeDuration(BREZ_SPELL_ID)
		self.lastStart, self.lastDuration = nil, nil
		self.frame.separator:SetShown(self.isText)
		if duration then
			self.frame.cooldown:SetCooldownFromDurationObject(duration)
		else
			self.frame.cooldown:Clear()
		end
		return
	end

	local recharging = not IsSecret(info.currentCharges) and info.currentCharges < info.maxCharges
	self:SetRecharge(recharging and info.cooldownStartTime, info.cooldownDuration)
end

-------------------------------------------------------------------------------
--  Debug
--  Shows the tracker everywhere with the real pool data and prints every change
--  of the pool and of the visibility state to the chat.
-------------------------------------------------------------------------------
function module:IsDebug()
	return self.db and self.db.debug
end

function module:DebugPrint(...)
	if self:IsDebug() then
		F.Print("|cff00c0fa[Battle Res]|r", ...)
	end
end

-- Only prints when something besides the running timer changed.
function module:DebugPoll(info)
	if not self:IsDebug() then
		return
	end

	local line
	if not info then
		line = "GetSpellCharges: nil (no shared pool active)"
	else
		line = format(
			"charges %s/%s, cooldownStart %s, cooldownDuration %s",
			Describe(info.currentCharges),
			Describe(info.maxCharges),
			Describe(info.cooldownStartTime),
			Describe(info.cooldownDuration)
		)
	end

	if line ~= self.lastDebugLine then
		self.lastDebugLine = line
		self:DebugPrint(line)
	end
end

function module:DebugState(reason)
	if not self:IsDebug() then
		return
	end

	local _, instanceType, difficultyID = GetInstanceInfo()
	self:DebugPrint(
		format(
			"%s: instance %s (difficulty %s), keystone %s, raid encounter %s, shown %s",
			reason,
			tostring(instanceType),
			tostring(difficultyID),
			tostring(self.inKeystone),
			tostring(self.inRaidEncounter),
			tostring(self.frame and self.frame:IsShown())
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

function module:ShouldShow()
	local db = self.db
	if not db or not db.enable then
		return false
	end

	if self.testMode or db.debug then
		return true
	end

	-- Hard gate, so a stuck state can never leave the icon up in the open world
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
	local frame = self.frame
	if not frame then
		return
	end

	if self:ShouldShow() then
		frame:Show()
		if not self.ticker then
			self.ticker = C_Timer.NewTicker(POLL_INTERVAL, function()
				self:Poll()
			end)
		end
		self:Poll()
	else
		frame:Hide()
		if self.ticker then
			self.ticker:Cancel()
			self.ticker = nil
		end
	end

	if reason then
		self:DebugState(reason)
	end
end

-------------------------------------------------------------------------------
--  Test mode
-------------------------------------------------------------------------------
function module:ToggleTestMode()
	self.testMode = not self.testMode
	self.testStart = nil
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

	-- Drop the sample values, so they never show up as real pool data
	self.lastStart, self.lastDuration = nil, nil
	if self.frame then
		self.frame.cooldown:Clear()
	end

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
function module:EnableTracker()
	self:CreateFrames()
	E:EnableMover("MER_BattleResMover")

	for _, event in ipairs(EVENTS) do
		self:RegisterEvent(event)
	end

	self:RefreshInstanceState()
	self:UpdateLayout()
	-- Print the current pool again, e.g. right after the debug mode was turned on
	self.lastDebugLine = nil
	self:UpdateVisibility("Settings")
end

function module:DisableTracker()
	self:UnregisterAllEvents()
	if self.testMode then
		self:ToggleTestMode()
	end

	if self.frame then
		E:DisableMover("MER_BattleResMover")
		self:UpdateVisibility()
	end
end

-- Called by the options after any setting changed.
function module:SettingsUpdate()
	if not self.db then
		return
	end

	if self.db.enable then
		self:EnableTracker()
	else
		self:DisableTracker()
	end
end

function module:Initialize()
	self.db = E.db.mui.battleRes

	if self.db.enable then
		self:EnableTracker()
	end
end

function module:ProfileUpdate()
	self.db = E.db.mui.battleRes
	self:SettingsUpdate()
end

MER:RegisterModule(module:GetName())
