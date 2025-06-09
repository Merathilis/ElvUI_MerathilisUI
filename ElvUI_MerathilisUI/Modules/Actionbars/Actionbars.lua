local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Actionbars")

function module:Initialize()
	if not E.private.actionbar.enable then
		return
	end

	local db = E.db.mui.actionbars

	self:CreateSpecBar()
	self:ColorModifiers()
end

MER:RegisterModule(module:GetName())
