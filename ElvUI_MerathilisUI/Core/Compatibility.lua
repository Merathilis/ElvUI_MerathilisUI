local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local S = E:GetModule("Skins")
local WS = W:GetModule("Skins")

-- Compatibility check: finds features that MerathilisUI and another ElvUI plugin
-- both have turned on and lets the user pick per feature which one stays on.
-- Each conflict is a row of two MERToggleCards (Options/Widgets/InfoCards.lua),
-- MerathilisUI on the left, the plugin on the right. Nothing is written before
-- Apply; a row left on on both sides counts as "keep both" and isn't asked again.
--
-- This file loads before Media/, so every I.Media lookup happens at runtime.

local _G = _G
local format, ipairs, max, min, strsplit, strupper, type, unpack =
	format, ipairs, max, min, strsplit, strupper, type, unpack
local tinsert, wipe = table.insert, table.wipe

local CreateFrame = CreateFrame
local PlaySound = PlaySound
local GetAddOnMetadata = C_AddOns.GetAddOnMetadata
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local C_UI_Reload = C_UI.Reload
local APPLY = APPLY

local FRAME_WIDTH = 640
local INSET = 24
local HEADER_HEIGHT = 150
local FOOTER_HEIGHT = 56
local MAX_BODY_HEIGHT = 360
local SCROLLBAR_WIDTH = 20
local GROUP_HEIGHT = 26
local GROUP_GAP = 8

local COLOR_ACCENT = { I.Colors.Accent.r, I.Colors.Accent.g, I.Colors.Accent.b }
local COLOR_CARD_HOVER = { I.Colors.Accent.r * 0.15, I.Colors.Accent.g * 0.15, I.Colors.Accent.b * 0.15, 0.9 }
local COLOR_BUTTON = { 0.16, 0.16, 0.16, 1 }
local COLOR_BORDER = { 1, 1, 1, 0.08 }
local COLOR_MUTED = { 0.62, 0.62, 0.62 }

local SOUND_CLICK = 852 -- SOUNDKIT.IG_MAINMENU_OPTION

--[[----------------------------------
--	Shared features
--]]
----------------------------------
-- A conflict is reported when the plugin is loaded, `active` (if given) agrees and
-- both sides are on. `mine` / `theirs` are one path or a list: any path that is
-- true counts as on, turning a side off sets all of its paths to false. Paths start
-- at `E` (db.* / private.*), or at `root()` for plugins with their own SavedVariables.
-- `retail` marks MerathilisUI features that are off on WoW Forever anyway.
local ARMORY = "db.mui.armory.enable"
local ADDON_BUTTONS = "db.mui.minimapButtons.addonButtons.enable"
local DAMAGE_METER = "private.mui.skins.blizzard.damageMeter.enable"
local FOCUS_HIGHLIGHT = "db.mui.nameplates.focusHighlight.enable"
local GRADIENT = "db.mui.themes.gradientMode.enable"
local VEHICLE_BAR = "db.mui.vehicleBar.enable"

local plugins = {
	{
		addon = "ElvUI_WindTools",
		name = "WindTools",
		checks = {
			{
				feature = L["Addon Buttons"],
				theirFeature = L["Minimap Buttons"],
				mine = ADDON_BUTTONS,
				theirs = "private.WT.maps.minimapButtons.enable",
			},
		},
	},
	{
		addon = "ElvUI_SLE",
		name = "Shadow & Light",
		checks = {
			{
				feature = L["Armory"],
				theirFeature = L["Armory"],
				mine = ARMORY,
				theirs = { "db.sle.armory.character.enable", "private.sle.armory.stats.enable" },
				retail = true,
			},
			{
				feature = L["Equipment Manager"],
				theirFeature = L["Equipment Manager"],
				mine = "db.mui.bags.equipmentManager.enable",
				theirs = "db.sle.bags.equipmentmanager.enable",
			},
			{
				feature = L["VehicleBar"],
				theirFeature = L["VehicleBar"],
				mine = VEHICLE_BAR,
				theirs = "db.sle.actionbar.vehicle.enable",
			},
			{
				feature = L["Location Panel"],
				theirFeature = L["Location Panel"],
				mine = "db.mui.locationPanel.enable",
				theirs = "db.sle.minimap.locPanel.enable",
			},
			{
				feature = L["AFK"],
				theirFeature = L["AFK Mode"],
				mine = "db.mui.general.AFK",
				theirs = "db.sle.afk.enable",
			},
		},
	},
	{
		addon = "ElvUI_BenikUI",
		name = "BenikUI",
		checks = {
			{
				feature = L["Style"],
				theirFeature = L["Style"],
				mine = "db.mui.style.enable",
				theirs = "db.benikui.general.benikuiStyle",
			},
			{
				feature = L["SplashScreen"],
				theirFeature = L["SplashScreen"],
				mine = "db.mui.general.splashScreen",
				theirs = "db.benikui.general.splashScreen",
			},
			{
				feature = L["Armory"],
				theirFeature = L["Item Level"],
				mine = ARMORY,
				theirs = "db.benikui.misc.ilevel.enable",
				retail = true,
			},
		},
	},
	{
		addon = "ElvUI_ToxiUI",
		name = "ToxiUI",
		-- Almost every ToxiUI feature needs a ToxiUI profile (F.IsTXUIProfile in ToxiUI)
		active = function()
			local changelog = E.db.TXUI and E.db.TXUI.changelog
			return changelog and changelog.releaseVersion and changelog.releaseVersion ~= 0
		end,
		checks = {
			{
				feature = L["Gradient"],
				theirFeature = L["Gradient"],
				mine = GRADIENT,
				theirs = "db.TXUI.themes.gradientMode.enabled",
			},
			{
				feature = L["Color Modifier Keys"],
				theirFeature = L["Color Modifier Keys"],
				mine = "db.mui.colorModifiers.enable",
				theirs = "db.TXUI.addons.colorModifiers.enabled",
			},
			{
				feature = L["AFK"],
				theirFeature = L["AFK Mode"],
				mine = "db.mui.general.AFK",
				theirs = "db.TXUI.addons.afkMode.enabled",
			},
			{
				feature = L["Game Menu"],
				theirFeature = L["Game Menu"],
				mine = "db.mui.gameMenu.enable",
				theirs = "db.TXUI.addons.gameMenuSkin.enabled",
			},
			{
				feature = L["Blizzard DamageMeter"],
				theirFeature = L["Blizzard DamageMeter"],
				mine = DAMAGE_METER,
				theirs = "db.TXUI.addons.damageMeter.enabled",
			},
			{
				feature = L["Scale"],
				theirFeature = L["Scale"],
				mine = "db.mui.scale.enable",
				theirs = "db.TXUI.misc.scaling.enabled",
			},
			{
				feature = L["Raid Info Frame"],
				theirFeature = L["Raid Info Frame"],
				mine = "db.mui.misc.raidInfo.enable",
				theirs = "db.TXUI.misc.raidInfo.enabled",
			},
			{
				feature = L["VehicleBar"],
				theirFeature = L["VehicleBar"],
				mine = VEHICLE_BAR,
				theirs = "db.TXUI.vehicleBar.enabled",
			},
			{
				feature = L["Armory"],
				theirFeature = L["Armory"],
				mine = ARMORY,
				theirs = "db.TXUI.armory.enabled",
				retail = true,
			},
		},
	},
	{
		addon = "ElvUI_EltreumUI",
		name = "Eltruism",
		checks = {
			{
				feature = L["Armory"],
				theirFeature = L["Character Frame"],
				mine = ARMORY,
				theirs = {
					"db.ElvUI_EltreumUI.skins.classicarmory",
					"db.ElvUI_EltreumUI.skins.expandarmorybg",
					"db.ElvUI_EltreumUI.skins.characterskingradients",
					"db.ElvUI_EltreumUI.skins.statcolors",
					"db.ElvUI_EltreumUI.skins.classiconsoncharacterpanel",
				},
				retail = true,
			},
			{
				feature = L["Gradient"],
				theirFeature = L["Gradient"],
				mine = GRADIENT,
				theirs = "db.ElvUI_EltreumUI.unitframes.gradientmode.enable",
			},
			{
				feature = L["Color Modifier Keys"],
				theirFeature = L["Color Modifier Keys"],
				mine = "db.mui.colorModifiers.enable",
				theirs = "db.ElvUI_EltreumUI.skins.colormodkey",
			},
			{
				feature = L["Cursor"],
				theirFeature = L["Cursor"],
				mine = "db.mui.cursor.enable",
				theirs = "db.ElvUI_EltreumUI.cursors.cursor.enable",
			},
			{
				feature = L["Battle Res"],
				theirFeature = L["Battle Res"],
				mine = "db.mui.tracker.battleRes.enable",
				theirs = "db.ElvUI_EltreumUI.otherstuff.bres",
			},
			{
				feature = L["Blizzard DamageMeter"],
				theirFeature = L["Blizzard DamageMeter"],
				mine = DAMAGE_METER,
				theirs = "db.ElvUI_EltreumUI.skins.blizzdamagemeter.enable",
			},
			{
				feature = L["Details"],
				theirFeature = L["Details"],
				mine = "private.mui.skins.addonSkins.dt.enable",
				theirs = "db.ElvUI_EltreumUI.skins.details",
			},
			{
				feature = L["Details Embed"],
				theirFeature = L["Details Embed"],
				mine = "private.mui.skins.embed.enable",
				theirs = "db.ElvUI_EltreumUI.skins.detailsembed",
			},
			{
				feature = "BugSack",
				theirFeature = "BugSack",
				mine = "private.mui.skins.addonSkins.bugSack",
				theirs = "db.ElvUI_EltreumUI.skins.bugsack",
			},
			{
				feature = L["Clique"],
				theirFeature = L["Clique"],
				mine = "private.mui.skins.addonSkins.cl",
				theirs = "db.ElvUI_EltreumUI.skins.clique",
			},
		},
	},
	{
		addon = "ElvUI_mMediaTag",
		name = "mMediaTag & Tools",
		checks = {
			{
				feature = L["Focus Highlight"],
				theirFeature = L["Focus Highlight"],
				mine = FOCUS_HIGHLIGHT,
				theirs = "db.mMediaTag.nameplates.focus.enable",
			},
			{
				feature = L["Execute Line"],
				theirFeature = L["Execute Line"],
				mine = "db.mui.nameplates.executeLine.enable",
				theirs = "db.mMediaTag.nameplates.execute.enable",
			},
			{
				feature = L["Raid Marker Color"],
				theirFeature = L["Raid Marker Color"],
				mine = "db.mui.nameplates.markerColor.enable",
				theirs = "db.mMediaTag.nameplates.raid_marker_color.enable",
			},
			{
				feature = L["Interrupt Ready"],
				theirFeature = L["Interrupt on Cooldown"],
				mine = { "db.mui.nameplates.interruptReady.enable", "db.mui.unitframes.interruptReady.enable" },
				theirs = "db.mMediaTag.interrupt_on_cd.enable",
			},
		},
	},
	{
		addon = "LuckyoneUI",
		name = "LuckyoneUI",
		-- LuckyoneUI keeps its own SavedVariables, filled with its defaults on load
		root = function()
			local sv = _G.LuckyoneDB
			return sv and sv.profiles and sv.profiles[sv.profileKeys and sv.profileKeys[E.mynameRealm] or "Default"]
		end,
		checks = {
			{
				feature = L["Addon Buttons"],
				theirFeature = L["Minimap Buttons"],
				mine = ADDON_BUTTONS,
				theirs = "map.minimap.buttons.enable",
			},
			{
				feature = L["Focus Highlight"],
				theirFeature = L["Focus Highlight"],
				mine = FOCUS_HIGHLIGHT,
				theirs = "nameplates.focusTextureEnable",
			},
			{
				feature = "BugSack",
				theirFeature = "BugSack",
				mine = "private.mui.skins.addonSkins.bugSack",
				theirs = "skins.BugSack",
			},
		},
	},
	{
		addon = "ProjectAzilroka",
		name = "ProjectAzilroka",
		root = function()
			return _G.SquareMinimapButtons
		end,
		checks = {
			{
				feature = L["Addon Buttons"],
				theirFeature = "Square Minimap Buttons",
				mine = ADDON_BUTTONS,
				theirs = "db.Enable",
			},
		},
	},
}

-- Lists everywhere, and a stable key per check for the "keep both" memory
for _, plugin in ipairs(plugins) do
	for _, check in ipairs(plugin.checks) do
		if type(check.mine) == "string" then
			check.mine = { check.mine }
		end
		if type(check.theirs) == "string" then
			check.theirs = { check.theirs }
		end
		check.key = format("%s:%s:%s", plugin.addon, check.mine[1], check.theirs[1])
	end
end

--[[----------------------------------
--	Database access
--]]
----------------------------------
local function GetParent(root, path)
	local keys = { strsplit(".", path) }
	local tbl = root
	for i = 1, #keys - 1 do
		if type(tbl) ~= "table" then
			return
		end
		tbl = tbl[keys[i]]
	end

	if type(tbl) == "table" then
		return tbl, keys[#keys]
	end
end

local function IsOn(root, paths)
	for _, path in ipairs(paths) do
		local tbl, key = GetParent(root, path)
		if tbl and tbl[key] == true then
			return true
		end
	end

	return false
end

local function TurnOff(root, paths)
	for _, path in ipairs(paths) do
		local tbl, key = GetParent(root, path)
		if tbl and tbl[key] == true then
			tbl[key] = false
		end
	end
end

---@param includeKept boolean? also list the conflicts the user chose to keep
---@return table[] conflicts { plugin, check, root }
local function CollectConflicts(includeKept)
	local kept = E.global.mui.core.compatibilityKept
	local conflicts = {}

	for _, plugin in ipairs(plugins) do
		if IsAddOnLoaded(plugin.addon) and (not plugin.active or plugin.active()) then
			local root = plugin.root and plugin.root() or E
			if type(root) == "table" then
				for _, check in ipairs(plugin.checks) do
					if
						not (check.retail and E.Forever)
						and (includeKept or not kept[check.key])
						and IsOn(E, check.mine)
						and IsOn(root, check.theirs)
					then
						tinsert(conflicts, { plugin = plugin, check = check, root = root })
					end
				end
			end
		end
	end

	return conflicts
end

--[[----------------------------------
--	Widgets
--]]
----------------------------------
local function CreateText(parent, size, color, justify)
	local text = parent:CreateFontString(nil, "OVERLAY")
	text:FontTemplate(nil, size)
	text:SetJustifyH(justify or "CENTER")
	if color then
		text:SetTextColor(unpack(color))
	end
	return text
end

-- Same flat buttons as the installer, the primary one filled with the accent color
local function Button_UpdateVisual(button)
	if button.primary then
		local mult = button.hover and 1 or 0.75
		button:SetBackdropColor(COLOR_ACCENT[1] * mult, COLOR_ACCENT[2] * mult, COLOR_ACCENT[3] * mult, 1)
		button:SetBackdropBorderColor(COLOR_ACCENT[1], COLOR_ACCENT[2], COLOR_ACCENT[3], 1)
	elseif button.hover then
		button:SetBackdropColor(unpack(COLOR_CARD_HOVER))
		button:SetBackdropBorderColor(COLOR_ACCENT[1], COLOR_ACCENT[2], COLOR_ACCENT[3], 1)
	else
		button:SetBackdropColor(unpack(COLOR_BUTTON))
		button:SetBackdropBorderColor(unpack(COLOR_BORDER))
	end
end

local function Button_OnEnter(button)
	button.hover = true
	Button_UpdateVisual(button)
end

local function Button_OnLeave(button)
	button.hover = nil
	Button_UpdateVisual(button)
end

local function Button_OnClick(button)
	PlaySound(SOUND_CLICK)
	button.onClick(button)
end

local function CreateButton(parent, text, width, primary, onClick)
	-- Our own backdrop instead of SetTemplate: ElvUI's template sweep would reset the hover colors
	local button = CreateFrame("Button", nil, parent, "BackdropTemplate")
	button:SetBackdrop({ bgFile = E.media.blankTex, edgeFile = E.media.blankTex, edgeSize = E.mult })
	button:SetSize(width, 30)
	button.primary = primary
	button.onClick = onClick
	button:SetScript("OnEnter", Button_OnEnter)
	button:SetScript("OnLeave", Button_OnLeave)
	button:SetScript("OnClick", Button_OnClick)

	button.text = CreateText(button, 13)
	button.text:SetPoint("CENTER")
	button.text:SetText(text)

	Button_UpdateVisual(button)
	return button
end

local function GetAddOnIcon(addon)
	return GetAddOnMetadata(addon, "IconTexture") or I.Media.Icons.Categories.More
end

--[[----------------------------------
--	Frame
--]]
----------------------------------
local frame
local rows = {} -- { conflict, mine = widget, theirs = widget }
local groups = {} -- plugin headers, reused between checks

local function ReleaseRows()
	local AceGUI = E.Libs.AceGUI
	for _, row in ipairs(rows) do
		AceGUI:Release(row.mine)
		AceGUI:Release(row.theirs)
	end
	wipe(rows)

	for _, group in ipairs(groups) do
		group:Hide()
	end
end

local function Apply()
	local kept = E.global.mui.core.compatibilityKept
	local changed = false

	for _, row in ipairs(rows) do
		local conflict = row.conflict
		local check = conflict.check
		local keepMine, keepTheirs = row.mine:GetValue(), row.theirs:GetValue()

		if not keepMine then
			TurnOff(E, check.mine)
			changed = true
		end

		if not keepTheirs then
			TurnOff(conflict.root, check.theirs)
			changed = true
		end

		kept[check.key] = (keepMine and keepTheirs) or nil
	end

	frame:Hide()

	-- Both sides only read their settings when they load
	if changed then
		C_UI_Reload()
	end
end

local function CreateGroupHeader(index)
	local group = groups[index]
	if group then
		return group
	end

	group = CreateFrame("Frame", nil, frame.content)
	group:SetHeight(GROUP_HEIGHT)

	group.icon = group:CreateTexture(nil, "ARTWORK")
	group.icon:SetSize(16, 16)
	group.icon:SetPoint("LEFT", 1, 0)

	group.name = CreateText(group, 13, nil, "LEFT")
	group.name:SetPoint("LEFT", group.icon, "RIGHT", 6, 0)

	group.count = CreateText(group, 11, COLOR_MUTED, "LEFT")
	group.count:SetPoint("LEFT", group.name, "RIGHT", 6, 0)

	groups[index] = group
	return group
end

-- The same toggle cards as on the options pages, the switch shows if the feature stays on
local function CreateCard(parent, title, desc, icon)
	local card = E.Libs.AceGUI:Create("MERToggleCard")
	card.frame:SetParent(parent)
	card:SetLabel(title)
	card:SetDescription(desc)
	card:SetImage(icon)
	card:SetCustomData({ lines = 1 })
	card:SetValue(true)
	card.frame:Show()
	return card
end

-- Places the group headers and card rows at the given content width, returns the height
local function Layout(width)
	local content = frame.content
	local cardWidth = width / 2
	local y = 0

	content:SetWidth(width)
	for i, row in ipairs(rows) do
		if row.group then
			if i > 1 then
				y = y + GROUP_GAP
			end

			row.group:ClearAllPoints()
			row.group:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)
			row.group:SetPoint("RIGHT", content, "RIGHT")
			y = y + GROUP_HEIGHT
		end

		row.mine:SetWidth(cardWidth)
		row.mine.frame:ClearAllPoints()
		row.mine.frame:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)

		row.theirs:SetWidth(cardWidth)
		row.theirs.frame:ClearAllPoints()
		row.theirs.frame:SetPoint("TOPLEFT", content, "TOPLEFT", cardWidth, -y)

		y = y + max(row.mine.frame.height or 0, row.theirs.frame.height or 0)
	end

	content:SetHeight(max(y, 1))
	return y
end

local function Populate(conflicts)
	ReleaseRows()

	local content = frame.content
	local mineIcon = I.Media.Icons.Brands.MerathilisUI
	local groupIndex = 0
	local lastPlugin

	-- Number of conflicts per plugin, for the group headers
	local counts = {}
	for _, conflict in ipairs(conflicts) do
		counts[conflict.plugin] = (counts[conflict.plugin] or 0) + 1
	end

	for _, conflict in ipairs(conflicts) do
		local plugin, check = conflict.plugin, conflict.check
		local row = { conflict = conflict }

		if plugin ~= lastPlugin then
			groupIndex = groupIndex + 1
			local group = CreateGroupHeader(groupIndex)
			group.icon:SetTexture(GetAddOnIcon(plugin.addon))
			group.name:SetText(plugin.name)
			group.count:SetText(format(L["%d shared |4feature:features;"], counts[plugin]))
			group:Show()

			row.group = group
			lastPlugin = plugin
		end

		row.mine = CreateCard(content, check.feature, MER.Title, mineIcon)
		row.theirs = CreateCard(content, check.theirFeature, plugin.name, GetAddOnIcon(plugin.addon))
		tinsert(rows, row)
	end

	-- The scroll bar only takes room when the list doesn't fit
	local width = FRAME_WIDTH - INSET * 2
	local height = Layout(width)
	local overflow = height > MAX_BODY_HEIGHT
	if overflow then
		height = Layout(width - SCROLLBAR_WIDTH)
	end

	local scroll = frame.scroll
	local bodyHeight = min(height, MAX_BODY_HEIGHT)
	scroll:ClearAllPoints()
	scroll:SetPoint("TOPLEFT", INSET, -HEADER_HEIGHT)
	scroll:SetPoint("RIGHT", frame, "RIGHT", -INSET - (overflow and SCROLLBAR_WIDTH or 0), 0)
	scroll:SetHeight(bodyHeight)
	scroll:SetVerticalScroll(0)
	scroll.ScrollBar:SetShown(overflow)

	frame:SetHeight(HEADER_HEIGHT + bodyHeight + FOOTER_HEIGHT)
end

local function CreateMainFrame()
	frame = CreateFrame("Frame", "MER_CompatibilityFrame", E.UIParent)
	frame:SetWidth(FRAME_WIDTH)
	frame:SetPoint("CENTER")
	frame:SetFrameStrata("FULLSCREEN_DIALOG") -- above the ElvUI options, "Check Now" opens it from there
	frame:SetToplevel(true)
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:SetClampedToScreen(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", frame.StartMoving)
	frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
	frame:SetTemplate("Transparent")
	WS:CreateShadow(frame)
	frame:SetScript("OnHide", ReleaseRows)
	frame:Hide()

	frame.close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
	frame.close:SetPoint("TOPRIGHT", 2, 2)
	frame.close:SetScript("OnClick", function()
		frame:Hide()
	end)
	S:HandleCloseButton(frame.close)

	-- Header: logo, eyebrow, title and description, centered like the installer
	frame.logo = frame:CreateTexture(nil, "ARTWORK")
	frame.logo:SetSize(36, 36)
	frame.logo:SetPoint("TOP", 0, -16)
	frame.logo:SetTexture(I.Media.Icons.Brands.MerathilisUI)

	frame.eyebrow = CreateText(frame, 11, COLOR_ACCENT)
	frame.eyebrow:SetPoint("TOP", frame.logo, "BOTTOM", 0, -8)
	frame.eyebrow:SetText(strupper(L["Compatibility Check"]))

	frame.title = CreateText(frame, 20)
	frame.title:SetPoint("TOP", frame.eyebrow, "BOTTOM", 0, -6)
	frame.title:SetText(L["Shared Features Found"])

	frame.desc = CreateText(frame, 12, COLOR_MUTED)
	frame.desc:SetPoint("TOP", frame.title, "BOTTOM", 0, -8)
	frame.desc:SetWidth(FRAME_WIDTH - INSET * 4)
	frame.desc:SetWordWrap(true)
	frame.desc:SetText(
		format(
			L["Some of your ElvUI plugins offer the same features as %s. Running both can cause errors or a doubled look, so turn off the one you don't want to use."],
			MER.Title
		)
	)

	-- Body: the conflict rows in a scroll frame
	local scroll = CreateFrame("ScrollFrame", "MER_CompatibilityScrollFrame", frame, "UIPanelScrollFrameTemplate")
	S:HandleScrollBar(scroll.ScrollBar)

	local content = CreateFrame("Frame", nil, scroll)
	content:SetSize(1, 1)
	scroll:SetScrollChild(content)

	frame.scroll = scroll
	frame.content = content

	-- Footer: hint on the left, Later and Apply on the right
	frame.apply = CreateButton(frame, APPLY, 120, true, Apply)
	frame.apply:SetPoint("BOTTOMRIGHT", -INSET, 14)

	frame.later = CreateButton(frame, L["Later"], 100, false, function()
		frame:Hide()
	end)
	frame.later:SetPoint("RIGHT", frame.apply, "LEFT", -8, 0)

	frame.hint = CreateText(frame, 11, COLOR_MUTED, "LEFT")
	frame.hint:SetPoint("LEFT", frame, "BOTTOMLEFT", INSET, 29)
	frame.hint:SetPoint("RIGHT", frame.later, "LEFT", -12, 0)
	frame.hint:SetWordWrap(true)
	frame.hint:SetText(
		L["Features left on for both won't be asked about again. Apply reloads the UI when something was turned off."]
	)
end

--[[----------------------------------
--	Entry points
--]]
----------------------------------
---Shows the compatibility check when features overlap
---@param manual boolean? started by the user: also lists kept conflicts and reports when there are none
function MER:CheckCompatibility(manual)
	local conflicts = CollectConflicts(manual)
	if #conflicts == 0 then
		if manual then
			F.Print(L["No shared features with your other ElvUI plugins found."])
		end
		return
	end

	if not frame then
		CreateMainFrame()
	end

	frame:Show()
	Populate(conflicts)
end

-- Once per login, after the installer and out of combat
F.Event.RegisterOnceCallback("MER.InitializedSafe", function()
	if not E.global.mui.core.compatibilityCheck or E.db.mui.core.installed == nil then
		return
	end

	E:Delay(8, function()
		local installer = _G.PluginInstallFrame
		if installer and installer:IsShown() then
			return
		end

		MER:CheckCompatibility()
	end)
end)
