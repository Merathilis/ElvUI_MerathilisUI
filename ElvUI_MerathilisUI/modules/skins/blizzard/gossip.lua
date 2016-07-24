local E, L, V, P, G = unpack(ElvUI);
local S = E:GetModule('Skins');

-- Cache global variables
-- Lua functions
-- WoW API / Variables
-- GLOBALS: hooksecurefunc

local function styleGossip()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.gossip ~= true or E.private.muiSkins.blizzard.gossip ~= true then return; end
	
	GossipGreetingScrollFrame:StripTextures()
	GossipGreetingText:SetTextColor(1, 1, 1)

	for i = 1, NUMGOSSIPBUTTONS do
		obj = select(3, _G['GossipTitleButton'..i]:GetRegions())
		obj:SetTextColor(1, 1, 1)
	end

	hooksecurefunc('GossipFrameUpdate', function()
		for i = 1, NUMGOSSIPBUTTONS do
			local button = _G['GossipTitleButton'..i]
			if button:GetFontString() then
				if button:GetFontString():GetText() and button:GetFontString():GetText():find('|cff000000') then
					button:GetFontString():SetText(string.gsub(button:GetFontString():GetText(), '|cff000000', '|cffFFFF00'))
				end
			end
		end
	end)
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "ElvUI_MerathilisUI" then
		E:Delay(1, styleGossip)
		self:UnregisterEvent("ADDON_LOADED")
	end
end)