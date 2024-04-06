local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.DataTexts

function module:LoadDataTexts()
	if not E.db.mui.datatexts then
		return
	end
end

function module:Initialize()
	module.db = E.db.mui.datatexts

	-- self:LoadDataTexts()
end

MER:RegisterModule(module:GetName())
