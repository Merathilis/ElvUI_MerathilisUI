local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnitFrames")

function module:Update_TargetTargetFrame(frame)
	module:CreateHighlight(frame)
end
