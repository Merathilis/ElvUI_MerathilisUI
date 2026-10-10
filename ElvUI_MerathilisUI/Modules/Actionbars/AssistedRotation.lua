local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Actionbars")
local LAB = LibStub("LibActionButton-1.0-ElvUI")

local next, tonumber = next, tonumber
local max = math.max

local CreateFrame = CreateFrame
local UnitAffectingCombat = UnitAffectingCombat
local IsAssistedCombatAction = C_ActionBar and C_ActionBar.IsAssistedCombatAction

-- LibActionButton builds its buttons from ActionButtonTemplate, so the rotation frame that
-- ActionBarActionButtonMixin adds to the Single-Button Assistant never exists on ElvUI's bars.
-- This rebuilds Blizzard's ActionBarButtonAssistedCombatRotationTemplate (same atlases and glow
-- animation), sized for ElvUI's square buttons.

-- The art is 64px and its inner frame is drawn for a 40px square: at 1.6x the button, centered,
-- the top and right edges sit on the gold band and all four corners stay covered by the ring.
local ART_SCALE = 1.6
-- Blizzard: 100px glow at scale 0.8 over the 64px border
local GLOW_SCALE = 80 / 64

local frames = {} -- [button] = rotation frame
local loaded = false

local function GetColor(db)
	if db.colorMode == "CLASS" then
		return F.r, F.g, F.b
	elseif db.colorMode == "CUSTOM" then
		local c = db.customColor
		return c.r, c.g, c.b
	end
end

local function Layout(frame)
	local width, height = frame:GetParent():GetSize()
	local artWidth, artHeight = width * ART_SCALE, height * ART_SCALE
	local glowSize = max(artWidth, artHeight) * GLOW_SCALE

	frame.InactiveTexture:SetSize(artWidth, artHeight)
	frame.ActiveFrame.Border:SetSize(artWidth, artHeight)
	frame.ActiveFrame.Mask:SetSize(artWidth, artHeight)
	frame.ActiveFrame.Glow:SetSize(glowSize, glowSize)
end

local function Button_OnSizeChanged(button)
	local frame = frames[button]
	if frame then
		Layout(frame)
	end
end

local function SetCombatState(frame, inCombat)
	local db = E.db.mui.actionbars.assistedRotation
	local active = frame.ActiveFrame

	if inCombat then
		frame.InactiveTexture:Hide()
		active:Show()

		if db.animation then
			active.Glow:Show()
			active.GlowAnim:Play()
		else
			active.GlowAnim:Stop()
			active.Glow:Hide()
		end
	else
		frame.InactiveTexture:Show()
		active:Hide()
	end
end

local function UpdateGlow(frame)
	SetCombatState(frame, UnitAffectingCombat("player"))
end

local function UpdateColor(frame)
	local r, g, b = GetColor(E.db.mui.actionbars.assistedRotation)
	local recolor = r ~= nil

	for _, texture in next, { frame.InactiveTexture, frame.ActiveFrame.Border, frame.ActiveFrame.Glow } do
		texture:SetDesaturated(recolor)
		texture:SetVertexColor(r or 1, g or 1, b or 1)
	end
end

-- Textures and animation only, shared by the action buttons and the options preview
local function BuildFrame(parent)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetAllPoints()
	-- above the cooldown and ElvUI's glows, like Blizzard's end-cap level
	frame:SetFrameLevel(parent:GetFrameLevel() + 5)

	local inactive = frame:CreateTexture(nil, "ARTWORK")
	inactive:SetAtlas("UI-HUD-RotationHelper-Inactive")
	inactive:SetPoint("CENTER")
	frame.InactiveTexture = inactive

	local active = CreateFrame("Frame", nil, frame)
	active:SetAllPoints()
	active:Hide()
	frame.ActiveFrame = active

	local border = active:CreateTexture(nil, "BORDER")
	border:SetAtlas("UI-HUD-RotationHelper-Active")
	border:SetPoint("CENTER")
	active.Border = border

	local glow = active:CreateTexture(nil, "ARTWORK")
	glow:SetAtlas("UI-HUD-RotationHelper-Active-FX")
	glow:SetBlendMode("ADD")
	glow:SetAlpha(0.6)
	glow:SetPoint("CENTER")
	active.Glow = glow

	local mask = active:CreateMaskTexture()
	mask:SetAtlas("UI-HUD-RotationHelper-Active-FX-Mask")
	mask:SetPoint("CENTER")
	glow:AddMaskTexture(mask)
	active.Mask = mask

	local anim = active:CreateAnimationGroup()
	anim:SetLooping("REPEAT")
	local rotation = anim:CreateAnimation("Rotation")
	rotation:SetTarget(glow)
	rotation:SetDuration(3)
	rotation:SetDegrees(-360)
	rotation:SetOrigin("CENTER", 0, 0)
	active.GlowAnim = anim

	Layout(frame)
	UpdateColor(frame)

	return frame
end

local function CreateRotationFrame(button)
	local frame = BuildFrame(button)
	frame:Hide() -- the first SetShown(true) runs OnShow and picks the combat state
	frame:SetScript("OnShow", UpdateGlow)

	frames[button] = frame
	button:HookScript("OnSizeChanged", Button_OnSizeChanged)

	return frame
end

local function IsAssistedButton(button)
	if button._state_type ~= "action" then
		return false
	end

	local action = tonumber(button._state_action)
	return action and IsAssistedCombatAction(action) or false
end

function module:AssistedRotation_UpdateButton(_, button)
	local show = E.db.mui.actionbars.assistedRotation.enable and IsAssistedButton(button)
	local frame = frames[button]

	if show and not frame then
		frame = CreateRotationFrame(button)
	end

	if frame then
		frame:SetShown(show)
	end
end

function module:AssistedRotation_UpdateCombat()
	for _, frame in next, frames do
		if frame:IsShown() then
			UpdateGlow(frame)
		end
	end
end

-- Sample frame for the options preview, on a button of its own
function module:AssistedRotation_CreatePreview(button)
	return BuildFrame(button)
end

function module:AssistedRotation_UpdatePreview(frame, inCombat)
	Layout(frame)
	UpdateColor(frame)
	SetCombatState(frame, inCombat)
end

-- Called from the options after a setting changed
function module:AssistedRotation_Refresh()
	if not loaded then
		return
	end

	for _, frame in next, frames do
		UpdateColor(frame)
	end

	-- With the feature off this pass hides every frame, afterwards nothing listens anymore
	for button in next, LAB:GetAllButtons() do
		self:AssistedRotation_UpdateButton(nil, button)
	end

	self:AssistedRotation_SetActive(E.db.mui.actionbars.assistedRotation.enable)
	self:AssistedRotation_UpdateCombat()
end

-- The button callback fires after every content change of every action button, so it and the
-- combat events are only there while the feature is on
function module:AssistedRotation_SetActive(active)
	active = active and true or false
	if active == (self.assistedRotationActive or false) then
		return
	end
	self.assistedRotationActive = active

	if active then
		-- fires after every content change, which covers paging, stances and dragging the spell around
		LAB.RegisterCallback(self, "OnButtonUpdate", "AssistedRotation_UpdateButton")
		self:RegisterEvent("PLAYER_REGEN_ENABLED", "AssistedRotation_UpdateCombat")
		self:RegisterEvent("PLAYER_REGEN_DISABLED", "AssistedRotation_UpdateCombat")
	else
		LAB.UnregisterCallback(self, "OnButtonUpdate")
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		self:UnregisterEvent("PLAYER_REGEN_DISABLED")
	end
end

function module:CreateAssistedRotation()
	if not IsAssistedCombatAction then
		return
	end

	F.Event.RegisterCallback("MER.DatabaseUpdate", self.AssistedRotation_Refresh, self)

	-- ElvUI's bars exist already, so catch the buttons that were updated before us
	loaded = true
	self:AssistedRotation_Refresh()
end
