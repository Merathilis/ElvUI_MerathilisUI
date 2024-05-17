local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local _G = _G
local format = string.format
local pairs = pairs
local pcall = pcall
local tinsert = table.insert

local GetAddOnMetadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata
local GetBuildInfo = GetBuildInfo
local GetMaxLevelForPlayerExpansion = GetMaxLevelForPlayerExpansion
local InCombatLockdown = InCombatLockdown

local C_CVar_GetCVarBool = C_CVar.GetCVarBool
local C_LFGList_IsPlayerAuthenticatedForLFG = C_LFGList.IsPlayerAuthenticatedForLFG
local C_LFGList_GetPlaystyleString = C_LFGList.GetPlaystyleString
local C_LFGList_GetLfgCategoryInfo = C_LFGList.GetLfgCategoryInfo

MER.dummy = function()
	return
end
MER.ElvUIVersion = tonumber(E.version)
MER.RequiredVersion = tonumber(GetAddOnMetadata("ElvUI_MerathilisUI", "X-ElvUIVersion"))

MER.IsRetail = select(4, GetBuildInfo()) >= 100206
MER.IsNewPatch = select(4, GetBuildInfo()) >= 100000 -- 10.0
MER.IsPTR = select(4, GetBuildInfo()) == 100002 -- 10.0.2

MER.Locale = GetLocale()
MER.ChineseLocale = strsub(MER.Locale, 0, 2) == "zh"
MER.MaxLevelForPlayerExpansion = GetMaxLevelForPlayerExpansion()
MER.MetaFlavor = GetAddOnMetadata("ElvUI_MerathilisUI", "X-Flavor")

-- Masque support
MER.MSQ = _G.LibStub("Masque", true)

MER.Logo = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\mUI.tga]]
MER.LogoSmall = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\mUI1.tga]]

MER.ClassColor = _G.RAID_CLASS_COLORS[E.myclass]

MER.LeftButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:230:307|t "
MER.RightButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:333:411|t "
MER.ScrollButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:127:204|t "

MER.RegisteredModules = {}
MER.Changelog = {}

MER.UseKeyDown = C_CVar_GetCVarBool("ActionButtonUseKeyDown")

-- Config Helper
MER.Values = {
	FontFlags = E.Libs.ACH.FontValues,
}

local LBG = LibStub("LibButtonGlow-1.0")
F.ShowOverlayGlow = LBG.ShowOverlayGlow
F.HideOverlayGlow = LBG.HideOverlayGlow

if not E.Retail then
	E.PopupDialogs.WRONGWOWVERSION = {
		text = MER.Title
			.. L[" does not support this game version, please uninstall it and don't ask for support. Thanks!"],
		--button1 = OKAY,
		timeout = 0,
		whileDead = 1,
		hideOnEscape = false,
	}
	E:StaticPopup_Show("WRONGWOWVERSION")
end

E.PopupDialogs.MERATHILISUI_BUTTON_FIX_RELOAD = {
	text = format(
		"%s\n%s\n\n|cffaaaaaa%s|r",
		format(L["%s detects CVar %s has been changed."], MER.Title, "|cff209ceeActionButtonUseKeyDown|r"),
		L["It will cause some buttons not work properly before UI reloading."],
		format(
			L["You can disable this alert in [%s]-[%s]-[%s]"],
			MER.Title,
			L["Advanced Settings"],
			L["Blizzard Fixes"]
		)
	),
	button1 = L["Reload UI"],
	button2 = _G.CANCEL,
	OnAccept = _G.ReloadUI,
}

_G.BINDING_HEADER_MER = "|cffff7d0aMerathilisUI|r"
for i = 1, 5 do
	_G["BINDING_HEADER_AUTOBUTTONBAR" .. i] = L["Auto Button Bar" .. " " .. i]
	for j = 1, 12 do
		_G[format("BINDING_NAME_CLICK AutoButtonBar%dButton%d:LeftButton", i, j)] = L["Button"] .. " " .. j
	end
end

-- Register own Modules
function MER:RegisterModule(name)
	if not name then
		F.Developer.ThrowError("The name of module is required!")
		return
	end

	if self.initialized then
		self:GetModule(name):Initialize()
	else
		tinsert(self.RegisteredModules, name)
	end
end

function MER:InitializeModules()
	for _, moduleName in pairs(MER.RegisteredModules) do
		local module = self:GetModule(moduleName)
		if module.Initialize then
			pcall(module.Initialize, module)
		end
	end
end

function MER:UpdateModules()
	self:UpdateScripts()
	for _, moduleName in pairs(self.RegisteredModules) do
		local module = MER:GetModule(moduleName)
		if module.ProfileUpdate then
			pcall(module.ProfileUpdate, module)
		end
	end
end

function MER:AddMoverCategories()
	tinsert(E.ConfigModeLayouts, #E.ConfigModeLayouts + 1, "MERATHILISUI")
	E.ConfigModeLocalizedStrings["MERATHILISUI"] = format("|cffff7d0a%s |r", "MerathilisUI")
end

function MER:CheckElvUIVersion()
	-- ElvUI versions check
	if E.version < 99999 then
		if MER.ElvUIVersion < 1 or (MER.ElvUIVersion < MER.RequiredVersion) then
			E:StaticPopup_Show("VERSION_OUTDATED")
			return false -- If ElvUI Version is outdated stop right here. So things don't get broken.
		elseif MER.ElvUIVersion > MER.RequiredVersion + 0.03 then
			E:StaticPopup_Show("VERSION_MISMATCH")
			return false
		end
	end

	return true
end

function MER:CheckInstalledVersion()
	if InCombatLockdown() then
		return
	end

	if self.showChangeLog then
		E:StaticPopup_Show("MERATHILIS_OPEN_CHANGELOG")
		self.showChangeLog = false
	end
end

function MER:FixGame()
	-- fix playstyle string
	-- from Premade Groups Filter & LFMPlus
	if E.global.mui.core.fixLFG then
		if C_LFGList_IsPlayerAuthenticatedForLFG(703) then
			function C_LFGList_GetPlaystyleString(playstyle, activityInfo)
				if
					not (
						activityInfo
						and playstyle
						and playstyle ~= 0
						and C_LFGList_GetLfgCategoryInfo(activityInfo.categoryID).showPlaystyleDropdown
					)
				then
					return nil
				end
				local globalStringPrefix
				if activityInfo.isMythicPlusActivity then
					globalStringPrefix = "GROUP_FINDER_PVE_PLAYSTYLE"
				elseif activityInfo.isRatedPvpActivity then
					globalStringPrefix = "GROUP_FINDER_PVP_PLAYSTYLE"
				elseif activityInfo.isCurrentRaidActivity then
					globalStringPrefix = "GROUP_FINDER_PVE_RAID_PLAYSTYLE"
				elseif activityInfo.isMythicActivity then
					globalStringPrefix = "GROUP_FINDER_PVE_MYTHICZERO_PLAYSTYLE"
				end
				return globalStringPrefix and _G[globalStringPrefix .. tostring(playstyle)] or nil
			end

			_G.LFGListEntryCreation_SetTitleFromActivityInfo = function(_) end
		end
	end

	-- Button Fix
	if E.global.mui.core.cvarAlert then
		self:RegisterEvent("CVAR_UPDATE", function(_, cvar, value)
			if cvar == "ActionButtonUseKeyDown" and MER.UseKeyDown ~= (value == "1") then
				E:StaticPopup_Show("MERATHILISUI_BUTTON_FIX_RELOAD")
			end
		end)
	end
end
