local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Actionbars")

function module:Initialize()
	if not E.private.actionbar.enable then
		return
	end

	self:CreateSpecBar()
	self:CreateAssistedRotation()
end

MER:RegisterModule(module:GetName())
