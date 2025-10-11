local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnitFrames")

function module:Update_PlayerFrame(frame)
	local db = E.db.mui.unitframes

	if not frame.__MERAnim then
		module:CreateAnimatedBars(frame.Power)
	end

	module:CreateHighlight(frame)
end
