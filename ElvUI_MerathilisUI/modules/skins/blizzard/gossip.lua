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
		for i = 1, NUMGOSSIPBUTTONS do
			local text = _G["GossipTitleButton" .. i]:GetText()
			if text then
				text = gsub(text, "|cff......", "|cffffffff")
				_G["GossipTitleButton"..i]:SetText(text)
			end
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