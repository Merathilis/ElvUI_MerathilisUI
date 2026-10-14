local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Nameplates")
local NP = E:GetModule("NamePlates")
local ElvUF = E.oUF

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local pairs = pairs
local InCombatLockdown = InCombatLockdown
local UnitExists = UnitExists

--[[
	oUF element: MER_TargetEmphasis

	Makes the target's nameplate stand out while you have a target: the other
	plates fade to a lower alpha and get a dark shade over their health bar, the
	new target pops up once. Changes from a target switch or a combat change fade
	over a short time, a plate that just appeared takes its state right away.

	Widget: nameplate.MER_TargetEmphasis - a table with
	  shade - Texture over the health bar, so name-only plates never show it
	  pop   - AnimationGroup on the nameplate, a short scale bump
	Options: alpha / shadeAlpha / popScale (nil turns that part off), keepCasting,
	  combatOnly, friendly

	Next to it, ElvUI's border glow on the target gets wider, fades in and may
	pulse (Configure_TargetGlow).

	The plate alpha is left alone while ElvUI's Fader runs on a plate, it owns
	the alpha then.
--]]

local FADE_DURATION = 0.2
local POP_GROW = 0.1
local POP_SHRINK = 0.2
local PULSE_DURATION = 0.9
local PULSE_ALPHA = 0.4

local HOSTILE = {
	ENEMY_NPC = true,
	ENEMY_PLAYER = true,
}

-- Only real changes animate, a new or reconfigured plate is set right away
local ANIMATED = {
	PLAYER_TARGET_CHANGED = true,
	PLAYER_REGEN_DISABLED = true,
	PLAYER_REGEN_ENABLED = true,
	MER_CastbarChanged = true,
}

-- ElvUI's fader starts from the current alpha, a switch halfway through a fade
-- turns around smoothly instead of jumping
local function FadeTo(region, alpha, animate)
	local current = region:GetAlpha()
	if animate and current ~= alpha and region:IsVisible() then
		if alpha < current then
			E:UIFrameFadeOut(region, FADE_DURATION, current, alpha)
		else
			E:UIFrameFadeIn(region, FADE_DURATION, current, alpha)
		end
	else
		E:UIFrameFadeRemoveFrame(region)
		region:SetAlpha(alpha)
	end
end

local function CreateParts(owner, health)
	local element = {}

	-- Above the fill, the Raid Marker Color and the Focus Highlight
	local shade = health:CreateTexture(nil, "ARTWORK", nil, 7)
	shade:SetAllPoints(health)
	shade:SetColorTexture(0, 0, 0, 1)
	shade:SetAlpha(0)
	element.shade = shade

	-- Scale animations multiply, the shrink undoes the grow
	local pop = owner:CreateAnimationGroup()
	pop.grow = pop:CreateAnimation("Scale")
	pop.grow:SetOrder(1)
	pop.grow:SetDuration(POP_GROW)
	pop.grow:SetSmoothing("OUT")
	pop.shrink = pop:CreateAnimation("Scale")
	pop.shrink:SetOrder(2)
	pop.shrink:SetDuration(POP_SHRINK)
	pop.shrink:SetSmoothing("IN_OUT")
	element.pop = pop

	return element
end

local function ConfigureParts(element, db)
	element.alpha = db.fade and db.alpha or nil
	element.shadeAlpha = db.shade and db.shadeAlpha or nil
	element.popScale = db.pop and db.popScale or nil
	element.keepCasting = db.keepCasting
	element.combatOnly = db.combatOnly
	element.friendly = db.friendly

	if element.popScale then
		local scale = element.popScale
		element.pop.grow:SetScale(scale, scale)
		element.pop.shrink:SetScale(1 / scale, 1 / scale)
	else
		element.pop:Stop()
	end
end

-- owner: the frame that fades and pops, fade: whether it fades out, nil when
-- someone else owns its alpha
local function Apply(owner, element, isTarget, dim, fade, animate)
	FadeTo(element.shade, (dim and element.shadeAlpha) or 0, animate)

	if fade ~= nil then
		FadeTo(owner, (fade and element.alpha) or 1, animate)
	end

	if isTarget and not element.isTarget and animate and element.popScale then
		element.pop:Stop()
		element.pop:Play()
	end

	element.isTarget = isTarget
end

local function IsAffected(element, frameType)
	return HOSTILE[frameType] or (element.friendly and frameType ~= "PLAYER")
end

local function Update(self, event)
	local element = self.MER_TargetEmphasis
	local unit = self.__unit
	if not unit then
		return
	end

	if element.PreUpdate then
		element:PreUpdate()
	end

	-- The player's own plate never counts as the target
	local isTarget = self.frameType ~= "PLAYER" and E:UnitIsUnit(unit, "target") and true or false

	-- The lockdown starts after PLAYER_REGEN_DISABLED and ends after PLAYER_REGEN_ENABLED
	local inCombat
	if event == "PLAYER_REGEN_DISABLED" then
		inCombat = true
	elseif event == "PLAYER_REGEN_ENABLED" then
		inCombat = false
	else
		inCombat = InCombatLockdown()
	end

	local dim = false
	if not isTarget and UnitExists("target") and (inCombat or not element.combatOnly) then
		dim = IsAffected(element, self.frameType) and true or false
	end

	-- A casting unit keeps its alpha, its castbar is what matters then. The shade stays.
	local fade
	if element.alpha and not self:IsElementEnabled("Fader") then
		local castbar = self.Castbar
		fade = dim and not (element.keepCasting and castbar and castbar:IsShown()) or false
	end

	Apply(self, element, isTarget, dim, fade, ANIMATED[event])

	if element.PostUpdate then
		return element:PostUpdate(isTarget, dim)
	end
end

local function Path(self, ...)
	return (self.MER_TargetEmphasis.Override or Update)(self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, "ForceUpdate", element.__owner.__unit)
end

local function Enable(self)
	local element = self.MER_TargetEmphasis
	if element then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent("PLAYER_TARGET_CHANGED", Path, true)
		self:RegisterEvent("PLAYER_REGEN_DISABLED", Path, true)
		self:RegisterEvent("PLAYER_REGEN_ENABLED", Path, true)

		return true
	end
end

local function Reset(self, element)
	element.pop:Stop()
	element.isTarget = nil
	FadeTo(element.shade, 0, false)

	if not self:IsElementEnabled("Fader") then
		FadeTo(self, 1, false)
	end
end

local function Disable(self)
	local element = self.MER_TargetEmphasis
	if element then
		Reset(self, element)

		self:UnregisterEvent("PLAYER_TARGET_CHANGED", Path)
		self:UnregisterEvent("PLAYER_REGEN_DISABLED", Path)
		self:UnregisterEvent("PLAYER_REGEN_ENABLED", Path)
	end
end

ElvUF:AddElement("MER_TargetEmphasis", Path, Enable, Disable)

-- Nameplate integration
-- Bumped on every settings change, UpdatePlate runs for each new unit and only
-- has to configure a plate that missed the last change
local version = 0

local function Castbar_OnVisibility(castbar)
	local nameplate = castbar.MER_TargetEmphasisOwner
	local element = nameplate and nameplate.MER_TargetEmphasis
	if element and element.keepCasting and nameplate:IsElementEnabled("MER_TargetEmphasis") then
		Path(nameplate, "MER_CastbarChanged")
	end
end

function module:Configure_TargetEmphasis(nameplate)
	if not nameplate or nameplate == NP.TestFrame or not nameplate.Health then
		return
	end

	local element = nameplate.MER_TargetEmphasis
	if element and element.version == version then
		return
	end

	local db = E.db.mui.nameplates.targetEmphasis
	if not (db and db.enable) then
		if element then
			element.version = version
			if nameplate:IsElementEnabled("MER_TargetEmphasis") then
				nameplate:DisableElement("MER_TargetEmphasis")
			end
		end
		return
	end

	if not element then
		element = CreateParts(nameplate, nameplate.Health)
		nameplate.MER_TargetEmphasis = element

		local castbar = nameplate.Castbar
		if castbar then
			castbar.MER_TargetEmphasisOwner = nameplate
			castbar:HookScript("OnShow", Castbar_OnVisibility)
			castbar:HookScript("OnHide", Castbar_OnVisibility)
		end
	end

	element.version = version
	ConfigureParts(element, db)

	-- A part that was turned off gives back what it changed
	if not element.shadeAlpha then
		FadeTo(element.shade, 0, false)
	end
	if not element.alpha and not nameplate:IsElementEnabled("Fader") then
		FadeTo(nameplate, 1, false)
	end

	if not nameplate:IsElementEnabled("MER_TargetEmphasis") then
		nameplate:EnableElement("MER_TargetEmphasis")
	end

	if nameplate.__unit then
		element:ForceUpdate()
	end
end

-- ElvUI's border glow (TargetIndicator.Shadow, the Border styles): wider, fades in
-- on a new target and may pulse. ElvUI hides and shows it on every update of the
-- indicator, so OnShow is the moment the target changed. Its color stays ElvUI's.
local BORDER_STYLES = {
	style1 = true,
	style5 = true,
	style7 = true,
}

local ELVUI_GLOW_SIZE = 5
local GLOW_FADE = 0.25

local function Glow_OnShow(shadow)
	if not shadow.MER_Enhanced then
		return
	end

	shadow.MER_Pulse:Stop()
	shadow.MER_Fade:Stop()
	shadow.MER_Fade:Play()
end

-- The pulse takes over once the glow is fully in
local function Fade_OnFinished(fade)
	local shadow = fade.shadow
	if shadow.MER_Enhanced and shadow.MER_PulseEnabled and shadow:IsShown() then
		shadow.MER_Pulse:Play()
	end
end

local function Glow_OnHide(shadow)
	if shadow.MER_Pulse then
		shadow.MER_Pulse:Stop()
	end
end

-- An alpha animation replaces the alpha ElvUI sets on the glow, so both run up
-- to that alpha, one after the other
local function CreateGlowParts(shadow)
	local fade = shadow:CreateAnimationGroup()
	fade.shadow = shadow
	fade:SetScript("OnFinished", Fade_OnFinished)
	local fadeIn = fade:CreateAnimation("Alpha")
	fadeIn:SetFromAlpha(0)
	fadeIn:SetToAlpha(1)
	fadeIn:SetDuration(GLOW_FADE)
	fadeIn:SetSmoothing("OUT")
	fade.alpha = fadeIn
	shadow.MER_Fade = fade

	local pulse = shadow:CreateAnimationGroup()
	pulse:SetLooping("BOUNCE")
	local breathe = pulse:CreateAnimation("Alpha")
	breathe:SetDuration(PULSE_DURATION)
	breathe:SetSmoothing("IN_OUT")
	pulse.alpha = breathe
	shadow.MER_Pulse = pulse

	shadow:HookScript("OnShow", Glow_OnShow)
	shadow:HookScript("OnHide", Glow_OnHide)
end

-- Returns true when the backdrop was set again, that drops the border color
local function SetGlowSize(shadow, anchor, size)
	-- Same spacing to the bar as ElvUI's own glow
	local offset = size + (E.PixelMode and 1 or 3)
	shadow:SetOutside(anchor, offset, offset, nil, true)

	if (shadow.MER_Size or ELVUI_GLOW_SIZE) ~= size then
		shadow.MER_Size = size
		shadow:SetBackdrop({ edgeFile = E.Media.Textures.GlowTex, edgeSize = size })
		return true
	end
end

-- alpha: the glow's own alpha from ElvUI's glow color
local function ConfigureGlow(shadow, anchor, db, alpha)
	if not shadow.MER_Fade then
		CreateGlowParts(shadow)
	end

	shadow.MER_Enhanced = true
	shadow.MER_PulseEnabled = db.glowPulse

	-- Both ends of the fade-in are relative to the alpha ElvUI wants
	shadow.MER_Fade.alpha:SetToAlpha(alpha)
	shadow.MER_Pulse.alpha:SetFromAlpha(alpha)
	shadow.MER_Pulse.alpha:SetToAlpha(alpha * PULSE_ALPHA)

	if not db.glowPulse then
		shadow.MER_Pulse:Stop()
	elseif shadow:IsShown() and not shadow.MER_Fade:IsPlaying() then
		shadow.MER_Pulse:Play()
	end

	return SetGlowSize(shadow, anchor, db.glowSize)
end

local function ResetGlow(shadow, anchor)
	if not shadow.MER_Enhanced then
		return
	end

	shadow.MER_Enhanced = nil
	shadow.MER_Fade:Stop()
	shadow.MER_Pulse:Stop()
	return SetGlowSize(shadow, anchor, ELVUI_GLOW_SIZE)
end

function module:Configure_TargetGlow(nameplate)
	local indicator = nameplate and nameplate.TargetIndicator
	local shadow = indicator and indicator.Shadow
	if not shadow or nameplate == NP.TestFrame or not nameplate.Health then
		return
	end

	local db = E.db.mui.nameplates.targetEmphasis
	local enabled = db
		and db.enable
		and db.glow
		and BORDER_STYLES[indicator.style]
		and nameplate:IsElementEnabled("TargetIndicator")

	local changed
	if enabled then
		local color = NP.db.colors.glowColor
		changed = ConfigureGlow(shadow, nameplate.Health, db, color.a or 1)
	else
		changed = ResetGlow(shadow, nameplate.Health)
	end

	-- ElvUI sets the border color again when it shows the glow
	if changed and nameplate.__unit and indicator.ForceUpdate and nameplate:IsElementEnabled("TargetIndicator") then
		indicator:ForceUpdate()
	end
end

function module:UpdateTargetEmphasis()
	version = version + 1

	if not NP.Plates then
		return
	end

	for nameplate in pairs(NP.Plates) do
		module:Configure_TargetEmphasis(nameplate)
		module:Configure_TargetGlow(nameplate)
	end
end

-- Sample parts on a bar for the options preview (Options/Widgets/TargetEmphasisPreview.lua)
function module:TargetEmphasis_CreatePreview(bar)
	return CreateParts(bar, bar)
end

function module:TargetEmphasis_UpdatePreview(bar, element, isTarget, hasTarget, animate)
	ConfigureParts(element, E.db.mui.nameplates.targetEmphasis)

	local dim = hasTarget and not isTarget
	Apply(bar, element, isTarget, dim, dim and element.alpha ~= nil, animate)
end

-- Sample border glow around a bar for the options preview, like ElvUI's
function module:TargetGlow_CreatePreview(bar)
	local shadow = CreateFrame("Frame", nil, bar, "BackdropTemplate")
	shadow:SetFrameLevel(bar:GetFrameLevel())
	shadow:SetBackdrop({ edgeFile = E.Media.Textures.GlowTex, edgeSize = ELVUI_GLOW_SIZE })
	shadow:Hide()

	return shadow
end

function module:TargetGlow_UpdatePreview(shadow, bar, isTarget)
	shadow:Hide()

	-- Only ElvUI's Border styles have this glow
	local style = NP.db.units.TARGET.glowStyle
	if not BORDER_STYLES[style] then
		return
	end

	local db = E.db.mui.nameplates.targetEmphasis
	local color = NP.db.colors.glowColor
	if db.enable and db.glow then
		ConfigureGlow(shadow, bar, db, color.a or 1)
	else
		ResetGlow(shadow, bar)
		SetGlowSize(shadow, bar, ELVUI_GLOW_SIZE)
	end

	shadow:SetBackdropBorderColor(color.r, color.g, color.b)
	shadow:SetAlpha(color.a or 1)
	shadow:SetShown(isTarget)
end

function module:TargetEmphasis()
	-- Runs for every plate that gets a unit, also the name-only ones
	hooksecurefunc(NP, "UpdatePlate", function(_, nameplate)
		module:Configure_TargetEmphasis(nameplate)
	end)

	-- ElvUI lays its glow out again here, the wider one goes on top
	hooksecurefunc(NP, "Update_TargetIndicator", function(_, nameplate)
		module:Configure_TargetGlow(nameplate)
	end)

	-- Plates that already existed before the hook
	module:UpdateTargetEmphasis()
end
