local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnitFrames")
local UF = E:GetModule("UnitFrames")

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local pairs = pairs
local UnitCanAttack = UnitCanAttack

local C_CurveUtil_EvaluateColorValueFromBoolean = C_CurveUtil and C_CurveUtil.EvaluateColorValueFromBoolean

local MAX_ARENA_FRAMES = 5
local MAX_BOSS_FRAMES = 8

--[[
	Castbar Shield

	Shared by the MerathilisUI unitframe and nameplate castbars. A shield icon on
	the castbar of hostile units while their cast can't be interrupted.

	ElvUI's own castbar.Shield is the colored overlay of the "not interruptible"
	castbar color, so this one lives in a separate frame. The interruptible flag
	can be a secret value, it only goes into EvaluateColorValueFromBoolean.
--]]

local CS = {
	-- Blizzard's own castbar shield, 29x33, also used by the options preview
	ATLAS = "ui-castingbar-shield",
	ASPECT = 29 / 33,
}
MER.CastbarShield = CS

local function UpdateAlpha(cs)
	local notInterruptible = cs.castbar.notInterruptible
	if notInterruptible == nil then
		notInterruptible = false
	end

	if C_CurveUtil_EvaluateColorValueFromBoolean then
		cs.icon:SetAlpha(C_CurveUtil_EvaluateColorValueFromBoolean(notInterruptible, 1, 0))
	else
		cs.icon:SetAlpha(notInterruptible and 1 or 0)
	end
end

local function ApplyStyle(cs)
	local db = cs.getDB()
	local castbar = cs.castbar

	cs.icon:SetSize(db.size * CS.ASPECT, db.size)
	cs.icon:ClearAllPoints()
	cs.icon:SetPoint("CENTER", castbar, db.anchorPoint, db.xOffset, db.yOffset)
end

local function Hide(cs)
	cs.frame:Hide()
end

local function Start(cs, unit)
	Hide(cs)

	unit = unit or cs.castbar.__owner.unit
	if not (cs.enabled and unit) then
		return
	end

	-- Friendly casts don't need an interrupt, secret answers fall through to the flag
	local canAttack = UnitCanAttack("player", unit)
	if E:NotSecretValue(canAttack) and not canAttack then
		return
	end

	-- Size and position come from Configure, a cast only shows the icon
	UpdateAlpha(cs)
	cs.frame:Show()
end

local function Create(castbar)
	local cs = { castbar = castbar }

	-- Above the castbar text and the Interrupt Ready overlays
	cs.frame = CreateFrame("Frame", nil, castbar)
	cs.frame:SetAllPoints(castbar)
	cs.frame:SetFrameLevel(castbar:GetFrameLevel() + 3)
	cs.frame:Hide()

	cs.icon = cs.frame:CreateTexture(nil, "OVERLAY")
	cs.icon:SetAtlas(CS.ATLAS)

	local function OnStart(_, unit)
		Start(cs, unit)
	end
	local function OnStop()
		Hide(cs)
	end
	local function OnInterruptible()
		if cs.frame:IsShown() then
			UpdateAlpha(cs)
		end
	end

	-- ElvUI sets these callbacks once when it builds the castbar
	for key, func in pairs({
		PostCastStart = OnStart,
		PostCastStop = OnStop,
		PostCastFail = OnStop,
		PostCastInterrupted = OnStop,
		PostCastInterruptible = OnInterruptible,
	}) do
		if castbar[key] then
			hooksecurefunc(castbar, key, func)
		else
			castbar[key] = func
		end
	end

	castbar.MER_CastbarShield = cs
	return cs
end

---Turns the shield on a castbar on or off
---@param castbar table ElvUI castbar
---@param getDB function returns the settings table (size, anchorPoint, xOffset, yOffset)
---@param enabled boolean
function CS:Configure(castbar, getDB, enabled)
	if not castbar then
		return
	end

	local cs = castbar.MER_CastbarShield
	if not cs then
		if not enabled then
			return
		end
		cs = Create(castbar)
	end

	cs.getDB = getDB
	cs.enabled = enabled

	if not enabled then
		Hide(cs)
	else
		ApplyStyle(cs)
	end
end

-- Unitframe integration
local UNITS = {
	target = true,
	focus = true,
	boss = true,
	arena = true,
}

local function GetUnitFrameDB()
	return E.db.mui.unitframes.castbarShield
end

function module:Configure_CastbarShield(frame)
	if not frame or not frame.Castbar then
		return
	end

	local unitType = frame.unitframeType
	if not UNITS[unitType] then
		return
	end

	local db = GetUnitFrameDB()
	CS:Configure(frame.Castbar, GetUnitFrameDB, db.enable and db.units[unitType])
end

function module:UpdateCastbarShield()
	module:Configure_CastbarShield(UF.target)
	module:Configure_CastbarShield(UF.focus)

	for i = 1, MAX_BOSS_FRAMES do
		module:Configure_CastbarShield(UF["boss" .. i])
	end
	for i = 1, MAX_ARENA_FRAMES do
		module:Configure_CastbarShield(UF["arena" .. i])
	end
end

function module:CastbarShield()
	hooksecurefunc(UF, "Configure_Castbar", function(_, frame)
		module:Configure_CastbarShield(frame)
	end)

	-- ElvUI spawns its frames before our hooks exist
	module:UpdateCastbarShield()
end
