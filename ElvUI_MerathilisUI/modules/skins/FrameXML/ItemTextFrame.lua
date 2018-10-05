local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
local _G = _G
local select = select
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleMerchant()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.gossip ~= true or E.private.muiSkins.blizzard.gossip ~= true then return end

	local ItemTextFrame = _G["ItemTextFrame"]
	select(18, ItemTextFrame:GetRegions()):Hide()

	ItemTextFrame:Styling()
end

S:AddCallback("mUIItemText", styleMerchant)