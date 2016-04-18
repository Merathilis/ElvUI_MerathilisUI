local E, L, V, P, G = unpack(ElvUI);
local S = E:GetModule('Skins');

local function styleGlyph()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.talent ~= true or E.private.muiSkins.blizzard.glyph ~= true then return end
	
	if GlyphFrameBackground then
		GlyphFrameBackground:Hide()
	end
	
	if IsAddOnLoaded("AddOnSkins") and GlyphFrame.Backdrop then
		GlyphFrame.Backdrop:Hide()
	end

	PlayerTalentFrameInset.backdrop.Show = function() end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "Blizzard_GlyphUI" then
		styleGlyph()
		self:UnregisterEvent("ADDON_LOADED")
	end
end)
