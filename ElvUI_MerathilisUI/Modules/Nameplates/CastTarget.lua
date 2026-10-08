local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Nameplates")
local NP = E:GetModule("NamePlates")

local hooksecurefunc = hooksecurefunc
local pairs = pairs
local PlayerIsSpellTarget = PlayerIsSpellTarget

local C_CurveUtil_EvaluateColorValueFromBoolean = C_CurveUtil and C_CurveUtil.EvaluateColorValueFromBoolean

--[[
	Cast on You

	Marks the castbar of a hostile nameplate while its cast targets the player:
	- border: a colored border around the castbar
	- tint:   the filled part of the bar gets the same color

	Secret-safe: the answer of PlayerIsSpellTarget only goes into a *FromBoolean
	API, the result is the alpha of the textures. It is asked once per cast start,
	nothing runs while the cast is going.
--]]

local ENEMY_TYPES = {
	ENEMY_NPC = true,
	ENEMY_PLAYER = true,
}

local BORDER_SIDES = { "top", "bottom", "left", "right" }

local function GetDB()
	return E.db.mui.nameplates.castTarget
end

local function IsSupported()
	return PlayerIsSpellTarget and C_CurveUtil_EvaluateColorValueFromBoolean and true
end

-- The look only changes with the settings (Configure marks it) or a new fill region, so a cast
-- start only shows the parts instead of anchoring everything again
local function ApplyStyle(ct)
	local castbar = ct.castbar
	local db = GetDB()
	local color = db.color

	-- A texture change on the castbar can hand out a new fill region
	local barTexture = castbar:GetStatusBarTexture()
	if not ct.styleDirty and ct.styledFill == barTexture then
		ct.tint:SetShown(db.tint)
		for _, side in pairs(BORDER_SIDES) do
			ct.border[side]:SetShown(db.border)
		end
		return
	end
	ct.styleDirty, ct.styledFill = nil, barTexture

	ct.tint:SetAllPoints(barTexture)
	ct.tint:SetTexture(barTexture and barTexture:GetTexture() or E.media.normTex)
	ct.tint:SetVertexColor(color.r, color.g, color.b, 1)
	ct.tint:SetShown(db.tint)

	-- Around the backdrop, so the border of the bar itself stays visible
	local anchor = castbar.backdrop or castbar
	local size = db.borderSize
	local border = ct.border

	for _, side in pairs(BORDER_SIDES) do
		local texture = border[side]
		texture:ClearAllPoints()
		texture:SetVertexColor(color.r, color.g, color.b, 1)
		texture:SetShown(db.border)
	end

	border.top:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", -size, 0)
	border.top:SetPoint("BOTTOMRIGHT", anchor, "TOPRIGHT", size, 0)
	border.top:SetHeight(size)

	border.bottom:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", -size, 0)
	border.bottom:SetPoint("TOPRIGHT", anchor, "BOTTOMRIGHT", size, 0)
	border.bottom:SetHeight(size)

	border.left:SetPoint("TOPRIGHT", anchor, "TOPLEFT")
	border.left:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMLEFT")
	border.left:SetWidth(size)

	border.right:SetPoint("TOPLEFT", anchor, "TOPRIGHT")
	border.right:SetPoint("BOTTOMLEFT", anchor, "BOTTOMRIGHT")
	border.right:SetWidth(size)
end

local function SetAlpha(ct, alpha)
	ct.tint:SetAlpha(alpha)
	for _, side in pairs(BORDER_SIDES) do
		ct.border[side]:SetAlpha(alpha)
	end
end

local function Hide(ct)
	ct.active = nil
	ct.tint:Hide()
	for _, side in pairs(BORDER_SIDES) do
		ct.border[side]:Hide()
	end
end

local function Start(ct, unit)
	Hide(ct)

	local castbar = ct.castbar
	unit = unit or castbar.__owner.unit
	if not (ct.enabled and unit) then
		return
	end

	-- A channel still reports the target of the cast before it, empowered casts are right
	if castbar.channeling and not castbar.empowering then
		return
	end

	ct.active = true
	ApplyStyle(ct)
	SetAlpha(ct, C_CurveUtil_EvaluateColorValueFromBoolean(PlayerIsSpellTarget(unit), 1, 0))
end

local function Create(castbar)
	local ct = { castbar = castbar, border = {} }

	-- Below the Interrupt Ready colors, the border still tells when both apply
	ct.tint = castbar:CreateTexture(nil, "ARTWORK", nil, 4)
	ct.tint:Hide()

	for _, side in pairs(BORDER_SIDES) do
		local texture = castbar:CreateTexture(nil, "OVERLAY")
		texture:SetTexture(E.media.blankTex)
		texture:Hide()
		ct.border[side] = texture
	end

	local function OnStart(_, unit)
		Start(ct, unit)
	end
	local function OnStop()
		Hide(ct)
	end

	-- ElvUI sets these callbacks once when it builds the castbar
	for key, func in pairs({
		PostCastStart = OnStart,
		PostCastStop = OnStop,
		PostCastFail = OnStop,
		PostCastInterrupted = OnStop,
	}) do
		if castbar[key] then
			hooksecurefunc(castbar, key, func)
		else
			castbar[key] = func
		end
	end

	castbar.MER_CastTarget = ct
	return ct
end

-- Plates get reused for friendly and hostile units, so this runs per unit
function module:Configure_CastTarget(nameplate)
	if not nameplate or nameplate == NP.TestFrame or not nameplate.Castbar then
		return
	end

	local castbar = nameplate.Castbar
	local enabled = GetDB().enable and ENEMY_TYPES[nameplate.frameType] and IsSupported()
	local ct = castbar.MER_CastTarget
	if not ct then
		if not enabled then
			return
		end
		ct = Create(castbar)
	end

	ct.enabled = enabled
	ct.styleDirty = true

	if not enabled then
		Hide(ct)
	elseif ct.active then
		ApplyStyle(ct)
	end
end

function module:UpdateCastTargets()
	if not NP.Plates then
		return
	end

	for nameplate in pairs(NP.Plates) do
		module:Configure_CastTarget(nameplate)
	end
end

function module:CastTarget()
	hooksecurefunc(NP, "Update_Castbar", function(_, nameplate)
		module:Configure_CastTarget(nameplate)
	end)

	-- Plates that already existed before the hook
	module:UpdateCastTargets()
end
