local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local InCombatLockdown = InCombatLockdown
local IsInInstance = IsInInstance
local CreateFrame = CreateFrame

local logoFrame

-- Timings (seconds) of the fly-in, drift, bounce-back and fly-out phases
local FLY_TIME = 0.5
local DRIFT_TIME = 2
local BOUNCE_TIME = 0.2

local function AddTranslation(anim, offsetX, duration, delay, smoothing)
	local move = anim:CreateAnimation("Translation")
	move:SetOffset(offsetX, 0)
	move:SetDuration(duration)
	move:SetStartDelay(delay)
	move:SetSmoothing(smoothing)

	return move
end

local function AddFade(anim, fromAlpha, toAlpha, delay, smoothing)
	local fade = anim:CreateAnimation("Alpha")
	fade:SetFromAlpha(fromAlpha)
	fade:SetToAlpha(toAlpha)
	fade:SetDuration(FLY_TIME)
	fade:SetStartDelay(delay)
	fade:SetSmoothing(smoothing)

	return fade
end

local function CreateLogoFrame()
	local frame = CreateFrame("Frame", nil, E.UIParent)
	frame:Size(300, 150)
	frame:Point("CENTER", E.UIParent, "BOTTOM", -500, E.UIParent:GetHeight() * 0.618)
	frame:SetFrameStrata("HIGH")
	frame:SetAlpha(0)
	frame:Hide()

	local tex = frame:CreateTexture()
	tex:Point("CENTER", frame, "CENTER")
	tex:SetTexture(I.General.MediaPath .. "Textures\\mUI1_Shadow.tga")
	tex:Size(125)

	local color = I.Strings.Branding.ColorRGB
	local version = frame:CreateFontString(nil, "OVERLAY")
	version:FontTemplate(nil, 14)
	version:Point("TOP", tex, "BOTTOM", 0, 10)
	version:SetText(MER.Version)
	version:SetTextColor(color.r, color.g, color.b)

	-- Total travel: 480 + 80 - 40 + 480 = 1000, so the logo crosses from -500 to +500
	local anim = frame:CreateAnimationGroup()
	local delay = 0

	AddTranslation(anim, 480, FLY_TIME, delay, "OUT")
	AddFade(anim, 0, 1, delay, "IN")
	delay = delay + FLY_TIME

	AddTranslation(anim, 80, DRIFT_TIME, delay, "NONE")
	delay = delay + DRIFT_TIME

	AddTranslation(anim, -40, BOUNCE_TIME, delay, "IN_OUT")
	delay = delay + BOUNCE_TIME

	AddTranslation(anim, 480, FLY_TIME, delay, "IN")
	AddFade(anim, 1, 0, delay, "OUT")

	anim:SetScript("OnFinished", function()
		frame:Hide()
		logoFrame = nil
	end)

	frame.anim = anim

	return frame
end

function MER:LoginLogo_Play()
	-- Combat state can change between login and the first movement, so check here.
	-- Stay registered and retry on the next movement instead of dropping the logo.
	if InCombatLockdown() or IsInInstance() then
		return
	end

	self:UnregisterEvent("PLAYER_STARTED_MOVING")

	logoFrame = CreateLogoFrame()
	logoFrame:Show()
	logoFrame.anim:Play()
end

function MER:LoginLogo()
	if not (E.db.mui and E.db.mui.general.splashScreen and E.db.mui.core.installed) then
		return
	end

	self:RegisterEvent("PLAYER_STARTED_MOVING", "LoginLogo_Play")
end
