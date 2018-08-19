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

	TalkingHeadFrame.MainFrame.CloseButton:ClearAllPoints()
	TalkingHeadFrame.MainFrame.CloseButton:Point("TOPRIGHT", TalkingHeadFrame.BackgroundFrame, "TOPRIGHT", 0, -2)

	hooksecurefunc("TalkingHeadFrame_PlayCurrent", function()
		local frame = TalkingHeadFrame
		if frame:IsShown() then
			frame.NameFrame.Name:SetTextColor(1, .8, 0)
			frame.NameFrame.Name:SetShadowColor(0, 0, 0, 0)
			frame.TextFrame.Text:SetTextColor(1, 1, 1)
			frame.TextFrame.Text:SetShadowColor(0, 0, 0, 0)
		end
	end)
end

S:AddCallbackForAddon("Blizzard_TalkingHeadUI", "mUITalkingHead", styleTalkingHead)