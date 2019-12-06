local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule("MERDashBoard")

--Cache global variables
--Lua functions
local pairs = pairs
--WoW API / Variables
-- GLOBALS:

local boards = {"FPS", "MS", "Volume"}

local function UpdateSystemOptions()
	for _, boardname in pairs(boards) do
		local optionOrder = 1
		E.Options.args.mui.args.modules.args.dashboard.args.system.args.chooseSystem.args[boardname] = {
			order = optionOrder + 1,
			type = "toggle",
			name = boardname,
			desc = L["Enable/Disable "]..boardname,
			get = function(info) return E.db.mui.dashboard.system.chooseSystem[boardname] end,
			set = function(info, value) E.db.mui.dashboard.system.chooseSystem[boardname] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
		}
	end

	E.Options.args.mui.args.modules.args.dashboard.args.system.args.latency = {
		order = 10,
		type = "select",
		name = L["Latency (MS)"],
		values = {
			[1] = L["HOME"],
			[2] = L["WORLD"],
		},
		disabled = function() return not E.db.mui.dashboard.system.chooseSystem.MS end,
		get = function(info) return E.db.mui.dashboard.system.latency end,
		set = function(info, value) E.db.mui.dashboard.system.latency = value; E:StaticPopup_Show('PRIVATE_RL'); end,
	}
end

local function DashboardsTable()
	E.Options.args.mui.args.modules.args.dashboard = {
		type = "group",
		name = E.NewSign..L["Dashboard"],
		hidden = function() return IsAddOnLoaded("ElvUI_BenikUI") end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = MER:cOption(L["Dashboard"]),
			},
			credits = {
				order = 2,
				type = "group",
				name = MER:cOption(L["Credits"]),
				guiInline = true,
				args = {
					tukui = {
						order = 1,
						type = "description",
						fontSize = "medium",
						name = format("|cff00c0faBenikUI|r"),
					},
				},
			},
			dashColor = {
				order = 3,
				type = "group",
				name = MER:cOption(L.COLOR),
				guiInline = true,
				args = {
					barColor = {
						type = "select",
						order = 1,
						name = L["Bar Color"],
						values = {
							[1] = L.CLASS,
							[2] = L.CUSTOM,
						},
						get = function(info) return E.db.mui.dashboard[ info[#info] ] end,
						set = function(info, value) E.db.mui.dashboard[ info[#info] ] = value;
							if E.db.mui.dashboard.system.enableSystem then module:UpdateSystemSettings(); end
						end,
					},
					customBarColor = {
						type = "select",
						order = 2,
						type = "color",
						name = L.COLOR,
						disabled = function() return E.db.mui.dashboard.barColor == 1 end,
						get = function(info)
							local t = E.db.mui.dashboard[ info[#info] ]
							local d = P.mui.dashboard[info[#info]]
							return t.r, t.g, t.b, t.a, d.r, d.g, d.b
						end,
						set = function(info, r, g, b, a)
							E.db.mui.dashboard[ info[#info] ] = {}
							local t = E.db.mui.dashboard[ info[#info] ]
							t.r, t.g, t.b, t.a = r, g, b, a
							if E.db.mui.dashboard.system.enableSystem then module:UpdateSystemSettings(); end
						end,
					},
					spacer = {
						order = 3,
						type = "description",
						name = '',
					},
					textColor = {
						order = 4,
						type = "select",
						name = L["Text Color"],
						values = {
							[1] = L.CLASS,
							[2] = L.CUSTOM,
						},
						get = function(info) return E.db.mui.dashboard[ info[#info] ] end,
						set = function(info, value) E.db.mui.dashboard[ info[#info] ] = value;
							if E.db.mui.dashboard.system.enableSystem then module:UpdateSystemSettings(); end
						end,
					},
					customTextColor = {
						order = 5,
						type = "color",
						name = L.COLOR,
						disabled = function() return E.db.mui.dashboard.textColor == 1 end,
						get = function(info)
							local t = E.db.mui.dashboard[ info[#info] ]
							local d = P.mui.dashboard[info[#info]]
							return t.r, t.g, t.b, t.a, d.r, d.g, d.b
							end,
						set = function(info, r, g, b, a)
							E.db.mui.dashboard[ info[#info] ] = {}
							local t = E.db.mui.dashboard[ info[#info] ]
							t.r, t.g, t.b, t.a = r, g, b, a
							if E.db.mui.dashboard.system.enableSystem then module:UpdateSystemSettings(); end
						end,
					},
				},
			},
			dashfont = {
				order = 4,
				type = "group",
				name = MER:cOption(L["Font"]),
				guiInline = true,
				disabled = function() return not E.db.mui.dashboard.system.enableSystem end,
				get = function(info) return E.db.mui.dashboard.dashfont[ info[#info] ] end,
				set = function(info, value) E.db.mui.dashboard.dashfont[ info[#info] ] = value;
					if E.db.mui.dashboard.system.enableSystem then module:UpdateSystemSettings(); end;
				end,
				args = {
					useDTfont = {
						order = 1,
						name = L["Use DataTexts font"],
						type = "toggle",
						width = "full",
					},
					dbfont = {
						type = "select", dialogControl = "LSM30_Font",
						order = 2,
						name = L["Font"],
						disabled = function() return E.db.mui.dashboard.dashfont.useDTfont end,
						values = AceGUIWidgetLSMlists.font,
					},
					dbfontsize = {
						order = 3,
						name = L.FONT_SIZE,
						disabled = function() return E.db.mui.dashboard.dashfont.useDTfont end,
						type = "range",
						min = 6, max = 22, step = 1,
					},
					dbfontflags = {
						order = 4,
						name = L["Font Outline"],
						disabled = function() return E.db.mui.dashboard.dashfont.useDTfont end,
						type = 'select',
						values = {
							['NONE'] = L['None'],
							['OUTLINE'] = 'OUTLINE',
							['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
							['THICKOUTLINE'] = 'THICKOUTLINE',
						},
					},
				},
			},
			system = {
				order = 5,
				type = 'group',
				name = MER:cOption(L["System"]),
				guiInline = true,
				args = {
					name = {
						order = 1,
						type = 'header',
						name = MER:cOption(L["System"]),
					},
					enableSystem = {
						order = 2,
						type = "toggle",
						name = L["Enable"],
						width = "full",
						desc = L["Enable the System Dashboard."],
						get = function(info) return E.db.mui.dashboard.system.enableSystem end,
						set = function(info, value) E.db.mui.dashboard.system.enableSystem = value; E:StaticPopup_Show('PRIVATE_RL'); end,
					},
					combat = {
						order = 3,
						name = L["Hide In Combat"],
						type = 'toggle',
						disabled = function() return not E.db.mui.dashboard.system.enableSystem end,
						get = function(info) return E.db.mui.dashboard.system.combat end,
						set = function(info, value) E.db.mui.dashboard.system.combat = value; module:EnableDisableCombat(MER_SystemDashboard, 'system'); end,
					},
					width = {
						order = 4,
						type = "range",
						name = L["Width"],
						desc = L["Change the System Dashboard width."],
						min = 120, max = 520, step = 1,
						disabled = function() return not E.db.mui.dashboard.system.enableSystem end,
						get = function(info) return E.db.mui.dashboard.system.width end,
						set = function(info, value) E.db.mui.dashboard.system.width = value; module:UpdateHolderDimensions(MER_SystemDashboard, 'system', module.SystemDB); module:UpdateSystemSettings(); E:StaticPopup_Show('PRIVATE_RL'); end,
					},
					transparency = {
						order = 6,
						name = L["Panel Transparency"],
						type = 'toggle',
						disabled = function() return not E.db.mui.dashboard.system.enableSystem end,
						get = function(info) return E.db.mui.dashboard.system.transparency end,
						set = function(info, value) E.db.mui.dashboard.system.transparency = value; module:ToggleTransparency(MER_SystemDashboard, 'system'); end,
					},
					backdrop = {
						order = 7,
						name = L['Backdrop'],
						type = 'toggle',
						disabled = function() return not E.db.mui.dashboard.system.enableSystem end,
						get = function(info) return E.db.mui.dashboard.system.backdrop end,
						set = function(info, value) E.db.mui.dashboard.system.backdrop = value; module:ToggleTransparency(MER_SystemDashboard, 'system'); end,
					},
					chooseSystem = {
						order = 8,
						type = "group",
						guiInline = true,
						name = MER:cOption(L["Select System Board"]),
						disabled = function() return not E.db.mui.dashboard.system.enableSystem end,
						args = {
						},
					},
				},
			},
		},
	}
end

tinsert(MER.Config, DashboardsTable)
tinsert(MER.Config, UpdateSystemOptions)
