local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_DelvesCompanionConfiguration()
	local CompanionConfigurationFrame = _G.DelvesCompanionConfigurationFrame
	module:CreateShadow(CompanionConfigurationFrame)

	local CompanionAbilityListFrame = _G.DelvesCompanionAbilityListFrame
	module:CreateShadow(CompanionAbilityListFrame)
end

module:AddCallbackForAddon("Blizzard_DelvesCompanionConfiguration")

function module:Blizzard_DelvesDashboardUI() end

module:AddCallbackForAddon("Blizzard_DelvesDashboardUI")

function module:Blizzard_DelvesDifficultyPicker() end

module:AddCallbackForAddon("Blizzard_DelvesDifficultyPicker")
