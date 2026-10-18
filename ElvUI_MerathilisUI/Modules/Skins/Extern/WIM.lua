local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local S = E:GetModule("Skins")
local WS = W:GetModule("Skins")

local _G = _G
local ipairs, pairs, type, unpack = ipairs, pairs, type, unpack
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

--[[ Dropdown lists ]]

-- WIM's context menus (minimap button, shortcut bar) and the option dropdowns use
-- LibDropDownMenu. ElvUI hooks Blizzard's global dropdown functions for it, which the
-- library never calls, so its lists keep the old dialog look without this.
local function SkinDropDownBackdrop(backdrop)
	if backdrop and not backdrop.__MERSkinned then
		backdrop:SetTemplate("Transparent")
		WS:CreateShadow(backdrop)
		backdrop.__MERSkinned = true
	end
end

local function SkinDropDownButton(button)
	local name = button:GetName()

	local highlight = _G[name .. "Highlight"]
	if highlight then
		highlight:SetTexture(E.media.normTex)
		highlight:SetBlendMode("BLEND")
		highlight:SetVertexColor(F.r, F.g, F.b, 0.3)
	end

	local expandArrow = _G[name .. "ExpandArrow"]
	local arrow = expandArrow and expandArrow:GetRegions()
	if arrow then
		arrow:SetTexture(E.Media.Textures.ArrowUp)
		arrow:SetRotation(S.ArrowRotation.right)
		arrow:SetVertexColor(F.r, F.g, F.b)
	end

	local check = _G[name .. "Check"]
	if check then
		local box = CreateFrame("Frame", nil, button)
		box:Size(12)
		box:Point("CENTER", check)
		box:SetTemplate()
		box:Hide()
		button.__MERCheckBox = box
	end

	button.__MERSkinned = true
end

-- The library sets the radio check art again for every entry, so this runs on each show
local function UpdateDropDownChecks(button)
	local name = button:GetName()
	local check, uncheck = _G[name .. "Check"], _G[name .. "UnCheck"]
	local box = button.__MERCheckBox
	if not (check and uncheck and box) then
		return
	end

	local checkable = check:IsShown() or uncheck:IsShown()
	box:SetShown(checkable and not check:GetAtlas())
	if not box:IsShown() then
		return
	end

	check:SetTexture(E.media.normTex)
	check:SetTexCoord(0, 1, 0, 1)
	check:SetVertexColor(F.r, F.g, F.b)
	check:SetInside(box)
	check:SetDrawLayer("OVERLAY")
	uncheck:SetTexture(E.ClearTexture)
end

local function DropDownList_OnShow(list)
	local name = list:GetName()
	SkinDropDownBackdrop(_G[name .. "Backdrop"])
	SkinDropDownBackdrop(_G[name .. "MenuBackdrop"])

	local index = 1
	local button = _G[name .. "Button" .. index]
	while button do
		if not button.__MERSkinned then
			SkinDropDownButton(button)
		end
		if button:IsShown() then
			UpdateDropDownChecks(button)
		end
		index = index + 1
		button = _G[name .. "Button" .. index]
	end
end

local function HookDropDownLists(lib)
	for level = 1, lib.UIDROPDOWNMENU_MAXLEVELS do
		local list = _G["LibDropDownMenu_List" .. level]
		if list and not list.__MERHooked then
			list:HookScript("OnShow", DropDownList_OnShow)
			list.__MERHooked = true
		end
	end
end

local function SkinDropDownLists()
	local lib = _G.WIM.libs.DropDownMenu
	if not lib then
		return
	end

	HookDropDownLists(lib)
	-- More levels get created on demand, the library calls this through its own table
	hooksecurefunc(lib, "UIDropDownMenu_CreateFrames", function()
		HookDropDownLists(lib)
	end)
end

--[[ Options window ]]

-- WIM's framed panels keep their border textures in a plain table named backdrop,
-- so they never get ElvUI's CreateBackdrop, which would take that field for its frame.
local function IsFramedPanel(object)
	return type(object.backdrop) == "table" and not object.backdrop.GetObjectType and object.backdrop.bg
end

local function SkinFramedBackdrop(frame)
	for _, region in pairs(frame.backdrop) do
		region:SetAlpha(0)
	end

	return module:CreateBDFrame(frame, 0.25)
end

local function IsPanelButton(object)
	return object.Left and object.Middle and object.Right
end

-- The option pages are built from WIM's own widget toolkit when a page is opened first,
-- so each page is walked once it shows and its widgets get skinned by type.
local function SkinOptionWidget(object)
	local objectType = object:GetObjectType()

	if objectType == "CheckButton" then
		S:HandleCheckBox(object)
	elseif objectType == "Slider" then
		-- Scroll bars are sliders as well, they come with their scroll frame
		if object.input then
			object:SetBackdrop(nil)
			S:HandleSliderFrame(object)
			S:HandleEditBox(object.input)
			object.input.__MERSkinned = true
		end
	elseif objectType == "EditBox" then
		if IsPanelButton(object) then
			S:HandleEditBox(object)
		end
	elseif objectType == "Button" then
		local parent = object:GetParent()
		if IsPanelButton(object) then
			S:HandleButton(object)
		elseif parent and parent.isCheckButton and parent.menu == object then
			S:HandleNextPrevButton(object, "down")
		end
	elseif objectType == "ScrollFrame" then
		local name = object:GetName()
		local scrollBar = object.ScrollBar or (name and _G[name .. "ScrollBar"])
		if scrollBar then
			if scrollBar.GetThumb then
				S:HandleTrimScrollBar(scrollBar)
			else
				S:HandleScrollBar(scrollBar)
			end
		end
	elseif objectType == "Frame" then
		if object.Button and object.Text and IsPanelButton(object) then
			S:HandleDropDownBox(object, object:GetWidth(), nil, true)
		elseif IsFramedPanel(object) then
			SkinFramedBackdrop(object)
		end
	end

	object.__MERSkinned = true
end

local function WalkOptionWidgets(frame)
	if not frame.__MERSkinned then
		SkinOptionWidget(frame)
	end

	for _, child in ipairs({ frame:GetChildren() }) do
		WalkOptionWidgets(child)
	end
end

local function SkinOptionsListButton(button)
	local highlight = button:GetHighlightTexture()
	if highlight then
		highlight:SetColorTexture(F.r, F.g, F.b, 0.25)
	end

	button.__MERSkinned = true
end

local function SkinOptionsCategory(button)
	-- WIM paints the category gradient again on every update
	button.bg:SetAlpha(0)

	button:CreateBackdrop("Transparent")
	button.backdrop:ClearAllPoints()
	button.backdrop:Point("TOPLEFT", 0, -1)
	button.backdrop:Point("BOTTOMRIGHT", 0, 1)

	local selected = button:CreateTexture(nil, "BORDER")
	selected:SetTexture(E.media.normTex)
	selected:SetVertexColor(F.r, F.g, F.b, 0.4)
	selected:SetInside(button.backdrop)
	button.__MERSelected = selected

	SkinOptionsListButton(button)
end

local function SkinDialogWindow(win)
	win:SetBackdrop(nil)
	module:SetBD(win)

	win.title:ClearAllPoints()
	win.title:Point("TOPLEFT", 18, -16)

	S:HandleCloseButton(win.close)
	win.close:SetHitRectInsets(0, 0, 0, 0)
	win.close:Size(CLOSE_BUTTON_SIZE)
	win.close:ClearAllPoints()
	win.close:Point("TOPRIGHT", -4, -4)

	win.__MERSkinned = true
end

local function Options_UpdateCategories()
	local win = _G.WIM.options.frame
	if not win then
		return
	end

	if not win.__MERSkinned then
		SkinDialogWindow(win)
	end

	for _, button in ipairs(win.nav.category) do
		if not button.__MERSkinned then
			SkinOptionsCategory(button)
		end
		-- The open category is the disabled one
		button.__MERSelected:SetShown(not button:IsEnabled())
	end
end

local function WalkOptionsPage()
	local page = _G.WIM.options.frame.container.frame
	if page then
		WalkOptionWidgets(page)
	end
end

local function Options_UpdateSubCategories()
	local win = _G.WIM.options.frame
	if not win then
		return
	end

	for _, button in ipairs(win.nav.sub.buttons) do
		if not button.__MERSkinned then
			SkinOptionsListButton(button)
			-- A click builds the page first, refreshes the list and only then puts the page into
			-- the container, so the refresh below still sees the previous page.
			button:HookScript("OnClick", WalkOptionsPage)
		end
	end

	WalkOptionsPage()

	-- The scrolling dropdown of the check button menus, created with the first of them
	local dropDown = _G.WIM_DropDownFrame
	if dropDown and not dropDown.__MERSkinned then
		SkinDropDownBackdrop(dropDown)
		for _, button in ipairs(dropDown.buttons) do
			SkinDropDownButton(button)
		end
		dropDown.__MERSkinned = true
	end
end

-- Add / Edit Filter opens its own window, built like the options window
local function SkinFilterWindow()
	local win = _G.WIM3_FilterFrame
	if not win then
		return
	end

	if not win.__MERSkinned then
		SkinDialogWindow(win)
	end

	WalkOptionWidgets(win)
end

--[[ History viewer ]]

local function SkinHistoryDeleteButton(button)
	S:HandleCloseButton(button)
	button:SetHitRectInsets(0, 0, 0, 0)
end

local function SkinHistoryListButton(button)
	button:GetHighlightTexture():SetColorTexture(F.r, F.g, F.b, 0.25)
	if button.delete then
		SkinHistoryDeleteButton(button.delete)
	end

	button.__MERSkinned = true
end

local function SkinHistoryList(scroll)
	for _, button in ipairs(scroll.buttons) do
		if not button.__MERSkinned then
			SkinHistoryListButton(button)
		end
	end
end

-- The user list adds rows when the window grows
local function UserList_Update()
	SkinHistoryList(_G.WIM3_HistoryFrame.nav.userList.scroll)
end

local function UpdateHistoryTabs(win)
	for _, tab in ipairs(win.content.tabs) do
		tab.__MERLine:SetShown(win.TAB == tab.index)
	end
end

local function HistoryTab_OnClick()
	UpdateHistoryTabs(_G.WIM3_HistoryFrame)
end

local function SkinHistoryWindow()
	local win = _G.WIM3_HistoryFrame
	if not win or win.__MERSkinned then
		return
	end

	SkinDialogWindow(win)

	-- Navigation: character dropdown, conversations, date filters
	local nav = win.nav
	S:HandleDropDownBox(nav.user, nav.user:GetWidth(), nil, true)
	nav.border:SetWidth(1)

	nav.filters.border:SetTexture(E.media.normTex)
	nav.filters.border:SetVertexColor(F.r, F.g, F.b, 0.25)

	SkinOptionWidget(nav.userList.scroll)
	SkinOptionWidget(nav.filters.scroll)
	SkinHistoryList(nav.userList.scroll)
	SkinHistoryList(nav.filters.scroll)
	hooksecurefunc(nav.userList.scroll, "update", UserList_Update)

	-- Search bar
	local search = win.search
	search.bg:SetAlpha(0)
	module:CreateBDFrame(search, 0.25)
	local searchBG = SkinFramedBackdrop(search.text)
	searchBG:Point("TOPLEFT", search.text, "TOPLEFT", -4, 2)
	searchBG:Point("BOTTOMRIGHT", search.text, "BOTTOMRIGHT", 2, -2)
	SkinHistoryDeleteButton(search.clear)

	-- Content: message display, plain text view and the tabs below them
	local content = win.content
	module:CreateBDFrame(content, 0.25)

	local chatFrame = content.chatFrame
	S:HandleNextPrevButton(chatFrame.up, "up")
	chatFrame.up:ClearAllPoints()
	chatFrame.up:Point("TOPRIGHT", chatFrame, "TOPRIGHT", 24, 0)
	S:HandleNextPrevButton(chatFrame.down, "down")
	chatFrame.down:ClearAllPoints()
	chatFrame.down:Point("BOTTOMRIGHT", chatFrame, "BOTTOMRIGHT", 24, 0)

	SkinOptionWidget(content.textFrame)

	for _, tab in ipairs(content.tabs) do
		tab.bg:SetAlpha(0)
		tab:CreateBackdrop("Transparent")

		local line = tab:CreateTexture(nil, "OVERLAY")
		line:SetTexture(E.media.normTex)
		line:SetVertexColor(F.r, F.g, F.b)
		line:Height(2)
		line:Point("BOTTOMLEFT", tab.backdrop, "BOTTOMLEFT", 1, 1)
		line:Point("BOTTOMRIGHT", tab.backdrop, "BOTTOMRIGHT", -1, 1)
		tab.__MERLine = line

		tab:HookScript("OnClick", HistoryTab_OnClick)
	end
	UpdateHistoryTabs(win)

	-- Loading bar of long conversations
	local progressBar = win.progressBar
	SkinFramedBackdrop(progressBar)
	SkinFramedBackdrop(progressBar.bar)
	progressBar.bar.bg:SetTexture(E.media.normTex)
	progressBar.bar.bg:SetVertexColor(F.r, F.g, F.b)
	SkinHistoryDeleteButton(progressBar.delete)

	win.__MERSkinned = true
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

	SkinDropDownLists()

	-- The options window is created on its first open, these run whenever a category or page shows
	hooksecurefunc(WIM.options, "UpdateCategories", Options_UpdateCategories)
	hooksecurefunc(WIM.options, "UpdateSubCategories", Options_UpdateSubCategories)
	if WIM.ShowFilterFrame then
		hooksecurefunc(WIM, "ShowFilterFrame", SkinFilterWindow)
	end
	if WIM.ShowHistoryViewer then
		hooksecurefunc(WIM, "ShowHistoryViewer", SkinHistoryWindow)
	end

	-- The minimap button is created once WIM's saved variables are loaded
	local minimapIcon = WIM.modules and WIM.modules.MinimapIcon
	if minimapIcon then
		hooksecurefunc(minimapIcon, "OnEnable", SkinMinimapButton)
	end
	SkinMinimapButton()
end

module:AddCallbackForAddon("WIM")
