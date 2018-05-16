local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions

--WoW API / Variables

--Global variables that we don't cache, list them here for mikk's FindGlobals script
-- GLOBALS:

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.lfguild ~= true or E.private.muiSkins.blizzard.lfguild ~= true then return end

	local function SkinLFGuild(self)
		self:Styling()
	end
	hooksecurefunc("LookingForGuildFrame_OnShow", SkinLFGuild)
end

S:AddCallbackForAddon("Blizzard_LookingForGuildUI", "mUILookingForGuild", LoadSkin)