local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Tooltip")

function module:Initialize()
	self:InitializeBuffs()
	self:InitializeAchievement()
	self:InitializeUpgradeTrack()
end

function module:ProfileUpdate()
	self:UpdateBuffs()
	self:InitializeAchievement()
	self:InitializeUpgradeTrack()
end

MER:RegisterModule(module:GetName())
