local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_DataBars")
local DB = E:GetModule("DataBars")

local pairs = pairs

function module:StyleBackdrops()
	for _, bar in pairs(DB.StatusBars) do
		if bar and bar.db.enable then
		end
	end
end

function module:Initialize()
	module.db = E.db.mui.databars

	self:StyleBackdrops()
end

MER:RegisterModule(module:GetName())
