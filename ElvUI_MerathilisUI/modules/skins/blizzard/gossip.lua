local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
local select = select
local find, gsub = string.find, string.gsub
-- WoW API / Variables
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: hooksecurefunc, obj, NUMGOSSIPBUTTONS, MER_TRIVIAL_QUEST_DISPLAY, MER_NORMAL_QUEST_DISPLAY

local function styleGossip()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.gossip ~= true or E.private.muiSkins.blizzard.gossip ~= true then return; end

	_G["GossipFrame"]:Styling()

	_G["GossipGreetingScrollFrame"]:StripTextures()
	_G["GossipGreetingText"]:SetTextColor(1, 1, 1)

	for i = 1, 7 do
		select(i, _G["GossipFrame"]:GetRegions()):Hide()
	end
	select(19, _G["GossipFrame"]:GetRegions()):Hide()

	_G["GreetingText"]:SetTextColor(1, 1, 1)
	_G["GreetingText"].SetTextColor = MER.dummy

	_G["GossipGreetingScrollFrame"].spellTex:SetTexture('')

	hooksecurefunc("GossipFrameUpdate", function()
		for i=1, NUMGOSSIPBUTTONS do
			local text = _G["GossipTitleButton" .. i]:GetText()
			if text then
				text = gsub(text, "|cff......", "|cffffffff")
				_G["GossipTitleButton" .. i]:SetText(text)
			end
		end
	end)

	hooksecurefunc("GossipFrameAvailableQuestsUpdate", function(...)
		local numAvailQuestsData = select("#", ...)
		local buttonIndex = (_G["GossipFrame"].buttonIndex - 1) - (numAvailQuestsData / 7)
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
		local buttonIndex = (_G["GossipFrame"].buttonIndex - 1) - (numActiveQuestsData / 6)
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

	_G["ItemTextFrame"]:StripTextures(true)
	_G["ItemTextScrollFrameScrollBar"]:StripTextures()
	_G["InboxFrameBg"]:Hide()
	_G["ItemTextPrevPageButton"]:GetRegions():Hide()
	_G["ItemTextNextPageButton"]:GetRegions():Hide()
	_G["ItemTextMaterialTopLeft"]:SetAlpha(0)
	_G["ItemTextMaterialTopRight"]:SetAlpha(0)
	_G["ItemTextMaterialBotLeft"]:SetAlpha(0)
	_G["ItemTextMaterialBotRight"]:SetAlpha(0)
	_G["ItemTextPageText"]:SetTextColor(1, 1, 1)
	_G["ItemTextPageText"].SetTextColor = MER.dummy
end

S:AddCallback("mUIGossip", styleGossip)