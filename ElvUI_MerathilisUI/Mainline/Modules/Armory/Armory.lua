local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Armory')


function module:Initialize()
	module.db = E.db.mui.armory
	MER:RegisterDB(self, "armory")

end

MER:RegisterModule(module:GetName())
