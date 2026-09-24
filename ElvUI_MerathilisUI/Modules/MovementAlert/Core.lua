local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_MovementAlert")
local WS = W:GetModule("Skins")
local LSM = E.Libs.LSM

local _G = _G
local pairs, ipairs, next, type, unpack = pairs, ipairs, next, type, unpack
local floor, max = math.floor, math.max
local format, gsub, wipe = format, gsub, wipe

local CreateFont = CreateFont
local CreateFrame = CreateFrame
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local GetSpellBaseCooldown = GetSpellBaseCooldown
local GetTime = GetTime
local InCombatLockdown = InCombatLockdown
local IsPlayerSpell = IsPlayerSpell
local PlaySoundFile = PlaySoundFile
local UnitAffectingCombat = UnitAffectingCombat

local C_Item_GetItemCount = C_Item.GetItemCount
local C_Item_IsUsableItem = C_Item.IsUsableItem
local C_Spell = C_Spell
local C_SpellBook = C_SpellBook
local C_VoiceChat = C_VoiceChat

-------------------------------------------------------------------------------
--  Spell data
--  Mobility spells per class and specialization. Spells listed in DEFAULT_OFF
--  are tracked only after they have been checked in the options.
-------------------------------------------------------------------------------
local MOVEMENT_SPELLS = {
	DEATHKNIGHT = {
		[250] = { 48265, 212552 },
		[251] = { 48265, 212552 },
		[252] = { 48265, 444010, 444347, 212552 },
	},
	DEMONHUNTER = {
		[577] = { 195072 },
		[581] = { 189110 },
		[1480] = { 1234796 },
	},
	DRUID = {
		[102] = { 102401, 252216, 1850, 102417 },
		[103] = { 102401, 252216, 1850, 102417 },
		[104] = { 102401, 252216, 106898, 1850, 102417 },
		[105] = { 102401, 252216, 1850, 102417 },
	},
	EVOKER = {
		[1467] = { 358267 },
		[1468] = { 358267 },
		[1473] = { 358267 },
	},
	HUNTER = {
		[253] = { 186257, 781 },
		[254] = { 186257, 781 },
		[255] = { 186257, 781 },
	},
	MAGE = {
		[62] = { 212653, 1953 },
		[63] = { 212653, 1953 },
		[64] = { 212653, 1953 },
	},
	MONK = {
		[268] = { 115008, 109132, 119085, 361138 },
		[269] = { 109132, 119085, 361138, 101545 },
		[270] = { 109132, 119085, 361138 },
	},
	PALADIN = {
		[65] = { 190784 },
		[66] = { 190784 },
		[70] = { 190784 },
	},
	PRIEST = {
		[256] = { 121536, 73325 },
		[257] = { 121536, 73325 },
		[258] = { 121536, 73325 },
	},
	ROGUE = {
		[259] = { 36554, 2983 },
		[260] = { 195457, 2983 },
		[261] = { 36554, 2983 },
	},
	SHAMAN = {
		[262] = { 79206, 90328, 192063, 58875 },
		[263] = { 90328, 192063, 58875 },
		[264] = { 79206, 90328, 192063, 58875 },
	},
	WARLOCK = {
		[265] = { 48020 },
		[266] = { 48020 },
		[267] = { 48020 },
	},
	WARRIOR = {
		[71] = { 6544 },
		[72] = { 6544 },
		[73] = { 6544 },
	},
}

local DEFAULT_OFF = {
	[2983] = true, -- Sprint
	[73325] = true, -- Leap of Faith
	[106898] = true, -- Stampeding Roar
	[1850] = true, -- Dash
	[252216] = true, -- Tiger Dash
	[212552] = true, -- Wraith Walk
	[79206] = true, -- Spiritwalker's Grace
	[58875] = true, -- Spirit Walk
	[90328] = true, -- Spirit Walk (pet)
}

-- Talents whose own casts light up a movement spell with the same overlay glow
-- Time Spiral uses: [talent] = { spells whose cast should not count as a proc }
local TIME_SPIRAL_CAST_FILTERS = {
	DEMONHUNTER = {
		[427640] = { 198793, 370965, 195072 },
		[427794] = { 195072 },
	},
	WARLOCK = {
		[385899] = { 385899 },
	},
}

local GATEWAY_SHARD_ITEM = 188152
local TIME_SPIRAL_DURATION = 10

-- Anything up to this length is the global cooldown, not the spell's own.
local GCD_THRESHOLD = 1.5
-- Casting some abilities briefly locks out their siblings (Skull Bash does it to
-- Wild Charge). Those windows report through the regular cooldown fields, so
-- anything shorter than this on a spell with a longer base cooldown is ignored.
local LOCKOUT_THRESHOLD = 3

module.MOVEMENT_SPELLS = MOVEMENT_SPELLS
module.DEFAULT_OFF = DEFAULT_OFF

-------------------------------------------------------------------------------
--  Helpers
-------------------------------------------------------------------------------
local function IsSecret(value)
	return E:IsSecretValue(value)
end

local function IsKnown(spellID)
	return (IsPlayerSpell and IsPlayerSpell(spellID))
		or (C_SpellBook and C_SpellBook.IsSpellKnown and C_SpellBook.IsSpellKnown(spellID))
end

local function GetSpecID()
	local spec = GetSpecialization and GetSpecialization()
	return spec and GetSpecializationInfo(spec) or nil
end

local function GetOverrideSpell(spellID)
	if C_Spell.GetOverrideSpell then
		local ok, overrideID = pcall(C_Spell.GetOverrideSpell, spellID)
		if ok and type(overrideID) == "number" and overrideID > 0 then
			return overrideID
		end
	end

	return spellID
end

local function GetColor(db)
	if db.useClassColor then
		local color = E:ClassColor(E.myclass, true)
		return color.r, color.g, color.b
	end

	return db.color.r, db.color.g, db.color.b
end

local function SetFont(object, db)
	local style = db.style or "OUTLINE"
	local shadow = style:find("SHADOW") ~= nil
	style = gsub(style, "SHADOW", "")
	if style == "NONE" then
		style = ""
	end

	object:SetFont(F.GetFontPath(db.name), db.size or 20, style)
	if shadow then
		object:SetShadowColor(0, 0, 0, 1)
		object:SetShadowOffset(1, -1)
	else
		object:SetShadowOffset(0, 0)
	end
end

-- Engine-side comparison for secret durations: a step curve maps a total
-- duration below the threshold to 0 and anything above to 1. Evaluated by the
-- duration object itself, so the result may be secret and is only ever fed to
-- SetAlpha, never compared in Lua.
local stepCurves = {}
local function GetStepCurve(threshold)
	if stepCurves[threshold] == nil then
		if C_CurveUtil and C_CurveUtil.CreateCurve and Enum.LuaCurveType then
			local curve = C_CurveUtil.CreateCurve()
			curve:SetType(Enum.LuaCurveType.Step)
			curve:AddPoint(0, 0)
			curve:AddPoint(threshold, 1)
			stepCurves[threshold] = curve
		else
			stepCurves[threshold] = false
		end
	end

	return stepCurves[threshold] or nil
end

local function EvaluateVisibility(durationObject, threshold)
	local curve = GetStepCurve(threshold)
	if not curve or not durationObject or not durationObject.EvaluateTotalDuration then
		return 1
	end

	return durationObject:EvaluateTotalDuration(curve, 1) or 1
end

-------------------------------------------------------------------------------
--  Sound & text to speech
-------------------------------------------------------------------------------
local function Speak(text)
	if not text or text == "" then
		return
	end

	-- Prefer Blizzard's own wrapper: it uses the voice, speed and volume from the
	-- game's Text to Speech settings and keeps up with API changes.
	local voiceType = Enum.TtsVoiceType and Enum.TtsVoiceType.Standard or 0
	local voice = _G.TextToSpeech_GetSelectedVoice and _G.TextToSpeech_GetSelectedVoice(voiceType)
	if _G.TextToSpeech_Speak and voice then
		pcall(_G.TextToSpeech_Speak, text, voice)
		return
	end

	if C_VoiceChat and C_VoiceChat.SpeakText then
		local voices = C_VoiceChat.GetTtsVoices and C_VoiceChat.GetTtsVoices()
		local voiceID = voices and voices[1] and voices[1].voiceID or 0
		pcall(C_VoiceChat.SpeakText, voiceID, text, 1, 100, true)
	end
end

local function PlayAlert(db, text)
	if not db then
		return
	end

	if db.tts then
		Speak(text)
	elseif db.sound and db.sound ~= "None" then
		local file = LSM:Fetch("sound", db.sound, true)
		if file then
			PlaySoundFile(file, "Master")
		end
	end
end

-------------------------------------------------------------------------------
--  Tracked spells
-------------------------------------------------------------------------------
local trackedSpells = {}

function module:IsSpellEnabled(spellID)
	local saved = self.db and self.db.spells[spellID]
	if saved == nil then
		return not DEFAULT_OFF[spellID]
	end

	return saved
end

function module:GetCustomSpells()
	local custom = self.db.customSpells
	custom[E.myclass] = custom[E.myclass] or {}
	return custom[E.myclass]
end

local function AddTrackedSpell(spellID, seen)
	if seen[spellID] or not IsKnown(spellID) then
		return
	end

	local displayID = GetOverrideSpell(spellID)
	if seen[displayID] then
		return
	end
	seen[spellID], seen[displayID] = true, true

	local info = C_Spell.GetSpellInfo(displayID)
	if not info then
		return
	end

	local baseCooldown = 0
	local baseMS = GetSpellBaseCooldown and GetSpellBaseCooldown(spellID)
	if type(baseMS) == "number" and not IsSecret(baseMS) then
		baseCooldown = baseMS / 1000
	end
	if baseCooldown <= 0 then
		local charges = C_Spell.GetSpellCharges(spellID)
		local recharge = charges and charges.cooldownDuration
		if type(recharge) == "number" and not IsSecret(recharge) then
			baseCooldown = recharge
		end
	end

	trackedSpells[#trackedSpells + 1] = {
		spellID = spellID,
		displayID = displayID,
		name = info.name,
		icon = info.iconID,
		baseCooldown = baseCooldown,
	}
end

function module:UpdateTrackedSpells()
	wipe(trackedSpells)
	self.readySpells = self.readySpells and wipe(self.readySpells) or {}

	local classSpells = MOVEMENT_SPELLS[E.myclass]
	local specID = GetSpecID()
	local seen = {}

	local specSpells = classSpells and specID and classSpells[specID]
	if specSpells then
		for _, spellID in ipairs(specSpells) do
			if self:IsSpellEnabled(spellID) then
				AddTrackedSpell(spellID, seen)
			end
		end
	end

	for spellID, enabled in pairs(self:GetCustomSpells()) do
		if enabled then
			AddTrackedSpell(spellID, seen)
		end
	end
end

local function IsLockout(entry, total)
	return entry.baseCooldown > LOCKOUT_THRESHOLD and total < LOCKOUT_THRESHOLD
end

-- Returns whether the spell is currently unavailable, the duration object that
-- drives the countdown and the alpha for the slot. When the cooldown values are
-- secret (restricted content), visibility is decided by the engine via the
-- alpha, so the slot is always returned as shown.
local function GetSpellState(entry)
	local spellID = entry.spellID
	local cooldown = C_Spell.GetSpellCooldown(spellID)
	if not cooldown then
		return false
	end

	local onGCD = cooldown.isOnGCD
	if not IsSecret(onGCD) and onGCD == true then
		return false
	end

	local charges = C_Spell.GetSpellCharges(spellID)
	local maxCharges = charges and charges.maxCharges
	local isCharge = type(maxCharges) == "number" and not IsSecret(maxCharges) and maxCharges > 1

	local secret = false
	if isCharge then
		local current = charges.currentCharges
		if IsSecret(current) then
			secret = true
		elseif current and current > 0 then
			return false
		end
	end

	local duration
	if isCharge and C_Spell.GetSpellChargeDuration then
		duration = C_Spell.GetSpellChargeDuration(spellID)
	elseif C_Spell.GetSpellCooldownDuration then
		duration = C_Spell.GetSpellCooldownDuration(spellID, true)
	end

	if not duration then
		local start, length = cooldown.startTime, cooldown.duration
		if IsSecret(start) or IsSecret(length) or not start or not length then
			return false
		end
		if length > GCD_THRESHOLD and not IsLockout(entry, length) and start + length > GetTime() then
			return true, nil, 1, start, length
		end

		return false
	end

	local remaining, total = duration:GetRemainingDuration(), duration:GetTotalDuration()
	if not secret and not IsSecret(remaining) and not IsSecret(total) then
		if total <= GCD_THRESHOLD or remaining <= 0 or IsLockout(entry, total) then
			return false
		end

		return true, duration, 1
	end

	if isCharge then
		-- While a charge is banked the spell itself only reports the GCD, the full
		-- recharge shows up on its cooldown once the last charge is spent.
		local spellCooldown = C_Spell.GetSpellCooldownDuration and C_Spell.GetSpellCooldownDuration(spellID)
		return true, duration, EvaluateVisibility(spellCooldown, GCD_THRESHOLD + 0.1)
	end

	local threshold = entry.baseCooldown > LOCKOUT_THRESHOLD and LOCKOUT_THRESHOLD or (GCD_THRESHOLD + 0.1)
	return true, duration, EvaluateVisibility(duration, threshold)
end

-------------------------------------------------------------------------------
--  Display
-------------------------------------------------------------------------------
local countdownFont = CreateFont("MER_MovementAlertCountdownFont")
countdownFont:SetFont(E.media.normFont, 20, "OUTLINE")

local slots = {}

local function CreateSlot(parent)
	local slot = CreateFrame("Frame", nil, parent)

	slot.text = slot:CreateFontString(nil, "OVERLAY")

	slot.iconFrame = CreateFrame("Frame", nil, slot)
	slot.iconFrame:SetTemplate()
	WS:CreateShadow(slot.iconFrame)
	slot.icon = slot.iconFrame:CreateTexture(nil, "ARTWORK")
	slot.icon:SetInside()
	slot.icon:SetTexCoord(unpack(E.TexCoords))
	slot.swipe = CreateFrame("Cooldown", nil, slot.iconFrame, "CooldownFrameTemplate")
	slot.swipe:SetInside()
	slot.swipe:SetDrawEdge(false)
	slot.swipe:SetHideCountdownNumbers(true)
	slot.swipe.noCooldownCount = true -- OmniCC
	slot.swipe.noOCC = true

	slot.bar = CreateFrame("StatusBar", nil, slot)
	slot.bar:CreateBackdrop("Transparent")
	WS:CreateShadow(slot.bar.backdrop)
	slot.bar:SetMinMaxValues(0, 1)
	slot.barIconFrame = CreateFrame("Frame", nil, slot.bar)
	slot.barIconFrame:SetTemplate()
	WS:CreateShadow(slot.barIconFrame)
	slot.barIcon = slot.barIconFrame:CreateTexture(nil, "ARTWORK")
	slot.barIcon:SetInside()
	slot.barIcon:SetTexCoord(unpack(E.TexCoords))

	-- The countdown number is always drawn by a Cooldown widget: the engine can
	-- render remaining times that are secret for Lua, and readable ones look the
	-- same that way.
	slot.countdown = CreateFrame("Cooldown", nil, slot, "CooldownFrameTemplate")
	slot.countdown:SetDrawSwipe(false)
	slot.countdown:SetDrawEdge(false)
	slot.countdown:SetDrawBling(false)
	slot.countdown:SetHideCountdownNumbers(false)
	slot.countdown:SetCountdownFont("MER_MovementAlertCountdownFont")
	slot.countdown.noCooldownCount = true
	slot.countdown.noOCC = true
	if slot.countdown.SetMinimumCountdownDuration then
		slot.countdown:SetMinimumCountdownDuration(0)
	end
	if slot.countdown.SetCountdownAbbrevThreshold then
		slot.countdown:SetCountdownAbbrevThreshold(0)
	end
	slot.countdownText = slot.countdown.GetCountdownFontString and slot.countdown:GetCountdownFontString()

	slot:Hide()
	return slot
end

local function GetSlot(index)
	slots[index] = slots[index] or CreateSlot(module.anchor)
	return slots[index]
end

local function BindTimer(cooldown, timer)
	if timer.duration and cooldown.SetCooldownFromDurationObject then
		cooldown:SetCooldownFromDurationObject(timer.duration)
	elseif timer.start then
		cooldown:SetCooldown(timer.start, timer.length)
	else
		cooldown:Clear()
		return false
	end

	return true
end

local function UpdateBarValue(slot)
	local timer = slot.timer
	if not timer or not slot.bar:IsShown() then
		return
	end

	if timer.duration then
		local duration = timer.duration
		pcall(slot.bar.SetMinMaxValues, slot.bar, 0, duration:GetTotalDuration())
		pcall(slot.bar.SetValue, slot.bar, duration:GetRemainingDuration())
	elseif timer.start then
		slot.bar:SetMinMaxValues(0, timer.length)
		slot.bar:SetValue(max(0, timer.start + timer.length - GetTime()))
	end
end

function module:StyleSlot(slot)
	if slot.styleVersion == self.styleVersion then
		return
	end
	slot.styleVersion = self.styleVersion

	local db = self.db
	local r, g, b = GetColor(db)
	local mode = db.displayMode

	SetFont(slot.text, db.font)
	slot.text:SetTextColor(r, g, b)
	countdownFont:SetTextColor(r, g, b)
	if slot.countdownText then
		slot.countdownText:SetFontObject(countdownFont)
		slot.countdownText:SetTextColor(r, g, b)
	end

	local threshold = db.decimals and 86400 or 0
	if slot.countdown.SetCountdownMillisecondsThreshold then
		slot.countdown:SetCountdownMillisecondsThreshold(threshold)
	end

	slot.iconFrame:Size(db.iconSize)
	slot.iconFrame:ClearAllPoints()
	slot.iconFrame:Point("CENTER")

	local barDB = db.bar
	local iconWidth = barDB.showIcon and (barDB.height + 4) or 0
	slot.bar:SetStatusBarTexture(LSM:Fetch("statusbar", barDB.texture))
	slot.bar:SetStatusBarColor(r, g, b)
	slot.bar:Size(barDB.width - iconWidth, barDB.height)
	slot.bar:ClearAllPoints()
	slot.bar:Point("RIGHT", slot, "RIGHT", 0, 0)
	slot.barIconFrame:Size(barDB.height)
	slot.barIconFrame:ClearAllPoints()
	slot.barIconFrame:Point("RIGHT", slot.bar, "LEFT", -4, 0)
	slot.barIconFrame:SetShown(barDB.showIcon)

	slot:SetSize(self:GetSlotSize(mode))
end

function module:GetSlotSize(mode)
	local db = self.db
	if mode == "ICON" then
		return db.iconSize, db.iconSize
	elseif mode == "BAR" then
		return db.bar.width, db.bar.height
	end

	return db.textWidth, db.font.size + 8
end

-- Label and countdown are two separate font strings, centered as one unit: the
-- label width is known, the number gets a fixed reserved width so the label does
-- not jump around while the number shrinks.
local function LayoutText(slot, format_, hasNumber)
	local db = module.db
	local size = db.font.size
	local gap = max(2, floor(size * 0.25))
	local reserved = hasNumber and size * (db.decimals and 2.4 or 1.6) or 0
	local labelWidth = slot.text:IsShown() and slot.text:GetStringWidth() or 0
	local total = labelWidth + ((labelWidth > 0 and hasNumber) and (gap + reserved) or reserved)

	slot.text:ClearAllPoints()
	slot.countdown:ClearAllPoints()
	slot.countdown:SetSize(1, 1)

	local number = slot.countdownText
	if number then
		number:ClearAllPoints()
	end

	if format_ == "TIME" or labelWidth == 0 then
		slot.countdown:SetPoint("CENTER", slot, "CENTER")
		if number then
			number:SetJustifyH("CENTER")
			number:SetPoint("CENTER", slot, "CENTER")
		end
		return
	end

	if format_ == "NAME_TIME" then
		slot.text:SetPoint("LEFT", slot, "CENTER", -total / 2, 0)
		slot.countdown:SetPoint("LEFT", slot.text, "RIGHT", gap, 0)
		if number then
			number:SetJustifyH("LEFT")
			number:SetPoint("LEFT", slot.text, "RIGHT", gap, 0)
		end
	else
		slot.text:SetPoint("RIGHT", slot, "CENTER", total / 2, 0)
		slot.countdown:SetPoint("RIGHT", slot.text, "LEFT", -gap, 0)
		if number then
			number:SetJustifyH("RIGHT")
			number:SetPoint("RIGHT", slot.text, "LEFT", -gap, 0)
		end
	end
end

local function RenderSlot(slot, entry, timer, alpha)
	local db = module.db
	local mode = db.displayMode

	module:StyleSlot(slot)
	slot.entry = entry
	slot.timer = timer
	slot.text:Hide()
	slot.iconFrame:Hide()
	slot.bar:Hide()

	local hasNumber = BindTimer(slot.countdown, timer)

	if mode == "ICON" then
		slot.icon:SetTexture(entry.icon)
		BindTimer(slot.swipe, timer)
		slot.iconFrame:Show()
		slot.countdown:SetFrameLevel(slot.iconFrame:GetFrameLevel() + 5)
		LayoutText(slot, "TIME", hasNumber)
	elseif mode == "BAR" then
		slot.barIcon:SetTexture(entry.icon)
		slot.bar:Show()
		UpdateBarValue(slot)
		slot.countdown:SetFrameLevel(slot.bar:GetFrameLevel() + 5)
		slot.countdown:ClearAllPoints()
		slot.countdown:SetSize(1, 1)
		slot.countdown:SetPoint("CENTER", slot.bar, "CENTER")
		if slot.countdownText then
			slot.countdownText:ClearAllPoints()
			slot.countdownText:SetJustifyH("CENTER")
			slot.countdownText:SetPoint("CENTER", slot.bar, "CENTER")
		end
		slot.countdown:SetShown(db.bar.showTime)
	else
		local textFormat = db.textFormat
		if textFormat ~= "TIME" then
			slot.text:SetText(format(L["No %s"], entry.name or ""))
			slot.text:Show()
		end
		slot.countdown:SetFrameLevel(slot:GetFrameLevel() + 2)
		LayoutText(slot, textFormat, hasNumber)
	end

	if mode ~= "BAR" then
		slot.countdown:SetShown(hasNumber)
	end

	slot:SetAlpha(alpha or 1)
	slot:Show()
end

-- Ticker pass for a slot that already shows this spell: the countdown keeps
-- running on its own, only the bar fill and the visibility need a refresh.
local function RefreshSlot(slot, alpha)
	UpdateBarValue(slot)
	slot:SetAlpha(alpha or 1)
end

local function HideSlot(slot)
	slot.entry = nil
	slot.timer = nil
	slot.countdown:Clear()
	slot.swipe:Clear()
	slot:Hide()
end

function module:LayoutSlots(count)
	local spacing = self.db.spacing
	local growUp = self.db.growDirection == "UP"
	for i = 1, count do
		local slot = slots[i]
		slot:ClearAllPoints()
		if i == 1 then
			slot:SetPoint(growUp and "BOTTOM" or "TOP", self.anchor, growUp and "BOTTOM" or "TOP")
		elseif growUp then
			slot:SetPoint("BOTTOM", slots[i - 1], "TOP", 0, spacing)
		else
			slot:SetPoint("TOP", slots[i - 1], "BOTTOM", 0, -spacing)
		end
	end
end

function module:HideMovementAlert()
	for _, slot in ipairs(slots) do
		HideSlot(slot)
	end
	self.shownCount = 0
	if self.anchor then
		self.anchor.elapsed = nil
		self.anchor:SetScript("OnUpdate", nil)
	end
end

local function OnUpdate(frame, elapsed)
	frame.elapsed = (frame.elapsed or 0) + elapsed
	if frame.elapsed < 0.1 then
		return
	end
	frame.elapsed = 0

	module:UpdateMovementAlert(true)
end

local shownNow = {}
function module:UpdateMovementAlert(fromTicker)
	local db = self.db
	if not self.anchor or not db or not db.enable then
		return
	end

	if self.testMode then
		return self:UpdateTestMode(fromTicker)
	end

	if (db.combatOnly and not self.inCombat) or #trackedSpells == 0 then
		self:HideMovementAlert()
		wipe(self.readySpells)
		return
	end

	wipe(shownNow)
	local count = 0
	for _, entry in ipairs(trackedSpells) do
		local unavailable, duration, alpha, start, length = GetSpellState(entry)
		if unavailable then
			count = count + 1
			local slot = GetSlot(count)
			slot.timerData = slot.timerData or {}
			local timer = slot.timerData
			timer.duration, timer.start, timer.length = duration, start, length
			if fromTicker and slot.entry == entry and slot:IsShown() then
				RefreshSlot(slot, alpha)
			else
				RenderSlot(slot, entry, timer, alpha)
			end
			-- Secret states always report as unavailable, so they can not be
			-- used to detect the moment a spell comes back.
			if alpha == 1 then
				shownNow[entry.spellID] = entry
			end
		end
	end

	for i = count + 1, #slots do
		HideSlot(slots[i])
	end

	if db.alert.enable then
		for spellID, entry in pairs(self.readySpells) do
			if not shownNow[spellID] then
				PlayAlert(db.alert, format(L["%s ready"], entry.name))
			end
		end
	end
	wipe(self.readySpells)
	for spellID, entry in pairs(shownNow) do
		self.readySpells[spellID] = entry
	end

	self.shownCount = count
	if count > 0 then
		self:LayoutSlots(count)
		self.anchor:SetScript("OnUpdate", OnUpdate)
	else
		self.anchor:SetScript("OnUpdate", nil)
	end
end

function module:RequestUpdate()
	if not self.updater then
		self.updater = CreateFrame("Frame")
		self.updater:Hide()
		self.updater:SetScript("OnUpdate", function(frame)
			frame:Hide()
			module:UpdateMovementAlert()
		end)
	end

	self.updater:Show()
end

-------------------------------------------------------------------------------
--  Test mode
-------------------------------------------------------------------------------
local TEST_LENGTH = 8

function module:UpdateTestMode(fromTicker)
	local entry = trackedSpells[1]
	if not entry then
		local spellID = 1953 -- Blink
		local info = C_Spell.GetSpellInfo(spellID)
		entry = { spellID = spellID, name = info and info.name or "Blink", icon = info and info.iconID }
	end

	local now = GetTime()
	local restart = not self.testStart or now - self.testStart >= TEST_LENGTH
	if restart then
		self.testStart = now
	end

	local slot = GetSlot(1)
	slot.timerData = slot.timerData or {}
	local timer = slot.timerData
	timer.duration, timer.start, timer.length = nil, self.testStart, TEST_LENGTH
	if fromTicker and not restart and slot:IsShown() then
		RefreshSlot(slot, 1)
	else
		RenderSlot(slot, entry, timer, 1)
	end
	for i = 2, #slots do
		HideSlot(slots[i])
	end
	self:LayoutSlots(1)
	self.anchor:SetScript("OnUpdate", OnUpdate)

	if self.db.timeSpiral.enable then
		self:ShowTimeSpiral(true)
	end
	if self.db.gateway.enable then
		self.gatewayFrame.text:SetText(self.db.gateway.text)
		self.gatewayFrame:Show()
	end
end

function module:ToggleTestMode()
	self.testMode = not self.testMode
	self.testStart = nil
	if self.testTimer then
		self.testTimer:Cancel()
		self.testTimer = nil
	end

	if self.testMode then
		self.testTimer = C_Timer.NewTimer(20, function()
			self.testTimer = nil
			if self.testMode then
				self:ToggleTestMode()
			end
		end)
	else
		self:HideMovementAlert()
		self:HideTimeSpiral()
		self.gatewayFrame:Hide()
		self.gatewayUsable = nil
		self:UpdateGateway()
	end

	self:RequestUpdate()
	E.Libs.AceConfigRegistry:NotifyChange("ElvUI")
end

-------------------------------------------------------------------------------
--  Time Spiral
-------------------------------------------------------------------------------
local castFilters = {}
local timeSpiralGlows = {}

function module:UpdateCastFilters()
	wipe(castFilters)
	local filters = TIME_SPIRAL_CAST_FILTERS[E.myclass]
	if not filters then
		return
	end

	for talentID, spells in pairs(filters) do
		if IsKnown(talentID) then
			for _, spellID in ipairs(spells) do
				castFilters[spellID] = true
			end
		end
	end
end

function module:IsTimeSpiralProc(spellID)
	local now = GetTime()
	if now < (self.glowBlockedUntil or 0) or now - (self.lastProc or 0) < 0.12 then
		return false
	end

	local classSpells = MOVEMENT_SPELLS[E.myclass]
	local specID = GetSpecID()
	local specSpells = classSpells and specID and classSpells[specID]
	if specSpells then
		for _, id in ipairs(specSpells) do
			if id == spellID or GetOverrideSpell(id) == spellID then
				return true
			end
		end
	end

	for id, enabled in pairs(self:GetCustomSpells()) do
		if enabled and (id == spellID or GetOverrideSpell(id) == spellID) then
			return true
		end
	end

	return false
end

local function UpdateTimeSpiralText(frame, elapsed)
	frame.elapsed = (frame.elapsed or 0) + elapsed
	if frame.elapsed < 0.1 then
		return
	end
	frame.elapsed = 0

	local remaining = TIME_SPIRAL_DURATION - (GetTime() - frame.startTime)
	if remaining <= 0 then
		module:HideTimeSpiral()
		return
	end

	local db = module.db.timeSpiral
	if db.showTimer then
		frame.text:SetFormattedText("%s\n%.1f", db.text, remaining)
	else
		frame.text:SetText(db.text)
	end
end

function module:ShowTimeSpiral(isTest)
	local frame = self.timeSpiralFrame
	if not isTest or not frame:IsShown() then
		frame.startTime = GetTime()
	end
	frame.elapsed = 1
	frame:SetScript("OnUpdate", UpdateTimeSpiralText)
	frame:Show()
	UpdateTimeSpiralText(frame, 0)
end

function module:HideTimeSpiral()
	wipe(timeSpiralGlows)
	local frame = self.timeSpiralFrame
	if frame then
		frame:SetScript("OnUpdate", nil)
		frame:Hide()
	end
end

-------------------------------------------------------------------------------
--  Gateway Control Shard
-------------------------------------------------------------------------------
function module:UpdateGateway()
	local db = self.db and self.db.gateway
	local frame = self.gatewayFrame
	if not frame or self.testMode then
		return
	end

	if not self.db.enable or not db.enable then
		self:StopGatewayPolling()
		frame:Hide()
		return
	end

	local count = C_Item_GetItemCount(GATEWAY_SHARD_ITEM)
	if not count or count == 0 or (db.combatOnly and not self.inCombat) then
		self:StopGatewayPolling()
		self.gatewayUsable = false
		frame:Hide()
		return
	end

	-- The shard only becomes usable while a Demonic Gateway is in range and no
	-- event reports that, so it is polled while the item is in the bags.
	if not self.gatewayTicker then
		self.gatewayTicker = C_Timer.NewTicker(0.2, function()
			module:UpdateGateway()
		end)
	end

	local usable = C_Item_IsUsableItem(GATEWAY_SHARD_ITEM) and true or false
	if usable and self.gatewayUsable == false then
		PlayAlert(db, db.text)
	end
	self.gatewayUsable = usable

	if usable then
		frame.text:SetText(db.text)
	end
	frame:SetShown(usable)
end

function module:StopGatewayPolling()
	if self.gatewayTicker then
		self.gatewayTicker:Cancel()
		self.gatewayTicker = nil
	end
end

-------------------------------------------------------------------------------
--  Frames
-------------------------------------------------------------------------------
local function CreateTextFrame(name, y)
	local frame = CreateFrame("Frame", name, E.UIParent)
	frame:Size(250, 40)
	frame:Point("CENTER", E.UIParent, "CENTER", 0, y)
	frame.text = frame:CreateFontString(nil, "OVERLAY")
	frame.text:SetPoint("CENTER")
	frame.text:SetJustifyH("CENTER")
	frame:Hide()
	return frame
end

function module:CreateFrames()
	if self.anchor then
		return
	end

	self.anchor = CreateFrame("Frame", "MER_MovementAlert", E.UIParent)
	self.anchor:Size(200, 32)
	self.anchor:Point("CENTER", E.UIParent, "CENTER", 0, 120)

	self.timeSpiralFrame = CreateTextFrame("MER_MovementAlertTimeSpiral", 170)
	self.gatewayFrame = CreateTextFrame("MER_MovementAlertGateway", 220)

	E:CreateMover(
		self.anchor,
		"MER_MovementAlertMover",
		MER.Title .. L["Movement Alert"],
		nil,
		nil,
		nil,
		"ALL,SOLO,MERATHILISUI",
		nil,
		"mui,modules,movementAlert"
	)
	E:CreateMover(
		self.timeSpiralFrame,
		"MER_MovementAlertTimeSpiralMover",
		MER.Title .. L["Time Spiral"],
		nil,
		nil,
		nil,
		"ALL,SOLO,MERATHILISUI",
		function()
			return not (module.db and module.db.enable and module.db.timeSpiral.enable)
		end,
		"mui,modules,movementAlert"
	)
	E:CreateMover(
		self.gatewayFrame,
		"MER_MovementAlertGatewayMover",
		MER.Title .. L["Gateway Control Shard"],
		nil,
		nil,
		nil,
		"ALL,SOLO,MERATHILISUI",
		function()
			return not (module.db and module.db.enable and module.db.gateway.enable)
		end,
		"mui,modules,movementAlert"
	)
end

-- The sample text sizes the frame, it can only be set once the font is.
local function StyleTextFrame(frame, db, sample)
	SetFont(frame.text, db.font)
	frame.text:SetText(sample)
	frame.text:SetTextColor(GetColor(db))
	frame:Size(max(100, frame.text:GetStringWidth() + 20), max(20, db.font.size * 2 + 8))
end

function module:UpdateLayout()
	if not self.anchor then
		return
	end

	local db = self.db
	self.styleVersion = (self.styleVersion or 0) + 1
	local width, height = self:GetSlotSize(db.displayMode)
	self.anchor:Size(width, height)
	SetFont(countdownFont, db.font)

	for _, slot in ipairs(slots) do
		self:StyleSlot(slot)
	end

	StyleTextFrame(self.timeSpiralFrame, db.timeSpiral, db.timeSpiral.text .. "\n0.0")
	StyleTextFrame(self.gatewayFrame, db.gateway, db.gateway.text)
end

-------------------------------------------------------------------------------
--  Events
-------------------------------------------------------------------------------
local EVENTS = {
	"PLAYER_ENTERING_WORLD",
	"PLAYER_REGEN_DISABLED",
	"PLAYER_REGEN_ENABLED",
	"PLAYER_SPECIALIZATION_CHANGED",
	"PLAYER_TALENT_UPDATE",
	"TRAIT_CONFIG_UPDATED",
	"SPELLS_CHANGED",
	"UPDATE_SHAPESHIFT_FORM",
	"SPELL_UPDATE_COOLDOWN",
	"SPELL_UPDATE_CHARGES",
	"SPELL_UPDATE_USABLE",
	"BAG_UPDATE_DELAYED",
	"SPELL_ACTIVATION_OVERLAY_GLOW_SHOW",
	"SPELL_ACTIVATION_OVERLAY_GLOW_HIDE",
	"UNIT_SPELLCAST_SENT",
}

function module:PLAYER_ENTERING_WORLD()
	self.inCombat = UnitAffectingCombat("player")
	self:HideTimeSpiral()
	self:RefreshSpells()
	self:UpdateGateway()
end

function module:PLAYER_REGEN_DISABLED()
	self.inCombat = true
	self:RequestUpdate()
	self:UpdateGateway()
end

function module:PLAYER_REGEN_ENABLED()
	self.inCombat = false
	self:RequestUpdate()
	self:UpdateGateway()
end

function module:RefreshSpells()
	self:UpdateTrackedSpells()
	self:UpdateCastFilters()
	self:RequestUpdate()
end

function module:SPELLS_CHANGED()
	if not InCombatLockdown() then
		self:RefreshSpells()
	end
end

module.PLAYER_SPECIALIZATION_CHANGED = module.SPELLS_CHANGED
module.PLAYER_TALENT_UPDATE = module.SPELLS_CHANGED
module.TRAIT_CONFIG_UPDATED = module.SPELLS_CHANGED
module.UPDATE_SHAPESHIFT_FORM = module.RefreshSpells
module.SPELL_UPDATE_COOLDOWN = module.RequestUpdate
module.SPELL_UPDATE_CHARGES = module.RequestUpdate
module.SPELL_UPDATE_USABLE = module.RequestUpdate

function module:BAG_UPDATE_DELAYED()
	self:UpdateGateway()
end

function module:UNIT_SPELLCAST_SENT(_, unit, _, _, spellID)
	if unit == "player" and not IsSecret(spellID) and castFilters[spellID] then
		self.glowBlockedUntil = GetTime() + 1.5
	end
end

function module:SPELL_ACTIVATION_OVERLAY_GLOW_SHOW(_, spellID)
	if not self.db.timeSpiral.enable or IsSecret(spellID) or not self:IsTimeSpiralProc(spellID) then
		return
	end

	self.lastProc = GetTime()
	timeSpiralGlows[spellID] = true
	self:ShowTimeSpiral()
	PlayAlert(self.db.timeSpiral, self.db.timeSpiral.ttsText)
end

function module:SPELL_ACTIVATION_OVERLAY_GLOW_HIDE(_, spellID)
	if IsSecret(spellID) or not timeSpiralGlows[spellID] then
		return
	end

	timeSpiralGlows[spellID] = nil
	if not next(timeSpiralGlows) then
		self:HideTimeSpiral()
	end
end

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

function module:UpdateMovers()
	local db = self.db
	SetMoverEnabled("MER_MovementAlertMover", db.enable)
	SetMoverEnabled("MER_MovementAlertTimeSpiralMover", db.enable and db.timeSpiral.enable)
	SetMoverEnabled("MER_MovementAlertGatewayMover", db.enable and db.gateway.enable)
end

function module:EnableAlerts()
	self:CreateFrames()
	self:UpdateMovers()

	for _, event in ipairs(EVENTS) do
		self:RegisterEvent(event)
	end

	self.inCombat = UnitAffectingCombat("player")
	self:UpdateLayout()
	self:RefreshSpells()
	self:UpdateGateway()
end

function module:DisableAlerts()
	self:UnregisterAllEvents()
	if self.testMode then
		self:ToggleTestMode()
	end

	if self.anchor then
		self:HideMovementAlert()
		self:HideTimeSpiral()
		self:StopGatewayPolling()
		self.gatewayFrame:Hide()
		self:UpdateMovers()
	end
end

-- Called by the options after any setting changed.
function module:SettingsUpdate()
	if not self.db then
		return
	end

	if self.db.enable then
		self:EnableAlerts()
	else
		self:DisableAlerts()
	end
end

function module:Initialize()
	self.db = E.db.mui.movementAlert
	self.readySpells = {}
	self.shownCount = 0

	if self.RebuildSpellOptions then
		self.RebuildSpellOptions()
	end

	if self.db.enable then
		self:EnableAlerts()
	end
end

function module:ProfileUpdate()
	self.db = E.db.mui.movementAlert
	if self.RebuildSpellOptions then
		self.RebuildSpellOptions()
	end
	self:SettingsUpdate()
end

MER:RegisterModule(module:GetName())
