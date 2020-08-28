local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule("muiChat")

--Cache global variables
--Lua functions
local tinsert = table.insert
--WoW API / Variable
-- GLOBALS:

local function ChatTable()
	local ACH = E.Libs.ACH

	E.Options.args.mui.args.modules.args.chat = {
		type = "group",
		name = L["Chat"],
		get = function(info) return E.db.mui.chat[ info[#info] ] end,
		set = function(info, value) E.db.mui.chat[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			header = ACH:Header(MER:cOption(L["Chat"]), 1),
			chatButton = {
				order = 2,
				type = "toggle",
				name = L["Chat Menu"],
				desc = L["Create a chat button to increase the chat size."],
			},
			hidePlayerBrackets = {
				order = 3,
				type = "toggle",
				name = L["Hide Player Brackets"],
				desc = L["Removes brackets around the person who posts a chat message."],
			},
			hideChat = {
				order = 4,
				type = "toggle",
				name = L["Hide Community Chat"],
				desc = L["Adds an overlay to the Community Chat. Useful for streamers."],
			},
			chatBar = {
				order = 5,
				type = "toggle",
				name = L["ChatBar"],
				desc = L["Shows a ChatBar with different quick buttons."],
			},
			emotes = {
				order = 6,
				type = "toggle",
				name = L["Emotes"],
			},
			itemLevelLink = {
				order = 7,
				type = "toggle",
				name = L["Item Level Links"],
			},
			seperators = {
				order = 8,
				type = "group",
				name = MER:cOption(L["Seperators"]),
				guiInline = true,
				get = function(info) return E.db.mui.chat.seperators[ info[#info] ] end,
				set = function(info, value) E.db.mui.chat.seperators[ info[#info] ] = value; end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"]
					},
					visibility = {
						order = 2,
						type = 'select',
						name = L["Visibility"],
						get = function(info) return E.db.mui.chat.seperators[ info[#info] ] end,
						set = function(info, value) E.db.mui.chat.seperators[ info[#info] ] = value; module:UpdateSeperators() end,
						values = {
							HIDEBOTH = L["Hide Both"],
							SHOWBOTH = L["Show Both"],
							LEFT = L["Left Only"],
							RIGHT = L["Right Only"],
						},
					}
				},
			},
			chatFade = {
				order = 9,
				type = "group",
				name = MER:cOption(L["Fade Chat"]),
				guiInline = true,
				get = function(info) return E.db.mui.chat.chatFade[ info[#info] ] end,
				set = function(info, value) E.db.mui.chat.chatFade[ info[#info] ] = value; module:Configure_ChatFade() end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
					},
					timeout = {
						order = 2,
						type = "range",
						min = 5, max = 60, step = 1,
						name = L["Auto hide timeout"],
						desc = L["Seconds before fading chat panel"],
						disabled = function() return not E.db.mui.chat.chatFade.enable end
					},
					minAlpha = {
						order = 3,
						type = "range",
						min = 0, max = 1, step = 0.01,
						name = L["Min Alpha"],
						disabled = function() return not E.db.mui.chat.chatFade.enable end
					},
					fadeOutTime = {
						order = 4,
						type = "range",
						min = 0.1, max = 2, step = 0.01,
						name = L["Fadeout duration"],
						disabled = function() return not E.db.mui.chat.chatFade.enable end,
					},
				},
			},
			filter = {
				order = 20,
				type = "group",
				name = MER:cOption(L["Filter"]),
				guiInline = true,
				get = function(info) return E.db.mui.chat.filter[ info[#info] ] end,
				set = function(info, value) E.db.mui.chat.filter[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
					},
					damagemeter = {
						order = 2,
						type = "toggle",
						name = L["Damage Meter Filter"],
						disabled = function() return not E.db.mui.chat.filter.enable end,
					}
				},
			},
		},
	}
end

tinsert(MER.Config, ChatTable)
