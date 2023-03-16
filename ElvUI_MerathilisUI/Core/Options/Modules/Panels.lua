local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local module = MER:GetModule('MER_Panels')
local options = MER.options.modules.args

options.panels = {
	type = "group",
	name = L["Panels"],
	get = function(info) return E.db.mui.panels[ info[#info] ] end,
	set = function(info, value) E.db.mui.panels[ info[#info] ] = value; end,
	args = {
		header = {
			order = 1,
			type = "header",
			name = F.cOption(L["Panels"], 'orange'),
		},
		color = {
			order = 1,
			type = "group",
			name = F.cOption(L["Color"], 'orange'),
			guiInline = true,
			args = {
				colorType = {
					order = 1,
					name = L["Color"],
					type = "select",
					get = function(info) return E.db.mui.panels[ info[#info] ] end,
					set = function(info, value) E.db.mui.panels[ info[#info] ] = value; module:UpdateColors() end,
					values = {
						["DEFAULT"] = DEFAULT,
						["CLASS"] = CLASS,
						["CUSTOM"] = CUSTOM,
					},
				},
				customColor = {
					type = "color",
					order = 2,
					name = L["Custom Color"],
					disabled = function() return E.db.mui.panels.colorType ~= "CUSTOM" end,
					get = function(info)
						local t = E.db.mui.panels[ info[#info] ]
						local d = P.panels[info[#info]]
						return t.r, t.g, t.b, d.r, d.g, d.b
					end,
					set = function(info, r, g, b)
						E.db.mui.panels[ info[#info] ] = {}
						local t = E.db.mui.panels[ info[#info] ]
						t.r, t.g, t.b = r, g, b
						module:UpdateColors()
					end,
				},
			},
		},
		panels = {
			order = 2,
			type = "group",
			name = F.cOption(L["Panels"], 'orange'),
			guiInline = true,
			args = {
				topPanel = {
					order = 1,
					type = "toggle",
					name = L["Top Panel"],
					get = function(info) return E.db.mui.panels.topPanel end,
					set = function(info, value) E.db.mui.panels.topPanel = value; module:UpdatePanels() end,
				},
				topPanelHeight = {
					order = 2,
					type = "range",
					name = L["Height"],
					min = 1, max = 400, step = 1,
					get = function(info) return E.db.mui.panels.topPanelHeight end,
					set = function(info, value) E.db.mui.panels.topPanelHeight = value; module:Resize() end,
					disabled = function() return not E.db.mui.panels.topPanel end,
				},
				spacer = {
					order = 3,
					type = "description",
					name = '',
				},
				bottomPanel = {
					order = 4,
					type = "toggle",
					name = L["Bottom Panel"],
					get = function(info) return E.db.mui.panels.bottomPanel end,
					set = function(info, value) E.db.mui.panels.bottomPanel = value; module:UpdatePanels() end,
				},
				bottomPanelHeight = {
					order = 5,
					type = "range",
					name = L["Height"],
					min = 1, max = 400, step = 1,
					get = function(info) return E.db.mui.panels.bottomPanelHeight end,
					set = function(info, value) E.db.mui.panels.bottomPanelHeight = value; module:Resize() end,
					disabled = function() return not E.db.mui.panels.bottomPanel end,
				},
			},
		},
		stylepanels = {
			order = 3,
			type = "group",
			name = F.cOption(L["Style Panels"], 'orange'),
			guiInline = true,
			args = {
				panelSize = {
					order = 1,
					name = L["Width"],
					type = "range",
					min = 50, max = 800, step = 1,
					get = function(info) return E.db.mui.panels.panelSize end,
					set = function(info, value) E.db.mui.panels.panelSize = value; module:Resize() end,
				},
				spacer = {
					order = 2,
					type = "description",
					name = "",
					width = "full",
				},
				topLeftPanel = {
					order = 3,
					type = "toggle",
					name = L["Top Left Panel"],
					get = function(info) return E.db.mui.panels.stylePanels.topLeftPanel end,
					set = function(info, value) E.db.mui.panels.stylePanels.topLeftPanel = value; module:UpdatePanels() end,
				},
				topLeftExtraPanel = {
					order = 4,
					type = "toggle",
					name = L["Top Left Extra Panel"],
					get = function(info) return E.db.mui.panels.stylePanels.topLeftExtraPanel end,
					set = function(info, value) E.db.mui.panels.stylePanels.topLeftExtraPanel = value; module:UpdatePanels() end,
					disabled = function() return not E.db.mui.panels.stylePanels.topLeftPanel end,
				},
				spacer1 = {
					order = 5,
					type = "description",
					name = "",
				},
				topRightPanel = {
					order = 6,
					type = "toggle",
					name = L["Top Right Panel"],
					get = function(info) return E.db.mui.panels.stylePanels.topRightPanel end,
					set = function(info, value) E.db.mui.panels.stylePanels.topRightPanel = value; module:UpdatePanels() end,
				},
				topRightExtraPanel = {
					order = 7,
					type = "toggle",
					name = L["Top Right Extra Panel"],
					get = function(info) return E.db.mui.panels.stylePanels.topRightExtraPanel end,
					set = function(info, value) E.db.mui.panels.stylePanels.topRightExtraPanel = value; module:UpdatePanels() end,
					disabled = function() return not E.db.mui.panels.stylePanels.topRightPanel end,
				},
				spacer2 = {
					order = 8,
					type = "description",
					name = "",
				},
				bottomLeftPanel = {
					order = 9,
					type = "toggle",
					name = L["Bottom Left Panel"],
					get = function(info) return E.db.mui.panels.stylePanels.bottomLeftPanel end,
					set = function(info, value) E.db.mui.panels.stylePanels.bottomLeftPanel = value; module:UpdatePanels() end,
				},
				bottomLeftExtraPanel = {
					order = 10,
					type = "toggle",
					name = L["Bottom Left Extra Panel"],
					get = function(info) return E.db.mui.panels.stylePanels.bottomLeftExtraPanel end,
					set = function(info, value) E.db.mui.panels.stylePanels.bottomLeftExtraPanel = value; module:UpdatePanels() end,
					disabled = function() return not E.db.mui.panels.stylePanels.bottomLeftPanel end,
				},
				spacer3 = {
					order = 11,
					type = "description",
					name = "",
				},
				bottomRightPanel = {
					order = 12,
					type = "toggle",
					name = L["Bottom Right Panel"],
					get = function(info) return E.db.mui.panels.stylePanels.bottomRightPanel end,
					set = function(info, value) E.db.mui.panels.stylePanels.bottomRightPanel = value; module:UpdatePanels() end,
				},
				bottomRightExtraPanel = {
					order = 13,
					type = "toggle",
					name = L["Bottom Right Extra Panel"],
					get = function(info) return E.db.mui.panels.stylePanels.bottomRightExtraPanel end,
					set = function(info, value) E.db.mui.panels.stylePanels.bottomRightExtraPanel = value; module:UpdatePanels() end,
					disabled = function() return not E.db.mui.panels.stylePanels.bottomRightPanel end,
				},
			},
		},
	},
}
