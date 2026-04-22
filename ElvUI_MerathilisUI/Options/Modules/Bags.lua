local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local EM = MER:GetModule("MER_EquipManager") ---@class EquipmentManager
local B = E:GetModule("Bags")

local options = module.options.modules.args

options.bags = {
	type = "group",
	name = L["Bags"],
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.cOption(L["Bags"], "orange"),
		},
		equipmentManager = {
			order = 1,
			type = "group",
			name = L["Equipment Manager"],
			guiInline = true,
			get = function(info)
				return E.db.mui.bags.equipmentManager[info[#info]]
			end,
			-- set = function(info, value) E.db.mui.bags.equipmentManager[info[#info]] = value; EM:UpdateBagSettings() end,
			set = function(info, value)
				E.db.mui.bags.equipmentManager[info[#info]] = value
				-- B:UpdateLayouts()
				-- B:UpdateAllBagSlots()
				EM:UpdateItemDisplay()
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Enables an indicator on equipment icons located in your bags to show if they are part of an equipment set."],
					set = function(info, value)
						E.db.mui.bags.equipmentManager[info[#info]] = value
						-- EM:ToggleSettings()
						B:UpdateLayouts()
						B:UpdateAllBagSlots(true)
					end,
				},
				size = {
					order = 2,
					type = "range",
					name = L["Size"],
					min = 8,
					max = 64,
					step = 1,
				},
				point = {
					order = 3,
					type = "select",
					name = L["Anchor Point"],
					values = I.Values.positionValues,
				},
				xOffset = {
					order = 4,
					type = "range",
					name = L["X-Offset"],
					min = -64,
					max = 64,
					step = 1,
				},
				yOffset = {
					order = 5,
					type = "range",
					name = L["Y-Offset"],
					min = -64,
					max = 64,
					step = 1,
				},
				icon = {
					order = 6,
					type = "select",
					name = L["Icon"],
					values = function()
						return EM.equipmentmanager.icons
					end,
				},
				customTexture = {
					order = 7,
					type = "input",
					name = L["Custom Texture"],
					desc = L["You can use a file id or path.\nFile id as an example.\niconFileID: 3547163\n\nAlready an option but showing as a path example.\nPath: Interface\\AddOns\\ElvUI_SLE\\media\\textures\\lock"],
					width = "double",
					hidden = function()
						return E.db.mui.bags.equipmentManager.icon ~= "CUSTOM"
					end,
				},
				color = {
					order = 8,
					type = "color",
					name = COLOR,
					hasAlpha = true,
					get = function(info)
						local t = E.db.mui.bags.equipmentManager[info[#info]]
						local d = P.bags.equipmentManager[info[#info]]
						return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db.mui.bags.equipmentManager[info[#info]]
						t.r, t.g, t.b, t.a = r, g, b, a
						-- B:UpdateLayouts()
						-- B:UpdateAllBagSlots()
						EM:UpdateItemDisplay()
					end,
				},
			},
		},
	},
}
