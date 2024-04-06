local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local GetScreenHeight = GetScreenHeight
local InCombatLockdown = InCombatLockdown
local IsInInstance = IsInInstance
local CreateFrame = CreateFrame

local needAnimation

function MER:Logo_PlayAnimation()
	if needAnimation then
		MER.logoFrame:Show()
		MER:UnregisterEvent(self, MER.Logo_PlayAnimation)
		needAnimation = false
	end
end

function MER:Logo_CheckStatus()
	if not (IsInInstance() and InCombatLockdown()) then
		needAnimation = true
		self:CreateSplash()
		MER:RegisterEvent("PLAYER_STARTED_MOVING", self.Logo_PlayAnimation)
	end
end

function MER:CreateSplash()
	local frame = CreateFrame("Frame", nil, E.UIParent)
	frame:SetSize(300, 150)
	frame:SetPoint("CENTER", E.UIParent, "BOTTOM", -500, GetScreenHeight() * 0.618)
	frame:SetFrameStrata("HIGH")
	frame:SetAlpha(0)
	frame:Hide()

	local tex = frame:CreateTexture()
	tex:Point("CENTER", frame, "CENTER")
	tex:SetTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\Media\\Textures\\mUI1_Shadow.tga")
	tex:Size(125, 125)

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

	MER.logoFrame = frame
end

function MER:SplashScreen()
	if not E.db.mui or not E.db.mui.general.splashScreen then
		return
	end

	self:Logo_CheckStatus()

	SlashCmdList["MER_PLAYLOGO"] = function()
		if not MER.logoFrame then
			MER:CreateSplash()
		end
		MER.logoFrame:Show()
	end
	SLASH_MER_PLAYLOGO1 = "/mlogo"
end
