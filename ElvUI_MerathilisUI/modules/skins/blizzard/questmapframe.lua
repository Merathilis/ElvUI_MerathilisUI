local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
local select = select

-- WoW API / Variables

-- GLOBALS: hooksecurefunc

local function styleQuestMapFrame()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.quest ~= true or E.private.muiSkins.blizzard.quest ~= true then return; end

	--[[Taken from Aurora]]--
	local QuestMapFrame = _G["QuestMapFrame"]

	-- [[ Quest scroll frame ]]
	local QuestScrollFrame = _G["QuestScrollFrame"]
	local StoryHeader = QuestScrollFrame.Contents.StoryHeader


	_G["QuestScrollFrame"]:HookScript("OnUpdate", function(self)
		if self.spellTex and self.spellTex2 then
			self.spellTex:SetTexture("")
			self.spellTex:SetTexture("")
		end
	end)

	QuestMapFrame.VerticalSeparator:Hide()
	QuestScrollFrame.Background:Hide()

	MERS:CreateBD(QuestScrollFrame.StoryTooltip)

	-- Story header
	StoryHeader.Background:Hide()
	StoryHeader.Shadow:Hide()

	do
		local bg = MERS:CreateBDFrame(StoryHeader, .25)
		bg:SetPoint("TOPLEFT", 0, -1)
		bg:SetPoint("BOTTOMRIGHT", -4, 0)

		local hl = StoryHeader.HighlightTexture

		hl:SetTexture(E["media"].muiGradient)
		hl:SetVertexColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b, .2)
		hl:SetPoint("TOPLEFT", 1, -2)
		hl:SetPoint("BOTTOMRIGHT", -5, 1)
		hl:SetDrawLayer("BACKGROUND")
		hl:Hide()

		StoryHeader:HookScript("OnEnter", function()
			hl:Show()
		end)

		StoryHeader:HookScript("OnLeave", function()
			hl:Hide()
		end)
	end

	-- [[ Quest details ]]
	local DetailsFrame = QuestMapFrame.DetailsFrame
	local RewardsFrame = DetailsFrame.RewardsFrame
	local CompleteQuestFrame = DetailsFrame.CompleteQuestFrame

	_G["WorldMapFrame"].BorderFrame.Inset:Hide()
	DetailsFrame:GetRegions():Hide()
	select(2, DetailsFrame:GetRegions()):Hide()
	select(4, DetailsFrame:GetRegions()):Hide()
	select(6, DetailsFrame.ShareButton:GetRegions()):Hide()
	select(7, DetailsFrame.ShareButton:GetRegions()):Hide()

	-- Rewards frame
	RewardsFrame.Background:Hide()
	select(2, RewardsFrame:GetRegions()):Hide()

	if _G["QuestProgressScrollFrame"].spellTex then
		_G["QuestProgressScrollFrame"].spellTex:SetTexture("")
	end

	-- Complete quest frame
	CompleteQuestFrame:GetRegions():Hide()
	select(2, CompleteQuestFrame:GetRegions()):Hide()
	select(6, CompleteQuestFrame.CompleteButton:GetRegions()):Hide()
	select(7, CompleteQuestFrame.CompleteButton:GetRegions()):Hide()

	-- Quest log popup detail frame
	local QuestLogPopupDetailFrame = _G["QuestLogPopupDetailFrame"]

	select(18, QuestLogPopupDetailFrame:GetRegions()):Hide()
	_G["QuestLogPopupDetailFrameScrollFrameTop"]:Hide()
	_G["QuestLogPopupDetailFrameScrollFrameBottom"]:Hide()
	_G["QuestLogPopupDetailFrameScrollFrameMiddle"]:Hide()
end

S:AddCallback("mUIQuestMapFrame", styleQuestMapFrame)