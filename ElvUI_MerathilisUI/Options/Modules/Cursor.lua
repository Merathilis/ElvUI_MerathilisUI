local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Cursor = MER:GetModule("MER_Cursor")

local options = module.options.modules.args

local function RequestRefresh()
	Cursor:SettingsApply()
end

local function BuildColorArgs(order, sectionKey)
	return {
		useClassColor = {
			order = order,
			type = "toggle",
			name = L["Use Class Color"],
			get = function()
				return E.db.mui.cursor[sectionKey].useClassColor
			end,
			set = function(_, value)
				E.db.mui.cursor[sectionKey].useClassColor = value
				RequestRefresh()
			end,
		},
		color = {
			order = order + 1,
			type = "color",
			name = L["Custom Color"],
			hasAlpha = false,
			disabled = function()
				return E.db.mui.cursor[sectionKey].useClassColor
			end,
			get = function()
				local db = E.db.mui.cursor[sectionKey].color
				local default = P.cursor[sectionKey].color
				return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
			end,
			set = function(_, r, g, b)
				local db = E.db.mui.cursor[sectionKey].color
				db.r, db.g, db.b = r, g, b
				RequestRefresh()
			end,
		},
	}
end

options.cursor = {
	type = "group",
	name = module:AddCategorieIcon(E.NewSign .. L["Cursor"], "Tool"),
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.cOption(L["Cursor"], "orange"),
		},
		desc = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Description"],
			args = {
				feature = {
					order = 1,
					type = "description",
					name = L["Show a colored ring around your mouse cursor, with an optional trail, GCD ring and cast-time ring."],
					fontSize = "medium",
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			get = function()
				return E.db.mui.cursor.enable
			end,
			set = function(_, value)
				E.db.mui.cursor.enable = value
				E:StaticPopup_Show("PRIVATE_RL")
			end,
		},
		spacer = {
			order = 3,
			type = "description",
			name = "",
		},
		ring = {
			order = 4,
			type = "group",
			guiInline = true,
			name = L["Cursor Ring"],
			disabled = function()
				return not E.db.mui.cursor.enable
			end,
			args = F.Table.Join({
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					get = function()
						return E.db.mui.cursor.ring.enable
					end,
					set = function(_, value)
						E.db.mui.cursor.ring.enable = value
						RequestRefresh()
					end,
				},
				radius = {
					order = 2,
					type = "range",
					name = L["Radius"],
					min = 6,
					max = 40,
					step = 1,
					get = function()
						return E.db.mui.cursor.ring.radius
					end,
					set = function(_, value)
						E.db.mui.cursor.ring.radius = value
						RequestRefresh()
					end,
				},
				alpha = {
					order = 3,
					type = "range",
					name = L["Alpha"],
					min = 0.1,
					max = 1,
					step = 0.05,
					isPercent = true,
					get = function()
						return E.db.mui.cursor.ring.alpha
					end,
					set = function(_, value)
						E.db.mui.cursor.ring.alpha = value
						RequestRefresh()
					end,
				},
				reticle = {
					order = 4,
					type = "toggle",
					name = L["Show Center Dot"],
					get = function()
						return E.db.mui.cursor.ring.reticle
					end,
					set = function(_, value)
						E.db.mui.cursor.ring.reticle = value
						RequestRefresh()
					end,
				},
				spacer2 = {
					order = 5,
					type = "description",
					name = "",
				},
				instanceOnly = {
					order = 6,
					type = "toggle",
					name = L["Only In Instances"],
					get = function()
						return E.db.mui.cursor.ring.instanceOnly
					end,
					set = function(_, value)
						E.db.mui.cursor.ring.instanceOnly = value
						RequestRefresh()
					end,
				},
				combatOnly = {
					order = 7,
					type = "toggle",
					name = L["Only In Combat"],
					get = function()
						return E.db.mui.cursor.ring.combatOnly
					end,
					set = function(_, value)
						E.db.mui.cursor.ring.combatOnly = value
						RequestRefresh()
					end,
				},
				onlyWhenHidden = {
					order = 8,
					type = "toggle",
					name = L["Only While Steering Camera"],
					desc = L["Only show the ring while you're holding a mouse button to turn or move the camera (the hardware cursor is hidden)."],
					get = function()
						return E.db.mui.cursor.ring.onlyWhenHidden
					end,
					set = function(_, value)
						E.db.mui.cursor.ring.onlyWhenHidden = value
						RequestRefresh()
					end,
				},
			}, BuildColorArgs(9, "ring")),
		},
		trail = {
			order = 5,
			type = "group",
			guiInline = true,
			name = L["Cursor Trail"],
			disabled = function()
				return not E.db.mui.cursor.enable
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					get = function()
						return E.db.mui.cursor.trail.enable
					end,
					set = function(_, value)
						E.db.mui.cursor.trail.enable = value
						RequestRefresh()
					end,
				},
			},
		},
		gcd = {
			order = 6,
			type = "group",
			guiInline = true,
			name = L["GCD Ring"],
			disabled = function()
				return not E.db.mui.cursor.enable
			end,
			args = F.Table.Join({
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					get = function()
						return E.db.mui.cursor.gcd.enable
					end,
					set = function(_, value)
						E.db.mui.cursor.gcd.enable = value
						RequestRefresh()
					end,
				},
				attached = {
					order = 2,
					type = "toggle",
					name = L["Attach to Cursor"],
					get = function()
						return E.db.mui.cursor.gcd.attached
					end,
					set = function(_, value)
						E.db.mui.cursor.gcd.attached = value
						RequestRefresh()
					end,
				},
				radius = {
					order = 3,
					type = "range",
					name = L["Radius"],
					min = 10,
					max = 60,
					step = 1,
					get = function()
						return E.db.mui.cursor.gcd.radius
					end,
					set = function(_, value)
						E.db.mui.cursor.gcd.radius = value
						RequestRefresh()
					end,
				},
				alpha = {
					order = 4,
					type = "range",
					name = L["Alpha"],
					min = 0.1,
					max = 1,
					step = 0.05,
					isPercent = true,
					get = function()
						return E.db.mui.cursor.gcd.alpha
					end,
					set = function(_, value)
						E.db.mui.cursor.gcd.alpha = value
						RequestRefresh()
					end,
				},
			}, BuildColorArgs(5, "gcd")),
		},
		castCircle = {
			order = 7,
			type = "group",
			guiInline = true,
			name = L["Cast Ring"],
			disabled = function()
				return not E.db.mui.cursor.enable
			end,
			args = F.Table.Join({
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					get = function()
						return E.db.mui.cursor.castCircle.enable
					end,
					set = function(_, value)
						E.db.mui.cursor.castCircle.enable = value
						RequestRefresh()
					end,
				},
				attached = {
					order = 2,
					type = "toggle",
					name = L["Attach to Cursor"],
					get = function()
						return E.db.mui.cursor.castCircle.attached
					end,
					set = function(_, value)
						E.db.mui.cursor.castCircle.attached = value
						RequestRefresh()
					end,
				},
				radius = {
					order = 3,
					type = "range",
					name = L["Radius"],
					min = 10,
					max = 60,
					step = 1,
					get = function()
						return E.db.mui.cursor.castCircle.radius
					end,
					set = function(_, value)
						E.db.mui.cursor.castCircle.radius = value
						RequestRefresh()
					end,
				},
				alpha = {
					order = 4,
					type = "range",
					name = L["Alpha"],
					min = 0.1,
					max = 1,
					step = 0.05,
					isPercent = true,
					get = function()
						return E.db.mui.cursor.castCircle.alpha
					end,
					set = function(_, value)
						E.db.mui.cursor.castCircle.alpha = value
						RequestRefresh()
					end,
				},
				sparkEnable = {
					order = 5,
					type = "toggle",
					name = L["Show Spark"],
					get = function()
						return E.db.mui.cursor.castCircle.sparkEnable
					end,
					set = function(_, value)
						E.db.mui.cursor.castCircle.sparkEnable = value
						RequestRefresh()
					end,
				},
			}, BuildColorArgs(6, "castCircle")),
		},
	},
}
