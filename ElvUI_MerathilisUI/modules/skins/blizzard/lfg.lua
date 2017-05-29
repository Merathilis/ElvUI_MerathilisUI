local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")
local MERS = E:GetModule("muiSkins")

--Cache global variables
--Lua functions

--WoW API / Variables

local function styleLFG()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.lfg ~= true then return end

	if not PVEFrame.stripes then
		MERS:CreateStripes(PVEFrame)
	end
end

S:AddCallback("mUILFG", styleLFG)