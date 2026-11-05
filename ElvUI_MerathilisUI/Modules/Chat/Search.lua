local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Chat")
local S = E:GetModule("Skins")
local CH = E:GetModule("Chat")

local _G = _G
local format, gmatch, ipairs, pcall, sort, strfind, strlower, strsub, tinsert, wipe =
	format, gmatch, ipairs, pcall, table.sort, strfind, strlower, strsub, tinsert, wipe
local floor, max = math.floor, math.max
local tconcat = table.concat

local CreateDataProvider = CreateDataProvider
local CreateFrame = CreateFrame
local CreateScrollBoxListLinearView = CreateScrollBoxListLinearView
local ScrollUtil = ScrollUtil

local HEADER_HEIGHT = 26
local FOOTER_HEIGHT = 22
local PADDING = 8
local SEARCH_HEIGHT = 22
local ROW_HEIGHT = 18
local SCROLLBAR_WIDTH = 8

local function GetDB()
	return module.chatDB and module.chatDB.search
end

local function IsEnabled()
	local db = GetDB()
	return db and db.enable and E.private.chat.enable
end

-------------------------------------------------------------------------------
-- Reading the chat
-------------------------------------------------------------------------------
-- Plain text of every readable line, newest last. Read again only when the
-- chat got new lines since the last search.
local cache = { lines = {} }

local function ReadChat(chatFrame)
	local count = chatFrame:GetNumMessages()
	local ok, newest = pcall(chatFrame.GetMessageInfo, chatFrame, count)
	newest = ok and E:NotSecretValue(newest) and newest or nil

	if cache.chatFrame == chatFrame and cache.count == count and cache.newest == newest then
		return cache.lines
	end

	local lines = cache.lines
	wipe(lines)
	for i = 1, count do
		local read, msg, r, g, b = pcall(chatFrame.GetMessageInfo, chatFrame, i)
		if read and msg and not CH:MessageIsProtected(msg) then
			local cleaned, plain = pcall(module.GetPlainChatLine, msg)
			if cleaned and plain and plain ~= "" then
				tinsert(lines, { index = i, raw = msg, plain = plain, lower = strlower(plain), r = r, g = g, b = b })
			end
		end
	end

	cache.chatFrame, cache.count, cache.newest = chatFrame, count, newest
	return lines
end

local terms = {}
local function SplitQuery(query)
	wipe(terms)
	for word in gmatch(strlower(query), "%S+") do
		tinsert(terms, word)
	end
	return terms
end

-- Every typed word has to be in the line, in any order
local function Matches(line)
	for _, term in ipairs(terms) do
		if not strfind(line.lower, term, 1, true) then
			return false
		end
	end
	return true
end

local function ByStart(a, b)
	return a[1] < b[1]
end

-- The plain line with every found word in ElvUI's value color, the same color
-- ElvUI uses for its keyword highlight
local ranges = {}
local function HighlightTerms(line)
	wipe(ranges)
	for _, term in ipairs(terms) do
		local init = 1
		while true do
			local first, last = strfind(line.lower, term, init, true)
			if not first then
				break
			end
			tinsert(ranges, { first, last })
			init = last + 1
		end
	end

	if #ranges == 0 then
		return line.plain
	end

	sort(ranges, ByStart)

	local parts, pos = {}, 1
	local color = E.media.hexvaluecolor
	local i = 1
	while i <= #ranges do
		local first, last = ranges[i][1], ranges[i][2]
		-- Overlapping words become one highlight
		while ranges[i + 1] and ranges[i + 1][1] <= last + 1 do
			i = i + 1
			last = max(last, ranges[i][2])
		end

		if first >= pos then
			tinsert(parts, strsub(line.plain, pos, first - 1))
			tinsert(parts, color .. strsub(line.plain, first, last) .. "|r")
			pos = last + 1
		end
		i = i + 1
	end
	tinsert(parts, strsub(line.plain, pos))

	return tconcat(parts)
end

-------------------------------------------------------------------------------
-- Jumping to a line
-------------------------------------------------------------------------------
-- New lines push the old ones down and the oldest ones drop out, so the saved
-- index is checked and the line looked up again when it moved.
local function FindMessageIndex(chatFrame, line)
	local ok, msg = pcall(chatFrame.GetMessageInfo, chatFrame, line.index)
	if ok and msg == line.raw then
		return line.index
	end

	for i = chatFrame:GetNumMessages(), 1, -1 do
		ok, msg = pcall(chatFrame.GetMessageInfo, chatFrame, i)
		if ok and msg == line.raw then
			return i
		end
	end
end

-- Scroll offsets count messages from the newest one up, the line ends up in
-- the middle of the chat with what was said around it above and below
local function JumpToLine(chatFrame, line)
	local index = FindMessageIndex(chatFrame, line)
	if not index then
		return
	end

	if chatFrame.isDocked and not chatFrame:IsShown() and _G.FCF_SelectDockFrame then
		_G.FCF_SelectDockFrame(chatFrame)
	end

	local visible = chatFrame.GetNumVisibleLines and chatFrame:GetNumVisibleLines() or 0
	chatFrame:SetScrollOffset(max(0, chatFrame:GetNumMessages() - index - floor(visible / 2)))

	-- Faded out lines come back, otherwise the jump lands on an empty chat
	if chatFrame.ResetAllFadeTimes then
		chatFrame:ResetAllFadeTimes()
	end
end

-------------------------------------------------------------------------------
-- Window
-------------------------------------------------------------------------------
local window

local function Row_OnEnter(row)
	local line = row.line
	if not line then
		return
	end

	-- The whole line, the row itself cuts it off at the window edge
	local tooltip = _G.GameTooltip
	tooltip:SetOwner(row, "ANCHOR_CURSOR")
	tooltip:AddLine(line.plain, line.r or 1, line.g or 1, line.b or 1, true)
	tooltip:Show()
end

local function Row_OnLeave()
	_G.GameTooltip:Hide()
end

local function Row_OnClick(row)
	if row.line and window and window.chatFrame then
		JumpToLine(window.chatFrame, row.line)
	end
end

local function InitRow(row, line)
	if not row.Text then
		row:SetHeight(ROW_HEIGHT)

		local highlight = row:CreateTexture(nil, "HIGHLIGHT")
		highlight:SetAllPoints()
		local cc = E.myClassColor
		highlight:SetColorTexture(cc.r, cc.g, cc.b, 0.15)

		local text = row:CreateFontString(nil, "OVERLAY")
		text:SetPoint("LEFT", row, "LEFT", 4, 0)
		text:SetPoint("RIGHT", row, "RIGHT", -4, 0)
		text:SetJustifyH("LEFT")
		text:SetWordWrap(false)
		row.Text = text

		row:SetScript("OnEnter", Row_OnEnter)
		row:SetScript("OnLeave", Row_OnLeave)
		row:SetScript("OnClick", Row_OnClick)
	end

	row.line = line
	row.Text:FontTemplate(nil, GetDB().fontSize, "NONE")
	row.Text:SetTextColor(line.r or 1, line.g or 1, line.b or 1)
	row.Text:SetText(HighlightTerms(line))
end

local function CreateWindow()
	local frame = module:CreateChatPopup("MER_ChatSearchFrame", GetDB)
	frame:HookScript("OnHide", function(self)
		-- Nothing stays around until the next open
		self.SearchBox:SetText("")
		self.ScrollBox:RemoveDataProvider()
		wipe(cache.lines)
		cache.chatFrame = nil
	end)

	local searchBox = CreateFrame("EditBox", nil, frame, "SearchBoxTemplate")
	searchBox:SetPoint("TOPLEFT", frame, "TOPLEFT", PADDING + 4, -(HEADER_HEIGHT + PADDING))
	searchBox:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -PADDING, -(HEADER_HEIGHT + PADDING))
	searchBox:SetHeight(SEARCH_HEIGHT)
	searchBox:SetAutoFocus(false)
	S:HandleEditBox(searchBox)
	searchBox:HookScript("OnTextChanged", function()
		module:UpdateChatSearch()
	end)
	searchBox:HookScript("OnEnterPressed", function(self)
		-- Enter takes the newest match
		local first = frame.results and frame.results[1]
		if first then
			JumpToLine(frame.chatFrame, first)
		end
		self:ClearFocus()
	end)
	searchBox:HookScript("OnEscapePressed", function()
		frame:Hide()
	end)
	frame.SearchBox = searchBox

	local scrollBox = CreateFrame("Frame", nil, frame, "WowScrollBoxList")
	scrollBox:SetPoint("TOPLEFT", searchBox, "BOTTOMLEFT", -4, -PADDING)
	scrollBox:SetPoint(
		"BOTTOMRIGHT",
		frame,
		"BOTTOMRIGHT",
		-(PADDING + SCROLLBAR_WIDTH + 6),
		FOOTER_HEIGHT + PADDING / 2
	)
	frame.ScrollBox = scrollBox

	local scrollBar = CreateFrame("EventFrame", nil, frame, "MinimalScrollBar")
	scrollBar:SetPoint("TOPLEFT", scrollBox, "TOPRIGHT", 6, 0)
	scrollBar:SetPoint("BOTTOMLEFT", scrollBox, "BOTTOMRIGHT", 6, 0)
	S:HandleTrimScrollBar(scrollBar)

	local view = CreateScrollBoxListLinearView()
	view:SetElementExtent(ROW_HEIGHT)
	view:SetElementInitializer("Button", InitRow)
	ScrollUtil.InitScrollBoxListWithScrollBar(scrollBox, scrollBar, view)

	-- Footer: number of matches and a click hint
	local count = frame:CreateFontString(nil, "OVERLAY")
	count:FontTemplate(nil, 11)
	count:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", PADDING, PADDING / 2 + 2)
	count:SetTextColor(0.6, 0.6, 0.6)
	frame.Count = count

	local hint = frame:CreateFontString(nil, "OVERLAY")
	hint:FontTemplate(nil, 11)
	hint:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -(PADDING + 14), PADDING / 2 + 2)
	hint:SetTextColor(0.6, 0.6, 0.6)
	hint:SetText(L["Click a line to jump to it in the chat."])

	return frame
end

-------------------------------------------------------------------------------
-- API
-------------------------------------------------------------------------------
---Search the open window's chat again, after typing or an option change
function module:UpdateChatSearch()
	if not (window and window:IsShown() and window.chatFrame) then
		return
	end

	if not IsEnabled() then
		window:Hide()
		return
	end

	local chatName = module.GetChatWindowName(window.chatFrame)
	window.Title:SetText(MER.Title .. L["Chat Search"] .. (chatName and (" - " .. chatName) or ""))

	local results = {}
	if #SplitQuery(window.SearchBox:GetText()) > 0 then
		local lines = ReadChat(window.chatFrame)
		-- Newest first
		for i = #lines, 1, -1 do
			if Matches(lines[i]) then
				tinsert(results, lines[i])
			end
		end
		window.Count:SetText(format(L["%d matches"], #results))
	else
		window.Count:SetText(L["Type to search the chat history."])
	end

	window.results = results
	window.ScrollBox:SetDataProvider(CreateDataProvider(results))
end

---Open the search for a chat frame, or close it if it already shows that one
---@param chatFrame table
function module:ToggleChatSearch(chatFrame)
	if not IsEnabled() then
		return
	end

	if window and window:IsShown() and window.chatFrame == chatFrame then
		window:Hide()
		return
	end

	window = window or CreateWindow()
	window.chatFrame = chatFrame
	window:Show()
	window:Raise()
	window.SearchBox:SetFocus()
	self:UpdateChatSearch()
end
