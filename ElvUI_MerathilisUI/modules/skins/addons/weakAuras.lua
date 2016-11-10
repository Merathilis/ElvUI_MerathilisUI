local E, L, V, P, G = unpack(ElvUI);

-- Cache global variables
-- Lua functions
local pairs, select, unpack = pairs, select, unpack
-- WoW API / Variables
local IsAddOnLoaded = IsAddOnLoaded
-- GLOBALS: WeakAuras

-- WEAKAURAS SKIN
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(self, event)
	if not IsAddOnLoaded("WeakAuras") or not E.private.muiSkins.addonSkins.wa then return end

	local function Skin_WeakAuras(frame)
		if frame.icon then
			frame.icon:SetTexCoord(unpack(E.TexCoords))
			frame.icon.SetTexCoord = function() end
		end

		if frame.bar then
			frame.bar.fg:SetTexture(E["media"].normTex)
			frame.bar.bg:SetTexture(E["media"].blankTex)
		end

		if frame.stacks then
			frame.stacks:SetFont(E["media"].normFont, select(2, frame.stacks:GetFont()), "OUTLINE")
			frame.stacks:SetShadowOffset(0, -0)
		end

		if frame.timer then
			frame.timer:SetFont(E["media"].normFont, select(2, frame.timer:GetFont()), "OUTLINE")
			frame.timer:SetShadowOffset(0, -0)
		end

		if frame.text then
			frame.text:SetFont(E["media"].normFont, select(2, frame.text:GetFont()), "OUTLINE")
			frame.text:SetShadowOffset(0, -0)
		end
	end

	for weakAura, _ in pairs(WeakAuras.regions) do
		if WeakAuras.regions[weakAura].regionType == "icon" or WeakAuras.regions[weakAura].regionType == "aurabar" then
			Skin_WeakAuras(WeakAuras.regions[weakAura].region)
		end
	end
end)