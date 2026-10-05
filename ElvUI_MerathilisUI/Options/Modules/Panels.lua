local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Panels = MER:GetModule("MER_Panels")

local options = module.options.modules.args

local function Height(order, key, toggleKey)
	return {
		order = order,
		type = "range",
		name = L["Height"],
		min = 1,
		max = 400,
		step = 1,
		get = function()
			return E.db.mui.panels[key]
		end,
		set = function(_, value)
			E.db.mui.panels[key] = value
			Panels:Resize()
		end,
		disabled = function()
			return not E.db.mui.panels[toggleKey]
		end,
	}
end

---Toggle for one of the style panels; the extra panel needs its main panel
local function StylePanel(order, name, key, mainKey)
	return {
		order = order,
		type = "toggle",
		name = name,
		disabled = mainKey and function()
			return not E.db.mui.panels.stylePanels[mainKey]
		end,
		get = function()
			return E.db.mui.panels.stylePanels[key]
		end,
		set = function(_, value)
			E.db.mui.panels.stylePanels[key] = value
			Panels:UpdatePanels()
		end,
	}
end

local function Spacer(order)
	return {
		order = order,
		type = "description",
		name = "",
		width = "full",
	}
end

options.panels = {
	type = "group",
	name = module:AddCategorieIcon(L["Panels"], "panels"),
	args = {
		header = {
			order = 1,
			type = "header",
			name = L["Panels"],
		},
		preview = module.PreviewOption(1.5, "MERPanelsPreview", "panels"),
		color = {
			order = 2,
			type = "group",
			name = L["Color"],
			guiInline = true,
			args = {
				colorType = {
					order = 1,
					name = L["Color"],
					type = "select",
					get = function()
						return E.db.mui.panels.colorType
					end,
					set = function(_, value)
						E.db.mui.panels.colorType = value
						Panels:UpdateColors()
					end,
					values = {
						["DEFAULT"] = DEFAULT,
						["CLASS"] = CLASS,
						["CUSTOM"] = CUSTOM,
					},
				},
				customColor = {
					order = 2,
					type = "color",
					name = L["Custom Color"],
					hasAlpha = false,
					disabled = function()
						return E.db.mui.panels.colorType ~= "CUSTOM"
					end,
					get = function()
						local t = E.db.mui.panels.customColor
						local d = P.panels.customColor
						return t.r, t.g, t.b, nil, d.r, d.g, d.b, nil
					end,
					set = function(_, r, g, b)
						local t = E.db.mui.panels.customColor
						t.r, t.g, t.b = r, g, b
						Panels:UpdateColors()
					end,
				},
			},
		},
		panels = {
			order = 3,
			type = "group",
			name = L["Panels"],
			guiInline = true,
			args = {
				topPanel = {
					order = 1,
					type = "toggle",
					name = L["Top Panel"],
					get = function()
						return E.db.mui.panels.topPanel
					end,
					set = function(_, value)
						E.db.mui.panels.topPanel = value
						Panels:UpdatePanels()
					end,
				},
				topPanelHeight = Height(2, "topPanelHeight", "topPanel"),
				spacer = Spacer(3),
				bottomPanel = {
					order = 4,
					type = "toggle",
					name = L["Bottom Panel"],
					get = function()
						return E.db.mui.panels.bottomPanel
					end,
					set = function(_, value)
						E.db.mui.panels.bottomPanel = value
						Panels:UpdatePanels()
					end,
				},
				bottomPanelHeight = Height(5, "bottomPanelHeight", "bottomPanel"),
			},
		},
		stylepanels = {
			order = 4,
			type = "group",
			name = L["Style Panels"],
			guiInline = true,
			args = {
				panelSize = {
					order = 1,
					name = L["Width"],
					type = "range",
					min = 50,
					max = 800,
					step = 1,
					get = function()
						return E.db.mui.panels.panelSize
					end,
					set = function(_, value)
						E.db.mui.panels.panelSize = value
						Panels:Resize()
					end,
				},
				spacer = Spacer(2),
				topLeftPanel = StylePanel(3, L["Top Left Panel"], "topLeftPanel"),
				topLeftExtraPanel = StylePanel(4, L["Top Left Extra Panel"], "topLeftExtraPanel", "topLeftPanel"),
				spacer1 = Spacer(5),
				topRightPanel = StylePanel(6, L["Top Right Panel"], "topRightPanel"),
				topRightExtraPanel = StylePanel(7, L["Top Right Extra Panel"], "topRightExtraPanel", "topRightPanel"),
				spacer2 = Spacer(8),
				bottomLeftPanel = StylePanel(9, L["Bottom Left Panel"], "bottomLeftPanel"),
				bottomLeftExtraPanel = StylePanel(
					10,
					L["Bottom Left Extra Panel"],
					"bottomLeftExtraPanel",
					"bottomLeftPanel"
				),
				spacer3 = Spacer(11),
				bottomRightPanel = StylePanel(12, L["Bottom Right Panel"], "bottomRightPanel"),
				bottomRightExtraPanel = StylePanel(
					13,
					L["Bottom Right Extra Panel"],
					"bottomRightExtraPanel",
					"bottomRightPanel"
				),
			},
		},
	},
}
