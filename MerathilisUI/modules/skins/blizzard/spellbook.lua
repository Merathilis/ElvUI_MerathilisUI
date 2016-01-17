local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local S = E:GetModule('Skins');

local function styleSpellBook()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.spellbook ~= true then return end
 
	if SpellBookFrame.pagebackdrop then
		SpellBookFrame.pagebackdrop:Hide()
	else
		E:Delay(.1, styleSpellBook)
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "MerathilisUI" then
		styleSpellBook()
		self:UnregisterEvent("ADDON_LOADED")
	end
end)
