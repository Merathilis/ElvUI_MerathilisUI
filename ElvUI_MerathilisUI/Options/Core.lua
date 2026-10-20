local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local MISC = MER:GetModule("MER_Misc")

local format, type, pairs, ipairs, next, tinsert, sort = format, type, pairs, ipairs, next, tinsert, sort
local gsub, strlower, strtrim = gsub, strlower, strtrim
local xpcall = xpcall
local min, max, floor = min, max, floor

local CreateTextureMarkup = CreateTextureMarkup

local logo =
	CreateTextureMarkup("Interface/AddOns/ElvUI_MerathilisUI/Media/textures/m2", 64, 64, 20, 20, 0, 1, 0, 1, 0, -1)

module.enabledState = F.Enum({ "YES", "NO", "FORCE_DISABLED" })
module.orderIndex = 1
module.callOnInit = {}

-- The option tables are built when ElvUI's options load for the first time, not at login:
-- every options file hands its body over as a builder. Post builders run after the tree
-- is assembled, on every OptionsCallback.
module.builders = {}
module.postBuilders = {}

function module:AddOptions(builder)
	tinsert(self.builders, builder)
end

function module:AddOptionsPostBuild(func)
	tinsert(self.postBuilders, func)
end

module.options = {
	general = {
		order = 101,
		name = L["General"],
		icon = I.Media.Icons.Categories.OptionsHome,
		args = {},
	},
	modules = {
		order = 102,
		name = L["Modules"],
		icon = I.Media.Icons.Categories.Config,
		args = {
			info = {
				order = 1,
				type = "description",
				name = L["Here you find the options for all the different |cffffffffMerathilis|r|cffff8000UI|r modules."],
			},
		},
	},
	misc = {
		order = 103,
		name = L["Misc"],
		icon = I.Media.Icons.Categories.More,
		args = {},
	},
	skins = {
		order = 104,
		name = L["Skins/AddOns"],
		icon = I.Media.Icons.Categories.Bill,
		args = {},
	},
	presets = {
		order = 104.5,
		name = L["Presets"],
		icon = I.Media.Icons.Categories.presets,
		args = {},
		-- A preset can replace the installer, so it is reachable on a fresh profile too
		alwaysShown = true,
	},
	profiles = {
		order = 105,
		name = L["Profiles"],
		icon = I.Media.Icons.Categories.System,
		args = {},
	},
	advanced = {
		order = 111,
		name = L["Advanced Settings"],
		icon = I.Media.Icons.Categories.Tips,
		args = {},
	},
	information = {
		order = 112,
		name = L["Information"],
		icon = I.Media.Icons.Categories.Save,
		args = {},
	},
}

-- Error handler
local function errorhandler(err)
	return _G.geterrorhandler()(err)
end

function module:BuildOptions()
	for index, builder in ipairs(self.builders) do
		xpcall(builder, errorhandler)
		self.builders[index] = nil
	end

	-- Registered by the builders through AddCallback
	for index, func in next, self.callOnInit do
		xpcall(func, errorhandler, self)
		self.callOnInit[index] = nil
	end
end

function module:GetFontColorGetter(profileDB, defaultDB, customKey)
	return function(info)
		local key = customKey or info[#info]
		local profileEntry = F.GetDBFromPath(profileDB)[key]
		local defaultEntry = defaultDB[key]
		return profileEntry.r,
			profileEntry.g,
			profileEntry.b,
			profileEntry.a,
			defaultEntry.r,
			defaultEntry.g,
			defaultEntry.b,
			defaultEntry.a
	end
end

function module:GetFontColorSetter(profileDB, callback, customKey)
	return function(info, r, g, b, a)
		local key = customKey or info[#info]
		local profileEntry = F.GetDBFromPath(profileDB)[key]
		if profileEntry.r ~= r or profileEntry.g ~= g or profileEntry.b ~= b or profileEntry.a ~= a then
			profileEntry.r, profileEntry.g, profileEntry.b, profileEntry.a = r, g, b, a
			if callback then
				callback()
			end
		end
	end
end

function module:GetEnabledState(check, group)
	local enabled = (check == true)
	local forceDisabled = false

	if group and group.disabled then
		if type(group.disabled) == "boolean" then
			forceDisabled = group.disabled
		elseif type(group.disabled) == "function" then
			forceDisabled = group.disabled()
		end
	end

	if (enabled and enabled == true) and not forceDisabled then
		return self.enabledState.YES
	elseif not forceDisabled then
		return self.enabledState.NO
	end

	return self.enabledState.FORCE_DISABLED
end

function module:GetEnableName(check, group)
	local enabled = self:GetEnabledState(check, group)

	if enabled == self.enabledState.YES then
		return F.String.Good(L["Enable"])
	elseif enabled == self.enabledState.NO then
		return F.String.Error(L["Disable"])
	end

	return L["Disable"]
end

function module:AddGroup(options, others)
	local orderIdx = self:GetOrder()
	local group = {
		order = orderIdx,
		type = "group",
		args = {},
	}
	E:CopyTable(group, others)
	options["fancyInlineGroup" .. orderIdx] = group
	return options["fancyInlineGroup" .. orderIdx]
end

function module:AddInlineGroup(options, others)
	local orderIdx = self:GetOrder()
	local group = {
		order = orderIdx,
		inline = true,
		type = "group",
		args = {},
	}
	E:CopyTable(group, others)
	options["fancyInlineGroup" .. orderIdx] = group
	return options["fancyInlineGroup" .. orderIdx]
end

function module:AddInlineDesc(options, othersGroup, othersDesc)
	local orderIdx = self:GetOrder()
	local inlineGroup = self:AddInlineGroup(options, othersGroup)
	local group = {
		order = orderIdx,
		type = "description",
	}
	E:CopyTable(group, othersDesc)
	inlineGroup["args"]["fancyInlineDesc" .. orderIdx] = group
	return inlineGroup
end

function module:AddInlineSoloDesc(options, othersDesc)
	local orderIdx = self:GetOrder()
	local group = {
		order = orderIdx,
		type = "description",
	}
	E:CopyTable(group, othersDesc)
	options["fancyInlineDesc" .. orderIdx] = group
	return group
end

---Red notice with the reason why a requirement isn't met, hidden while it is met.
---Pair it with `disabled = module.RequirementsDisabled(requirements)` on the same group.
---@param requirements number[] list from I.Requirements
---@param order number?
---@return table option
function module.RequirementsNotice(requirements, order)
	return {
		order = order or 0,
		type = "description",
		fontSize = "medium",
		width = "full",
		name = function()
			local check = MER:CheckRequirements(requirements)
			local reason = check ~= true and MER:GetRequirementString(check)
			return reason and F.String.Error(reason) or ""
		end,
		hidden = function()
			return MER:HasRequirements(requirements)
		end,
	}
end

---@param requirements number[] list from I.Requirements
---@return function disabled
function module.RequirementsDisabled(requirements)
	return function()
		return not MER:HasRequirements(requirements)
	end
end

---Turns a toggle into a MERToggleCard (Options/Widgets/InfoCards.lua) with its
---description as card body. Without `relWidth` the card takes the full width.
---@param option table toggle option, `type` can be left out
---@param relWidth number? share of the row, e.g. 0.5 for two cards per row
---@return table option
function module.ToggleCard(option, relWidth)
	option.type = "toggle"
	option.dialogControl = "MERToggleCard"
	option.descStyle = "inline"
	if relWidth then
		option.width = "relative"
		option.relWidth = relWidth
	else
		option.width = "full"
	end

	return option
end

---A description shown as MERTextCard (Options/Widgets/InfoCards.lua)
---@param order number
---@param text string|function card body
---@param title string? title line above the body
---@param icon string|number? texture in front of the title
---@return table option
function module.TextCard(order, text, title, icon)
	return {
		order = order,
		type = "description",
		dialogControl = "MERTextCard",
		fontSize = "medium",
		name = text,
		arg = (title or icon) and { title = title, icon = icon } or nil,
	}
end

---Credits of a module as MERTextCard
---@param order number
---@param text string
---@return table option
function module.CreditsCard(order, text)
	return module.TextCard(order, text, L["Credits"])
end

---A live preview widget (Options/Widgets/*Preview.lua) as a full width row
---@param order number
---@param dialogControl string AceGUI type of the preview
---@param key string tells the preview which settings to show
---@return table option
function module.PreviewOption(order, dialogControl, key)
	return {
		order = order,
		type = "description",
		dialogControl = dialogControl,
		name = key,
		width = "full",
	}
end

-- Open state of module cards and "Show More Options" sections, keyed by id.
-- Session only: everything starts closed again after a reload.
local expandedSections = {}

---@param id string
---@return boolean
function module.IsSectionExpanded(id)
	return expandedSections[id] == true
end

---Opens or closes a collapsible section and redraws the options
---@param id string
function module.ToggleSectionExpanded(id)
	expandedSections[id] = not expandedSections[id] or nil
	E.Libs.AceConfigRegistry:NotifyChange("ElvUI")
end

-- Keeps the option's own hidden state, adds "hidden while the section is closed"
local function HideWhileCollapsed(option, id)
	local hidden = option.hidden
	option.hidden = function(...)
		if not expandedSections[id] then
			return true
		end
		if type(hidden) == "function" then
			return hidden(...)
		end
		return hidden
	end
end

---Turns an inline group into a collapsible module card (MERModuleCard in
---Options/Widgets/Collapsible.lua): a header row with the group's name, `desc`
---and `icon`, the other args only show while the card is open. With
---`enableKey`, that toggle of the group moves into the header as its switch
---(it keeps its own get/set/disabled); without a group `desc`, the toggle's
---`desc` (or else a plain `args.desc` intro text) becomes the card description
---and a NEW marker on its name moves to the title. Paths stay the same, the args remain direct children of the group.
---Call module.LessCommon on the group's args first, so its link is hidden with
---the rest of the card.
---@param id string unique key of the card's open state
---@param group table group option, `type` and `inline` can be left out
---@param enableKey string? key of the toggle in `group.args` used as the switch
---@return table group
function module.ModuleCard(id, group, enableKey)
	local args = group.args
	local title, desc = group.name, group.desc

	-- A plain intro text of the group becomes the card description
	local intro = args.desc
	if not desc and intro and intro.type == "description" and type(intro.name) == "string" then
		desc = intro.name
		args.desc = nil
	end

	for key, option in pairs(args) do
		if key ~= enableKey then
			HideWhileCollapsed(option, id)
		end
	end

	local toggle = enableKey and args[enableKey]
	if toggle then
		desc = desc or toggle.desc
		if type(toggle.name) == "string" and toggle.name:find(F.NewFeatureMarker, 1, true) then
			title = F.NewFeatureText(title)
		end
	end

	local header = toggle or { type = "description" }
	header.order = 0
	header.dialogControl = "MERModuleCard"
	header.name = title
	header.desc = nil
	header.width = "full"
	-- A name function reaches the header through AceConfigDialog, only text goes into arg
	header.arg = {
		id = id,
		title = type(title) == "string" and title or nil,
		desc = desc,
		icon = group.icon,
		atlas = group.atlas,
	}
	args[enableKey or "cardHeader"] = header

	-- A blank name keeps AceConfigDialog on an InlineGroup (the card box), an
	-- empty one would give a SimpleGroup without a box. GroupTitle.lua treats a
	-- blank title as untitled. The real name lives on in the header.
	group.type = "group"
	group.inline = true
	group.guiInline = nil
	group.name = " "
	group.desc = nil
	group.icon = nil
	group.atlas = nil

	return group
end

---Moves rarely needed options of a group behind a "Show More Options" link
---(MERExpanderLink). The link sits after the last of them, so give them the
---highest orders in their group.
---@param args table args of the group
---@param id string unique key of the section's open state
---@param keys string[] keys in `args` to hide while the section is closed
function module.LessCommon(args, id, keys)
	local lastOrder = 0
	for _, key in ipairs(keys) do
		local option = args[key]
		HideWhileCollapsed(option, id)
		lastOrder = max(lastOrder, option.order or 0)
	end

	args[id .. "LessCommon"] = {
		order = lastOrder + 0.01,
		type = "execute",
		dialogControl = "MERExpanderLink",
		name = function()
			return expandedSections[id] and L["Show Fewer Options"] or L["Show More Options"]
		end,
		width = "full",
		arg = { id = id },
		-- The link opens and closes, it never gets locked with its group
		disabled = false,
		func = function() end,
	}
end

---Turns an execute into a MERActionCard (Options/Widgets/ActionCard.lua): icon
---on top, name as title, the description as muted text below it (it no longer
---shows as tooltip)
---@param option table execute option, `type` can be left out
---@param opts table? { icon, atlas, desc (default: option.desc), lines (reserved description lines),
--- relWidth (share of the row, default 0.25), color ("rrggbb" hover color) }
---@return table option
function module.ActionCard(option, opts)
	opts = opts or {}
	option.type = "execute"
	option.dialogControl = "MERActionCard"
	option.image = opts.icon or option.image
	option.width = "relative"
	option.relWidth = opts.relWidth or 0.25
	option.arg = {
		desc = opts.desc or option.desc,
		lines = opts.lines,
		atlas = opts.atlas,
		color = opts.color,
	}
	option.desc = nil
	return option
end

---Moves an inline group into a popup (Options/Widgets/CogPopup.lua): the page
---shows a MERCogButton row with the group's name and a short summary instead,
---a click opens the group's settings next to it. The group keeps its key, get,
---set and disabled. It hides itself on the page only: `hidden` is inherited,
---the args ask with their own key, so the popup still renders them.
---@param args table args holding the group
---@param key string key of the group
---@param summary function? returns the text shown in the button's box
---@param width number|string? AceConfig width of the button
---@return table button
function module.CogGroup(args, key, summary, width)
	local group = args[key]
	local button = {
		order = group.order,
		type = "execute",
		dialogControl = "MERCogButton",
		name = group.name,
		hidden = group.hidden,
		disabled = group.disabled,
		width = width,
		arg = { group = key, summary = summary },
		func = function() end,
	}

	group.type = "group"
	group.inline = true
	group.guiInline = nil
	group.hidden = function(info)
		return info[#info] == key
	end
	args[key .. "Cog"] = button

	return button
end

---Summary of a font settings table for module.CogGroup, e.g. "Expressway, 12, Outline"
---@param getDB function returns the table with `name`, `size` and `style`
---@return function summary
function module.FontSummary(getDB)
	return function()
		local db = getDB()
		if not db then
			return ""
		end

		local style = db.style and MER.Values.FontFlags[db.style] or db.style
		local parts = {}
		for _, part in ipairs({ db.name, db.size, style }) do
			if part and part ~= "" then
				parts[#parts + 1] = tostring(part)
			end
		end
		return table.concat(parts, ", ")
	end
end

---Moves loose options of a group into a new inline subgroup, e.g. flat font
---settings into a "Font" group that module.ApplyCogFonts then puts in a popup.
---The options keep their keys; without own get/set they inherit the outer
---group's ones through the new group, which has none.
---@param args table args holding the options
---@param groupKey string key of the new group
---@param name string name of the new group
---@param keys string[] keys of the options to move
---@return table group
function module.GroupOptions(args, groupKey, name, keys)
	local group = { type = "group", inline = true, name = name, args = {} }
	local order, disabled
	for i, key in ipairs(keys) do
		local option = args[key]
		order = order and min(order, option.order or 0) or option.order
		-- A disabled check all of them share also locks the group (and its cog button)
		if i == 1 then
			disabled = option.disabled
		elseif option.disabled ~= disabled then
			disabled = nil
		end
		group.args[key] = option
		args[key] = nil
	end
	group.order = order
	group.disabled = disabled
	args[groupKey] = group
	return group
end

local function IsFontSelect(entry)
	return entry.type == "select"
		and (entry.dialogControl == "LSM30_Font" or entry.itemControl == "MERDropdownItemFont")
end

-- Font, size and outline of a font group, read through its getters
local function FontGroupSummary(group, inheritedGet)
	local fields = {}
	for key, entry in pairs(group.args) do
		if type(entry) == "table" then
			local rank
			if IsFontSelect(entry) then
				rank = 1
			elseif entry.type == "range" and strlower(key):find("size") then
				rank = 2
			elseif
				entry.type == "select" and (entry.values == MER.Values.FontFlags or strlower(key):find("outline"))
			then
				rank = 3
			end
			if rank then
				fields[#fields + 1] = { key = key, entry = entry, rank = rank }
			end
		end
	end
	sort(fields, function(a, b)
		return a.rank < b.rank
	end)

	return function()
		local parts = {}
		for _, field in ipairs(fields) do
			local get = field.entry.get or group.get or inheritedGet
			if type(get) == "function" then
				local ok, value = pcall(get, { field.key })
				if ok and value ~= nil and value ~= "" then
					if field.rank == 3 then
						value = MER.Values.FontFlags[value] or value
					end
					parts[#parts + 1] = tostring(value)
				end
			end
		end
		return table.concat(parts, ", ")
	end
end

---Puts every inline font group (an LSM30_Font select among its args) of the
---options into a popup behind a module.CogGroup button, with font, size and
---outline as summary. Groups that already have a cog button are left alone.
---@param args table
---@param inheritedGet function? get of the enclosing groups
---@param parentInline boolean? the enclosing group is inline, AceConfigDialog shows its subgroups inline too
function module:ApplyCogFonts(args, inheritedGet, parentInline)
	local fontGroups = {}
	for key, entry in pairs(args) do
		if type(entry) == "table" and entry.type == "group" and type(entry.args) == "table" then
			local inline = parentInline or entry.inline or entry.guiInline or entry.dialogInline
			local get = type(entry.get) == "function" and entry.get or inheritedGet
			self:ApplyCogFonts(entry.args, get, inline)

			if inline and not args[key .. "Cog"] then
				for _, child in pairs(entry.args) do
					if type(child) == "table" and IsFontSelect(child) then
						fontGroups[key] = inheritedGet
						break
					end
				end
			end
		end
	end

	for key, get in pairs(fontGroups) do
		module.CogGroup(args, key, FontGroupSummary(args[key], get))
	end
end

---Shows a select with two to four short values as a MERSegmented bar
---(Options/Widgets/Segmented.lua) instead of a dropdown
---@param option table select option with static `values`
---@param order table values in the order of the bar
---@param width number|string? AceConfig width, by default half a column per value
---@return table option
function module.Segmented(option, order, width)
	option.dialogControl = "MERSegmented"
	option.sorting = order
	option.width = width or max(1, #order * 0.5)
	return option
end

local function ClassColorChip()
	local color = E:ClassColor(E.myclass, true)
	return color.r, color.g, color.b
end

local function ValueColorChip()
	return unpack(E.media.rgbvaluecolor)
end

-- Chips of the usual color modes, a site can add or replace them
local COLOR_MODE_CHIPS = {
	CLASS = ClassColorChip,
	CLASS_GRADIENT = ClassColorChip,
	VALUE = ValueColorChip,
}

---Turns a color mode select and its custom color option into one MERSegmented
---bar: a chip in front of each mode shows its color, the custom mode's chip shows
---the custom color and a click on it opens the color picker. The color option
---itself gets hidden; it needs its own get/set, both are called with an info of
---just its key.
---@param args table args holding both options
---@param selectKey string key of the select
---@param colorKey string? key of the color option, nil for a mode without own color
---@param order table values in the order of the bar
---@param opts table? { custom = value with the own color (default "CUSTOM"), chips = { [value] = color }, width = ... }
function module.ColorModeSelect(args, selectKey, colorKey, order, opts)
	opts = opts or {}
	local select, color = args[selectKey], colorKey and args[colorKey]

	local chips = {}
	for value, chip in pairs(COLOR_MODE_CHIPS) do
		chips[value] = chip
	end
	if opts.chips then
		for value, chip in pairs(opts.chips) do
			chips[value] = chip
		end
	end

	local pick
	if color and color.get and color.set then
		local info = { colorKey }
		pick = {
			value = opts.custom or "CUSTOM",
			get = function()
				return color.get(info)
			end,
			set = function(r, g, b, a)
				color.set(info, r, g, b, a)
			end,
			hasAlpha = color.hasAlpha,
		}
		color.hidden = true
	end

	module.Segmented(select, order, opts.width)
	select.arg = { chips = chips, pick = pick }
end

---Settings of the Interrupt Ready castbar indicator, shared by UnitFrames and NamePlates
---@param order number
---@param getDB function returns the settings table
---@param update function refresh after a change
---@param requirementsDisabled function disabled check of the owning module
---@param previewKey string settings key under E.db.mui ("unitframes", "nameplates") for the sample castbar
---@param extraArgs table? more options, merged into the group's args
---@return table option
function module.InterruptReadyOptions(order, getDB, update, requirementsDisabled, previewKey, extraArgs)
	-- Own disabled replaces the group's, so the children repeat the requirement
	local function Disabled()
		return requirementsDisabled() or not getDB().enable
	end

	local group = {
		order = order,
		type = "group",
		name = L["Interrupt Ready"],
		guiInline = true,
		get = function(info)
			return getDB()[info[#info]]
		end,
		set = function(info, value)
			getDB()[info[#info]] = value
			update()
		end,
		disabled = requirementsDisabled,
		args = {
			desc = {
				order = 1,
				type = "description",
				name = L["Colors the castbar of hostile units while your interrupt is on cooldown and marks the moment it is ready again. The colors are ElvUI's Non-Interruptible and Interruptible castbar colors."],
			},
			elvuiColors = {
				order = 1.6,
				type = "execute",
				name = L["ElvUI Castbar Colors"],
				desc = L["Opens ElvUI's castbar colors, where you can change them."],
				func = function()
					if previewKey == "nameplates" then
						E.Libs.AceConfigDialog:SelectGroup("ElvUI", "nameplates", "colorsGroup")
					else
						E.Libs.AceConfigDialog:SelectGroup("ElvUI", "unitframe", "allColorsGroup", "castBars")
					end
				end,
			},
			preview = {
				order = 1.5,
				type = "description",
				dialogControl = "MERInterruptReadyPreview",
				name = previewKey,
				width = "full",
			},
			enable = {
				order = 2,
				type = "toggle",
				name = L["Enable"],
			},
			tint = {
				order = 3,
				type = "toggle",
				name = L["Cooldown Color"],
				desc = L["Colors the filled part of the castbar while your interrupt is on cooldown."],
				disabled = Disabled,
			},
			window = {
				order = 4,
				type = "toggle",
				name = L["Ready Window"],
				desc = L["Colors the rest of the cast from the moment your interrupt is ready again."],
				disabled = Disabled,
			},
			tick = {
				order = 5,
				type = "toggle",
				name = L["Ready Tick"],
				desc = L["A thin line at the moment your interrupt is ready again."],
				disabled = Disabled,
			},
			tickColor = {
				order = 6,
				type = "color",
				name = L["Tick Color"],
				hasAlpha = false,
				disabled = function()
					return Disabled() or not getDB().tick
				end,
				get = function()
					local color = getDB().tickColor
					return color.r, color.g, color.b, nil, 1, 1, 1, nil
				end,
				set = function(_, r, g, b)
					local color = getDB().tickColor
					color.r, color.g, color.b = r, g, b
					update()
				end,
			},
		},
	}

	if extraArgs then
		for key, option in pairs(extraArgs) do
			if option.disabled == nil then
				option.disabled = Disabled
			end
			group.args[key] = option
		end
	end

	module.ModuleCard("interruptReady" .. previewKey, group, "enable")

	return group
end

---Settings of the shield icon on castbars of casts that can't be interrupted, shared by UnitFrames and NamePlates
---@param order number
---@param getDB function returns the settings table
---@param update function refresh after a change
---@param requirementsDisabled function disabled check of the owning module
---@param previewKey string settings key under E.db.mui ("unitframes", "nameplates") for the sample castbar
---@param extraArgs table? more options, merged into the group's args
---@return table option
function module.CastbarShieldOptions(order, getDB, update, requirementsDisabled, previewKey, extraArgs)
	-- Own disabled replaces the group's, so the children repeat the requirement
	local function Disabled()
		return requirementsDisabled() or not getDB().enable
	end

	local group = {
		order = order,
		type = "group",
		name = L["Castbar Shield"],
		guiInline = true,
		get = function(info)
			return getDB()[info[#info]]
		end,
		set = function(info, value)
			getDB()[info[#info]] = value
			update()
		end,
		disabled = requirementsDisabled,
		args = {
			desc = {
				order = 1,
				type = "description",
				name = L["Shows a shield icon on the castbar of hostile units while their cast can't be interrupted."],
			},
			preview = {
				order = 1.5,
				type = "description",
				dialogControl = "MERCastbarShieldPreview",
				name = previewKey,
				width = "full",
			},
			enable = {
				order = 2,
				type = "toggle",
				name = L["Enable"],
			},
			size = {
				order = 3,
				type = "range",
				name = L["Size"],
				min = 8,
				max = 64,
				step = 1,
				disabled = Disabled,
			},
			anchorPoint = {
				order = 4,
				type = "select",
				name = L["Anchor Point"],
				values = I.Values.positionValues,
				disabled = Disabled,
			},
			xOffset = {
				order = 5,
				type = "range",
				name = L["X-Offset"],
				min = -100,
				max = 100,
				step = 1,
				disabled = Disabled,
			},
			yOffset = {
				order = 6,
				type = "range",
				name = L["Y-Offset"],
				min = -100,
				max = 100,
				step = 1,
				disabled = Disabled,
			},
		},
	}

	if extraArgs then
		for key, option in pairs(extraArgs) do
			-- A replaced description keeps the group's disabled, like the built-in one
			if option.disabled == nil and option.type ~= "description" then
				option.disabled = Disabled
			end
			group.args[key] = option
		end
	end

	module.LessCommon(group.args, "castbarShield" .. previewKey .. "More", { "anchorPoint", "xOffset", "yOffset" })
	module.ModuleCard("castbarShield" .. previewKey, group, "enable")

	return group
end

---Settings of the Execute Line on the health bar, shared by UnitFrames and NamePlates
---@param order number
---@param getDB function returns the settings table
---@param update function refresh after a change
---@param requirementsDisabled function disabled check of the owning module
---@param previewKey string settings key under E.db.mui ("unitframes", "nameplates") for the sample health bar
---@param extraArgs table? more options, merged into the group's args
---@return table option
function module.ExecuteLineOptions(order, getDB, update, requirementsDisabled, previewKey, extraArgs)
	-- Own disabled replaces the group's, so the children repeat the requirement
	local function Disabled()
		return requirementsDisabled() or not getDB().enable
	end

	local group = {
		order = order,
		type = "group",
		name = L["Execute Line"],
		guiInline = true,
		get = function(info)
			return getDB()[info[#info]]
		end,
		set = function(info, value)
			getDB()[info[#info]] = value
			update()
		end,
		disabled = requirementsDisabled,
		args = {
			desc = {
				order = 1,
				type = "description",
				name = L["A line on the health bar at the given health percent, so you see at a glance when a unit gets into the range of your execute abilities."],
			},
			enable = {
				order = 2,
				type = "toggle",
				name = L["Enable"],
			},
			preview = module.PreviewOption(2.5, "MERExecuteLinePreview", previewKey),
			hostileOnly = {
				order = 3,
				type = "toggle",
				name = L["Hostile Units Only"],
				desc = L["Only shows the line on units you can attack."],
				disabled = Disabled,
			},
			percent = {
				order = 4,
				type = "range",
				name = L["Health Percent"],
				min = 1,
				max = 90,
				step = 1,
				disabled = Disabled,
			},
			width = {
				order = 5,
				type = "range",
				name = L["Width"],
				min = 1,
				max = 6,
				step = 1,
				disabled = Disabled,
			},
			colorMode = {
				order = 6,
				type = "select",
				name = L["Color"],
				values = {
					CLASS = L["Class Color"],
					CUSTOM = L["Custom"],
				},
				disabled = Disabled,
			},
			customColor = {
				order = 7,
				type = "color",
				name = L["Custom Color"],
				hasAlpha = false,
				disabled = function()
					return Disabled() or getDB().colorMode ~= "CUSTOM"
				end,
				get = function()
					local color = getDB().customColor
					local dr, dg, db = F.String.HexToRGB("#00c0fa")
					return color.r, color.g, color.b, nil, dr, dg, db, nil
				end,
				set = function(_, r, g, b)
					local color = getDB().customColor
					color.r, color.g, color.b = r, g, b
					update()
				end,
			},
			glow = {
				order = 9,
				type = "toggle",
				name = L["Glow"],
				desc = L["A soft glow around the line."],
				disabled = Disabled,
			},
			pulse = {
				order = 10,
				type = "toggle",
				name = L["Pulse"],
				desc = L["The glow slowly pulses."],
				disabled = function()
					return Disabled() or not getDB().glow
				end,
			},
			notches = {
				order = 11,
				type = "toggle",
				name = L["Markers"],
				desc = L["Small arrows at both ends of the line that point at the health bar."],
				disabled = Disabled,
			},
			zone = {
				order = 12,
				type = "toggle",
				name = L["Execute Range"],
				desc = L["Tints the part of the health bar below the line, fading in towards the line."],
				disabled = Disabled,
			},
			zoneAlpha = {
				order = 13,
				type = "range",
				name = L["Range Opacity"],
				min = 0.05,
				max = 0.8,
				step = 0.05,
				isPercent = true,
				disabled = function()
					return Disabled() or not getDB().zone
				end,
			},
		},
	}

	if extraArgs then
		for key, option in pairs(extraArgs) do
			if option.disabled == nil then
				option.disabled = Disabled
			end
			group.args[key] = option
		end
	end

	module.ColorModeSelect(group.args, "colorMode", "customColor", { "CLASS", "CUSTOM" })
	module.ModuleCard("executeLine" .. previewKey, group, "enable")

	return group
end

function module:AddInlineRequirementsDesc(options, othersGroup, othersDesc, requirements)
	local orderIdx = self:GetOrder()
	local inlineGroup = self:AddInlineGroup(options, othersGroup)
	local group = F.Table.Join({}, {
		order = orderIdx,
		type = "description",
	}, othersDesc)

	inlineGroup.disabled = module.RequirementsDisabled(requirements)

	-- Define if not defined
	if not group["name"] then
		group["name"] = ""
	end

	-- Convert to function
	if type(group["name"]) == "string" then
		local originalText = "" .. group["name"]

		group["name"] = function()
			local description = "" .. originalText
			local check = MER:CheckRequirements(requirements)
			if check and check ~= true then
				local reason = MER:GetRequirementString(check)
				if reason then
					description = description .. F.String.Error(reason) .. "\n\n"
				end
			end
			return description
		end
	end

	inlineGroup["args"]["fancyInlineDesc" .. orderIdx] = group
	return inlineGroup
end

function module:AddSpacer(options, big)
	local orderIdx = self:GetOrder()
	local key = "fancySpacer" .. orderIdx
	options[key] = {
		order = orderIdx,
		type = "description",
		name = big and "\n\n" or "\n",
	}
	return options[key]
end

function module:AddTinySpacer(options)
	local orderIdx = self:GetOrder()
	local key = "fancySpacer" .. orderIdx
	options[key] = {
		order = orderIdx,
		type = "description",
		name = "",
	}
	return options[key]
end

function module:GetOrder()
	self.orderIndex = self.orderIndex + 1
	return self.orderIndex
end

function module:AddCategorieIcon(text, icon)
	local iconPath = I.Media.Icons.Categories and I.Media.Icons.Categories[icon]

	if not iconPath then
		F.Developer.LogDebug("Could not find category icon", icon)
		return text
	end

	return format("|T%s:16:16|t  %s", iconPath, text)
end

-- Strips texture/color escapes so "|T...|t  Name" sorts by "Name", not by the icon path
local function GetSortName(key, entry)
	local name = type(entry.name) == "string" and entry.name or key
	name = gsub(name, "|T.-|t", "")
	name = gsub(name, "|c%x%x%x%x%x%x%x%x", "")
	name = gsub(name, "|r", "")
	return strlower(strtrim(name))
end

-- Gives every group without an explicit order an alphabetical one, starting at firstOrder
function module:SortGroupsByName(args, firstOrder)
	local keys, sortNames = {}, {}
	for key, entry in pairs(args) do
		if type(entry) == "table" and entry.type == "group" and entry.order == nil then
			tinsert(keys, key)
			sortNames[key] = GetSortName(key, entry)
		end
	end

	sort(keys, function(a, b)
		return sortNames[a] < sortNames[b]
	end)

	for index, key in ipairs(keys) do
		args[key].order = firstOrder + index - 1
	end
end

function module:AddCallback(name, func)
	-- Don't load any other settings except general and changelog when MER is not installed
	if not F.IsMERProfile() and (name ~= "Information" and name ~= "General" and name ~= "Changelog") then
		return
	end

	tinsert(self.callOnInit, func or self[name])
end

function module:OptionsCallback()
	self:BuildOptions()

	local icon = F.GetIconString(I.Media.Textures.pepeSmall, 14)
	E.Options.name = format("%s + %s %s |cFF00c0fa%s|r", E.Options.name, icon, MER.Title, MER.DisplayVersion)

	-- Main options
	E.Options.args.mui = {
		type = "group",
		name = logo .. MER.Title,
		desc = L["Plugin for |cffff7d0aElvUI|r by\nMerathilis."],
		childGroups = "tree",
		get = function(info)
			return E.db.mui.general[info[#info]]
		end,
		set = function(info, value)
			E.db.mui.general[info[#info]] = value
			E:StaticPopup_Show("PRIVATE_RL")
		end,
		args = {
			logo = {
				order = 2,
				type = "description",
				-- Logo + description with the "What's New" card next to it
				dialogControl = "MERHomeHeader",
				name = function()
					local text
					if not F.IsMERProfile() then
						text = F.NewSign
							.. L["Please run through the installation process to set up the plugin.\n\n |cffff7d0aThis step is needed to ensure that all features are configured correctly for your profile. You don't have to apply every step.|r"]
							.. F.NewSign
					else
						text = F.NewFeatureTrailingText(L["MER_DESC"])
					end

					return text
				end,
				fontSize = "large",
				image = function()
					return I.General.MediaPath .. "Textures\\mUI1.tga", 200, 200
				end,
			},
			install = {
				order = 3,
				type = "execute",
				name = L["|T" .. I.General.MediaPath .. "Icons\\Install.tga:18:18:0:0:64:64|t Install"],
				desc = L["Run the installation process."],
				customWidth = 140,
				func = function()
					E:GetModule("PluginInstaller"):Queue(MER.installTable)
					E:ToggleOptions()
				end,
			},
			statusReport = {
				order = 4,
				type = "execute",
				name = L["|T" .. I.General.MediaPath .. "Icons\\gradientList.tga:18:18:0:0:64:64|t Status Report"],
				desc = format(
					L["Open the %s Status Report window that shows necessary information for debugging. Post this when reporting bugs!"],
					MER.Title
				),
				customWidth = 140,
				func = function()
					MISC:StatusReportShow()
					E:ToggleOptions()
					MISC.StatusReportToggled = true
				end,
			},
			discordButton = {
				order = 5,
				type = "execute",
				name = L["|T" .. I.General.MediaPath .. "Icons\\Discord.tga:18:18:0:0:64:64|t |cffffffffMerathilis|r|cffff7d0aUI|r Discord"],
				customWidth = 160,
				func = function()
					E:StaticPopup_Show("MERATHILISUI_EditBox", nil, nil, MER.DiscordURL)
				end,
			},
			websiteButton = {
				order = 6,
				type = "execute",
				name = L["|T" .. I.General.MediaPath .. "Icons\\Home.tga:18:18:0:0:64:64|t Website"],
				customWidth = 140,
				func = function()
					E:StaticPopup_Show("MERATHILISUI_EditBox", nil, nil, MER.WebsiteURL)
				end,
			},
			donateButton = {
				order = 7,
				type = "execute",
				name = format("|T%s:18:18:0:0:64:64|t %s", I.Media.Icons.Favorite, F.String.Good(L["Donate"])),
				customWidth = 140,
				func = function()
					E.Libs.AceConfigDialog:SelectGroup("ElvUI", "mui", "information", "name")
				end,
			},
		},
	}

	self:SortGroupsByName(self.options.modules.args, 2)

	for category, info in pairs(self.options) do
		E.Options.args.mui.args[category] = {
			order = info.order,
			type = "group",
			childGroups = "tab",
			name = info.name,
			desc = info.desc,
			icon = info.icon,
			args = info.args,
			get = info.get,
			set = info.set,
			hidden = function() -- Only the start page is shown until the installer ran
				return not info.alwaysShown and not F.IsMERProfile()
			end,
		}
	end

	-- Before ApplyCustomWidgets, which turns the LSM30_Font selects into MERDropdowns
	self:ApplyCogFonts(E.Options.args.mui.args)
	self:ApplyCustomWidgets(E.Options.args.mui.args)

	for _, func in ipairs(self.postBuilders) do
		xpcall(func, errorhandler, self)
	end
end

-- Redirects MER's own toggle/range/select/input/color/execute/header args to custom
-- one AceGUI widgets (MERToggleSwitch / MERSlider / MERDropdown / MEREditBox /
-- MERColorPicker / MERButton / MERSectionHeader) without touching ElvUI's shared
-- global AceGUI skin, so only the MerathilisUI options tab is affected.
function module:ApplyCustomWidgets(argsTable)
	for _, entry in pairs(argsTable) do
		if type(entry) == "table" then
			if entry.type == "toggle" and not entry.dialogControl and not entry.control then
				entry.dialogControl = "MERToggleSwitch"
			elseif entry.type == "range" and not entry.dialogControl and not entry.control then
				entry.dialogControl = "MERSlider"
			elseif
				entry.type == "select"
				and entry.style ~= "radio"
				and not entry.dialogControl
				and not entry.control
			then
				entry.dialogControl = "MERDropdown"
			elseif entry.type == "input" and not entry.multiline and not entry.dialogControl and not entry.control then
				entry.dialogControl = "MEREditBox"
			elseif entry.type == "color" and not entry.dialogControl and not entry.control then
				entry.dialogControl = "MERColorPicker"
			elseif entry.type == "execute" and not entry.image and not entry.dialogControl and not entry.control then
				-- Options with an "image" get AceConfigDialog's icon-button treatment
				-- (dialogControl "Icon", not "Button") - leave those on the stock
				-- widget instead of redirecting them into a plain text button.
				entry.dialogControl = "MERButton"
			elseif entry.type == "select" and entry.dialogControl == "LSM30_Font" then
				-- LSM30_Font's "values" maps font name -> file path (that's what
				-- LSM:HashTable("font") returns), which the stock widget ignores
				-- in favor of the font-name keys themselves. A plain select would
				-- show those paths as the option text, so remap to name -> name
				-- before handing it to MERDropdown, and use the font-preview item
				-- type so the list still renders each entry in its own font.
				if type(entry.values) == "table" then
					local names = {}
					for name in pairs(entry.values) do
						names[name] = name
					end
					entry.values = names
				end
				entry.itemControl = entry.itemControl or "MERDropdownItemFont"
				entry.dialogControl = "MERDropdown"
			elseif entry.type == "header" and not entry.dialogControl and not entry.control then
				entry.dialogControl = "MERSectionHeader"
			end

			if type(entry.args) == "table" then
				self:ApplyCustomWidgets(entry.args)
			end
		end
	end
end

-- ElvUI opens its options at a fixed 1024x768 until the window is moved or
-- resized by hand (that size is saved in E.global). As long as nothing is
-- saved, the default follows the screen instead. All in UI units, so a larger
-- UI scale gets a proportionally smaller window. ElvUI's own 800x600 minimum
-- and the screen minus 50 stay the bounds.
local OPTIONS_WIDTH_RATIO, OPTIONS_HEIGHT_RATIO = 0.6, 0.75
local OPTIONS_MAX_WIDTH, OPTIONS_MAX_HEIGHT = 1600, 1100

function module:ScaleConfigDefaultSize()
	local stockGetDefaultSize = E.Config_GetDefaultSize
	local defaults = E.DF.global.general.AceGUI
	if not stockGetDefaultSize or not defaults then
		return
	end

	function E:Config_GetDefaultSize()
		local width, height = self:Config_GetSize()
		if width ~= defaults.width or height ~= defaults.height then
			return stockGetDefaultSize(self)
		end

		local maxWidth, maxHeight = E.UIParent:GetSize()
		width = min(max(maxWidth * OPTIONS_WIDTH_RATIO, defaults.width), OPTIONS_MAX_WIDTH)
		height = min(max(maxHeight * OPTIONS_HEIGHT_RATIO, defaults.height), OPTIONS_MAX_HEIGHT)
		return floor(min(maxWidth - 50, width)), floor(min(maxHeight - 50, height))
	end
end

function module:Initialize()
	if self.Initialized then
		return
	end

	self:ScaleConfigDefaultSize()

	-- The options themselves are built by OptionsCallback, see BuildOptions
	self.Initialized = true
end

MER:RegisterModule(module:GetName())
