local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule("Skins")


local function LoadSkin()
	if not module:CheckDB("character", "character") then
		return
	end

	-- _G.GearManagerDialogPopup:Styling()
end

S:AddCallback("PaperDollFrame", LoadSkin)
