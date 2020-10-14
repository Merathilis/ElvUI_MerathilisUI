local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

--Cache global variables
--Lua functions
local _G = _G
--WoW API / Variables
-- GLOBALS:

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.azeriteRespec ~= true or E.private.muiSkins.blizzard.AzeriteRespec ~= true then return end

	local AzeriteRespecFrame = _G.AzeriteRespecFrame
	AzeriteRespecFrame:Styling()
end

S:AddCallbackForAddon("Blizzard_AzeriteRespecUI", "mUIAzeriteRespec", LoadSkin)
