local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

function module:UIDropDownMenu()
	if not module:CheckDB("misc", "misc") then
		return
	end
end

S:AddCallback("UIDropDownMenu")
