local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

local function Misc()
	E.Options.args.mui.args.misc = {
		order = 9,
		type = 'group',
		name = L['Misc'],
		guiInline = true,
		get = function(info) return E.db.mui.misc[ info[#info] ] end,
		set = function(info, value) E.db.mui.misc[ info[#info] ] = value; E:StaticPopup_Show('PRIVATE_RL'); end,
		args = {
			TooltipIcon = {
				order = 1,
				type = 'toggle',
				name = L['Tooltip Icon'],
				desc = L['Adds an Icon for Items/Spells/Achievement on the Tooltip'],
			},
			HideAlertFrame = {
				order = 2,
				type = 'toggle',
				name = L['Garrison Alert Frame'],
				desc = L['Hides the Garrison Alert Frame while in combat.'],
			},
			MailInputbox = {
				order = 3,
				type = 'toggle',
				name = L['Mail Inputbox Resize'],
				desc = L['Resize the Mail Inputbox and move the shipping cost to the Bottom'],
			},
			FriendAlert = {
				order = 4,
				type = 'toggle',
				name = L['Battle.net Alert'],
				desc = L['Shows a Chat notification if a Battle.net Friend switch Games or goes offline.'],
			},
			moveBlizz = {
				order = 5,
				type = 'toggle',
				name = L['moveBlizz'],
				desc = L['Make some Blizzard Frames movable.'],
			},
			minimapblip = {
				order = 6,
				type = 'toggle',
				name = L['Minimap Blip'],
				desc = L['Replaces the default minimap blips with custom textures.'],
			},
			hoverName = {
				order = 7,
				type = 'toggle',
				name = L['hoverName'],
				desc = L['Shows UnitNames on mouseover.'],
			},
		},
	}
end
tinsert(MER.Config, Misc)