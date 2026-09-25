local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

-- Reskins the navigation tree AceConfigDialog builds for MerathilisUI's own
-- `childGroups = "tree"` page (General/Modules/Misc/...) so it matches the
-- inline groups (GroupTitle.lua) and the tab strip (TabGroup.lua): the same
-- lighter box with a small shadow, white labels in the MerathilisUI font and
-- the selected entry marked with an accent bar, a faint accent fill and
-- accent text instead of Blizzard's glowing highlight.
--
-- Same constraints as TabGroup.lua: "TreeGroup" lives on the shared AceGUI
-- instance and AceConfigDialog hard-codes `gui:Create("TreeGroup")`, so this
-- reaches in after FeedGroup built it and only touches trees whose path
-- starts with "mui". TreeGroup widgets are pooled as well, so every FeedGroup
-- call re-decides between our look and the stock one, and OnRelease restores
-- the stock look before the widget goes back into the pool - a tree handed
-- out to another addon's plain AceConfigDialog-3.0 never passes through the
-- ElvUI FeedGroup hooked here.
local ACD = LibStub("AceConfigDialog-3.0-ElvUI", true)
if not ACD or not ACD.FeedGroup then
	return
end

local pairs, unpack = pairs, unpack
local hooksecurefunc = hooksecurefunc
local CreateFont = CreateFont
local GameFontNormal, GameFontHighlight, GameFontHighlightSmall = GameFontNormal, GameFontHighlight, GameFontHighlightSmall

-- Same shadow as GroupTitle.lua's inline groups, but a darker box so the
-- navigation doesn't compete with the option groups next to it.
local COLOR_BACKDROP = { 0.06, 0.06, 0.06, 0.45 }
local SHADOW_SIZE = 3

local COLOR_TEXT = { 1, 1, 1 }
local COLOR_TEXT_SELECTED = { I.Colors.Accent.r, I.Colors.Accent.g, I.Colors.Accent.b }
local FONT_SIZE, FONT_SIZE_SMALL = 12, 11
local SELECTED_FILL_ALPHA = 0.12
local HOVER_FILL_ALPHA = 0.06
local BAR_WIDTH = 2

local fontNormal, fontSmall

-- Font objects instead of setting the label font directly: the button swaps
-- its label between its normal and highlight font objects on every hover and
-- LockHighlight, which would wipe a font set on the label itself.
local function GetFonts()
	if not fontNormal then
		fontNormal = CreateFont("MERTreeGroupFont")
		fontNormal:SetFont(F.GetFontPath(), FONT_SIZE, "")
		fontNormal:SetTextColor(unpack(COLOR_TEXT))
		fontNormal:SetShadowColor(0, 0, 0, 1)
		fontNormal:SetShadowOffset(1, -1)

		fontSmall = CreateFont("MERTreeGroupFontSmall")
		fontSmall:CopyFontObject(fontNormal)
		fontSmall:SetFont(F.GetFontPath(), FONT_SIZE_SMALL, "")
	end

	return fontNormal, fontSmall
end

local function Button_OnEnter(button)
	if button.merActive and not button.selected then
		button.merHover:Show()
	end
end

local function Button_OnLeave(button)
	if button.merActive then
		button.merHover:Hide()
	end
end

local function PrepareButton(button)
	if button.merPrepared then
		return
	end
	button.merPrepared = true

	local hover = button:CreateTexture(nil, "BACKGROUND")
	hover:SetAllPoints()
	hover:SetColorTexture(1, 1, 1, HOVER_FILL_ALPHA)
	hover:Hide()
	button.merHover = hover

	local fill = button:CreateTexture(nil, "BACKGROUND")
	fill:SetAllPoints()
	fill:SetColorTexture(I.Colors.Accent.r, I.Colors.Accent.g, I.Colors.Accent.b, SELECTED_FILL_ALPHA)
	fill:Hide()
	button.merFill = fill

	local bar = button:CreateTexture(nil, "ARTWORK")
	bar:SetWidth(BAR_WIDTH)
	bar:SetPoint("TOPLEFT")
	bar:SetPoint("BOTTOMLEFT")
	bar:SetColorTexture(I.Colors.Accent.r, I.Colors.Accent.g, I.Colors.Accent.b, 1)
	bar:Hide()
	button.merBar = bar

	-- Additive, the stock OnEnter/OnLeave still fire the tree's callbacks
	-- and tooltips. Both check merActive, so they no-op on stock trees.
	button:HookScript("OnEnter", Button_OnEnter)
	button:HookScript("OnLeave", Button_OnLeave)
end

local function StyleButton(button)
	PrepareButton(button)
	button.merActive = true

	-- Kept alive but invisible: LockHighlight/UnlockHighlight still drive it,
	-- and ElvUI recolors it on every refresh.
	if button.highlight then
		button.highlight:SetAlpha(0)
	end

	local normal, small = GetFonts()
	local font = button.level == 1 and normal or small
	button:SetNormalFontObject(font)
	button:SetHighlightFontObject(font)

	local selected = button.selected and true or false
	button.merFill:SetShown(selected)
	button.merBar:SetShown(selected)
	if selected then
		button.merHover:Hide()
		button.text:SetTextColor(unpack(COLOR_TEXT_SELECTED))
	else
		button.text:SetTextColor(unpack(COLOR_TEXT))
	end
end

local function RestoreButton(button)
	if not button.merActive then
		return
	end
	button.merActive = false

	if button.highlight then
		button.highlight:SetAlpha(1)
	end
	button.merHover:Hide()
	button.merFill:Hide()
	button.merBar:Hide()

	-- Same font objects the stock UpdateButton picks per level. Put back
	-- right here instead of waiting for the next RefreshTree: a released
	-- tree has no data left to refresh with, and the explicit text color
	-- set in StyleButton has to go either way.
	local normal = button.level == 1 and GameFontNormal or GameFontHighlightSmall
	local highlight = button.level == 1 and GameFontHighlight or GameFontHighlightSmall
	button:SetNormalFontObject(normal)
	button:SetHighlightFontObject(highlight)
	button.text:SetTextColor((button.selected and highlight or normal):GetTextColor())
end

-- Replaces the Transparent template color the E.frames sweep would put back
-- (same reasoning as GroupTitle.lua's Border_BackdropColor).
local function TreeFrame_BackdropColor(treeframe)
	treeframe:SetBackdropColor(unpack(COLOR_BACKDROP))
end

local function StyleTreeFrame(tree)
	local treeframe = tree.treeframe
	-- Only when ElvUI's Ace3 skin templated the tree frame.
	if not treeframe or not treeframe.template then
		return
	end

	treeframe.callbackBackdropColor = TreeFrame_BackdropColor
	TreeFrame_BackdropColor(treeframe)

	if not treeframe.shadow then
		W:GetModule("Skins"):CreateShadow(treeframe, SHADOW_SIZE)
	end
	if treeframe.shadow then
		treeframe.shadow:Show()
	end
end

local function RestoreTreeFrame(tree)
	local treeframe = tree.treeframe
	if not treeframe or not treeframe.template then
		return
	end

	treeframe.callbackBackdropColor = nil
	treeframe:SetBackdropColor(unpack(E.media.backdropfadecolor))
	if treeframe.shadow then
		treeframe.shadow:Hide()
	end
end

-- Runs after every RefreshTree (stock + ElvUI's override), which re-applies
-- fonts and highlight colors to the visible buttons and may create new ones.
local function Tree_OnRefresh(tree)
	if not tree.merActive or not tree.buttons then
		return
	end

	for _, button in pairs(tree.buttons) do
		StyleButton(button)
	end
end

local RestoreStockLook

local function PrepareTree(tree)
	if tree.merPrepared then
		return
	end
	tree.merPrepared = true

	-- Hooked on the widget itself, after ElvUI swapped in its own
	-- RefreshTree, so this runs after both of them.
	hooksecurefunc(tree, "RefreshTree", Tree_OnRefresh)
	hooksecurefunc(tree, "OnRelease", function(self)
		RestoreStockLook(self)
	end)
end

local function ApplyMerLook(tree)
	PrepareTree(tree)
	tree.merActive = true

	StyleTreeFrame(tree)
	Tree_OnRefresh(tree)
end

function RestoreStockLook(tree)
	if not tree.merActive then
		return
	end
	tree.merActive = false

	RestoreTreeFrame(tree)
	for _, button in pairs(tree.buttons) do
		RestoreButton(button)
	end
end

hooksecurefunc(ACD, "FeedGroup", function(_, _, _, container, _, path)
	if not container or not container.children then
		return
	end

	local isMUI = path and path[1] == "mui"
	for _, child in pairs(container.children) do
		if child.type == "TreeGroup" then
			if isMUI then
				ApplyMerLook(child)
			else
				RestoreStockLook(child)
			end
		end
	end
end)
