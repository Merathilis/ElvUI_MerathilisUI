local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_SplashScreen")

local GetScreenHeight = GetScreenHeight
local InCombatLockdown = InCombatLockdown
local IsInInstance = IsInInstance
local CreateFrame = CreateFrame

local needAnimation

function module:Logo_PlayAnimation()
	if needAnimation then
		module.logoFrame:Show()
		module:UnregisterEvent(self, module.Logo_PlayAnimation)

		needAnimation = false
	end
end

function module:Logo_CheckStatus()
	if not E.db.mui or not E.db.mui.general.splashScreen then
		return
	end

	if not IsInInstance() and InCombatLockdown() then
		needAnimation = true
		self:CreateSplash()
		module:RegisterEvent("PLAYER_STARTED_MOVING", self.Logo_PlayAnimation)
	end
end

function module:CreateSplash()
	local frame = CreateFrame("Frame", nil, E.UIParent)
	frame:SetSize(300, 150)
	frame:SetPoint("CENTER", E.UIParent, "BOTTOM", -500, GetScreenHeight() * 0.618)
	frame:SetFrameStrata("HIGH")
	frame:SetAlpha(0)
	frame:Hide()

	local tex = frame:CreateTexture()
	tex:Point("CENTER", frame, "CENTER")
	tex:SetTexture(I.General.MediaPath .. "Textures\\mUI1_Shadow.tga")
	tex:Size(125)

	local version = frame:CreateFontString(nil, "OVERLAY")
	version:FontTemplate(nil, 14)
	version:Point("TOP", tex, "BOTTOM", 0, 10)
	version:SetFormattedText("%s", MER.Version)
	version:SetTextColor(0, 0.75, 0.98)

	local delayTime = 0
	local timer1 = 0.5
	local timer2 = 2
	local timer3 = 0.2

	local anim = frame:CreateAnimationGroup()
	anim.move1 = anim:CreateAnimation("Translation")
	anim.move1:SetOffset(480, 0)
	anim.move1:SetDuration(timer1)
	anim.move1:SetStartDelay(delayTime)

	anim.fadeIn = anim:CreateAnimation("Alpha")
	anim.fadeIn:SetFromAlpha(0)
	anim.fadeIn:SetToAlpha(1)
	anim.fadeIn:SetDuration(timer1)
	anim.fadeIn:SetSmoothing("IN")
	anim.fadeIn:SetStartDelay(delayTime)

	delayTime = delayTime + timer1

	anim.move2 = anim:CreateAnimation("Translation")
	anim.move2:SetOffset(80, 0)
	anim.move2:SetDuration(timer2)
	anim.move2:SetStartDelay(delayTime)

	delayTime = delayTime + timer2

	anim.move3 = anim:CreateAnimation("Translation")
	anim.move3:SetOffset(-40, 0)
	anim.move3:SetDuration(timer3)
	anim.move3:SetStartDelay(delayTime)

	delayTime = delayTime + timer3

	anim.move4 = anim:CreateAnimation("Translation")
	anim.move4:SetOffset(480, 0)
	anim.move4:SetDuration(timer1)
	anim.move4:SetStartDelay(delayTime)

	anim.fadeOut = anim:CreateAnimation("Alpha")
	anim.fadeOut:SetFromAlpha(1)
	anim.fadeOut:SetToAlpha(0)
	anim.fadeOut:SetDuration(timer1)
	anim.fadeOut:SetSmoothing("OUT")
	anim.fadeOut:SetStartDelay(delayTime)

	frame:SetScript("OnShow", function()
		anim:Play()
	end)
	anim:SetScript("OnFinished", function()
		frame:Hide()
	end)

	module.logoFrame = frame
end
