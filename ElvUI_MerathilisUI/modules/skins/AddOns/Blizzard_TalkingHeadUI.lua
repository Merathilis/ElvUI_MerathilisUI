local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
local _G = _G
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleTalkingHead()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.talkinghead ~= true or E.private.muiSkins.blizzard.talkinghead ~= true then return end

	local TalkingHeadFrame = _G["TalkingHeadFrame"]
	MERS:CreateBD(TalkingHeadFrame.BackgroundFrame, .5)
	TalkingHeadFrame.BackgroundFrame:Styling()

	TalkingHeadFrame.MainFrame.Model.ModelShadow = TalkingHeadFrame.MainFrame.Model:CreateTexture(nil, "OVERLAY", nil, 2)
	TalkingHeadFrame.MainFrame.Model.ModelShadow:SetAtlas("Artifacts-BG-Shadow")
	TalkingHeadFrame.MainFrame.Model.ModelShadow:SetOutside()
	TalkingHeadFrame.MainFrame.Model.PortraitBg:Hide()

	TalkingHeadFrame.MainFrame.CloseButton:ClearAllPoints()
	TalkingHeadFrame.MainFrame.CloseButton:Point("TOPRIGHT", TalkingHeadFrame.BackgroundFrame, "TOPRIGHT", 0, -2)

	TalkingHeadFrame.NameFrame.Name:SetTextColor(1, 0.82, 0.02)
	TalkingHeadFrame.NameFrame.Name.SetTextColor = MER.dummy
	TalkingHeadFrame.NameFrame.Name:SetShadowColor(0.0, 0.0, 0.0, 1.0)
	TalkingHeadFrame.NameFrame.Name:SetShadowOffset(2, -2)

	TalkingHeadFrame.TextFrame.Text:SetTextColor(1, 1, 1)
	TalkingHeadFrame.TextFrame.Text.SetTextColor = MER.dummy
	TalkingHeadFrame.TextFrame.Text:SetShadowColor(0.0, 0.0, 0.0, 1.0)
	TalkingHeadFrame.TextFrame.Text:SetShadowOffset(2, -2)
end

S:AddCallbackForAddon("Blizzard_TalkingHeadUI", "mUITalkingHead", styleTalkingHead)