local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local unpack = unpack

local function styleWorldmap()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.worldmap ~= true or E.private.muiSkins.blizzard.worldmap ~= true then return end

	if not WorldMapFrame.stripes then
		MERS:CreateStripes(WorldMapFrame)
	end
end

S:AddCallback("mUISkinWorldMap", styleWorldmap)