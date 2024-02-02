local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local module = MER:GetModule('MER_Actionbars')
local AB = E:GetModule("ActionBars")



function module:Initialize()
	if not E.private.actionbar.enable then
		return
	end

	local db = E.db.mui.actionbars

	self:CreateSpecBar()
	self:ColorModifiers()
end

MER:RegisterModule(module:GetName())
