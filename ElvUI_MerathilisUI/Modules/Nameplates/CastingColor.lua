local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Nameplates")
local NP = E:GetModule("NamePlates")

local hooksecurefunc = hooksecurefunc
local pairs = pairs

local C_CurveUtil_EvaluateColorValueFromBoolean = C_CurveUtil and C_CurveUtil.EvaluateColorValueFromBoolean

--[[
	Color Casting Enemies

	An enemy NPC that casts keeps a color on its health bar for as long as it
	holds the plate, so the casters of a pull stay visible between their casts.
	Two tints over the fill, one per kind of cast. The interruptible one lies on
	top, it wins once a mob has shown both kinds. A raid marker color stays above
	them.

	Secret-safe: notInterruptible can be a secret value, so each kind is kept as
	an alpha folded from it by EvaluateColorValueFromBoolean. These alphas may be
	secret as well, they are only ever passed on and never read.

	Works from ElvUI's castbar callbacks, a plate without a castbar notes nothing.
--]]

local function GetDB()
	return E.db.mui.nameplates.castingColor
end

local function Pick(flag, ifTrue, ifFalse)
	if C_CurveUtil_EvaluateColorValueFromBoolean then
		return C_CurveUtil_EvaluateColorValueFromBoolean(flag, ifTrue, ifFalse)
	end

	return flag and ifTrue or ifFalse
end

local function SetAlphas(element, interruptible, uninterruptible)
	element.interruptibleAlpha, element.uninterruptibleAlpha = interruptible, uninterruptible
	element.interruptible:SetAlpha(interruptible)
	element.uninterruptible:SetAlpha(uninterruptible)
end

local function Forget(element)
	SetAlphas(element, 0, 0)
end

-- A cast start or a cast that changed between interruptible and not
local function Note(element)
	if not element.enabled then
		return
	end

	local notInterruptible = element.castbar.notInterruptible
	if notInterruptible == nil then
		notInterruptible = false
	end

	SetAlphas(
		element,
		Pick(notInterruptible, element.interruptibleAlpha, 1),
		Pick(notInterruptible, 1, element.uninterruptibleAlpha)
	)
end

local function Create(nameplate)
	local health = nameplate.Health
	local element = { castbar = nameplate.Castbar, health = health }

	-- Below the Raid Marker Color
	element.uninterruptible = health:CreateTexture(nil, "ARTWORK", nil, 3)
	element.interruptible = health:CreateTexture(nil, "ARTWORK", nil, 4)
	Forget(element)

	local function OnCast()
		Note(element)
	end

	-- ElvUI sets these callbacks once when it builds the castbar
	hooksecurefunc(element.castbar, "PostCastStart", OnCast)
	hooksecurefunc(element.castbar, "PostCastInterruptible", OnCast)

	-- The next unit of this plate has not cast anything yet
	nameplate:HookScript("OnHide", function()
		Forget(element)
	end)

	nameplate.MER_CastingColor = element
	return element
end

-- A texture change on the health bar can hand out a new fill region
local function StyleTint(tint, fill, color, alpha)
	tint:SetAllPoints(fill)
	tint:SetTexture(fill and fill:GetTexture() or E.media.normTex)
	tint:SetVertexColor(color.r, color.g, color.b, alpha)
end

-- Plates get reused for friendly and hostile units, ElvUI runs this when the type changes
function module:Configure_CastingColor(nameplate)
	if not nameplate or nameplate == NP.TestFrame or not nameplate.Health or not nameplate.Castbar then
		return
	end

	local db = GetDB()
	local enabled = db.enable and nameplate.frameType == "ENEMY_NPC"
	local element = nameplate.MER_CastingColor
	if not element then
		if not enabled then
			return
		end
		element = Create(nameplate)
	end

	element.enabled = enabled

	if enabled then
		local fill = element.health:GetStatusBarTexture()
		StyleTint(element.interruptible, fill, db.interruptible, db.alpha)
		StyleTint(element.uninterruptible, fill, db.uninterruptible, db.alpha)
	else
		Forget(element)
	end

	element.interruptible:SetShown(enabled)
	element.uninterruptible:SetShown(enabled)
end

function module:UpdateCastingColors()
	if not NP.Plates then
		return
	end

	for nameplate in pairs(NP.Plates) do
		module:Configure_CastingColor(nameplate)
	end
end

function module:CastingColor()
	hooksecurefunc(NP, "Update_Health", function(_, nameplate)
		module:Configure_CastingColor(nameplate)
	end)

	-- Plates that already existed before the hook
	module:UpdateCastingColors()
end
