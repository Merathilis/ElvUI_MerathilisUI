local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

--Cache global variables
local _G = _G
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleLoot()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.loot ~= true or E.private.muiSkins.blizzard.loot ~= true then return end

	_G["BonusRollFrame"]:Styling()
	_G["LootHistoryFrame"]:Styling()
end

S:AddCallback("mUILoot", styleLoot)