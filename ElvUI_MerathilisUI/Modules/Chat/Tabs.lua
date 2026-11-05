local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Chat")
local CH = E:GetModule("Chat")

local _G = _G
local pairs, setmetatable = pairs, setmetatable

local CreateFrame = CreateFrame
local GetPhysicalScreenSize = GetPhysicalScreenSize

-- Same look as the underline of the MerathilisUI options tabs: a flat 2px
-- bar just above the tab's bottom edge, a little wider than the name.
local UNDERLINE_HEIGHT = 2
local UNDERLINE_PADDING = 4

-- Our underline holder per tab, keyed by the tab instead of a field on Blizzard's frame.
local underlines = setmetatable({}, { __mode = "k" })

local function IsEnabled()
	local db = module.chatDB and module.chatDB.tabs
	return db and db.underline and E.private.chat.enable
end

local function IsChatTab(tab)
	return tab and tab.Text and tab:GetParent() ~= _G.ChatConfigFrameChatTabManager and CH:GetOwner(tab) ~= nil
end

-- Follows ElvUI's tab name (whisper names, selector arrows) in width.
local function CreateUnderline(tab)
	local holder = CreateFrame("Frame", nil, tab)
	holder:SetAllPoints()
	holder:EnableMouse(false)

	-- Spanned between the name's edges instead of measured, so secret whisper
	-- names never have to be read.
	local line = holder:CreateTexture(nil, "ARTWORK")
	line:SetTexture(E.media.blankTex)
	line:SetPoint("LEFT", tab.Text, "LEFT", -UNDERLINE_PADDING, 0)
	line:SetPoint("RIGHT", tab.Text, "RIGHT", UNDERLINE_PADDING, 0)
	holder.line = line

	underlines[tab] = holder
	return holder
end

function module:StyleChatTab(tab, selected)
	local holder = underlines[tab]

	if not selected or not IsEnabled() then
		if holder then
			holder:Hide()
		end
		return
	end

	holder = holder or CreateUnderline(tab)

	-- Exactly UNDERLINE_HEIGHT screen pixels in the line's own effective scale
	-- (E:Scale assumes UIParent's), so both snapped edges round the same way on
	-- every tab. Set here so UI scale changes follow.
	local line = holder.line
	local _, screenHeight = GetPhysicalScreenSize()
	local pixel = 768 / screenHeight / line:GetEffectiveScale()
	line:SetHeight(UNDERLINE_HEIGHT * pixel)

	-- Overflow tabs live in the dock's scroll child, a pixel below the dock's
	-- clip edge, which cut the bottom row off. One pixel up keeps the line inside
	-- on every tab, at the same distance to the name.
	line:SetPoint("BOTTOM", tab, "BOTTOM", 0, pixel)

	local cc = E.myClassColor
	line:SetVertexColor(cc.r, cc.g, cc.b, 1)

	-- ElvUI's SetTexture/SetVertexColor hooks turn pixel snapping off, so on tabs
	-- sitting between pixel rows the line blurs over three rows and looks thicker.
	-- Turned back on after the color, which would otherwise disable it again. Both
	-- calls are needed: a bias of 0 (ElvUI's) leaves the snap without effect.
	line:SetSnapToPixelGrid(true)
	line:SetTexelSnappingBias(1)

	holder:Show()
end

-- ElvUI's own tab color pass (selection, whisper colors) runs first.
function module:PostTabUpdateColors(_, tab, selected)
	if IsChatTab(tab) then
		self:StyleChatTab(tab, selected)
	end
end

function module:UpdateTabs()
	if not self.tabsInitialized then
		return
	end

	-- ElvUI's pass revisits every tab and our hook follows right behind.
	CH:UpdateChatTabColors()

	if not IsEnabled() then
		for _, holder in pairs(underlines) do
			holder:Hide()
		end
	end
end

function module:InitializeTabs()
	self:SecureHook(CH, "FCFTab_UpdateColors", "PostTabUpdateColors")
	self.tabsInitialized = true
end
