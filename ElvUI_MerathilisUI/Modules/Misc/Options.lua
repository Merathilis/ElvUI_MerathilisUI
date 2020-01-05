local MER, E, L, V, P, G = unpack(select(2, ...))
local MI = MER:GetModule("mUIMisc")

--Cache global variables
--Lua functions
local _G = _G
local tinsert = table.insert
--WoW API / Variables
local GUILD_MOTD_LABEL2 = GUILD_MOTD_LABEL2
-- GLOBALS:

local function Misc()
	E.Options.args.mui.args.modules.args.misc = {
		type = "group",
		name = E.NewSign..L["Miscellaneous"],
		get = function(info) return E.db.mui.misc[ info[#info] ] end,
		set = function(info, value) E.db.mui.misc[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = MER:cOption(L["Miscellaneous"]),
			},
			MailInputbox = {
				order = 2,
				type = "toggle",
				name = L["Mail Inputbox Resize"],
				desc = L["Resize the Mail Inputbox and move the shipping cost to the Bottom"],
			},
			gmotd = {
				order = 3,
				type = "toggle",
				name = L.GUILD_MOTD_LABEL2,
				desc = L["Display the Guild Message of the Day in an extra window, if updated."],
			},
			quest = {
				order = 4,
				type = "toggle",
				name = L["Quest"],
				desc = L["Automatically select the quest reward with the highest vendor sell value. Also announce Quest Progress."],
			},
			announce = {
				order = 5,
				type = "toggle",
				name = L["Announce"],
				desc = L["Skill gains"],
			},
			cursor = {
				order = 6,
				type = "toggle",
				name = L["Flashing Cursor"],
			},
			skipAzerite = {
				order = 7,
				type = "toggle",
				name = L["Skip Azerite Animation"],
			},
			funstuff = {
				order = 8,
				type = "toggle",
				name = L["Fun Stuff"],
			},
			wowheadlinks = {
				order = 9,
				type = "toggle",
				name = L["Wowhead Links"],
				desc = L["Adds Wowhead links to the Achievement- and WorldMap Frame"],
			},
			respec = {
				order = 10,
				type = "toggle",
				name = E.NewSign..L["Codex Buttons"],
				desc = L["Adds two buttons on your Talent Frame, with Codex or Tome Items"],
			},
			alerts = {
				order = 20,
				type = "group",
				name = L["Alerts"],
				guiInline = true,
				get = function(info) return E.db.mui.misc.alerts[ info[#info] ] end,
				set = function(info, value) E.db.mui.misc.alerts[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {
					lfg = {
						order = 1,
						type = "toggle",
						name = L["Call to Arms"],
					},
				},
			},
			paragon = {
				order = 21,
				type = "group",
				name = L["MISC_PARAGON_REPUTATION"],
				guiInline = true,
				get = function(info) return E.db.mui.misc.paragon[ info[#info] ] end,
				set = function(info, value) E.db.mui.misc.paragon[ info[#info] ] = value; end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
					},
					textStyle = {
						order = 2,
						type = "select",
						name = L["Text Style"],
						disabled = function() return not E.db.mui.misc.paragon.enable end,
						values = {
							["PARAGON"] = L["MISC_PARAGON"],
							["CURRENT"] = L["Current"],
							["VALUE"] = L["Value"],
							["DEFICIT"] = L["Deficit"],
						},
					},
					paragonColor = {
						order = 3,
						name = L["COLOR"],
						type = "color",
						disabled = function() return not E.db.mui.misc.paragon.enable end,
						hasAlpha = false,
						get = function(info)
							local t = E.db.mui.misc.paragon[ info[#info] ]
							local d = P.mui.misc.paragon[info[#info]]
							return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
						end,
						set = function(info, r, g, b, a)
							local t = E.db.mui.misc.paragon[ info[#info] ]
							t.r, t.g, t.b, t.a = r, g, b, a
						end,
					},
				},
			},
			macros = {
				order = 30,
				type = "group",
				name = E.NewSign..L["Macros"],
				guiInline = true,
				args = {
					randomtoy = {
						order = 1,
						type = "input",
						name = L["Random Toy"],
						desc = L["Creates a random toy macro."],
						get = function() return "/randomtoy" end,
						set = function() return end,
					},
				},
			},
		},
	}
end
tinsert(MER.Config, Misc)
