local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
local select, unpack = select, unpack
local gsub = string.gsub
-- WoW API / Variables
local C_Timer_After = C_Timer.After
local hooksecurefunc = hooksecurefunc
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function styleGossip()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.gossip ~= true or E.private.muiSkins.blizzard.gossip ~= true then return; end

	local GossipFrame = _G.GossipFrame
	GossipFrame:Styling()

	_G.GossipGreetingScrollFrame:StripTextures()

	if not E.private.skins.parchmentRemover.enable then
		_G.GossipGreetingScrollFrame.spellTex:SetTexture('') -- Remove Parchement
	end

	_G.GossipGreetingText:SetTextColor(1, 1, 1)
	_G.NPCFriendshipStatusBar:GetRegions():Hide()
	_G.NPCFriendshipStatusBarNotch1:SetColorTexture(0, 0, 0)
	_G.NPCFriendshipStatusBarNotch1:SetSize(1, 16)
	_G.NPCFriendshipStatusBarNotch2:SetColorTexture(0, 0, 0)
	_G.NPCFriendshipStatusBarNotch2:SetSize(1, 16)
	_G.NPCFriendshipStatusBarNotch3:SetColorTexture(0, 0, 0)
	_G.NPCFriendshipStatusBarNotch3:SetSize(1, 16)
	_G.NPCFriendshipStatusBarNotch4:SetColorTexture(0, 0, 0)
	_G.NPCFriendshipStatusBarNotch4:SetSize(1, 16)
	select(7, _G.NPCFriendshipStatusBar:GetRegions()):Hide()

	_G.NPCFriendshipStatusBar.icon:SetPoint("TOPLEFT", -30, 7)
	MERS:CreateBDFrame(_G.NPCFriendshipStatusBar, .25)

	GossipFrame:HookScript("OnShow", function()
		C_Timer_After(.01, function()
			local index = 1
			local titleButton = _G["GossipTitleButton"..index]
			while titleButton do
				if titleButton:GetText() ~= nil then
					titleButton:SetText(gsub(titleButton:GetText(), ":32:32:0:0", ":32:32:0:0:64:64:5:59:5:59"))
				end
				index = index + 1
				titleButton = _G["GossipTitleButton"..index]
			end
		end)
	end)

	local function GossipTitleButtonTemplate(Button)
		local highlight = Button:GetHighlightTexture()
		highlight:SetColorTexture(r, g, b, 0.3)
		highlight:SetInside(Button)

		Button:SetSize(300, 16)
		_G[Button:GetName().."GossipIcon"]:SetSize(16, 16)
		_G[Button:GetName().."GossipIcon"]:SetPoint("TOPLEFT", 3, 1)

		local text = Button:GetFontString()
		text:SetSize(257, 0)
		text:SetPoint("LEFT", 20, 0)
		text:SetTextColor(1, 1, 1)
	end

	local prevTitle
	for i = 1, _G.NUMGOSSIPBUTTONS do
		GossipTitleButtonTemplate(_G["GossipTitleButton"..i])

		if not prevTitle then
			_G["GossipTitleButton"..i]:SetPoint("TOPLEFT", _G.GossipGreetingText, "BOTTOMLEFT", -10, -20)
		else
			_G["GossipTitleButton"..i]:SetPoint("TOPLEFT", prevTitle, "BOTTOMLEFT", 0, -3)
		end
		prevTitle = _G["GossipTitleButton"..i]
	end

	local availDataPerQuest, activeDataPerQuest = 7, 6
	hooksecurefunc("GossipFrameAvailableQuestsUpdate", function(...)
		local numAvailQuestsData = select("#", ...)
		local buttonIndex = (GossipFrame.buttonIndex - 1) - (numAvailQuestsData / availDataPerQuest)
		for i = 1, numAvailQuestsData, availDataPerQuest do
			local titleText, _, isTrivial = select(i, ...)
			local titleButton = _G["GossipTitleButton" .. buttonIndex]
			if isTrivial then
				titleButton:SetFormattedText(_G.MER_TRIVIAL_QUEST_DISPLAY, titleText)
			else
				titleButton:SetFormattedText(_G.MER_NORMAL_QUEST_DISPLAY, titleText)
			end
			buttonIndex = buttonIndex + 1
		end
	end)

	hooksecurefunc("GossipFrameActiveQuestsUpdate", function(...)
		local numActiveQuestsData = select("#", ...)
		local buttonIndex = (GossipFrame.buttonIndex - 1) - (numActiveQuestsData / activeDataPerQuest)
		for i = 1, numActiveQuestsData, activeDataPerQuest do
			local titleText, _, isTrivial = select(i, ...)
			local titleButton = _G["GossipTitleButton" .. buttonIndex]
			if isTrivial then
				titleButton:SetFormattedText(_G.MER_TRIVIAL_QUEST_DISPLAY, titleText)
			else
				titleButton:SetFormattedText(_G.MER_NORMAL_QUEST_DISPLAY, titleText)
			end
			buttonIndex = buttonIndex + 1
		end
	end)

	hooksecurefunc("GossipResize", function(titleButton)
		titleButton:SetHeight(titleButton:GetTextHeight() + 4)
	end)
end

S:AddCallback("mUIGossip", styleGossip)
