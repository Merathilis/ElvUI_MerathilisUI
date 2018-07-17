local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

function MERS.SocialToastTemplate(ContainedAlertFrame)

end

local function styleBNet()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.misc ~= true then return end

	--MERS.SocialToastTemplate(_G["BNToastFrame"])

	_G["BNToastFrame"]:Styling()
end

S:AddCallback("mUIBNet", styleBNet)