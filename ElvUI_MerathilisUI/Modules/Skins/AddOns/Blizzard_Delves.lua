local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local _G = _G

function module:Blizzard_DelvesCompanionConfiguration()
	if not self:CheckDB("lfg", "delves") then
		return
	end

	local CompanionConfigurationFrame = _G.DelvesCompanionConfigurationFrame
	if CompanionConfigurationFrame then
		self:CreateShadow(CompanionConfigurationFrame)
		CompanionConfigurationFrame.CloseButton:ClearAllPoints()
		CompanionConfigurationFrame.CloseButton:SetPoint("TOPRIGHT", CompanionConfigurationFrame, "TOPRIGHT", -3, -3)

		for _, frame in pairs({
			CompanionConfigurationFrame.CompanionCombatRoleSlot,
			CompanionConfigurationFrame.CompanionUtilityTrinketSlot,
			CompanionConfigurationFrame.CompanionCombatTrinketSlot,
		}) do
			self:CreateShadow(frame.OptionsList)
			self:HighAlphaTransparent(frame.OptionsList)
		end
	end

	local CompanionAbilityListFrame = _G.DelvesCompanionAbilityListFrame
	if CompanionAbilityListFrame then
		self:CreateShadow(CompanionAbilityListFrame)
	end
end

module:AddCallbackForAddon("Blizzard_DelvesCompanionConfiguration")

function module:Blizzard_DelvesDashboardUI() end

module:AddCallbackForAddon("Blizzard_DelvesDashboardUI")

local function HandleRewards(self)
	for rewardFrame in self.rewardPool:EnumerateActive() do
		if not rewardFrame.backdrop then
			rewardFrame:CreateBackdrop("Transparent")
			rewardFrame.NameFrame:SetAlpha(0)
			S:HandleIcon(rewardFrame.Icon, true)
			S:HandleIconBorder(rewardFrame.IconBorder, rewardFrame.Icon.backdrop)
		end
	end
end

function module:Blizzard_DelvesDifficultyPicker()
	if not self:CheckDB("lfg", "delves") then
		return
	end

	local DifficultyPickerFrame = _G.DelvesDifficultyPickerFrame
	if DifficultyPickerFrame then
		self:CreateShadow(DifficultyPickerFrame)
		DifficultyPickerFrame.CloseButton:ClearAllPoints()
		DifficultyPickerFrame.CloseButton:SetPoint("TOPRIGHT", DifficultyPickerFrame, "TOPRIGHT", -3, -3)

		DifficultyPickerFrame.DelveRewardsContainerFrame:HookScript("OnShow", HandleRewards)
		hooksecurefunc(DifficultyPickerFrame.DelveRewardsContainerFrame, "SetRewards", HandleRewards)
	end
end

module:AddCallbackForAddon("Blizzard_DelvesDifficultyPicker")
