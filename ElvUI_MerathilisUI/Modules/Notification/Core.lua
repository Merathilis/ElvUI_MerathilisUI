local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Notification")
local S = MER:GetModule("MER_Skins")
local WS = W:GetModule("Skins")

-- Credits RealUI
local unpack, type, pcall = unpack, type, pcall
local max, min = math.max, math.min
local table = table
local tinsert, tremove = table.insert, table.remove

local CreateFrame = CreateFrame
local UnitIsAFK = UnitIsAFK
local GetAtlasInfo = C_Texture.GetAtlasInfo
local GetTime = GetTime
local PlaySound = PlaySound
local After = C_Timer.After
local CreateAnimationGroup = CreateAnimationGroup
local SlashCmdList = SlashCmdList

-- Card layout in the style of the options cards: accent strip on the left,
-- icon top left, title and text as one block next to it, a timer bar at the
-- bottom. The height follows the text.
local TOAST_WIDTH = 290
local PADDING = 10
local ACCENT_WIDTH = 2
local ICON_SIZE = 36
local TEXT_GAP = 3
local MAX_TEXT_LINES = 3
local CLOSE_SIZE = 10
local ARROW_SIZE = 12
local TIMER_HEIGHT = 2
local MIN_HEIGHT = ICON_SIZE + PADDING * 2
-- Title and text keep clear of the close button and the click arrow
local TEXT_RIGHT_INSET = PADDING + CLOSE_SIZE + 4
local STACK_GAP = 6
local SLIDE_OFFSET = 54

local COLOR_ACCENT = { I.Colors.Accent.r, I.Colors.Accent.g, I.Colors.Accent.b }
local COLOR_TEXT = { 0.8, 0.8, 0.8 }
local COLOR_MUTED = { 0.62, 0.62, 0.62 }

local max_active_toasts = 3
local fadeout_delay = 5
local toasts = {}
local activeToasts = {}
local queuedToasts = {}
local anchorFrame

function module:SpawnToast(toast)
	if not toast then
		return
	end

	if #activeToasts >= max_active_toasts then
		tinsert(queuedToasts, toast)

		return false
	end

	local afk = UnitIsAFK("player")
	if E:NotSecretValue(afk) and afk then
		tinsert(queuedToasts, toast)
		self:RegisterEvent("PLAYER_FLAGS_CHANGED")

		return false
	end

	local YOffset
	if E:GetScreenQuadrant(anchorFrame):find("TOP") then
		YOffset = -SLIDE_OFFSET
	else
		YOffset = SLIDE_OFFSET
	end

	toast:ClearAllPoints()
	if #activeToasts > 0 then
		if E:GetScreenQuadrant(anchorFrame):find("TOP") then
			toast:SetPoint("TOP", activeToasts[#activeToasts], "BOTTOM", 0, -STACK_GAP - YOffset)
		else
			toast:SetPoint("BOTTOM", activeToasts[#activeToasts], "TOP", 0, STACK_GAP - YOffset)
		end
	else
		toast:SetPoint("TOP", anchorFrame, "TOP", 0, 1 - YOffset)
	end

	tinsert(activeToasts, toast)

	-- A toast closed by hand goes back into the pool fully visible
	toast:SetAlpha(0)
	toast:Show()
	toast.AnimIn.AnimMove:SetOffset(0, YOffset)
	toast.AnimOut.AnimMove:SetOffset(0, -YOffset)
	toast.AnimIn:Play()
	toast.AnimOut:Play()
	toast.timerStart = GetTime()

	if E.db.mui.notification.noSound ~= true then
		PlaySound(18019, "Master")
	end
end

function module:RefreshToasts()
	for i = 1, #activeToasts do
		local activeToast = activeToasts[i]
		local YOffset, _ = 0
		if activeToast.AnimIn.AnimMove:IsPlaying() then
			_, YOffset = activeToast.AnimIn.AnimMove:GetOffset()
		end
		if activeToast.AnimOut.AnimMove:IsPlaying() then
			_, YOffset = activeToast.AnimOut.AnimMove:GetOffset()
		end

		activeToast:ClearAllPoints()

		if i == 1 then
			activeToast:SetPoint("TOP", anchorFrame, "TOP", 0, 1 - YOffset)
		else
			if E:GetScreenQuadrant(anchorFrame):find("TOP") then
				activeToast:SetPoint("TOP", activeToasts[i - 1], "BOTTOM", 0, -STACK_GAP - YOffset)
			else
				activeToast:SetPoint("BOTTOM", activeToasts[i - 1], "TOP", 0, STACK_GAP - YOffset)
			end
		end
	end

	local queuedToast = tremove(queuedToasts, 1)

	if queuedToast then
		self:SpawnToast(queuedToast)
	end
end

function module:HideToast(toast)
	local wasActive = false
	for i = #activeToasts, 1, -1 do
		if toast == activeToasts[i] then
			tremove(activeToasts, i)
			wasActive = true
		end
	end

	-- Already back in the pool, a second insert would hand the frame out twice
	if not wasActive then
		return
	end

	toast.AnimIn:Stop()
	toast.AnimOut:Stop()
	tinsert(toasts, toast)
	toast:Hide()
	After(0.1, function()
		self:RefreshToasts()
	end)
end

local function ToastButtonAnimOut_OnFinished(self)
	module:HideToast(self:GetParent())
end

-- Text heights can come back as secret values (e.g. names from the social
-- queue), those fall back to the given number of font lines
local function GetTextHeight(fontString, fallbackLines)
	local height = fontString:GetStringHeight()
	if not height or E:IsSecretValue(height) then
		local _, size = fontString:GetFont()
		return (size or 12) * fallbackLines
	end

	return height
end

-- Hover reads like an options tile: accent border, tinted background, the
-- close button shows up and the click arrow lights up
function module:UpdateToastHover(toast)
	local hover = toast.isHovered
	local backdrop = toast.backdrop

	-- Read every time, a changed ElvUI backdrop color applies to pooled toasts too
	if hover then
		backdrop:SetBackdropColor(COLOR_ACCENT[1] * 0.18, COLOR_ACCENT[2] * 0.18, COLOR_ACCENT[3] * 0.18, 0.9)
		backdrop:SetBackdropBorderColor(COLOR_ACCENT[1], COLOR_ACCENT[2], COLOR_ACCENT[3], 1)
	else
		local bg = E.media.backdropfadecolor
		backdrop:SetBackdropColor(bg[1], bg[2], bg[3], bg[4])
		backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
	end

	toast.CloseButton:SetAlpha(hover and 1 or 0)
	toast.arrow:SetShown(toast.clickFunc ~= nil)
	toast.arrow:SetVertexColor(unpack(hover and COLOR_ACCENT or COLOR_MUTED))

	-- The countdown starts over once the mouse leaves, so it stands full while hovered
	toast.timer:SetAlpha(hover and 0.4 or 0.8)
	if hover then
		toast.timer:SetWidth(toast.timerWidth)
		toast.timer:Show()
	end
end

-- Sizes the toast to its text: title and text form one block that is centered
-- next to the icon while it is shorter than the icon, otherwise the toast grows
function module:LayoutToast(toast)
	local title, text = toast.title, toast.text

	local message = text:GetText()
	local hasText = message ~= nil and (E:IsSecretValue(message) or message ~= "")

	local contentHeight = GetTextHeight(title, 1)
	if hasText then
		local _, size = text:GetFont()
		local maxHeight = (size or 12) * 1.25 * MAX_TEXT_LINES
		contentHeight = contentHeight + TEXT_GAP + min(GetTextHeight(text, 1), maxHeight)
	end
	text:SetShown(hasText)

	title:ClearAllPoints()
	title:SetPoint("TOPLEFT", toast.icon, "TOPRIGHT", PADDING, -max(0, (ICON_SIZE - contentHeight) / 2))

	toast:SetHeight(max(MIN_HEIGHT, contentHeight + PADDING * 2))
	toast.timerWidth = TOAST_WIDTH - ACCENT_WIDTH - E.mult * 2
end

-- Frame and regions without animations or scripts, the options preview builds
-- its example toast with this as well
function module:BuildToastFrame(parent)
	local toast = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	toast:SetSize(TOAST_WIDTH, MIN_HEIGHT)
	toast:CreateBackdrop("Transparent")
	WS:CreateBackdropShadow(toast, true)
	toast:CreateCloseButton(CLOSE_SIZE)

	local accent = toast:CreateTexture(nil, "ARTWORK")
	accent:SetPoint("TOPLEFT", toast.backdrop, "TOPLEFT", E.mult, -E.mult)
	accent:SetPoint("BOTTOMLEFT", toast.backdrop, "BOTTOMLEFT", E.mult, E.mult)
	accent:SetWidth(ACCENT_WIDTH)
	accent:SetColorTexture(COLOR_ACCENT[1], COLOR_ACCENT[2], COLOR_ACCENT[3], 1)
	toast.accent = accent

	local timer = toast:CreateTexture(nil, "ARTWORK")
	timer:SetPoint("BOTTOMLEFT", accent, "BOTTOMRIGHT")
	timer:SetHeight(TIMER_HEIGHT)
	timer:SetColorTexture(COLOR_ACCENT[1], COLOR_ACCENT[2], COLOR_ACCENT[3], 1)
	toast.timer = timer

	local icon = toast:CreateTexture(nil, "OVERLAY")
	icon:SetSize(ICON_SIZE, ICON_SIZE)
	icon:SetPoint("TOPLEFT", toast, "TOPLEFT", PADDING + ACCENT_WIDTH, -PADDING)
	S:CreateBG(icon)
	toast.icon = icon

	-- Fixed widths instead of a right anchor, so the heights are known before
	-- the toast has its place on the screen
	local textWidth = TOAST_WIDTH - (PADDING + ACCENT_WIDTH + ICON_SIZE + PADDING) - TEXT_RIGHT_INSET

	local title = toast:CreateFontString(nil, "OVERLAY")
	title:FontTemplate()
	title:SetShadowOffset(1, -1)
	title:SetWidth(textWidth)
	title:SetJustifyH("LEFT")
	title:SetJustifyV("TOP")
	title:SetWordWrap(true)
	title:SetMaxLines(2)
	title:SetTextColor(1, 1, 1)
	toast.title = title

	local text = toast:CreateFontString(nil, "OVERLAY")
	text:FontTemplate()
	text:SetShadowOffset(1, -1)
	text:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -TEXT_GAP)
	text:SetWidth(textWidth)
	text:SetJustifyH("LEFT")
	text:SetJustifyV("TOP")
	text:SetWordWrap(true)
	text:SetMaxLines(MAX_TEXT_LINES)
	text:SetTextColor(unpack(COLOR_TEXT))
	toast.text = text

	local arrow = toast:CreateTexture(nil, "OVERLAY")
	arrow:SetSize(ARROW_SIZE, ARROW_SIZE)
	arrow:SetPoint("BOTTOMRIGHT", toast, "BOTTOMRIGHT", -6, 6)
	arrow:SetTexture(I.Media.Icons.Forward)
	arrow:Hide()
	toast.arrow = arrow

	self:LayoutToast(toast)

	return toast
end

local function Toast_OnUpdate(self)
	if self.isHovered or not self.timerStart then
		return
	end

	local width = self.timerWidth * (1 - (GetTime() - self.timerStart) / fadeout_delay)
	if width > 0 then
		self.timer:SetWidth(width)
		self.timer:Show()
	else
		self.timer:Hide()
	end
end

local function Toast_OnEnter(self)
	self.isHovered = true
	self.AnimOut:Stop()
	module:UpdateToastHover(self)
end

local function Toast_OnLeave(self)
	-- Moving onto the close button leaves the toast as well
	if not self.isHovered or self:IsMouseOver() then
		return
	end

	self.isHovered = nil
	self.AnimOut:Play()
	self.timerStart = GetTime()
	module:UpdateToastHover(self)
end

function module:CreateToast()
	local toast = tremove(toasts, 1)
	if toast then
		return toast
	end

	toast = self:BuildToastFrame(E.UIParent)
	toast:SetFrameStrata("HIGH")
	toast:SetPoint("TOP", E.UIParent, "TOP")
	toast:Hide()

	-- The button only hides the frame, the slot has to be given back as well
	toast.CloseButton:HookScript("OnClick", function(button)
		module:HideToast(button:GetParent())
	end)
	-- Leaving the button past the toast's edge never reaches the toast itself
	toast.CloseButton:HookScript("OnLeave", function(button)
		Toast_OnLeave(button:GetParent())
	end)

	toast.AnimIn = CreateAnimationGroup(toast)

	local animInAlpha = toast.AnimIn:CreateAnimation("Fade")
	animInAlpha:SetOrder(1)
	animInAlpha:SetChange(1)
	animInAlpha:SetDuration(0.5)
	toast.AnimIn.AnimAlpha = animInAlpha

	local animInMove = toast.AnimIn:CreateAnimation("Move")
	animInMove:SetOrder(1)
	animInMove:SetDuration(0.5)
	animInMove:SetEasing("Out")
	animInMove:SetOffset(-TOAST_WIDTH, 0)
	toast.AnimIn.AnimMove = animInMove

	toast.AnimOut = CreateAnimationGroup(toast)

	local animOutSleep = toast.AnimOut:CreateAnimation("Sleep")
	animOutSleep:SetOrder(1)
	animOutSleep:SetDuration(fadeout_delay)
	toast.AnimOut.AnimSleep = animOutSleep

	local animOutAlpha = toast.AnimOut:CreateAnimation("Fade")
	animOutAlpha:SetOrder(2)
	animOutAlpha:SetChange(0)
	animOutAlpha:SetDuration(0.5)
	toast.AnimOut.AnimAlpha = animOutAlpha

	local animOutMove = toast.AnimOut:CreateAnimation("Move")
	animOutMove:SetOrder(2)
	animOutMove:SetDuration(0.5)
	animOutMove:SetEasing("In")
	animOutMove:SetOffset(TOAST_WIDTH, 0)
	toast.AnimOut.AnimMove = animOutMove

	toast.AnimOut.AnimAlpha:SetScript("OnFinished", ToastButtonAnimOut_OnFinished)

	-- Only runs while the toast is shown, pooled toasts are hidden
	toast:SetScript("OnUpdate", Toast_OnUpdate)
	toast:SetScript("OnEnter", Toast_OnEnter)
	toast:SetScript("OnLeave", Toast_OnLeave)

	toast:SetScript("OnMouseUp", function(self, button)
		if button == "LeftButton" and self.clickFunc then
			self.clickFunc()
		end
	end)

	return toast
end

function module:DisplayToast(name, message, clickFunc, texture, ...)
	-- Nothing to anchor to while the module was disabled on load
	if not anchorFrame then
		return
	end

	local toast = self:CreateToast()

	-- Toasts are reused, so the fonts are set every time to pick up option changes
	local db = E.db.mui.notification
	WF.SetFontWithDB(toast.title, db.titleFont)
	WF.SetFontWithDB(toast.text, db.textFont)

	toast.clickFunc = type(clickFunc) == "function" and clickFunc or nil

	local safeTexture = texture and not E:IsSecretValue(texture) and texture or nil

	if safeTexture then
		local ok, atlas = pcall(GetAtlasInfo, safeTexture)
		if ok and atlas then
			toast.icon:SetAtlas(safeTexture)
		else
			toast.icon:SetTexture(safeTexture)
			local a, b, c, d = ...
			if a and not E:IsSecretValue(a) then
				toast.icon:SetTexCoord(a, b, c, d)
			else
				toast.icon:SetTexCoords()
			end
		end
	else
		toast.icon:SetTexture("Interface\\Icons\\achievement_general")
		toast.icon:SetTexCoords()
	end

	toast.title:SetText(name)
	toast.text:SetText(message)
	self:LayoutToast(toast)

	toast.isHovered = nil
	toast.timerStart = nil
	self:UpdateToastHover(toast)

	local ok, err = pcall(function()
		self:SpawnToast(toast)
	end)
	if not ok then
		F.Developer.ThrowError("DisplayToast:", err)
	end
end

function module:PLAYER_FLAGS_CHANGED(event)
	self:UnregisterEvent(event)
	for _ = 1, max_active_toasts - #activeToasts do
		self:RefreshToasts()
	end
end

function module:PLAYER_REGEN_ENABLED()
	for _ = 1, max_active_toasts - #activeToasts do
		self:RefreshToasts()
	end
end

-- Test function
local function testCallback()
	F.Print("Banner clicked!")
end

SlashCmdList.TESTNOTIFICATION = function(b)
	module:DisplayToast(
		F.cOption("MerathilisUI:", "gradient"),
		L["This is an example of a notification."],
		testCallback,
		b == "true" and "INTERFACE\\ICONS\\SPELL_FROST_ARCTICWINDS" or nil,
		0.08,
		0.92,
		0.08,
		0.92
	)
end
SLASH_TESTNOTIFICATION1 = "/testnotification"

-- Every notification checks its setting when it fires, only the events are set up here
function module:Initialize()
	if not E.db.mui.notification.enable then
		return
	end

	anchorFrame = CreateFrame("Frame", nil, E.UIParent)
	anchorFrame:Size(TOAST_WIDTH, 50)
	anchorFrame:Point("TOP", 0, -75)
	E:CreateMover(
		anchorFrame,
		"MER_NotificationMover",
		MER.Title .. L["Notification Mover"],
		nil,
		nil,
		nil,
		"ALL,SOLO,MERATHILISUI",
		nil,
		"mui,modules,Notification"
	)

	self.lastMinimapRare = { time = 0, id = nil }

	-- One-time calendar check after login, the handler unregisters itself
	local db = E.db.mui.notification
	if db.invites or db.guildEvents then
		self:RegisterEvent("PLAYER_ENTERING_WORLD")
	end

	self.initialized = true
	self:UpdateEvents()
end

-- Each event only while the notification that needs it is turned on
local EVENT_TOGGLES = {
	PLAYER_REGEN_ENABLED = function()
		return true
	end,
	UPDATE_INVENTORY_DURABILITY = function()
		return true
	end,
	UPDATE_PENDING_MAIL = function(db)
		return db.mail
	end,
	CALENDAR_UPDATE_PENDING_INVITES = function(db)
		return db.invites or db.guildEvents
	end,
	CALENDAR_UPDATE_GUILD_EVENTS = function(db)
		return db.guildEvents
	end,
	VIGNETTE_MINIMAP_UPDATED = function(db)
		return db.vignette and db.vignette.enable
	end,
	SOCIAL_QUEUE_UPDATE = function(db)
		return db.quickJoin
	end,
	LFG_UPDATE_RANDOM_INFO = function(db)
		return db.callToArms
	end,
	QUEST_ACCEPTED = function(db)
		return db.paragon
	end,
	WEEKLY_REWARDS_UPDATE = function(db)
		return db.greatVault
	end,
	CURRENCY_DISPLAY_UPDATE = function(db)
		local warning = db.currencyWarning
		return warning and warning.enable and next(warning.list)
	end,
	BAG_UPDATE_DELAYED = function(db)
		return db.bags
	end,
}

local EVENT_HANDLERS = {
	SOCIAL_QUEUE_UPDATE = "SocialQueueEvent",
}

-- Called after Initialize and whenever a notification setting changed
function module:UpdateEvents()
	if not self.initialized then
		return
	end

	local db = E.db.mui.notification
	for event, isNeeded in pairs(EVENT_TOGGLES) do
		if db.enable and isNeeded(db) then
			self:RegisterEvent(event, EVENT_HANDLERS[event])
		else
			self:UnregisterEvent(event)
		end
	end

	-- Chat events follow their own channel toggles, see Mentions.lua
	self:UpdateMentions()
end

function module:ProfileUpdate()
	self:UpdateEvents()
end

MER:RegisterModule(module:GetName())
