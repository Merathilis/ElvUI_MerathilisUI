local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local _G = _G
local pairs = pairs

function module:Immersion_ReskinTitleButton(frame)
	for _, button in pairs({ frame.TitleButtons:GetChildren() }) do
		if button and not button.__MERSkin then
			S:HandleButton(button, true, nil, nil, true, "Transparent")
			button.backdrop:ClearAllPoints()
			button.backdrop:SetPoint("TOPLEFT", button, "TOPLEFT", 3, -3)
			button.backdrop:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -10, 3)
			module:CreateBackdropShadow(button)

			button.Hilite:StripTextures()
			button.Overlay:StripTextures()
			button:SetBackdrop(nil)
			F.SetFontOutline(button.Label)

			button.__MERSkin = true
		end
	end
end

function module:AttemptReskinButton()
	self.reskinButtonAttemptCount = self.reskinButtonAttemptCount + 1
	self:Immersion_ReskinTitleButton(_G.ImmersionFrame)
	if self.reskinButtonAttemptCount == 10 then
		self:CancelTimer(self.reskinButtonTimer)
	end
end

function module:Immersion_Show()
	self:Immersion_SpeechProgressText()
	self:Immersion_ReskinTitleButton(_G.ImmersionFrame)
	self.reskinButtonAttemptCount = 0
	self.reskinButtonTimer = self:ScheduleRepeatingTimer("AttemptReskinButton", 0.1)
	E:Delay(0.1, S.Immersion_ReskinItems, S)
end

function module:Immersion_ReskinItems()
	for i = 1, 20 do
		local rButton = _G["ImmersionQuestInfoItem" .. i]
		if not rButton then
			break
		end

		if not rButton.__MERSkin then
			if rButton.NameFrame then
				rButton.NameFrame:StripTextures()
				rButton.NameFrame:CreateBackdrop("Transparent")
				rButton.NameFrame.backdrop:ClearAllPoints()
				rButton.NameFrame.backdrop:SetOutside(rButton.NameFrame, -18, -15)
				module:CreateBackdropShadow(rButton.NameFrame)
			end

			rButton.__MERSkin = true
		end
	end

	for i = 1, 20 do
		local rButton = _G["ImmersionProgressItem" .. i]
		if not rButton then
			break
		end

		if not rButton.__MERSkin then
			if rButton.NameFrame then
				rButton.NameFrame:StripTextures()
				rButton.NameFrame:CreateBackdrop("Transparent")
				rButton.NameFrame.backdrop:ClearAllPoints()
				rButton.NameFrame.backdrop:SetOutside(rButton.NameFrame, -18, -15)
				module:CreateBackdropShadow(rButton.NameFrame)
			end

			rButton.__MERSkin = true
		end
	end
end

do
	local reskin = false
	function module:Immersion_SpeechProgressText()
		if reskin then
			return
		end

		local talkBox = _G.ImmersionFrame and _G.ImmersionFrame.TalkBox
		if talkBox and talkBox.TextFrame and talkBox.TextFrame.SpeechProgress then
			F.SetFontOutline(talkBox.TextFrame.SpeechProgress)

			reskin = true
		end
	end
end

function module:Immersion()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.imm then
		return
	end

	module:DisableAddOnSkins("Immersion", false)

	local frame = _G.ImmersionFrame
	-- TalkBox
	local talkBox = frame.TalkBox

	-- Backdrop
	talkBox.BackgroundFrame:StripTextures()
	talkBox:CreateBackdrop("Transparent")
	talkBox.backdrop:ClearAllPoints()
	talkBox.backdrop:SetPoint("TOPLEFT", talkBox, "TOPLEFT", 10, -10)
	talkBox.backdrop:SetPoint("BOTTOMRIGHT", talkBox, "BOTTOMRIGHT", -10, 10)
	module:CreateBackdropShadow(talkBox)

	-- Use colored backdrop edge as highlight
	talkBox.Hilite:StripTextures()
	talkBox:HookScript("OnEnter", function(box)
		S.SetModifiedBackdrop(box)

		if box.backdrop.shadow then
			box.backdrop.shadow:SetBackdropBorderColor(box.backdrop:GetBackdropBorderColor())
		end
	end)

	talkBox:HookScript("OnLeave", function(box)
		S.SetOriginalBackdrop(box)

		if box.backdrop.shadow then
			box.backdrop.shadow:SetBackdropBorderColor(box.backdrop:GetBackdropBorderColor())
		end
	end)

	-- Remove background of model
	talkBox.PortraitFrame:StripTextures()
	talkBox.MainFrame.Model.ModelShadow:StripTextures()
	talkBox.MainFrame.Model.PortraitBG:StripTextures()

	-- No Sheen
	talkBox.MainFrame.Sheen:StripTextures()
	talkBox.MainFrame.TextSheen:StripTextures()
	talkBox.MainFrame.Overlay:StripTextures()

	-- Text
	F.SetFontOutline(talkBox.NameFrame.Name)
	F.SetFontOutline(talkBox.TextFrame.Text, nil, 15)

	-- Close Button
	S:HandleCloseButton(talkBox.MainFrame.CloseButton)

	-- Indicator
	talkBox.MainFrame.Indicator:ClearAllPoints()
	talkBox.MainFrame.Indicator:SetPoint("RIGHT", talkBox.MainFrame.CloseButton, "LEFT", -2, 0)

	-- Reputation bar
	local repBar = talkBox.ReputationBar
	repBar:StripTextures()
	repBar:SetStatusBarTexture(E.media.normTex)
	repBar:CreateBackdrop()
	repBar:ClearAllPoints()
	repBar:SetPoint("TOPLEFT", talkBox, "TOPLEFT", 11, -11)
	repBar:SetHeight(6)

	E:RegisterStatusBar(repBar)

	-- Backdrop of elements (bottom window)
	local elements = talkBox.Elements
	elements:SetBackdrop(nil)
	elements:CreateBackdrop("Transparent")
	elements.backdrop:ClearAllPoints()
	elements.backdrop:SetPoint("TOPLEFT", elements, "TOPLEFT", 10, -5)
	elements.backdrop:SetPoint("BOTTOMRIGHT", elements, "BOTTOMRIGHT", -10, 5)
	F.SetFontOutline(elements.Progress.ReqText)
	module:CreateBackdropShadow(elements)

	-- Details
	local content = elements.Content
	F.SetFontOutline(content.ObjectivesHeader)
	F.SetFontOutline(content.ObjectivesText)
	F.SetFontOutline(content.RewardText)
	F.SetFontOutline(content.RewardsFrame.Header)
	F.SetFontOutline(content.RewardsFrame.TitleFrame.Name)
	F.SetFontOutline(content.RewardsFrame.XPFrame.ReceiveText)
	F.SetFontOutline(content.RewardsFrame.XPFrame.ValueText)
	F.SetFontOutline(content.RewardsFrame.ItemReceiveText)
	F.SetFontOutline(content.RewardsFrame.ItemChooseText)
	F.SetFontOutline(content.RewardsFrame.PlayerTitleText)
	F.SetFontOutline(content.RewardsFrame.SkillPointFrame.ValueText)

	-- Buttons
	self:SecureHookScript(frame, "OnEvent", "Immersion_ReskinTitleButton")
	self:SecureHook(frame, "Show", "Immersion_Show")
end

module:AddCallbackForAddon("Immersion")
