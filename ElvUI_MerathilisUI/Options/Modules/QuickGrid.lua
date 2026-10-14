local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options

-- Built on the first open of the options, see module:AddOptions in Options/Core.lua
module:AddOptions(function()
	local QG = MER:GetModule("MER_QuickGrid")

	local _G = _G
	local ipairs, format = ipairs, format

	local GetBindingKey = GetBindingKey
	local GetCurrentBindingSet = GetCurrentBindingSet
	local InCombatLockdown = InCombatLockdown
	local SaveBindings = SaveBindings
	local SetBinding = SetBinding

	local options = module.options.modules.args

	local function DB()
		return E.db.mui.quickGrid
	end

	local function CustomSlots()
		return E.private.mui.quickGrid.custom
	end

	local function Update()
		QG:SettingsUpdate()
	end

	local function Disabled()
		return not DB().enable
	end

	local function Get(info)
		return DB()[info[#info]]
	end

	local function Set(info, value)
		DB()[info[#info]] = value
		Update()
	end

	-------------------------------------------------------------------------------
	--  Decks
	-------------------------------------------------------------------------------
	local function KeybindOption(order, binding)
		return {
			order = order,
			type = "keybinding",
			name = L["Keybind"],
			desc = L["Hold this key to open the deck. The free modifier combinations of the key open it too, so a modifier can be pressed while the deck is open."],
			get = function()
				return GetBindingKey(binding) or ""
			end,
			set = function(_, key)
				if InCombatLockdown() then
					F.Print(_G.ERR_NOT_IN_COMBAT)
					return
				end

				for _, old in ipairs({ GetBindingKey(binding) }) do
					SetBinding(old)
				end
				if key and key ~= "" then
					SetBinding(key, binding)
				end
				SaveBindings(GetCurrentBindingSet())
				QG:ApplyBindings()
			end,
		}
	end

	local deckArgs = {}
	for index, key in ipairs(QG.DeckOrder) do
		local deck = QG.Decks[key]
		deckArgs[key] = {
			order = index,
			type = "group",
			name = format("|T%s:16:16:0:0:64:64:5:59:5:59|t  %s", deck.icon, deck.name),
			guiInline = true,
			hidden = function()
				return not QG:IsDeckAvailable(key)
			end,
			args = {
				desc = {
					order = 1,
					type = "description",
					fontSize = "medium",
					name = deck.desc,
				},
				enable = {
					order = 2,
					type = "toggle",
					name = L["Enable"],
					get = function()
						return DB().decks[key]
					end,
					set = function(_, value)
						DB().decks[key] = value
						Update()
					end,
				},
				keybind = KeybindOption(3, deck.binding),
			},
		}
	end

	-------------------------------------------------------------------------------
	--  Custom deck
	--  The fields are laid out like the grid itself, cell numbers from Decks.lua
	-------------------------------------------------------------------------------
	local CUSTOM_LAYOUT = {
		{ cell = 8, name = L["Top Left"] },
		{ cell = 1, name = L["Top"] },
		{ cell = 2, name = L["Top Right"] },
		{ cell = 7, name = L["Left"] },
		{ center = true },
		{ cell = 3, name = L["Right"] },
		{ cell = 6, name = L["Bottom Left"] },
		{ cell = 5, name = L["Bottom"] },
		{ cell = 4, name = L["Bottom Right"] },
	}

	local customArgs = {
		desc = module.TextCard(
			1,
			L["Drag a spell, item or macro onto a field, or type the name of a spell, macro, mount, toy or item. Empty a field to clear it."]
		),
	}

	for index, field in ipairs(CUSTOM_LAYOUT) do
		if field.center then
			customArgs["center"] = {
				order = 10 + index,
				type = "description",
				name = "\n" .. L["The center cancels."],
				fontSize = "medium",
				width = "relative",
				relWidth = 0.33,
			}
		else
			local cell = field.cell
			customArgs["cell" .. cell] = {
				order = 10 + index,
				type = "input",
				name = field.name,
				width = "relative",
				relWidth = 0.33,
				get = function()
					return QG:SlotText(CustomSlots()[cell])
				end,
				set = function(_, text)
					local slot = QG:ParseSlotText(text)
					if not slot and text and text ~= "" then
						F.Print(
							format(L["Could not find %s. Use the name of a spell, macro, mount, toy or item."], text)
						)
						return
					end

					CustomSlots()[cell] = slot
					QG:RefreshDeck("custom")
				end,
			}
		end
	end

	-------------------------------------------------------------------------------
	--  Page
	-------------------------------------------------------------------------------
	options.quickGrid = {
		type = "group",
		name = module:AddCategorieIcon(L["Quick Grid"], "quick_grid"),
		childGroups = "tab",
		get = Get,
		set = Set,
		args = {
			header = {
				order = 0,
				type = "header",
				name = L["Quick Grid"],
			},
			enable = module.ToggleCard({
				order = 1,
				name = L["Quick Grid"],
				desc = L["Hold a key and a grid of eight actions opens around your mouse cursor. Point in a direction and release the key to use that action. Releasing in the center or without moving the mouse cancels. Works in combat."],
				image = I.Media.Icons.Categories.quick_grid,
			}),
			general = {
				order = 10,
				type = "group",
				name = L["General"],
				disabled = Disabled,
				args = {
					-- Inside the tab, not above it: the args above a tab group don't
					-- scroll, a tall widget there squeezes the tabs and AceGUI's
					-- auto height then grows the nested tab groups without end
					preview = {
						order = 0,
						type = "description",
						dialogControl = "MERQuickGridPreview",
						name = "",
						width = "full",
					},
					anchor = {
						order = 1,
						type = "select",
						name = L["Open At"],
						desc = L["Opens the grid under your mouse cursor or always in the middle of the screen."],
						values = {
							CURSOR = L["Cursor"],
							CENTER = L["Screen Center"],
						},
					},
					tileSize = {
						order = 2,
						type = "range",
						name = L["Tile Size"],
						min = 28,
						max = 72,
						step = 1,
					},
					spacing = {
						order = 3,
						type = "range",
						name = L["Spacing"],
						min = 0,
						max = 20,
						step = 1,
					},
					showCooldowns = {
						order = 4,
						type = "toggle",
						name = L["Show Cooldowns"],
						desc = L["Shows the cooldowns of spells, items and toys on their tiles."],
					},
					showLabel = {
						order = 5,
						type = "toggle",
						name = L["Show Name"],
						desc = L["Shows the name of the selected action below the grid."],
					},
					labelSize = {
						order = 6,
						type = "range",
						name = L["Name Size"],
						min = 8,
						max = 24,
						step = 1,
						disabled = function()
							return Disabled() or not DB().showLabel
						end,
					},
				},
			},
			decks = {
				order = 20,
				type = "group",
				name = L["Decks"],
				disabled = Disabled,
				args = deckArgs,
			},
			custom = {
				order = 30,
				type = "group",
				name = L["Custom Deck"],
				disabled = function()
					return Disabled() or not DB().decks.custom
				end,
				args = customArgs,
			},
		},
	}
end)
