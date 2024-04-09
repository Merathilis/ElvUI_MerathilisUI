local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

function module:PaperDollFrame()
	if not module:CheckDB("character", "character") then
		return
	end
end

module:AddCallback("PaperDollFrame")
