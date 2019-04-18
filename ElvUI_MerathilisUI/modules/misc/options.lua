local MER, E, L, V, P, G = unpack(select(2, ...))
local MI = MER:GetModule("mUIMisc")
local MERA = MER:GetModule("mUIAnnounce")

--Cache global variables
--Lua functions
local tinsert = table.insert
--WoW API / Variables
local GUILD_MOTD_LABEL2 = GUILD_MOTD_LABEL2
-- GLOBALS:

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
			raidInfo = {
				order = 8,
				type = "toggle",
				name = L["Raid Info"],
				desc = L["Shows a simple frame with Raid Informations."],
			},
			talentManager = {
				order = 9,
				type = "toggle",
				name = E.NewSign..L["Talent Manager"],
				desc = L["Allow you to create multiple Talent presets"],
			},
		},
	}
end
tinsert(MER.Config, Misc)
