local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins


function module:PaperDollFrame()
	if not module:CheckDB("character", "character") then
		return
	end
end

module:AddCallback("PaperDollFrame")
