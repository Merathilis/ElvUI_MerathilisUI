local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G

function module:Blizzard_Professions()
	if not module:CheckDB("tradeskill", "tradeskill") then
		return
	end

	local ProfessionsFrame = _G.ProfessionsFrame
	module:CreateShadow(ProfessionsFrame)
	module:CreateShadow(ProfessionsFrame.OrdersPage.OrderView.CraftingOutputLog)
	module:CreateShadow(ProfessionsFrame.CraftingPage.CraftingOutputLog)

	for _, tab in next, { ProfessionsFrame.TabSystem:GetChildren() } do
		module:ReskinTab(tab)
	end

	ProfessionsFrame.CraftingPage.RecipeList.BackgroundNineSlice:SetAlpha(0.45)
	ProfessionsFrame.CraftingPage.SchematicForm.Background:SetAlpha(0.45)

	local function reskinChild(child)
		if child.NineSlice and child.NineSlice.template == "Transparent" then
			self:CreateShadow(child.NineSlice)
		end
	end

	hooksecurefunc("ToggleProfessionsItemFlyout", function()
		local SchematicForm = ProfessionsFrame.CraftingPage and ProfessionsFrame.CraftingPage.SchematicForm
		if SchematicForm then
			for _, child in next, { SchematicForm:GetChildren() } do
				if child.InitializeContents then
					E:Delay(0.05, reskinChild, child)
					hooksecurefunc(child, "InitializeContents", reskinChild)
				end
			end
		end
	end)
end

module:AddCallbackForAddon("Blizzard_Professions")
