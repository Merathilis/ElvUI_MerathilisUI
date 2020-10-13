local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G
local select = select
local strmatch = strmatch
local gsub = string.gsub

local hooksecurefunc = hooksecurefunc


local function ReplaceGossipFormat(button, textFormat, text)
	local newFormat, count = gsub(textFormat, "000000", "ffffff")
	if count > 0 then
		button:SetFormattedText(newFormat, text)
	end
end

local ReplacedGossipColor = {
	["000000"] = "ffffff",
	["414141"] = "7b8489", -- lighter color for some gossip options
}

local function ReplaceGossipText(button, text)
	if text and text ~= "" then
		local newText, count = gsub(text, ":32:32:0:0", ":32:32:0:0:64:64:5:59:5:59") -- replace icon texture
		if count > 0 then
			text = newText
			button:SetFormattedText("%s", text)
		end

		local colorStr, rawText = strmatch(text, "|c[fF][fF](%x%x%x%x%x%x)(.-)|r")
		colorStr = ReplacedGossipColor[colorStr]
		if colorStr and rawText then
			button:SetFormattedText("|cff%s%s|r", colorStr, rawText)
		end
	end
end

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.gossip ~= true or E.private.muiSkins.blizzard.gossip ~= true then return; end

	local GossipFrame = _G.GossipFrame
	GossipFrame:Styling()

	_G.GossipGreetingScrollFrame:StripTextures()

	if _G.GossipFrameInset then
		_G.GossipFrameInset:Hide() -- Parchment
	end

	if GossipFrame.Background then
		GossipFrame.Background:Hide()
	end

	if _G.GossipGreetingScrollFrame.backdrop then
		_G.GossipGreetingScrollFrame.backdrop:Hide()
	end

	_G.QuestFont:SetTextColor(1, 1, 1)

	hooksecurefunc("GossipFrameUpdate", function()
		for button in GossipFrame.titleButtonPool:EnumerateActive() do
			if not button.styled then
				ReplaceGossipText(button, button:GetText())
				hooksecurefunc(button, "SetText", ReplaceGossipText)
				hooksecurefunc(button, "SetFormattedText", ReplaceGossipFormat)

				button.styled = true
			end
		end
	end)

	for i = 1, 4 do
		local notch = _G["NPCFriendshipStatusBarNotch"..i]
		if notch then
			notch:SetColorTexture(0, 0, 0)
			notch:SetSize(E.mult, 16)
		end
	end
	select(7, _G.NPCFriendshipStatusBar:GetRegions()):Hide()

	_G.NPCFriendshipStatusBar.icon:SetPoint("TOPLEFT", -30, 7)
	MERS:CreateBDFrame(_G.NPCFriendshipStatusBar, .25)

	MER.NPC:Register(GossipFrame)
	hooksecurefunc("GossipTitleButton_OnClick", function() MER.NPC:PlayerTalksFirst() end)
end

S:AddCallback("mUIGossip", LoadSkin)
