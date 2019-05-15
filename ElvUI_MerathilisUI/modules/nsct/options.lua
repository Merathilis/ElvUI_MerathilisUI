local MER, E, _, V, P, G = unpack(select(2, ...))
local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale or 'enUS')
local SCT = MER:GetModule("ScrollingCombatText")

--Cache global variables
local tonumber = tonumber
local format = string.format
local floor = math.floor
local tinsert = table.insert
--WoW API / Variables
local IsAddOnLoaded = IsAddOnLoaded
local GetCVar = GetCVar
local SetCVar = SetCVar
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function rgbToHex(r, g, b)
	return format("%02x%02x%02x", floor(255 * r), floor(255 * g), floor(255 * b));
end

local function hexToRGB(hex)
	return tonumber(hex:sub(1,2), 16)/255, tonumber(hex:sub(3,4), 16)/255, tonumber(hex:sub(5,6), 16)/255, 1;
end

local iconValues = {
	["none"] = L["No Icons"],
	["left"] = L["Left Side"],
	["right"] = L["Right Side"],
	["both"] = L["Both Sides"],
	["only"] = L["Icons Only (No Text)"],
};

local animationValues = {
	-- ["shake"] = "Shake",
	["verticalUp"] = L["Vertical Up"],
	["verticalDown"] = L["Vertical Down"],
	["fountain"] = L["Fountain"],
	["rainfall"] = L["Rainfall"],
};

local fontFlags = {
	[""] = "None",
	["OUTLINE"] = "Outline",
	["THICKOUTLINE"] = "Thick Outline",
	["nil, MONOCHROME"] = "Monochrome",
	["OUTLINE , MONOCHROME"] = "Monochrome Outline",
	["THICKOUTLINE , MONOCHROME"] = "Monochrome Thick Outline",
};

local function CombatTextTable()
	E.Options.args.mui.args.modules.args.nsct = {
		type = "group",
		order = 18,
		name = SCT.modName,
		childGroups = "tab",
		disabled = function() return IsAddOnLoaded("NameplateSCT") end,
		get = function(info) return E.db.mui.nsct[ info[#info] ] end,
		set = function(info, value) E.db.mui.nsct[ info[#info] ] = value; end,
		args = {
			enable = {
				order = 1,
				type = "toggle",
				width = "half",
				name = L["Enable"],
				get = function(info) return E.db.mui.nsct.enable end,
				set = function(info, value) E.db.mui.nsct.enable = value; E:StaticPopup_Show("PRIVATE_RL"); end,
			},
			disableBlizzardFCT = {
				order = 2,
				type = "toggle",
				name = L["Disable Blizzard FCT"],
				desc = "",
				get = function(info) return GetCVar("floatingCombatTextCombatDamage") == "0" end,
				set = function(info, value)
					if (value) then
						SetCVar("floatingCombatTextCombatDamage", "0");
					else
						SetCVar("floatingCombatTextCombatDamage", "1");
					end
				end,
			},
			personalNameplate = {
				order = 3,
				type = "toggle",
				name = L["Personal SCT"],
				desc = L["Also show numbers when you take damage on your personal nameplate or in the center of the screen."],
				get = function(info) return E.db.mui.nsct.personal end,
				set = function(info, value) E.db.mui.nsct.personal = value; end,
			},
			animations = {
				order = 30,
				type = "group",
				name = L["Animations"],
				disabled = function() return not E.db.mui.nsct.enable; end,
				get = function(info) return E.db.mui.nsct.animations[ info[#info] ] end,
				set = function(info, value) E.db.mui.nsct.animations[ info[#info] ] = value; end,
				args = {
					normal = {
						order = 1,
						type = "select",
						name = L["Default"],
						values = animationValues,
					},
					crit = {
						order = 2,
						type = "select",
						name = L["Criticals"],
						values = animationValues,
					},
					miss = {
						order = 3,
						type = "select",
						name = L["Miss/Parry/Dodge/etc."],
						values = animationValues,
					},
				},
			},
			animationsPersonal = {
				order = 40,
				type = "group",
				name = L["Personal SCT Animations"],
				disabled = function() return not E.db.mui.nsct.enable; end;
				get = function(info) return E.db.mui.nsct.animationsPersonal[ info[#info] ] end,
				set = function(info, value) E.db.mui.nsct.animationsPersonal[ info[#info] ] = value; end,
				args = {
					normal = {
						order = 1,
						type = "select",
						name = L["Default"],
						values = animationValues,
					},
					crit = {
						order = 2,
						type = "select",
						name = L["Criticals"],
						values = animationValues,
					},
					miss = {
						order = 3,
						type = "select",
						name = L["Miss/Parry/Dodge/etc."],
						values = animationValues,
					},
				},
			},
			appearance = {
				order = 50,
				type = "group",
				name = L["Appearance/Offsets"],
				disabled = function() return not E.db.mui.nsct.enable; end,
				get = function(info) return E.db.mui.nsct[ info[#info] ] end,
				set = function(info, value) E.db.mui.nsct[ info[#info] ] = value; end,
				args = {
					font = {
						order = 1,
						type = "select",
						dialogControl = "LSM30_Font",
						name = L["Font"],
						values = AceGUIWidgetLSMlists.font,
					},
					fontFlag = {
						order = 2,
						type = "select",
						name = L["Font Outline"],
						values = fontFlags,
					},
					fontShadow = {
						order = 3,
						type = "toggle",
						name = L["Font Shadow"],
					},
					damageColor = {
						order = 4,
						type = "toggle",
						name = L["Use Damage Type Color"],
					},
					defaultColor = {
						order = 5,
						type = "color",
						name = L["Default Color"],
						hasAlpha = false,
						get = function(info) return hexToRGB(E.db.mui.nsct.defaultColor); end,
						set = function(_, r, g, b) E.db.mui.nsct.defaultColor = rgbToHex(r, g, b); end,
					},
					space1 = {
						order = 6,
						type = "description",
						name = "",
					},
					xOffset = {
						order = 10,
						type = "range",
						width = 1.5,
						name = L["X-Offset"],
						desc = L["Has soft min/max, you can type whatever you'd like into the editbox tho."],
						softMin = -75, softMax = 75, step = 1,
					},
					yOffset = {
						order = 11,
						type = "range",
						width = 1.5,
						name = L["Y-Offset"],
						desc = L["Has soft min/max, you can type whatever you'd like into the editbox tho."],
						softMin = -75, softMax = 75, step = 1,
					},
					space2 = {
						order = 12,
						type = "description",
						name = "",
					},
					xOffsetPersonal = {
						order = 13,
						type = "range",
						width = 1.5,
						name = L["X-Offset Personal SCT"],
						desc = L["Only used if Personal Nameplate is Disabled."],
						softMin = -400, softMax = 400, step = 1,
						hidden = function() return not E.db.mui.nsct.personal; end,
					},
					yOffsetPersonal = {
						order = 14,
						type = "range",
						width = 1.5,
						name = L["Y-Offset Personal SCT"],
						desc = L["Only used if Personal Nameplate is Disabled."],
						softMin = -400, softMax = 400, step = 1,
						hidden = function() return not E.db.mui.nsct.personal; end,
					},
				},
			},
			formatting = {
				order = 90,
				type = "group",
				name = L["Text Formatting"],
				disabled = function() return not E.db.mui.nsct.enable; end,
				get = function(info) return E.db.mui.nsct.formatting[ info[#info] ] end,
				set = function(info, value) E.db.mui.nsct.formatting[ info[#info] ] = value; end,
				args = {
					truncate = {
						order = 1,
						type = "toggle",
						name = L["Truncate Number"],
						desc = L["Condense combat text numbers."],
						get = function(info) return E.db.mui.nsct.truncate; end,
						set = function(info, value) E.db.mui.nsct.truncate = value; end,
					},
					truncateLetter = {
						order = 2,
						type = "toggle",
						name = L["Show Truncated Letter"],
						desc = "",
						disabled = function() return not E.db.mui.nsct.enable or not E.db.mui.nsct.truncate; end,
						get = function(info) return E.db.mui.nsct.truncateLetter; end,
						set = function(info, value) E.db.mui.nsct.truncateLetter = value; end,
					},
					commaSeperate = {
						order = 3,
						type = "toggle",
						name = L["Comma Seperate"],
						desc = L["e.g. 100000 -> 100,000"],
						disabled = function() return not E.db.mui.nsct.enable or E.db.mui.nsct.truncate; end,
						get = function(info) return E.db.mui.nsct.commaSeperate; end,
						set = function(info, value) E.db.mui.nsct.commaSeperate = value; end,
					},
					icon = {
						order = 51,
						type = "select",
						name = L["Icon"],
						values = iconValues,
					},
					size = {
						order = 52,
						type = "range",
						name = L["Size"],
						min = 5, max = 72, step = 1,
					},
					alpha = {
						order = 53,
						type = "range",
						name = L["Start Alpha"],
						min = 0.1, max = 1, step = .01,
					},
					useOffTarget = {
						order = 100,
						type = "toggle",
						width = "full",
						name = L["Use Seperate Off-Target Text Appearance"],
						get = function(info) return E.db.mui.nsct.useOffTarget; end,
						set = function(info, value) E.db.mui.nsct.useOffTarget = value; end,
					},
					offTarget = {
						order = 101,
						type = "group",
						name = L["Off-Target Text Appearance"],
						guiInline = true,
						hidden = function() return not E.db.mui.nsct.useOffTarget; end,
						get = function(info) return E.db.mui.nsct.offTargetFormatting[ info[#info] ] end,
						set = function(info, value) E.db.mui.nsct.offTargetFormatting[ info[#info] ] = value; end,
						args = {
							icon = {
								order = 1,
								type = "select",
								name = L["Icon"],
								values = iconValues,
							},
							size = {
								order = 2,
								type = "range",
								name = L["Size"],
								min = 5, max = 72, step = 1,
							},
							alpha = {
								order = 3,
								type = "range",
								name = L["Start Alpha"],
								min = 0.1, max = 1, step = .01,
							},
						},
					},
				},
			},
			sizing = {
				order = 100,
				type = "group",
				name = L["Sizing Modifiers"],
				disabled = function() return not E.db.mui.nsct.enable; end,
				get = function(info) return E.db.mui.nsct.sizing[ info[#info] ] end,
				set = function(info, value) E.db.mui.nsct.sizing[ info[#info] ] = value; end,
				args = {
					crits = {
						order = 1,
						type = "toggle",
						name = L["Embiggen Crits"],
					},
					critsScale = {
						order = 2,
						type = "range",
						width = "double",
						name = L["Embiggen Crits Scale"],
						min = 1, max = 3, step = .01,
						disabled = function() return not E.db.mui.nsct.enable or not E.db.mui.nsct.sizing.crits; end,
					},
					miss = {
						order = 10,
						type = "toggle",
						name = L["Embiggen Miss/Parry/Dodge/etc."],
					},
					missScale = {
						order = 11,
						type = "range",
						width = "double",
						name = L["Embiggen Miss/Parry/Dodge/etc. Scale"],
						min = 1, max = 3, step = .01,
						disabled = function() return not E.db.mui.nsct.enable or not E.db.mui.nsct.sizing.miss; end,
					},
					smallHits = {
						order = 20,
						type = "toggle",
						name = L["Scale Down Small Hits"],
					},
					smallHitsScale = {
						order = 21,
						type = "range",
						width = "double",
						name = L["Small Hits Scale"],
						min = 0.33, max = 1, step = .01,
						disabled = function() return not E.db.mui.nsct.enable or not E.db.mui.nsct.sizing.smallHits; end,
					},
				},
			},
		},
	}
end
tinsert(MER.Config, CombatTextTable)
