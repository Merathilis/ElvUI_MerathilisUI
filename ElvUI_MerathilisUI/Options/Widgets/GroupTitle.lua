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
local ACD = LibStub("AceConfigDialog-3.0-ElvUI", true)
if not ACD or not ACD.FeedGroup then
	return
end

local pairs, unpack = pairs, unpack
local hooksecurefunc = hooksecurefunc

local COLOR_TITLE = { 1, 1, 1 }

local function Group_OnSetTitle(group, title)
	if not group.merActive then
		return
	end
	title = title or ""
	title = title:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
	group.titletext:SetText(title)
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

	-- Additive (hooksecurefunc), never replaces the stock SetTitle - it's
	-- still needed for the actual text/layout. Checks group.merActive itself,
	-- so it's a harmless no-op whenever this group isn't currently one of ours.
	hooksecurefunc(group, "SetTitle", Group_OnSetTitle)
end

local function ApplyMerLook(group)
	PrepareGroup(group)
	if not group.titletext or group.merActive then
		return
	end
	group.merActive = true

	group.titletext:SetTextColor(unpack(COLOR_TITLE))
	-- SetTitle was already called (by FeedOptions, before we ever attached our
	-- hook the first time this group was prepared) - strip whatever it's
	-- already carrying instead of waiting for the next title change.
	Group_OnSetTitle(group, group.titletext:GetText())
end

local function RestoreStockLook(group)
	if not group.merActive then
		return
	end
	group.merActive = false

	if group.merOriginalColor then
		group.titletext:SetTextColor(unpack(group.merOriginalColor))
	end
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
	WalkForInlineGroups(container, path and path[1] == "mui", 0)
end)
