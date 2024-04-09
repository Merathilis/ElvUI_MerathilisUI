local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnitFrames")
local UF = E:GetModule("UnitFrames")

local hooksecurefunc = hooksecurefunc

function module:Update_TargetFrame(frame)
	local db = E.db.mui.unitframes

	module:CreateHighlight(frame)
end

function module:InitTarget()
	if not E.db.unitframe.units.target.enable then
		return
	end

	hooksecurefunc(UF, "Update_TargetFrame", module.Update_TargetFrame)
end
