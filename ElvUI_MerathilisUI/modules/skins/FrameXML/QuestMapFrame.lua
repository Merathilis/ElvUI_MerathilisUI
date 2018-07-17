local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G

-- WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleQuestMapFrame()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.quest ~= true or E.private.muiSkins.blizzard.quest ~= true then return; end

	--[[ FrameXML\QuestMapFrame.lua ]]
	function MERS.QuestLogQuests_Update(poiTable)
		local warCampaignID = C_CampaignInfo.GetCurrentCampaignID()
		local warCampaignShown = false

		if warCampaignID then
			local warCampaignInfo = C_CampaignInfo.GetCampaignInfo(warCampaignID)
			if warCampaignInfo and warCampaignInfo.visibilityConditionMatched then
				if E.myfaction == "Alliance" then
					QuestScrollFrame.Contents.WarCampaignHeader.Background:SetColorTexture(20/255, 69/255, 135/255)
					QuestScrollFrame.Contents.WarCampaignHeader._mUIOverlay:SetTexture([[Interface\Timer\Alliance-Logo]])
				else
					QuestScrollFrame.Contents.WarCampaignHeader.Background:SetColorTexture(255/255, 0/255, 0/255, 0.4)
					QuestScrollFrame.Contents.WarCampaignHeader._mUIOverlay:SetTexture([[Interface\Timer\Horde-Logo]])
				end
				warCampaignShown = true
			end
		end

		if warCampaignShown then
			QuestScrollFrame.Contents.Separator.Divider:SetColorTexture(1, 1, 1, 0.5)
			QuestScrollFrame.Contents.Separator.Divider:SetSize(200, 1)
		end

		for i = 6, QuestMapFrame.QuestsFrame.Contents:GetNumChildren() do
			local child = select(i, QuestMapFrame.QuestsFrame.Contents:GetChildren())
			if not child.IsSkinned then
				if child.TaskIcon then
					MERS:QuestLogTitleTemplate(child)
				else
					MERS:QuestLogObjectiveTemplate(child)
				end
				child.IsSkinned = true
			end
		end
	end

	--[[ FrameXML\QuestMapFrame.xml ]]
	function MERS:QuestLogTitleTemplate(Button)
	end

	function MERS:QuestLogObjectiveTemplate(Button)
	end

	function MERS:QuestMapHeader(Frame)
		local clipFrame = CreateFrame("Frame", nil, Frame)
		clipFrame:SetClipsChildren(true)

		if Frame.layoutIndex == QUEST_LOG_STORY_LAYOUT_INDEX then
			clipFrame:SetPoint("TOPLEFT", 0, -14)
			clipFrame:SetPoint("BOTTOMRIGHT", 0, 5)
		else
			clipFrame:SetPoint("TOPLEFT")
			clipFrame:SetPoint("BOTTOMRIGHT", 0, 9)

			local overlay = clipFrame:CreateTexture(nil, "OVERLAY")
			overlay:SetSize(142, 142)
			overlay:SetPoint("TOPRIGHT", 16, 38)
			overlay:SetAlpha(0.2)
			overlay:SetDesaturated(true)
			Frame._mUIOverlay = overlay
		end

		Frame.Background:SetColorTexture(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b, 0.15)
		Frame.Background:SetAllPoints(clipFrame)
		Frame.HighlightTexture:SetAllPoints(clipFrame)
		Frame.HighlightTexture:SetColorTexture(1, 1, 1, 0.2)

		Frame:SetHeight(59)
	end

	------------------------------
	-- QuestLogPopupDetailFrame --
	------------------------------
	_G["QuestLogPopupDetailFrameScrollFrame"]:HookScript("OnUpdate", function(self)
		_G["QuestLogPopupDetailFrameScrollFrame"].backdrop:Hide()
		_G["QuestLogPopupDetailFrameInset"]:Hide()
		_G["QuestLogPopupDetailFrameBg"]:Hide()
		self:SetTemplate("Transparent")
		self.spellTex:SetTexture("")
	end)
	select(18, _G["QuestLogPopupDetailFrame"]:GetRegions()):Hide()
	_G["QuestLogPopupDetailFrame"]:Styling()

	-------------------
	-- QuestMapFrame --
	-------------------
	hooksecurefunc("QuestLogQuests_Update", MERS.QuestLogQuests_Update)

	local QuestMapFrame = _G["QuestMapFrame"]
	QuestMapFrame.VerticalSeparator:Hide()

	local QuestsFrame = QuestMapFrame.QuestsFrame
	QuestsFrame.Background:Hide()

	QuestsFrame.Contents.Separator.Divider:Show()
	QuestsFrame.Contents.Separator.Divider:SetVertexColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)
	QuestsFrame.Contents.Separator:SetSize(260, 10)

	MERS:QuestMapHeader(QuestsFrame.Contents.WarCampaignHeader)
	MERS:QuestMapHeader(QuestsFrame.Contents.StoryHeader)

	QuestsFrame.DetailFrame.BottomDetail:Hide()
	QuestsFrame.DetailFrame.TopDetail:Hide()

	local DetailsFrame = QuestMapFrame.DetailsFrame
	local bg, overlay, _, tile = DetailsFrame:GetRegions()
	bg:Hide()
	overlay:Hide()
	tile:Hide()

	DetailsFrame.RewardsFrame.Background:Hide()
	select(2, DetailsFrame.RewardsFrame:GetRegions()):Hide()

	bg, tile = DetailsFrame.CompleteQuestFrame:GetRegions()
	bg:Hide()
	tile:Hide()
end

S:AddCallback("mUIQuestMapFrame", styleQuestMapFrame)