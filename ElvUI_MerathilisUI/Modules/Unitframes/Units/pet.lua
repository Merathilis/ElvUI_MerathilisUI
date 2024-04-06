local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnitFrames")
local UF = E:GetModule("UnitFrames")

local hooksecurefunc = hooksecurefunc

function module:Update_PetFrame(frame)
	local db = E.db.mui.unitframes

	module:CreateHighlight(frame)
end
