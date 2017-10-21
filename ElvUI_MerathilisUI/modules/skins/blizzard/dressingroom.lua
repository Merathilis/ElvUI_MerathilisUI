local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

local function styleDressingroom()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.dressingroom ~= true or E.private.muiSkins.blizzard.dressingroom ~= true then return end

	MERS:CreateGradient(DressUpFrame)
	MERS:CreateStripes(DressUpFrame)

	-- Wardrobe edit frame
	MERS:CreateGradient(WardrobeOutfitFrame)
	MERS:CreateStripes(WardrobeOutfitFrame)
end

S:AddCallback("mUIDressingRoom", styleDressingroom)