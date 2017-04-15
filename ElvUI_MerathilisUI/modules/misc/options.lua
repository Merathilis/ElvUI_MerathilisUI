local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule("MerathilisUI");
local MI = E:GetModule("mUIMisc")

local function Misc()
	E.Options.args.mui.args.misc = {
		order = 9,
		type = "group",
		name = MER:cOption(L["Misc"]),
		guiInline = true,
		get = function(info) return E.db.mui.misc[ info[#info] ] end,
		set = function(info, value) E.db.mui.misc[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			MailInputbox = {
				order = 1,
				type = "toggle",
				name = L["Mail Inputbox Resize"],
				desc = L["Resize the Mail Inputbox and move the shipping cost to the Bottom"],
			},
			moveBlizz = {
				order = 2,
				type = "toggle",
				name = L["moveBlizz"],
				desc = L["Make some Blizzard Frames movable."],
			},
			tradeTabs = {
				order = 3,
				type = "toggle",
				name = L["TradeSkill Tabs"],
				desc = L["Add tabs for professions on the TradeSkill Frame."],
			},
			gmotd = {
				order = 4,
				type = "toggle",
				name = GUILD_MOTD_LABEL2,
				desc = L["Display the Guild Message of the Day in an extra window, if updated."],
			},
			vignette = {
				order = 5,
				type = "toggle",
				name = L["Vignette"],
				desc = L["Display a RaidWarning if a Rar/Treasures are spotted on the minimap."],
			},
			Movertransparancy = {
				order = 6,
				type = "range",
				name = L["Mover Transparency"],
				desc = L["Changes the transparency of all the movers."],
				isPercent = true,
				min = 0, max = 1, step = 0.01,
				get = function(info) return E.db.mui.general.Movertransparancy end,
				set = function(info, value) E.db.mui.general.Movertransparancy = value MI:UpdateMoverTransparancy() end,
			},
			selectquestreward = {
				order = 7,
				type = "toggle",
				name = L["Select Quest Reward"],
				desc = L["Automatically select the quest reward with the highest vendor sell value."],
				get = function(info) return E.private.muiMisc.selectquestreward end,
				set = function(info, value) E.private.muiMisc.selectquestreward = value; end,
			},
		},
	}
end
tinsert(MER.Config, Misc)