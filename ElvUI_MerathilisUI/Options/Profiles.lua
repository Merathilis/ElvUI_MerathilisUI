local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles")
local options = MER.options.profiles.args

local ipairs, unpack = ipairs, unpack
local IsAddOnLoaded = C_AddOns and C_AddOns.IsAddOnLoaded

local SupportedProfiles = {
	{ "AddOnSkins", "AddOnSkins" },
	{ "BigWigs", "BigWigs" },
	{ "Details", "Details" },
	{ "ElvUI_FCT", "FCT" },
	{ "ElvUI_mMediaTag", "mMediaTag & Tools" },
	{ "ProjectAzilroka", "ProjectAzilroka" },
	{ "ls_Toasts", "ls_Toasts" },
	{ "OmniCD", "OmniCD" },
}

options.generalGroup = {
	order = 1,
	type = "group",
	name = L["General"],
	args = {
		desc = {
			order = 1,
			type = "description",
			name = "This group allows to update all fonts used in the "
				.. MER.Title
				.. " "
				.. F.String.ElvUI()
				.. " Profile.\n\n"
				.. F.String.Error(
					"Warning: Some fonts might still not look ideal! The results will not be ideal, but it should help you customize the fonts :)\n"
				),
		},
		header = {
			order = 2,
			type = "header",
			name = F.cOption(L["Fonts"], "orange"),
		},
		applyButton = {
			order = 3,
			type = "execute",
			name = F.String.Good("Apply"),
			desc = "Applies all " .. MER.Title .. " font settings.",
			func = function()
				module:ApplyFontChange()
				E:StaticPopup_Show("PRIVATE_RL")
			end,
		},
		resetButton = {
			order = 4,
			type = "execute",
			name = F.String.Error("Reset"),
			desc = "Resets all " .. MER.Title .. " font settings.",
			func = function()
				E:CopyTable(E.db.mui.general.fontOverride, P.general.fontOverride)
				E:CopyTable(E.db.mui.general.fontStyleOverride, P.general.fontStyleOverride)
				E:CopyTable(E.db.mui.general.fontShadowOverride, P.general.fontShadowOverride)

				module:ApplyFontChange()
				E:StaticPopup_Show("PRIVATE_RL")
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
	options.addons.args[addon] = {
		order = optionOrder + 1,
		type = "execute",
		name = addonName,
		desc = L["This will create and apply profile for "] .. addonName,
		func = function()
			if addon == "BigWigs" then
				module:LoadBigWigsProfile()
			elseif addon == "Details" then
				E:StaticPopup_Show("MER_INSTALL_DETAILS_LAYOUT")
			elseif addon == "AddOnSkins" then
				module:LoadAddOnSkinsProfile()
				E:StaticPopup_Show("PRIVATE_RL")
			elseif addon == "ProjectAzilroka" then
				module:LoadPAProfile()
				E:StaticPopup_Show("PRIVATE_RL")
			elseif addon == "ls_Toasts" then
				module:LoadLSProfile()
				E:StaticPopup_Show("PRIVATE_RL")
			elseif addon == "ElvUI_FCT" then
				local FCT = E.Libs.AceAddon:GetAddon("ElvUI_FCT")
				module:LoadFCTProfile()
				FCT:UpdateUnitFrames()
				FCT:UpdateNamePlates()
			elseif addon == "ElvUI_mMediaTag" then
				module:LoadmMediaTagProfile()
				E:StaticPopup_Show("PRIVATE_RL")
			elseif addon == "OmniCD" then
				module:LoadOmniCDProfile()
				E:StaticPopup_Show("PRIVATE_RL")
			end
		end,
		disabled = function()
			return not IsAddOnLoaded(addon)
		end,
	}
end
