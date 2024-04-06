local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule("Skins")

function module:UIDropDownMenu()
	if not module:CheckDB("misc", "misc") then
		return
	end
end

S:AddCallback("UIDropDownMenu")
