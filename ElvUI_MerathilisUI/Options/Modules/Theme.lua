local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local ACH = LibStub("LibAceConfigHelper")

local options = module.options.modules.args

local _G = _G
local FACTION_BAR_COLORS = _G.FACTION_BAR_COLORS
local LOCALIZED_CLASS_NAMES_FEMALE = _G.LOCALIZED_CLASS_NAMES_FEMALE
local LOCALIZED_CLASS_NAMES_MALE = _G.LOCALIZED_CLASS_NAMES_MALE
local PowerBarColor = _G.PowerBarColor

options.theme = {
	type = "group",
	name = E.NewSign .. L["Theme"],
	get = function(info)
		return E.db.mui.themes[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.themes[info[#info]] = value
	end,
	childGroups = "tab",
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.cOption(L["Theme"], "orange"),
		},
	},
}

function module:MerathilisUI_Themes_GradientMode()
	local gradientTitle = "|cffff97f6G|r|cfff8b0f2ra|r|cfff5c6f1di|r|cfff3d9f1en|r|cffffeafdt"

	-- Create Tab
	options.theme.args.gradientMode = {
		order = self:GetOrder(),
		type = "group",
		childGroups = "tab",
		name = gradientTitle .. " Mode|r",
		get = function(info)
			return E.db.mui.themes.gradientMode[info[#info]]
		end,
		set = function(info, value)
			E.db.mui.themes.gradientMode[info[#info]] = value
			F.Event.TriggerEvent("MER_Theme.DatabaseUpdate")
		end,
		args = {},
	}

	-- Options
	local options = options.theme.args.gradientMode.args

	-- General
	do
		-- General Group
		local generalGroup = self:AddInlineRequirementsDesc(options, {
			name = "Description",
		}, {
			name = "Credits: |cff1784d1ElvUI|r |cffffffffToxi|r|cff18a8ffUI|r"
				.. "\n\n"
				.. F.String.Error(
					L["Warning: Enabling one of these settings may overwrite colors or textures in ElvUI, they also prevent you from changing certain settings in ElvUI!"]
				)
				.. "\n\n",
		}, I.Requirements.GradientMode).args

		-- Enable
		generalGroup.enable = {
			order = self:GetOrder(),
			type = "toggle",
			desc = L["Toggling this on enables fancy gradients for "] .. MER.Title .. L[".\n\n"] .. F.String.Error(
				L["Warning: Enabling this setting will overwrite textures in ElvUI!"]
			),
			name = function()
				return self:GetEnableName(E.db.mui.themes.gradientMode.enable, generalGroup)
			end,
			get = function()
				return E.db.mui.themes.gradientMode.enable
			end,
			set = function(_, value)
				E.db.mui.themes.gradientMode.enable = value
				F.Event.TriggerEvent("MER_Theme.DatabaseUpdate")
			end,
		}
	end

	-- Colors
	do
		-- Tab
		local tab = self:AddGroup(options, {
			name = L["Class Colors"],
		}).args

		-- Colors Group
		local colorGroup = self:AddInlineDesc(tab, {
			name = L["Class Colors"],
		}, {
			name = MER.Title
				.. L[" Gradient theme "]
				.. F.String.Class("shifts", "MONK")
				.. L[" from one color to another. You can change the "]
				.. F.String.Class("shifts", "MONK")
				.. L[" below.\n\n"],
		}).args

		-- Get correct classname table
		local classNames = LOCALIZED_CLASS_NAMES_MALE
		if UnitSex("player") == 3 then
			classNames = LOCALIZED_CLASS_NAMES_FEMALE
		end

		local function generateClassOptions(class)
			-- Class Name
			self:AddInlineSoloDesc(colorGroup, {
				width = 1,
				customWidth = 120,
				name = F.String.Class(classNames[class], class),
			})

			-- Shift Color
			colorGroup[class .. "shift"] = {
				order = self:GetOrder(),
				type = "color",
				name = "",
				hasAlpha = false,
				width = 1,
				customWidth = 30,
				get = self:GetFontColorGetter(
					"mui.themes.gradientMode.classColorMap." .. I.Enum.GradientMode.Color.SHIFT,
					P.themes.gradientMode.classColorMap[I.Enum.GradientMode.Color.SHIFT],
					class
				),
				set = self:GetFontColorSetter(
					"mui.themes.gradientMode.classColorMap." .. I.Enum.GradientMode.Color.SHIFT,
					function()
						F.Event.TriggerEvent("MER_Theme.SettingsUpdate.Health")
					end,
					class
				),
			}

			-- Spacer for arrow & arrow
			self:AddInlineSoloDesc(colorGroup, {
				width = 1,
				customWidth = 30,
				name = "",
			})
			self:AddInlineSoloDesc(colorGroup, {
				width = 1,
				customWidth = 30,
				name = F.String.Class(">", "MONK"),
			})

			-- Normal Color
			colorGroup[class .. "normal"] = {
				order = self:GetOrder(),
				type = "color",
				name = "",
				hasAlpha = false,
				width = 1,
				customWidth = 30,
				get = self:GetFontColorGetter(
					"mui.themes.gradientMode.classColorMap." .. I.Enum.GradientMode.Color.NORMAL,
					P.themes.gradientMode.classColorMap[I.Enum.GradientMode.Color.NORMAL],
					class
				),
				set = self:GetFontColorSetter(
					"mui.themes.gradientMode.classColorMap." .. I.Enum.GradientMode.Color.NORMAL,
					function()
						F.Event.TriggerEvent("MER_Theme.SettingsUpdate.Health")
					end,
					class
				),
			}

			-- Gradient Preview
			colorGroup[class .. "preview"] = {
				order = self:GetOrder(),
				type = "description",
				name = "classColorMap:" .. class,
				dialogControl = "MERGradientPreview",
				width = 1,
				customWidth = 120,
			}

			-- Spacer
			self:AddTinySpacer(colorGroup)
		end

		-- Class Colors (alphabetical by localized name)
		local sortedClasses = {}
		for class, _ in pairs(P.themes.gradientMode.classColorMap[I.Enum.GradientMode.Color.SHIFT]) do
			if classNames[class] ~= nil then
				sortedClasses[#sortedClasses + 1] = class
			end
		end
		table.sort(sortedClasses, function(a, b)
			return classNames[a] < classNames[b]
		end)
		for _, class in ipairs(sortedClasses) do
			generateClassOptions(class)
		end
	end

	-- Reaction Colors
	do
		local name = L["NPC Colors"]

		-- Tab
		local tab = self:AddGroup(options, {
			name = name,
		}).args

		-- Colors Group
		local colorGroup = self:AddInlineDesc(tab, {
			name = name,
		}, {
			name = L["Here you can change the "]
				.. F.String.Class("gradient shifts", "MONK")
				.. L[" of NPC colors.\n\n"],
		}).args

		-- Reaction Colors
		for reaction, _ in pairs(P.themes.gradientMode.reactionColorMap[I.Enum.GradientMode.Color.SHIFT]) do
			-- Get correct color index for blizzard colors
			local colorIndex = 1
			if reaction == "GOOD" then
				colorIndex = 5
			elseif reaction == "NEUTRAL" then
				colorIndex = 4
			end

			-- Reaction Name
			local npcColorName = "Neutral"
			if reaction == "GOOD" then
				npcColorName = "Friendly"
			elseif reaction == "BAD" then
				npcColorName = "Enemy"
			end

			-- Reaction Name
			self:AddInlineSoloDesc(colorGroup, {
				width = 1,
				customWidth = 120,
				name = F.String.RGB(npcColorName, FACTION_BAR_COLORS[colorIndex]),
			})

			-- Shift Color
			colorGroup[reaction .. "shift"] = {
				order = self:GetOrder(),
				type = "color",
				name = "",
				hasAlpha = false,
				width = 1,
				customWidth = 30,
				get = self:GetFontColorGetter(
					"mui.themes.gradientMode.reactionColorMap." .. I.Enum.GradientMode.Color.SHIFT,
					P.themes.gradientMode.reactionColorMap[I.Enum.GradientMode.Color.SHIFT],
					reaction
				),
				set = self:GetFontColorSetter(
					"mui.themes.gradientMode.reactionColorMap." .. I.Enum.GradientMode.Color.SHIFT,
					function()
						F.Event.TriggerEvent("MER_Theme.SettingsUpdate.Health")
					end,
					reaction
				),
			}

			-- Spacer for arrow & arrow
			self:AddInlineSoloDesc(colorGroup, {
				width = 1,
				customWidth = 30,
				name = "",
			})
			self:AddInlineSoloDesc(colorGroup, {
				width = 1,
				customWidth = 30,
				name = F.String.Class(">", "MONK"),
			})

			-- Normal Color
			colorGroup[reaction .. "normal"] = {
				order = self:GetOrder(),
				type = "color",
				name = "",
				hasAlpha = false,
				width = 1,
				customWidth = 30,
				get = self:GetFontColorGetter(
					"mui.themes.gradientMode.reactionColorMap." .. I.Enum.GradientMode.Color.NORMAL,
					P.themes.gradientMode.reactionColorMap[I.Enum.GradientMode.Color.NORMAL],
					reaction
				),
				set = self:GetFontColorSetter(
					"mui.themes.gradientMode.reactionColorMap." .. I.Enum.GradientMode.Color.NORMAL,
					function()
						F.Event.TriggerEvent("MER_Theme.SettingsUpdate.Health")
					end,
					reaction
				),
			}

			-- Gradient Preview
			colorGroup[reaction .. "preview"] = {
				order = self:GetOrder(),
				type = "description",
				name = "reactionColorMap:" .. reaction,
				dialogControl = "MERGradientPreview",
				width = 1,
				customWidth = 120,
			}

			-- Spacer
			self:AddTinySpacer(colorGroup)
		end
	end

	-- Power Colors
	do
		local name = "Power Colors"

		-- Tab
		local tab = self:AddGroup(options, {
			name = name,
		}).args

		-- Power Color Group
		local colorGroup = self:AddInlineDesc(tab, {
			name = name,
		}, {
			name = L["Here you can change the "]
				.. F.String.Class("gradient shifts", "MONK")
				.. L[" of Power colors.\n\n"],
		}).args

		-- Power Colors
		local function generatePowerColors(power)
			local colorIndex = power
			if colorIndex == "ALT_POWER" then
				colorIndex = "MANA"
			end

			-- Class Name
			self:AddInlineSoloDesc(colorGroup, {
				width = 1,
				customWidth = 120,
				name = F.String.RGB(
					F.String.LowercaseEnum(power),
					{ F.CalculateMultiplierColorArray(1.35, PowerBarColor[colorIndex]) }
				),
			})

			-- Shift Color
			colorGroup[power .. "shift"] = {
				order = self:GetOrder(),
				type = "color",
				name = "",
				hasAlpha = false,
				width = 1,
				customWidth = 30,
				get = self:GetFontColorGetter(
					"mui.themes.gradientMode.powerColorMap." .. I.Enum.GradientMode.Color.SHIFT,
					P.themes.gradientMode.powerColorMap[I.Enum.GradientMode.Color.SHIFT],
					power
				),
				set = self:GetFontColorSetter(
					"mui.themes.gradientMode.powerColorMap." .. I.Enum.GradientMode.Color.SHIFT,
					function()
						F.Event.TriggerEvent("MER_Theme.SettingsUpdate.Power")
					end,
					power
				),
			}

			-- Spacer for arrow & arrow
			self:AddInlineSoloDesc(colorGroup, {
				width = 1,
				customWidth = 30,
				name = "",
			})
			self:AddInlineSoloDesc(colorGroup, {
				width = 1,
				customWidth = 30,
				name = F.String.Class(">", "MONK"),
			})

			-- Normal Color
			colorGroup[power .. "normal"] = {
				order = self:GetOrder(),
				type = "color",
				name = "",
				hasAlpha = false,
				width = 1,
				customWidth = 30,
				get = self:GetFontColorGetter(
					"mui.themes.gradientMode.powerColorMap." .. I.Enum.GradientMode.Color.NORMAL,
					P.themes.gradientMode.powerColorMap[I.Enum.GradientMode.Color.NORMAL],
					power
				),
				set = self:GetFontColorSetter(
					"mui.themes.gradientMode.powerColorMap." .. I.Enum.GradientMode.Color.NORMAL,
					function()
						F.Event.TriggerEvent("MER_Theme.SettingsUpdate.Power")
					end,
					power
				),
			}

			-- Gradient Preview
			colorGroup[power .. "preview"] = {
				order = self:GetOrder(),
				type = "description",
				name = "powerColorMap:" .. power,
				dialogControl = "MERGradientPreview",
				width = 1,
				customWidth = 120,
			}

			-- Spacer
			self:AddTinySpacer(colorGroup)
		end

		for power, _ in pairs(P.themes.gradientMode.powerColorMap[I.Enum.GradientMode.Color.SHIFT]) do
			generatePowerColors(power)
		end
	end

	-- Other Colors
	do
		-- Tab
		local tab = self:AddGroup(options, {
			name = L["Other Colors"],
		}).args

		-- State Group
		local stateGroup = self:AddInlineDesc(tab, {
			name = L["State Colors"],
		}, {
			name = L["Here you can change the "]
				.. F.String.Class("gradient shifts", "MONK")
				.. L[" of State colors.\n\n"],
		}).args

		-- State Colors
		for special, _ in pairs(P.themes.gradientMode.specialColorMap[I.Enum.GradientMode.Color.SHIFT]) do
			local nameColor = P.themes.gradientMode.specialColorMap[I.Enum.GradientMode.Color.NORMAL][special]
			if special == "DEAD" then
				nameColor = F.Table.HexToRGB("#ffffff")
			end

			-- State Description
			self:AddInlineSoloDesc(stateGroup, {
				width = 1,
				customWidth = 120,
				name = F.String.RGB(F.String.LowercaseEnum(special), nameColor),
			})

			-- Shift Color
			stateGroup[special .. "shift"] = {
				order = self:GetOrder(),
				type = "color",
				name = "",
				hasAlpha = false,
				width = 1,
				customWidth = 30,
				get = self:GetFontColorGetter(
					"mui.themes.gradientMode.specialColorMap." .. I.Enum.GradientMode.Color.SHIFT,
					P.themes.gradientMode.specialColorMap[I.Enum.GradientMode.Color.SHIFT],
					special
				),
				set = self:GetFontColorSetter(
					"mui.themes.gradientMode.specialColorMap." .. I.Enum.GradientMode.Color.SHIFT,
					function()
						F.Event.TriggerEvent("MER_Theme.SettingsUpdate.Health")
					end,
					special
				),
			}

			-- Spacer for arrow & arrow
			self:AddInlineSoloDesc(stateGroup, {
				width = 1,
				customWidth = 30,
				name = "",
			})
			self:AddInlineSoloDesc(stateGroup, {
				width = 1,
				customWidth = 30,
				name = F.String.Class(">", "MONK"),
			})

			-- Normal Color
			stateGroup[special .. "normal"] = {
				order = self:GetOrder(),
				type = "color",
				name = "",
				hasAlpha = false,
				width = 1,
				customWidth = 30,
				get = self:GetFontColorGetter(
					"mui.themes.gradientMode.specialColorMap." .. I.Enum.GradientMode.Color.NORMAL,
					P.themes.gradientMode.specialColorMap[I.Enum.GradientMode.Color.NORMAL],
					special
				),
				set = self:GetFontColorSetter(
					"mui.themes.gradientMode.specialColorMap." .. I.Enum.GradientMode.Color.NORMAL,
					function()
						F.Event.TriggerEvent("MER_Theme.SettingsUpdate.Health")
					end,
					special
				),
			}

			-- Gradient Preview
			stateGroup[special .. "preview"] = {
				order = self:GetOrder(),
				type = "description",
				name = "specialColorMap:" .. special,
				dialogControl = "MERGradientPreview",
				width = 1,
				customWidth = 120,
			}

			-- Spacer
			self:AddTinySpacer(stateGroup)
		end

		self:AddSpacer(tab)

		-- Cast Group
		local castGroup = self:AddInlineDesc(tab, {
			name = L["Castbar Colors"],
		}, {
			name = L["Here you can change the "]
				.. F.String.Class("gradient shifts", "MONK")
				.. L[" of Castbar colors.\n\n"],
		}).args

		-- Cast Colors
		for cast, _ in pairs(P.themes.gradientMode.castColorMap[I.Enum.GradientMode.Color.SHIFT]) do
			if (cast == "NOINTERRUPT") or (cast == "DEFAULT") then
				-- Name
				local settingsName
				if cast == "NOINTERRUPT" then
					settingsName = "Non-interruptible"
				elseif cast == "DEFAULT" then
					settingsName = "Regular"
				else
					settingsName = F.String.LowercaseEnum(cast)
				end

				-- Cast Description
				self:AddInlineSoloDesc(castGroup, {
					width = 1,
					customWidth = 120,
					name = F.String.RGB(
						settingsName,
						P.themes.gradientMode.castColorMap[I.Enum.GradientMode.Color.NORMAL][cast]
					),
				})

				-- Shift Color
				castGroup[cast .. "shift"] = {
					order = self:GetOrder(),
					type = "color",
					name = "",
					hasAlpha = false,
					width = 1,
					customWidth = 30,
					get = self:GetFontColorGetter(
						"mui.themes.gradientMode.castColorMap." .. I.Enum.GradientMode.Color.SHIFT,
						P.themes.gradientMode.castColorMap[I.Enum.GradientMode.Color.SHIFT],
						cast
					),
					set = self:GetFontColorSetter(
						"mui.themes.gradientMode.castColorMap." .. I.Enum.GradientMode.Color.SHIFT,
						function()
							F.Event.TriggerEvent("MER_Theme.SettingsUpdate")
						end,
						cast
					),
				}

				-- Spacer for arrow & arrow
				self:AddInlineSoloDesc(castGroup, {
					width = 1,
					customWidth = 30,
					name = "",
				})
				self:AddInlineSoloDesc(castGroup, {
					width = 1,
					customWidth = 30,
					name = F.String.Class(">", "MONK"),
				})

				-- Normal Color
				castGroup[cast .. "normal"] = {
					order = self:GetOrder(),
					type = "color",
					name = "",
					hasAlpha = false,
					width = 1,
					customWidth = 30,
					get = self:GetFontColorGetter(
						"mui.themes.gradientMode.castColorMap." .. I.Enum.GradientMode.Color.NORMAL,
						P.themes.gradientMode.castColorMap[I.Enum.GradientMode.Color.NORMAL],
						cast
					),
					set = self:GetFontColorSetter(
						"mui.themes.gradientMode.castColorMap." .. I.Enum.GradientMode.Color.NORMAL,
						function()
							F.Event.TriggerEvent("MER_Theme.SettingsUpdate")
						end,
						cast
					),
				}

				-- Gradient Preview
				castGroup[cast .. "preview"] = {
					order = self:GetOrder(),
					type = "description",
					name = "castColorMap:" .. cast,
					dialogControl = "MERGradientPreview",
					width = 1,
					customWidth = 120,
				}

				-- Spacer
				self:AddTinySpacer(castGroup)
			end
		end
	end

	-- Fade Direction
	do
		local name = L["Fade Direction"]

		-- Tab
		local tab = self:AddGroup(options, {
			name = name,
		}).args

		local directionValues = {
			[I.Enum.GradientMode.Direction.LEFT] = "Left",
			[I.Enum.GradientMode.Direction.RIGHT] = "Right",
		}

		local function directionGet(unitType)
			return function()
				return E.db.mui.themes.gradientMode.fadeDirection[unitType]
			end
		end

		local function directionSet(unitType)
			return function(_, value)
				if E.db.mui.themes.gradientMode.fadeDirection[unitType] == value then
					return
				end
				E.db.mui.themes.gradientMode.fadeDirection[unitType] = value
				F.Event.TriggerEvent("MER_Theme.SettingsUpdate")
				F.Event.TriggerEvent("MER_Theme.SettingsUpdate.Health")
				F.Event.TriggerEvent("MER_Theme.SettingsUpdate.Power", true)
			end
		end

		-- Player & Target
		do
			local group = self:AddInlineDesc(tab, {
				name = L["Player & Target"],
			}, {
				name = L["Control the gradient fade direction for player and target unitframes.\n\n"],
			}).args

			group.player = {
				order = self:GetOrder(),
				type = "select",
				name = L["Player"],
				values = directionValues,
				get = directionGet("player"),
				set = directionSet("player"),
			}

			group.pet = {
				order = self:GetOrder(),
				type = "select",
				name = L["Pet"],
				values = directionValues,
				get = directionGet("pet"),
				set = directionSet("pet"),
			}

			group.target = {
				order = self:GetOrder(),
				type = "select",
				name = L["Target"],
				values = directionValues,
				get = directionGet("target"),
				set = directionSet("target"),
			}

			group.targettarget = {
				order = self:GetOrder(),
				type = "select",
				name = L["Target of Target"],
				values = directionValues,
				get = directionGet("targettarget"),
				set = directionSet("targettarget"),
			}

			group.focus = {
				order = self:GetOrder(),
				type = "select",
				name = L["Focus"],
				values = directionValues,
				get = directionGet("focus"),
				set = directionSet("focus"),
			}
		end

		-- Spacer
		self:AddSpacer(tab)

		-- Group Frames
		do
			local group = self:AddInlineDesc(tab, {
				name = L["Group Frames"],
			}, {
				name = L["Control the gradient fade direction for party and raid unitframes.\n\n"],
			}).args

			group.party = {
				order = self:GetOrder(),
				type = "select",
				name = L["Party"],
				values = directionValues,
				get = directionGet("party"),
				set = directionSet("party"),
			}

			group.raid1 = {
				order = self:GetOrder(),
				type = "select",
				name = L["Raid 1"],
				values = directionValues,
				get = directionGet("raid1"),
				set = directionSet("raid1"),
			}

			group.raid2 = {
				order = self:GetOrder(),
				type = "select",
				name = L["Raid 2"],
				values = directionValues,
				get = directionGet("raid2"),
				set = directionSet("raid2"),
			}

			group.raid3 = {
				order = self:GetOrder(),
				type = "select",
				name = L["Raid 3"],
				values = directionValues,
				get = directionGet("raid3"),
				set = directionSet("raid3"),
			}
		end

		-- Spacer
		self:AddSpacer(tab)

		-- Boss & Arena
		do
			local group = self:AddInlineDesc(tab, {
				name = L["Boss & Arena"],
			}, {
				name = L["Control the gradient fade direction for boss and arena unitframes.\n\n"],
			}).args

			group.boss = {
				order = self:GetOrder(),
				type = "select",
				name = L["Boss"],
				values = directionValues,
				get = directionGet("boss"),
				set = directionSet("boss"),
			}

			group.arena = {
				order = self:GetOrder(),
				type = "select",
				name = L["Arena"],
				values = directionValues,
				get = directionGet("arena"),
				set = directionSet("arena"),
			}
		end

		-- Spacer
		self:AddSpacer(tab)

		-- Role Frames
		do
			local group = self:AddInlineDesc(tab, {
				name = L["Role Frames"],
			}, {
				name = L["Control the gradient fade direction for tank and assist unitframes.\n\n"],
			}).args

			group.tank = {
				order = self:GetOrder(),
				type = "select",
				name = L["Tank"],
				values = directionValues,
				get = directionGet("tank"),
				set = directionSet("tank"),
			}

			group.tanktarget = {
				order = self:GetOrder(),
				type = "select",
				name = L["Tank Target"],
				values = directionValues,
				get = directionGet("tanktarget"),
				set = directionSet("tanktarget"),
			}

			group.assist = {
				order = self:GetOrder(),
				type = "select",
				name = L["Assist"],
				values = directionValues,
				get = directionGet("assist"),
				set = directionSet("assist"),
			}

			group.assisttarget = {
				order = self:GetOrder(),
				type = "select",
				name = L["Assist Target"],
				values = directionValues,
				get = directionGet("assisttarget"),
				set = directionSet("assisttarget"),
			}
		end
	end

	-- Settings
	do
		local name = "Settings"

		-- Tab
		local tab = self:AddGroup(options, {
			name = name,
		}).args

		-- Settings Group
		self:AddInlineDesc(tab, {
			name = name,
		}, {
			name = L["Here you can change additional settings for the " .. gradientTitle .. " Mode|r.\n\n"],
		})

		-- Spacer
		self:AddSpacer(tab)

		do
			local texturesGroup = self:AddInlineDesc(tab, {
				name = L["UnitFrame Textures"],
			}, {
				name = L["Change the textures used for UnitFrame's Health, Power and Cast status bars."],
			}).args

			texturesGroup.health = ACH:SharedMediaStatusbar(
				L["Health Texture"],
				L["Health bar texture for UnitFrames"],
				self:GetOrder(),
				200,
				function()
					return E.db.mui.themes.gradientMode.textures.health
				end,
				function(_, value)
					E.db.mui.themes.gradientMode.textures.health = value
					F.Event.TriggerEvent("MER_Theme.TexturesUpdate")
				end
			)

			texturesGroup.power = ACH:SharedMediaStatusbar(
				L["Power Texture"],
				L["Power bar texture for UnitFrames"],
				self:GetOrder(),
				200,
				function()
					return E.db.mui.themes.gradientMode.textures.power
				end,
				function(_, value)
					E.db.mui.themes.gradientMode.textures.power = value
					F.Event.TriggerEvent("MER_Theme.TexturesUpdate")
				end
			)

			texturesGroup.cast = ACH:SharedMediaStatusbar(
				L["Castbar Texture"],
				L["Castbar texture for UnitFrames"],
				self:GetOrder(),
				200,
				function()
					return E.db.mui.themes.gradientMode.textures.cast
				end,
				function(_, value)
					E.db.mui.themes.gradientMode.textures.cast = value
					F.Event.TriggerEvent("MER_Theme.TexturesUpdate")
				end
			)
		end

		-- Spacer
		self:AddSpacer(tab)

		do
			local brightnessGroup = self:AddInlineDesc(tab, {
				name = L["Background Brightness"],
				get = function(info)
					return E.db.mui.themes.gradientMode[info[#info]]
				end,
				set = function(info, value)
					if E.db.mui.themes.gradientMode[info[#info]] == value then
						return
					end

					E.db.mui.themes.gradientMode[info[#info]] = value
					F.Event.TriggerEvent("MER_Theme.SettingsUpdate.Health")
					F.Event.TriggerEvent("MER_Theme.SettingsUpdate.Power", true)
				end,
			}, {
				name = L["This controls the strength of the background colors.\n\nLower value means a darker background, higher value means a lighter background.\n\n"]
					.. F.String.Error(L["Warning: Setting this too high may cause readability issues!"]),
			}).args

			-- Background Multiplier Size
			brightnessGroup.backgroundMultiplier = {
				order = self:GetOrder(),
				type = "range",
				name = "",
				min = 0,
				max = 0.5,
				step = 0.01,
				isPercent = true,
				width = 2,
			}
		end

		-- Spacer
		self:AddSpacer(tab)

		-- Saturation Boost
		local saturationGroup = self:AddInlineDesc(tab, {
			name = L["Saturation Boost"],
			get = function(info)
				return E.db.mui.themes.gradientMode.saturationBoost[info[#info]]
			end,
			set = function(info, value)
				if E.db.mui.themes.gradientMode.saturationBoost[info[#info]] == value then
					return
				end

				E.db.mui.themes.gradientMode.saturationBoost[info[#info]] = value
				F.Event.TriggerEvent("MER_Theme.SettingsUpdate.Health")
				F.Event.TriggerEvent("MER_Theme.SettingsUpdate.Power", true)
			end,
		}, {
			name = L["Boosts the saturation and darkens "]
				.. gradientTitle
				.. L[" Colors|r\nFor people that like it a bit more extreme\n\n"],
		}).args

		saturationGroup.enabled = {
			order = self:GetOrder(),
			type = "toggle",
			name = function()
				return self:GetEnableName(E.db.mui.themes.gradientMode.saturationBoost.enable, saturationGroup)
			end,
		}

		saturationGroup.shiftLight = {
			order = self:GetOrder(),
			type = "range",
			name = L["Shift Lightness"],
			desc = L["Control the Lightness value of HSL for the Shift color."],
			min = 0.1,
			max = 2,
			step = 0.01,
		}

		saturationGroup.shiftSat = {
			order = self:GetOrder(),
			type = "range",
			name = L["Shift Saturation"],
			desc = L["Control the Saturation value of HSL for the Shift color."],
			min = 0.1,
			max = 1,
			step = 0.01,
		}

		saturationGroup.normalLight = {
			order = self:GetOrder(),
			type = "range",
			name = L["Normal Lightness"],
			desc = L["Control the Lightness value of HSL for the Normal color."],
			min = 0.1,
			max = 2,
			step = 0.01,
		}

		saturationGroup.normalSat = {
			order = self:GetOrder(),
			type = "range",
			name = L["Normal Saturation"],
			desc = L["Control the Saturation value of HSL for the Normal color."],
			min = 0.1,
			max = 1,
			step = 0.01,
		}

		-- Spacer
		self:AddSpacer(tab)
	end
end

module:AddCallback("MerathilisUI_Themes_GradientMode")
