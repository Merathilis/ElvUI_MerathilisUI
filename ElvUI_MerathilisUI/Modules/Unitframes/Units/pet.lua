local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnitFrames")

function module:Update_PetFrame(frame)
	local db = E.db.mui.unitframes

	module:CreateHighlight(frame)

	if E.db.mui.portraits.general.enable then
		if E.db.mui.portraits.pet.enable then
			module:CreatePortraits("Pet", "pet", _G.ElvUF_Pet, E.db.mui.portraits.pet)
		else
			module:RemovePortraits(frame)
		end
	end
end
