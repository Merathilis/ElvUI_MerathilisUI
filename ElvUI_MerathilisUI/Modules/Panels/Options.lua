local MER, E, L, V, P, G = unpack(select(2, ...))
local PN = MER:GetModule("Panels")

--Cache global variables
--Lua functions
local _G = _G
local tinsert = table.insert
--WoW API / Variables
-- GLOBALS:

local function PanelTable()
	E.Options.args.mui.args.modules.args.panels = {
		type = "group",
		name = E.NewSign..L["Panels"],
		args = {
			header = {
				order = 0,
				type = "header",
				name = E.NewSign..MER:cOption(L["Panels"]),
			},
			spacer = {
				order = 2,
				type = "description",
				name = "",
			},
			panels = {
				order = 3,
				type = "group",
				name = MER:cOption(L["Panels"]),
				guiInline = true,
				args = {
					topPanel = {
						order = 1,
						type = "toggle",
						name = L["Top Panel"],
						get = function(info) return E.db.mui.panels.topPanel end,
						set = function(info, value) E.db.mui.panels.topPanel = value; PN:UpdatePanels() end,
					},
					bottomPanel = {
						order = 2,
						type = "toggle",
						name = L["Bottom Panel"],
						get = function(info) return E.db.mui.panels.bottomPanel end,
						set = function(info, value) E.db.mui.panels.bottomPanel = value; PN:UpdatePanels() end,
					},
				},
			},
			stylepanels = {
				order = 4,
				type = "group",
				name = MER:cOption(L["Style Panels"]),
				guiInline = true,
				args = {
					topLeftPanel = {
						order = 1,
						type = "toggle",
						name = L["Top Left Panel"],
						get = function(info) return E.db.mui.panels.stylePanels.topLeftPanel end,
						set = function(info, value) E.db.mui.panels.stylePanels.topLeftPanel = value; PN:UpdatePanels() end,
					},
					topLeftExtraPanel = {
						order = 2,
						type = "toggle",
						name = L["Top Left Extra Panel"],
						get = function(info) return E.db.mui.panels.stylePanels.topLeftExtraPanel end,
						set = function(info, value) E.db.mui.panels.stylePanels.topLeftExtraPanel = value; PN:UpdatePanels() end,
						disabled = function() return not E.db.mui.panels.stylePanels.topLeftPanel end,
					},
					spacer = {
						order = 3,
						type = "description",
						name = "",
					},
					topRightPanel = {
						order = 4,
						type = "toggle",
						name = L["Top Right Panel"],
						get = function(info) return E.db.mui.panels.stylePanels.topRightPanel end,
						set = function(info, value) E.db.mui.panels.stylePanels.topRightPanel = value; PN:UpdatePanels() end,
					},
					topRightExtraPanel = {
						order = 5,
						type = "toggle",
						name = L["Top Right Extra Panel"],
						get = function(info) return E.db.mui.panels.stylePanels.topRightExtraPanel end,
						set = function(info, value) E.db.mui.panels.stylePanels.topRightExtraPanel = value; PN:UpdatePanels() end,
						disabled = function() return not E.db.mui.panels.stylePanels.topRightPanel end,
					},
					spacer1 = {
						order = 6,
						type = "description",
						name = "",
					},
					bottomLeftPanel = {
						order = 7,
						type = "toggle",
						name = L["Bottom Left Panel"],
						get = function(info) return E.db.mui.panels.stylePanels.bottomLeftPanel end,
						set = function(info, value) E.db.mui.panels.stylePanels.bottomLeftPanel = value; PN:UpdatePanels() end,
					},
					bottomLeftExtraPanel = {
						order = 8,
						type = "toggle",
						name = L["Bottom Left Extra Panel"],
						get = function(info) return E.db.mui.panels.stylePanels.bottomLeftExtraPanel end,
						set = function(info, value) E.db.mui.panels.stylePanels.bottomLeftExtraPanel = value; PN:UpdatePanels() end,
						disabled = function() return not E.db.mui.panels.stylePanels.bottomLeftPanel end,
					},
					spacer2 = {
						order = 9,
						type = "description",
						name = "",
					},
					bottomRightPanel = {
						order = 10,
						type = "toggle",
						name = L["Bottom Right Panel"],
						get = function(info) return E.db.mui.panels.stylePanels.bottomRightPanel end,
						set = function(info, value) E.db.mui.panels.stylePanels.bottomRightPanel = value; PN:UpdatePanels() end,
					},
					bottomRightExtraPanel = {
						order = 11,
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
