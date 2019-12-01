local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule("muiChat")

--Cache global variables
--Lua functions
local tinsert = table.insert
--WoW API / Variable
-- GLOBALS:

local function ChatTable()
	E.Options.args.mui.args.modules.args.chat = {
		type = "group",
		name = E.NewSign..L["Chat"],
		get = function(info) return E.db.mui.chat[ info[#info] ] end,
		set = function(info, value) E.db.mui.chat[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			header1 = {
				type = "header",
				name = MER:cOption(L["Chat"]),
				order = 1
			},
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
			chatFade = {
				order = 10,
				type = "group",
				name = E.NewSign..L["Fade Chat"],
				guiInline = true,
				get = function(info) return E.db.mui.chat.chatFade[ info[#info] ] end,
				set = function(info, value) E.db.mui.chat.chatFade[ info[#info] ] = value; module:Configure_ChatFade(); end,
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
				},
			},
			filter = {
				order = 20,
				type = "group",
				name = L["Filter"],
				guiInline = true,
				get = function(info) return E.db.mui.chat.filter[ info[#info] ] end,
				set = function(info, value) E.db.mui.chat.filter[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
					},
					itemLevel = {
						order = 2,
						type = "toggle",
						name = L["Item Level"],
						disabled = function() return not E.db.mui.chat.filter.enable end,
					},
					damagemeter = {
						order = 3,
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
