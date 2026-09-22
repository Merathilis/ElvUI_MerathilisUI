local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options

local options = module.options.modules.args

F.MarkTabAsNew("chat")

local function SidebarDB()
	return E.db.mui.chat.sidebar
end

local function Update()
	F.Event.TriggerEvent("ChatSidebar.SettingsUpdate")
end

local function Disabled()
	return not E.private.chat.enable or not SidebarDB().enable
end

local function ChatDB()
	return E.db.mui.chat
end

local function ColorGet(db, default)
	return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
end

options.chat = {
	type = "group",
	name = module:AddCategorieIcon(L["Chat"], "chat"),
	args = {
		header = {
			order = 0,
			type = "header",
			name = F.NewFeatureText(F.cOption(L["Chat"], "orange")),
		},
		sidebar = {
			order = 1,
			type = "group",
			guiInline = true,
			name = L["Chat Sidebar"],
			get = function(info)
				return SidebarDB()[info[#info]]
			end,
			set = function(info, value)
				SidebarDB()[info[#info]] = value
				Update()
			end,
			disabled = Disabled,
			args = {
				desc = {
					order = 0,
					type = "group",
					inline = true,
					name = L["Description"],
					args = {
						feature = {
							order = 1,
							type = "description",
							name = L["Adds a slim icon bar inside a chat panel with quick access to friends, guild, copy chat, M+ portals and more."],
							fontSize = "medium",
						},
						requirement = {
							order = 2,
							type = "description",
							name = function()
								return E.private.chat.enable and ""
									or F.cOption(L["Requires ElvUI's Chat module to be enabled."], "red")
							end,
							fontSize = "medium",
						},
					},
				},
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					disabled = function()
						return not E.private.chat.enable
					end,
				},
				spacer = {
					order = 2,
					type = "description",
					name = "",
				},
				layout = {
					order = 3,
					type = "group",
					inline = true,
					name = L["Layout"],
					args = {
						panel = {
							order = 1,
							type = "select",
							name = L["Chat Panel"],
							values = {
								LEFT = L["Left Chat"],
								RIGHT = L["Right Chat"],
							},
						},
						side = {
							order = 2,
							type = "select",
							name = L["Side"],
							desc = L["Which edge of the chat panel the sidebar sits on."],
							values = {
								LEFT = L["Left"],
								RIGHT = L["Right"],
							},
						},
						attach = {
							order = 3,
							type = "select",
							name = L["Position"],
							desc = L["Inside shares the chat panel and moves the chat text aside, outside places the sidebar as its own block next to the panel."],
							values = {
								INSIDE = L["Inside"],
								OUTSIDE = L["Outside"],
							},
						},
						attachSpacing = {
							order = 4,
							type = "range",
							name = L["Distance"],
							min = 0,
							max = 20,
							step = 1,
							disabled = function()
								return Disabled() or SidebarDB().attach ~= "OUTSIDE"
							end,
						},
						visibility = {
							order = 5,
							type = "select",
							name = L["Visibility"],
							values = {
								ALWAYS = L["Always"],
								MOUSEOVER = L["Mouseover"],
							},
						},
						divider = {
							order = 6,
							type = "toggle",
							name = L["Divider"],
							desc = L["Draws a thin line between the sidebar and the chat text."],
							disabled = function()
								return Disabled() or SidebarDB().attach == "OUTSIDE"
							end,
						},
						width = {
							order = 7,
							type = "range",
							name = L["Width"],
							min = 18,
							max = 60,
							step = 1,
						},
						iconSize = {
							order = 8,
							type = "range",
							name = L["Icon Size"],
							min = 10,
							max = 40,
							step = 1,
						},
						spacing = {
							order = 9,
							type = "range",
							name = L["Spacing"],
							min = 0,
							max = 20,
							step = 1,
						},
						counterFontSize = {
							order = 10,
							type = "range",
							name = L["Counter Font Size"],
							min = 6,
							max = 20,
							step = 1,
						},
					},
				},
				colors = {
					order = 4,
					type = "group",
					inline = true,
					name = L["Colors"],
					args = {
						iconColor = {
							order = 1,
							type = "color",
							name = L["Icon Color"],
							hasAlpha = false,
							get = function(info)
								local db = SidebarDB()[info[#info]]
								local default = P.chat.sidebar[info[#info]]
								return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = SidebarDB()[info[#info]]
								db.r, db.g, db.b = r, g, b
								Update()
							end,
						},
						iconAlpha = {
							order = 2,
							type = "range",
							name = L["Icon Alpha"],
							min = 0.1,
							max = 1,
							step = 0.05,
							isPercent = true,
						},
						spacer = {
							order = 3,
							type = "description",
							name = "",
						},
						hoverClassColor = {
							order = 4,
							type = "toggle",
							name = L["Hover Class Color"],
							desc = L["Highlights hovered icons in your class color."],
						},
						hoverColor = {
							order = 5,
							type = "color",
							name = L["Hover Color"],
							hasAlpha = false,
							disabled = function()
								return Disabled() or SidebarDB().hoverClassColor
							end,
							get = function(info)
								local db = SidebarDB()[info[#info]]
								local default = P.chat.sidebar[info[#info]]
								return db.r, db.g, db.b, nil, default.r, default.g, default.b, nil
							end,
							set = function(info, r, g, b)
								local db = SidebarDB()[info[#info]]
								db.r, db.g, db.b = r, g, b
								Update()
							end,
						},
					},
				},
				buttons = {
					order = 5,
					type = "group",
					inline = true,
					name = L["Buttons"],
					get = function(info)
						return SidebarDB().buttons[info[#info]]
					end,
					set = function(info, value)
						SidebarDB().buttons[info[#info]] = value
						Update()
					end,
					args = {
						desc = {
							order = 0,
							type = "description",
							name = L["Buttons that no longer fit the panel height are left out."]
								.. "\n"
								.. L["Shift + drag an icon in the sidebar to change the order."],
						},
						friends = {
							order = 1,
							type = "toggle",
							name = L["Friends"],
							desc = L["Shows the number of friends online."],
						},
						guild = {
							order = 2,
							type = "toggle",
							name = L["Guild"],
							desc = L["Shows the number of guild members online."],
						},
						durability = {
							order = 3,
							type = "toggle",
							name = L["Durability"],
							desc = L["Shows the durability of your most damaged item."],
						},
						copy = {
							order = 4,
							type = "toggle",
							name = L["Copy Chat"],
							desc = L["Replaces ElvUI's copy button on the chat windows. Right-click opens the chat menu."],
						},
						portals = {
							order = 5,
							type = "toggle",
							name = L["M+ Portals"],
						},
						voice = {
							order = 6,
							type = "toggle",
							name = L["Voice / Channels"],
						},
						settings = {
							order = 7,
							type = "toggle",
							name = L["Settings"],
						},
						scroll = {
							order = 8,
							type = "toggle",
							name = L["Scroll to Bottom"],
							desc = L["Pinned to the bottom of the sidebar, lights up while the chat is scrolled up."],
						},
						durabilityWarning = {
							order = 9,
							type = "range",
							name = L["Durability Warning"],
							desc = L["The durability counter turns red at or below this value."],
							min = 0,
							max = 100,
							step = 1,
							get = function(info)
								return SidebarDB()[info[#info]]
							end,
							set = function(info, value)
								SidebarDB()[info[#info]] = value
								Update()
							end,
							disabled = function()
								return Disabled() or not SidebarDB().buttons.durability
							end,
						},
						resetOrder = {
							order = 10,
							type = "execute",
							name = L["Reset Order"],
							func = function()
								SidebarDB().order = P.chat.sidebar.order
								Update()
							end,
						},
					},
				},
			},
		},
		panel = {
			order = 2,
			type = "group",
			guiInline = true,
			name = L["Chat Panels"],
			get = function(info)
				return ChatDB()[info[#info]]
			end,
			set = function(info, value)
				ChatDB()[info[#info]] = value
				MER:GetModule("MER_Chat"):UpdateResizeGrips()
			end,
			disabled = function()
				return not E.private.chat.enable
			end,
			args = {
				lockSize = {
					order = 1,
					type = "toggle",
					name = L["Lock Chat Size"],
					desc = L["Hides the resize grip that shows in the corner of a chat panel while hovering it."],
				},
				underline = {
					order = 3,
					type = "toggle",
					name = L["Active Underline"],
					desc = L["Marks the active tab with a line in your class color."],
					get = function()
						return ChatDB().tabs.underline
					end,
					set = function(_, value)
						ChatDB().tabs.underline = value
						MER:GetModule("MER_Chat"):UpdateTabs()
					end,
				},
				combatLog = {
					order = 2,
					type = "toggle",
					name = L["Combat Log Filters"],
					desc = L["Colors the active combat log filter in your class color and dims the others."],
					get = function()
						return ChatDB().combatLog.enable
					end,
					set = function(_, value)
						ChatDB().combatLog.enable = value
						MER:GetModule("MER_Chat"):UpdateCombatLog()
					end,
				},
			},
		},
		editBox = {
			order = 3,
			type = "group",
			guiInline = true,
			name = L["Edit Box"],
			get = function(info)
				return ChatDB().editBox[info[#info]]
			end,
			set = function(info, value)
				ChatDB().editBox[info[#info]] = value
				MER:GetModule("MER_Chat"):UpdateEditBoxes()
			end,
			disabled = function(info)
				if not E.private.chat.enable then
					return true
				end
				return info[#info] ~= "enable" and not ChatDB().editBox.enable
			end,
			args = {
				desc = {
					order = 0,
					type = "description",
					name = L["Restyles the chat input box."],
				},
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
				},
				editBoxPosition = {
					order = 1.5,
					type = "select",
					name = function()
						return L["Chat EditBox Position"]
					end,
					desc = L["Same setting as in ElvUI's chat options, shown here for convenience."],
					-- ElvUI's own labels only exist once its options are loaded, so
					-- they are looked up when the dropdown is drawn.
					values = function()
						return {
							BELOW_CHAT = L["Below Chat"],
							ABOVE_CHAT = L["Above Chat"],
							BELOW_CHAT_INSIDE = L["Below Chat (Inside)"],
							ABOVE_CHAT_INSIDE = L["Above Chat (Inside)"],
						}
					end,
					get = function()
						return E.db.chat.editBoxPosition
					end,
					set = function(_, value)
						E.db.chat.editBoxPosition = value
						E:GetModule("Chat"):UpdateEditboxAnchors()
					end,
					disabled = function()
						return not E.private.chat.enable
					end,
				},
				style = {
					order = 2,
					type = "toggle",
					name = L["MerathilisUI Style"],
					desc = L["Transparent backdrop with the MerathilisUI stripes and gradient."],
				},
				backdropAlpha = {
					order = 2.5,
					type = "range",
					name = L["Backdrop Alpha"],
					desc = L["How opaque the edit box backdrop is. ElvUI's own transparency setting is used for everything else."],
					min = 0,
					max = 1,
					step = 0.05,
					isPercent = true,
					disabled = function()
						local db = ChatDB().editBox
						return not E.private.chat.enable or not db.enable or not db.style
					end,
				},
				accent = {
					order = 3,
					type = "toggle",
					name = L["Chat Type Accent"],
					desc = L["A neutral border with a small bar in the color of the current chat type, instead of coloring the whole border."],
				},
				badge = {
					order = 4,
					type = "toggle",
					name = L["Header Badge"],
					desc = L["Shows the chat type prefix (Say, Guild, Whisper to ...) as a colored badge."],
				},
				animation = {
					order = 5,
					type = "toggle",
					name = L["Open Animation"],
					desc = L["Fades the box in when it opens."],
				},
				glow = {
					order = 6,
					type = "toggle",
					name = L["Class Color Glow"],
					desc = L["A glow in your class color around the box while it is open."],
				},
			},
		},
	},
}

-------------------------------------------------------------------------------
-- ElvUI options our chat extensions take over are grayed out while they do,
-- with a hint pointing here instead.
-------------------------------------------------------------------------------
local REPLACED_ELVUI_OPTIONS = {
	{
		path = { "chat", "general", "hideCopyButton" },
		isReplaced = function()
			local db = SidebarDB()
			return E.private.chat.enable and db.enable and db.buttons.copy
		end,
		reason = function()
			return L["Replaced by the copy button of the MerathilisUI Chat Sidebar."]
		end,
		fallbackDisabled = function()
			return not E.Chat.Initialized
		end,
	},
}

-- AceConfigRegistry validates option tables against a fixed key list, so the
-- "already patched" flag lives here instead of on ElvUI's option.
local patchedOptions = {}

local function FindElvUIOption(path)
	local option = E.Options.args[path[1]]
	for i = 2, #path do
		option = option and option.args and option.args[path[i]]
	end
	return option
end

local function ReplacedHint(entry)
	return F.cOption(entry.reason(), "orange")
end

hooksecurefunc(module, "OptionsCallback", function()
	for _, entry in ipairs(REPLACED_ELVUI_OPTIONS) do
		local option = FindElvUIOption(entry.path)
		if option and not patchedOptions[option] then
			patchedOptions[option] = true

			local disabled, desc = option.disabled, option.desc
			option.disabled = function(info)
				if entry.isReplaced() then
					return true
				end
				if type(disabled) == "function" then
					return disabled(info)
				elseif disabled ~= nil then
					return disabled
				end
				return entry.fallbackDisabled and entry.fallbackDisabled() or false
			end

			option.desc = function(info)
				local text = type(desc) == "function" and desc(info) or desc
				if not entry.isReplaced() then
					return text
				end
				return text and (text .. "\n\n" .. ReplacedHint(entry)) or ReplacedHint(entry)
			end
		end
	end
end)
