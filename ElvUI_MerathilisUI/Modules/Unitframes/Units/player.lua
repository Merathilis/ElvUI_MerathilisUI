local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnitFrames")

function module:Update_PlayerFrame(frame)
	local db = E.db.mui.unitframes

	module:CreateHighlight(frame)

	if E.db.mui.portraits.general.enable then
		if E.db.mui.portraits.player.enable then
			module:CreatePortraits("Player", "player", _G.ElvUF_Player, E.db.mui.portraits.player)
		else
			module:RemovePortraits(frame)
		end
	end
end
