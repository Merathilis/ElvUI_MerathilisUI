local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G

-- WoW API

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleIslands()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.IslandQueue ~= true or E.private.muiSkins.blizzard.IslandQueue ~= true then return end

	local IslandsQueueFrame = _G["IslandsQueueFrame"]
	IslandsQueueFrame:Styling()

	IslandsQueueFrame.HelpButton:Hide()
end

S:AddCallbackForAddon("Blizzard_IslandsQueueUI", "mUIIslands", styleIslands)