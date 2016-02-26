local E, L, V, P, G = unpack(ElvUI);
local S = E:GetModule('Skins');

-- Cache global variables
local _G = _G

local function styleSpellBook()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.spellbook ~= true or E.private.mui.skins.blizzard.spellbook ~= true then return; end
 
	if _G["SpellBookFrame"].pagebackdrop then
		_G["SpellBookFrame"].pagebackdrop:Hide()
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
