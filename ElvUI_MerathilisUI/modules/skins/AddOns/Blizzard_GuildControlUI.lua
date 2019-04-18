local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

--Cache global variables
local _G = _G
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleGuildControlUI()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.guildcontrol ~= true or E.private.muiSkins.blizzard.guildcontrol ~= true then return end

	_G.GuildControlUI:Styling()
end

S:AddCallbackForAddon("Blizzard_GuildControlUI", "mUIGuildControl", styleGuildControlUI)
