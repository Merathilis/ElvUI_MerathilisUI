local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Actionbars")

function module:Initialize()
	if not F.IsElvUIActionBarsEnabled() then
		return
	end

	self:CreateSpecBar()
	self:CreateAssistedRotation()
end

MER:RegisterModule(module:GetName())
