local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
local select = select
local find, gsub = string.find, string.gsub
-- WoW API / Variables
-- GLOBALS: hooksecurefunc, obj, NUMGOSSIPBUTTONS

local function styleGossip()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.gossip ~= true or E.private.muiSkins.blizzard.gossip ~= true then return; end

	MERS:CreateGradient(GossipFrame)
	if not GossipFrame.stripes then
		MERS:CreateStripes(GossipFrame)
	end
	_G["GossipGreetingScrollFrame"]:StripTextures()
	_G["GossipGreetingText"]:SetTextColor(1, 1, 1)

	for i = 1, 7 do
		select(i, GossipFrame:GetRegions()):Hide()
	end
	select(19, GossipFrame:GetRegions()):Hide()

	GreetingText:SetTextColor(1, 1, 1)
	GreetingText.SetTextColor = MER.dummy

	GossipGreetingScrollFrame.spellTex:SetTexture('')

	hooksecurefunc("GossipFrameUpdate", function()
		for i=1, NUMGOSSIPBUTTONS do
			local text = _G["GossipTitleButton" .. i]:GetText()
			if text then
				text = string.gsub(text, "|cff......", "|cffffffff")
				_G["GossipTitleButton" .. i]:SetText(text)
			end
		end
	end)

	hooksecurefunc("GossipFrameAvailableQuestsUpdate", function(...)
		local numAvailQuestsData = select("#", ...)
		local buttonIndex = (GossipFrame.buttonIndex - 1) - (numAvailQuestsData / 7)
		for i = 1, numAvailQuestsData, 7 do
			local titleText, _, isTrivial = select(i, ...)
			local titleButton = _G["GossipTitleButton" .. buttonIndex]
			if isTrivial then
				titleButton:SetFormattedText(MER_TRIVIAL_QUEST_DISPLAY, titleText)
			else
				titleButton:SetFormattedText(MER_NORMAL_QUEST_DISPLAY, titleText)
			end
			buttonIndex = buttonIndex + 1
		end
	end)
	hooksecurefunc("GossipFrameActiveQuestsUpdate", function(...)
		local numActiveQuestsData = select("#", ...)
		local buttonIndex = (GossipFrame.buttonIndex - 1) - (numActiveQuestsData / 6)
		for i = 1, numActiveQuestsData, 6 do
			local titleText, _, isTrivial = select(i, ...)
			local titleButton = _G["GossipTitleButton" .. buttonIndex]
			if isTrivial then
				titleButton:SetFormattedText(MER_TRIVIAL_QUEST_DISPLAY, titleText)
			else
				titleButton:SetFormattedText(MER_NORMAL_QUEST_DISPLAY, titleText)
			end
			buttonIndex = buttonIndex + 1
		end
	end)

	ItemTextFrame:StripTextures(true)
	ItemTextScrollFrameScrollBar:StripTextures()
	InboxFrameBg:Hide()
	ItemTextPrevPageButton:GetRegions():Hide()
	ItemTextNextPageButton:GetRegions():Hide()
	ItemTextMaterialTopLeft:SetAlpha(0)
	ItemTextMaterialTopRight:SetAlpha(0)
	ItemTextMaterialBotLeft:SetAlpha(0)
	ItemTextMaterialBotRight:SetAlpha(0)
	ItemTextPageText:SetTextColor(1, 1, 1)
	ItemTextPageText.SetTextColor = MER.dummy
end

S:AddCallback("mUIGossip", styleGossip)