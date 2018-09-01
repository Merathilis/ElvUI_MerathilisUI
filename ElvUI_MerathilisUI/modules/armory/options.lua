local MER, E, L, V, P, G = unpack(select(2, ...))
local CA = MER:GetModule("CharacterArmory")

--Cache global variables
local format = string.format
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: 

local function CharacterArmory()
	E.Options.args.mui.args.modules.args.armory = {
		type = "group",
		order = 21,
		name = CA.modName,
		disabled = function() return IsAddOnLoaded("ElvUI_SLE") end,
		hidden = function() return IsAddOnLoaded("ElvUI_SLE") end,
		get = function(info) return E.db.mui.armory[ info[#info] ] end,
		set = function(info, value) E.db.mui.armory[ info[#info] ] = value; CA:UpdateItemLevel(); end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = MER:cOption(CA.modName),
			},
			general = {
				order = 2,
				type = "group",
				guiInline = true,
				name = MER:cOption(L["General"]),
				args = {
					enable = {
						type = "toggle",
						order = 1,
						name = L["Enable"],
						desc = L["Enable/Disable the |cfff960d9KlixUI|r Armory Mode."],
						get = function(info) return E.db.mui.armory.enable end,
						set = function(info, value) E.db.mui.armory.enable = value; E:StaticPopup_Show("PRIVATE_RL"); end,
					},
					durability = {
						order = 3,
						type = "group",
						name = MER:cOption(L["Durability"]),
						guiInline = true,
						disabled = function() return not E.db.mui.armory.enable end,
						get = function(info) return E.db.mui.armory.durability[ info[#info] ] end,
						set = function(info, value) E.db.mui.armory.durability[ info[#info] ] = value; CA:UpdatePaperDoll() end,
						args = {
							enable = {
								type = "toggle",
								order = 1,
								name = L["Enable"],
								desc = L["Enable/Disable the display of durability information on the character window."],
							},
							onlydamaged = {
								type = "toggle",
								order = 2,
								name = L["Damaged Only"],
								desc = L["Only show durability information for items that are damaged."],
								disabled = function() return not E.db.mui.armory.enable or not E.db.mui.armory.durability.enable end,
							},
							font = {
								order = 3,
								type = "select", dialogControl = "LSM30_Font",
								name = L["Font"],
								values = AceGUIWidgetLSMlists.font,
								set = function(info, value) E.db.mui.armory.durability[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
							},
							textSize = {
								order = 4,
								name = FONT_SIZE,
								type = "range",
								min = 6, max = 22, step = 1,
								set = function(info, value) E.db.mui.armory.durability[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
							},
							fontOutline = {
								order = 5,
								type = "select",
								name = L["Font Outline"],
								values = {
									["NONE"] = NONE,
									["OUTLINE"] = "OUTLINE",
									["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE",
									["THICKOUTLINE"] = "THICKOUTLINE",
								},
								set = function(info, value) E.db.mui.armory.durability[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
							},
						},
					},
					itemlevel = {
						order = 4,
						type = "group",
						name = MER:cOption(L["Itemlevel"]),
						guiInline = true,
						disabled = function() return not E.db.mui.armory.enable end,
						get = function(info) return E.db.mui.armory.ilvl[ info[#info] ] end,
						set = function(info, value) E.db.mui.armory.ilvl[ info[#info] ] = value; CA:UpdatePaperDoll() end,
						args = {
							enable = {
								type = "toggle",
								order = 1,
								name = L["Enable"],
								desc = L["Enable/Disable the display of item levels on the character window."],
							},
							font = {
								order = 2,
								type = "select", dialogControl = "LSM30_Font",
								name = L["Font"],
								values = AceGUIWidgetLSMlists.font,
								set = function(info, value) E.db.mui.armory.ilvl[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
							},
							textSize = {
								order = 3,
								name = FONT_SIZE,
								type = "range",
								min = 6, max = 22, step = 1,
								set = function(info, value) E.db.mui.armory.ilvl[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
							},
							fontOutline = {
								order = 4,
								type = "select",
								name = L["Font Outline"],
								values = {
									["NONE"] = NONE,
									["OUTLINE"] = "OUTLINE",
									["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE",
									["THICKOUTLINE"] = "THICKOUTLINE",
								},
								set = function(info, value) E.db.mui.armory.ilvl[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL") end,
							},
							colorStyle = {
								order = 5,
								type = "select",
								name = COLOR,
								values = {
									["RARITY"] = RARITY,
									["CUSTOM"] = CUSTOM,
								},
								disabled = function() return not E.db.mui.armory.ilvl.enable end,
							},
							color = {
								order = 6,
								type = "color",
								name = COLOR_PICKER,
								disabled = function() return E.db.mui.armory.ilvl.colorStyle == 'RARITY' or not E.db.mui.armory.ilvl.enable end,
								get = function(info)
									local t = E.db.mui.armory.ilvl[ info[#info] ]
									local d = P.mui.armory.ilvl[info[#info]]
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b
								end,
								set = function(info, r, g, b)
									E.db.mui.armory.ilvl[ info[#info] ] = {}
									local t = E.db.mui.armory.ilvl[ info[#info] ]
									t.r, t.g, t.b, t.a = r, g, b, a
									E:StaticPopup_Show("PRIVATE_RL")
								end,
							},
						},
					},
				},
			},
		},
	}
end
tinsert(MER.Config, CharacterArmory)