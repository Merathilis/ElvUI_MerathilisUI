local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

-- AceConfigDialog adds a "ScrollFrame" container (AceConfigDialog-3.0.lua's
-- FeedGroup, ~line 1796) to any options page whose content overflows the
-- visible area. ElvUI already reskins that scrollbar's thumb globally, for
-- every AceGUI-3.0 instance, via Skins/Ace3.lua's Ace3_RegisterAsContainer ->
-- S:HandleScrollBar - using ElvUI's own general "value color"
-- (E.media.rgbvaluecolor, set under ElvUI > General > Colors), not
-- I.Colors.Accent. Same situation as TabGroup.lua/GroupTitle.lua: "ScrollFrame"
-- is a widget type on the *shared* AceGUI-3.0 instance and has no
-- dialogControl-style override point, so this reaches in *after* FeedGroup
-- builds the page and recolors just the thumb, only for MerathilisUI's own
-- options tree (path[1] == "mui") - leaving every other addon's (and ElvUI's
-- own) scrollbars on the stock value color.
local ACD = LibStub("AceConfigDialog-3.0-ElvUI", true)
if not ACD or not ACD.FeedGroup then
	return
end

local pairs, unpack = pairs, unpack
local hooksecurefunc = hooksecurefunc

local COLOR_ACCENT = { I.Colors.Accent.r, I.Colors.Accent.g, I.Colors.Accent.b }

-- Horizontal-only inset for the thumb's backdrop, shrinking the visible
-- colored bar without touching the Slider frame's own width - that width is
-- what AceGUI's ScrollFrame:FixScroll bases its hardcoded 20px content
-- gutter on, so resizing the frame itself would desync the two. HandleScrollBar
-- already supports exactly this via its own thumbX/thumbY params (unused by
-- ElvUI's stock call at Ace3.lua's Ace3_RegisterAsContainer, so thumbX/Y are
-- both 0 there) - we just can't call HandleScrollBar a second time ourselves
-- to pass our own (it no-ops once frame.backdrop exists), so this reproduces
-- its thumb-backdrop anchoring line by hand with our own inset instead.
local THUMB_INSET_X = 4

-- One-time setup, run at most once per ScrollFrame widget object regardless
-- of how many different pages it ends up serving over its pooled lifetime.
-- Captures whatever color ElvUI's own HandleScrollBar already applied, so
-- RestoreStockLook has the real original to put back rather than a guess.
local function PrepareScrollFrame(scrollFrame)
	local thumb = scrollFrame.scrollbar and scrollFrame.scrollbar.Thumb
	if scrollFrame.merPrepared or not thumb or not thumb.backdrop then
		return
	end
	scrollFrame.merPrepared = true
	scrollFrame.merOriginalColor = { thumb.backdrop:GetBackdropColor() }
end

local function ApplyMerLook(scrollFrame)
	PrepareScrollFrame(scrollFrame)

	local thumb = scrollFrame.scrollbar and scrollFrame.scrollbar.Thumb
	if not thumb or not thumb.backdrop then
		return
	end

	-- Re-applied on every FeedGroup call, not just the first time this
	-- ScrollFrame goes active - AceGUI recycles these widgets, and ElvUI's own
	-- ThumbWatcher (hooked onto SetMinMaxValues/Enable/Disable/SetEnabled) can
	-- repaint the thumb back to the stock value color in between.
	scrollFrame.merActive = true
	thumb.backdrop:SetBackdropColor(unpack(COLOR_ACCENT))
	thumb.backdrop:ClearAllPoints()
	thumb.backdrop:SetPoint("TOPLEFT", thumb, THUMB_INSET_X, 0)
	thumb.backdrop:SetPoint("BOTTOMRIGHT", thumb, -THUMB_INSET_X, 0)
end

local function RestoreStockLook(scrollFrame)
	if not scrollFrame.merActive then
		return
	end
	scrollFrame.merActive = false

	local thumb = scrollFrame.scrollbar and scrollFrame.scrollbar.Thumb
	if thumb and thumb.backdrop then
		if scrollFrame.merOriginalColor then
			thumb.backdrop:SetBackdropColor(unpack(scrollFrame.merOriginalColor))
		end
		thumb.backdrop:ClearAllPoints()
		thumb.backdrop:SetPoint("TOPLEFT", thumb, 0, 0)
		thumb.backdrop:SetPoint("BOTTOMRIGHT", thumb, 0, 0)
	end
end

-- Same recursion as GroupTitle.lua's WalkForInlineGroups: a page whose own
-- args have no non-inline subgroup never sets FeedGroup's local
-- `hasChildGroups`, so the ScrollFrame ends up nested inside another
-- container child rather than a direct child of the `container` this hook
-- receives - walk down through anything container-shaped to find it.
local function WalkForScrollFrames(container, isMUI, depth)
	if not container or not container.children or depth > 4 then
		return
	end

	for _, child in pairs(container.children) do
		if child.type == "ScrollFrame" then
			if isMUI then
				ApplyMerLook(child)
			else
				RestoreStockLook(child)
			end
		end
		if child.children then
			WalkForScrollFrames(child, isMUI, depth + 1)
		end
	end
end

hooksecurefunc(ACD, "FeedGroup", function(_, _, _, container, _, path)
	-- FeedGroup's own trailing call for the dialog's synthetic root group
	-- always carries an empty path regardless of which page is actually
	-- open - see GroupTitle.lua for the full explanation. Skip it, or it
	-- unconditionally restores stock color right after every real page's
	-- own (correctly-pathed) call in the same refresh cascade.
	if not path or #path == 0 then
		return
	end
	WalkForScrollFrames(container, path[1] == "mui", 0)
end)
