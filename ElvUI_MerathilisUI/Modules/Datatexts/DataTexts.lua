local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.DataTexts
local DT = E:GetModule('DataTexts')

local _G = _G

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc

function module:LoadDataTexts()
	if not E.db.mui.datatexts then return end

end

function module:Initialize()
	module.db = E.db.mui.datatexts

	-- self:LoadDataTexts()
end

MER:RegisterModule(module:GetName())
