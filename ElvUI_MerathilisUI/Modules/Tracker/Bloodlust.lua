local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Tracker")

local format, ipairs, pcall, tostring = format, ipairs, pcall, tostring

local C_Spell = C_Spell
local C_Timer = C_Timer
local C_UnitAuras = C_UnitAuras
local CreateFont = CreateFont
local CreateFrame = CreateFrame
local GetTime = GetTime
local IsPlayerSpell = IsPlayerSpell
local UnitFactionGroup = UnitFactionGroup

-- Castable lusts, the first one the character knows supplies the icon
local LUST_SPELLS = {
	2825, -- Bloodlust
	32182, -- Heroism
	80353, -- Time Warp
	390386, -- Fury of the Aspects
	272678, -- Primal Rage
}

-- Lockout debuffs of every lust variant
local SATED_DEBUFFS = {
	57723, -- Exhaustion (Heroism)
	57724, -- Sated (Bloodlust)
	80354, -- Temporal Displacement (Time Warp)
	95809, -- Insanity (Ancient Hysteria)
	160455, -- Fatigued (Netherwinds)
	264689, -- Fatigued (Primal Rage)
	390435, -- Exhaustion (Fury of the Aspects)
}

local LOCKOUT_DURATION = 600
local BUFF_DURATION = 40
-- Auras are resent after a loading screen, a lockout found in that window is an
-- old one and must not be mistaken for a fresh lust.
local ZONE_GUARD = 1.5

local lustFont = CreateFont("MER_TrackerBloodlustFont")
lustFont:SetFont(E.media.normFont, 14, "OUTLINE")

-------------------------------------------------------------------------------
--  Helpers
-------------------------------------------------------------------------------
function module:GetLustIcon()
	if self.lustIcon then
		return self.lustIcon
	end

	for _, spellID in ipairs(LUST_SPELLS) do
		if IsPlayerSpell(spellID) then
			self.lustIcon = C_Spell.GetSpellTexture(spellID)
			if self.lustIcon then
				return self.lustIcon
			end
		end
	end

	-- Everyone else gets the faction lust
	self.lustIcon = UnitFactionGroup("player") == "Alliance" and 132313 or 136012
	return self.lustIcon
end

-- GetPlayerAuraBySpellID only answers for auras that are not secret, the lockout
-- debuffs are not. Their fields can still be secret while auras are restricted.
local function FindSated()
	for _, spellID in ipairs(SATED_DEBUFFS) do
		local aura = C_UnitAuras.GetPlayerAuraBySpellID(spellID)
		if aura then
			return aura, spellID
		end
	end
end

local function Readable(value)
	return value ~= nil and not module.IsSecret(value)
end

-------------------------------------------------------------------------------
--  Frames
-------------------------------------------------------------------------------
function module:CreateBloodlustFrames()
	if self.bloodlustFrame then
		return
	end

	local frame = CreateFrame("Frame", "MER_TrackerBloodlust", E.UIParent)
	frame:Size(40)
	frame:Point("CENTER", E.UIParent, "CENTER", -46, 200)
	frame:Hide()

	frame.iconFrame = self:CreateIcon(frame)
	frame.icon = frame.iconFrame.icon

	frame.cooldown = self:CreateCountdown(frame, "MER_TrackerBloodlustFont")
	frame.cooldown:SetInside(frame.iconFrame)
	frame.cooldown:SetFrameLevel(frame.iconFrame:GetFrameLevel() + 2)

	frame.overlay = CreateFrame("Frame", nil, frame)
	frame.overlay:SetAllPoints()
	frame.overlay:SetFrameLevel(frame.cooldown:GetFrameLevel() + 1)
	frame.readyText = frame.overlay:CreateFontString(nil, "OVERLAY")
	frame.readyText:Point("CENTER")
	frame.readyText:Hide()

	-- The active lust: covers the lockout icon for the length of the buff
	local buff = CreateFrame("Frame", nil, frame)
	buff:SetAllPoints()
	buff:SetFrameLevel(frame.overlay:GetFrameLevel() + 2)
	buff:Hide()
	buff.iconFrame = self:CreateIcon(buff)
	buff.cooldown = self:CreateCountdown(buff, "MER_TrackerBloodlustFont")
	buff.cooldown:SetInside(buff.iconFrame)
	buff.cooldown:SetFrameLevel(buff.iconFrame:GetFrameLevel() + 2)
	-- Starts bright and darkens while the buff runs out
	buff.cooldown:SetReverse(true)
	frame.buff = buff

	self.bloodlustFrame = frame

	-- UNIT_AURA filtered to the player, AceEvent can not do that
	self.auraWatcher = CreateFrame("Frame")
	self.auraWatcher:SetScript("OnEvent", function(_, _, _, updateInfo)
		self:OnPlayerAura(updateInfo)
	end)

	self:CreateTrackerMover(frame, "MER_TrackerBloodlustMover", L["Bloodlust"], "bloodlust")
end

function module:UpdateBloodlustLayout()
	local frame = self.bloodlustFrame
	if not frame then
		return
	end

	local db = self.db.bloodlust
	frame:Size(db.iconSize)
	self.SetFont(lustFont, db.font)
	self.SetFont(frame.readyText, db.font)
	frame.readyText:SetTextColor(db.color.r, db.color.g, db.color.b)
	for _, cooldown in ipairs({ frame.cooldown, frame.buff.cooldown }) do
		local text = cooldown:GetCountdownFontString()
		if text then
			text:SetFontObject(lustFont)
			text:SetTextColor(db.color.r, db.color.g, db.color.b)
		end
	end

	-- Render the current state again with the new settings
	self.bloodlustState = nil
end

-------------------------------------------------------------------------------
--  Lockout detection
-------------------------------------------------------------------------------
function module:RefreshSated()
	local aura, spellID = FindSated()
	local changed = (aura ~= nil) ~= (self.satedAura ~= nil) or spellID ~= self.satedSpell
	-- Same lockout, readable id: nothing to re-apply. A secret id says nothing,
	-- so the running swipe is kept as it is.
	if not changed and aura and Readable(aura.auraInstanceID) then
		changed = aura.auraInstanceID ~= self.satedInstanceID
	end

	self.satedAura, self.satedSpell = aura, spellID
	self.satedInstanceID = aura and Readable(aura.auraInstanceID) and aura.auraInstanceID or nil

	if aura then
		-- Every lockout lasts ten minutes, keep the expiry for the times it is secret
		local expiration = aura.expirationTime
		if Readable(expiration) and expiration > 0 then
			self.satedExpiry = expiration
		end
	else
		self.satedExpiry = nil
	end

	if changed then
		self.bloodlustState = nil
		self:DebugSated()
	end
end

function module:OnPlayerAura(updateInfo)
	local wasSated = self.satedAura ~= nil
	self:RefreshSated()

	-- A secret payload counts as an incremental update: full updates only come
	-- with a loading screen, which the zone guard covers.
	local isFullUpdate = false
	if Readable(updateInfo) and Readable(updateInfo.isFullUpdate) then
		isFullUpdate = updateInfo.isFullUpdate
	end

	if self.satedAura and not wasSated and not isFullUpdate and GetTime() >= (self.lustZoneGuard or 0) then
		-- A fresh lockout means somebody just cast a lust
		self.satedExpiry = GetTime() + LOCKOUT_DURATION
		self.bloodlustState = nil
		self:ShowLustBuff()
	end

	self:UpdateBloodlust()
end

function module:ResetBloodlustOnZone()
	if not self.bloodlustFrame then
		return
	end

	self.lustIcon = nil
	self.lustZoneGuard = GetTime() + ZONE_GUARD
	self:RefreshSated()
end

function module:ApplySatedCooldown(aura)
	local cooldown = self.bloodlustFrame.cooldown

	local expiration, duration = aura.expirationTime, aura.duration
	if Readable(expiration) and Readable(duration) and duration > 0 then
		cooldown:SetCooldown(expiration - duration, duration)
		return
	end

	-- Aura durations can error out while auras are restricted
	local instanceID = aura.auraInstanceID
	if Readable(instanceID) then
		local ok, durationObject = pcall(C_UnitAuras.GetAuraDuration, "player", instanceID)
		if ok and durationObject then
			cooldown:SetCooldownFromDurationObject(durationObject)
			return
		end
	end

	if self.satedExpiry and self.satedExpiry > GetTime() then
		cooldown:SetCooldown(self.satedExpiry - LOCKOUT_DURATION, LOCKOUT_DURATION)
	else
		cooldown:Clear()
	end
end

-------------------------------------------------------------------------------
--  Active lust
-------------------------------------------------------------------------------
function module:ShowLustBuff()
	local buff = self.bloodlustFrame.buff
	buff.iconFrame.icon:SetTexture(self:GetLustIcon())
	buff.cooldown:SetCooldown(GetTime(), BUFF_DURATION)
	buff:Show()

	if self.lustBuffTimer then
		self.lustBuffTimer:Cancel()
	end
	self.lustBuffTimer = C_Timer.NewTimer(BUFF_DURATION, function()
		self.lustBuffTimer = nil
		self:HideLustBuff()
		self:UpdateBloodlust()
	end)
end

function module:HideLustBuff()
	if self.lustBuffTimer then
		self.lustBuffTimer:Cancel()
		self.lustBuffTimer = nil
	end

	if self.bloodlustFrame then
		self.bloodlustFrame.buff.cooldown:Clear()
		self.bloodlustFrame.buff:Hide()
	end
end

function module:PLAYER_DEAD()
	-- Buffs drop on death
	self:HideLustBuff()
	self:UpdateBloodlust()
end

function module:PLAYER_SPECIALIZATION_CHANGED()
	-- A spec swap can add or remove the character's own lust
	self.lustIcon = nil
	self.bloodlustState = nil
	self:UpdateBloodlust()
end

-------------------------------------------------------------------------------
--  Display
-------------------------------------------------------------------------------
function module:ShouldShowBloodlust()
	local db = self.db.bloodlust
	if not (self.testMode or self.db.debug) then
		if self.satedAura then
			-- The active lust is worth seeing even with the lockout itself hidden
			if not db.showSated and not self.bloodlustFrame.buff:IsShown() then
				return false
			end
		elseif not db.showReady then
			return false
		end
	end

	return self:ShouldShowTracker(db)
end

function module:RenderBloodlust(state)
	local frame = self.bloodlustFrame
	local db = self.db.bloodlust

	if state == "SATED" then
		frame.icon:SetTexture(C_Spell.GetSpellTexture(self.satedSpell) or self:GetLustIcon())
		self:ApplySatedCooldown(self.satedAura)
	elseif state == "TEST" then
		frame.icon:SetTexture(self:GetLustIcon())
		frame.cooldown:SetCooldown(GetTime(), LOCKOUT_DURATION)
	else
		frame.icon:SetTexture(self:GetLustIcon())
		frame.cooldown:Clear()
	end

	local isReady = state == "READY"
	frame.readyText:SetText(L["Ready"])
	frame.readyText:SetShown(isReady)
	frame.icon:SetDesaturated(not isReady and db.desaturate)
end

function module:UpdateBloodlust()
	local frame = self.bloodlustFrame
	if not frame then
		return
	end

	if not self:ShouldShowBloodlust() then
		frame:Hide()
		self.bloodlustState = nil
		return
	end

	frame:Show()
	local state = self.testMode and "TEST" or self.satedAura and "SATED" or "READY"
	if state ~= self.bloodlustState then
		self.bloodlustState = state
		self:RenderBloodlust(state)
	end
end

function module:DebugSated()
	local aura = self.satedAura
	if not aura then
		self:DebugPrint("Sated: none")
		return
	end

	self:DebugPrint(
		format(
			"Sated: spell %s, expirationTime %s, duration %s, auraInstanceID %s",
			tostring(self.satedSpell),
			self.Describe(aura.expirationTime),
			self.Describe(aura.duration),
			self.Describe(aura.auraInstanceID)
		)
	)
end

-------------------------------------------------------------------------------
--  Lifecycle
-------------------------------------------------------------------------------
function module:EnableBloodlust()
	if not self.db.bloodlust.enable then
		self:DisableBloodlust()
		return
	end

	self.auraWatcher:RegisterUnitEvent("UNIT_AURA", "player")
	self:RegisterEvent("PLAYER_DEAD")
	self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")

	-- A lockout that is already there when the tracker starts is no fresh lust
	self:RefreshSated()
end

function module:DisableBloodlust()
	if self.auraWatcher then
		self.auraWatcher:UnregisterAllEvents()
	end
	self:UnregisterEvent("PLAYER_DEAD")
	self:UnregisterEvent("PLAYER_SPECIALIZATION_CHANGED")

	self:HideLustBuff()
	self.satedAura, self.satedSpell, self.satedInstanceID, self.satedExpiry = nil, nil, nil, nil
	self.bloodlustState = nil
end
