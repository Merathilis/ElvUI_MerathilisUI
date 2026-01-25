local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnitFrames")
local UF = E:GetModule("UnitFrames")

local hooksecurefunc = hooksecurefunc

function module:Update_TargetFrame(frame)
	local db = E.db.mui.unitframes

	module:CreateHighlight(frame)

	if E.db.mui.portraits.general.enable then
		if E.db.mui.portraits.target.enable then
			module:CreatePortraits(
				"Target",
				"target",
				_G.ElvUF_Target,
				E.db.mui.portraits.target,
				{ "PLAYER_TARGET_CHANGED" }
			)
		else
			module:RemovePortraits(frame)
		end
	end
end

function module:InitTarget()
	if not E.db.unitframe.units.target.enable then
		return
	end

	hooksecurefunc(UF, "Update_TargetFrame", module.Update_TargetFrame)
end
