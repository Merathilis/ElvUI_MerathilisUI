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

	for i = 1, NUMGOSSIPBUTTONS do
		obj = select(3, _G["GossipTitleButton"..i]:GetRegions())
		obj:SetTextColor(1, 1, 1)
	end

	hooksecurefunc("GossipFrameUpdate", function()
		for i = 1, NUMGOSSIPBUTTONS do
			local button = _G["GossipTitleButton"..i]
			if button:GetFontString() then
				if button:GetFontString():GetText() and button:GetFontString():GetText():find("|cff000000") then
					button:GetFontString():SetText(gsub(button:GetFontString():GetText(), "|cff000000", "|cffFFFF00"))
				end
			end
		end
	end)
end

S:AddCallback("mUIGossip", styleGossip)