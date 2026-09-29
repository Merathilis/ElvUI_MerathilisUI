local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnitFrames")
local UF = E:GetModule("UnitFrames")

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local next, pairs, type = next, pairs, type
local UnitCanAttack = UnitCanAttack
local UnitCastingDuration = UnitCastingDuration
local UnitChannelDuration = UnitChannelDuration
local UnitClassBase = UnitClassBase
local UnitEmpoweredChannelDuration = UnitEmpoweredChannelDuration

local C_CurveUtil_EvaluateColorValueFromBoolean = C_CurveUtil and C_CurveUtil.EvaluateColorValueFromBoolean
local C_Spell_GetSpellCooldownDuration = C_Spell and C_Spell.GetSpellCooldownDuration
local C_SpellBook_IsSpellKnownOrInSpellBook = C_SpellBook and C_SpellBook.IsSpellKnownOrInSpellBook

local MAX_ARENA_FRAMES = 5
local MAX_BOSS_FRAMES = 8
local ALPHA_THROTTLE = 0.1

--[[
	Interrupt Ready

	Shared by the MerathilisUI unitframe and nameplate castbars. While your
	interrupt is on cooldown during an interruptible cast of a hostile unit:
	- tint:   the filled part of the bar gets the Theme's "Interrupt on Cooldown" color
	- window: the part of the bar after the moment your interrupt is ready again
	          gets the Theme's "Interrupt Ready Soon" color
	- tick:   a thin line at that moment
	Both colors follow the gradient mode when it is on.

	Secret-safe: cast and cooldown durations only go into StatusBars, the cast's
	interruptible flag and the cooldown state only into *FromBoolean APIs. The
	ready point is the positioner's fill (elapsed cast time) plus the marker's
	fill (remaining cooldown), both sampled at the same moment. When the interrupt
	won't be ready in time, that point lies behind the end of the bar: the window
	collapses and the tick is clipped away.
--]]

local IR = {}
MER.InterruptReady = IR

-- Pet interrupts win over the player's own, a Felguard's Axe Toss is the only
-- interrupt of that Warlock even when the spellbook still reports Spell Lock
local KICK_SPELLS = {
	DEATHKNIGHT = { 47528 }, -- Mind Freeze
	DEMONHUNTER = { 183752 }, -- Disrupt
	DRUID = { 106839, 78675, 38675 }, -- Skull Bash, Solar Beam, 38675
	EVOKER = { 351338 }, -- Quell
	HUNTER = { 147362, 187707 }, -- Counter Shot, Muzzle
	MAGE = { 2139 }, -- Counterspell
	MONK = { 116705 }, -- Spear Hand Strike
	PALADIN = { 96231, 31935 }, -- Rebuke, Avenger's Shield
	PRIEST = { 15487 }, -- Silence
	ROGUE = { 1766 }, -- Kick
	SHAMAN = { 57994 }, -- Wind Shear
	-- Spell Lock, Axe Toss, Command Demon, Spell Lock (Grimoire of Sacrifice), 1276467
	WARLOCK = { 19647, 89766, 119910, 132409, 1276467 },
	WARRIOR = { 6552 }, -- Pummel
}

local kickSpell
local active = {} -- indicators of castbars that are casting right now

local function IsSupported()
	return C_CurveUtil_EvaluateColorValueFromBoolean and C_Spell_GetSpellCooldownDuration and UnitCastingDuration and true
end

local function RefreshKickSpell()
	kickSpell = nil

	local spells = KICK_SPELLS[UnitClassBase("player")]
	if not spells or not C_SpellBook_IsSpellKnownOrInSpellBook then
		return
	end

	local petSpell, playerSpell
	for _, spellID in next, spells do
		if not petSpell and C_SpellBook_IsSpellKnownOrInSpellBook(spellID, Enum.SpellBookSpellBank.Pet) then
			petSpell = spellID
		elseif not playerSpell and C_SpellBook_IsSpellKnownOrInSpellBook(spellID) then
			playerSpell = spellID
		end
	end

	kickSpell = petSpell or playerSpell
end

local function GetCastDuration(ir)
	local unit = ir.unit
	if ir.isChannel then
		if ir.isEmpowered and UnitEmpoweredChannelDuration then
			return UnitEmpoweredChannelDuration(unit, true)
		end
		return UnitChannelDuration(unit)
	end

	return UnitCastingDuration(unit)
end

-- normal/shift of a castColorMap entry, from the gradient cache when it exists
local function GetThemeColors(entry)
	local fgMap = F.Color.GetMap("castColorMap")
	local normal = fgMap and fgMap[I.Enum.GradientMode.Color.NORMAL][entry]
	local shift = fgMap and fgMap[I.Enum.GradientMode.Color.SHIFT][entry]
	if normal and shift then
		return normal, shift
	end

	local db = E.db.mui.themes.gradientMode.castColorMap
	return db[I.Enum.GradientMode.Color.NORMAL][entry], db[I.Enum.GradientMode.Color.SHIFT][entry]
end

local function ApplyColor(texture, castbar, entry)
	local barTexture = castbar:GetStatusBarTexture()
	texture:SetTexture(barTexture and barTexture:GetTexture() or E.media.normTex)

	local normal, shift = GetThemeColors(entry)
	if E.db.mui.themes.gradientMode.enable then
		local fadeMode = castbar.fadeMode or "HORIZONTAL"
		if castbar.fadeDirection == I.Enum.GradientMode.Direction.LEFT then
			F.Color.SetGradient(texture, fadeMode, shift, normal)
		else
			F.Color.SetGradient(texture, fadeMode, normal, shift)
		end
	else
		texture:SetVertexColor(normal.r, normal.g, normal.b, 1)
	end
end

-- Visible while the cast is interruptible and the interrupt is on cooldown
local function UpdateAlpha(ir)
	local cooldown = C_Spell_GetSpellCooldownDuration(kickSpell, true)
	if not cooldown then
		return
	end

	local notInterruptible = ir.castbar.notInterruptible
	if type(notInterruptible) == "nil" then
		notInterruptible = false
	end

	local interruptible = C_CurveUtil_EvaluateColorValueFromBoolean(notInterruptible, 0, 1)
	local alpha = C_CurveUtil_EvaluateColorValueFromBoolean(cooldown:IsZero(), 0, interruptible)

	ir.tint:SetAlpha(alpha)
	ir.window:SetAlpha(alpha)
	ir.tick:SetAlpha(alpha)
end

-- Samples cast and cooldown together, the ready point is only right for a pair
local function UpdateGeometry(ir)
	local cooldown = C_Spell_GetSpellCooldownDuration(kickSpell, true)
	local castDuration = GetCastDuration(ir)
	if not (cooldown and castDuration) then
		return
	end

	local total = castDuration:GetTotalDuration()
	ir.positioner:SetMinMaxValues(0, total)
	ir.positioner:SetValue(castDuration:GetElapsedDuration())
	ir.marker:SetMinMaxValues(0, total)
	ir.marker:SetValue(cooldown:GetRemainingDuration())
end

local function SetFillStyle(bar, reverse)
	bar:SetFillStyle(reverse and Enum.StatusBarFillStyle.Reverse or Enum.StatusBarFillStyle.Standard)

	-- The fill is re-created snapped to the pixel grid, the summed edges need exact floats
	local fill = bar:GetStatusBarTexture()
	if fill and fill.SetSnapToPixelGrid then
		fill:SetSnapToPixelGrid(false)
		fill:SetTexelSnappingBias(0)
	end
	if fill then
		fill:SetAlpha(0)
	end
end

local function UpdateLayout(ir)
	local castbar = ir.castbar
	-- A draining channel runs right to left, so does a cast on a reversed bar
	local reverse = (ir.isChannel and not ir.isEmpowered) ~= (castbar:GetReverseFill() and true or false)

	SetFillStyle(ir.positioner, reverse)
	SetFillStyle(ir.marker, reverse)

	local width, height = castbar:GetSize()
	ir.marker:SetSize(width, height)

	local markerFill = ir.marker:GetStatusBarTexture()
	local positionerFill = ir.positioner:GetStatusBarTexture()

	ir.marker:ClearAllPoints()
	ir.window:ClearAllPoints()
	ir.tick:ClearAllPoints()
	ir.window:SetPoint("TOP", castbar, "TOP")
	ir.window:SetPoint("BOTTOM", castbar, "BOTTOM")

	if reverse then
		ir.marker:SetPoint("RIGHT", positionerFill, "LEFT")
		ir.window:SetPoint("LEFT", castbar, "LEFT")
		ir.window:SetPoint("RIGHT", markerFill, "LEFT")
		ir.tick:SetPoint("TOP", markerFill, "TOPLEFT")
		ir.tick:SetPoint("BOTTOM", markerFill, "BOTTOMLEFT")
	else
		ir.marker:SetPoint("LEFT", positionerFill, "RIGHT")
		ir.window:SetPoint("LEFT", markerFill, "RIGHT")
		ir.window:SetPoint("RIGHT", castbar, "RIGHT")
		ir.tick:SetPoint("TOP", markerFill, "TOPRIGHT")
		ir.tick:SetPoint("BOTTOM", markerFill, "BOTTOMRIGHT")
	end
end

local function Clip_OnUpdate(clip, elapsed)
	clip.elapsed = (clip.elapsed or 0) + elapsed
	if clip.elapsed < ALPHA_THROTTLE then
		return
	end
	clip.elapsed = 0

	if kickSpell then
		UpdateAlpha(clip.ir)
	end
end

local function Hide(ir)
	active[ir] = nil
	ir.tint:Hide()
	ir.window:Hide()
	ir.clip:Hide()
end

local function Start(ir, unit)
	Hide(ir)

	local castbar = ir.castbar
	unit = unit or castbar.__owner.unit
	if not (ir.enabled and kickSpell and unit) then
		return
	end

	-- Friendly casts don't need an interrupt, secret answers fall through to the cooldown check
	local canAttack = UnitCanAttack("player", unit)
	if E:NotSecretValue(canAttack) and not canAttack then
		return
	end

	local db = ir.getDB()
	ir.unit = unit
	ir.isChannel = castbar.channeling and true or false
	ir.isEmpowered = castbar.empowering and true or false

	UpdateLayout(ir)
	UpdateGeometry(ir)

	if db.tint then
		-- A texture change on the castbar can hand out a new fill region
		ir.tint:SetAllPoints(castbar:GetStatusBarTexture())
		ApplyColor(ir.tint, castbar, "INTERRUPTCD")
		ir.tint:Show()
	end
	if db.window then
		ApplyColor(ir.window, castbar, "INTERRUPTSOON")
		ir.window:Show()
	end

	ir.tick:SetColorTexture(db.tickColor.r, db.tickColor.g, db.tickColor.b, 1)
	ir.tick:SetShown(db.tick)

	ir.clip.elapsed = 0
	ir.clip:Show()
	UpdateAlpha(ir)

	active[ir] = true
end

local function Create(castbar)
	local ir = { castbar = castbar }

	-- On the castbar itself so the cast text stays on top
	ir.tint = castbar:CreateTexture(nil, "ARTWORK", nil, 5)
	ir.tint:SetAllPoints(castbar:GetStatusBarTexture())
	ir.tint:Hide()

	ir.window = castbar:CreateTexture(nil, "ARTWORK", nil, 6)
	ir.window:Hide()

	-- Geometry helpers and the tick live in a clipping frame, a ready point
	-- behind the end of the cast never shows outside the bar
	ir.clip = CreateFrame("Frame", nil, castbar)
	ir.clip:SetAllPoints(castbar)
	ir.clip:SetClipsChildren(true)
	ir.clip:SetFrameLevel(castbar:GetFrameLevel() + 1)
	ir.clip:SetScript("OnUpdate", Clip_OnUpdate)
	ir.clip:Hide()
	ir.clip.ir = ir

	ir.positioner = CreateFrame("StatusBar", nil, ir.clip)
	ir.positioner:SetAllPoints(castbar)
	ir.positioner:SetStatusBarTexture(E.media.blankTex)

	ir.marker = CreateFrame("StatusBar", nil, ir.clip)
	ir.marker:SetStatusBarTexture(E.media.blankTex)

	ir.tick = ir.clip:CreateTexture(nil, "OVERLAY", nil, 3)
	ir.tick:SetWidth(2)

	local function OnStart(_, unit)
		Start(ir, unit)
	end
	local function OnStop()
		Hide(ir)
	end
	local function OnInterruptible()
		if active[ir] then
			UpdateAlpha(ir)
		end
	end
	local function OnUpdate()
		if active[ir] then
			UpdateGeometry(ir)
		end
	end

	-- ElvUI sets these callbacks once when it builds the castbar
	for key, func in pairs({
		PostCastStart = OnStart,
		PostCastStop = OnStop,
		PostCastFail = OnStop,
		PostCastInterrupted = OnStop,
		PostCastInterruptible = OnInterruptible,
		PostCastUpdate = OnUpdate,
	}) do
		if castbar[key] then
			hooksecurefunc(castbar, key, func)
		else
			castbar[key] = func
		end
	end

	castbar.MER_InterruptReady = ir
	return ir
end

---Turns the indicator on a castbar on or off
---@param castbar table ElvUI castbar
---@param getDB function returns the settings table (tint, window, tick, tickColor)
---@param enabled boolean
function IR:Configure(castbar, getDB, enabled)
	if not castbar then
		return
	end

	enabled = enabled and IsSupported()
	local ir = castbar.MER_InterruptReady
	if not ir then
		if not enabled then
			return
		end
		ir = Create(castbar)
	end

	ir.getDB = getDB
	ir.enabled = enabled

	if not enabled then
		Hide(ir)
	end
end

do
	local frame = CreateFrame("Frame")
	frame:RegisterEvent("PLAYER_LOGIN")
	frame:RegisterEvent("SPELLS_CHANGED")
	frame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	frame:RegisterUnitEvent("UNIT_PET", "player")
	frame:RegisterEvent("SPELL_UPDATE_COOLDOWN")
	frame:SetScript("OnEvent", function(_, event)
		if event == "SPELL_UPDATE_COOLDOWN" then
			if kickSpell then
				for ir in pairs(active) do
					UpdateGeometry(ir)
					UpdateAlpha(ir)
				end
			end
			return
		end

		RefreshKickSpell()
		if not kickSpell then
			for ir in pairs(active) do
				Hide(ir)
			end
		end
	end)
end

-- Unitframe integration
local UNITS = {
	target = true,
	focus = true,
	boss = true,
	arena = true,
}

local function GetUnitFrameDB()
	return E.db.mui.unitframes.interruptReady
end

function module:Configure_InterruptReady(frame)
	if not frame or not frame.Castbar then
		return
	end

	local unitType = frame.unitframeType
	if not UNITS[unitType] then
		return
	end

	local db = GetUnitFrameDB()
	IR:Configure(frame.Castbar, GetUnitFrameDB, db.enable and db.units[unitType])
end

function module:UpdateInterruptReady()
	module:Configure_InterruptReady(UF.target)
	module:Configure_InterruptReady(UF.focus)

	for i = 1, MAX_BOSS_FRAMES do
		module:Configure_InterruptReady(UF["boss" .. i])
	end
	for i = 1, MAX_ARENA_FRAMES do
		module:Configure_InterruptReady(UF["arena" .. i])
	end
end

function module:InterruptReady()
	hooksecurefunc(UF, "Configure_Castbar", function(_, frame)
		module:Configure_InterruptReady(frame)
	end)

	-- ElvUI spawns its frames before our hooks exist
	module:UpdateInterruptReady()
end
