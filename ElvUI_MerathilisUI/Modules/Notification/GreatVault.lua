local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Notification")

local _G = _G
local InCombatLockdown = InCombatLockdown
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local LoadAddOn = C_AddOns.LoadAddOn
local HasAvailableRewards = C_WeeklyRewards and C_WeeklyRewards.HasAvailableRewards

local GREAT_VAULT_ATLAS = "greatVault-whole-normal"
local hasVaultRewards = false

local function ToggleGreatVault()
	if not IsAddOnLoaded("Blizzard_WeeklyRewards") then
		LoadAddOn("Blizzard_WeeklyRewards")
	end

	if _G.WeeklyRewardsFrame then
		_G.WeeklyRewardsFrame:SetShown(not _G.WeeklyRewardsFrame:IsShown())
	end
end

function module:WEEKLY_REWARDS_UPDATE()
	local db = E.db.mui.notification
	if not db or not db.enable or not db.greatVault or InCombatLockdown() then
		return
	end

	if not HasAvailableRewards then
		return
	end

	local available = HasAvailableRewards()
	if hasVaultRewards == available then
		return
	end

	hasVaultRewards = available
	if not hasVaultRewards then
		return
	end

	self:DisplayToast(L["Great Vault"], L["Your Great Vault has rewards ready to claim!"], ToggleGreatVault, GREAT_VAULT_ATLAS)
end
