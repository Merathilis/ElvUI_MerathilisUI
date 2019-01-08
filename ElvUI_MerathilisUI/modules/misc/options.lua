local MER, E, L, V, P, G = unpack(select(2, ...))
local MI = MER:GetModule("mUIMisc")
local MERA = MER:GetModule("mUIAnnounce")

--Cache global variables

--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: GUILD_MOTD_LABEL2

local function Misc()
	E.Options.args.mui.args.misc = {
		order = 9,
		type = "group",
		name = "",
		guiInline = true,
		get = function(info) return E.db.mui.misc[ info[#info] ] end,
		set = function(info, value) E.db.mui.misc[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = MER:cOption(MI.modName),
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
				name = GUILD_MOTD_LABEL2,
				desc = L["Display the Guild Message of the Day in an extra window, if updated."],
			},
			Movertransparancy = {
				order = 4,
				type = "range",
				name = L["Mover Transparency"],
				desc = L["Changes the transparency of all the movers."],
				isPercent = true,
				min = 0, max = 1, step = 0.01,
				get = function(info) return E.db.mui.general.Movertransparancy end,
				set = function(info, value) E.db.mui.general.Movertransparancy = value MI:UpdateMoverTransparancy() end,
			},
			quest = {
				order = 5,
				type = "toggle",
				name = L["Quest"],
				desc = L["Automatically select the quest reward with the highest vendor sell value. Also announce Quest Progress."],
			},
			announce = {
				order = 6,
				type = "toggle",
				name = MERA.modName,
				desc = L["Skill gains"],
			},
			cursor = {
				order = 7,
				type = "toggle",
				name = L["Flashing Cursor"],
			},
			nameHover = {
				order = 8,
				type = "group",
				name = L["Name Hover"],
				desc = L["Shows the Unit Name on the mouse."],
				get = function(info) return E.db.mui.nameHover[ info[#info] ] end,
				set = function(info, value) E.db.mui.nameHover[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
					},
					fontSize = {
						order = 2,
						type = "range",
						name = L["Size"],
						min = 4, max = 24, step = 1,
					},
					fontOutline = {
						order = 3,
						type = "select",
						name = L["Font Outline"],
						values = {
							["NONE"] = NONE,
							["OUTLINE"] = "OUTLINE",
							["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE",
							["THICKOUTLINE"] = "THICKOUTLINE",
						},
					},
				},
			},
		},
	}
end
tinsert(MER.Config, Misc)
