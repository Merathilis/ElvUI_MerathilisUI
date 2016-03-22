local E, L, V, P, G = unpack(ElvUI);
local S = E:GetModule('Skins');

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API / Variables
local SpellBookFrame = _G["SpellBookFrame"]


local function styleSpellBook()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.spellbook ~= true or E.private.muiSkins.blizzard.spellbook ~= true then return; end
 
	if SpellBookFrame.pagebackdrop then
		SpellBookFrame.pagebackdrop:Hide()
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "ElvUI_MerathilisUI" then
		E:Delay(1, styleSpellBook)
		self:UnregisterEvent("ADDON_LOADED")
	end
end)
