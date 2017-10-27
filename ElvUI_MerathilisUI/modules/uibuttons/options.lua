local MER, E, L, V, P, G = unpack(select(2, ...))
local MUB = E:GetModule("muiButtons")

--Cache global variables
local pairs, type = pairs, type
local format = string.format
--WoW API / Variables
local CUSTOM, NONE, DEFAULT = CUSTOM, NONE, DEFAULT
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local positionValues = {
	TOPLEFT = 'TOPLEFT',
	LEFT = 'LEFT',
	BOTTOMLEFT = 'BOTTOMLEFT',
	RIGHT = 'RIGHT',
	TOPRIGHT = 'TOPRIGHT',
	BOTTOMRIGHT = 'BOTTOMRIGHT',
	CENTER = 'CENTER',
	TOP = 'TOP',
	BOTTOM = 'BOTTOM',
};

local stratas = {
	["BACKGROUND"] = "1. Background",
	["LOW"] = "2. Low",
	["MEDIUM"] = "3. Medium",
	["HIGH"] = "4. High",
	["DIALOG"] = "5. Dialog",
	["FULLSCREEN"] = "6. Fullscreen",
	["FULLSCREEN_DIALOG"] = "7. Fullscreen Dialog",
	["TOOLTIP"] = "8. Tooltip",
}

local function uiButtonsTable()
	local Bar = MUB.Holder
	E.Options.args.mui.args.uiButtons = {
		type = "group",
		name = MUB.modName or MUB:GetName(),
		order = 19,
		get = function(info) return E.db.mui.uiButtons[ info[#info] ] end,
		args = {
			name = {
				order = 1,
				type = "header",
				name = MER:cOption(MUB.modName or MUB:GetName()),
			},
			credits = {
				order = 2,
				type = "group",
				name = MER:cOption(L["Credits"]),
				guiInline = true,
				args = {
					tukui = {
						order = 1,
						type = "description",
						fontSize = "medium",
						name = format("|cff9482c9Shadow&Light - Darth Predator|r"),
					},
				},
			},
			enabled = {
				order = 3,
				type = "toggle",
				name = L["Enable"],
				desc = L["Show/Hide UI buttons."],
				get = function(info) return E.db.mui.uiButtons.enable end,
				set = function(info, value) E.db.mui.uiButtons.enable = value; Bar:ToggleShow() end
			},
			style = {
				order = 4,
				name = L["UI Buttons Style"],
				type = "select",
				values = {
					["classic"] = L["Classic"],
					["dropdown"] = L["Dropdown"],
				},
				disabled = function() return not E.db.mui.uiButtons.enable end,
				hidden = function() return not E.db.mui.uiButtons.enable end,
				get = function(info) return E.db.mui.uiButtons.style end,
				set = function(info, value) E.db.mui.uiButtons.style = value; E:StaticPopup_Show("PRIVATE_RL") end,
			},
			space = {
				order = 5,
				type = 'description',
				name = "",
				hidden = function() return not E.db.mui.uiButtons.enable end,
			},
			size = {
				order = 6,
				type = "range",
				name = L["Size"],
				desc = L["Sets size of buttons"],
				min = 12, max = 25, step = 1,
				disabled = function() return not E.db.mui.uiButtons.enable end,
				hidden = function() return not E.db.mui.uiButtons.enable end,
				get = function(info) return E.db.mui.uiButtons.size end,
				set = function(info, value) E.db.mui.uiButtons.size = value; Bar:FrameSize() end,
			},
			spacing = {
				order = 7,
				type = "range",
				name = L["Button Spacing"],
				desc = L["The spacing between buttons."],
				min = -4, max = 10, step = 1,
				disabled = function() return not E.db.mui.uiButtons.enable end,
				hidden = function() return not E.db.mui.uiButtons.enable end,
				get = function(info) return E.db.mui.uiButtons.spacing end,
				set = function(info, value) E.db.mui.uiButtons.spacing = value; Bar:FrameSize() end,
			},
			mouse = {
				order = 8,
				type = "toggle",
				name = L["Mouse Over"],
				desc = L["Show on mouse over."],
				disabled = function() return not E.db.mui.uiButtons.enable end,
				hidden = function() return not E.db.mui.uiButtons.enable end,
				get = function(info) return E.db.mui.uiButtons.mouse end,
				set = function(info, value) E.db.mui.uiButtons.mouse = value; Bar:UpdateMouseOverSetting() end
			},
			menuBackdrop = {
				order = 9,
				type = "toggle",
				name = L["Backdrop"],
				disabled = function() return not E.db.mui.uiButtons.enable end,
				hidden = function() return not E.db.mui.uiButtons.enable end,
				get = function(info) return E.db.mui.uiButtons.menuBackdrop end,
				set = function(info, value) E.db.mui.uiButtons.menuBackdrop = value; Bar:UpdateBackdrop() end
			},
			dropdownBackdrop = {
				order = 10,
				type = "toggle",
				name = L["Dropdown Backdrop"],
				disabled = function() return not E.db.mui.uiButtons.enable or E.db.mui.uiButtons.style == "classic" end,
				hidden = function() return not E.db.mui.uiButtons.enable end,
				get = function(info) return E.db.mui.uiButtons.dropdownBackdrop end,
				set = function(info, value) E.db.mui.uiButtons.dropdownBackdrop = value; Bar:FrameSize() end
			},
			orientation = {
				order = 11,
				name = L["Buttons position"],
				desc = L["Layout for UI buttons."],
				type = "select",
				values = {
					["horizontal"] = L["Horizontal"],
					["vertical"] = L["Vertical"],
				},
				disabled = function() return not E.db.mui.uiButtons.enable end,
				hidden = function() return not E.db.mui.uiButtons.enable end,
				get = function(info) return E.db.mui.uiButtons.orientation end,
				set = function(info, value) E.db.mui.uiButtons.orientation = value; Bar:FrameSize() end,
			},
			point = {
				type = 'select',
				order = 12,
				name = L["Anchor Point"],
				desc = L["What point of dropdown will be attached to the toggle button."],
				disabled = function() return not E.db.mui.uiButtons.enable or E.db.mui.uiButtons.style == "classic" end,
				hidden = function() return not E.db.mui.uiButtons.enable end,
				get = function(info) return E.db.mui.uiButtons.point end,
				set = function(info, value) E.db.mui.uiButtons.point = value; Bar:FrameSize() end,
				values = positionValues,
			},
			anchor = {
				type = 'select',
				order = 13,
				name = L["Attach To"],
				desc = L["What point to anchor dropdown on the toggle button."],
				disabled = function() return not E.db.mui.uiButtons.enable or E.db.mui.uiButtons.style == "classic" end,
				hidden = function() return not E.db.mui.uiButtons.enable end,
				get = function(info) return E.db.mui.uiButtons.anchor end,
				set = function(info, value) E.db.mui.uiButtons.anchor = value; Bar:FrameSize() end,
				values = positionValues,
			},
			xoffset = {
				order = 14,
				type = "range",
				name = L["X-Offset"],
				desc = L["Horizontal offset of dropdown from the toggle button."],
				min = -10, max = 10, step = 1,
				disabled = function() return not E.db.mui.uiButtons.enable or E.db.mui.uiButtons.style == "classic" end,
				hidden = function() return not E.db.mui.uiButtons.enable end,
				get = function(info) return E.db.mui.uiButtons.xoffset end,
				set = function(info, value) E.db.mui.uiButtons.xoffset = value; Bar:FrameSize() end,
			},
			yoffset = {
				order = 15,
				type = "range",
				name = L["Y-Offset"],
				desc = L["Vertical offset of dropdown from the toggle button."],
				min = -10, max = 10, step = 1,
				disabled = function() return not E.db.mui.uiButtons.enable or E.db.mui.uiButtons.style == "classic" end,
				hidden = function() return not E.db.mui.uiButtons.enable end,
				get = function(info) return E.db.mui.uiButtons.yoffset end,
				set = function(info, value) E.db.mui.uiButtons.yoffset = value; Bar:FrameSize() end,
			},
			minroll = {
				order = 16,
				type = 'input',
				name = L["Minimum Roll Value"],
				desc = L["The lower limit for custom roll button."],
				disabled = function() return not E.db.mui.uiButtons.enable or E.db.mui.uiButtons.style == "classic" end,
				hidden = function() return not E.db.mui.uiButtons.enable end,
				get = function(info) return E.db.mui.uiButtons.customroll.min end,
				set = function(info, value) E.db.mui.uiButtons.customroll.min = value; end,
			},
			maxroll = {
				order = 17,
				type = 'input',
				name = L["Maximum Roll Value"],
				desc = L["The higher limit for custom roll button."],
				disabled = function() return not E.db.mui.uiButtons.enable or E.db.mui.uiButtons.style == "classic" end,
				hidden = function() return not E.db.mui.uiButtons.enable end,
				get = function(info) return E.db.mui.uiButtons.customroll.max end,
				set = function(info, value) E.db.mui.uiButtons.customroll.max = value; end,
			},
			visibility = {
				order = 18,
				type = 'input',
				width = 'full',
				name = L["Visibility State"],
				disabled = function() return not E.db.mui.uiButtons.enable end,
				hidden = function() return not E.db.mui.uiButtons.enable end,
				get = function(info) return E.db.mui.uiButtons.visibility end,
				set = function(info, value) E.db.mui.uiButtons.visibility = value; Bar:ToggleShow() end,
			},
			Config = {
				order = 30,
				name = "\"C\" "..L["Quick Action"],
				type = "group",
				guiInline = true,
				disabled = function() return not E.db.mui.uiButtons.enable or E.db.mui.uiButtons.style == "classic" end,
				hidden = function() return not E.db.mui.uiButtons.enable end,
				args = {
					enabled = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Use quick access (on right click) for this button."],
						get = function(info) return E.db.mui.uiButtons.Config.enable end,
						set = function(info, value) E.db.mui.uiButtons.Config.enable = value end
					},
					called = {
						order = 2,
						name = L["Function"],
						desc = L["Function called by quick access."],
						type = "select",
						values = {
							["Elv"] = L["ElvUI Config"],
							["SLE"] = L["S&L Config"],
							["Reload"] = L["Reload UI"],
							["MoveUI"] = L["Move UI"],
						},
						get = function(info) return E.db.mui.uiButtons.Config.called end,
						set = function(info, value) E.db.mui.uiButtons.Config.called = value; end,
					},
				},
			},
			Addon = {
				order = 31,
				name = "\"A\" "..L["Quick Action"],
				type = "group",
				guiInline = true,
				disabled = function() return not E.db.mui.uiButtons.enable or E.db.mui.uiButtons.style == "classic" end,
				hidden = function() return not E.db.mui.uiButtons.enable end,
				args = {
					enabled = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Use quick access (on right click) for this button."],
						get = function(info) return E.db.mui.uiButtons.Addon.enable end,
						set = function(info, value) E.db.mui.uiButtons.Addon.enable = value end
					},
					called = {
						order = 2,
						name = L["Function"],
						desc = L["Function called by quick access."],
						type = "select",
						values = {
							["Manager"] = L["AddOns"],
						},
						get = function(info) return E.db.mui.uiButtons.Addon.called end,
						set = function(info, value) E.db.mui.uiButtons.Addon.called = value; end,
					},
				},
			},
			Status = {
				order = 32,
				name = "\"S\" "..L["Quick Action"],
				type = "group",
				guiInline = true,
				disabled = function() return not E.db.mui.uiButtons.enable or E.db.mui.uiButtons.style == "classic" end,
				hidden = function() return not E.db.mui.uiButtons.enable end,
				args = {
					enabled = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Use quick access (on right click) for this button."],
						get = function(info) return E.db.mui.uiButtons.Status.enable end,
						set = function(info, value) E.db.mui.uiButtons.Status.enable = value end
					},
					called = {
						order = 2,
						name = L["Function"],
						desc = L["Function called by quick access."],
						type = "select",
						values = {
							["AFK"] = L["AFK"],
							["DND"] = L["DND"],
						},
						get = function(info) return E.db.mui.uiButtons.Status.called end,
						set = function(info, value) E.db.mui.uiButtons.Status.called = value; end,
					},
				},
			},
			Roll = {
				order = 33,
				name = "\"R\" "..L["Quick Action"],
				type = "group",
				guiInline = true,
				disabled = function() return not E.db.mui.uiButtons.enable or E.db.mui.uiButtons.style == "classic" end,
				hidden = function() return not E.db.mui.uiButtons.enable end,
				args = {
					enabled = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
						desc = L["Use quick access (on right click) for this button."],
						get = function(info) return E.db.mui.uiButtons.Roll.enable end,
						set = function(info, value) E.db.mui.uiButtons.Roll.enable = value end
					},
					called = {
						order = 2,
						name = L["Function"],
						desc = L["Function called by quick access."],
						type = "select",
						values = {
							["Ten"] = "1-10",
							["Twenty"] = "1-20",
							["Thirty"] = "1-30",
							["Forty"] = "1-40",
							["Hundred"] = "1-100",
							["Custom"] = CUSTOM,

						},
						get = function(info) return E.db.mui.uiButtons.Roll.called end,
						set = function(info, value) E.db.mui.uiButtons.Roll.called = value; end,
					},
				},
			},
		},
	}
	if E.db.mui.uiButtons.style == "dropdown" then
		for k, v in pairs(MUB.Holder.Addon) do
			if k ~= "Toggle" and type(v) == "table" and (v.HasScript and v:HasScript("OnClick")) then E.Options.args.mui.args.uiButtons.args.Addon.args.called.values[k] = k end
		end
	end
end

tinsert(MER.Config, uiButtonsTable)