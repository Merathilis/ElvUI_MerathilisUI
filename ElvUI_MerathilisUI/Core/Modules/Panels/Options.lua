local MER, F, E, L, V, P, G = unpack(select(2, ...))
local PN = MER:GetModule('MER_Panels')

local tinsert = table.insert

local function PanelTable()
	local ACH = E.Libs.ACH

	E.Options.args.mui.args.modules.args.panels = {
		type = "group",
		name = E.NewSign..L["Panels"],
		args = {
			header = ACH:Header(MER:cOption(L["Panels"], 'orange'), 0),
			color = {
				order = 1,
				type = "group",
				name = E.NewSign..MER:cOption(L["Color"], 'orange'),
				guiInline = true,
				args = {
					colorType = {
						order = 1,
						name = L["Color"],
						type = "select",
						get = function(info) return E.db.mui.panels[ info[#info] ] end,
						set = function(info, value) E.db.mui.panels[ info[#info] ] = value; PN:UpdateColors() end,
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
							local d = P.mui.panels[info[#info]]
							return t.r, t.g, t.b, d.r, d.g, d.b
						end,
						set = function(info, r, g, b)
							E.db.mui.panels[ info[#info] ] = {}
							local t = E.db.mui.panels[ info[#info] ]
							t.r, t.g, t.b = r, g, b
							PN:UpdateColors()
						end,
					},
				},
			},
			panels = {
				order = 2,
				type = "group",
				name = MER:cOption(L["Panels"], 'orange'),
				guiInline = true,
				args = {
					topPanel = {
						order = 1,
						type = "toggle",
						name = L["Top Panel"],
						get = function(info) return E.db.mui.panels.topPanel end,
						set = function(info, value) E.db.mui.panels.topPanel = value; PN:UpdatePanels() end,
					},
					topPanelHeight = {
						order = 2,
						type = "range",
						name = L["Height"],
						min = 1, max = 400, step = 1,
						get = function(info) return E.db.mui.panels.topPanelHeight end,
						set = function(info, value) E.db.mui.panels.topPanelHeight = value; PN:Resize() end,
						disabled = function() return not E.db.mui.panels.topPanel end,
					},
					spacer = ACH:Spacer(3),
					bottomPanel = {
						order = 4,
						type = "toggle",
						name = L["Bottom Panel"],
						get = function(info) return E.db.mui.panels.bottomPanel end,
						set = function(info, value) E.db.mui.panels.bottomPanel = value; PN:UpdatePanels() end,
					},
					bottomPanelHeight = {
						order = 5,
						type = "range",
						name = L["Height"],
						min = 1, max = 400, step = 1,
						get = function(info) return E.db.mui.panels.bottomPanelHeight end,
						set = function(info, value) E.db.mui.panels.bottomPanelHeight = value; PN:Resize() end,
						disabled = function() return not E.db.mui.panels.bottomPanel end,
					},
				},
			},
			stylepanels = {
				order = 3,
				type = "group",
				name = MER:cOption(L["Style Panels"], 'orange'),
				guiInline = true,
				args = {
					panelSize = {
						order = 1,
						name = L["Width"],
						type = "range",
						min = 50, max = 800, step = 1,
						get = function(info) return E.db.mui.panels.panelSize end,
						set = function(info, value) E.db.mui.panels.panelSize = value; PN:Resize() end,
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
						set = function(info, value) E.db.mui.panels.stylePanels.topLeftPanel = value; PN:UpdatePanels() end,
					},
					topLeftExtraPanel = {
						order = 4,
						type = "toggle",
						name = L["Top Left Extra Panel"],
						get = function(info) return E.db.mui.panels.stylePanels.topLeftExtraPanel end,
						set = function(info, value) E.db.mui.panels.stylePanels.topLeftExtraPanel = value; PN:UpdatePanels() end,
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
						set = function(info, value) E.db.mui.panels.stylePanels.topRightPanel = value; PN:UpdatePanels() end,
					},
					topRightExtraPanel = {
						order = 7,
						type = "toggle",
						name = L["Top Right Extra Panel"],
						get = function(info) return E.db.mui.panels.stylePanels.topRightExtraPanel end,
						set = function(info, value) E.db.mui.panels.stylePanels.topRightExtraPanel = value; PN:UpdatePanels() end,
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
						set = function(info, value) E.db.mui.panels.stylePanels.bottomLeftPanel = value; PN:UpdatePanels() end,
					},
					bottomLeftExtraPanel = {
						order = 10,
						type = "toggle",
						name = L["Bottom Left Extra Panel"],
						get = function(info) return E.db.mui.panels.stylePanels.bottomLeftExtraPanel end,
						set = function(info, value) E.db.mui.panels.stylePanels.bottomLeftExtraPanel = value; PN:UpdatePanels() end,
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
						set = function(info, value) E.db.mui.panels.stylePanels.bottomRightPanel = value; PN:UpdatePanels() end,
					},
					bottomRightExtraPanel = {
						order = 13,
						type = "toggle",
						name = L["Bottom Right Extra Panel"],
						get = function(info) return E.db.mui.panels.stylePanels.bottomRightExtraPanel end,
						set = function(info, value) E.db.mui.panels.stylePanels.bottomRightExtraPanel = value; PN:UpdatePanels() end,
						disabled = function() return not E.db.mui.panels.stylePanels.bottomRightPanel end,
					},
				},
			},
		},
	}
end

tinsert(MER.Config, PanelTable)
