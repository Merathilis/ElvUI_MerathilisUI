local MER, E, L, V, P, G = unpack(select(2, ...))

--Cache global variables
--Lua functions
local tinsert = table.insert
--WoW API / Variables
-- GLOBALS:

local function NotificationTable()
	local ACH = E.Libs.ACH

	E.Options.args.mui.args.modules.args.Notification = {
		type = "group",
		name = L["Notification"],
		get = function(info) return E.db.mui.notification[ info[#info] ] end,
		set = function(info, value) E.db.mui.notification[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			name = ACH:Header(MER:cOption(L["Notification"], 'orange'), 0),
			credits = {
				order = 1,
				type = "group",
				name = MER:cOption(L["Credits"], 'orange'),
				guiInline = true,
				args = {
					tukui = ACH:Description("RealUI - Nibelheim, Gethe", 1),
				},
			},
			desc = {
				order = 2,
				type = "description",
				fontSize = "small",
				name = L["Here you can enable/disable the different notification types."],
				disabled = function() return not E.db.mui.notification.enable end,
			},
			enable = {
				order = 3,
				type = "toggle",
				name = L["Enable"],
			},
			noSound = {
				order = 4,
				type = "toggle",
				name = L["No Sounds"],
				disabled = function() return not E.db.mui.notification.enable end,
			},
			mail = {
				order = 5,
				type = "toggle",
				name = L["Enable Mail"],
				disabled = function() return not E.db.mui.notification.enable end,
			},
			vignette = {
				order = 6,
				type = "toggle",
				name = L["Enable Vignette"],
				desc = L["If a Rare Mob or a treasure gets spotted on the minimap."],
				disabled = function() return not E.db.mui.notification.enable end,
			},
			invites = {
				order = 8,
				type = "toggle",
				name = L["Enable Invites"],
				disabled = function() return not E.db.mui.notification.enable end,
			},
			guildEvents = {
				order = 9,
				type = "toggle",
				name = L["Enable Guild Events"],
				disabled = function() return not E.db.mui.notification.enable end,
			},
			paragon = {
				order = 10,
				type = "toggle",
				name = L["MISC_PARAGON"],
				disabled = function() return not E.db.mui.notification.enable end,
			},
		},
	}
end

tinsert(MER.Config, NotificationTable)
