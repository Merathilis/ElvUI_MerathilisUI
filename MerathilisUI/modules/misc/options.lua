local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

local function muiMisc()
	E.Options.args.mui.args.misc = {
		order = 9,
		type = 'group',
		name = L['Misc'],
		guiInline = true,
		args = {
			TooltipIcon = {
				order = 1,
				type = 'toggle',
				name = L['Tooltip Icon'],
				desc = L['Adds an Icon for Items/Spells/Achievement on the Tooltip'],
				get = function(info) return E.db.muiMisc[ info[#info] ] end,
				set = function(info, value) E.db.muiMisc[ info[#info] ] = value; end,
			},
			HideAlertFrame = {
				order = 2,
				type = 'toggle',
				name = L['Garrison Alert Frame'],
				desc = L['Hides the Garrison Alert Frame while in combat.'],
				get = function(info) return E.db.muiMisc[ info[#info] ] end,
				set = function(info, value) E.db.muiMisc[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
			},
			MailInputbox = {
				order = 3,
				type = 'toggle',
				name = L['Mail Inputbox Resize'],
				desc = L['Resize the Mail Inputbox and move the shipping cost to the Bottom'],
				get = function(info) return E.db.muiMisc[ info[#info] ] end,
				set = function(info, value) E.db.muiMisc[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
			},
			FriendAlert = {
				order = 4,
				type = 'toggle',
				name = L['Battle.net Alert'],
				desc = L['Shows a Chat notification if a Battle.net Friend switch Games or goes offline.'],
				get = function(info) return E.db.muiMisc[ info[#info] ] end,
				set = function(info, value) E.db.muiMisc[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
			},
			moveBlizz = {
				order = 5,
				type = 'toggle',
				name = L['moveBlizz'],
				desc = L['Make some Blizzard Frames movable.'],
				get = function(info) return E.db.muiMisc[ info[#info] ] end,
				set = function(info, value) E.db.muiMisc[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
			},
			enchantScroll = {
				order = 6,
				type = 'toggle',
				name = L['Enchant on Scroll'],
				desc = L['Place a button in the Enchant Trade Window, allow you to automatically place a enchant on a scroll.'],
				get = function(info) return E.db.muiMisc[ info[#info] ] end,
				set = function(info, value) E.db.muiMisc[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
			},
		},
	}
end
tinsert(E.MerConfig, muiMisc)