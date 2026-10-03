local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local PI = E:GetModule("PluginInstaller")
local PF = MER:GetModule("MER_Profiles")
local Splash = MER:GetModule("MER_SplashScreen")

-- The MerathilisUI installer: pages for ElvUI's PluginInstaller, drawn with our
-- own header, cards and switches instead of the stock texts and option buttons.
-- ElvUI's frame, step list, Previous/Continue buttons and progress bar stay; the
-- step list marks every step applied in this session with a check.
-- The settings the steps write live in Install.lua.
--
-- This file loads before Media/, so every I.Media lookup happens at runtime.

local _G = _G
local abs, format, ipairs, max, next, pairs, strmatch = abs, format, ipairs, max, next, pairs, strmatch
local strtrim, strupper, tonumber, tostring, type, unpack = strtrim, strupper, tonumber, tostring, type, unpack
local geterrorhandler, xpcall = geterrorhandler, xpcall
local tinsert, wipe = table.insert, table.wipe

local CreateFrame = CreateFrame
local GameTooltip = GameTooltip
local PlaySound = PlaySound
local GetAddOnMetadata = C_AddOns.GetAddOnMetadata
local C_UI_Reload = C_UI.Reload
local ACCEPT, CANCEL, OKAY = ACCEPT, CANCEL, OKAY

local FRAME_WIDTH = 860
local FRAME_HEIGHT = 540
local HEADER_TOP = 38
local BODY_TOP = 165 -- the page body starts below eyebrow, title and two lines of description
local BODY_BOTTOM = 45 -- room for Previous/Continue and the progress bar
local BODY_INSET = 40
local BODY_WIDTH = FRAME_WIDTH - BODY_INSET * 2
local PADDING = 12
local GAP = 12

local LOGO = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\merathilis_logo.tga]]
local PREVIEW_PATH = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\Install\]]
local WEBSITE_IMAGE = PREVIEW_PATH .. "Website.tga"
-- The previews are full screenshots, the cards show the unit frames and action bars
local PREVIEW_COORDS = { 0.22, 0.78, 0.55, 0.95 }

local COLOR_ACCENT = { I.Colors.Accent.r, I.Colors.Accent.g, I.Colors.Accent.b }
local COLOR_CARD = { 0.06, 0.06, 0.06, 0.85 }
local COLOR_CARD_HOVER = { I.Colors.Accent.r * 0.15, I.Colors.Accent.g * 0.15, I.Colors.Accent.b * 0.15, 0.9 }
local COLOR_BUTTON = { 0.16, 0.16, 0.16, 1 }
local COLOR_BORDER = { 1, 1, 1, 0.08 }
local COLOR_KNOB = { 0.92, 0.92, 0.92, 1 }
local COLOR_MUTED = { 0.62, 0.62, 0.62 }
local COLOR_WARNING = { 1, 0.7, 0.2 }
local COLOR_STEP = { 0.55, 0.55, 0.55 }

local SOUND_CLICK = 852 -- SOUNDKIT.IG_MAINMENU_OPTION

-- What was applied in this session, for the check marks and the summary
local state = { addons = {} }

local function ResetState()
	wipe(state)
	state.addons = {}
end

local steps = {}
local builtPages = {}
local activeStep, activePage

--[[----------------------------------
--	Widgets
--]]
----------------------------------
local function CreatePanel(parent, frameType)
	-- Our own backdrop instead of SetTemplate: ElvUI's template sweep would
	-- reset the hover and applied colors painted on it
	local panel = CreateFrame(frameType or "Frame", nil, parent, "BackdropTemplate")
	panel:SetBackdrop({ bgFile = E.media.blankTex, edgeFile = E.media.blankTex, edgeSize = E.mult })
	panel:SetBackdropColor(unpack(COLOR_CARD))
	panel:SetBackdropBorderColor(unpack(COLOR_BORDER))
	return panel
end

local function CreateText(parent, size, color, justify)
	local text = parent:CreateFontString(nil, "OVERLAY")
	text:FontTemplate(nil, size)
	text:SetJustifyH(justify or "CENTER")
	if color then
		text:SetTextColor(unpack(color))
	end
	return text
end

local function ShowTooltip(owner, text)
	GameTooltip:SetOwner(owner, "ANCHOR_TOP", 0, 4)
	GameTooltip:AddLine(text, 1, 1, 1, true)
	GameTooltip:Show()
end

-- Centers a row of widgets in the page body, each keeps its own width
local function LayoutRow(page, widgets, y, gap)
	gap = gap or GAP
	local total = -gap
	for _, widget in ipairs(widgets) do
		total = total + widget:GetWidth() + gap
	end

	local x = (BODY_WIDTH - total) / 2
	for _, widget in ipairs(widgets) do
		widget:ClearAllPoints()
		widget:SetPoint("TOPLEFT", page, "TOPLEFT", x, y)
		x = x + widget:GetWidth() + gap
	end
end

-- Cards: the clickable choices of a page, with a check once applied
local function Card_UpdateVisual(card)
	local enabled = card:IsEnabled()
	local hover = card.hover and enabled

	card:SetBackdropColor(unpack(hover and COLOR_CARD_HOVER or COLOR_CARD))
	if hover then
		card:SetBackdropBorderColor(COLOR_ACCENT[1], COLOR_ACCENT[2], COLOR_ACCENT[3], 1)
	elseif card.applied then
		card:SetBackdropBorderColor(COLOR_ACCENT[1], COLOR_ACCENT[2], COLOR_ACCENT[3], 0.5)
	else
		card:SetBackdropBorderColor(unpack(COLOR_BORDER))
	end

	card.accent:SetShown(card.applied)
	card.check:SetShown(card.applied)
	card:SetAlpha(enabled and 1 or 0.5)
end

local function Card_SetApplied(card, applied)
	card.applied = applied and true or false
	Card_UpdateVisual(card)
end

local function Card_OnEnter(card)
	card.hover = true
	Card_UpdateVisual(card)
	if card.tooltip then
		ShowTooltip(card, card.tooltip)
	end
end

local function Card_OnLeave(card)
	card.hover = nil
	Card_UpdateVisual(card)
	GameTooltip:Hide()
end

local function Card_OnClick(card)
	PlaySound(SOUND_CLICK)
	card.onClick(card)
end

-- data: title, desc, tag, value (big number line), image + imageHeight + texCoord, icon, tooltip, onClick
-- An empty tag still reserves its line, so cards in one row keep their titles aligned
local function CreateCard(parent, width, height, data)
	local card = CreatePanel(parent, "Button")
	card:SetSize(width, height)
	card.onClick = data.onClick
	card.tooltip = data.tooltip
	card.SetApplied = Card_SetApplied
	card:SetScript("OnEnter", Card_OnEnter)
	card:SetScript("OnLeave", Card_OnLeave)
	card:SetScript("OnClick", Card_OnClick)

	local inset = E.mult
	local top = PADDING
	if data.image then
		card.image = card:CreateTexture(nil, "ARTWORK")
		card.image:SetPoint("TOPLEFT", inset, -inset)
		card.image:SetPoint("TOPRIGHT", -inset, -inset)
		card.image:SetHeight(data.imageHeight)
		card.image:SetTexture(data.image)
		if data.texCoord then
			card.image:SetTexCoord(unpack(data.texCoord))
		end
		top = data.imageHeight + 10
	end

	card.accent = card:CreateTexture(nil, "OVERLAY")
	card.accent:SetPoint("TOPLEFT", inset, -inset)
	card.accent:SetPoint("TOPRIGHT", -inset, -inset)
	card.accent:SetHeight(2)
	card.accent:SetColorTexture(unpack(COLOR_ACCENT))

	card.check = card:CreateTexture(nil, "OVERLAY")
	card.check:SetSize(16, 16)
	card.check:SetPoint("TOPRIGHT", -8, -8)
	card.check:SetTexture(I.Media.Icons.Ok)

	local left = PADDING
	if data.icon then
		card.icon = card:CreateTexture(nil, "ARTWORK")
		card.icon:SetSize(28, 28)
		card.icon:SetPoint("LEFT", PADDING, 0)
		left = PADDING + 28 + 10
	end

	if data.tag then
		card.tag = CreateText(card, 10, COLOR_ACCENT, "LEFT")
		card.tag:SetPoint("TOPLEFT", left, -top)
		card.tag:SetText(strupper(data.tag))
		top = top + 16
	end

	if data.value then
		card.value = CreateText(card, 22, nil, "LEFT")
		card.value:SetPoint("TOPLEFT", left, -top)
		card.value:SetText(data.value)
		top = top + 32
	end

	card.title = CreateText(card, 14, nil, "LEFT")
	card.title:SetWidth(width - left - 30) -- leaves room for the check
	card.title:SetWordWrap(false)
	card.title:SetText(data.title)

	card.desc = CreateText(card, 11, COLOR_MUTED, "LEFT")
	card.desc:SetWidth(width - left - PADDING)
	card.desc:SetJustifyV("TOP")
	card.desc:SetWordWrap(true)
	card.desc:SetText(data.desc or "")

	if data.icon then
		card.title:SetPoint("BOTTOMLEFT", card, "LEFT", left, 1)
		card.desc:SetPoint("TOPLEFT", card, "LEFT", left, -3)
	else
		card.title:SetPoint("TOPLEFT", left, -top)
		card.desc:SetPoint("TOPLEFT", card.title, "BOTTOMLEFT", 0, -5)
	end

	Card_UpdateVisual(card)
	return card
end

-- Buttons: flat, the primary one filled with the accent color
local function Button_UpdateVisual(button)
	if button.primary then
		local mult = button.hover and 1 or 0.75
		button:SetBackdropColor(COLOR_ACCENT[1] * mult, COLOR_ACCENT[2] * mult, COLOR_ACCENT[3] * mult, 1)
		button:SetBackdropBorderColor(COLOR_ACCENT[1], COLOR_ACCENT[2], COLOR_ACCENT[3], 1)
	elseif button.hover then
		button:SetBackdropColor(unpack(COLOR_CARD_HOVER))
		button:SetBackdropBorderColor(COLOR_ACCENT[1], COLOR_ACCENT[2], COLOR_ACCENT[3], 1)
	else
		button:SetBackdropColor(unpack(COLOR_BUTTON))
		button:SetBackdropBorderColor(unpack(COLOR_BORDER))
	end
end

local function Button_OnEnter(button)
	button.hover = true
	Button_UpdateVisual(button)
	if button.tooltip then
		ShowTooltip(button, button.tooltip)
	end
end

local function Button_OnLeave(button)
	button.hover = nil
	Button_UpdateVisual(button)
	GameTooltip:Hide()
end

local function Button_OnClick(button)
	PlaySound(SOUND_CLICK)
	button.onClick(button)
end

local function CreateButton(parent, text, width, primary, onClick, tooltip)
	local button = CreatePanel(parent, "Button")
	button:SetSize(width, 30)
	button.primary = primary
	button.onClick = onClick
	button.tooltip = tooltip
	button:SetScript("OnEnter", Button_OnEnter)
	button:SetScript("OnLeave", Button_OnLeave)
	button:SetScript("OnClick", Button_OnClick)

	button.text = CreateText(button, 13)
	button.text:SetPoint("CENTER")
	button.text:SetText(text)

	Button_UpdateVisual(button)
	return button
end

-- Switches: same look as the toggles in the options
local function Switch_SetChecked(switch, checked)
	switch.checked = checked and true or false
	switch.knob:ClearAllPoints()
	if switch.checked then
		switch.track:SetBackdropColor(COLOR_ACCENT[1], COLOR_ACCENT[2], COLOR_ACCENT[3], 1)
		switch.knob:SetPoint("RIGHT", -2, 0)
	else
		switch.track:SetBackdropColor(unpack(COLOR_BUTTON))
		switch.knob:SetPoint("LEFT", 2, 0)
	end
end

local function Switch_OnEnter(switch)
	switch.label:SetTextColor(unpack(COLOR_ACCENT))
	if switch.tooltip then
		ShowTooltip(switch, switch.tooltip)
	end
end

local function Switch_OnLeave(switch)
	switch.label:SetTextColor(1, 1, 1)
	GameTooltip:Hide()
end

local function Switch_OnClick(switch)
	PlaySound(SOUND_CLICK)
	switch:SetChecked(not switch.checked)
	if switch.onToggle then
		switch.onToggle(switch, switch.checked)
	end
end

local function CreateSwitch(parent, label, width, onToggle, tooltip)
	local switch = CreateFrame("Button", nil, parent)
	switch:SetSize(width, 20)
	switch.onToggle = onToggle
	switch.tooltip = tooltip
	switch.SetChecked = Switch_SetChecked
	switch:SetScript("OnEnter", Switch_OnEnter)
	switch:SetScript("OnLeave", Switch_OnLeave)
	switch:SetScript("OnClick", Switch_OnClick)

	switch.track = CreatePanel(switch)
	switch.track:SetSize(30, 16)
	switch.track:SetPoint("LEFT")

	switch.knob = switch.track:CreateTexture(nil, "OVERLAY")
	switch.knob:SetSize(12, 12)
	switch.knob:SetColorTexture(unpack(COLOR_KNOB))

	switch.label = CreateText(switch, 12, nil, "LEFT")
	switch.label:SetPoint("LEFT", switch.track, "RIGHT", 8, 0)
	switch.label:SetText(label)

	switch:SetChecked(false)
	return switch
end

-- Links: small accent text buttons
local function Link_OnEnter(link)
	link.text:SetTextColor(1, 1, 1)
end

local function Link_OnLeave(link)
	link.text:SetTextColor(unpack(COLOR_ACCENT))
end

local function Link_OnClick(link)
	PlaySound(SOUND_CLICK)
	link.onClick(link)
end

local function CreateLink(parent, text, onClick)
	local link = CreateFrame("Button", nil, parent)
	link.onClick = onClick
	link.text = CreateText(link, 11, COLOR_ACCENT)
	link.text:SetPoint("CENTER")
	link.text:SetText(text)
	link:SetSize(link.text:GetStringWidth() + 4, 16)
	link:SetScript("OnEnter", Link_OnEnter)
	link:SetScript("OnLeave", Link_OnLeave)
	link:SetScript("OnClick", Link_OnClick)
	return link
end

--[[----------------------------------
--	Step list and page switching
--]]
----------------------------------
local function StepTitle(index)
	local step = steps[index]
	if step.done and step.done() then
		-- ElvUI colors the whole line, the current one in the accent color
		local title = PluginInstallFrame.CurrentPage == index and step.title or "|cffffffff" .. step.title .. "|r"
		return F.GetIconString(I.Media.Icons.Ok, 14) .. " " .. title
	end

	return format("%d. %s", index, step.title)
end

-- ElvUI only writes the step list when the page changes
local function RefreshSteps()
	local frame = PluginInstallFrame
	if not frame.StepTitles then
		return
	end

	for i, line in ipairs(frame.side.Lines) do
		if frame.StepTitles[i] then
			line.text:SetText(StepTitle(i))
		end
	end
end

local function RefreshPage()
	if activeStep and activeStep.update then
		activeStep.update(activePage)
	end
	RefreshSteps()
end

-- Moves on when the player is still on the step that triggered it
local function NextPageFrom(key)
	if PluginInstallFrame:IsShown() and activeStep and activeStep.key == key then
		PI:NextPage()
	end
end

-- Everything we add to ElvUI's shared frame has to go when our installer closes,
-- otherwise the next plugin in the queue inherits it
local function Installer_OnHide(frame)
	if not frame.merHeader:IsShown() then
		return
	end

	frame.merHeader:Hide()
	frame.merBody:Hide()
	PluginInstallTutorialImage:Show()

	activeStep, activePage = nil, nil
	ResetState()
end

local function SetupFrame(frame)
	frame:SetSize(FRAME_WIDTH, FRAME_HEIGHT)

	if not frame.merHeader then
		local header = CreateFrame("Frame", nil, frame)
		header:SetPoint("TOPLEFT", BODY_INSET, -HEADER_TOP)
		header:SetPoint("TOPRIGHT", -BODY_INSET, -HEADER_TOP)
		header:SetHeight(BODY_TOP - HEADER_TOP)

		header.eyebrow = CreateText(header, 11, COLOR_ACCENT)
		header.eyebrow:SetPoint("TOP", 0, -6)

		header.title = CreateText(header, 24)
		header.title:SetPoint("TOP", header.eyebrow, "BOTTOM", 0, -6)

		header.desc = CreateText(header, 12, COLOR_MUTED)
		header.desc:SetPoint("TOP", header.title, "BOTTOM", 0, -10)
		header.desc:SetWidth(660)
		header.desc:SetWordWrap(true)

		local body = CreateFrame("Frame", nil, frame)
		body:SetPoint("TOPLEFT", BODY_INSET, -BODY_TOP)
		body:SetPoint("BOTTOMRIGHT", -BODY_INSET, BODY_BOTTOM)

		frame.merHeader = header
		frame.merBody = body
		frame:HookScript("OnHide", Installer_OnHide)
	end

	frame.merHeader:Show()
	frame.merBody:Show()
	PluginInstallTutorialImage:Hide()
end

local function Resolve(value)
	if type(value) == "function" then
		return value()
	end
	return value
end

-- Runs as the page function: ElvUI has just reset its own texts and buttons
local function ShowStep(index)
	local frame = PluginInstallFrame
	local step = steps[index]
	SetupFrame(frame)

	local header = frame.merHeader
	header.eyebrow:SetText(strupper(format(L["Step %d of %d"], index, #steps)))
	header.title:SetText(Resolve(step.heading) or step.title)
	header.desc:SetText(Resolve(step.desc) or "")

	for _, page in pairs(builtPages) do
		page:Hide()
	end

	local page = builtPages[step.key]
	if not page then
		page = CreateFrame("Frame", nil, frame.merBody)
		page:SetAllPoints()
		step.build(page)
		builtPages[step.key] = page
	end

	activeStep, activePage = step, page
	page:Show()
	if step.update then
		step.update(page)
	end
end

--[[----------------------------------
--	Actions
--]]
----------------------------------
function MER:ShowStepCompleteHook()
	local stepComplete = _G["PluginInstallStepComplete"]

	if not self:IsHooked(stepComplete, "OnShow") then
		stepComplete.bg:SetVertexColor(0, 0, 0, 0.75)
		stepComplete.lineTop:SetVertexColor(0, 0, 0, 1)
		stepComplete.lineBottom:SetVertexColor(0, 0, 0, 1)

		self:RawHookScript(stepComplete, "OnShow", function(frame)
			if frame.message then
				PlaySound(888)

				-- Set Text
				frame.text:SetText(frame.message)

				E:UIFrameFadeOut(frame, 0.25, 0, 1)

				E:Delay(2.5, function()
					E:UIFrameFadeOut(frame, 0.25, 1, 0)
				end)

				E:Delay(4, function()
					if frame:GetAlpha() <= 0 then
						frame:Hide()
					end
				end)

				frame.message = nil
			else
				frame:Hide()
			end
		end)
	end
end

function MER:ShowStepComplete(step)
	step = "|cccffffff" .. step .. "|r"

	self:ShowStepCompleteHook()

	local stepComplete = _G["PluginInstallStepComplete"]
	stepComplete:Hide()
	stepComplete.message = step
	stepComplete:Show()
end

-- The layout step sets the layout version, finishing only marks the profile
-- as installed, so a run without the layout step keeps reporting an old layout
local function InstallComplete()
	E.private.install_complete = E.version
	E.db.mui.core.installed = true
	E.private.mui.general.install_complete = MER.Version

	C_UI_Reload()
end

-- Only stops the installer from opening on every login, nothing is applied
local function SkipInstaller()
	E.db.mui.core.installed = true
	PI:CloseInstall()
end

local function CreateNewProfile(name)
	if strtrim(name) == "" then
		return
	end

	if E.data:IsDualSpecEnabled() then
		E.data:SetDualSpecProfile(name)
	else
		E.data:SetProfile(name)
	end

	state.profile = "new"
	MER:ShowStepComplete(MER.Title .. L["Profile Created"])
	NextPageFrom("profile")
end

local function ShowProfileDialog()
	local textInfo = L["Name for the new profile"]
	local errorInfo = L["A profile with that name already exists."]
	local dialogName = "MER_CreateNewProfile"

	E.PopupDialogs[dialogName] = {
		text = textInfo,
		timeout = 0,
		hasEditBox = 1,
		whileDead = 1,
		hideOnEscape = 1,
		editBoxWidth = 350,
		maxLetters = 127,
		OnShow = function(frame)
			frame.editBox:SetAutoFocus(false)
			frame.editBox:SetText(E.mynameRealm)
			frame.editBox:HighlightText()
		end,
		button1 = OKAY,
		button2 = CANCEL,
		OnAccept = function(frame)
			CreateNewProfile(frame.editBox:GetText())
		end,
		EditBoxOnEnterPressed = function(editBox)
			CreateNewProfile(editBox:GetText())
			editBox:GetParent():Hide()
		end,
		EditBoxOnEscapePressed = function(editBox)
			editBox:GetParent():Hide()
		end,
		EditBoxOnTextChanged = function(editBox)
			if strtrim(editBox:GetText()) == "" then
				editBox:GetParent().button1:Disable()
			else
				editBox:GetParent().button1:Enable()

				local parent = editBox:GetParent()
				local textObj = _G[parent:GetName() .. "Text"]

				local profs = E.data:GetProfiles()
				for _, name in ipairs(profs) do
					if name == editBox:GetText() then
						textObj:SetText(textInfo .. "\n\n" .. F.String.Warning(errorInfo))

						parent.maxHeightSoFar = 0
						E:StaticPopup_Resize(parent, dialogName)
						return
					end
				end

				textObj:SetText(textInfo)

				parent.maxHeightSoFar = 0
				E:StaticPopup_Resize(parent, dialogName)
			end
		end,
		OnEditFocusGained = function(editBox)
			editBox:HighlightText()
		end,
	}

	E:StaticPopup_Show(dialogName)
end

-- Layout versions are display versions ("7.39", "7.40-beta-2"), compared by their number
local function VersionNumber(version)
	return tonumber(strmatch(tostring(version or ""), "^%d+%.?%d*")) or 0
end

-- The newest MerathilisUI profile of this account and the newest private
-- settings of another character, so an alt can take both over in one click
local function FindImportProfiles()
	local public, private

	for name, data in pairs(E.data.profiles) do
		local version = data.mui and data.mui.core and data.mui.core.lastLayoutVersion
		if VersionNumber(version) > 0 and (not public or VersionNumber(version) > VersionNumber(public.version)) then
			public = { name = name, version = version }
		end
	end

	local currentChar = E.charSettings:GetCurrentProfile()
	for name, data in pairs(E.charSettings.profiles) do
		local version = name ~= currentChar and data.mui and data.mui.general and data.mui.general.install_complete
		if version and (not private or VersionNumber(version) > VersionNumber(private.version)) then
			private = { name = name, version = version }
		end
	end

	if not (public and private) then
		return
	end

	-- Nothing to take over when this character already runs that profile
	if public.name == E.data:GetCurrentProfile() and E.private.mui.general.install_complete then
		return
	end

	return { public = public, private = private }
end

local function ImportProfiles(profiles)
	E.data:SetProfile(profiles.public.name)

	-- Copied by hand, the copy callbacks of ElvUI's private db would reload right away
	local source = E.charSettings.profiles[profiles.private.name]
	if source then
		F.Table.Crush(E.private, E:CopyTable({}, source))
	end

	InstallComplete()
end

local function ShowImportPopup(profiles)
	E.PopupDialogs.MER_IMPORT_PROFILES = {
		text = format(
			L["Use the MerathilisUI profile %s (layout %s) and the settings of %s for this character? The UI reloads afterwards."],
			F.String.MERATHILISUI(profiles.public.name),
			profiles.public.version,
			F.String.MERATHILISUI(profiles.private.name)
		),
		button1 = ACCEPT,
		button2 = CANCEL,
		OnAccept = function()
			ImportProfiles(profiles)
		end,
		timeout = 0,
		whileDead = 1,
		hideOnEscape = 1,
	}

	E:StaticPopup_Show("MER_IMPORT_PROFILES")
end

local function ApplyScale(card)
	E.global.general.UIScale = card.scaleValue
	E:PixelScaleChanged()

	state.scale = card.scaleValue
	RefreshPage()
end

local function WriteLayout(layout)
	E.db.mui.core.lastLayoutVersion = MER.DisplayVersion

	MER:SetupLayout()
	MER:SetupChat()
	MER:SetupDts()
	MER:SetupActionbars()
	MER:SetupNamePlates()
	MER:SetupUnitframes(layout)
	if state.cvars ~= false then
		MER:SetupCVars()
	end
end

-- All former layout steps at once, behind the splash screen, with one ElvUI update
local function ApplyLayout(layout)
	if state.applying then
		return
	end
	state.applying = true

	local function Finish(applied)
		Splash:Hide()
		state.applying = nil

		if applied then
			state.layout = layout
			MER:ShowStepComplete(MER.Title .. L["Layout Set"])
			RefreshPage()
			NextPageFrom("layout")
		end
	end

	Splash:Wrap(L["Installing ..."], function()
		-- The splash blocks the mouse until it hides, an error must not leave it up
		if not xpcall(WriteLayout, geterrorhandler(), layout) then
			Finish(false)
			return
		end

		-- E:UpdateAll spreads the module updates over a few frames, wait until they started
		E:UpdateAll()
		F.Event.RunNextFrame(function()
			F.Event.ContinueAfterElvUIUpdate(function()
				Finish(true)
			end)
		end, 0.3)
	end, true)
end

local function ApplyAddOnProfile(card)
	PF[card.method](PF)
	state.addons[card.addon] = true
	RefreshPage()
end

local function GetAddOnIcon(addon)
	local iconTexture = GetAddOnMetadata(addon, "IconTexture")
	local iconAtlas = GetAddOnMetadata(addon, "IconAtlas")
	if iconTexture then
		return iconTexture
	elseif iconAtlas then
		return nil, iconAtlas
	end
	return [[Interface\ICONS\INV_Misc_QuestionMark]]
end

--[[----------------------------------
--	Modules page data
--]]
----------------------------------
-- Modules that can be toggled on the installer's module page, one column per group
-- Each entry is the path below E.db.mui, the last key is the toggle itself
local moduleToggles = {
	{
		name = L["Interface"],
		{
			label = L["Armory"],
			path = { "armory", "enable" },
			desc = L["The Armory warns you about missing enchants and sockets on your gear."],
		},
		{
			label = L["Categorized Bags"],
			path = { "bags", "categorizedBags", "enable" },
			desc = L["Categorized Bags sorts your bags into groups like equipment, consumables and quest items."],
		},
		{
			label = L["Chat Sidebar"],
			path = { "chat", "sidebar", "enable" },
			desc = L["The Chat Sidebar gives quick access to friends, guild, copy chat and M+ portals."],
		},
		{
			label = L["Location Panel"],
			path = { "locationPanel", "enable" },
			desc = L["The Location Panel above the Minimap can show your coordinates. Left-click it to open the World Map, right-click to link your location in chat."],
		},
		{
			label = L["Minimap Buttons"],
			path = { "minimapButtons", "enable" },
			desc = L["The Minimap Buttons bar adds a Great Vault button and your M+ portals next to the Minimap."],
		},
		{
			label = L["Game Menu"],
			path = { "gameMenu", "enable" },
			desc = L["Enable/Disable the MerathilisUI Style from the Blizzard Game Menu. (e.g. Pepe, Logo, Bars)"],
		},
		{
			label = L["VehicleBar"],
			path = { "vehicleBar", "enable" },
			desc = L["Shows a styled bar for vehicles and skyriding, with vigor and speed."],
		},
	},
	{
		name = L["Combat"],
		{
			label = L["Buff Reminder"],
			path = { "buffReminder", "enable" },
			desc = L["Buff Reminder shows icons for the raid buffs you are missing."],
		},
		{
			label = L["Battle Res"],
			path = { "tracker", "battleRes", "enable" },
			desc = L["Shows the shared battle res charges of your group and the time until the next charge during Mythic+ keys and raid boss encounters."],
		},
		{
			label = L["Bloodlust"],
			path = { "tracker", "bloodlust", "enable" },
			desc = L["The Bloodlust tracker shows your Sated lockout, the active lust and optionally when a lust is ready again."],
		},
		{
			label = L["Movement Alert"],
			path = { "movementAlert", "enable" },
			desc = L["Movement Alert shows the cooldown of your movement spells while they are not ready."],
		},
		{
			label = L["Cursor"],
			path = { "cursor", "enable" },
			desc = L["Cursor puts a colored ring around your mouse cursor, optionally with a GCD and cast ring."],
		},
	},
	{
		name = L["Quality of Life"],
		{
			label = L["Item Level"],
			path = { "itemLevel", "enable" },
			desc = L["Item Level shows the item level on items in the merchant and trade windows."],
		},
		{
			label = L["Loot Roll"],
			path = { "lootRoll", "enable" },
			desc = L["Replaces ElvUI's Need/Greed/Pass loot roll frames with a custom, movable bar."],
		},
		{
			label = L["Mail"],
			path = { "mail", "enable" },
			desc = L["Mail adds checkboxes to open or delete several mails at once and saves recipient lists."],
		},
		{
			label = L["Notification"],
			path = { "notification", "enable" },
			desc = L["Shows toasts for new mail, invites, guild events, the Great Vault and more."],
		},
		{
			label = L["Name Hover"],
			path = { "nameHover", "enable" },
			desc = L["Shows the name, guild and level of the unit under your mouse right next to the cursor."],
		},
	},
}

local function GetToggleParent(path)
	local db = E.db.mui
	for i = 1, #path - 1 do
		db = db[path[i]]
	end
	return db, path[#path]
end

-- Only the db is written, the reload at the end of the installer loads the modules
local function ModuleToggle_OnToggle(switch, checked)
	local db, key = GetToggleParent(switch.path)
	db[key] = checked
end

local function SetAllModules(page, enable)
	for _, switch in ipairs(page.switches) do
		switch:SetChecked(enable)
		ModuleToggle_OnToggle(switch, enable)
	end
end

local function CountEnabledModules()
	local enabled, total = 0, 0
	for _, group in ipairs(moduleToggles) do
		for _, toggle in ipairs(group) do
			local db, key = GetToggleParent(toggle.path)
			total = total + 1
			if db[key] then
				enabled = enabled + 1
			end
		end
	end
	return enabled, total
end

-- Profiles of AddOns that are loaded, the AddOn page only exists when there is one
local addOnProfiles = {}
for _, entry in ipairs(I.AddOnProfiles) do
	if E:IsAddOnEnabled(entry[1]) then
		tinsert(addOnProfiles, entry)
	end
end

--[[----------------------------------
--	Steps
--]]
----------------------------------
local function AddStep(step)
	if not step.hidden then
		tinsert(steps, step)
	end
end

AddStep({
	key = "welcome",
	title = L["Welcome"],
	heading = function()
		return format(L["Welcome to %s"], MER.Title)
	end,
	desc = L["This installer sets up MerathilisUI in a few steps. Everything can be changed later in the options."],
	build = function(page)
		page.logo = page:CreateTexture(nil, "ARTWORK")
		page.logo:SetSize(256, 128)
		page.logo:SetPoint("TOP", 0, 4)
		page.logo:SetTexture(LOGO)

		page.version = CreateText(page, 11, COLOR_MUTED)
		page.version:SetPoint("TOP", page.logo, "BOTTOM", 0, 0)
		page.version:SetFormattedText(L["Version %s for ElvUI %s"], MER.DisplayVersion, E.version)

		page.install = CreateButton(page, L["Install"], 180, true, function()
			PI:NextPage()
		end)
		page.import = CreateButton(page, L["Import Existing"], 180, false, function()
			ShowImportPopup(page.profiles)
		end)
		page.skip = CreateButton(
			page,
			L["Skip"],
			120,
			false,
			SkipInstaller,
			L["Closes the installer without changing anything. It does not open again by itself, run it anytime with /mer install."]
		)

		page.note = CreateText(page, 11, COLOR_MUTED)
		page.note:SetWidth(600)
		page.note:SetWordWrap(true)
	end,
	update = function(page)
		page.profiles = FindImportProfiles()
		page.import:SetShown(page.profiles ~= nil)

		local buttons = { page.install }
		if page.profiles then
			tinsert(buttons, page.import)
		end
		tinsert(buttons, page.skip)
		LayoutRow(page, buttons, -168)

		page.note:ClearAllPoints()
		page.note:SetPoint("TOP", page, "TOP", 0, -212)
		if page.profiles then
			page.note:SetFormattedText(
				L["Import Existing takes over the MerathilisUI profile %s and the settings of %s, for example from your main character."],
				page.profiles.public.name,
				page.profiles.private.name
			)
		else
			page.note:SetText("")
		end
	end,
})

AddStep({
	key = "profile",
	title = L["Profile"],
	desc = L["MerathilisUI changes a lot of ElvUI settings. A new profile keeps your current one untouched, so you can switch back anytime."],
	done = function()
		return state.profile
	end,
	summary = function()
		if state.profile == "new" then
			return L["New Profile"]
		elseif state.profile == "current" then
			return E.data:GetCurrentProfile()
		end
	end,
	build = function(page)
		page.new = CreateCard(page, 340, 120, {
			tag = L["Recommended"],
			title = L["New Profile"],
			desc = L["Creates a fresh profile for this character and installs MerathilisUI into it."],
			onClick = ShowProfileDialog,
		})
		page.current = CreateCard(page, 340, 120, {
			tag = "", -- keeps the title in line with the recommended card
			title = L["Use Current Profile"],
			onClick = function()
				state.profile = "current"
				RefreshPage()
				PI:NextPage()
			end,
		})
		LayoutRow(page, { page.new, page.current }, -20)
	end,
	update = function(page)
		page.current.desc:SetFormattedText(
			L["Installs MerathilisUI into %s. Your changes in this profile get overwritten."],
			"|cffffffff" .. E.data:GetCurrentProfile() .. "|r"
		)
		page.new:SetApplied(state.profile == "new")
		page.current:SetApplied(state.profile == "current")
	end,
})

AddStep({
	key = "scale",
	title = L["UI Scale"],
	desc = L["Choose how big the interface is. Auto Scale picks the pixel perfect size for your resolution."],
	done = function()
		return state.scale
	end,
	summary = function()
		return state.scale and format("%.2f", state.scale)
	end,
	build = function(page)
		page.cards = {
			CreateCard(page, 180, 140, { tag = L["Recommended"], value = "", title = L["Auto Scale"], onClick = ApplyScale }),
			CreateCard(page, 180, 140, { tag = "", value = "0.60", title = L["Small"], desc = L["More room on the screen"], onClick = ApplyScale }),
			CreateCard(page, 180, 140, { tag = "", value = "0.80", title = L["Medium"], desc = L["A balanced size"], onClick = ApplyScale }),
			CreateCard(page, 180, 140, { tag = "", value = "1.00", title = L["Large"], desc = L["Easier to read"], onClick = ApplyScale }),
		}
		page.cards[2].scaleValue = 0.6
		page.cards[3].scaleValue = 0.8
		page.cards[4].scaleValue = 1
		LayoutRow(page, page.cards, -20)
	end,
	update = function(page)
		local auto = page.cards[1]
		auto.scaleValue = E:PixelBestSize()
		auto.value:SetFormattedText("%.2f", auto.scaleValue)
		auto.desc:SetFormattedText(L["Pixel perfect for %s"], E.resolution)

		for _, card in ipairs(page.cards) do
			card:SetApplied(abs(E.global.general.UIScale - card.scaleValue) < 0.001)
		end
	end,
})

AddStep({
	key = "layout",
	title = L["Layout"],
	desc = L["Applies the complete MerathilisUI layout: general look, chat, datatexts, action bars, nameplates and unit frames. Pick the unit frame style you like."],
	done = function()
		return state.layout
	end,
	summary = function()
		if state.layout == "gradient" then
			return L["Gradient Layout"]
		elseif state.layout == "dark" then
			return L["Dark Layout"]
		end
	end,
	build = function(page)
		page.gradient = CreateCard(page, 360, 190, {
			image = PREVIEW_PATH .. "Gradient.tga",
			imageHeight = 128,
			texCoord = PREVIEW_COORDS,
			title = L["Gradient Layout"],
			desc = L["Class colored health bars with a soft gradient."],
			onClick = function()
				ApplyLayout("gradient")
			end,
		})
		page.dark = CreateCard(page, 360, 190, {
			image = PREVIEW_PATH .. "Dark.tga",
			imageHeight = 128,
			texCoord = PREVIEW_COORDS,
			title = L["Dark Layout"],
			desc = L["Dark health bars with the class color on their backdrop."],
			onClick = function()
				ApplyLayout("dark")
			end,
		})
		LayoutRow(page, { page.gradient, page.dark }, 0)

		page.cvars = CreateSwitch(page, L["Recommended game settings (CVars)"], 340, function(_, checked)
			state.cvars = checked
		end, L["Changes a few World of Warcraft settings, for example the camera distance, nameplates and chat. They are tailored to the author of MerathilisUI and not needed for the layout."])
		page.cvars:SetPoint("TOPLEFT", page.gradient, "BOTTOMLEFT", 0, -16)

		page.warning = CreateText(page, 11, COLOR_WARNING, "RIGHT")
		page.warning:SetPoint("TOPRIGHT", page.dark, "BOTTOMRIGHT", 0, -20)
		page.warning:SetText(L["Overwrites the layout settings of the current profile."])
	end,
	update = function(page)
		page.cvars:SetChecked(state.cvars ~= false)
		page.gradient:SetApplied(state.layout == "gradient")
		page.dark:SetApplied(state.layout == "dark")
	end,
})

AddStep({
	key = "modules",
	title = L["Modules"],
	desc = L["Choose the modules you want to use. Changes are applied on the reload at the end of the installer and can be changed anytime in the options."],
	done = function()
		return state.modules
	end,
	summary = function()
		if state.modules then
			return format(L["%d of %d enabled"], CountEnabledModules())
		end
	end,
	build = function(page)
		page.switches = {}
		local columnWidth = (BODY_WIDTH - GAP * (#moduleToggles - 1)) / #moduleToggles

		-- All columns as tall as the longest one
		local rows = 0
		for _, group in ipairs(moduleToggles) do
			rows = max(rows, #group)
		end

		for column, group in ipairs(moduleToggles) do
			local panel = CreatePanel(page)
			panel:SetSize(columnWidth, PADDING * 2 + 22 + rows * 26)
			panel:SetPoint("TOPLEFT", (column - 1) * (columnWidth + GAP), -24)

			local header = CreateText(panel, 13, COLOR_ACCENT, "LEFT")
			header:SetPoint("TOPLEFT", PADDING, -PADDING)
			header:SetText(group.name)

			for row, toggle in ipairs(group) do
				local switch = CreateSwitch(panel, toggle.label, columnWidth - PADDING * 2, ModuleToggle_OnToggle, toggle.desc)
				switch:SetPoint("TOPLEFT", PADDING, -PADDING - 2 - row * 26)
				switch.path = toggle.path
				tinsert(page.switches, switch)
			end
		end

		page.disableAll = CreateLink(page, L["Disable All"], function()
			SetAllModules(page, false)
		end)
		page.disableAll:SetPoint("TOPRIGHT", 0, 0)

		page.enableAll = CreateLink(page, L["Enable All"], function()
			SetAllModules(page, true)
		end)
		page.enableAll:SetPoint("RIGHT", page.disableAll, "LEFT", -12, 0)
	end,
	update = function(page)
		-- Read the db every time, the profile step might have switched profiles
		for _, switch in ipairs(page.switches) do
			local db, key = GetToggleParent(switch.path)
			switch:SetChecked(db[key])
		end

		state.modules = true
	end,
})

AddStep({
	key = "editMode",
	title = L["EditMode"],
	-- The layout string is made for Retail's Edit Mode
	hidden = E.Forever,
	desc = L["Blizzard's Edit Mode places a few frames ElvUI does not move. Import the MerathilisUI Edit Mode layout in two steps."],
	done = function()
		return state.editMode
	end,
	summary = function()
		return state.editMode and L["String copied"]
	end,
	build = function(page)
		page.copy = CreateCard(page, 340, 130, {
			value = "1",
			title = L["Copy the Layout String"],
			desc = L["Opens a window with the string. Select it with CTRL+A and copy it with CTRL+C."],
			onClick = function()
				PF:EditModeString()
				state.editMode = true
				RefreshPage()
			end,
		})
		page.open = CreateCard(page, 340, 130, {
			value = "2",
			title = L["Enter Edit Mode"],
			desc = L["Pick Import in the layout dropdown, paste the string with CTRL+V, give it a name and click Import."],
			onClick = function()
				PF:ToggleEditMode()
			end,
		})
		LayoutRow(page, { page.copy, page.open }, -20)
	end,
	update = function(page)
		page.copy:SetApplied(state.editMode)
	end,
})

AddStep({
	key = "addons",
	title = L["AddOn Profiles"],
	hidden = #addOnProfiles == 0,
	desc = L["MerathilisUI brings matching profiles for these AddOns. Click an AddOn to apply its profile."],
	done = function()
		return next(state.addons) ~= nil
	end,
	summary = function()
		local count = 0
		for _ in pairs(state.addons) do
			count = count + 1
		end
		return count > 0 and format(L["%d applied"], count)
	end,
	build = function(page)
		page.cards = {}
		local columns = 3
		local cardWidth = (BODY_WIDTH - GAP * (columns - 1)) / columns

		for index, entry in ipairs(addOnProfiles) do
			local addon, label, method = unpack(entry)
			local card = CreateCard(page, cardWidth, 60, { icon = true, title = label, onClick = ApplyAddOnProfile })
			card.addon = addon
			card.method = method

			local texture, atlas = GetAddOnIcon(addon)
			if atlas then
				card.icon:SetAtlas(atlas)
			else
				card.icon:SetTexture(texture)
			end

			local column = (index - 1) % columns
			local row = (index - 1 - column) / columns
			card:SetPoint("TOPLEFT", column * (cardWidth + GAP), -row * (60 + GAP))
			tinsert(page.cards, card)
		end
	end,
	update = function(page)
		for _, card in ipairs(page.cards) do
			local applied = state.addons[card.addon]
			card:SetApplied(applied)
			card.desc:SetText(applied and L["Profile applied"] or L["Click to apply the profile"])
		end
	end,
})

AddStep({
	key = "developer",
	title = L["Developer Settings"],
	hidden = not F.IsDeveloper(),
	desc = L["Settings only the developer of MerathilisUI uses."],
	done = function()
		return state.developer
	end,
	summary = function()
		return state.developer and L["Applied"]
	end,
	build = function(page)
		page.apply = CreateCard(page, 340, 110, {
			title = L["Setup Developer Settings"],
			desc = L["UI scale, chat bubbles, ElvUI user tags and a few module settings."],
			onClick = function()
				MER:DeveloperSettings()
				state.developer = true
				RefreshPage()
			end,
		})
		LayoutRow(page, { page.apply }, -20)
	end,
	update = function(page)
		page.apply:SetApplied(state.developer)
	end,
})

AddStep({
	key = "finish",
	title = L["Installation Complete"],
	desc = function()
		return format(L["Features, the full changelog and downloads can be found on the website %s."], "|cffff7d0amerathilisui.com|r")
	end,
	build = function(page)
		local summary = CreatePanel(page)
		summary:SetSize(380, 236)
		summary:SetPoint("TOPLEFT")
		page.summary = summary

		summary.header = CreateText(summary, 13, COLOR_ACCENT, "LEFT")
		summary.header:SetPoint("TOPLEFT", PADDING, -PADDING)
		summary.header:SetText(L["Summary"])

		page.rows = {}
		for _, step in ipairs(steps) do
			if step.summary then
				local row = CreateFrame("Frame", nil, summary)
				row:SetSize(380 - PADDING * 2, 22)
				row:SetPoint("TOPLEFT", PADDING, -PADDING - 20 - #page.rows * 24)
				row.step = step

				row.icon = row:CreateTexture(nil, "ARTWORK")
				row.icon:SetSize(14, 14)
				row.icon:SetPoint("LEFT")
				row.icon:SetTexture(I.Media.Icons.Ok)

				row.label = CreateText(row, 12, nil, "LEFT")
				row.label:SetPoint("LEFT", row.icon, "RIGHT", 8, 0)
				row.label:SetText(step.title)

				row.value = CreateText(row, 12, nil, "RIGHT")
				row.value:SetPoint("RIGHT")

				tinsert(page.rows, row)
			end
		end

		page.website = page:CreateTexture(nil, "ARTWORK")
		page.website:SetSize(320, 160)
		page.website:SetPoint("TOPRIGHT", -20, 4)
		page.website:SetTexture(WEBSITE_IMAGE)

		page.websiteButton = CreateButton(
			page,
			format("|T%s:16:16:0:0:64:64|t %s", I.Media.Icons.Home, L["Website"]),
			154,
			false,
			function()
				E:StaticPopup_Show("MERATHILISUI_EditBox", nil, nil, MER.WebsiteURL)
			end
		)
		page.websiteButton:SetPoint("TOPLEFT", page.website, "BOTTOMLEFT", 2, -8)

		page.discordButton = CreateButton(
			page,
			format("|T%s:16:16:0:0:64:64|t %s", I.Media.Icons.Discord, "Discord"),
			154,
			false,
			function()
				E:StaticPopup_Show("MERATHILISUI_EditBox", nil, nil, MER.DiscordURL)
			end
		)
		page.discordButton:SetPoint("TOPRIGHT", page.website, "BOTTOMRIGHT", -2, -8)

		page.finish = CreateButton(page, L["Finish & Reload"], 220, true, InstallComplete)
		page.finish:SetPoint("BOTTOM", 0, 0)
	end,
	update = function(page)
		for _, row in ipairs(page.rows) do
			local value = row.step.summary()
			row.icon:SetShown(value and true or false)
			row.label:SetTextColor(unpack(value and { 1, 1, 1 } or COLOR_MUTED))
			row.value:SetText(value or L["Skipped"])
			row.value:SetTextColor(unpack(value and { 1, 1, 1 } or COLOR_MUTED))
		end
	end,
})

--[[----------------------------------
--	ElvUI PlugIn installer
--]]
----------------------------------
MER.installTable = {
	Name = MER.Title,
	Title = L["|cffff7d0aMerathilisUI|r Installation"],
	-- Hidden on our pages, set anyway so ElvUI's own logo never shows up
	tutorialImage = LOGO,
	Pages = {},
	StepTitles = {},
	StepTitlesColor = COLOR_STEP,
	StepTitlesColorSelected = COLOR_ACCENT,
	StepTitleWidth = 200,
	StepTitleButtonWidth = 184,
	StepTitleTextJustification = "LEFT",
}

for index in ipairs(steps) do
	MER.installTable.Pages[index] = function()
		ShowStep(index)
	end
	MER.installTable.StepTitles[index] = function()
		return StepTitle(index)
	end
end
