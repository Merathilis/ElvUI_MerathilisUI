local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

function module:UIDropDownMenu()
	if not module:CheckDB("misc", "misc") then
		return
	end
end

module:AddCallback("UIDropDownMenu")
