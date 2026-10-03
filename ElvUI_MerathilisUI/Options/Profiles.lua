local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Profile = MER:GetModule("MER_Profiles")
local LSM = E.Libs.LSM

local options = module.options.profiles.args

local ipairs, unpack = ipairs, unpack
local strfind, strlower = strfind, strlower

local GetAddOnMetadata = C_AddOns.GetAddOnMetadata

local Ok = F.GetIconString(I.Media.Icons.Ok, 14, 14)
local No = F.GetIconString(I.Media.Icons.No, 14, 14)

-- "DEFAULT" in the override tables means "keep the font / outline the profile uses"
local OutlineValues = E:CopyTable({ DEFAULT = L["Default"] }, MER.Values.FontFlags)

-- Font + outline override for one of the fonts the ElvUI profile is built from
local function FontOverrideGroup(order, name, baseFont)
	return {
		order = order,
		type = "group",
		inline = true,
		name = name,
		args = {
			font = {
				order = 1,
				type = "select",
				dialogControl = "LSM30_Font",
				name = L["Font"],
				values = LSM:HashTable("font"),
				get = function()
					return F.FontOverride(baseFont)
				end,
				set = function(_, value)
					-- picking the base font again clears the override
					E.db.mui.general.fontOverride[baseFont] = value == baseFont and "DEFAULT" or value
				end,
			},
			outline = {
				order = 2,
				type = "select",
				name = L["Outline"],
				desc = L["Default keeps the outline each element uses in the profile."],
				values = OutlineValues,
				sortByValue = true,
				get = function()
					return E.db.mui.general.fontStyleOverride[baseFont] or "DEFAULT"
				end,
				set = function(_, value)
					E.db.mui.general.fontStyleOverride[baseFont] = value
				end,
			},
		},
	}
end

options.generalGroup = {
	order = 1,
	type = "group",
	name = module:AddCategorieIcon(L["General"], "OptionsHome"),
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
			name = L["Fonts"],
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
				E.db.mui.general.fontOverride = E:CopyTable({}, P.general.fontOverride)
				E.db.mui.general.fontStyleOverride = E:CopyTable({}, P.general.fontStyleOverride)
				E.db.mui.general.fontScale = P.general.fontScale

				Profile:ApplyFontChange()
			end,
		},
		spacer = {
			order = 5,
			type = "description",
			name = "",
		},
		applyHint = {
			order = 6,
			type = "description",
			name = F.String.Warning(L["Changes are only applied to the ElvUI profile after clicking Apply."]),
			fontSize = "medium",
		},
		primaryFont = FontOverrideGroup(7, L["Main Font"], I.Fonts.Primary),
		numberFont = FontOverrideGroup(8, L["Number Font"], I.Fonts.GothamRaid),
		fontScale = {
			order = 9,
			type = "range",
			name = L["Font Size Offset"],
			desc = L["Added to every font size the profile sets."],
			min = -4,
			max = 4,
			step = 1,
			get = function()
				return E.db.mui.general.fontScale
			end,
			set = function(_, value)
				E.db.mui.general.fontScale = value
			end,
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
			name = L["Profiles"],
		},
	},
}

for index, v in ipairs(I.AddOnProfiles) do
	local addon, addonName, applyMethod = unpack(v)

	local iconTexture = GetAddOnMetadata(addon, "IconTexture")
	local iconAtlas = GetAddOnMetadata(addon, "IconAtlas")

	if not iconTexture and not iconAtlas then
		iconTexture = [[Interface\ICONS\INV_Misc_QuestionMark]]
	end

	-- Spell icons get their built-in border cropped, like everywhere else in ElvUI
	local imageCoords = iconTexture and strfind(strlower(iconTexture), "^interface[\\/]icons[\\/]") and E.TexCoords
	-- Enabling an AddOn needs a reload, so the state at load time stays valid
	local enabled = E:IsAddOnEnabled(addon)

	options.addons.args[addon] = {
		order = 3 + index,
		type = "execute",
		dialogControl = "MERLinkTile",
		name = addonName,
		desc = L["This will create and apply profile for "] .. addonName,
		image = iconTexture,
		imageCoords = imageCoords,
		width = "relative",
		relWidth = 0.333,
		arg = {
			subtitle = enabled and L["Create and apply the profile"] or L["AddOn is not enabled"],
			atlas = not iconTexture and iconAtlas or nil,
		},
		func = function()
			Profile[applyMethod](Profile)
		end,
		disabled = not enabled,
	}
end
