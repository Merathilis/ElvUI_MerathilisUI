local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

-- Cache global variables
-- Lua functions
local print = print
local format = string.format

MER.NewSign = "|TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:14:14|t"

function MER:MismatchText()
	local text = format(L["MSG_MER_ELV_OUTDATED"], MER.ElvUIV, MER.ElvUIX)
	return text
end

function MER:Print(msg)
	print(E["media"].hexvaluecolor..'MUI:|r', msg)
end

function MER:PrintURL(url)
	return format("|cFF00c0fa[|Hurl:%s|h%s|h]|r", url, url)
end

local color = { r = 1, g = 1, b = 1, a = 1 }
function MER:unpackColor(color)
	return color.r, color.g, color.b, color.a
end

local function CreateWideShadow(f)
	local borderr, borderg, borderb = 0, 0, 0
	local backdropr, backdropg, backdropb = 0, 0, 0

	local shadow = f.shadow or CreateFrame('Frame', nil, f) -- This way you can replace current shadows.
	shadow:SetFrameLevel(1)
	shadow:SetFrameStrata(f:GetFrameStrata())
	shadow:SetOutside(f, 6, 6)
	shadow:SetBackdrop( { 
		edgeFile = LSM:Fetch('border', 'ElvUI GlowBorder'), edgeSize = E:Scale(6),
		insets = {left = E:Scale(8), right = E:Scale(8), top = E:Scale(8), bottom = E:Scale(8)},
	})
	shadow:SetBackdropColor(backdropr, backdropg, backdropb, 0)
	shadow:SetBackdropBorderColor(borderr, borderg, borderb, 0.5)
	f.shadow = shadow
end

local function CreateSoftShadow(f)
	local borderr, borderg, borderb = 0, 0, 0
	local backdropr, backdropg, backdropb = 0, 0, 0

	local shadow = f.shadow or CreateFrame('Frame', nil, f) -- This way you can replace current shadows.
	shadow:SetFrameLevel(1)
	shadow:SetFrameStrata(f:GetFrameStrata())
	shadow:SetOutside(f, 2, 2)
	shadow:SetBackdrop( { 
		edgeFile = LSM:Fetch('border', 'ElvUI GlowBorder'), edgeSize = E:Scale(2),
		insets = {left = E:Scale(5), right = E:Scale(5), top = E:Scale(5), bottom = E:Scale(5)},
	})
	shadow:SetBackdropColor(backdropr, backdropg, backdropb, 0)
	shadow:SetBackdropBorderColor(borderr, borderg, borderb, 0.4)
	f.shadow = shadow
end

local function CreateSoftGlow(f)
	if f.sglow then return end

	local borderr, borderg, borderb = 1, 1, .5
	local backdropr, backdropg, backdropb = 1, 1, .5

	local sglow = CreateFrame('Frame', nil, f)
	sglow:SetFrameLevel(1)
	sglow:SetFrameStrata(f:GetFrameStrata())
	sglow:SetOutside(f, 2, 2)
	sglow:SetBackdrop( { 
		edgeFile = LSM:Fetch('border', 'ElvUI GlowBorder'), edgeSize = E:Scale(3),
		insets = {left = E:Scale(5), right = E:Scale(5), top = E:Scale(5), bottom = E:Scale(5)},
	})
	sglow:SetBackdropColor(BUI:unpackColor(E.db.general.valuecolor), 0)
	sglow:SetBackdropBorderColor(BUI:unpackColor(E.db.general.valuecolor), 0.4)
	f.sglow = sglow
end

-- Test Blizz Alerts / AlertFrames
SlashCmdList.TEST_ACHIEVEMENT = function()
	PlaySound("LFG_Rewards")
	if not AchievementFrame then
		AchievementFrame_LoadUI()
	end
	AchievementAlertFrame_ShowAlert(4912)
	AchievementAlertFrame_ShowAlert(6193)
	GuildChallengeAlertFrame_ShowAlert(3, 2, 5)
	CriteriaAlertFrame_ShowAlert(6301, 29918)
	MoneyWonAlertFrame_ShowAlert(9999999)
	LootWonAlertFrame_ShowAlert(select(2, GetItemInfo(6948)) or GetInventoryItemLink("player", 5), -1, 1, 100, 70)
	ChallengeModeAlertFrame_ShowAlert()
	AlertFrame_AnimateIn(ScenarioAlertFrame1)
	AlertFrame_AnimateIn(GarrisonMissionAlertFrame)
	StorePurchaseAlertFrame_ShowAlert(select(3, GetSpellInfo(2060)), GetSpellInfo(2060), 2060)
	LootUpgradeFrame_ShowAlert(select(2, GetItemInfo(6948)) or GetInventoryItemLink("player", 5), 1, 1, 1)
	GarrisonBuildingAlertFrame_ShowAlert(E.myname)
	-- AlertFrame_AnimateIn(GarrisonFollowerAlertFrame)
	AlertFrame_FixAnchors()
end
SLASH_TEST_ACHIEVEMENT1 = "/tav"
