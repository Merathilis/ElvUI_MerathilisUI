local E, L, V, P, G = unpack(ElvUI);
local S = E:GetModule('Skins');

-- Cache global variables
-- Lua functions
local _G = _G
local pairs, unpack = pairs, unpack
-- WoW API / Variables
local SpellBookFrame = _G["SpellBookFrame"]
local SpellBookCoreAbilitiesFrame = _G["SpellBookCoreAbilitiesFrame"]
local SpellBookPageText = _G["SpellBookPageText"]
-- GLOBALS: hooksecurefunc

<<<<<<< HEAD

=======
>>>>>>> legion/master
local function styleSpellBook()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.spellbook ~= true or E.private.muiSkins.blizzard.spellbook ~= true then return end
 
	if SpellBookFrame.pagebackdrop then
		SpellBookFrame.pagebackdrop:Hide()
	end
<<<<<<< HEAD
	
	SpellBookPageText:SetTextColor(unpack(E.media.rgbvaluecolor))
	SpellBookCoreAbilitiesFrame.SpecName:SetTextColor(unpack(E.media.rgbvaluecolor))
	
=======

	SpellBookPageText:SetTextColor(unpack(E.media.rgbvaluecolor))

>>>>>>> legion/master
	local professionheaders = {
		"PrimaryProfession1",
		"PrimaryProfession2",
		"SecondaryProfession1",
		"SecondaryProfession2",
		"SecondaryProfession3",
		"SecondaryProfession4"
	}
<<<<<<< HEAD
	
=======

>>>>>>> legion/master
	for _, header in pairs(professionheaders) do
		_G[header.."Missing"]:SetTextColor(1, 0.8, 0)
		_G[header.."Missing"]:SetShadowColor(0, 0, 0)
		_G[header.."Missing"]:SetShadowOffset(1, -1)
		_G[header].missingText:SetTextColor(0.6, 0.6, 0.6)
	end
<<<<<<< HEAD
	
	hooksecurefunc("SpellBook_UpdateCoreAbilitiesTab", function()
		for i = 1, #SpellBookCoreAbilitiesFrame.Abilities do
			local button = SpellBookCoreAbilitiesFrame.Abilities[i]
			if button and button.isSkinned ~= true then

				button.EmptySlot:SetAlpha(0)
				button.ActiveTexture:SetAlpha(0)
				button.FutureTexture:SetAlpha(0)

				button.iconTexture:SetInside()

				if button.FutureTexture:IsShown() then
					button.iconTexture:SetDesaturated(true)
					button.Name:SetTextColor(0.6, 0.6, 0.6)
					button.InfoText:SetTextColor(0.6, 0.6, 0.6)
				else
					button.Name:SetTextColor(1, 0.82, 0)
					button.InfoText:SetTextColor(0.8, 0.8, 0.8)
				end
				
				button.isSkinned = true
			end
=======

	hooksecurefunc("SpellButton_UpdateButton", function(self)
		if self.SpellSubName then
			self.SpellSubName:SetTextColor(unpack(E.media.rgbvaluecolor))
>>>>>>> legion/master
		end
	end)
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "ElvUI_MerathilisUI" then
		E:Delay(1, styleSpellBook)
		self:UnregisterEvent("ADDON_LOADED")
	end
end)
