local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles")
local options = MER.options.profiles.args

local ipairs, unpack = ipairs, unpack

local CreateSimpleTextureMarkup = CreateSimpleTextureMarkup
local CreateAtlasMarkup = CreateAtlasMarkup
local GetAddOnMetadata = C_AddOns.GetAddOnMetadata
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded

local Ok = F.GetIconString(I.Media.Icons.Ok, 14, 14)
local No = F.GetIconString(I.Media.Icons.No, 14, 14)

local SupportedProfiles = {
	{ "AddOnSkins", "AddOnSkins" },
	{ "Capping", "Capping" },
	{ "BigWigs", "BigWigs" },
	{ "Details", "Details" },
	{ "ElvUI_FCT", "FCT" },
	{ "ElvUI_mMediaTag", "mMediaTag & Tools" },
	{ "ls_Toasts", "ls_Toasts" },
	{ "OmniCD", "OmniCD" },
	{ "TomTom", "TomTom" },
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
				module:ApplyFontChange()
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

				module:ApplyFontChange()
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
			if addon == "BigWigs" then
				module:ApplyBigWigsProfile()
			elseif addon == "Capping" then
				module:ApplyCappingProfile()
			elseif addon == "Details" then
				module:ApplyDetailsProfile()
			elseif addon == "AddOnSkins" then
				module:ApplyAddOnSkinsProfile()
			elseif addon == "ls_Toasts" then
				module:ApplyLSProfile()
			elseif addon == "ElvUI_FCT" then
				module:ApplyFCTProfile()
			elseif addon == "ElvUI_mMediaTag" then
				module:ApplymMediaTagProfile()
			elseif addon == "OmniCD" then
				module:ApplyOmniCDProfile()
			elseif addon == "TomTom" then
				module:ApplyTomTomProfile()
			end
		end,
		disabled = function()
			return not IsAddOnLoaded(addon)
		end,
	}
end
