local MER, E, L, V, P, G = unpack(select(2, ...))
local MI = MER:GetModule("mUIMisc")

-- Cache global variables
-- Lua functions
-- WoW API / Variables
local InCombatLockdown = InCombatLockdown
local IsInInstance = IsInInstance

local needAnimation

function MI:Logo_PlayAnimation()
	if needAnimation then
		MI.logoFrame:Show()
		MER:UnregisterEvent(self, MER.Logo_PlayAnimation)
		needAnimation = false
	end
end

function MI:Logo_CheckStatus(isInitialLogin)
	if isInitialLogin and not (IsInInstance() and InCombatLockdown()) then
		needAnimation = true
		MI:CreateSplash()
		MER:RegisterEvent("PLAYER_STARTED_MOVING", MI.Logo_PlayAnimation)
	end
	MER:UnregisterEvent(self, MI.Logo_CheckStatus)
end

function MI:CreateSplash()
	local frame = CreateFrame("Frame", nil, E.UIParent)
	frame:SetSize(300, 150)
	frame:SetPoint("CENTER", E.UIParent, "BOTTOM", -500, GetScreenHeight()*.618)
	frame:SetFrameStrata("HIGH")
	frame:SetAlpha(0)
	frame:Hide()

	local tex = frame:CreateTexture()
	tex:Point("CENTER", frame, "CENTER")
	tex:SetTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\mUI1_Shadow.tga")
	tex:Size(125, 125)

	local version = MER:CreateText(frame, "OVERLAY", 14, nil, "CENTER")
	version:FontTemplate(nil, 14, nil)
	version:Point("TOP", tex, "BOTTOM", 0, 10)
	version:SetFormattedText("v%s", MER.Version)
	version:SetTextColor(1, 0.5, 0.25, 1)

	local delayTime = 0
	local timer1 = .5
	local timer2 = 2
	local timer3 = .2

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

	MI.logoFrame = frame
end

function MI:SplashScreen()
	if not E.db.mui.general.splashScreen then return end

	MER:RegisterEvent("PLAYER_ENTERING_WORLD", MI.Logo_CheckStatus)

	SlashCmdList["NDUI_PLAYLOGO"] = function()
		if not MI.logoFrame then
			MI:CreateSplash()
		end
		MI.logoFrame:Show()
	end
	SLASH_NDUI_PLAYLOGO1 = "/mlogo"
end
