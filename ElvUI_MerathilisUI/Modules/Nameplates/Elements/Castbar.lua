local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local MNP = MER:GetModule("MER_NamePlates")
local NP = E:GetModule("NamePlates")

local _G = _G

function MNP:Construct_Castbar(nameplate)
	local Castbar = _G[nameplate:GetDebugName() .. "Castbar"]
end
-- hooksecurefunc(NP, "Construct_Castbar", MNP.Construct_Castbar)
