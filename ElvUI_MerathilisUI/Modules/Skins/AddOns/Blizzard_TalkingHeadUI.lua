local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

--Cache global variables
local _G = _G
--WoW API / Variables
-- GLOBALS:

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.talkinghead ~= true or E.private.muiSkins.blizzard.talkinghead ~= true then return end

	local TalkingHeadFrame = _G.TalkingHeadFrame
	if TalkingHeadFrame.backdrop then TalkingHeadFrame.backdrop:Styling() end

	TalkingHeadFrame.BackgroundFrame.TextBackground:SetAtlas(nil)
	TalkingHeadFrame.PortraitFrame.Portrait:SetAtlas(nil)
	TalkingHeadFrame.MainFrame.Model.PortraitBg:SetAtlas(nil)
	TalkingHeadFrame.BackgroundFrame.TextBackground.SetAtlas = MER.dummy
	TalkingHeadFrame.PortraitFrame.Portrait.SetAtlas = MER.dummy
	TalkingHeadFrame.MainFrame.Model.PortraitBg.SetAtlas = MER.dummy

	TalkingHeadFrame.MainFrame.Model.ModelShadow = TalkingHeadFrame.MainFrame.Model:CreateTexture(nil, "OVERLAY", nil, 2)
	TalkingHeadFrame.MainFrame.Model.ModelShadow:SetAtlas("Artifacts-BG-Shadow")
	TalkingHeadFrame.MainFrame.Model.ModelShadow:SetOutside()
	TalkingHeadFrame.MainFrame.Model.PortraitBg:Hide()

	TalkingHeadFrame.MainFrame.CloseButton:ClearAllPoints()
	TalkingHeadFrame.MainFrame.CloseButton:Point("TOPRIGHT", TalkingHeadFrame.BackgroundFrame, "TOPRIGHT", 0, -2)

	TalkingHeadFrame.NameFrame.Name:SetTextColor(1, 0.82, 0.02)
	TalkingHeadFrame.NameFrame.Name.SetTextColor = MER.dummy
	TalkingHeadFrame.NameFrame.Name:SetShadowColor(0, 0, 0, 1)
	TalkingHeadFrame.NameFrame.Name:SetShadowOffset(2, -2)

	TalkingHeadFrame.TextFrame.Text:SetTextColor(1, 1, 1)
	TalkingHeadFrame.TextFrame.Text.SetTextColor = MER.dummy
	TalkingHeadFrame.TextFrame.Text:SetShadowColor(0, 0, 0, 1)
	TalkingHeadFrame.TextFrame.Text:SetShadowOffset(2, -2)
end

S:AddCallbackForAddon("Blizzard_TalkingHeadUI", "mUITalkingHead", LoadSkin)
