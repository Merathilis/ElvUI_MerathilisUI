local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
local next, pairs, select, unpack = next, pairs, select, unpack
-- WoW API / Variables
local C_CampaignInfo_GetCampaignInfo = C_CampaignInfo.GetCampaignInfo
local C_CampaignInfo_GetCurrentCampaignID = C_CampaignInfo.GetCurrentCampaignID
local hooksecurefunc = hooksecurefunc
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function styleQuestMapFrame()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.quest ~= true or E.private.muiSkins.blizzard.quest ~= true then return; end

	-- Stop here if parchment reomover is enabled.
	if E.private.skins.parchmentRemover.enable then return end

	local QuestMapFrame = _G.QuestMapFrame

	-- Quest scroll frame
	local QuestScrollFrame = _G.QuestScrollFrame
	local campaignHeader = QuestScrollFrame.Contents.WarCampaignHeader
	local storyHeader = QuestScrollFrame.Contents.StoryHeader

	QuestMapFrame.VerticalSeparator:SetAlpha(0)
	QuestScrollFrame.Background:SetAlpha(0)
	QuestScrollFrame.DetailFrame.TopDetail:SetAlpha(0)
	QuestScrollFrame.DetailFrame.BottomDetail:SetAlpha(0)
	QuestScrollFrame.Contents.Separator:SetAlpha(0)

	_G.QuestScrollFrameScrollBar:ClearAllPoints()
	_G.QuestScrollFrameScrollBar:SetPoint("TOPLEFT", QuestScrollFrame, "TOPRIGHT", 4, -16)
	_G.QuestScrollFrameScrollBar:SetPoint("BOTTOMLEFT", QuestScrollFrame, "BOTTOMRIGHT", 4, 15)

	_G.QuestMapDetailsScrollFrameScrollBar:SetPoint("TOPLEFT", _G.QuestMapDetailsScrollFrame, "TOPRIGHT", 0, -18)

	local questHeader = {
		QuestScrollFrame.Contents.WarCampaignHeader,
		QuestScrollFrame.Contents.StoryHeader
	}

	for i = 1, #questHeader do
		local frame = questHeader[i]
		frame.HighlightTexture:Hide()
		frame.Background:Hide()
		frame.Text:SetPoint("TOPLEFT", 15, -20)

		frame:CreateBackdrop("Transparent")
		if i == 1 then -- WarCampaignHeader
			local newTex = frame:CreateTexture(nil, "OVERLAY")
			newTex:SetPoint("TOPRIGHT", -15, -7)
			newTex:SetSize(40, 40)
			newTex:SetBlendMode("ADD")
			newTex:SetAlpha(0)
			frame.newTex = newTex

			frame.backdrop:SetPoint("TOPLEFT", 6, -5)
		else  -- StoryHeader
			frame.backdrop:SetPoint("TOPLEFT", 6, -9)
		end
		frame.backdrop:SetPoint("BOTTOMRIGHT", -6, 11)

		frame:HookScript("OnEnter", function()
			frame.backdrop:SetBackdropColor(r, g, b, .25)
		end)
		frame:HookScript("OnLeave", function()
			frame.backdrop:SetBackdropColor(0, 0, 0, .25)
		end)
	end

	local idToTexture = {
		[261] = "Interface\\FriendsFrame\\PlusManz-Alliance",
		[262] = "Interface\\FriendsFrame\\PlusManz-Horde",
	}

	local function UpdateCampaignHeader()
		campaignHeader.newTex:SetAlpha(0)
		if campaignHeader:IsShown() then
			local campaignID = C_CampaignInfo_GetCurrentCampaignID()
			if campaignID then
				local warCampaignInfo = C_CampaignInfo_GetCampaignInfo(campaignID)
				local textureID = warCampaignInfo.uiTextureKitID
				if textureID and idToTexture[textureID] then
					campaignHeader.newTex:SetTexture(idToTexture[textureID])
					campaignHeader.newTex:SetAlpha(.7)
				end
			end
		end
	end

	hooksecurefunc("QuestLogQuests_Update", function()
		UpdateCampaignHeader()
	end)

	-- Shows Quest Level if ~= Player Level
	local function Showlevel(_, _, _, title, level, _, isHeader, _, _, _, questID)
		for button in pairs(QuestScrollFrame.titleFramePool.activeObjects) do
			if title and not isHeader and button.questID == questID then
				local title = level ~= E.mylevel and "["..level.."] "..title or title
				local height = button.Text:GetHeight()
				button.Text:SetText(title)
				button.Check:SetPoint("LEFT", button.Text, button.Text:GetWrappedWidth() + 2, 0)
				button:SetHeight(button:GetHeight() - height + button.Text:GetHeight())
			end
		end
	end
	hooksecurefunc("QuestLogQuests_AddQuestButton", Showlevel)

	-- Quest details
	local DetailsFrame = QuestMapFrame.DetailsFrame
	local RewardsFrame = DetailsFrame.RewardsFrame
	local CompleteQuestFrame = DetailsFrame.CompleteQuestFrame

	DetailsFrame:StripTextures()
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
	local QuestLogPopupDetailFrame = _G["QuestLogPopupDetailFrame"]

	select(18, QuestLogPopupDetailFrame:GetRegions()):SetAlpha(0)
	_G.QuestLogPopupDetailFrameScrollFrameTop:SetAlpha(0)
	_G.QuestLogPopupDetailFrameScrollFrameBottom:SetAlpha(0)
	_G.QuestLogPopupDetailFrameScrollFrameMiddle:SetAlpha(0)

	_G.QuestLogPopupDetailFrameScrollFrame:HookScript("OnUpdate", function(self)
		_G.QuestLogPopupDetailFrameScrollFrame.backdrop:Hide()
		_G.QuestLogPopupDetailFrameInset:Hide()
		_G.QuestLogPopupDetailFrameBg:Hide()
		self:SetTemplate("Transparent")
		if not E.private.skins.parchmentRemover.enable then
			self.spellTex:SetTexture("")
		end
	end)
	QuestLogPopupDetailFrame:Styling()

	-- Show map button
	local ShowMapButton = QuestLogPopupDetailFrame.ShowMapButton

	ShowMapButton.Texture:SetAlpha(0)
	ShowMapButton.Highlight:SetTexture("")
	ShowMapButton.Highlight:SetTexture("")

	ShowMapButton:SetSize(ShowMapButton.Text:GetStringWidth() + 14, 22)
	ShowMapButton.Text:ClearAllPoints()
	ShowMapButton.Text:SetPoint("CENTER", 1, 0)

	ShowMapButton:ClearAllPoints()
	ShowMapButton:SetPoint("TOPRIGHT", QuestLogPopupDetailFrame, -30, -25)

	ShowMapButton:HookScript("OnEnter", function(self)
		self.Text:SetTextColor(_G.GameFontHighlight:GetTextColor())
	end)

	ShowMapButton:HookScript("OnLeave", function(self)
		self.Text:SetTextColor(_G.GameFontNormal:GetTextColor())
	end)

	-- Bottom buttons
	QuestLogPopupDetailFrame.ShareButton:ClearAllPoints()
	QuestLogPopupDetailFrame.ShareButton:SetPoint("LEFT", QuestLogPopupDetailFrame.AbandonButton, "RIGHT", 1, 0)
	QuestLogPopupDetailFrame.ShareButton:SetPoint("RIGHT", QuestLogPopupDetailFrame.TrackButton, "LEFT", -1, 0)
end

S:AddCallback("mUIQuestMapFrame", styleQuestMapFrame)
