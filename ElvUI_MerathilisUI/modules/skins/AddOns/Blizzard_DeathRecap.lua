local MER, E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G
--WoW API / Variables
-- GLOBALS:

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.deathRecap ~= true or E.private.muiSkins.blizzard.deathRecap ~= true then return end

	local DeathRecapFrame = _G.DeathRecapFrame
	DeathRecapFrame:Styling()
end

S:AddCallbackForAddon("Blizzard_DeathRecap", "muiDeathRecap", LoadSkin)
