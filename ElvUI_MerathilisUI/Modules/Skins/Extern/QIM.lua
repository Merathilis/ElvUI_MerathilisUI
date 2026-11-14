local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local S = E:GetModule("Skins")

local _G = _G
local ipairs, pairs, unpack = ipairs, pairs, unpack

local hooksecurefunc = hooksecurefunc

-- QIM ships two appearances. Classic is built from Blizzard templates, Flat draws everything itself:
-- every widget comes from a factory function in QIM.SkinFlat and takes its colors from one palette
-- (QIM.Themes.ResolvePalette). This skin sits on top of Flat. It swaps the palette for our colors and
-- lets the factories hand out widgets in the ElvUI look, so it covers windows QIM adds later as well.
local SELECTED_ALPHA = 0.3
local HOVER_ALPHA = 0.1

local palette

local function BuildPalette()
	local r, g, b, a = unpack(E.media.backdropfadecolor)

	palette = {
		-- Accent: scroll bar thumbs, picked days in the delete by date calendar
		chrome = { r = F.r, g = F.g, b = F.b, a = 1 },
		windowBg = { r = r, g = g, b = b, a = a },
		field = { r = 0, g = 0, b = 0, a = 0.25 },
		-- Filter column of the big window
		softChrome = { r = 0, g = 0, b = 0, a = 0.25 },
		text = { r = 1, g = 1, b = 1, a = 1 },
		textMuted = { r = 0.6, g = 0.6, b = 0.6, a = 1 },
		onChrome = { r = 1, g = 1, b = 1, a = 1 },
		-- The active filter of that column
		onSoftChrome = { r = F.r, g = F.g, b = F.b, a = 1 },
	}
end

--[[ QIM's own art ]]

-- QIM repaints its fills and 1px edges whenever the theme or a font changes, but it only ever
-- sets their color. The region alpha stays ours.
local function HideFill(frame)
	if frame._qimBg then
		frame._qimBg:SetAlpha(0)
	end
end

local hiddenEdge

-- Some edges are created on first use (the hover border of buttons). QIM takes an existing
-- _qimEdge as is, so those get a set of textures that never shows.
local function GetHiddenEdge()
	if not hiddenEdge then
		hiddenEdge = {}
		for _, key in ipairs({ "t", "b", "l", "r" }) do
			hiddenEdge[key] = E.HiddenFrame:CreateTexture()
		end
	end

	return hiddenEdge
end

local function HideEdge(frame)
	local edge = frame._qimEdge
	if edge then
		for _, texture in pairs(edge) do
			texture:SetAlpha(0)
		end
	else
		frame._qimEdge = GetHiddenEdge()
	end
end

--[[ Windows ]]

-- Main windows, popups, the hover preview and the search strip above the small window
local function SkinHost(frame)
	for _, texture in pairs(frame._qimChrome) do
		texture:SetAlpha(0)
	end

	if not frame.__MERSkinned then
		module:SetBD(frame)
		frame.__MERSkinned = true
	end
end

-- Dropdown list, context menu and tooltip are created on their first use
local function SkinPopup(frame)
	if not frame or frame.__MERSkinned then
		return
	end

	HideFill(frame)
	HideEdge(frame)
	module:SetBD(frame)

	frame.__MERSkinned = true
end

local function SkinDropMenu()
	SkinPopup(_G.QIMDropMenu)
end

--[[ Widgets ]]

local function SkinButton(button)
	HideFill(button)
	HideEdge(button)
	S:HandleButton(button)
end

local function SkinCloseButton(button)
	HideFill(button)
	HideEdge(button)
	-- The "x" glyph, ElvUI brings its own
	button._qimLabel:SetAlpha(0)

	S:HandleCloseButton(button)
	-- ElvUI's insets are made for 32px Blizzard buttons and leave almost nothing to click here
	button:SetHitRectInsets(0, 0, 0, 0)
end

local function ModeButton_OnEnter(button)
	button._qimLabel:SetTextColor(F.r, F.g, F.b)
end

-- Switches between the small and the big window. Keeps its glyph, QIM resets the color on leave.
local function SkinModeButton(button)
	HideFill(button)
	HideEdge(button)
	button:HookScript("OnEnter", ModeButton_OnEnter)
end

local function SkinCheckRow(row)
	local check = row.check
	HideEdge(check)

	check:CreateBackdrop()
	check.backdrop:ClearAllPoints()
	check.backdrop:SetAllPoints(check)
end

-- QIM picks the slider colors by their contrast to its window color, which says nothing about ours
local function PaintSlider(slider)
	slider._qimSliderTrack:SetColorTexture(1, 1, 1, 0.15)
	slider._qimSliderFill:SetColorTexture(F.r, F.g, F.b, 1)

	if slider._qimSliderThumb then
		slider._qimSliderThumb:SetColorTexture(F.r, F.g, F.b, 1)
	end
end

local function SkinSlider(slider)
	slider._qimPaintSlider = PaintSlider
	PaintSlider(slider)
end

local function SkinDropdownRow(row)
	local button = row.button
	SkinButton(button)

	local arrow = button._qimArrow
	arrow:SetTexture(E.Media.Textures.ArrowUp)
	arrow:SetRotation(S.ArrowRotation.down)
	arrow:Size(12)
	arrow:ClearAllPoints()
	arrow:Point("RIGHT", -6, 0)
end

-- Single line boxes are edit boxes, the message input is a frame around one
local function SkinEditBox(edit)
	HideFill(edit)
	HideEdge(edit)

	if not edit.__MERSkinned then
		module:CreateBDFrame(edit, 0.25)
		edit.__MERSkinned = true
	end
end

--[[ List rows ]]

-- Session list, options categories and context menu rows. Names in the session list are class
-- colored, so the selection stays a tint instead of QIM's nearly solid bar.
local function ApplyNavHoverHighlight(texture, shown)
	if not texture then
		return
	end

	if shown then
		texture:SetColorTexture(1, 1, 1, HOVER_ALPHA)
	end
	texture:SetShown(shown and true or false)
end

local function SetNavListTexture(texture, selected, hovering)
	if not texture then
		return
	end

	if selected then
		texture:SetColorTexture(F.r, F.g, F.b, SELECTED_ALPHA)
		texture:Show()
	else
		ApplyNavHoverHighlight(texture, hovering)
	end
end

--[[ Notification button ]]

-- The button on screen that opens QIM. With its border option on it wears Blizzard's chat button art.
local function SkinNotifyButton()
	local QIM = _G.QIM
	local button = QIM.notifyButton
	if not button then
		return
	end

	if not button.backdrop then
		button:CreateBackdrop("Transparent")
		button.backdrop:ClearAllPoints()
		button.backdrop:SetAllPoints(button)
	end

	-- Classic always shows the border, Flat has an option for it
	local opt = QIM.GetOpt()
	local bordered = not QIM.IsFlatUi() or not opt or opt.notifyIconBorder ~= false
	button.backdrop:SetShown(bordered)
	if not bordered then
		return
	end

	button:ClearNormalTexture()
	button:ClearPushedTexture()

	button:SetHighlightTexture(E.media.blankTex)
	local highlight = button:GetHighlightTexture()
	-- Left over from the atlas QIM had on it
	highlight:SetTexCoord(0, 1, 0, 1)
	highlight:SetBlendMode("BLEND")
	highlight:SetVertexColor(1, 1, 1, 0.15)
	highlight:SetInside(button.backdrop)
end

--[[ Factories ]]

-- Skins what a QIM factory function returns
local function HookFactory(flat, name, skin)
	local create = flat[name]
	if not create then
		return
	end

	flat[name] = function(...)
		local widget = create(...)
		if widget then
			skin(widget)
		end

		return widget
	end
end

local function HookFactories(flat)
	-- Close and mode buttons are flat buttons underneath, they get their own look instead of a backdrop
	local plainButton = false

	local createFlatButton = flat.CreateFlatButton
	flat.CreateFlatButton = function(...)
		local plain = plainButton
		plainButton = false

		local button = createFlatButton(...)
		if not plain then
			SkinButton(button)
		end

		return button
	end

	local createCloseButton = flat.CreateCloseButton
	flat.CreateCloseButton = function(...)
		plainButton = true
		local button = createCloseButton(...)
		SkinCloseButton(button)

		return button
	end

	local createModeButton = flat.CreateModeButton
	flat.CreateModeButton = function(...)
		plainButton = true
		local button = createModeButton(...)
		SkinModeButton(button)

		return button
	end

	HookFactory(flat, "CreateCheckRow", SkinCheckRow)
	HookFactory(flat, "CreateSlider", SkinSlider)
	HookFactory(flat, "CreateDropdownRow", SkinDropdownRow)

	local skinEditBox = flat.SkinEditBox
	flat.SkinEditBox = function(edit)
		skinEditBox(edit)
		if edit then
			SkinEditBox(edit)
		end
	end

	-- The list opens from the button's click handler, which this function sets
	local setupDropdownChoices = flat.SetupDropdownChoices
	flat.SetupDropdownChoices = function(row, ...)
		setupDropdownChoices(row, ...)
		if row and row.button then
			row.button:HookScript("OnClick", SkinDropMenu)
		end
	end

	local openContextMenu = flat.OpenContextMenu
	flat.OpenContextMenu = function(...)
		openContextMenu(...)
		SkinPopup(_G.QIMContextMenu)
	end

	local showTip = flat.ShowTip
	flat.ShowTip = function(...)
		showTip(...)
		SkinPopup(_G.QIMHoverTip)
	end

	flat.SetNavListTexture = SetNavListTexture
	flat.ApplyNavHoverHighlight = ApplyNavHoverHighlight
end

function module:QIM()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.qim then
		return
	end

	local QIM = _G.QIM
	local themes = QIM and QIM.Themes
	local flat = QIM and QIM.SkinFlat
	if not (themes and flat and QIM.IsFlatUi) then
		return
	end

	hooksecurefunc(QIM, "ApplyNotifyButtonOptions", SkinNotifyButton)
	SkinNotifyButton()

	-- The Flat factories below are only called while QIM uses its Flat appearance (changing it
	-- reloads the UI). The palette and the window painter are shared with Classic, so those check.
	BuildPalette()

	local resolvePalette = themes.ResolvePalette
	themes.ResolvePalette = function()
		local colors = resolvePalette()
		if QIM.IsFlatUi() then
			for key, color in pairs(palette) do
				colors[key] = color
			end
		end

		return colors
	end

	local paintHost = themes.PaintHost
	themes.PaintHost = function(frame, colors)
		paintHost(frame, colors)
		if frame and frame._qimChrome and QIM.IsFlatUi() then
			SkinHost(frame)
		end
	end

	HookFactories(flat)

	-- Repaints what already exists with the new palette
	if QIM.IsFlatUi() then
		themes.ApplyAll()
	end
end

module:AddCallbackForAddon("QIM")
