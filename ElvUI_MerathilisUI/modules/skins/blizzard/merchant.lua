local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

--Cache global variables
local _G = _G
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleMerchant()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.merchant ~= true or E.private.muiSkins.blizzard.merchant ~= true then return end

	_G["MerchantFrame"]:Styling(true, true)
end

S:AddCallback("mUIMerchant", styleMerchant)