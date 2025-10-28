local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local options = MER.options.modules.args
local module = MER:GetModule("MER_Chat")
local CH = E:GetModule("Chat")

local _G = _G

options.chat = {
	type = "group",
	name = L["Chat"],
	get = function(info)
		return E.db.mui.chat[info[#info]]
	end,
	set = function(info, value)
		E.db.mui.chat[info[#info]] = value
		E:StaticPopup_Show("PRIVATE_RL")
	end,
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.cOption(L["Chat"], "orange"),
		},
		enable = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
		},
		general = {
			order = 2,
			type = "group",
			name = F.cOption(L["General"], "orange"),
			inline = true,
			args = {
				chatButton = {
					order = 1,
					type = "toggle",
					name = L["Chat Menu"],
					desc = L["Create a chat button to increase the chat size."],
				},
				hideChat = {
					order = 2,
					type = "toggle",
					name = L["Hide Community Chat"],
					desc = L["Adds an overlay to the Community Chat. Useful for streamers."],
				},
				editBoxPosition = {
					order = 4,
					type = "select",
					name = L["Chat EditBox Position"],
					desc = L["Position of the Chat EditBox, if the Actionbar backdrop is disabled, this will be forced to be above chat."],
					values = {
						["BELOW_CHAT"] = L["Below Chat"],
						["ABOVE_CHAT"] = L["Above Chat"],
						["EAB_1"] = L["Actionbar 1 (below)"],
						["EAB_2"] = L["Actionbar 2 (below)"],
						["EAB_3"] = L["Actionbar 3 (below)"],
						["EAB_4"] = L["Actionbar 4 (below)"],
						["EAB_5"] = L["Actionbar 5 (below)"],
						["EAB_6"] = L["Actionbar 6 (above)"],
					},
					disabled = function()
						return not E.db.mui.chat.enable
					end,
					get = function(info)
						return E.db.mui.chat[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.chat[info[#info]] = value
						CH:UpdateEditboxAnchors()
					end,
				},
			},
		},
		seperators = {
			order = 15,
			type = "group",
			name = F.cOption(L["Seperators"], "orange"),
			disabled = function()
				return not E.db.mui.chat.enable
			end,
			get = function(info)
				return E.db.mui.chat.seperators[info[#info]]
			end,
			set = function(info, value)
				E.db.mui.chat.seperators[info[#info]] = value
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
				},
				visibility = {
					order = 2,
					type = "select",
					name = L["Visibility"],
					get = function(info)
						return E.db.mui.chat.seperators[info[#info]]
					end,
					set = function(info, value)
						E.db.mui.chat.seperators[info[#info]] = value
						module:UpdateSeperators()
					end,
					values = {
						HIDEBOTH = L["Hide Both"],
						SHOWBOTH = L["Show Both"],
						LEFT = L["Left Only"],
						RIGHT = L["Right Only"],
					},
				},
			},
		},
	},
}
