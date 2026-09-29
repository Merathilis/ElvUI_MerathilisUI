local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local LSM = E.Libs.LSM

local options = module.options.modules.args

-- Own disabled replaces the group's, so every own disabled repeats the requirement
local function RequirementMissing()
	return not MER:HasRequirements(I.Requirements.VehicleBar)
end

local function ModuleDisabled()
	return RequirementMissing() or not E.db.mui.vehicleBar.enable
end

local function VigorDisabled()
	return ModuleDisabled() or not E.db.mui.vehicleBar.vigorBar.enable
end

-- The module rebuilds the bar on every change (disable + enable), no reload needed
local function Update()
	F.Event.TriggerEvent("VehicleBar.SettingsUpdate")
end

local function VigorColor(order, name, key, disabled)
	return {
		order = order,
		type = "color",
		name = name,
		hasAlpha = false,
		disabled = disabled,
		get = function()
			local t = E.db.mui.vehicleBar.vigorBar[key]
			local d = P.vehicleBar.vigorBar[key]
			return t.r, t.g, t.b, nil, d.r, d.g, d.b, nil
		end,
		set = function(_, r, g, b)
			local t = E.db.mui.vehicleBar.vigorBar[key]
			t.r, t.g, t.b = r, g, b
			Update()
		end,
	}
end

options.vehicleBar = {
	type = "group",
	name = module:AddCategorieIcon(L["VehicleBar"], "vehicle"),
	childGroups = "tab",
	disabled = RequirementMissing,
	args = {
		name = {
			order = 1,
			type = "header",
			name = L["VehicleBar"],
		},
		requirements = module.RequirementsNotice(I.Requirements.VehicleBar, 1.5),
		credits = {
			order = 2,
			type = "group",
			name = L["Credits"],
			guiInline = true,
			args = {
				toxiui = {
					order = 1,
					type = "description",
					name = "|cff1784d1ElvUI|r |cffffffffToxi|r|cff18a8ffUI|r",
				},
			},
		},
		general = {
			order = 3,
			type = "group",
			name = L["General"],
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					get = function()
						return E.db.mui.vehicleBar.enable
					end,
					set = function(_, value)
						E.db.mui.vehicleBar.enable = value
						Update()
					end,
				},
				elvuiBars = {
					order = 2,
					type = "toggle",
					name = L["Hide ElvUI Bars"],
					disabled = ModuleDisabled,
					get = function()
						return E.db.mui.vehicleBar.hideElvUIBars
					end,
					-- The ElvUI bars are only given back when the new value still says to hide them
					set = function(_, value)
						E.db.mui.vehicleBar.hideElvUIBars = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
			},
		},
		buttonGroup = {
			order = 4,
			type = "group",
			name = L["Buttons"],
			desc = L["Settings for the Action Bar Buttons of the Vehicle Bar.\n\n"],
			disabled = ModuleDisabled,
			get = function(info)
				return E.db.mui.vehicleBar[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.vehicleBar[info[#info]] = value
				Update()
			end,
			args = {
				buttonWidth = {
					order = 1,
					type = "range",
					name = L["Button Width"],
					desc = L["Change the Vehicle Bar's Button width. The height will scale accordingly in a 4:3 aspect ratio."],
					min = 20,
					max = 80,
					step = 1,
				},
				showKeybinds = {
					order = 2,
					type = "toggle",
					name = L["Show Keybinds"],
					desc = L["Toggle whether to show keybinds of an action bar button on the Vehicle Bar."],
				},
				showMacro = {
					order = 3,
					type = "toggle",
					name = L["Show Macro Text"],
					desc = L["Toggle whether to show macro text of an action bar button on the Vehicle Bar."],
				},
			},
		},
		vigorBarGroup = {
			order = 5,
			type = "group",
			name = L["Vigor Bar"],
			disabled = ModuleDisabled,
			get = function(info)
				return E.db.mui.vehicleBar.vigorBar[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.vehicleBar.vigorBar[info[#info]] = value
				Update()
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
				},
				vigorBarBarHeader = {
					order = 2,
					type = "header",
					name = L["Bar Settings"],
				},
				height = {
					order = 3,
					type = "range",
					name = L["Bar Height"],
					desc = L["Change the Skyriding Bar's height."],
					min = 4,
					max = 20,
					step = 1,
					disabled = VigorDisabled,
				},
				normalTexture = {
					order = 4,
					type = "select",
					name = L["Normal Texture"],
					desc = L["Vigor bar texture for Normal and Gradient Mode"],
					dialogControl = "LSM30_Statusbar",
					values = LSM:HashTable("statusbar"),
					disabled = VigorDisabled,
				},
				darkTexture = {
					order = 5,
					type = "select",
					name = L["Dark Texture"],
					desc = L["Vigor bar texture for Dark Mode."],
					dialogControl = "LSM30_Statusbar",
					values = LSM:HashTable("statusbar"),
					disabled = VigorDisabled,
				},
				vigorBarcolorHeader = {
					order = 6,
					type = "header",
					name = L["Color Settings"],
				},
				useCustomColor = {
					order = 7,
					type = "toggle",
					name = L["Use Custom Color"],
					disabled = VigorDisabled,
				},
				customColorLeft = VigorColor(8, L["Left Color"], "customColorLeft", function()
					return VigorDisabled() or not E.db.mui.vehicleBar.vigorBar.useCustomColor
				end),
				customColorRight = VigorColor(9, L["Right Color"], "customColorRight", function()
					return VigorDisabled() or not E.db.mui.vehicleBar.vigorBar.useCustomColor
				end),
				speedTextHeader = {
					order = 10,
					type = "header",
					name = L["Speed Text Settings"],
				},
				showSpeedText = {
					order = 11,
					type = "toggle",
					name = L["Show Speed Text"],
					disabled = VigorDisabled,
				},
				thrillColor = VigorColor(12, L["Thrill Color"], "thrillColor", VigorDisabled),
				speedTextFont = {
					order = 13,
					type = "select",
					name = L["Font"],
					dialogControl = "LSM30_Font",
					values = LSM:HashTable("font"),
					disabled = VigorDisabled,
				},
				speedTextFontSize = {
					order = 14,
					type = "range",
					name = L["Font Size"],
					min = 8,
					max = 40,
					step = 1,
					disabled = VigorDisabled,
				},
				speedTextOffsetY = {
					order = 15,
					type = "range",
					name = L["Offset Y"],
					min = -10,
					max = 10,
					step = 1,
					disabled = VigorDisabled,
				},
				speedTextUpdateRate = {
					order = 16,
					type = "range",
					name = L["Update Rate"],
					desc = L["How often the speed text is updated."],
					min = 0.05,
					max = 1,
					step = 0.05,
					disabled = VigorDisabled,
				},
			},
		},
		animationsGroup = {
			order = 6,
			type = "group",
			name = L["Animations"],
			disabled = ModuleDisabled,
			args = {
				animations = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					get = function()
						return E.db.mui.vehicleBar.animations
					end,
					set = function(_, value)
						E.db.mui.vehicleBar.animations = value
						Update()
					end,
				},
				-- Read when the bar is shown, nothing to rebuild
				animationsMult = {
					order = 2,
					type = "range",
					name = L["Animation Speed"],
					min = 0.5,
					max = 2,
					step = 0.1,
					isPercent = true,
					disabled = function()
						return ModuleDisabled() or not E.db.mui.vehicleBar.animations
					end,
					get = function()
						return 1 / E.db.mui.vehicleBar.animationsMult
					end,
					set = function(_, value)
						E.db.mui.vehicleBar.animationsMult = 1 / value
					end,
				},
			},
		},
	},
}
