local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

--Cache global variables
local _G = _G
--WoW API / Variables
-- GLOBALS:

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.guildcontrol ~= true or E.private.muiSkins.blizzard.guildcontrol ~= true then return end

	_G.GuildControlUI:Styling()
end

S:AddCallbackForAddon("Blizzard_GuildControlUI", "mUIGuildControl", LoadSkin)
