local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

--Cache global variables
local _G = _G
--WoW API / Variables
-- GLOBALS:

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.dressingroom ~= true or E.private.muiSkins.blizzard.dressingroom ~= true then return end

	_G.DressUpFrame:Styling()

	-- Wardrobe edit frame
	_G.WardrobeOutfitFrame:Styling()

	-- AuctionHouse
	_G.SideDressUpFrame:Styling()
end

S:AddCallback("mUIDressingRoom", LoadSkin)
