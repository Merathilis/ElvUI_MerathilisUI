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
					topLeftPanel = {
						order = 1,
						type = "toggle",
						name = L["Top Left Panel"],
						get = function(info) return E.db.mui.panels.topLeftPanel end,
						set = function(info, value) E.db.mui.panels.topLeftPanel = value; PN:UpdatePanels() end,
					},
					topRightPanel = {
						order = 2,
						type = "toggle",
						name = L["Top Right Panel"],
						get = function(info) return E.db.mui.panels.topRightPanel end,
						set = function(info, value) E.db.mui.panels.topRightPanel = value; PN:UpdatePanels() end,
					},
					bottomLeftPanel = {
						order = 3,
						type = "toggle",
						name = L["Bottom Left Panel"],
						get = function(info) return E.db.mui.panels.bottomLeftPanel end,
						set = function(info, value) E.db.mui.panels.bottomLeftPanel = value; PN:UpdatePanels() end,
					},
					bottomRightPanel = {
						order = 4,
						type = "toggle",
						name = L["Bottom Right Panel"],
						get = function(info) return E.db.mui.panels.bottomRightPanel end,
						set = function(info, value) E.db.mui.panels.bottomRightPanel = value; PN:UpdatePanels() end,
					},
				},
			},
		},
	}
end

tinsert(MER.Config, PanelTable)
