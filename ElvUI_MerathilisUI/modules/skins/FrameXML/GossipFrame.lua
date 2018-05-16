local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G

-- WoW API / Variables
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleGossip()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.gossip ~= true or E.private.muiSkins.blizzard.gossip ~= true then return; end

	--[[ FrameXML\GossipFrame.lua ]]

	local availDataPerQuest, activeDataPerQuest = 7, 6
	function MERS.GossipFrameAvailableQuestsUpdate(...)
		local numAvailQuestsData = _G.select("#", ...)
		local buttonIndex = (_G.GossipFrame.buttonIndex - 1) - (numAvailQuestsData / availDataPerQuest)
		for i = 1, numAvailQuestsData, availDataPerQuest do
			local titleText, _, isTrivial = _G.select(i, ...)
			local titleButton = _G["GossipTitleButton" .. buttonIndex]
			if isTrivial then
				titleButton:SetFormattedText(MER_TRIVIAL_QUEST_DISPLAY, titleText)
			else
				titleButton:SetFormattedText(MER_NORMAL_QUEST_DISPLAY, titleText)
			end
			buttonIndex = buttonIndex + 1
		end
	end

	function MERS.GossipFrameActiveQuestsUpdate(...)
		local numActiveQuestsData = _G.select("#", ...)
		local buttonIndex = (_G.GossipFrame.buttonIndex - 1) - (numActiveQuestsData / activeDataPerQuest)
		for i = 1, numActiveQuestsData, activeDataPerQuest do
			local titleText, _, isTrivial = _G.select(i, ...)
			local titleButton = _G["GossipTitleButton" .. buttonIndex]
			if isTrivial then
				titleButton:SetFormattedText(MER_TRIVIAL_QUEST_DISPLAY, titleText)
			else
				titleButton:SetFormattedText(MER_NORMAL_QUEST_DISPLAY, titleText)
			end
			buttonIndex = buttonIndex + 1
		end
	end

	--[[ FrameXML\GossipFrame.xml ]]

	function MERS:GossipTitleButtonTemplate(Button)
		Button:SetSize(300, 16)
		_G[Button:GetName().."GossipIcon"]:SetSize(16, 16)
		_G[Button:GetName().."GossipIcon"]:SetPoint("TOPLEFT", 3, 1)

		local text = Button:GetFontString()
		text:SetSize(257, 0)
		text:SetPoint("LEFT", 20, 0)
	end

	hooksecurefunc("GossipFrameAvailableQuestsUpdate", MERS.GossipFrameAvailableQuestsUpdate)
	hooksecurefunc("GossipFrameActiveQuestsUpdate", MERS.GossipFrameActiveQuestsUpdate)

	_G["GossipFrame"]:Styling()
	for i = 1, 7 do
		select(i, _G["GossipFrame"]:GetRegions()):Hide()
	end
	_G["GossipGreetingScrollFrame"]:StripTextures()
	_G["GossipGreetingScrollFrame"].spellTex:SetTexture('') -- Remove Parchement
	select(19, _G.GossipFrame:GetRegions()):Hide() -- GossipFrameBg

	_G["GossipFrameNpcNameText"]:SetAllPoints(_G["GossipFrame"].TitleText)

	for i = 1, NUMGOSSIPBUTTONS do
		MERS:GossipTitleButtonTemplate(_G["GossipTitleButton"..i])
	end

	local prevTitle
	for i = 1, _G.NUMGOSSIPBUTTONS do
		if not prevTitle then
			_G["GossipTitleButton"..i]:SetPoint("TOPLEFT", GossipGreetingText, "BOTTOMLEFT", -10, -20)
		else
			_G["GossipTitleButton"..i]:SetPoint("TOPLEFT", prevTitle, "BOTTOMLEFT", 0, -3)
		end
		prevTitle = _G["GossipTitleButton"..i]
	end

	-- SIZE
	_G["GossipGreetingScrollChildFrame"]:SetSize(300, 403)
	_G["GossipGreetingText"]:SetSize(300, 0)
	_G["GossipGreetingText"]:SetPoint("TOPLEFT", 10, -10)
end

S:AddCallback("mUIGossip", styleGossip)