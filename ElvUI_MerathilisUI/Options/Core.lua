local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local async = MER.Utilities.Async

local format = format

local CreateTextureMarkup = CreateTextureMarkup

local newSignIgnored = [[|TInterface\OptionsFrame\UI-OptionsFrame-NewFeatureIcon:14:14|t]]
local logo =
	CreateTextureMarkup("Interface/AddOns/ElvUI_MerathilisUI/Media/textures/m2", 64, 64, 20, 20, 0, 1, 0, 1, 0, -1)

MER.options = {
	general = {
		order = 101,
		name = F.cOption(L["General"], "gradient"),
		icon = I.Media.Icons.OptionsHome,
		args = {},
	},
	modules = {
		order = 102,
		name = F.cOption(L["Modules"], "gradient"),
		icon = I.Media.Icons.Config,
		args = {
			info = {
				order = 1,
				type = "description",
				name = L["Here you find the options for all the different |cffffffffMerathilis|r|cffff8000UI|r modules."],
			},
		},
	},
	misc = {
		order = 103,
		name = F.cOption(L["Misc"], "gradient"),
		icon = I.Media.Icons.More,
		args = {},
	},
	skins = {
		order = 104,
		name = F.cOption(L["Skins/AddOns"], "gradient"),
		icon = I.Media.Icons.Bill,
		args = {},
	},
	profiles = {
		order = 105,
		name = F.cOption(L["Profiles"], "gradient"),
		icon = I.Media.Icons.System,
		args = {},
	},
	gradient = {
		order = 106,
		name = F.cOption(L["Gradient Colors"], "gradient"),
		icon = I.Media.Icons.Gradient,
		args = {},
	},
	advanced = {
		order = 111,
		name = F.cOption(L["Advanced Settings"], "gradient"),
		icon = I.Media.Icons.Tips,
		args = {},
	},
	information = {
		order = 112,
		name = F.cOption(L["Information"], "gradient"),
		icon = I.Media.Icons.Save,
		args = {},
	},
	changelog = {
		order = 113,
		name = F.cOption(L["Changelog"], "gradient"),
		icon = I.Media.Icons.Changelog,
		args = {},
	},
}

function MER:OptionsCallback()
	local icon = F.GetIconString(I.Media.Textures.pepeSmall, 14)
	E.Options.name = format("%s + %s %s |cFF00c0fa%s|r", E.Options.name, icon, MER.Title, MER.DisplayVersion)

	-- Main options
	E.Options.args.mui = {
		type = "group",
		name = logo .. MER.Title,
		desc = L["Plugin for |cffff7d0aElvUI|r by\nMerathilis."],
		childGroups = "tree",
		get = function(info)
			return E.db.mui.general[info[#info]]
		end,
		set = function(info, value)
			E.db.mui.general[info[#info]] = value
			E:StaticPopup_Show("PRIVATE_RL")
		end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = MER.Title .. F.cOption(MER.Version, "blue") .. L["by Merathilis (|cFF00c0faEU-Shattrath|r)"],
			},
			logo = {
				order = 2,
				type = "description",
				name = function()
					local text
					if not F.IsMERProfile() then
						text = newSignIgnored
							.. L["Please run through the installation process to set up the plugin.\n\n This step is needed to ensure that all features are configured correctly for your profile. You don't have to apply every step."]
							.. newSignIgnored
					else
						text = L["MER_DESC"] .. newSignIgnored
					end

					return text
				end,
				fontSize = "large",
				image = function()
					return I.General.MediaPath .. "Textures\\mUI1.tga", 200, 200
				end,
			},
			install = {
				order = 3,
				type = "execute",
				name = L["Install"],
				desc = L["Run the installation process."],
				customWidth = 140,
				func = function()
					E:GetModule("PluginInstaller"):Queue(MER.installTable)
					E:ToggleOptions()
				end,
			},
			statusReport = {
				order = 4,
				type = "execute",
				name = L["|T" .. I.General.MediaPath .. "Icons\\gradientList.tga:18:18:0:0:64:64|t Status Report"],
				desc = "Open the "
					.. MER.Title
					.. " Status Report window that shows necessary information for debugging. Post this when reporting bugs!",
				customWidth = 140,
				func = function()
					MER:GetModule("MER_Misc"):StatusReportShow()
					E:ToggleOptions()
				end,
				disabled = function()
					return not MER:HasRequirements(I.Enum.Requirements.MERUI_PROFILE) and not F.IsMERProfile()
				end,
			},
			discordButton = {
				order = 5,
				type = "execute",
				name = L["|T" .. I.General.MediaPath .. "Icons\\Discord.tga:18:18:0:0:64:64|t |cffffffffMerathilis|r|cffff7d0aUI|r Discord"],
				customWidth = 160,
				func = function()
					E:StaticPopup_Show("MERATHILISUI_CREDITS", nil, nil, "https://discord.gg/28We6esE9v")
				end,
			},
		},
	}

	for catagory, info in pairs(MER.options) do
		E.Options.args.mui.args[catagory] = {
			order = info.order,
			type = "group",
			childGroups = "tab",
			name = info.name,
			desc = info.desc,
			icon = info.icon,
			args = info.args,
			hidden = function() -- Hide the options if not my profile is installed
				return not MER:HasRequirements(I.Enum.Requirements.MERUI_PROFILE)
			end,
		}
	end

	-- Data warmup
	async.WithItemIDTable(E.db.mui.autoButtons.blackList, "key")
	async.WithItemIDTable(E.db.mui.autoButtons.customList, "value")
end

MER.AnimationEaseTable = {
	["linear"] = L["Linear Ease"],
	["quadratic"] = L["Quadratic Ease"],
	["cubic"] = L["Cubic Ease"],
	["quartic"] = L["Quartic Ease"],
	["quintic"] = L["Quintic Ease"],
	["sinusoidal"] = L["Sinusoidal Ease"],
	["exponential"] = L["Exponential Ease"],
	["circular"] = L["Circular Ease"],
	["bounce"] = L["Bounce Ease"],
}
