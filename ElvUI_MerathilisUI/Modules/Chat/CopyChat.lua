local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Chat")
local WS = W:GetModule("Skins")
local S = E:GetModule("Skins")
local CH = E:GetModule("Chat")

local _G = _G
local format, gsub, pcall, strlower, tinsert, wipe = format, gsub, pcall, strlower, tinsert, wipe
local tconcat = table.concat

local C_Timer = C_Timer
local CreateFrame = CreateFrame
local ScrollUtil = ScrollUtil

local MIN_WIDTH, MIN_HEIGHT = 360, 180
local HEADER_HEIGHT = 26
local FOOTER_HEIGHT = 22
local PADDING = 8
local SCROLLBAR_WIDTH = 8
local GRIP_SIZE = 14
local GRIP_ALPHA = 0.4

local function GetDB()
	return module.chatDB and module.chatDB.copyChat
end

local function IsEnabled()
	local db = GetDB()
	return db and db.enable and E.private.chat.enable
end

-------------------------------------------------------------------------------
-- Reading the chat
-------------------------------------------------------------------------------
-- Raid target icons become their chat shortcut ({star}), the same text that
-- turns back into the icon when it is pasted into the chat.
local function RaidIconText(index)
	local name = _G["RAID_TARGET_" .. index]
	return name and ("{" .. strlower(name) .. "}") or ""
end

-- "1 |4day:days;" style plurals, picked by the number in front of them
local function PluralText(number, between, singular, plural)
	return number .. between .. (number == "1" and singular or plural)
end

local function CleanLine(text)
	text = gsub(text, [[|TInterface\TargetingFrame\UI%-RaidTargetingIcon_(%d+).-|t]], RaidIconText)
	text = gsub(text, "|[TA].-|[ta]", "")
	text = gsub(text, "|H.-|h(.-)|h", "%1")
	text = gsub(text, "(%d+)(.-)|4(.-):(.-);", PluralText)
	text = gsub(text, "|n", "\n")
	return text
end

local function StripColors(text)
	text = gsub(text, "|c%x%x%x%x%x%x%x%x", "")
	text = gsub(text, "|cn.-:", "")
	text = gsub(text, "|r", "")
	return text
end

local function FormatLine(msg, r, g, b, colors)
	msg = CleanLine(msg)
	if colors then
		return E:RGBToHex(r or 1, g or 1, b or 1) .. msg .. "|r"
	end
	return StripColors(msg)
end

-- Protected lines (secret values, |K name tokens) are left out, the same rule
-- ElvUI's own copy window follows.
local lines = {}
local function CollectLines(chatFrame, colors)
	wipe(lines)
	if not (chatFrame and chatFrame.GetNumMessages) then
		return lines
	end

	for i = 1, chatFrame:GetNumMessages() do
		local ok, msg, r, g, b = pcall(chatFrame.GetMessageInfo, chatFrame, i)
		if ok and msg and not CH:MessageIsProtected(msg) then
			local formatted, line = pcall(FormatLine, msg, r, g, b, colors)
			if formatted and line then
				lines[#lines + 1] = line
			end
		end
	end

	return lines
end

local function GetChatName(chatFrame)
	local id = chatFrame and chatFrame.GetID and chatFrame:GetID()
	local name = id and _G.FCF_GetChatWindowInfo and _G.FCF_GetChatWindowInfo(id)
	return name ~= "" and name or nil
end
module.GetChatWindowName = GetChatName

---Plain text of a chat line: links, textures and colors removed, raid icons as {star}
---@param msg string
---@return string
function module.GetPlainChatLine(msg)
	return StripColors(CleanLine(msg))
end

-------------------------------------------------------------------------------
-- Window
-------------------------------------------------------------------------------
local window

local function SaveSize(frame)
	local db = frame.getDB()
	if db then
		db.width = F.Round(frame:GetWidth())
		db.height = F.Round(frame:GetHeight())
	end
end

local function StopSizing(frame)
	if frame.isSizing then
		frame:StopMovingOrSizing()
		frame.isSizing = nil
		SaveSize(frame)
	end
end

local function Window_OnHide(frame)
	-- Drop the copied history, it is read again on the next open
	frame.text = nil
	frame.textBox:SetText("")
end

local function CreateGrip(frame)
	local grip = CreateFrame("Button", nil, frame)
	grip:SetSize(GRIP_SIZE, GRIP_SIZE)
	grip:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
	grip:SetFrameLevel(frame:GetFrameLevel() + 10)
	grip:SetAlpha(GRIP_ALPHA)

	local texture = grip:CreateTexture(nil, "OVERLAY")
	texture:SetAllPoints()
	texture:SetTexture(I.Media.Icons.Chat.resize)

	grip:SetScript("OnMouseDown", function(_, button)
		if button == "LeftButton" then
			frame.isSizing = true
			frame:StartSizing("BOTTOMRIGHT")
		end
	end)
	grip:SetScript("OnMouseUp", function()
		StopSizing(frame)
	end)
	grip:SetScript("OnEnter", function(self)
		self:SetAlpha(1)
	end)
	grip:SetScript("OnLeave", function(self)
		self:SetAlpha(GRIP_ALPHA)
	end)

	return grip
end

local function CreateColorsToggle(frame)
	local checkBox = CreateFrame("CheckButton", nil, frame, "UICheckButtonTemplate")
	checkBox:SetSize(18, 18)
	S:HandleCheckBox(checkBox)

	local label = checkBox:CreateFontString(nil, "OVERLAY")
	label:FontTemplate(nil, 12)
	label:SetPoint("RIGHT", checkBox, "LEFT", -2, 0)
	label:SetText(L["Colors"])
	-- The label clicks the box too
	checkBox:SetHitRectInsets(-(label:GetStringWidth() + 2), 0, 0, 0)
	checkBox.label = label

	checkBox:SetScript("OnClick", function(self)
		GetDB().colors = self:GetChecked() and true or false
		module:UpdateCopyChat()
	end)

	return checkBox
end

---Movable, resizable chat popup with a header (title, close button, class
---colored line below it) and a resize grip. Shared by Copy Chat and Chat Search.
---@param name string global frame name, also used to close it with Escape
---@param getDB function returns the table holding width and height
---@return table frame
function module:CreateChatPopup(name, getDB)
	local db = getDB()

	local frame = CreateFrame("Frame", name, E.UIParent)
	frame.getDB = getDB
	frame:SetSize(db.width, db.height)
	frame:SetPoint("CENTER", E.UIParent, "CENTER", 0, 60)
	frame:SetFrameStrata("DIALOG")
	frame:SetToplevel(true)
	frame:SetTemplate("Transparent")
	WS:CreateShadow(frame)
	frame:SetClampedToScreen(true)
	frame:SetMovable(true)
	frame:SetResizable(true)
	frame:SetResizeBounds(MIN_WIDTH, MIN_HEIGHT)
	frame:EnableMouse(true)
	frame:Hide()
	frame:HookScript("OnHide", function(self)
		self:StopMovingOrSizing()
		self.isSizing = nil
	end)
	tinsert(_G.UISpecialFrames, name)

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
	title:SetPoint("LEFT", header, "LEFT", PADDING, 0)
	title:SetJustifyH("LEFT")
	frame.Title = title

	-- UIPanelCloseButton hides its parent, so it belongs to the window, not the header
	local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
	close:SetPoint("RIGHT", header, "RIGHT", 2, 0)
	close:SetFrameLevel(header:GetFrameLevel() + 1)
	S:HandleCloseButton(close)
	frame.Close = close

	title:SetPoint("RIGHT", close, "LEFT", -PADDING, 0)
	title:SetWordWrap(false)

	local cc = E.myClassColor
	local accent = frame:CreateTexture(nil, "ARTWORK")
	accent:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 1, 0)
	accent:SetPoint("TOPRIGHT", header, "BOTTOMRIGHT", -1, 0)
	accent:SetHeight(1)
	accent:SetColorTexture(cc.r, cc.g, cc.b, 0.8)

	frame.Header = header
	CreateGrip(frame)

	return frame
end

local function CreateWindow()
	local frame = module:CreateChatPopup("MER_CopyChatFrame", GetDB)
	frame:HookScript("OnHide", Window_OnHide)

	local colors = CreateColorsToggle(frame.Header)
	colors:SetPoint("RIGHT", frame.Close, "LEFT", -4, 0)
	frame.Colors = colors
	frame.Title:SetPoint("RIGHT", colors.label, "LEFT", -PADDING, 0)

	-- Text area: Blizzard's scrolling edit box brings scrolling and selection
	local textBox = CreateFrame("Frame", nil, frame, "ScrollingEditBoxTemplate")
	textBox:SetPoint("TOPLEFT", frame, "TOPLEFT", PADDING, -(HEADER_HEIGHT + PADDING))
	textBox:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -(PADDING + SCROLLBAR_WIDTH + 6), FOOTER_HEIGHT + PADDING / 2)
	frame.textBox = textBox

	local editBox = textBox:GetEditBox()
	editBox:SetMaxLetters(0)
	frame.editBox = editBox

	local scrollBox = textBox:GetScrollBox()
	local scrollBar = CreateFrame("EventFrame", nil, frame, "MinimalScrollBar")
	scrollBar:SetPoint("TOPLEFT", textBox, "TOPRIGHT", 6, 0)
	scrollBar:SetPoint("BOTTOMLEFT", textBox, "BOTTOMRIGHT", 6, 0)
	ScrollUtil.RegisterScrollBoxWithScrollBar(scrollBox, scrollBar)
	S:HandleTrimScrollBar(scrollBar)

	-- Read-only: whatever changes the text (typing, Enter, paste) is undone
	textBox:RegisterCallback("OnTextChanged", function(_, box)
		if frame.text and box:GetText() ~= frame.text then
			box:SetText(frame.text)
			box:HighlightText()
		end
	end, frame)
	textBox:RegisterCallback("OnEscapePressed", function()
		frame:Hide()
	end, frame)

	-- Footer: line count and a copy hint
	local count = frame:CreateFontString(nil, "OVERLAY")
	count:FontTemplate(nil, 11)
	count:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", PADDING, PADDING / 2 + 2)
	count:SetTextColor(0.6, 0.6, 0.6)
	frame.Count = count

	local hint = frame:CreateFontString(nil, "OVERLAY")
	hint:FontTemplate(nil, 11)
	hint:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -(PADDING + GRIP_SIZE), PADDING / 2 + 2)
	hint:SetTextColor(0.6, 0.6, 0.6)
	hint:SetText(L["Press Ctrl+C to copy the selected text."])

	return frame
end

-------------------------------------------------------------------------------
-- API
-------------------------------------------------------------------------------
---Fill the open window again from its chat frame, e.g. after the colors toggle
function module:UpdateCopyChat()
	if not (window and window:IsShown() and window.chatFrame) then
		return
	end

	if not IsEnabled() then
		window:Hide()
		return
	end

	local db = GetDB()
	local collected = CollectLines(window.chatFrame, db.colors)
	local text = #collected > 0 and tconcat(collected, "\n") or ""

	local chatName = GetChatName(window.chatFrame)
	window.Title:SetText(MER.Title .. L["Copy Chat"] .. (chatName and (" - " .. chatName) or ""))
	window.Count:SetText(format(L["%d lines"], #collected))
	window.Colors:SetChecked(db.colors)

	-- Set on the edit box directly, so the scroll step follows the font height
	window.editBox:FontTemplate(nil, db.fontSize, "NONE")
	window.textBox:GetScrollBox():SetPanExtent(window.editBox:GetFontHeight())

	window.text = text
	window.textBox:SetText(text)

	-- Open at the newest lines, everything selected and ready for Ctrl+C. The
	-- scroll box lays the text out on the next frame.
	C_Timer.After(0, function()
		if not window:IsShown() or window.text ~= text then
			return
		end

		local editBox = window.editBox
		editBox:SetFocus()
		editBox:SetCursorPosition(#text)
		editBox:HighlightText()
		window.textBox:GetScrollBox():ScrollToEnd(true)
	end)
end

---Open the copy window for a chat frame, or close it if it already shows that one
---@param chatFrame table
function module:ToggleCopyChat(chatFrame)
	if window and window:IsShown() and window.chatFrame == chatFrame then
		window:Hide()
		return
	end

	window = window or CreateWindow()
	window.chatFrame = chatFrame
	window:Show()
	window:Raise()
	self:UpdateCopyChat()
end

-- Every way into ElvUI's copy window (our sidebar button, ElvUI's copy button
-- on each chat) goes through CH:CopyChat, so taking it over opens ours.
function module:CH_CopyChat(ch, chatFrame)
	if IsEnabled() then
		return self:ToggleCopyChat(chatFrame)
	end

	if window then
		window:Hide()
	end

	return self.hooks[CH].CopyChat(ch, chatFrame)
end

function module:InitializeCopyChat()
	if not self:IsHooked(CH, "CopyChat") then
		self:RawHook(CH, "CopyChat", "CH_CopyChat")
	end
end
