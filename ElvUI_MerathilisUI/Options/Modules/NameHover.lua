local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local NH = MER:GetModule("MER_NameHover")

local options = module.options.modules.args

options.nameHover = {
	type = "group",
	name = L["Name Hover"],
	get = function(info)
		return E.db.mui.nameHover[info[#info]]
	end,
	set = function(info, value)
		local key = info[#info]

		E.db.mui.nameHover[key] = value

		-- Instant apply (no reload needed)
		if key == "blizztooltip" or key == "disableInDungeons" or key == "inspectKey" then
			if NH and NH.frame then
				NH.inspectMode = false

				if NH.UpdateInstanceState then
					NH:UpdateInstanceState()
				end

				-- Force tooltip refresh
				if GameTooltip and GameTooltip:IsShown() then
					GameTooltip:Show()
				end

				-- Force NameHover refresh
				NH.frame:Show()
			end

			return --IMPORTANT: prevents reload popup
		end

		-- Everything else requires reload
		E:StaticPopup_Show("GLOBAL_RL")
	end,
	args = {
		header = {
			order = 1,
			type = "header",
			name = F.cOption(L["Name Hover"], "orange"),
		},
		credits = {
			order = 2,
			type = "group",
			name = F.cOption(L["Credits"], "orange"),
			guiInline = true,
			args = {
				tukui = {
					order = 1,
					type = "description",
					name = L["ncHoverName by Nightcracker"],
				},
			},
		},
		enable = {
			order = 2,
			type = "toggle",
			name = L["Enable"],
			width = "full",
		},
		textGroup = {
			order = 3,
			type = "group",
			name = L["Text Options"],
			guiInline = true,
			args = {
				mainTextOutline = {
					order = 3,
					type = "select",
					name = L["Main Text Outline"],
					values = MER.Values.FontFlags,
					sortByValue = true,
				},
				mainTextSize = {
					order = 4,
					name = L["Main Text Size"],
					type = "range",
					min = 5,
					max = 60,
					step = 1,
				},
				statusTextOutline = {
					order = 5,
					type = "select",
					name = L["Status Text Outline"],
					values = MER.Values.FontFlags,
					sortByValue = true,
				},
				statusTextSize = {
					order = 6,
					name = L["Status Text Size"],
					type = "range",
					min = 5,
					max = 60,
					step = 1,
				},
				headerTextOutline = {
					order = 7,
					type = "select",
					name = L["Header Text Outline"],
					values = MER.Values.FontFlags,
					sortByValue = true,
				},
				headerTextSize = {
					order = 8,
					name = L["Header Text Size"],
					type = "range",
					min = 5,
					max = 60,
					step = 1,
				},
				guildTextOutline = {
					order = 9,
					type = "select",
					name = L["Guild Text Outline"],
					values = MER.Values.FontFlags,
					sortByValue = true,
				},
				guildTextSize = {
					order = 10,
					name = L["Guild Text Size"],
					type = "range",
					min = 5,
					max = 60,
					step = 1,
				},
				subTextOutline = {
					order = 11,
					type = "select",
					name = L["Sub Text Outline"],
					values = MER.Values.FontFlags,
					sortByValue = true,
				},
				subTextSize = {
					order = 12,
					name = L["Sub Text Size"],
					type = "range",
					min = 5,
					max = 60,
					step = 1,
				},
			},
		},
		targettarget = {
			order = 4,
			type = "toggle",
			name = L["Show Target of Target"],
		},
		guildName = {
			order = 5,
			type = "toggle",
			name = L["Guild Name"],
		},
		guildRank = {
			order = 6,
			type = "toggle",
			name = L["Guild Rank"],
		},
		race = {
			order = 7,
			type = "toggle",
			name = L["Race"],
		},
		status = {
			order = 8,
			type = "toggle",
			name = L["Status"],
		},
		faction = {
			order = 9,
			type = "toggle",
			name = L["Faction"],
		},
		level = {
			order = 10,
			type = "toggle",
			name = L["Level"],
		},
		classification = {
			order = 11,
			type = "toggle",
			name = L["Classification"],
		},
		BlizzToolTipGroup = {
			order = 12,
			type = "group",
			name = E.NewSign .. L["Blizzard ToolTip Options"],
			guiInline = true,
			args = {
				blizztooltip = {
					order = 12,
					type = "toggle",
					name = L["Blizzard Tool Tip"],
					desc = L["Show Blizzard unit tooltip alongside NameHover. If disabled, you can use keybind to quickly switch between NameHover and Blizzard"],
				},

				disableInDungeons = {
					order = 13,
					type = "toggle",
					name = L["Disable in Dungeons/Raids"],
					desc = L["Disable NameHover inside dungeons, raids and scenarios.\nIf disabled, NameHover will replace the Blizzard tooltip instead."],
				},

				inspectKey = {
					order = 14,
					type = "select",
					name = L["Blizzard Inspect Button Fallback"],
					desc = L["Use the WoW Key Bindings menu for the custom Hold to show bind. This modifier remains available for these hotkeys"],
					values = {
						SHIFT = "SHIFT",
						CTRL = "CTRL",
						ALT = "ALT",
						NONE = "NONE",
					},
				},
			},
		},
	},
}
