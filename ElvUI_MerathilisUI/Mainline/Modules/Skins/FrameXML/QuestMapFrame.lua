local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G
local select = select

local function LoadSkin()
	if not module:CheckDB("quest", "quest") then
		return
	end

	-- Stop here if parchment reomover is enabled.
	if E.private.skins.parchmentRemoverEnable then return end

	local QuestMapFrame = _G.QuestMapFrame
	QuestMapFrame.Background:SetAlpha(0)

	-- Quest scroll frame
	local QuestScrollFrame = _G.QuestScrollFrame

	QuestMapFrame.VerticalSeparator:SetAlpha(0)
	QuestScrollFrame.DetailFrame.TopDetail:SetAlpha(0)
	QuestScrollFrame.DetailFrame.BottomDetail:SetAlpha(0)
	QuestScrollFrame.Contents.Separator:SetAlpha(0)

	-- Quest details
	local DetailsFrame = QuestMapFrame.DetailsFrame
	local RewardsFrame = DetailsFrame.RewardsFrame
	local CompleteQuestFrame = DetailsFrame.CompleteQuestFrame

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

	-- Rewards frame
	RewardsFrame.Background:SetAlpha(0)
	select(2, RewardsFrame:GetRegions()):SetAlpha(0)

	-- Complete quest frame
	CompleteQuestFrame:GetRegions():SetAlpha(0)
	select(2, CompleteQuestFrame:GetRegions()):SetAlpha(0)
	select(6, CompleteQuestFrame.CompleteButton:GetRegions()):SetAlpha(0)
	select(7, CompleteQuestFrame.CompleteButton:GetRegions()):SetAlpha(0)

	-- Quest log popup detail frame
	_G.QuestLogPopupDetailFrameScrollFrameTop:SetAlpha(0)
	_G.QuestLogPopupDetailFrameScrollFrameBottom:SetAlpha(0)
	_G.QuestLogPopupDetailFrameScrollFrameMiddle:SetAlpha(0)

	_G.QuestLogPopupDetailFrameScrollFrame:HookScript("OnUpdate", function(self)
		_G.QuestLogPopupDetailFrameScrollFrame.backdrop:Hide()
		_G.QuestLogPopupDetailFrameInset:Hide()
		_G.QuestLogPopupDetailFrameBg:Hide()
		-- self:CreateBackdrop("Transparent")

		if not E.private.skins.parchmentRemoverEnable then
			self.spellTex:SetTexture("")
		end
	end)
	_G.QuestLogPopupDetailFrame:Styling()
	module:CreateBackdropShadow(_G.QuestLogPopupDetailFrame)

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

S:AddCallback("QuestMapFrame", LoadSkin)
