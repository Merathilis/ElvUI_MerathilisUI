local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Tracker")

local format, max, ceil, tostring = format, math.max, math.ceil, tostring

local C_Spell = C_Spell
local C_Timer = C_Timer
local CreateFont = CreateFont
local CreateFrame = CreateFrame
local GetTime = GetTime

-- Rebirth: inside a raid encounter or an active keystone every battle res of the
-- group draws from one shared pool, and this spell reports that pool.
local BREZ_SPELL_ID = 20484
local POLL_INTERVAL = 0.5
local TEST_RECHARGE = 90

local timeFont = CreateFont("MER_TrackerBattleResFont")
timeFont:SetFont(E.media.normFont, 14, "OUTLINE")

-------------------------------------------------------------------------------
--  Frames
-------------------------------------------------------------------------------
function module:CreateBattleResFrames()
	if self.battleResFrame then
		return
	end

	local frame = CreateFrame("Frame", "MER_TrackerBattleRes", E.UIParent)
	frame:Size(40)
	frame:Point("CENTER", E.UIParent, "CENTER", 0, 200)
	frame:Hide()

	frame.iconFrame = self:CreateIcon(frame)
	frame.icon = frame.iconFrame.icon
	frame.icon:SetTexture(C_Spell.GetSpellTexture(BREZ_SPELL_ID) or 136080)

	local cooldown = self:CreateCountdown(frame, "MER_TrackerBattleResFont")
	cooldown:SetFrameLevel(frame.iconFrame:GetFrameLevel() + 2)
	frame.cooldown = cooldown
	frame.timeText = cooldown:GetCountdownFontString()

	-- Charges sit above the swipe
	frame.overlay = CreateFrame("Frame", nil, frame)
	frame.overlay:SetAllPoints()
	frame.overlay:SetFrameLevel(cooldown:GetFrameLevel() + 1)
	frame.count = frame.overlay:CreateFontString(nil, "OVERLAY")
	frame.separator = frame.overlay:CreateFontString(nil, "OVERLAY")

	self.battleResFrame = frame
	self:CreateTrackerMover(frame, "MER_TrackerBattleResMover", L["Battle Res"], "battleRes")
end

function module:UpdateBattleResLayout()
	local frame = self.battleResFrame
	if not frame then
		return
	end

	local db = self.db.battleRes
	local isText = db.displayMode == "TEXT"
	self.battleResIsText = isText

	self.SetFont(frame.count, db.countFont)
	frame.count:SetTextColor(db.countColor.r, db.countColor.g, db.countColor.b)
	self.SetFont(frame.separator, db.countFont)
	self.SetFont(timeFont, db.timeFont)
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
function module:SetBattleResCount(charges)
	local frame = self.battleResFrame

	-- A secret count can still be displayed, it just can not be compared.
	if self.IsSecret(charges) then
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
		local db = self.db.battleRes
		if isZero then
			frame.count:SetTextColor(1, 0.2, 0.2)
		else
			frame.count:SetTextColor(db.countColor.r, db.countColor.g, db.countColor.b)
		end
		frame.icon:SetDesaturated(isZero and db.desaturate)
	end
end

function module:SetBattleResRecharge(start, duration)
	if start == self.lastStart and duration == self.lastDuration then
		return
	end

	self.lastStart, self.lastDuration = start, duration
	local frame = self.battleResFrame
	local active = start and duration and duration > 0
	if active then
		frame.cooldown:SetCooldown(start, duration)
	else
		frame.cooldown:Clear()
	end
	-- Just "2" instead of "2 |" while the pool is full
	frame.separator:SetShown(self.battleResIsText and active)
end

function module:PollBattleRes()
	local frame = self.battleResFrame
	if not frame then
		return
	end

	if self.testMode then
		local now = GetTime()
		if not self.testStart or now - self.testStart >= TEST_RECHARGE then
			self.testStart = now
		end
		self:SetBattleResCount(2)
		self:SetBattleResRecharge(self.testStart, TEST_RECHARGE)
		return
	end

	local info = C_Spell.GetSpellCharges(BREZ_SPELL_ID)
	self:DebugBattleRes(info)
	if not info then
		self:SetBattleResCount(nil)
		self:SetBattleResRecharge(nil)
		return
	end

	self:SetBattleResCount(info.currentCharges)

	if self.IsSecret(info.cooldownStartTime) or self.IsSecret(info.cooldownDuration) then
		-- Let the engine feed the swipe and the timer
		local duration = C_Spell.GetSpellChargeDuration(BREZ_SPELL_ID)
		self.lastStart, self.lastDuration = nil, nil
		frame.separator:SetShown(self.battleResIsText)
		if duration then
			frame.cooldown:SetCooldownFromDurationObject(duration)
		else
			frame.cooldown:Clear()
		end
		return
	end

	local recharging = not self.IsSecret(info.currentCharges) and info.currentCharges < info.maxCharges
	self:SetBattleResRecharge(recharging and info.cooldownStartTime, info.cooldownDuration)
end

function module:UpdateBattleRes()
	local frame = self.battleResFrame
	if not frame then
		return
	end

	if self:ShouldShowTracker(self.db.battleRes) then
		frame:Show()
		if not self.battleResTicker then
			self.battleResTicker = C_Timer.NewTicker(POLL_INTERVAL, function()
				self:PollBattleRes()
			end)
		end
		self:PollBattleRes()
	else
		frame:Hide()
		if self.battleResTicker then
			self.battleResTicker:Cancel()
			self.battleResTicker = nil
		end
	end
end

-- Drop the sample values, so they never show up as real pool data
function module:ResetBattleResTest()
	self.testStart = nil
	self.lastStart, self.lastDuration = nil, nil
	if self.battleResFrame then
		self.battleResFrame.cooldown:Clear()
	end
end

-- Only prints when something besides the running timer changed.
function module:DebugBattleRes(info)
	if not self:IsDebug() then
		return
	end

	local line
	if not info then
		line = "Battle Res: GetSpellCharges nil (no shared pool active)"
	else
		line = format(
			"Battle Res: charges %s/%s, cooldownStart %s, cooldownDuration %s",
			self.Describe(info.currentCharges),
			self.Describe(info.maxCharges),
			self.Describe(info.cooldownStartTime),
			self.Describe(info.cooldownDuration)
		)
	end

	if line ~= self.lastDebugLine then
		self.lastDebugLine = line
		self:DebugPrint(line)
	end
end
