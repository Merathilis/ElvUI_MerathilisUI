local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_DelvesCompanionConfiguration()
	if not self:CheckDB("lfg", "delves") then
		return
	end

	local CompanionConfigurationFrame = _G.DelvesCompanionConfigurationFrame
	module:CreateShadow(CompanionConfigurationFrame)

	local CompanionAbilityListFrame = _G.DelvesCompanionAbilityListFrame
	module:CreateShadow(CompanionAbilityListFrame)
end

module:AddCallbackForAddon("Blizzard_DelvesCompanionConfiguration")

function module:Blizzard_DelvesDashboardUI() end

module:AddCallbackForAddon("Blizzard_DelvesDashboardUI")

function module:Blizzard_DelvesDifficultyPicker()
	if not self:CheckDB("lfg", "delves") then
		return
	end

	local DifficultyPickerFrame = _G.DelvesDifficultyPickerFrame
	if DifficultyPickerFrame then
		self:CreateShadow(DifficultyPickerFrame)
		DifficultyPickerFrame.CloseButton:ClearAllPoints()
		DifficultyPickerFrame.CloseButton:SetPoint("TOPRIGHT", DifficultyPickerFrame, "TOPRIGHT", -3, -3)
	end
end

module:AddCallbackForAddon("Blizzard_DelvesDifficultyPicker")
