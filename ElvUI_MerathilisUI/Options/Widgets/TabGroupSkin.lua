local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

-- Reskins the tab strip AceConfigDialog builds for MerathilisUI's own
-- `childGroups = "tab"` category pages (e.g. "Modules" -> ActionBars/Armory/
-- Bags/...). Unlike the toggle/slider/dropdown/edit box/color picker/button
-- widgets, this can't be done by swapping in a custom `dialogControl`:
-- AceConfigDialog hard-codes `gui:Create("TabGroup")` for tab-style groups and
-- never reads a per-group control override, and "TabGroup" is a widget type on
-- the *shared* AceGUI-3.0 instance (E.Libs.AceGUI) - registering our own
-- "TabGroup" there would reskin every AceGUI-based addon's tab bars, not just
-- ours. So instead this reaches in *after* AceConfigDialog builds the tab
-- strip and reskins only the specific tab buttons belonging to MerathilisUI's
-- own options tree (path[1] == "mui"), leaving the shared TabGroup widget type
-- itself untouched for everyone else.
--
-- ElvUI renders its own (and its plugins') options through a privately-named
-- AceConfigDialog-3.0-ElvUI instance (see Modules/Skins/Core.lua's callback
-- registration for both "AceConfigDialog-3.0" and "AceConfigDialog-3.0-ElvUI"),
-- not the generic shared "AceConfigDialog-3.0". That instance isn't vendored in
-- this addon, so its FeedGroup is assumed (not verified) to match the standard
-- Ace3 AceConfigDialog-3.0 shape it was almost certainly forked from. Every
-- access below is nil-guarded so a future ElvUI update that changes this
-- internal shape just means the tabs stay unstyled, not a Lua error.
--
-- AceGUI recycles widgets from a shared pool by type, so a tab button frame
-- we've styled can later be handed back out for a completely unrelated tab
-- group - ElvUI's own "DataBars" page (Experience/Reputation/Honor/...) showed
-- up with our flat style this way. Every "TabGroup" ever created goes through
-- this same FeedGroup, though (it's the only place AceConfigDialog calls
-- `gui:Create("TabGroup")`), so the fix is to actively re-decide on *every*
-- FeedGroup call: apply our look when path[1] == "mui", explicitly restore the
-- stock look otherwise - never just style once and leave it.
local ACD = LibStub("AceConfigDialog-3.0-ElvUI", true)
if not ACD or not ACD.FeedGroup then
	return
end

local pairs, unpack = pairs, unpack
local hooksecurefunc = hooksecurefunc

local COLOR_TAB = { 0.16, 0.16, 0.16, 1 }
local COLOR_TAB_HOVER = { 0.22, 0.22, 0.22, 1 }

local COLOR_TEXT_NORMAL = { 1, 1, 1 }
local COLOR_TEXT_SELECTED = { I.Colors.Accent.r, I.Colors.Accent.g, I.Colors.Accent.b }
local COLOR_TEXT_DISABLED = { 0.5, 0.5, 0.5 }

-- Stock tabs anchor 10px into each other on purpose (BuildTabs in
-- AceGUIContainer-TabGroup.lua: `tab:SetPoint("LEFT", tabs[tabno-1], "RIGHT",
-- -10, 0)`) - the curved Left/Right edge art was designed to interlock there
-- with no visible seam. Our flat rectangular fill has no such curve, so it's
-- inset BOX_INSET_X from the tab frame's own left/right edge instead of
-- covering it edge-to-edge - with 6px inset on both sides that leaves a small
-- gap (2 * inset - the 10px overlap) between neighboring tabs instead of them
-- visibly overlapping.
local BOX_INSET_X = 6
local BOX_INSET_Y = 2

local function UpdateTabVisual(tab)
	if not tab.merActive then
		return
	end

	local hover = tab.merHover and not tab.disabled
	tab.merFill:SetVertexColor(unpack(hover and COLOR_TAB_HOVER or COLOR_TAB))
	tab.merUnderline:SetShown(tab.selected and true or false)

	if tab.disabled then
		tab.Text:SetTextColor(unpack(COLOR_TEXT_DISABLED))
	elseif tab.selected then
		tab.Text:SetTextColor(unpack(COLOR_TEXT_SELECTED))
	else
		tab.Text:SetTextColor(unpack(COLOR_TEXT_NORMAL))
	end
end

local function Tab_OnEnter(tab)
	if not tab.merActive then
		return
	end
	tab.merHover = true
	UpdateTabVisual(tab)
end

local function Tab_OnLeave(tab)
	if not tab.merActive then
		return
	end
	tab.merHover = nil
	UpdateTabVisual(tab)
end

-- One-time setup, run at most once per tab button frame regardless of how
-- many different tab groups it ends up serving over its pooled lifetime:
-- captures the original textures (so RestoreStockLook has something to put
-- back) and creates our fill/underline plus the additive hooks. Doesn't turn
-- our look on or off by itself - ApplyMerLook/RestoreStockLook do that.
local function PrepareTab(tab)
	if tab.merPrepared or not tab.Left then
		return
	end
	tab.merPrepared = true

	tab.merOriginal = {
		Left = tab.Left:GetTexture(),
		Middle = tab.Middle:GetTexture(),
		Right = tab.Right:GetTexture(),
		LeftDisabled = tab.LeftDisabled:GetTexture(),
		MiddleDisabled = tab.MiddleDisabled:GetTexture(),
		RightDisabled = tab.RightDisabled:GetTexture(),
		Highlight = tab.HighlightTexture and tab.HighlightTexture:GetTexture(),
	}

	-- Textures directly on `tab` itself (not a separate child frame) at
	-- "BACKGROUND"/"ARTWORK" draw layer - a *child frame*'s own regions always
	-- render above its parent's regions regardless of draw layer (frame level
	-- beats layer across frames), which is what made an earlier attempt with a
	-- child "box" frame opaquely cover tab.Text. Same-frame draw layers don't
	-- have that problem: BACKGROUND always renders below tab.Text's own layer.
	local fill = tab:CreateTexture(nil, "BACKGROUND")
	fill:SetPoint("TOPLEFT", tab, "TOPLEFT", BOX_INSET_X, -BOX_INSET_Y)
	fill:SetPoint("BOTTOMRIGHT", tab, "BOTTOMRIGHT", -BOX_INSET_X, BOX_INSET_Y)
	fill:SetColorTexture(1, 1, 1, 1)
	fill:Hide()
	tab.merFill = fill

	local underline = tab:CreateTexture(nil, "ARTWORK")
	underline:SetHeight(2)
	underline:SetPoint("BOTTOMLEFT", fill, "BOTTOMLEFT", 2, 1)
	underline:SetPoint("BOTTOMRIGHT", fill, "BOTTOMRIGHT", -2, 1)
	underline:SetColorTexture(I.Colors.Accent.r, I.Colors.Accent.g, I.Colors.Accent.b, 1)
	underline:Hide()
	tab.merUnderline = underline

	-- Additive (HookScript/hooksecurefunc), never replaces the stock
	-- Tab_OnEnter/OnLeave/SetSelected/SetDisabled behavior - those are still
	-- needed for OnTabEnter/OnTabLeave callbacks and click handling. Both
	-- check tab.merActive themselves, so they're harmless no-ops whenever this
	-- particular tab button isn't currently one of ours.
	tab:HookScript("OnEnter", Tab_OnEnter)
	tab:HookScript("OnLeave", Tab_OnLeave)
	hooksecurefunc(tab, "SetSelected", UpdateTabVisual)
	hooksecurefunc(tab, "SetDisabled", UpdateTabVisual)
end

local function ApplyMerLook(tab)
	PrepareTab(tab)
	if not tab.Left or tab.merActive then
		return
	end
	tab.merActive = true

	-- Strips the stock parchment tab art (left/middle/right + their disabled
	-- counterparts, plus the default orange highlight) down to blank textures
	-- instead of removing them outright - AceGUIContainer-TabGroup's own
	-- PanelTemplates_TabResize still reads their sizes to lay tabs out, so
	-- keeping the (now invisible) texture objects alive keeps that math intact.
	tab.Left:SetTexture(nil)
	tab.Middle:SetTexture(nil)
	tab.Right:SetTexture(nil)
	tab.LeftDisabled:SetTexture(nil)
	tab.MiddleDisabled:SetTexture(nil)
	tab.RightDisabled:SetTexture(nil)
	if tab.HighlightTexture then
		tab.HighlightTexture:SetTexture(nil)
	end

	tab.merFill:Show()
	UpdateTabVisual(tab)
end

local function RestoreStockLook(tab)
	if not tab.merActive then
		return
	end
	tab.merActive = false

	local original = tab.merOriginal
	if original then
		tab.Left:SetTexture(original.Left)
		tab.Middle:SetTexture(original.Middle)
		tab.Right:SetTexture(original.Right)
		tab.LeftDisabled:SetTexture(original.LeftDisabled)
		tab.MiddleDisabled:SetTexture(original.MiddleDisabled)
		tab.RightDisabled:SetTexture(original.RightDisabled)
		if tab.HighlightTexture and original.Highlight then
			tab.HighlightTexture:SetTexture(original.Highlight)
		end
	end

	tab.merFill:Hide()
	tab.merUnderline:Hide()

	-- tab.Text's color was set explicitly by our UpdateTabVisual and won't
	-- reset on its own - re-running the stock SetSelected/SetDisabled makes
	-- Blizzard's own Enable()/Disable()-driven font-object coloring repaint it.
	-- merActive is already false at this point, so our hooked UpdateTabVisual
	-- (still attached, hooks can't be removed) just no-ops when these re-fire.
	tab:SetSelected(tab.selected)
	tab:SetDisabled(tab.disabled)
end

local function StyleTabGroup(tabGroup, isMUI)
	if not tabGroup or not tabGroup.tabs then
		return
	end
	for _, tab in pairs(tabGroup.tabs) do
		if isMUI then
			ApplyMerLook(tab)
		else
			RestoreStockLook(tab)
		end
	end
end

hooksecurefunc(ACD, "FeedGroup", function(_, _, _, container, _, path)
	if not container or not container.children then
		return
	end

	local isMUI = path and path[1] == "mui"
	for _, child in pairs(container.children) do
		if child.type == "TabGroup" then
			StyleTabGroup(child, isMUI)
		end
	end
end)
