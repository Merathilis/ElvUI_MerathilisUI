local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleAddonManager()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.addonManager ~= true or E.private.muiSkins.blizzard.addonManager ~= true then return end

	_G["AddonList"]:Styling(true, true)

	_G["AddonCharacterDropDown"]:SetWidth(170)
end

S:AddCallback("mUIAddonManager", styleAddonManager)