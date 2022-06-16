local MER, F, E, _, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Actionbars')

function module:Initialize()
	if not E.private.actionbar.enable then
		return
	end

	local db = E.db.mui.actionbars

	if E.Retail then
		self:EquipSpecBar()
	end
end

MER:RegisterModule(module:GetName())
