local MER, E, L, V, P, G = unpack(select(2, ...))

--Cache global variables
--Lua functions
local tinsert = table.insert
--WoW API / Variables
-- GLOBALS:

local function NotificationTable()
	E.Options.args.mui.args.modules.args.Notification = {
		type = "group",
		name = L["Notification"],
		get = function(info) return E.db.mui.notification[ info[#info] ] end,
		set = function(info, value) E.db.mui.notification[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			credits = {
				order = 0,
				type = "group",
				name = MER:cOption(L["Credits"]),
				guiInline = true,
				args = {
					tukui = {
						order = 1,
						type = "description",
						fontSize = "medium",
						name = "RealUI - Nibelheim, Gethe",
					},
				},
			},
			enable = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
			},
			noSound = {
				order = 2,
				type = "toggle",
				name = L["No Sounds"],
				disabled = function() return not E.db.mui.notification.enable end,
			},
			header1 = {
				order = 5,
				name = MER:cOption(L["Notification"]),
				type = "header",
			},
			desc = {
				order = 6,
				type = "description",
				fontSize = "small",
				name = L["Here you can enable/disable the different notification types."],
				disabled = function() return not E.db.mui.notification.enable end,
			},
			mail = {
				order = 7,
				type = "toggle",
				name = L["Enable Mail"],
				disabled = function() return not E.db.mui.notification.enable end,
			},
			vignette = {
				order = 8,
				type = "toggle",
				name = L["Enable Vignette"],
				desc = L["If a Rare Mob or a treasure gets spotted on the minimap."],
				disabled = function() return not E.db.mui.notification.enable end,
			},
			invites = {
				order = 9,
				type = "toggle",
				name = L["Enable Invites"],
				disabled = function() return not E.db.mui.notification.enable end,
			},
			guildEvents = {
				order = 10,
				type = "toggle",
				name = L["Enable Guild Events"],
				disabled = function() return not E.db.mui.notification.enable end,
			},
			paragon = {
				order = 11,
				type = "toggle",
				name = L["MISC_PARAGON"],
				disabled = function() return not E.db.mui.notification.enable end,
			},
		},
	}
end

tinsert(MER.Config, NotificationTable)
