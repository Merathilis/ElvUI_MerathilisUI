local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

function module:DetailsIcons()
	if not E:IsAddOnEnabled("Details") then
		return
	end

	local iconsPath = I.General.MediaPath .. "Textures\\Details\\"
	local logoPath = I.General.MediaPath .. "Textures\\mUI1.tga"
	local coords = { 0, 1, 0, 1 }

	Details:AddCustomIconSet(iconsPath .. "details_roles.tga", MER.Title, false, logoPath, coords)
	Details:AddCustomIconSet(iconsPath .. "details_white.tga", MER.Title .. "white", false, logoPath, coords)
end

module:AddCallback("DetailsIcons")
