local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G
local unpack = unpack
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: hooksecurefunc

local function stylePVE()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.lfg ~= true or E.private.muiSkins.blizzard.lfg ~= true then return; end

	local PVEFrame = _G["PVEFrame"]
	PVEFrame:Styling()

	for i = 1, 4 do
		local bu = _G["GroupFinderFrame"]["groupButton"..i]

		bu.icon:Size(54)
		bu.icon:SetDrawLayer("OVERLAY")
		bu.icon:ClearAllPoints()
		bu.icon:SetPoint("LEFT", bu, "LEFT", 4, 0)
	end
end

S:AddCallback("mUIPVE", stylePVE)