local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local WS = W:GetModule("Skins")
local S = E:GetModule("Skins")

local _G = _G
local max = max
local next = next
local unpack = unpack

local CreateColor = CreateColor
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown

--[[
	RestedXP Guides in the MerathilisUI look:
	- the guide window is one panel with a darker header bar and a class colored rule below it
	- the step list is flat, the active steps get a class colored marker and glow
	- active step cards, Active Items, Active Targets and Level Splits share one card style,
	  their title tabs have no border
	- timer bars use the class gradient with a spark

	Supports the legacy window and the V2 window (an RXP beta option), which is picked on load.
	Not touched: Guide Configurator, Guide Importer, feedback/export windows, Leveling Report,
	Active Party Steps and the Auction House upgrades tab.

	Credits: LuckyoneUI, for showing which RXP frames are worth skinning
]]

local RXP -- the AceAddon object of RestedXP Guides

local SPARK = [[Interface\CastingBar\UI-CastingBar-Spark]]

--[[ Shared look ]]

local function UseElvFont(text)
	local _, size, flags = text:GetFont()
	text:SetFont(E.media.normFont, size, flags)
end

local function ClassGradient(texture, alphaFrom, alphaTo)
	texture:SetTexture(E.media.blankTex)
	texture:SetGradient("HORIZONTAL", CreateColor(F.r, F.g, F.b, alphaFrom), CreateColor(F.r, F.g, F.b, alphaTo))
end

-- 1px class colored rule along an edge, fading out to the right
local function AddClassRule(frame, edge)
	local y = edge == "TOP" and -1 or 1

	local rule = frame:CreateTexture(nil, "OVERLAY", nil, 7)
	ClassGradient(rule, 1, 0)
	rule:Height(1)
	rule:Point(edge .. "LEFT", frame, edge .. "LEFT", 1, y)
	rule:Point(edge .. "RIGHT", frame, edge .. "RIGHT", -1, y)

	return rule
end

-- Darker band behind header and footer, so they read as bars on the transparent panel
local function AddTint(frame)
	local tint = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
	tint:SetColorTexture(0, 0, 0, 0.3)
	tint:SetInside(frame, 1, 1)

	return tint
end

-- Class colored glow from the left while hovered, the frame needs mouse input
local function AddHoverGlow(frame)
	local glow = frame:CreateTexture(nil, "HIGHLIGHT")
	glow:SetAllPoints()
	ClassGradient(glow, 0.25, 0)
end

local function HoverBorder_OnEnter(button)
	button:SetBackdropBorderColor(F.r, F.g, F.b)
end

local function HoverBorder_OnLeave(button)
	button:SetBackdropBorderColor(unpack(E.media.bordercolor))
end

local function SetCogIcon(cog)
	cog:SetNormalTexture(I.Media.Icons.Categories.Config)
	cog:GetNormalTexture():SetInside(cog, 2, 2)
end

--[[ Taking over RXP backdrops ]]

-- V2 frames get these child frames from RXP's ApplyFrameBackdrop and AddFrameShadow
local V2_PIECES = { "rxpBackground", "rxpBorder", "rxpShadow" }

local function HideV2Pieces(frame)
	for _, key in next, V2_PIECES do
		local piece = frame[key]
		if piece then
			piece:SetAlpha(0)
		end
	end
end

local function IsRXPBackdrop(info)
	for _, rxpInfo in next, RXP.RXPFrame.backdrop do
		if info == rxpInfo then
			return true
		end
	end
end

-- Legacy frames get their backdrop set again on every theme update
local function Legacy_SetBackdrop(frame, info)
	if IsRXPBackdrop(info) then
		frame:ClearBackdrop()
	end
end

-- Removes RXP's own background, border and shadow from a frame for good
local function Strip(frame)
	if not frame or frame.__MERStripped then
		return
	end

	frame.__MERStripped = true
	HideV2Pieces(frame)

	if frame.ClearBackdrop then
		frame:ClearBackdrop()
		MER:SecureHook(frame, "SetBackdrop", Legacy_SetBackdrop)
	end
end

-- Strips the frame and puts a MerathilisUI panel behind it. RXP keeps coloring its own
-- (now empty) backdrop, so nothing has to be fought on theme updates.
local function TakeOver(frame, template, withShadow, noBorder)
	Strip(frame)

	local panel = frame.__MERPanel
	if panel then
		return panel
	end

	panel = CreateFrame("Frame", nil, frame)
	panel:SetAllPoints()
	panel:SetFrameLevel(max(frame:GetFrameLevel() - 1, 0))

	-- ignoreUpdates keeps ElvUI's media update from putting the border color back
	panel:SetTemplate(template, nil, noBorder)

	if noBorder then
		panel:SetBackdropBorderColor(0, 0, 0, 0)
	end

	if withShadow then
		WS:CreateShadow(panel)
	end

	-- RXP's Hide Background option leaves the V2 background hidden
	local background = frame.rxpBackground
	if background and not background:IsShown() then
		panel:Hide()
	end

	frame.__MERPanel = panel
	return panel
end

-- Card with a borderless title tab sticking out above its top left corner
local function StyleCard(card, tab, tabText)
	local panel = TakeOver(card, "Transparent", true)
	AddClassRule(panel, "TOP")

	-- A bit darker than the card below it, so the tab still stands out
	local tabPanel = TakeOver(tab, "Transparent", false, true)
	local r, g, b = unpack(E.media.backdropfadecolor)
	tabPanel:SetBackdropColor(r, g, b, 0.85)
	UseElvFont(tabText)
end

local function StyleCheckBox(button)
	if button.__MERSkin then
		return
	end

	Strip(button)
	S:HandleCheckBox(button)

	-- RXP's boxes are 12px, the ElvUI inset would leave a 4px square
	button.backdrop:SetAllPoints()
	button:GetCheckedTexture():SetVertexColor(F.r, F.g, F.b, 0.8)

	-- Completed elements are disabled but keep the checked look
	for _, texture in next, { button:GetDisabledCheckedTexture(), button:GetDisabledTexture() } do
		texture:SetAlpha(0)
	end

	button.__MERSkin = true
end

--[[ Step list rows (both windows) ]]

local function StyleListRow(row, number)
	Strip(row)
	Strip(number)

	local divider = row:CreateTexture(nil, "BACKGROUND")
	divider:SetColorTexture(1, 1, 1, 0.06)
	divider:Height(1)
	divider:Point("TOPLEFT", row, "BOTTOMLEFT", 0, -1)
	divider:Point("TOPRIGHT", row, "BOTTOMRIGHT", 0, -1)

	local wash = row:CreateTexture(nil, "BACKGROUND", nil, 1)
	wash:SetAllPoints()
	ClassGradient(wash, 0.15, 0)
	wash:Hide()

	local marker = row:CreateTexture(nil, "ARTWORK")
	marker:SetColorTexture(F.r, F.g, F.b)
	marker:Width(2)
	marker:Point("TOPLEFT")
	marker:Point("BOTTOMLEFT")
	marker:Hide()

	AddHoverGlow(row)

	row.__MERWash = wash
	row.__MERMarker = marker
end

local function SetRowActive(row, numberText, active, inactiveColor)
	row.__MERWash:SetShown(active)
	row.__MERMarker:SetShown(active)

	if active then
		numberText:SetTextColor(F.r, F.g, F.b)
	else
		numberText:SetTextColor(unpack(inactiveColor))
	end
end

--[[ Legacy guide window ]]

local Legacy = {}

function Legacy.RefreshRows()
	local inactive = RXP.activeTheme.textColor

	for _, row in next, RXP.RXPFrame.ScrollChild.framePool do
		if not row.__MERSkin then
			StyleListRow(row, row.number)
			UseElvFont(row.text)
			UseElvFont(row.number.text)
			row.__MERSkin = true
		end

		local step = row.step
		SetRowActive(row, row.number.text, row:IsShown() and step and step.active, inactive)
	end
end

-- Active step cards and their element rows are created in SetStep, which ends in UpdateText
function Legacy.RefreshCards()
	for _, card in next, RXP.RXPFrame.CurrentStepFrame.framePool do
		if not card.__MERSkin then
			StyleCard(card, card.number, card.number.text)
			card.__MERSkin = true
		end

		for _, element in next, card.elements do
			if element.button then
				StyleCheckBox(element.button)
			end
		end
	end
end

-- RXP puts its own arrows, highlight and knob back on every visual update
function Legacy.RestoreScrollBar()
	local scrollBar = RXP.RXPFrame.ScrollFrame.ScrollBar

	for button, textures in next, Legacy.arrows do
		button:SetNormalTexture(textures.normal)
		button:SetPushedTexture(textures.pushed)
		button:SetDisabledTexture(textures.disabled)
		button:GetHighlightTexture():SetTexture(nil)
	end

	scrollBar:GetThumbTexture():SetTexture(nil)
end

function Legacy.Skin()
	local frame = RXP.RXPFrame
	local header, footer, list = frame.GuideName, frame.Footer, frame.BottomFrame

	-- One panel from the header down to the footer instead of three boxes
	local panel = CreateFrame("Frame", nil, frame)
	panel:Point("TOPLEFT", header, "TOPLEFT")
	panel:Point("BOTTOMRIGHT", footer, "BOTTOMRIGHT")
	panel:SetFrameLevel(frame:GetFrameLevel())
	panel:SetTemplate("Transparent")
	WS:CreateShadow(panel)

	Strip(list)
	Strip(header)
	Strip(footer)

	-- Header bar
	header.bg:Hide()
	AddTint(header)
	AddClassRule(header, "BOTTOM")
	UseElvFont(header.text)

	header.icon:Size(30)
	header.icon:ClearAllPoints()
	header.icon:Point("LEFT", header, "LEFT", 4, 0)
	header.classIcon:Size(16)

	-- Footer bar
	footer.bg:Hide()
	AddTint(footer)
	UseElvFont(footer.text)
	footer.text:SetTextColor(0.6, 0.6, 0.6)

	local divider = footer:CreateTexture(nil, "OVERLAY")
	divider:SetColorTexture(1, 1, 1, 0.08)
	divider:Height(1)
	divider:Point("TOPLEFT", footer, "TOPLEFT", 1, -1)
	divider:Point("TOPRIGHT", footer, "TOPRIGHT", -1, -1)

	SetCogIcon(footer.cog)

	-- Scroll bar, remember ElvUI's arrows to put them back after RXP's updates
	local scrollBar = frame.ScrollFrame.ScrollBar
	S:HandleScrollBar(scrollBar)

	Legacy.arrows = {}
	for _, button in next, { scrollBar.ScrollUpButton, scrollBar.ScrollDownButton } do
		Legacy.arrows[button] = {
			normal = button:GetNormalTexture():GetTexture(),
			pushed = button:GetPushedTexture():GetTexture(),
			disabled = button:GetDisabledTexture():GetTexture(),
		}
	end

	Legacy.RestoreScrollBar()
	MER:SecureHook(frame, "UpdateScrollBar", Legacy.RestoreScrollBar)
	MER:SecureHook(frame, "UpdateVisuals", function()
		SetCogIcon(footer.cog)
	end)

	-- Step list and active steps
	Legacy.RefreshRows()
	Legacy.RefreshCards()
	MER:SecureHook(RXP, "LoadGuide", Legacy.RefreshRows)
	MER:SecureHook(RXP, "SetStep", Legacy.RefreshRows)
	MER:SecureHook(frame.CurrentStepFrame, "UpdateText", Legacy.RefreshCards)
end

--[[ V2 guide window (RXP beta option) ]]

local V2 = {}

-- Rows are pooled AceGUI widgets, every instance carries its own copy of SetRow
function V2.Row_SetRow(item)
	local row = item.row
	if row then
		SetRowActive(item.frame, item.number, row.current, RXP.v2:GetTheme().textColor.inactivePartyTab)
	end
end

function V2.RefreshRows(guideSteps)
	for _, item in next, guideSteps.items do
		if not item.__MERSkin then
			StyleListRow(item.frame, item.numberFrame)
			UseElvFont(item.text)
			UseElvFont(item.number)

			MER:SecureHook(item, "SetRow", V2.Row_SetRow)
			item.__MERSkin = true
		end

		V2.Row_SetRow(item)
	end
end

function V2.Card_SetElements(item)
	for _, row in next, item.elementRows do
		local button = row.button
		if button then
			StyleCheckBox(button)

			-- Skip icon on hover, without RXP's border
			Strip(button.rxpHoverFrame)
		end
	end
end

-- Only the player's own cards, the party members' cards keep the party window's look
function V2.RefreshCards(v2, playerState)
	if playerState ~= v2.state.player[RXP.player.name] or not playerState.activeStepItems then
		return
	end

	for _, item in next, playerState.activeStepItems do
		if not item.__MERSkin then
			StyleCard(item.card, item.title, item.titletext)

			V2.Card_SetElements(item)
			MER:SecureHook(item, "SetElements", V2.Card_SetElements)
			item.__MERSkin = true
		end
	end
end

-- RXP tints the arrows with the theme color on every visual refresh
function V2.Scroll_RefreshVisuals(scroll)
	local scrollBar = scroll.scrollbar
	scrollBar.ScrollUpButton:GetNormalTexture():SetVertexColor(1, 1, 1)
	scrollBar.ScrollDownButton:GetNormalTexture():SetVertexColor(1, 1, 1)
end

-- RXP's themed dropdown menus, ElvUI's skinned menu backdrop is used instead
function V2.UpdateMenuTheme(_, listFrame, enabled)
	if not (enabled and listFrame) then
		return
	end

	HideV2Pieces(listFrame)

	local menuBackdrop = _G[listFrame:GetName() .. "MenuBackdrop"]
	if menuBackdrop then
		menuBackdrop:Show()
	end
end

function V2.ApplyFrameBackdrop(_, frame)
	if frame and frame.__MERStripped then
		HideV2Pieces(frame)
	end
end

function V2.SetFrameBackdropShown(_, frame, shown)
	local panel = frame and frame.__MERPanel
	if panel then
		panel:SetShown(shown)
	end
end

function V2.Skin()
	local v2 = RXP.v2
	local window = v2:GetGuideWindow()
	if not window then
		return
	end

	-- Every later ApplyFrameBackdrop on a frame we took over is hidden again
	local ui = RXP.ui.v2
	MER:SecureHook(ui, "ApplyFrameBackdrop", V2.ApplyFrameBackdrop)
	MER:SecureHook(ui, "AddFrameShadow", V2.ApplyFrameBackdrop)
	MER:SecureHook(ui, "SetFrameBackdropShown", V2.SetFrameBackdropShown)
	MER:SecureHook(v2, "UpdateMenuTheme", V2.UpdateMenuTheme)

	-- Header bar
	local header = window.upperFrame
	local headerPanel = TakeOver(header, "Transparent", true)
	AddTint(headerPanel)
	AddClassRule(headerPanel, "BOTTOM")
	Strip(window.guideNameFrame)
	window.banner:SetAlpha(0)
	S:HandleCloseButton(window.closebutton, header)

	UseElvFont(window.title)
	UseElvFont(window.subtitle)

	-- Step list, its top border tucks under the header's rule
	local list = window.guideStepsFrame
	local listPanel = TakeOver(list, "Transparent", true)
	listPanel:ClearAllPoints()
	listPanel:Point("TOPLEFT", list, "TOPLEFT", 0, E.Border)
	listPanel:Point("BOTTOMRIGHT", list)

	window.footerBackground:SetAlpha(0)
	UseElvFont(window.footerText)
	window.footerText:SetTextColor(0.6, 0.6, 0.6)

	local guideSteps = window.guideSteps
	local scroll = guideSteps.scroll
	S:HandleScrollBar(scroll.scrollbar)
	scroll.scrollbg:SetAlpha(0)
	V2.Scroll_RefreshVisuals(scroll)
	MER:SecureHook(scroll, "RefreshVisuals", V2.Scroll_RefreshVisuals)

	V2.RefreshRows(guideSteps)
	MER:SecureHook(guideSteps, "SetRows", V2.RefreshRows)

	-- Cards RXP built during its own initialization
	local playerState = v2.state.player[RXP.player.name]
	if playerState then
		V2.RefreshCards(v2, playerState)
	end
	MER:SecureHook(v2, "ReconcileActiveStepItems", V2.RefreshCards)
end

--[[ Active Items and Active Targets ]]

local IconFrames = {}

-- The buttons are secure, RXP only creates and updates them out of combat
local function StyleIconButton(button)
	if button.__MERSkin then
		return
	end

	for _, region in next, { button:GetRegions() } do
		if region:IsObjectType("Texture") and region:GetDrawLayer() == "HIGHLIGHT" then
			region:SetAlpha(0)
		end
	end

	button:SetTemplate()
	button.Center:SetDrawLayer("BACKGROUND", -1)
	button:HookScript("OnEnter", HoverBorder_OnEnter)
	button:HookScript("OnLeave", HoverBorder_OnLeave)

	local cooldown = button.cooldown
	if cooldown then
		cooldown:SetInside(button)
		E:RegisterCooldown(cooldown)
	end

	button.__MERSkin = true
end

-- RXP anchors icons and cached portraits to the full button on every update
local function CropIcon(button)
	local icon = button.icon
	if icon and icon.SetTexCoord then
		icon:SetTexCoord(unpack(E.TexCoords))
		icon:SetInside(button)
	end
end

function IconFrames.UpdateItems()
	if InCombatLockdown() then
		return
	end

	for _, button in next, RXP.activeItemFrame.buttonList do
		StyleIconButton(button)
		CropIcon(button)
	end
end

function IconFrames.UpdateTargets(targeting)
	if InCombatLockdown() then
		return
	end

	local frame = targeting.activeTargetFrame
	for _, buttons in next, { frame.enemyTargetButtons, frame.friendlyTargetButtons } do
		for _, button in next, buttons do
			StyleIconButton(button)
			CropIcon(button)
		end
	end
end

-- Legacy icon frames clear their backdrop for RXP's Hide Background option
local function IconFrame_UpdateVisuals(frame)
	if not frame.v2 then
		frame.__MERPanel:SetShown(not RXP.settings.profile.activeItemHideBG)
	end

	UseElvFont(frame.title.text)
end

function IconFrames.Skin()
	local itemFrame = RXP.activeItemFrame
	local targetFrame = RXP.targeting.activeTargetFrame

	for _, frame in next, { itemFrame, targetFrame } do
		StyleCard(frame, frame.title, frame.title.text)
		IconFrame_UpdateVisuals(frame)
		MER:SecureHook(frame, "UpdateVisuals", IconFrame_UpdateVisuals)
	end

	IconFrames.UpdateItems()
	MER:SecureHook(RXP, "UpdateItemFrame", IconFrames.UpdateItems)

	-- The item frame calls the original function through its own UpdateFrame field
	MER:SecureHook(itemFrame, "UpdateFrame", IconFrames.UpdateItems)

	IconFrames.UpdateTargets(RXP.targeting)
	MER:SecureHook(RXP.targeting, "UpdateTargetFrame", IconFrames.UpdateTargets)
end

--[[ Timer bars ]]

-- The bars come from a LibCandyBar pool shared with other addons, so every
-- change is undone when the bar is stopped
local Timers = { sparks = {}, active = {} }

function Timers.Start(_, label)
	local bar = RXP.RXPFrame.BarContainer.bars[label or ""]
	if not bar then
		return
	end

	bar:SetTexture(E.media.normTex)
	UseElvFont(bar.candyBarLabel)
	UseElvFont(bar.candyBarDuration)

	local left, right = F.GradientColors(E.myclass)
	local statusBar = bar.candyBarBar:GetStatusBarTexture()
	statusBar:SetGradient(
		"HORIZONTAL",
		CreateColor(left.r, left.g, left.b, left.a),
		CreateColor(right.r, right.g, right.b, right.a)
	)

	bar.candyBarIconFrame:SetTexCoord(unpack(E.TexCoords))

	local backdrop = bar.candyBarBackdrop
	backdrop:SetTemplate("Transparent", nil, true, true)
	backdrop:SetOutside(bar)
	backdrop:Show()

	local spark = Timers.sparks[bar]
	if not spark then
		spark = bar.candyBarBar:CreateTexture(nil, "OVERLAY")
		spark:SetTexture(SPARK)
		spark:SetBlendMode("ADD")
		spark:Point("CENTER", statusBar, "RIGHT")
		Timers.sparks[bar] = spark
	end
	spark:Size(8, bar:GetHeight() * 2)
	spark:Show()

	Timers.active[bar] = true
end

function Timers.Stop(_, bar)
	if not Timers.active[bar] then
		return
	end

	Timers.active[bar] = nil
	Timers.sparks[bar]:Hide()
	bar.candyBarBackdrop:Hide()
	bar.candyBarIconFrame:SetTexCoord(0, 1, 0, 1)
end

--[[ Level Splits ]]

local function Tracker_CreateLevelSplits(tracker)
	local frame = tracker.levelSplits
	if not frame or frame.__MERSkin then
		return
	end

	StyleCard(frame, frame.title, frame.title.text)
	SetCogIcon(frame.title.cog)

	frame.__MERSkin = true
end

--[[ Fonts ]]

local function Theme_Load()
	RXP.font = E.media.normFont
end

-- V2 texts read the font from the theme tables, which RXP builds again from the legacy themes
local function Themes_Convert()
	for _, theme in next, RXP.v2.themes do
		theme.font = E.media.normFont
	end
end

local function SkinFonts()
	Theme_Load()
	MER:SecureHook(RXP, "LoadActiveTheme", Theme_Load)

	Themes_Convert()
	MER:SecureHook(RXP.v2, "ConvertThemes", Themes_Convert)

	-- Texts RXP already created with its own font
	RXP.UpdateGuideFontSize()
	UseElvFont(RXP.arrowFrame.text)
end

--[[ Buttons RXP adds to Blizzard frames ]]

local function Talents_UpdateButton(talents)
	local button = talents.talentsButton
	if not button or button.__MERSkin then
		return
	end

	button.bg:Hide()
	button.bg.ht:Hide()

	button:SetTemplate()
	button:StyleButton(nil, true)

	local icon = button:GetNormalTexture()
	icon:SetInside()
	icon:SetTexCoord(unpack(E.TexCoords))

	button.__MERSkin = true
end

local function SkinBlizzardAdditions()
	local blizzard = E.private.skins.blizzard
	if not blizzard.enable then
		return
	end

	-- Quest log cleanup button below Abandon
	local cleanupButton = _G.RXPQuestLogCleanupButton
	if cleanupButton and (E.Forever and blizzard.quest or blizzard.worldmap) then
		S:HandleButton(cleanupButton)
	end

	-- Talent guides button below the spec tabs, Classic flavors and Forever only
	local talents = RXP.talents
	if talents and talents.UpdateTalentsButton and blizzard.talent then
		Talents_UpdateButton(talents)
		MER:SecureHook(talents, "UpdateTalentsButton", Talents_UpdateButton)
	end
end

function module:RXPGuides()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.rxp then
		return
	end

	-- RXP builds all its frames in OnInitialize, which runs before this callback
	RXP = E.Libs.AceAddon:GetAddon("RXPGuides", true)
	if not RXP or not RXP.v2 then
		return
	end

	SkinFonts()

	if RXP.v2:IsGuideWindowEnabled() then
		V2.Skin()
	else
		Legacy.Skin()
	end

	IconFrames.Skin()

	MER:SecureHook(RXP, "StartTimer", Timers.Start)
	LibStub("LibCandyBar-3.0").RegisterCallback(Timers, "LibCandyBar_Stop", Timers.Stop)

	local tracker = RXP.tracker
	if tracker then
		Tracker_CreateLevelSplits(tracker)
		MER:SecureHook(tracker, "CreateLevelSplits", Tracker_CreateLevelSplits)
	end

	SkinBlizzardAdditions()
end

module:AddCallbackForAddon("RXPGuides")
