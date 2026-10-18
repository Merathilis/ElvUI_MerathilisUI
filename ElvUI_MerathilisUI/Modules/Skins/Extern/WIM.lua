local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local S = E:GetModule("Skins")

local _G = _G
local ipairs, unpack = ipairs, unpack
local gsub = string.gsub

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc

local CLASS_ICON_TCOORDS = CLASS_ICON_TCOORDS

local CLASS_ICONS = [[Interface\WorldStateFrame\Icons-Classes]]
local UNKNOWN_ICON = [[Interface\Icons\INV_Misc_QuestionMark]]

-- WIM applies its skin table (sizes, points and button art) again whenever a window gets
-- created, recycled or the WIM skin changes. Everything below LayoutWindow runs after each pass.
local ICON_SIZE = 32
local CLOSE_BUTTON_SIZE = 20
local SCROLL_BUTTON_SIZE = 18
local TAB_BUTTON_SIZE = 18

local backdropTextures = { "tl", "tr", "bl", "br", "t", "b", "l", "r", "bg" }
local tabTextures = { "left", "middle", "right", "sleft", "smiddle", "sright" }
local textureSetters = { "SetNormalTexture", "SetPushedTexture", "SetDisabledTexture", "SetHighlightTexture" }

-- Keeps ElvUI's arrow art on buttons WIM would otherwise re-texture on every skin pass.
local function LockButtonTextures(button)
	for _, func in ipairs(textureSetters) do
		button[func] = E.noop
	end
end

local function HideRegion(region)
	if region then
		region:SetAlpha(0)
	end
end

local function IsMinimapButtonCollected()
	local db = E.db.mui.minimapButtons
	if db and db.enable and db.addonButtons and db.addonButtons.enable then
		return true
	end

	local buttons = MER:GetModule("MER_MinimapButtons", true)
	return buttons and buttons:GetForeignCollector() ~= nil
end

--[[ Close button ]]

local function GetCloseStateTexture()
	local skin = _G.WIM.GetSelectedSkin()
	local close = skin and skin.message_window.widgets.close
	return close and close.state_close and close.state_close.NormalTexture
end

-- The button hides the window, with shift held it closes it. WIM swaps its art for that,
-- the glyph follows: an arrow for hide, a cross for close.
local function UpdateCloseGlyph(button, texture)
	local isClose
	if texture then
		isClose = texture == GetCloseStateTexture()
	else
		isClose = button.curTextureIndex == 2
	end

	button.Texture:SetTexture(isClose and E.Media.Textures.Close or I.Media.Textures.arrow)
end

local function Close_SetNormalTexture(button, texture)
	HideRegion(button:GetNormalTexture())
	UpdateCloseGlyph(button, texture)
end

local function Close_SetPushedTexture(button)
	HideRegion(button:GetPushedTexture())
end

local function Close_SetHighlightTexture(button)
	HideRegion(button:GetHighlightTexture())
end

local function SkinCloseButton(button)
	S:HandleCloseButton(button)
	-- ElvUI's insets are made for 32px Blizzard buttons and leave almost nothing to click here
	button:SetHitRectInsets(0, 0, 0, 0)

	Close_SetNormalTexture(button)
	Close_SetPushedTexture(button)
	Close_SetHighlightTexture(button)

	hooksecurefunc(button, "SetNormalTexture", Close_SetNormalTexture)
	hooksecurefunc(button, "SetPushedTexture", Close_SetPushedTexture)
	hooksecurefunc(button, "SetHighlightTexture", Close_SetHighlightTexture)
end

--[[ Class icon ]]

local function GetClassTag(class)
	local info = class and _G.WIM.constants.classes[class]
	if not info then
		return
	end

	-- Female class names are separate entries, tagged with a trailing F
	local tag = info.tag
	if not CLASS_ICON_TCOORDS[tag] then
		tag = gsub(tag, "F$", "")
	end

	return CLASS_ICON_TCOORDS[tag] and tag
end

local function Window_UpdateIcon(window)
	local icon = window.widgets.class_icon

	if window.type == "chat" and window.chatType then
		-- WIM tints a mask in the channel color, the gradient stays on the flat texture
		icon:SetTexture(E.media.normTex)
		icon:SetTexCoord(0, 1, 0, 1)
		return
	end

	local tag = GetClassTag(window.class)
	if tag then
		local left, right, top, bottom = unpack(CLASS_ICON_TCOORDS[tag])
		icon:SetTexture(CLASS_ICONS)
		icon:SetTexCoord(left + 0.015, right - 0.015, top + 0.015, bottom - 0.015)
	elseif not (window.bn and window.bn.client) then
		icon:SetTexture(UNKNOWN_ICON)
		icon:SetTexCoords()
	end
	-- Battle.net friends outside of WoW keep WIM's client icon
end

--[[ Shortcut bar ]]

local function SkinShortcutButton(button)
	if not button.__MERSkinned then
		button:CreateBackdrop()
		button.icon:SetInside(button.backdrop)
		button.icon:SetTexCoords()
		button.__MERSkinned = true
	end

	button:SetNormalTexture(E.ClearTexture)
	button:SetPushedTexture(E.ClearTexture)

	local highlight = button:GetHighlightTexture()
	if highlight then
		highlight:SetColorTexture(1, 1, 1, 0.25)
		highlight:SetInside(button.backdrop)
	end
end

--[[ Message windows ]]

local function SkinWindow(window)
	local widgets = window.widgets

	local backdrop = widgets.Backdrop
	for _, key in ipairs(backdropTextures) do
		HideRegion(backdrop[key])
	end
	module:SetBD(backdrop)

	-- A child of the backdrop, so it fades with WIM's window opacity like the rest
	local holder = CreateFrame("Frame", nil, backdrop)
	holder:Size(ICON_SIZE)
	holder:Point("TOPLEFT", 8, -8)
	holder:SetTemplate()
	widgets.class_icon:SetParent(holder)
	widgets.class_icon:SetDrawLayer("ARTWORK")
	window.__MERIconHolder = holder
	hooksecurefunc(window, "UpdateIcon", Window_UpdateIcon)

	local chat = widgets.chat_display
	chat.__MERbg = module:CreateBDFrame(chat, 0.25)
	chat.__MERbg:Point("TOPLEFT", -6, E.mult)
	chat.__MERbg:Point("BOTTOMRIGHT", 4, -6)

	local msgBox = widgets.msg_box
	msgBox.__MERbg = module:CreateBDFrame(msgBox, 0.25)
	msgBox.__MERbg:Point("TOPLEFT", -6, -2)
	msgBox.__MERbg:Point("BOTTOMRIGHT", E.mult, 2)

	S:HandleNextPrevButton(widgets.scroll_up, "up")
	LockButtonTextures(widgets.scroll_up)
	S:HandleNextPrevButton(widgets.scroll_down, "down")
	LockButtonTextures(widgets.scroll_down)

	SkinCloseButton(widgets.close)

	window.__MERSkinned = true
end

local function LayoutWindow(window)
	local widgets = window.widgets
	local holder = window.__MERIconHolder

	widgets.class_icon:ClearAllPoints()
	widgets.class_icon:SetInside(holder)

	-- Chat and W2W buttons sit on top of the icon, sized for WIM's 64px art
	for _, name in ipairs({ "chat_info", "w2w" }) do
		local widget = widgets[name]
		if widget then
			widget:ClearAllPoints()
			widget:SetAllPoints(holder)
		end
	end

	local chatBG = widgets.chat_display.__MERbg
	widgets.scroll_up:Size(SCROLL_BUTTON_SIZE)
	widgets.scroll_up:ClearAllPoints()
	widgets.scroll_up:Point("TOPLEFT", chatBG, "TOPRIGHT", 4, 0)
	widgets.scroll_down:Size(SCROLL_BUTTON_SIZE)
	widgets.scroll_down:ClearAllPoints()
	widgets.scroll_down:Point("BOTTOMLEFT", chatBG, "BOTTOMRIGHT", 4, 0)

	widgets.close:Size(CLOSE_BUTTON_SIZE)
	widgets.close:ClearAllPoints()
	widgets.close:Point("TOPRIGHT", window, "TOPRIGHT", -4, -4)

	local shortcuts = widgets.shortcuts
	if shortcuts and shortcuts.buttons then
		for _, button in ipairs(shortcuts.buttons) do
			SkinShortcutButton(button)
		end
	end

	Window_UpdateIcon(window)
end

local function ApplySkinToWindow(window)
	if not window or not window.widgets then
		return
	end

	if not window.__MERSkinned then
		SkinWindow(window)
	end

	LayoutWindow(window)
end

--[[ Tabs ]]

local function Tab_SetSelected(tab, selected)
	tab.__MERLine:SetShown(selected)
end

local function SkinTabStrip(strip)
	if not strip.__MERSkinned then
		for _, tab in ipairs(strip.tabs) do
			for _, key in ipairs(tabTextures) do
				HideRegion(tab[key])
			end

			-- The strip overlaps the window by 4px, the tabs end at its top edge
			tab:CreateBackdrop("Transparent")
			tab.backdrop:ClearAllPoints()
			tab.backdrop:Point("TOPLEFT", tab, "TOPLEFT", 1, 0)
			tab.backdrop:Point("BOTTOMRIGHT", tab, "BOTTOMRIGHT", -1, 4)

			local line = tab:CreateTexture(nil, "OVERLAY")
			line:SetTexture(E.media.normTex)
			line:SetVertexColor(F.r, F.g, F.b)
			line:Height(2)
			line:Point("BOTTOMLEFT", tab.backdrop, "BOTTOMLEFT", 1, 1)
			line:Point("BOTTOMRIGHT", tab.backdrop, "BOTTOMRIGHT", -1, 1)
			line:Hide()
			tab.__MERLine = line

			hooksecurefunc(tab, "SetSelected", Tab_SetSelected)
		end

		S:HandleNextPrevButton(strip.prevButton, "left")
		LockButtonTextures(strip.prevButton)
		S:HandleNextPrevButton(strip.nextButton, "right")
		LockButtonTextures(strip.nextButton)

		strip.__MERSkinned = true
	end

	-- WIM flashes the highlight for unread messages, so it keeps a visible color
	for _, tab in ipairs(strip.tabs) do
		local highlight = tab:GetHighlightTexture()
		if highlight then
			highlight:SetColorTexture(F.r, F.g, F.b, 0.25)
			highlight:SetInside(tab.backdrop)
		end
	end

	strip.prevButton:Size(TAB_BUTTON_SIZE)
	strip.nextButton:Size(TAB_BUTTON_SIZE)
end

local function SkinTabStrips()
	local index = 1
	local strip = _G["WIM_TabStrip" .. index]
	while strip do
		SkinTabStrip(strip)
		index = index + 1
		strip = _G["WIM_TabStrip" .. index]
	end
end

--[[ Menu ]]

local function SkinMenuButton(button)
	button:StripTextures()
	for _, key in ipairs({ "Left", "Middle", "Right" }) do
		HideRegion(button[key])
	end

	button:SetHighlightTexture(E.media.normTex)
	local highlight = button:GetHighlightTexture()
	highlight:SetVertexColor(F.r, F.g, F.b, 0.25)
	highlight:SetAllPoints()

	S:HandleCloseButton(button.close)
	button.close:SetHitRectInsets(0, 0, 0, 0)
end

local function Menu_ApplySkin(menu)
	for _, group in ipairs(menu.groups) do
		group:SetBackdrop(nil)
	end
end

local function SkinMenu(menu)
	module:SetBD(menu)

	for _, group in ipairs(menu.groups) do
		group.title:ClearAllPoints()
		group.title:Point("TOPLEFT", 10, -8)
		group.title:Point("TOPRIGHT", -10, -8)

		for _, button in ipairs(group.buttons) do
			SkinMenuButton(button)
		end
	end

	Menu_ApplySkin(menu)
	hooksecurefunc(menu, "ApplySkin", Menu_ApplySkin)
end

--[[ Minimap button ]]

local function SkinMinimapButton()
	local button = _G.WIM.MinimapIcon
	if not button or button.__MERSkinned then
		return
	end

	-- Tracking ring
	button:DisableDrawLayer("OVERLAY")

	-- WIM paints its state (enabled, disabled, notification) on a round mask behind the icon
	button.backGround:SetTexture(E.media.normTex)
	button.backGround:ClearAllPoints()
	button.backGround:SetAllPoints(button.icon)

	-- A button collector gives it its own frame
	if not IsMinimapButtonCollected() then
		button:CreateBackdrop("Transparent")
		button.backdrop:SetInside(button, 4, 4)
		button.icon:ClearAllPoints()
		button.icon:SetInside(button.backdrop)

		local highlight = button:GetHighlightTexture()
		if highlight then
			highlight:SetColorTexture(1, 1, 1, 0.25)
			highlight:SetInside(button.backdrop)
		end
	end

	button.__MERSkinned = true
end

function module:WIM()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.wim then
		return
	end

	local WIM = _G.WIM
	if not WIM then
		return
	end

	-- WIM runs its files in its own environment, so these hooks catch its internal calls too.
	-- ApplySkinToWindow covers new, recycled and reskinned windows alike.
	hooksecurefunc(WIM, "ApplySkinToWindow", ApplySkinToWindow)
	hooksecurefunc(WIM, "GetAvailableTabGroup", SkinTabStrips)
	hooksecurefunc(WIM, "ApplySkinToTabs", SkinTabStrips)

	-- Windows WIM created before this skin loaded
	local index = 1
	local window = _G["WIM3_msgFrame" .. index]
	while window do
		ApplySkinToWindow(window)
		index = index + 1
		window = _G["WIM3_msgFrame" .. index]
	end
	SkinTabStrips()

	if WIM.Menu then
		SkinMenu(WIM.Menu)
	end

	-- The minimap button is created once WIM's saved variables are loaded
	local minimapIcon = WIM.modules and WIM.modules.MinimapIcon
	if minimapIcon then
		hooksecurefunc(minimapIcon, "OnEnable", SkinMinimapButton)
	end
	SkinMinimapButton()
end

module:AddCallbackForAddon("WIM")
