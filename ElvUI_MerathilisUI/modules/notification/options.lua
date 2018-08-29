local MER, E, L, V, P, G = unpack(select(2, ...))
local NF = MER:GetModule("Notification")

local function Noticications()
	E.Options.args.mui.args.Notification = {
		type = "group",
		name = NF.modName,
		order = 9,
		get = function(info) return E.db.mui.general.Notification[ info[#info] ] end,
		set = function(info, value) E.db.mui.general.Notification[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			header1 = {
				type = "header",
				name = MER:cOption(NF.modName),
				order = 1
			},
			enable = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
			},
			desc = {
				order = 3,
				type = "description",
				fontSize = "small",
				name = L["Here you can enable/disable the different notification types."],
				disabled = function() return not E.db.mui.general.Notification.enable end,
				hidden = function() return not E.db.mui.general.Notification.enable end,
			},
			mail = {
				order = 4,
				type = "toggle",
				name = L["Enable Mail"],
				disabled = function() return not E.db.mui.general.Notification.enable end,
				hidden = function() return not E.db.mui.general.Notification.enable end,
			},
			vignette = {
				order = 5,
				type = "toggle",
				name = L["Enable Vignette"],
				desc = L["If a Rar Mob or a treasure gets spotted on the minimap."],
				disabled = function() return not E.db.mui.general.Notification.enable end,
				hidden = function() return not E.db.mui.general.Notification.enable end,
			},
			invites = {
				order = 6,
				type = "toggle",
				name = L["Enable Invites"],
				disabled = function() return not E.db.mui.general.Notification.enable end,
				hidden = function() return not E.db.mui.general.Notification.enable end,
			},
			guildEvents = {
				order = 7,
				type = "toggle",
				name = L["Enable Guild Events"],
				disabled = function() return not E.db.mui.general.Notification.enable end,
				hidden = function() return not E.db.mui.general.Notification.enable end,
			},
		},
	}
end

tinsert(MER.Config, Noticications)