local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB('tradeskill', 'tradeskill') then
		return
	end

	local ProfessionsFrame = _G.ProfessionsFrame
	ProfessionsFrame:Styling()
	module:CreateShadow(ProfessionsFrame)

	for _, tab in next, { ProfessionsFrame.TabSystem:GetChildren() } do
		module:ReskinTab(tab)
	end

	module:CreateShadow(ProfessionsFrame.OrdersPage.OrderView.CraftingOutputLog)
	ProfessionsFrame.OrdersPage.OrderView.CraftingOutputLog:Styling()
	module:CreateShadow(ProfessionsFrame.CraftingPage.CraftingOutputLog)
	ProfessionsFrame.CraftingPage.CraftingOutputLog:Styling()

	ProfessionsFrame.CraftingPage.RecipeList.BackgroundNineSlice:SetAlpha(.45)
	ProfessionsFrame.CraftingPage.SchematicForm.Background:SetAlpha(.45)
end

S:AddCallbackForAddon('Blizzard_Professions', LoadSkin)

