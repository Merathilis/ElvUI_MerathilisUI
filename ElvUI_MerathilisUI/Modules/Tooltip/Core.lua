local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Tooltip")

function module:Initialize()
	self:InitializeBuffs()
end

MER:RegisterModule(module:GetName())
