local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local MERLT = E:GetModule('MuiLoot');

local _G = _G
local tinsert = table.insert
local CHAT_MSG_BN_WHISPER, CHAT_MSG_BN_WHISPER_INFORM = CHAT_MSG_BN_WHISPER, CHAT_MSG_BN_WHISPER_INFORM

local function muiLoot()
	local function CreateChannel(Name, Order)
		local config = {
			order = Order,
			type = "toggle",
			name = _G[Name] or _G[gsub(Name, "CHAT_MSG_", "")],
			disabled = function() return not E.db.muiLoot.lootIcon.enable end,
			get = function(info) return E.db.muiLoot.lootIcon.channels[Name] end,
			set = function(info, value) E.db.muiLoot.lootIcon.channels[Name] = value end,
		}
		return config
	end
	
	E.Options.args.mui.args.config.args.loot = {
		order = 12,
		type = 'group',
		name = L["Loot"],
		args = {
			lootIcon = {
				order = 1,
				type = 'group',
				name = L["Loot Icon"],
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Showes icons of items looted/created near respective messages in chat. Does not affect usual messages."],
						get = function(info) return E.db.muiLoot.lootIcon[ info[#info] ] end,
						set = function(info, value) E.db.muiLoot.lootIcon[ info[#info] ] = value; MERLT:LootIconToggle() end,
					},
					position = {
						order = 2,
						type = "select",
						name = L["Position"],
						disabled = function() return not E.db.muiLoot.lootIcon.enable end,
						get = function(info) return E.db.muiLoot.lootIcon[ info[#info] ] end,
						set = function(info, value) E.db.muiLoot.lootIcon[ info[#info] ] = value; end,
						values = {
							LEFT = L["Left"],
							RIGHT = L["Right"],
						},
					},
					size = {
						order = 3,
						type = "range",
						name = L["Size"],
						disabled = function() return not E.db.muiLoot.lootIcon.enable end,
						min = 8, max = 32, step = 1,
						get = function(info) return E.db.muiLoot.lootIcon[ info[#info] ] end,
						set = function(info, value) E.db.muiLoot.lootIcon[ info[#info] ] = value; end,
					},
					channels = {
						type = "group",
						name = L["Channels"],
						order = 4,
						guiInline = true,
						args = {
							CHANNEL = CreateChannel("CHAT_MSG_CHANNEL", 4),
							EMOTE = CreateChannel("CHAT_MSG_EMOTE", 5),
							GUILD = CreateChannel("CHAT_MSG_GUILD", 6),
							INSTANCE_CHAT = CreateChannel("CHAT_MSG_INSTANCE_CHAT", 7),
							INSTANCE_CHAT_LEADER = CreateChannel("CHAT_MSG_INSTANCE_CHAT_LEADER", 8),
							LOOT = CreateChannel("CHAT_MSG_LOOT", 9),
							OFFICER = CreateChannel("CHAT_MSG_OFFICER", 10),
							PARTY = CreateChannel("CHAT_MSG_PARTY", 11),
							PARTY_LEADER = CreateChannel("CHAT_MSG_PARTY_LEADER", 12),
							RAID = CreateChannel("CHAT_MSG_RAID", 13),
							RAID_LEADER = CreateChannel("CHAT_MSG_RAID_LEADER", 14),
							RAID_WARNING = CreateChannel("CHAT_MSG_RAID_WARNING", 15),
							SAY = CreateChannel("CHAT_MSG_SAY", 16),
							SYSTEM = CreateChannel("CHAT_MSG_SYSTEM", 17),
							YELL = CreateChannel("CHAT_MSG_YELL", 20),
						},
					},
					privateChannels = {
						type = "group",
						name = L["Private channels"],
						order = 5,
						guiInline = true,
						args = {
							CHAT_MSG_BN_CONVERSATION = CreateChannel("CHAT_MSG_BN_CONVERSATION", 1),
							BN_WHISPER = {
								type = "group",
								name = CHAT_MSG_BN_WHISPER,
								order = 2,
								guiInline = true,
								args = {
									inc = {
										order = 1,
										type = "toggle",
										name = L["Incoming"],
										disabled = function() return not E.db.muiLoot.lootIcon.enable end,
										get = function(info) return E.db.muiLoot.lootIcon.channels.CHAT_MSG_BN_WHISPER end,
										set = function(info, value) E.db.muiLoot.lootIcon.channels.CHAT_MSG_BN_WHISPER = value end,
									},
									out = {
										order = 2,
										type = "toggle",
										name = L["Outgoing"],
										disabled = function() return not E.db.muiLoot.lootIcon.enable end,
										get = function(info) return E.db.muiLoot.lootIcon.channels.CHAT_MSG_BN_WHISPER_INFORM end,
										set = function(info, value) E.db.muiLoot.lootIcon.channels.CHAT_MSG_BN_WHISPER_INFORM = value end,
									},
								},
							},
							WHISPER = {
								type = "group",
								name = CHAT_MSG_WHISPER_INFORM,
								order = 3,
								guiInline = true,
								args = {
									inc = {
										order = 1,
										type = "toggle",
										name = L["Incoming"],
										disabled = function() return not E.db.muiLoot.lootIcon.enable end,
										get = function(info) return E.db.muiLoot.lootIcon.channels.CHAT_MSG_WHISPER end,
										set = function(info, value) E.db.muiLoot.lootIcon.channels.CHAT_MSG_WHISPER = value end,
									},
									out = {
										order = 2,
										type = "toggle",
										name = L["Outgoing"],
										disabled = function() return not E.db.muiLoot.lootIcon.enable end,
										get = function(info) return E.db.muiLoot.lootIcon.channels.CHAT_MSG_WHISPER_INFORM end,
										set = function(info, value) E.db.muiLoot.lootIcon.channels.CHAT_MSG_WHISPER_INFORM = value end,
									},
								},
							},
						},
					},
				},
			},
		},
	}
end
tinsert(E.MerConfig, muiLoot)
