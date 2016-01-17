local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local S = E:GetModule('Skins');

-- Cache global variables
local _G = _G

local function styleSpellBook()
	if E.db.muiSkins == nil then E.db.muiSkins = {} end -- Prevent a nil Error
	if E.db.muiSkins.blizzard == nil then E.db.muiSkins.blizzard = {} end -- Prevent a nil Error
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.spellbook ~= true or E.db.muiSkins.blizzard.spellbook == false then return end
 
	if _G["SpellBookFrame"].pagebackdrop then
		_G["SpellBookFrame"].pagebackdrop:Hide()
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
