local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

-- AceGUIContainer-InlineGroup's title FontString uses "GameFontNormal" (WoW's
-- classic yellow-gold UI color) unconditionally - there's no dialogControl
-- override point for containers, same problem MERTabGroup's tab buttons have
-- (see TabGroupSkin.lua's big comment for the full reasoning: "InlineGroup"
-- is a widget type on the *shared* AceGUI-3.0 instance, so this reaches in
-- *after* AceConfigDialog builds it instead of registering a replacement type).
--
-- Some MerathilisUI options also pass a group's name through F.cOption(...)
-- for manual coloring, which is embedded as |c...|r escape codes that would
-- otherwise override SetTextColor entirely (same issue MERSectionHeader had
-- with F.cOption(..., "gradient") headers) - stripped the same way.
--
-- InlineGroup widgets are pooled/reused by AceGUI just like TabGroup's tab
-- buttons, so this can't just recolor once and leave it: every FeedGroup call
-- actively applies white on MerathilisUI's own pages (path[1] == "mui") and
-- explicitly restores whatever color the title had otherwise.
--
-- Beyond the title color, our pages also get a clearer section look so inline
-- groups don't blend into the option rows around them: a larger title font, a
-- short accent bar in front of the title, a slightly lighter box and a small
-- shadow behind it. Everything is undone again on non-MerathilisUI pages.
local ACD = LibStub("AceConfigDialog-3.0-ElvUI", true)
if not ACD or not ACD.FeedGroup then
	return
end

local pairs, unpack = pairs, unpack
local hooksecurefunc = hooksecurefunc
local GameFontNormal = GameFontNormal

local COLOR_TITLE = { 1, 1, 1 }
local TITLE_FONT_SIZE = 14
local TITLE_OFFSET = 12 -- stock title sits at x = 14, the accent bar takes its place
local BAR_WIDTH, BAR_HEIGHT = 3, 14
local COLOR_BACKDROP = { 0.12, 0.12, 0.12, 0.45 }
local SHADOW_SIZE = 3

local function Group_OnSetTitle(group, title)
	if not group.merActive then
		return
	end
	title = title or ""
	title = title:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
	group.titletext:SetText(title)

	-- No bar for untitled groups, it would float above an empty title row.
	if group.merAccentBar then
		group.merAccentBar:SetShown(title ~= "")
	end
end

-- Replaces ElvUI's S.Ace3_BackdropColor on the box while the group is ours.
-- ElvUI's async E.frames sweep calls callbackBackdropColor on every media
-- update, so routing it through here keeps our color instead of having it
-- wiped (a plain SetBackdropColor would not survive that sweep).
local function Border_BackdropColor(border)
	local group = border.merGroup
	if group and group.merActive then
		border:SetBackdropColor(unpack(COLOR_BACKDROP))
	elseif border.merOriginalBackdropCallback then
		border.merOriginalBackdropCallback(border)
	end
end

local function ApplyBorderLook(group)
	local border = group.merBorder
	-- Only when ElvUI's Ace3 skin templated the box; with the skin disabled
	-- it still carries AceGUI's stock tooltip backdrop, leave that alone.
	if not border or not border.template then
		return
	end

	Border_BackdropColor(border)

	-- Created lazily on first use and only toggled afterwards, since the box
	-- is pooled. Follows WindTools' global shadow setting like every other
	-- CreateShadow call, so this stays nil while shadows are turned off.
	if not border.shadow then
		W:GetModule("Skins"):CreateShadow(border, SHADOW_SIZE)
	end
	if border.shadow then
		border.shadow:Show()
	end
end

local function RestoreBorderLook(group)
	local border = group.merBorder
	if not border or not border.template then
		return
	end

	Border_BackdropColor(border)
	if border.shadow then
		border.shadow:Hide()
	end
end

-- One-time setup, run at most once per InlineGroup widget object regardless
-- of how many different args groups it ends up serving over its pooled
-- lifetime. Doesn't turn our look on or off by itself.
local function PrepareGroup(group)
	if group.merPrepared or not group.titletext then
		return
	end
	group.merPrepared = true

	group.merOriginalColor = { group.titletext:GetTextColor() }

	local bar = group.frame:CreateTexture(nil, "OVERLAY")
	bar:SetSize(BAR_WIDTH, BAR_HEIGHT)
	bar:SetPoint("RIGHT", group.titletext, "LEFT", -5, 0)
	bar:SetColorTexture(I.Colors.Accent.r, I.Colors.Accent.g, I.Colors.Accent.b, 1)
	bar:Hide()
	group.merAccentBar = bar

	local border = group.content and group.content:GetParent()
	if border and border.SetBackdropColor then
		border.merGroup = group
		border.merOriginalBackdropCallback = border.callbackBackdropColor
		border.callbackBackdropColor = Border_BackdropColor
		group.merBorder = border
	end

	-- Additive (hooksecurefunc), never replaces the stock SetTitle - it's
	-- still needed for the actual text/layout. Checks group.merActive itself,
	-- so it's a harmless no-op whenever this group isn't currently one of ours.
	hooksecurefunc(group, "SetTitle", Group_OnSetTitle)
end

local function ApplyMerLook(group)
	PrepareGroup(group)
	if not group.titletext then
		return
	end
	group.merActive = true

	-- Re-applied on every FeedGroup call, not just the first time this group
	-- goes active - AceGUI recycles InlineGroup widgets and can reset
	-- titletext's color on reacquire, so merActive alone doesn't guarantee
	-- the color set below is still in effect.
	local titletext = group.titletext
	titletext:SetFont(F.GetFontPath(), TITLE_FONT_SIZE, "")
	titletext:SetShadowColor(0, 0, 0, 1)
	titletext:SetShadowOffset(1, -1)
	titletext:SetTextColor(unpack(COLOR_TITLE))
	titletext:SetPoint("TOPLEFT", TITLE_OFFSET, 0)
	Group_OnSetTitle(group, titletext:GetText())

	ApplyBorderLook(group)
end

local function RestoreStockLook(group)
	if not group.merActive then
		return
	end
	group.merActive = false

	local titletext = group.titletext
	titletext:SetFontObject(GameFontNormal)
	titletext:SetPoint("TOPLEFT", 14, 0)
	if group.merOriginalColor then
		titletext:SetTextColor(unpack(group.merOriginalColor))
	end
	group.merAccentBar:Hide()

	RestoreBorderLook(group)
end

-- A page whose own args have no *non-inline* subgroup (true of most module
-- pages - "General"/"Sounds"/"Raid Buffs" etc. are all guiInline) never sets
-- FeedGroup's local `hasChildGroups`, which is what decides whether a
-- ScrollFrame wrapper gets inserted (see AceConfigDialog-3.0.lua:1638) - so
-- FeedOptions ends up adding our InlineGroups as children of that ScrollFrame,
-- not of the `container` this hook receives directly. Recurse into any
-- container-shaped child (has its own `.children`) to find them regardless of
-- how many wrapper layers deep they ended up.
local function WalkForInlineGroups(container, isMUI, depth)
	if not container or not container.children or depth > 4 then
		return
	end

	for _, child in pairs(container.children) do
		if child.type == "InlineGroup" then
			if isMUI then
				ApplyMerLook(child)
			else
				RestoreStockLook(child)
			end
		end
		if child.children then
			WalkForInlineGroups(child, isMUI, depth + 1)
		end
	end
end

hooksecurefunc(ACD, "FeedGroup", function(_, _, _, container, _, path)
	-- AceConfigDialog feeds every ancestor level of the currently open path,
	-- deepest first, ending with a final call for the dialog's own synthetic
	-- root group whose path is always empty - regardless of which page is
	-- actually open. That root call's container still structurally reaches
	-- (via AceGUI's widget pooling/recycling) the same InlineGroups the
	-- deeper, correctly-pathed calls in the same cascade just fed, so acting
	-- on it here would unconditionally restore stock color right after every
	-- single refresh. It carries no real page information, so skip it.
	if not path or #path == 0 then
		return
	end
	WalkForInlineGroups(container, path[1] == "mui", 0)
end)
