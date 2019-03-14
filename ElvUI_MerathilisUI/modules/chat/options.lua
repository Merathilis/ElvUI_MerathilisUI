local MER, E, L, V, P, G = unpack(select(2, ...))
local MERC = MER:GetModule("muiChat")

local function ChatTable()
	E.Options.args.mui.args.modules.args.chat = {
		type = "group",
		name = E.NewSign..MERC.modName,
		order = 11,
		get = function(info) return E.db.mui.chat[ info[#info] ] end,
		set = function(info, value) E.db.mui.chat[ info[#info] ] = value; E:StaticPopup_Show("PRIVATE_RL"); end,
		args = {
			header1 = {
				type = "header",
				name = MER:cOption(MERC.modName),
				order = 1
			},
			chatButton = {
				order = 2,
				type = "toggle",
				name = L["Chat Menu"],
				desc = L["Create a chat button to increase the chat size and chat menu button."],
			},
			iLevelLink = {
				order = 3,
				type = "toggle",
				name = L["Chat Item Level"],
				desc = L["Shows the slot and item level in the chat"],
			},
			hidePlayerBrackets = {
				order = 4,
				type = "toggle",
				name = L["Hide Player Brackets"],
				desc = L["Removes brackets around the person who posts a chat message."],
			},
			sidePanel = {
				order = 5,
				type = "toggle",
				name = L["Hide Chat Side Panel"],
				desc = L["Removes the Chat SidePanel. |cffFF0000WARNING: If you disable this option you must adjust your Layout.|r"],
			},
			hideChat = {
				order = 7,
				type = "toggle",
				name = E.NewSign..L["Hide Community Chat"],
				desc = L["Adds an overlay to the Community Chat. Useful for streamers."],
			},
		},
	}
end

tinsert(MER.Config, ChatTable)
