local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_MediaPlayer") ---@class MediaPlayer
local S = E:GetModule("Skins")
local WS = W:GetModule("Skins")

local _G = _G
local format, strlower, strtrim = string.format, string.lower, strtrim
local ipairs = ipairs
local tinsert = table.insert

local CreateDataProvider = CreateDataProvider
local CreateFrame = CreateFrame
local CreateScrollBoxListLinearView = CreateScrollBoxListLinearView
local ScrollUtil = ScrollUtil
local SearchBoxTemplate_OnTextChanged = SearchBoxTemplate_OnTextChanged
local UIParent = UIParent

local WIDTH, HEIGHT = 760, 520
local PADDING = 10
local HEADER_HEIGHT = 30
local FOOTER_HEIGHT = 40
local NAV_WIDTH = 180
local NAV_BUTTON_HEIGHT = 24
local TOOLBAR_HEIGHT = 26
local ROW_HEIGHT = 22
local SCROLLBAR_WIDTH = 10

-- Search starts with this many letters, fewer would match almost everything
local MIN_SEARCH = 2

local window
-- What the list shows: { mode = "category", category } | { mode = "zone", zone, from } | { mode = "search", text }
local state = {}

local function ClassColor()
	return E.myClassColor
end

-- -----------------------------------------------------------------------------
-- List rows
-- -----------------------------------------------------------------------------

local function SetupRow(button)
	button:SetHeight(ROW_HEIGHT)

	local highlight = button:CreateTexture(nil, "HIGHLIGHT")
	highlight:SetAllPoints()
	highlight:SetColorTexture(1, 1, 1, 0.08)

	local active = button:CreateTexture(nil, "BACKGROUND")
	active:SetAllPoints()
	active:Hide()
	button.Active = active

	local text = button:CreateFontString(nil, "OVERLAY")
	text:FontTemplate(nil, 12)
	text:SetPoint("LEFT", 8, 0)
	text:SetJustifyH("LEFT")
	text:SetWordWrap(false)
	button.Text = text

	local info = button:CreateFontString(nil, "OVERLAY")
	info:FontTemplate(nil, 11)
	info:SetPoint("RIGHT", -8, 0)
	info:SetJustifyH("RIGHT")
	info:SetWordWrap(false)
	info:SetTextColor(0.6, 0.6, 0.6)
	button.Info = info

	text:SetPoint("RIGHT", info, "LEFT", -8, 0)

	button:SetScript("OnClick", function(self)
		local data = self.data
		if not data then
			return
		end

		if data.type == "zone" then
			module:ShowZone(data.zone)
		elseif data.type == "track" then
			module:PlayTrack(data.zone, data.index)
		elseif data.type == "movie" then
			module:PlayMovie(data.movie.id)
		end
	end)
end

local function InitRow(button, data)
	if not button.Text then
		SetupRow(button)
	end

	button.data = data
	button.Active:Hide()
	button.Info:SetText("")
	button:Enable()

	local text = button.Text
	text:SetTextColor(1, 1, 1)

	local searching = state.mode == "search"
	local cc = ClassColor()

	if data.type == "header" then
		text:SetText(data.text)
		text:SetTextColor(cc.r, cc.g, cc.b)
		button:Disable()
	elseif data.type == "zone" then
		local zone = data.zone
		text:SetText(zone.name)
		button.Info:SetText(
			searching and format("%s · %d", zone.category.name, #zone.tracks) or format("%d", #zone.tracks)
		)
	elseif data.type == "track" then
		local zone = data.zone
		local fileID = zone.tracks[data.index]
		text:SetText(module:GetTrackName(fileID))

		if searching then
			button.Info:SetText(zone.name)
		end

		local playing = module.playing
		if playing and playing.fileID == fileID then
			button.Active:SetColorTexture(cc.r, cc.g, cc.b, 0.25)
			button.Active:Show()
			text:SetTextColor(cc.r, cc.g, cc.b)
		end
	elseif data.type == "movie" then
		local movie = data.movie
		text:SetText(movie.name)

		if searching then
			button.Info:SetText(movie.category.name)
		end

		if not module:IsMoviePlayable(movie.id) then
			text:SetTextColor(0.5, 0.5, 0.5)
			button.Info:SetText(L["Not downloaded"])
			button:Disable()
		end
	end
end

-- -----------------------------------------------------------------------------
-- Views
-- -----------------------------------------------------------------------------

local function SetRows(rows, keepScroll)
	window.ScrollBox:SetDataProvider(
		CreateDataProvider(rows),
		keepScroll and _G.ScrollBoxConstants.RetainScrollPosition or _G.ScrollBoxConstants.DiscardScrollPosition
	)
	window.Empty:SetShown(#rows == 0)
end

local function UpdateNav()
	local cc = ClassColor()
	local selected = state.mode == "category" and state.category or state.mode == "zone" and state.zone.category

	for _, button in ipairs(window.NavButtons) do
		local isSelected = button.category == selected
		button.Selected:SetShown(isSelected)
		button.Bar:SetShown(isSelected)

		if isSelected then
			button.Text:SetTextColor(cc.r, cc.g, cc.b)
		else
			button.Text:SetTextColor(0.85, 0.85, 0.85)
		end
	end
end

local function BuildCategoryRows(category)
	local rows = {}

	if #category.movies > 0 then
		tinsert(rows, { type = "header", text = L["Cinematics"] })
		for _, movie in ipairs(category.movies) do
			tinsert(rows, { type = "movie", movie = movie })
		end
	end

	local lastKind
	for _, zone in ipairs(category.zones) do
		-- Folder entries are their own section header already
		if zone.kind ~= lastKind and zone.kind ~= "o" then
			tinsert(rows, { type = "header", text = module:GetKindLabel(zone.kind) })
		end
		lastKind = zone.kind

		tinsert(rows, { type = "zone", zone = zone })
	end

	return rows
end

function module:ShowCategory(category)
	state.mode, state.category, state.zone = "category", category, nil

	window.Back:Hide()
	window.Location:SetText(category.name)
	SetRows(BuildCategoryRows(category))
	UpdateNav()
end

function module:ShowZone(zone)
	-- Back returns to where the zone was opened from, the category or the search
	state.from = state.mode == "search" and "search" or "category"
	state.mode, state.zone = "zone", zone

	local rows = {}
	for index in ipairs(zone.tracks) do
		tinsert(rows, { type = "track", zone = zone, index = index })
	end

	window.Back:Show()
	window.Location:SetText(format("%s › %s", zone.category.name, zone.name))
	SetRows(rows)
	UpdateNav()
end

function module:ShowSearch(text)
	state.mode, state.text = "search", text

	window.Back:Hide()
	window.Location:SetText(format(L["Search: %s"], text))
	SetRows(self:Search(text))
	UpdateNav()
end

local function GoBack()
	local zone = state.zone
	local text = strtrim(window.SearchBox:GetText() or "")

	if state.from == "search" and #text >= MIN_SEARCH then
		module:ShowSearch(strlower(text))
	else
		module:ShowCategory(zone.category)
	end
end

local function OnSearchChanged(self)
	SearchBoxTemplate_OnTextChanged(self)

	local text = strlower(strtrim(self:GetText() or ""))
	if #text >= MIN_SEARCH then
		module:ShowSearch(text)
	elseif state.mode == "search" then
		module:ShowCategory(state.category or module.library.categories[1])
	end
end

-- -----------------------------------------------------------------------------
-- Now playing
-- -----------------------------------------------------------------------------

function module:UpdateWindow()
	if not window then
		return
	end

	local playing = self.playing
	if playing then
		local cc = ClassColor()
		window.NowPlaying:SetText(
			format(
				"%s %s  %s",
				E:RGBToHex(cc.r, cc.g, cc.b) .. L["Now Playing:"] .. "|r",
				self:GetTrackName(playing.fileID),
				F.String.Muted(format("(%s, %d/%d)", playing.zone.name, playing.index, #playing.zone.tracks))
			)
		)
	else
		window.NowPlaying:SetText(F.String.Muted(L["Click a track to play it, the zone's other tracks follow."]))
	end

	window.Previous:SetEnabled(playing ~= nil)
	window.Stop:SetEnabled(playing ~= nil)
	window.Next:SetEnabled(playing ~= nil)

	-- Repaint the visible rows for the playing highlight
	if window:IsShown() then
		window.ScrollBox:ForEachFrame(function(button)
			local data = button:GetElementData()
			if data then
				InitRow(button, data)
			end
		end)
	end
end

-- -----------------------------------------------------------------------------
-- Window
-- -----------------------------------------------------------------------------

local function CreateButton(parent, text, width, onClick)
	local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	button:SetSize(width, 22)
	button:SetText(text)
	button:SetScript("OnClick", onClick)
	S:HandleButton(button)

	return button
end

local function CreateNavButton(parent, category, index)
	local button = CreateFrame("Button", nil, parent)
	button:SetHeight(NAV_BUTTON_HEIGHT)
	button:SetPoint("TOPLEFT", 0, -(index - 1) * NAV_BUTTON_HEIGHT)
	button:SetPoint("TOPRIGHT", 0, -(index - 1) * NAV_BUTTON_HEIGHT)
	button.category = category

	local highlight = button:CreateTexture(nil, "HIGHLIGHT")
	highlight:SetAllPoints()
	highlight:SetColorTexture(1, 1, 1, 0.06)

	local cc = ClassColor()
	local selected = button:CreateTexture(nil, "BACKGROUND")
	selected:SetAllPoints()
	selected:SetColorTexture(cc.r, cc.g, cc.b, 0.15)
	selected:Hide()
	button.Selected = selected

	local bar = button:CreateTexture(nil, "ARTWORK")
	bar:SetPoint("TOPLEFT")
	bar:SetPoint("BOTTOMLEFT")
	bar:SetWidth(2)
	bar:SetColorTexture(cc.r, cc.g, cc.b, 1)
	bar:Hide()
	button.Bar = bar

	local text = button:CreateFontString(nil, "OVERLAY")
	text:FontTemplate(nil, 12)
	text:SetPoint("LEFT", 10, 0)
	text:SetPoint("RIGHT", -6, 0)
	text:SetJustifyH("LEFT")
	text:SetWordWrap(false)
	text:SetText(category.name)
	button.Text = text

	button:SetScript("OnClick", function()
		window.SearchBox:SetText("")
		window.SearchBox:ClearFocus()
		module:ShowCategory(category)
	end)

	return button
end

local function CreateWindow()
	local library = module:GetLibrary()
	local cc = ClassColor()

	local frame = CreateFrame("Frame", "MER_MediaPlayer", E.UIParent)
	frame:SetSize(WIDTH, HEIGHT)
	frame:SetPoint("CENTER", E.UIParent, "CENTER", 0, 40)
	frame:SetFrameStrata("DIALOG")
	frame:SetToplevel(true)
	frame:SetTemplate("Transparent")
	WS:CreateShadow(frame)
	frame:SetClampedToScreen(true)
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:Hide()
	tinsert(_G.UISpecialFrames, frame:GetName())

	frame:SetScript("OnShow", function()
		module:UpdateWindow()
	end)

	-- Opened from the options: bring them back once the player is closed. A
	-- cinematic hides the whole UI, that's no reason to reopen them.
	frame:SetScript("OnHide", function()
		if module.reopenOptions and UIParent:IsShown() then
			module.reopenOptions = nil
			E:ToggleOptions("mui,modules,mediaPlayer")
		end
	end)

	-- Header: drag handle, title, close button
	local header = CreateFrame("Frame", nil, frame)
	header:SetPoint("TOPLEFT")
	header:SetPoint("TOPRIGHT")
	header:SetHeight(HEADER_HEIGHT)
	header:EnableMouse(true)
	header:RegisterForDrag("LeftButton")
	header:SetScript("OnDragStart", function()
		frame:StartMoving()
	end)
	header:SetScript("OnDragStop", function()
		frame:StopMovingOrSizing()
	end)

	local title = header:CreateFontString(nil, "OVERLAY")
	title:FontTemplate(nil, 13, "OUTLINE")
	title:SetPoint("LEFT", PADDING, 0)
	title:SetText(MER.Title .. " " .. L["Media Player"])

	local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
	close:SetPoint("RIGHT", header, "RIGHT", 2, 0)
	close:SetFrameLevel(header:GetFrameLevel() + 1)
	S:HandleCloseButton(close)

	local accent = frame:CreateTexture(nil, "ARTWORK")
	accent:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 1, 0)
	accent:SetPoint("TOPRIGHT", header, "BOTTOMRIGHT", -1, 0)
	accent:SetHeight(1)
	accent:SetColorTexture(cc.r, cc.g, cc.b, 0.8)

	-- Left: one button per expansion
	local nav = CreateFrame("Frame", nil, frame)
	nav:SetPoint("TOPLEFT", PADDING, -(HEADER_HEIGHT + PADDING))
	nav:SetPoint("BOTTOMLEFT", PADDING, FOOTER_HEIGHT + PADDING)
	nav:SetWidth(NAV_WIDTH)
	nav:SetTemplate()

	frame.NavButtons = {}
	for index, category in ipairs(library.categories) do
		tinsert(frame.NavButtons, CreateNavButton(nav, category, index))
	end

	-- Right: toolbar with back button, location and search
	local content = CreateFrame("Frame", nil, frame)
	content:SetPoint("TOPLEFT", nav, "TOPRIGHT", PADDING, 0)
	content:SetPoint("BOTTOMRIGHT", -PADDING, FOOTER_HEIGHT + PADDING)

	local back = CreateButton(content, "‹ " .. L["Back"], 70, GoBack)
	back:SetPoint("TOPLEFT")
	back:Hide()
	frame.Back = back

	local searchBox = CreateFrame("EditBox", nil, content, "SearchBoxTemplate")
	S:HandleEditBox(searchBox)
	searchBox:SetSize(200, 20)
	searchBox:SetPoint("TOPRIGHT", 0, -1)
	searchBox:SetAutoFocus(false)
	searchBox:SetMaxLetters(40)
	searchBox.Instructions:SetText(L["Search tracks, zones and cinematics"])
	searchBox:SetScript("OnTextChanged", OnSearchChanged)
	searchBox:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
	end)
	frame.SearchBox = searchBox

	local location = content:CreateFontString(nil, "OVERLAY")
	location:FontTemplate(nil, 13)
	location:SetPoint("LEFT", content, "TOPLEFT", 0, -TOOLBAR_HEIGHT / 2)
	location:SetPoint("RIGHT", searchBox, "LEFT", -PADDING, 0)
	location:SetJustifyH("LEFT")
	location:SetWordWrap(false)
	frame.Location = location

	back:HookScript("OnShow", function()
		location:SetPoint("LEFT", back, "RIGHT", PADDING, 0)
	end)
	back:HookScript("OnHide", function()
		location:SetPoint("LEFT", content, "TOPLEFT", 0, -TOOLBAR_HEIGHT / 2)
	end)

	-- The list
	local listHolder = CreateFrame("Frame", nil, content)
	listHolder:SetPoint("TOPLEFT", 0, -(TOOLBAR_HEIGHT + 6))
	listHolder:SetPoint("BOTTOMRIGHT")
	listHolder:SetTemplate()

	local scrollBox = CreateFrame("Frame", nil, listHolder, "WowScrollBoxList")
	scrollBox:SetPoint("TOPLEFT", 2, -2)
	scrollBox:SetPoint("BOTTOMRIGHT", -(SCROLLBAR_WIDTH + 8), 2)
	frame.ScrollBox = scrollBox

	local scrollBar = CreateFrame("EventFrame", nil, listHolder, "MinimalScrollBar")
	scrollBar:SetPoint("TOPLEFT", scrollBox, "TOPRIGHT", 4, -2)
	scrollBar:SetPoint("BOTTOMLEFT", scrollBox, "BOTTOMRIGHT", 4, 2)

	local view = CreateScrollBoxListLinearView()
	view:SetElementExtent(ROW_HEIGHT)
	view:SetElementInitializer("Button", InitRow)
	ScrollUtil.InitScrollBoxListWithScrollBar(scrollBox, scrollBar, view)
	S:HandleTrimScrollBar(scrollBar)

	local empty = listHolder:CreateFontString(nil, "OVERLAY")
	empty:FontTemplate(nil, 12)
	empty:SetPoint("CENTER")
	empty:SetTextColor(0.6, 0.6, 0.6)
	empty:SetText(L["Nothing found."])
	empty:Hide()
	frame.Empty = empty

	-- Footer: now playing and the player buttons
	local nextButton = CreateButton(frame, L["Next"], 70, function()
		module:Next()
	end)
	nextButton:SetPoint("BOTTOMRIGHT", -PADDING, PADDING)
	frame.Next = nextButton

	local stop = CreateButton(frame, L["Stop"], 70, function()
		module:Stop()
	end)
	stop:SetPoint("RIGHT", nextButton, "LEFT", -6, 0)
	frame.Stop = stop

	local previous = CreateButton(frame, L["Previous"], 70, function()
		module:Previous()
	end)
	previous:SetPoint("RIGHT", stop, "LEFT", -6, 0)
	frame.Previous = previous

	local nowPlaying = frame:CreateFontString(nil, "OVERLAY")
	nowPlaying:FontTemplate(nil, 12)
	nowPlaying:SetPoint("LEFT", frame, "BOTTOMLEFT", PADDING, PADDING + 11)
	nowPlaying:SetPoint("RIGHT", previous, "LEFT", -PADDING, 0)
	nowPlaying:SetJustifyH("LEFT")
	nowPlaying:SetWordWrap(false)
	frame.NowPlaying = nowPlaying

	return frame
end

---The window, created on first use
---@return Frame
function module:GetWindow()
	if not window then
		window = CreateWindow()
		self:ShowCategory(self.library.categories[1])
	end

	return window
end
