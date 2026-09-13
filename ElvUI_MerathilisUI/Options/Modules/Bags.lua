local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local EM = MER:GetModule("MER_EquipManager") ---@class EquipmentManager
local BC = MER:GetModule("MER_BagCategories") ---@class BagCategories
local B = E:GetModule("Bags")

local options = module.options.modules.args

options.bags = {
	type = "group",
	name = module:AddCategorieIcon(L["Bags"], "bags"),
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
		categorizedBags = {
			order = 2,
			type = "group",
			name = L["Categorized Bags"],
			guiInline = true,
			get = function(info)
				return E.db.mui.bags.categorizedBags[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.bags.categorizedBags[info[#info]] = value

				if BC.frame then
					BC.frame:Size(E.db.mui.bags.categorizedBags.width, E.db.mui.bags.categorizedBags.height)
					BC:RefreshCategoryFrame()
				end
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Replaces ElvUI's bag frame with a category-sidebar view (Pinned/Recent items, custom categories). Requires a UI reload to take effect."],
					set = function(info, value)
						E.db.mui.bags.categorizedBags[info[#info]] = value
						E:StaticPopup_Show("PRIVATE_RL")
					end,
				},
				hideEmptyCategories = {
					order = 2,
					type = "toggle",
					name = L["Hide Empty Categories"],
				},
				showPinned = {
					order = 3,
					type = "toggle",
					name = L["Show Pinned Items"],
				},
				showRecent = {
					order = 4,
					type = "toggle",
					name = L["Show Recent Items"],
				},
				itemSize = {
					order = 5,
					type = "range",
					name = L["Item Size"],
					min = 24,
					max = 48,
					step = 1,
				},
				itemSpacing = {
					order = 6,
					type = "range",
					name = L["Item Spacing"],
					min = 0,
					max = 10,
					step = 1,
				},
				sidebarWidth = {
					order = 7,
					type = "range",
					name = L["Sidebar Width"],
					min = 100,
					max = 220,
					step = 1,
				},
				width = {
					order = 8,
					type = "range",
					name = L["Width"],
					min = 380,
					max = 900,
					step = 1,
				},
				height = {
					order = 9,
					type = "range",
					name = L["Height"],
					min = 300,
					max = 800,
					step = 1,
				},
			},
		},
	},
}
