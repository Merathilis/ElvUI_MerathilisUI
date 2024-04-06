local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G

function module:Blizzard_Professions()
	if not module:CheckDB("tradeskill", "tradeskill") then
		return
	end

	local ProfessionsFrame = _G.ProfessionsFrame
	module:CreateShadow(ProfessionsFrame)

	for _, tab in next, { ProfessionsFrame.TabSystem:GetChildren() } do
		module:ReskinTab(tab)
	end

	module:CreateShadow(ProfessionsFrame.OrdersPage.OrderView.CraftingOutputLog)
	module:CreateShadow(ProfessionsFrame.CraftingPage.CraftingOutputLog)

	ProfessionsFrame.CraftingPage.RecipeList.BackgroundNineSlice:SetAlpha(0.45)
	ProfessionsFrame.CraftingPage.SchematicForm.Background:SetAlpha(0.45)
end

module:AddCallbackForAddon("Blizzard_Professions")
