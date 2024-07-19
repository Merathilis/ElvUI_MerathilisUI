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

	-- Show map button
	local ShowMapButton = _G.QuestLogPopupDetailFrame.ShowMapButton

	ShowMapButton.Texture:SetAlpha(0)
	ShowMapButton.Highlight:SetTexture("")
	ShowMapButton.Highlight:SetTexture("")

	ShowMapButton:SetSize(ShowMapButton.Text:GetStringWidth() + 14, 22)
	ShowMapButton.Text:ClearAllPoints()
	ShowMapButton.Text:SetPoint("CENTER", 1, 0)

	ShowMapButton:ClearAllPoints()
	ShowMapButton:SetPoint("TOPRIGHT", _G.QuestLogPopupDetailFrame, -30, -25)

	ShowMapButton:HookScript("OnEnter", function(self)
		self.Text:SetTextColor(_G.GameFontHighlight:GetTextColor())
	end)

	ShowMapButton:HookScript("OnLeave", function(self)
		self.Text:SetTextColor(_G.GameFontNormal:GetTextColor())
	end)

	-- Bottom buttons
	_G.QuestLogPopupDetailFrame.ShareButton:ClearAllPoints()
	_G.QuestLogPopupDetailFrame.ShareButton:SetPoint("LEFT", _G.QuestLogPopupDetailFrame.AbandonButton, "RIGHT", 1, 0)
	_G.QuestLogPopupDetailFrame.ShareButton:SetPoint("RIGHT", _G.QuestLogPopupDetailFrame.TrackButton, "LEFT", -1, 0)

	_G.QuestMapFrame.CampaignOverview.BG:SetAlpha(0)
end

module:AddCallback("QuestMapFrame")
