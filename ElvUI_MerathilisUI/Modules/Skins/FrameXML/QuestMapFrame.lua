local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G
local select = select

function module:QuestMapFrame()
	if not module:CheckDB("quest", "quest") then
		return
	end

	local QuestMapFrame = _G.QuestMapFrame
	local DetailsFrame = QuestMapFrame.DetailsFrame

	DetailsFrame:StripTextures()
	DetailsFrame.Bg:SetAlpha(0)
	select(6, DetailsFrame.ShareButton:GetRegions()):SetAlpha(0)
	select(7, DetailsFrame.ShareButton:GetRegions()):SetAlpha(0)
	DetailsFrame.SealMaterialBG:SetAlpha(0)

	DetailsFrame.AbandonButton:ClearAllPoints()
	DetailsFrame.AbandonButton:SetPoint("BOTTOMLEFT", DetailsFrame, -1, 0)
	DetailsFrame.AbandonButton:SetWidth(95)

	DetailsFrame.ShareButton:ClearAllPoints()
	DetailsFrame.ShareButton:SetPoint("LEFT", DetailsFrame.AbandonButton, "RIGHT", 1, 0)
	DetailsFrame.ShareButton:SetWidth(94)

	DetailsFrame.TrackButton:ClearAllPoints()
	DetailsFrame.TrackButton:SetPoint("LEFT", DetailsFrame.ShareButton, "RIGHT", 1, 0)
	DetailsFrame.TrackButton:SetWidth(96)

	_G.QuestLogPopupDetailFrameScrollFrame:HookScript("OnUpdate", function(self)
		if _G.QuestLogPopupDetailFrameScrollFrame.backdrop then
			_G.QuestLogPopupDetailFrameScrollFrame.backdrop:Hide()
		end
		_G.QuestLogPopupDetailFrameInset:Hide()
		_G.QuestLogPopupDetailFrameBg:Hide()

		module:CreateShadow(_G.QuestLogPopupDetailFrame)

		if not E.private.skins.parchmentRemoverEnable then
			self.spellTex:SetTexture("")
		end
	end)

	QuestLogPopupDetailFrame.SealMaterialBG:SetAlpha(0)

	_G.QuestMapFrame.CampaignOverview.BG:SetAlpha(0)
end

module:AddCallback("QuestMapFrame")
