local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Profile = MER:GetModule("MER_Profiles")

local options = module.options.profiles.args

local ipairs, unpack = ipairs, unpack

local CreateSimpleTextureMarkup = CreateSimpleTextureMarkup
local CreateAtlasMarkup = CreateAtlasMarkup
local GetAddOnMetadata = C_AddOns.GetAddOnMetadata
local C_AddOns_DoesAddOnExist = C_AddOns.DoesAddOnExist

local Ok = F.GetIconString(I.Media.Icons.Ok, 14, 14)
local No = F.GetIconString(I.Media.Icons.No, 14, 14)

local SupportedProfiles = {
	{ "AddOnSkins", "AddOnSkins" },
	{ "BetterCooldownManager", "BetterCooldownManager" },
	{ "Capping", "Capping" },
	{ "BigWigs", "BigWigs" },
	{ "Details", "Details" },
	{ "ls_Toasts", "ls_Toasts" },
	{ "TomTom", "TomTom" },
	{
		"ElvUI_WindTools",
		"|cff1784d1ElvUI|r |cff5385edW|r|cff5094eai|r|cff4da4e7n|r|cff4ab4e4d|r|cff47c0e1T|r|cff44cbdfo|r|cff41d7ddo|r|cff41d7ddl|r|cff41d7dds|r",
	},
	{ "ElvUI_mMediaTag", "|CFF0294FFm|r|CFFBD26E5Media|r|CFFFF005DTag|r |CFF404040&|r  |CFFFF9D00Tools|r" },
}

options.generalGroup = {
	order = 1,
	type = "group",
	name = L["General"],
	args = {
		desc = {
			order = 1,
			type = "description",
			name = L["This group allows to update all fonts used in the "]
				.. MER.Title
				.. " "
				.. F.String.ElvUI()
				.. " Profile.\n\n"
				.. F.String.Error(
					L["WARNING: Some fonts might still not look ideal! The results will not be ideal, but it should help you customize the fonts :)\n"]
				),
			fontSize = "medium",
		},
		header = {
			order = 2,
			type = "header",
			name = F.cOption(L["Fonts"], "orange"),
		},
		applyButton = {
			order = 3,
			type = "execute",
			name = Ok .. F.String.Good(L[" Apply"]),
			desc = L["Applies all |cffffffffMerathilis|r|cffff7d0aUI|r font settings."],
			func = function()
				Profile:ApplyFontChange()
			end,
		},
		resetButton = {
			order = 4,
			type = "execute",
			name = No .. F.String.Error(L[" Reset"]),
			desc = L["Resets all |cffffffffMerathilis|r|cffff7d0aUI|r font settings."],
			func = function()
				E:CopyTable(E.db.mui.general.fontOverride, P.general.fontOverride)
				E:CopyTable(E.db.mui.general.fontStyleOverride, P.general.fontStyleOverride)
				E:CopyTable(E.db.mui.general.fontShadowOverride, P.general.fontShadowOverride)

				Profile:ApplyFontChange()
			end,
		},
		spacer = {
			order = 5,
			type = "description",
			name = "",
		},
		wip = {
			order = 6,
			type = "description",
			name = F.GetStyledText(L["Work In Progress"]),
			fontSize = "large",
		},
	},
}

options.addons = {
	order = 2,
	type = "group",
	name = L["AddOns"],
	args = {
		info = {
			order = 1,
			type = "description",
			name = F.String.MERATHILISUI(L["MER_PROFILE_DESC"]),
			fontSize = "medium",
		},
		space = {
			order = 2,
			type = "description",
			name = "",
		},
		header = {
			order = 3,
			type = "header",
			name = F.cOption(L["Profiles"], "orange"),
		},
	},
}

for _, v in ipairs(SupportedProfiles) do
	local addon, addonName = unpack(v)
	local optionOrder = 4

	local iconTexture = GetAddOnMetadata(addon, "IconTexture")
	local iconAtlas = GetAddOnMetadata(addon, "IconAtlas")

	if not iconTexture and not iconAtlas then
		iconTexture = [[Interface\ICONS\INV_Misc_QuestionMark]]
	end

	if iconTexture then
		addonName = CreateSimpleTextureMarkup(iconTexture, 14, 14) .. " " .. addonName
	elseif iconAtlas then
		addonName = CreateAtlasMarkup(iconAtlas, 14, 14) .. " " .. addonName
	end

	options.addons.args[addon] = {
		order = optionOrder + 1,
		type = "execute",
		name = addonName,
		desc = L["This will create and apply profile for "] .. addonName,
		func = function()
			if addon == "BetterCooldownManager" then
				Profile:ApplyCooldownManagerProfile()
			elseif addon == "BigWigs" then
				Profile:ApplyBigWigsProfile()
			elseif addon == "Capping" then
				Profile:ApplyCappingProfile()
			elseif addon == "Details" then
				Profile:ApplyDetailsProfile()
			elseif addon == "ls_Toasts" then
				Profile:ApplyLSProfile()
			elseif addon == "TomTom" then
				Profile:ApplyTomTomProfile()
			elseif addon == "ElvUI_WindTools" then
				Profile:ApplyWindToolsProfile()
			elseif addon == "ElvUI_mMediaTag" then
				Profile:ApplymMediaTagProfile()
			end
		end,
		disabled = function()
			return not C_AddOns_DoesAddOnExist(addon)
		end,
	}
end
