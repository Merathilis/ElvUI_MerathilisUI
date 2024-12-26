local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins

local _G = _G

function module:TalkingHeadUI()
	if not module:CheckDB("talkinghead", "talkinghead") then
		return
	end

	local TalkingHeadFrame = _G.TalkingHeadFrame
	if TalkingHeadFrame and not TalkingHeadFrame.__MERSkin then
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

		TalkingHeadFrame.__MERSkin = true
		print("blub")
	end
end

module:AddCallback("TalkingHeadUI")
