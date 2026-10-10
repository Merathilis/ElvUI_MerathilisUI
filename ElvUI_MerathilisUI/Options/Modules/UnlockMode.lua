local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options

-- Built on the first open of the options, see module:AddOptions in Options/Core.lua
module:AddOptions(function()
	local UM = MER:GetModule("MER_UnlockMode")

	local next = next

	local options = module.options.modules.args

	F.MarkTabAsNew("unlockMode")

	local function DB()
		return E.db.mui.unlockMode
	end

	local function Update()
		UM:SettingsUpdate()
	end

	local function Disabled()
		return not DB().enable
	end

	local function SnapDisabled()
		return Disabled() or not DB().snap.enable
	end

	options.unlockMode = {
		type = "group",
		name = module:AddCategorieIcon(L["Unlock Mode"], "unlock_mode"),
		childGroups = "tab",
		get = function(info)
			return DB()[info[#info]]
		end,
		set = function(info, value)
			DB()[info[#info]] = value
			Update()
		end,
		args = {
			enable = module.ToggleCard({
				order = 1,
				name = L["Unlock Mode"],
				desc = L["Extends ElvUI's mover mode: movers snap to each other with guide lines, can be anchored to each other, a click selects a mover for the arrow keys and a toolbar shows your changes, which you can save or revert. The positions stay in ElvUI's profile."],
				image = I.Media.Icons.Categories.unlock_mode,
			}),
			open = {
				order = 2,
				type = "execute",
				name = L["Open Unlock Mode"],
				desc = L["Opens ElvUI's mover mode with the additions of this page."],
				func = function()
					E:ToggleMoveMode()
					E.ConfigurationToggled = true
				end,
			},
			preview = module.PreviewOption(3, "MERUnlockModePreview", "screen"),
			general = {
				order = 10,
				type = "group",
				name = L["General"],
				disabled = Disabled,
				args = {
					animation = {
						order = 0,
						type = "toggle",
						name = L["Animation"],
						desc = L["Plays a short unlock animation when the mover mode opens and a lock animation when it closes."],
					},
					toolbar = {
						order = 1,
						type = "toggle",
						name = L["Toolbar"],
						desc = L["Shows a toolbar at the top of the screen instead of ElvUI's mover window, with the layout filter, grid, snapping and your changes."],
					},
					showGrid = {
						order = 2,
						type = "toggle",
						name = L["Show Grid"],
					},
					gridAccent = {
						order = 3,
						type = "toggle",
						name = L["Class Colored Grid"],
						desc = L["Draws the center lines of the grid in your class color."],
					},
					sortBySize = {
						order = 4,
						type = "toggle",
						name = L["Small Movers on Top"],
						desc = L["Small movers are drawn above big ones, so a mover inside another one can still be grabbed."],
					},
					editModeHints = {
						order = 5,
						type = "toggle",
						name = L["Edit Mode Hints"],
						desc = L["Marks the parts of the interface that Blizzard's Edit Mode places instead of ElvUI. A click on one closes the mover mode and opens the Edit Mode."],
					},
				},
			},
			snap = {
				order = 20,
				type = "group",
				name = L["Snapping"],
				disabled = Disabled,
				get = function(info)
					return DB().snap[info[#info]]
				end,
				set = function(info, value)
					DB().snap[info[#info]] = value
					Update()
				end,
				args = {
					desc = {
						order = 0,
						type = "description",
						fontSize = "medium",
						name = L["While you drag a mover, its edges and center snap to the edges and centers of the other movers. Hold Shift to drag freely. Replaces ElvUI's Sticky Frames as long as it is on."],
					},
					enable = {
						order = 1,
						type = "toggle",
						name = L["Enable"],
					},
					guides = {
						order = 2,
						type = "toggle",
						name = L["Guide Lines"],
						desc = L["Draws a line across the screen where the mover snapped."],
						disabled = SnapDisabled,
					},
					screen = {
						order = 3,
						type = "toggle",
						name = L["Snap to Screen"],
						desc = L["Also snaps to the center and the edges of the screen."],
						disabled = SnapDisabled,
					},
					distance = {
						order = 4,
						type = "range",
						name = L["Snap Distance"],
						desc = L["How close an edge has to come before it snaps, in pixels."],
						min = 2,
						max = 30,
						step = 1,
						disabled = SnapDisabled,
					},
				},
			},
			anchors = {
				order = 25,
				type = "group",
				name = L["Anchors"],
				disabled = Disabled,
				args = {
					desc = {
						order = 0,
						type = "description",
						fontSize = "medium",
						name = L["Select a mover, then Alt-click another one: the selected mover is anchored to it and follows it from then on. The side is taken from where the mover sits. Dragging or nudging an anchored mover only changes its distance to the target. Alt-click the target again to detach it."],
					},
					anchorLines = {
						order = 1,
						type = "toggle",
						name = L["Anchor Lines"],
						desc = L["Connects anchored movers with a line in the mover mode."],
					},
					detachAll = {
						order = 2,
						type = "execute",
						name = L["Detach All"],
						desc = L["Detaches every anchored mover, it keeps its current place on the screen."],
						confirm = true,
						disabled = function()
							return Disabled() or next(DB().anchors) == nil
						end,
						func = function()
							UM:DetachAll()
						end,
					},
				},
			},
			keyboard = {
				order = 30,
				type = "group",
				name = L["Keyboard"],
				disabled = Disabled,
				args = {
					desc = {
						order = 0,
						type = "description",
						fontSize = "medium",
						name = L["Click a mover to select it, the arrow keys then move it by one pixel. Escape or another click on it clears the selection."],
					},
					keyboardNudge = {
						order = 1,
						type = "toggle",
						name = L["Arrow Keys"],
					},
					bigStep = {
						order = 2,
						type = "range",
						name = L["Step with Modifier"],
						desc = L["Pixels per key press while Shift, Ctrl or Alt is held."],
						min = 2,
						max = 50,
						step = 1,
						disabled = function()
							return Disabled() or not DB().keyboardNudge
						end,
					},
				},
			},
		},
	}
end)
