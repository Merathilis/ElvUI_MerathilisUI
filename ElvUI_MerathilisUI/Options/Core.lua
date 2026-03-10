local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options

local format = format

local CreateTextureMarkup = CreateTextureMarkup

local newSignIgnored = [[|TInterface\OptionsFrame\UI-OptionsFrame-NewFeatureIcon:14:14|t]]
local logo =
	CreateTextureMarkup("Interface/AddOns/ElvUI_MerathilisUI/Media/textures/m2", 64, 64, 20, 20, 0, 1, 0, 1, 0, -1)

module.enabledState = F.Enum({ "YES", "NO", "FORCE_DISABLED" })
module.orderIndex = 1
module.callOnInit = {}

module.options = {
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
}

-- Error handler
local function errorhandler(err)
	return _G.geterrorhandler()(err)
end

function module:GetAllFontsFunc(additional)
	return function()
		return F.Table.Join({}, E.LSM:HashTable("font"), additional or {})
	end
end

function module:GetAllFontOutlinesFunc(additional)
	local styleSelection = {
		NONE = "None",
		OUTLINE = "Outline",
		THICKOUTLINE = "Thick",
		MONOCHROME = "|cffaaaaaaMono|r",
		MONOCHROMEOUTLINE = "|cffaaaaaaMono|r Outline",
		MONOCHROMETHICKOUTLINE = "|cffaaaaaaMono|r Thick",
		SHADOWOUTLINE = "ShadowOutline",
	}

	return function()
		return F.Table.Join({}, styleSelection, additional or {})
	end
end

function module:GetAllFontColorsFunc(additional)
	local colorSelection = {
		NONE = "None",
		CLASS = F.String.Class("Class Color"),
		VALUE = F.String.ElvUIValue("ElvUI Color"),
		TXUI = MER.Title .. F.String.MERATHILIS(" Color"),
		CUSTOM = "Custom",
	}

	return function()
		return F.Table.Join({}, colorSelection, additional or {})
	end
end

function module:GetFontColorGetter(profileDB, defaultDB, customKey)
	return function(info)
		local key = customKey or info[#info]
		local profileEntry = F.GetDBFromPath(profileDB)[key]
		local defaultEntry = defaultDB[key]
		return profileEntry.r,
			profileEntry.g,
			profileEntry.b,
			profileEntry.a,
			defaultEntry.r,
			defaultEntry.g,
			defaultEntry.b,
			defaultEntry.a
	end
end

function module:GetFontColorSetter(profileDB, callback, customKey)
	return function(info, r, g, b, a)
		local key = customKey or info[#info]
		local profileEntry = F.GetDBFromPath(profileDB)[key]
		if profileEntry.r ~= r or profileEntry.g ~= g or profileEntry.b ~= b or profileEntry.a ~= a then
			profileEntry.r, profileEntry.g, profileEntry.b, profileEntry.a = r, g, b, a
			if callback then
				callback()
			end
		end
	end
end

function module:GetEnabledState(check, group)
	local enabled = (check == true)
	local forceDisabled = false

	if group and group.disabled then
		if type(group.disabled) == "boolean" then
			forceDisabled = group.disabled
		elseif type(group.disabled) == "function" then
			forceDisabled = group.disabled()
		end
	end

	if (enabled and enabled == true) and not forceDisabled then
		return self.enabledState.YES
	elseif not forceDisabled then
		return self.enabledState.NO
	end

	return self.enabledState.FORCE_DISABLED
end

function module:GetEnableName(check, group)
	local enabled = self:GetEnabledState(check, group)

	if enabled == self.enabledState.YES then
		return F.String.Good("Enable")
	elseif enabled == self.enabledState.NO then
		return F.String.Error("Disable")
	end

	return "Disable"
end

function module:AddGroup(options, others)
	local orderIdx = self:GetOrder()
	local group = {
		order = orderIdx,
		type = "group",
		args = {},
	}
	E:CopyTable(group, others)
	options["fancyInlineGroup" .. orderIdx] = group
	return options["fancyInlineGroup" .. orderIdx]
end

function module:AddInlineGroup(options, others)
	local orderIdx = self:GetOrder()
	local group = {
		order = orderIdx,
		inline = true,
		type = "group",
		args = {},
	}
	E:CopyTable(group, others)
	options["fancyInlineGroup" .. orderIdx] = group
	return options["fancyInlineGroup" .. orderIdx]
end

function module:AddDesc(options, othersGroup, othersDesc)
	local orderIdx = self:GetOrder()
	local inlineGroup = self:AddGroup(options, othersGroup)
	local group = {
		order = orderIdx,
		type = "description",
	}
	E:CopyTable(group, othersDesc)
	inlineGroup["args"]["fancyInlineDesc" .. orderIdx] = group
	return inlineGroup
end

function module:AddInlineDesc(options, othersGroup, othersDesc)
	local orderIdx = self:GetOrder()
	local inlineGroup = self:AddInlineGroup(options, othersGroup)
	local group = {
		order = orderIdx,
		type = "description",
	}
	E:CopyTable(group, othersDesc)
	inlineGroup["args"]["fancyInlineDesc" .. orderIdx] = group
	return inlineGroup
end

function module:AddInlineSoloDesc(options, othersDesc)
	local orderIdx = self:GetOrder()
	local group = {
		order = orderIdx,
		type = "description",
	}
	E:CopyTable(group, othersDesc)
	options["fancyInlineDesc" .. orderIdx] = group
	return group
end

function module:AddInlineRequirementsDesc(options, othersGroup, othersDesc, requirements)
	local orderIdx = self:GetOrder()
	local inlineGroup = self:AddInlineGroup(options, othersGroup)
	local group = F.Table.Join({}, {
		order = orderIdx,
		type = "description",
	}, othersDesc)

	inlineGroup.disabled = function()
		return not MER:HasRequirements(requirements)
	end

	-- Define if not defined
	if not group["name"] then
		group["name"] = ""
	end

	-- Convert to function
	if type(group["name"]) == "string" then
		local originalText = "" .. group["name"]

		group["name"] = function()
			local description = "" .. originalText
			local check = MER:CheckRequirements(requirements)
			if check and check ~= true then
				local reason = MER:GetRequirementString(check)
				if reason then
					description = description .. F.String.Error(reason) .. "\n\n"
				end
			end
			return description
		end
	else
		-- self:LogDebug("GroupName is not a string, cannot convert to requirements check")
	end

	inlineGroup["args"]["fancyInlineDesc" .. orderIdx] = group
	return inlineGroup
end

function module:AddSpacer(options, big)
	options["fancySpacer" .. self:GetOrder()] = {
		order = self:GetOrder(),
		type = "description",
		name = big and "\n\n" or "\n",
	}
	return options["fancySpacer" .. self:GetOrder()]
end

function module:AddTinySpacer(options)
	options["fancySpacer" .. self:GetOrder()] = {
		order = self:GetOrder(),
		type = "description",
		name = "",
	}
	return options["fancySpacer" .. self:GetOrder()]
end

function module:GetOrder()
	self.orderIndex = self.orderIndex + 1
	return self.orderIndex
end

function module:ResetOrder()
	self.orderIndex = 1
end

function module:AddCallback(name, func)
	-- Don't load any other settings except general and changelog when MER is not installed
	if not F.IsMERProfile() and (name ~= "Information" and name ~= "General" and name ~= "Changelog") then
		return
	end

	tinsert(self.callOnInit, func or self[name])
end

function module:OptionsCallback()
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
							.. L["Please run through the installation process to set up the plugin.\n\n |cffff7d0aThis step is needed to ensure that all features are configured correctly for your profile. You don't have to apply every step.|r"]
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

	for category, info in pairs(self.options) do
		E.Options.args.mui.args[category] = {
			order = info.order,
			type = "group",
			childGroups = "tab",
			name = info.name,
			desc = info.desc,
			icon = info.icon,
			args = info.args,
			get = info.get,
			set = info.set,
			hidden = function() -- Hide the options if not my profile is installed
				return not MER:HasRequirements(I.Enum.Requirements.MERUI_PROFILE)
			end,
		}
	end
end

function module:Initialize()
	if self.Initialized then
		return
	end

	for index, func in next, self.callOnInit do
		xpcall(func, errorhandler, self)
		self.callOnInit[index] = nil
	end

	self.Initialized = true
end

MER:RegisterModule(module:GetName())
