local E, L, V, P, G = unpack(ElvUI);
local S = E:GetModule('Skins');

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API / Variables
local IsAddOnLoaded = IsAddOnLoaded

local function styleGlyph()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.talent ~= true or E.private.muiSkins.blizzard.glyph ~= true then return end
	
	if _G["GlyphFrameBackground"] then
		_G["GlyphFrameBackground"]:Hide()
	end
	
	if IsAddOnLoaded("AddOnSkins") and _G["GlyphFrame"].Backdrop then
		_G["GlyphFrame"].Backdrop:Hide()
	end

	_G["PlayerTalentFrameInset"].backdrop.Show = function() end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "Blizzard_GlyphUI" then
		styleGlyph()
		self:UnregisterEvent("ADDON_LOADED")
	end
end)
