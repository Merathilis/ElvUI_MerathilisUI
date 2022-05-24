local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.objectiveTracker ~= true or E.private.mui.skins.blizzard.objectiveTracker ~= true then return end

end

--S:AddCallback("mUIObjectiveTracker", LoadSkin)
