local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Chat")
local WS = W:GetModule("Skins")
local CH = E:GetModule("Chat")
local LO = E:GetModule("Layout")

local _G = _G
local format, gmatch, ipairs, select, strfind, unpack = format, string.gmatch, ipairs, select, strfind, unpack
local tconcat, tinsert, tremove = table.concat, table.insert, table.remove
local floor, max, min = math.floor, math.max, math.min

local BNGetNumFriends = BNGetNumFriends
local CreateFrame = CreateFrame
local GetCursorPosition = GetCursorPosition
local GetInventoryItemDurability = GetInventoryItemDurability
local GetNumGuildMembers = GetNumGuildMembers
local GetTime = GetTime
local InCombatLockdown = InCombatLockdown
local IsInGuild = IsInGuild
local IsShiftKeyDown = IsShiftKeyDown
local C_BattleNet = C_BattleNet
local C_FriendList = C_FriendList
local C_GuildInfo = C_GuildInfo
local C_Timer = C_Timer
local C_VoiceChat = C_VoiceChat

local issecretvalue = issecretvalue

local BINDING_HEADER_VOICE_CHAT = BINDING_HEADER_VOICE_CHAT
local BNET_CLIENT_WOW = _G.BNET_CLIENT_WOW or "WoW"
local CHAT_CHANNELS = CHAT_CHANNELS
local ERR_NOT_IN_COMBAT = ERR_NOT_IN_COMBAT
local NONE = NONE
local VOICE_TOOLTIP_DEAFEN = VOICE_TOOLTIP_DEAFEN
local VOICE_TOOLTIP_MUTE_MIC = VOICE_TOOLTIP_MUTE_MIC
local VOICE_TOOLTIP_UNDEAFEN = VOICE_TOOLTIP_UNDEAFEN
local VOICE_TOOLTIP_UNMUTE_MIC = VOICE_TOOLTIP_UNMUTE_MIC

-- ElvUI insets its tab strip 2px into the chat panel and the chat text 5px.
local EDGE_INSET = 2
local CHAT_INSET = 5
local TAB_GAP = 1

local ICON_ALPHA_HOVER = 1
local DIVIDER_ALPHA = 0.8
local UPDATE_THROTTLE = 0.1
local FADE_SPEED = 5
local GUILD_ROSTER_THROTTLE = 15

-- The voice buttons Blizzard docks to the chat, in the order ElvUI handles them.
local VOICE_BUTTONS = {
	"TextToSpeechButton",
	"ChatFrameChannelButton",
	"ChatFrameToggleVoiceDeafenButton",
	"ChatFrameToggleVoiceMuteButton",
}
local VOICE_SILENT_COLOR = { 0.9, 0.3, 0.3 }

-------------------------------------------------------------------------------
-- Helpers
-------------------------------------------------------------------------------
local function IsRightPanel(db)
	return db.panel == "RIGHT"
end

local function GetPanel(db)
	if IsRightPanel(db) then
		return _G.RightChatPanel, _G.RightChatTab, CH.RightChatWindow
	end

	return _G.LeftChatPanel, _G.LeftChatTab, CH.LeftChatWindow
end

-- Inside: the sidebar shares the chat panel and the chat text makes room.
-- Outside: its own block next to the panel, the chat stays untouched.
local function IsInside(db)
	return db.attach ~= "OUTSIDE"
end

local function GetPanelSize(db)
	if IsRightPanel(db) and CH.db.separateSizes then
		return CH.db.panelWidthRight, CH.db.panelHeightRight
	end

	return CH.db.panelWidth, CH.db.panelHeight
end

-- The window the sidebar acts on: the selected tab when the panel holds the
-- dock, otherwise whatever window is snapped to the panel.
local function GetTargetChat(db)
	local _, _, window = GetPanel(db)
	local dock = _G.GeneralDockManager

	if window and dock and window == dock.primary and _G.FCFDock_GetSelectedWindow then
		return _G.FCFDock_GetSelectedWindow(dock) or window
	end

	return window or _G.SELECTED_CHAT_FRAME or _G.ChatFrame1
end

local function GetHoverColor(db)
	if db.hoverClassColor then
		local cc = E.myClassColor
		return cc.r, cc.g, cc.b
	end

	return db.hoverColor.r, db.hoverColor.g, db.hoverColor.b
end

local function BlockedInCombat()
	if InCombatLockdown() then
		_G.UIErrorsFrame:AddMessage(E.InfoColor .. ERR_NOT_IN_COMBAT)
		return true
	end
end

local function ClickHint(button, text)
	local mouse = L["Left Click:"]
	if button == "RIGHT" then
		mouse = L["Right Click:"]
	elseif button == "MIDDLE" then
		mouse = L["Middle Click:"]
	end
	_G.GameTooltip:AddDoubleLine(format("%s |cffffffff%s|r", F.Icon(MER.Media.Mouse[button]), mouse), text, 1, 1, 1, 1, 1, 1)
end

-------------------------------------------------------------------------------
-- Counters
-------------------------------------------------------------------------------
local function GetFriendsOnline()
	local _, bnetOnline = BNGetNumFriends()
	local wowOnline = C_FriendList.GetNumOnlineFriends() or 0
	return bnetOnline or 0, wowOnline
end

-- Online Battle.net friends that are in World of Warcraft right now, going by the
-- game account the friends list shows for them. Only needed for the tooltip.
local function GetBattleNetFriendsInWoW()
	local numTotal = BNGetNumFriends() or 0
	local inWoW = 0

	for i = 1, numTotal do
		local accountInfo = C_BattleNet.GetFriendAccountInfo(i)
		local gameInfo = accountInfo and accountInfo.gameAccountInfo
		local client = gameInfo and gameInfo.isOnline and gameInfo.clientProgram
		if client and not (issecretvalue and issecretvalue(client)) and client == BNET_CLIENT_WOW then
			inWoW = inWoW + 1
		end
	end

	return inWoW
end

local lastGuildRoster = 0
local function GetGuildOnline()
	if not IsInGuild() then
		return 0
	end

	-- GuildRoster() fires GUILD_ROSTER_UPDATE itself, so the request is throttled
	-- or the update would feed on its own event.
	local now = GetTime()
	if now - lastGuildRoster >= GUILD_ROSTER_THROTTLE then
		lastGuildRoster = now
		C_GuildInfo.GuildRoster()
	end

	local _, online = GetNumGuildMembers()
	return online or 0
end

local function GetLowestDurability()
	local lowest = 100
	for slot = 1, 18 do
		local current, maximum = GetInventoryItemDurability(slot)
		if current and maximum and maximum > 0 then
			lowest = min(lowest, current / maximum * 100)
		end
	end

	return floor(lowest)
end

-------------------------------------------------------------------------------
-- Voice chat
-------------------------------------------------------------------------------
-- Logged in, in a channel, microphone off, speakers off. Being silenced counts
-- as muted because the result is the same: nobody hears you.
local function GetVoiceState()
	if not C_VoiceChat.IsLoggedIn() then
		return false
	end

	local muted = C_VoiceChat.IsMuted() or C_VoiceChat.IsSilenced() or C_VoiceChat.IsParentalMuted()
	return true, C_VoiceChat.GetActiveChannelID() ~= nil, muted, C_VoiceChat.IsDeafened()
end

local function GetVoiceChannelName()
	local channelID = C_VoiceChat.GetActiveChannelID()
	local channel = channelID and C_VoiceChat.GetChannel(channelID)
	return channel and channel.name
end

-------------------------------------------------------------------------------
-- Buttons
-------------------------------------------------------------------------------
local BUTTONS = {
	{
		key = "friends",
		label = L["Friends"],
		counter = true,
		onClick = function()
			if not BlockedInCombat() then
				_G.ToggleFriendsFrame()
			end
		end,
		tooltip = function()
			-- Character friends are in WoW by definition; Battle.net friends only while they play it.
			local bnet, characters = GetFriendsOnline()
			local bnetInWoW = GetBattleNetFriendsInWoW()
			_G.GameTooltip:AddDoubleLine(L["World of Warcraft"], bnetInWoW + characters, 1, 1, 1, 1, 1, 1)
			_G.GameTooltip:AddDoubleLine(L["Other Games / App"], bnet - bnetInWoW, 1, 1, 1, 1, 1, 1)
		end,
	},
	{
		key = "guild",
		label = L["Guild"],
		counter = true,
		onClick = function()
			if not BlockedInCombat() then
				_G.ToggleGuildFrame()
			end
		end,
		tooltip = function()
			if IsInGuild() then
				_G.GameTooltip:AddDoubleLine(L["Online"], select(2, GetNumGuildMembers()) or 0, 1, 1, 1, 1, 1, 1)
			end
		end,
	},
	{
		key = "durability",
		label = L["Durability"],
		counter = true,
		onClick = function()
			if not BlockedInCombat() then
				_G.ToggleCharacter("PaperDollFrame")
			end
		end,
	},
	{
		key = "copy",
		label = L["Copy Chat"],
		onClick = function(btn, mouseButton)
			if mouseButton == "RightButton" then
				module:OpenChatMenu(btn)
			else
				CH:CopyChat(GetTargetChat(module.db))
			end
		end,
		tooltip = function()
			ClickHint("LEFT", L["Copy Chat"])
			ClickHint("RIGHT", L["Chat Menu"])
		end,
	},
	{
		key = "portals",
		label = L["M+ Portals"],
		onClick = function(btn)
			module:TogglePortalFlyout(btn)
		end,
		hideTooltip = function()
			return F.PortalFlyout.IsShown()
		end,
	},
	{
		key = "voice",
		label = L["Voice / Channels"],
		middleClick = true,
		onClick = function(_, mouseButton)
			if mouseButton == "RightButton" then
				if C_VoiceChat.IsLoggedIn() then
					_G.VoiceChat_ToggleMutedFromUserAction()
				end
			elseif mouseButton == "MiddleButton" then
				if C_VoiceChat.IsLoggedIn() then
					_G.VoiceChat_ToggleDeafenedFromUserAction()
				end
			elseif not BlockedInCombat() then
				_G.ToggleChannelFrame()
			end
		end,
		tooltip = function()
			local loggedIn, _, muted, deafened = GetVoiceState()

			if loggedIn then
				_G.GameTooltip:AddDoubleLine(BINDING_HEADER_VOICE_CHAT, GetVoiceChannelName() or NONE, 1, 1, 1, 1, 1, 1)
			end

			ClickHint("LEFT", CHAT_CHANNELS)

			if loggedIn then
				ClickHint("RIGHT", muted and VOICE_TOOLTIP_UNMUTE_MIC or VOICE_TOOLTIP_MUTE_MIC)
				ClickHint("MIDDLE", deafened and VOICE_TOOLTIP_UNDEAFEN or VOICE_TOOLTIP_DEAFEN)
			end
		end,
	},
	{
		key = "settings",
		label = L["Settings"],
		onClick = function(_, mouseButton)
			if mouseButton == "RightButton" then
				E:ToggleOptions("chat")
			else
				E:ToggleOptions("mui,modules,chat")
			end
		end,
		tooltip = function()
			ClickHint("LEFT", L["Chat Sidebar"])
			ClickHint("RIGHT", L["ElvUI Chat"])
		end,
	},
	{
		key = "scroll",
		label = L["Scroll to Bottom"],
		pinned = true,
		onClick = function()
			local chat = GetTargetChat(module.db)
			if chat and chat.ScrollToBottom then
				chat:ScrollToBottom()
			end
		end,
	},
}

function module:ColorButton(btn)
	local db = self.db
	local r, g, b, a

	if btn.hovered then
		r, g, b = GetHoverColor(db)
		a = ICON_ALPHA_HOVER
	elseif btn.stateColor then
		r, g, b = unpack(btn.stateColor)
		a = ICON_ALPHA_HOVER
	elseif btn.highlighted then
		r, g, b = GetHoverColor(db)
		a = ICON_ALPHA_HOVER
	else
		r, g, b, a = db.iconColor.r, db.iconColor.g, db.iconColor.b, db.iconAlpha
	end

	btn.Icon:SetVertexColor(r, g, b, a)
	if btn.Text then
		btn.Text:SetTextColor(btn.textR or 1, btn.textG or 1, btn.textB or 1)
	end
end

local function Button_OnEnter(btn)
	btn.hovered = true
	module:ColorButton(btn)

	local info = btn.info
	if info.hideTooltip and info.hideTooltip() then
		return
	end

	local tooltip = _G.GameTooltip
	tooltip:SetOwner(btn, module.db.side == "RIGHT" and "ANCHOR_LEFT" or "ANCHOR_RIGHT")
	tooltip:AddLine(info.label)
	if info.tooltip then
		info.tooltip()
	end
	if not info.pinned then
		tooltip:AddLine(L["Shift + Drag to reorder"], 0.6, 0.6, 0.6)
	end
	tooltip:Show()
end

local function Button_OnLeave(btn)
	btn.hovered = nil
	module:ColorButton(btn)
	_G.GameTooltip:Hide()
end

local function Button_OnClick(btn, mouseButton)
	if btn.justDragged then
		return
	end

	btn.info.onClick(btn, mouseButton)
end

-------------------------------------------------------------------------------
-- Shift + drag reorders the stacked icons (the scroll button stays pinned)
-------------------------------------------------------------------------------
-- The saved order is a plain key list; keys it doesn't know yet (new buttons)
-- are appended, unknown ones dropped.
function module:GetButtonOrder()
	local order, seen = {}, {}

	for key in gmatch(self.db.order or "", "[^,]+") do
		local btn = self.buttons[key]
		if btn and not btn.info.pinned and not seen[key] then
			seen[key] = true
			tinsert(order, key)
		end
	end

	for _, info in ipairs(BUTTONS) do
		if not info.pinned and not seen[info.key] then
			tinsert(order, info.key)
		end
	end

	return order
end

local function CursorOffsetFromTop(bar)
	local _, y = GetCursorPosition()
	return y / bar:GetEffectiveScale() - bar:GetTop()
end

local function Button_DragUpdate(btn)
	local bar = module.bar
	local offset = max(-bar:GetHeight(), min(0, CursorOffsetFromTop(bar)))

	btn:ClearAllPoints()
	btn:SetPoint("CENTER", bar, "TOP", 0, offset)
end

local function Button_OnDragStart(btn)
	if btn.info.pinned or not IsShiftKeyDown() then
		return
	end

	btn.dragging = true
	btn:SetAlpha(0.6)
	btn:SetFrameLevel(btn:GetFrameLevel() + 10)
	btn:SetScript("OnUpdate", Button_DragUpdate)
	_G.GameTooltip:Hide()
end

local function Button_OnDragStop(btn)
	if not btn.dragging then
		return
	end

	btn.dragging = nil
	btn:SetScript("OnUpdate", nil)
	btn:SetAlpha(1)
	btn:SetFrameLevel(btn:GetFrameLevel() - 10)

	-- Swallow the click that follows the mouse release.
	btn.justDragged = true
	C_Timer.After(0, function()
		btn.justDragged = nil
	end)

	module:DropButton(btn)
end

-- Drops the dragged icon in front of the first visible icon below the cursor.
function module:DropButton(dragged)
	local bar = self.bar
	local cursorY = CursorOffsetFromTop(bar) + bar:GetTop()

	local before
	for _, key in ipairs(self.visibleOrder or {}) do
		local btn = self.buttons[key]
		if btn ~= dragged then
			local _, centerY = btn:GetCenter()
			if centerY and centerY < cursorY then
				before = key
				break
			end
		end
	end

	local order = self:GetButtonOrder()
	for i, key in ipairs(order) do
		if key == dragged.info.key then
			tremove(order, i)
			break
		end
	end

	local index = #order + 1
	if before then
		for i, key in ipairs(order) do
			if key == before then
				index = i
				break
			end
		end
	end
	tinsert(order, index, dragged.info.key)

	self.db.order = tconcat(order, ",")
	self:UpdateSidebar()
end

function module:CreateButton(info)
	local btn = CreateFrame("Button", "MER_ChatSidebar" .. info.key:gsub("^%l", string.upper), self.bar.holder)
	if info.middleClick then
		btn:RegisterForClicks("LeftButtonUp", "MiddleButtonUp", "RightButtonUp")
	else
		btn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	end
	btn.info = info

	local icon = btn:CreateTexture(nil, "ARTWORK")
	icon:SetAllPoints()
	icon:SetTexture(I.Media.Icons.Chat[info.key])
	btn.Icon = icon

	if info.counter then
		local text = btn:CreateFontString(nil, "OVERLAY")
		text:SetPoint("TOP", btn, "BOTTOM", 0, 0)
		btn.Text = text
	end

	btn:SetScript("OnEnter", Button_OnEnter)
	btn:SetScript("OnLeave", Button_OnLeave)
	btn:SetScript("OnClick", Button_OnClick)

	if not info.pinned then
		btn:RegisterForDrag("LeftButton")
		btn:SetScript("OnDragStart", Button_OnDragStart)
		btn:SetScript("OnDragStop", Button_OnDragStop)
	end

	return btn
end

-- ElvUI's own copy button doubles as the chat menu on right-click, so the
-- sidebar button takes over both once it replaces it.
function module:OpenChatMenu(btn)
	if _G.ChatMenu then
		CH.OpenChatMenu(btn, _G.ChatMenu)
		return
	end

	local menuButton = _G.ChatFrameMenuButton
	if menuButton and menuButton.OpenMenu then
		menuButton:ClearAllPoints()
		menuButton:SetPoint(self.db.side == "RIGHT" and "TOPRIGHT" or "TOPLEFT", btn, self.db.side == "RIGHT" and "TOPLEFT" or "TOPRIGHT")
		menuButton:OpenMenu()
	end
end

function module:TogglePortalFlyout(btn)
	-- Opens over the chat text, growing away from the nearer screen edge.
	local inward = self.db.side == "RIGHT" and "RIGHT" or "LEFT"
	local outward = inward == "LEFT" and "RIGHT" or "LEFT"
	local gap = F.Dpi(4)
	local x = inward == "LEFT" and gap or -gap

	local _, centerY = btn:GetCenter()
	local vertical = (centerY and centerY < E.UIParent:GetHeight() / 2) and "BOTTOM" or "TOP"

	F.PortalFlyout.Toggle(btn, vertical .. inward, vertical .. outward, x, 0)
end

-------------------------------------------------------------------------------
-- Counter updates
-------------------------------------------------------------------------------
function module:UpdateFriends()
	local btn = self.buttons and self.buttons.friends
	if not btn or not btn:IsShown() then
		return
	end

	if InCombatLockdown() then
		self.friendsDirty = true
		return
	end

	self.friendsDirty = nil
	local bnet, wow = GetFriendsOnline()
	btn.Text:SetText(bnet + wow)
end

function module:UpdateGuild()
	local btn = self.buttons and self.buttons.guild
	if not btn or not btn:IsShown() then
		return
	end

	if InCombatLockdown() then
		self.guildDirty = true
		return
	end

	self.guildDirty = nil
	btn.Text:SetText(GetGuildOnline())
end

function module:UpdateDurability()
	local btn = self.buttons and self.buttons.durability
	if not btn or not btn:IsShown() then
		return
	end

	local pct = GetLowestDurability()
	btn.Text:SetText(pct .. "%")

	if pct <= self.db.durabilityWarning then
		btn.textR, btn.textG, btn.textB = 1, 0.2, 0.2
	else
		btn.textR, btn.textG, btn.textB = nil, nil, nil
	end
	self:ColorButton(btn)
end

-- Durability events land in bursts (one per damaged slot), so one recount
-- after the frame settles is enough.
function module:QueueDurability()
	if self.durabilityQueued then
		return
	end

	self.durabilityQueued = true
	C_Timer.After(0, function()
		self.durabilityQueued = nil
		self:UpdateDurability()
	end)
end

-- The icon lights up while a voice channel is active and turns into a crossed
-- out microphone as soon as the player can no longer be heard or hear others.
function module:UpdateVoice()
	local btn = self.buttons and self.buttons.voice
	if not btn then
		return
	end

	local loggedIn, active, muted, deafened = GetVoiceState()
	local silent = loggedIn and active and (muted or deafened) or false

	btn.Icon:SetTexture(silent and I.Media.Icons.Chat.voiceoff or I.Media.Icons.Chat.voice)
	btn.highlighted = (loggedIn and active) or nil
	btn.stateColor = silent and VOICE_SILENT_COLOR or nil
	self:ColorButton(btn)
end

-- Blizzard puts its own voice buttons back on every state change, so they are
-- faded out and made click-through instead of hidden.
function module:UpdateBlizzardVoiceButtons()
	local hidden = self:IsActive() and self.db.buttons.voice and self.db.hideVoiceButtons

	for _, name in ipairs(VOICE_BUTTONS) do
		local button = _G[name]
		if button then
			button:SetAlpha(hidden and 0 or 1)
			button:EnableMouse(not hidden)
		end
	end

	-- ElvUI's holder for the unpinned buttons has nothing left to show.
	if CH.VoicePanel then
		CH.VoicePanel:SetShown(not hidden)
		if not hidden then
			CH:ResetVoicePanelAlpha()
		end
	end

	-- ElvUI hangs the tab overflow button off the last voice button, which
	-- leaves a gap once they are gone. Its own pass runs right before this one.
	local overflow = _G.GeneralDockManagerOverflowButton
	if hidden and overflow then
		overflow:ClearAllPoints()
		overflow:Point("RIGHT", _G.GeneralDockManager, "RIGHT", -4, 0)
	end
end

function module:UpdateCounters()
	self:UpdateFriends()
	self:UpdateGuild()
	self:UpdateDurability()
	self:UpdateVoice()
end

function module:PLAYER_REGEN_ENABLED()
	if self.friendsDirty then
		self:UpdateFriends()
	end
	if self.guildDirty then
		self:UpdateGuild()
	end
end

local FRIEND_EVENTS = {
	"BN_FRIEND_LIST_SIZE_CHANGED",
	"BN_FRIEND_ACCOUNT_ONLINE",
	"BN_FRIEND_ACCOUNT_OFFLINE",
	"BN_CONNECTED",
	"BN_DISCONNECTED",
	"FRIENDLIST_UPDATE",
}
local GUILD_EVENTS = { "GUILD_ROSTER_UPDATE", "PLAYER_GUILD_UPDATE" }
local DURABILITY_EVENTS = { "UPDATE_INVENTORY_DURABILITY", "UPDATE_INVENTORY_ALERTS" }
local VOICE_EVENTS = {
	"VOICE_CHAT_LOGIN",
	"VOICE_CHAT_LOGOUT",
	"VOICE_CHAT_CHANNEL_ACTIVATED",
	"VOICE_CHAT_CHANNEL_DEACTIVATED",
	"VOICE_CHAT_MUTED_CHANGED",
	"VOICE_CHAT_DEAFENED_CHANGED",
	"VOICE_CHAT_SILENCED_CHANGED",
}

function module:RegisterCounterEvents()
	for _, event in ipairs(FRIEND_EVENTS) do
		self:RegisterEvent(event, "UpdateFriends")
	end
	for _, event in ipairs(GUILD_EVENTS) do
		self:RegisterEvent(event, "UpdateGuild")
	end
	for _, event in ipairs(DURABILITY_EVENTS) do
		self:RegisterEvent(event, "QueueDurability")
	end
	for _, event in ipairs(VOICE_EVENTS) do
		self:RegisterEvent(event, "UpdateVoice")
	end
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdateCounters")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
end

function module:UnregisterCounterEvents()
	for _, list in ipairs({ FRIEND_EVENTS, GUILD_EVENTS, DURABILITY_EVENTS, VOICE_EVENTS }) do
		for _, event in ipairs(list) do
			self:UnregisterEvent(event)
		end
	end
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")
end

-------------------------------------------------------------------------------
-- Sidebar frame
-------------------------------------------------------------------------------
-- One throttled tick drives the mouseover fade and the scroll button, which
-- lights up while the target window is scrolled away from the newest line.
local function Sidebar_OnUpdate(bar, elapsed)
	local db = module.db

	if db.visibility == "MOUSEOVER" then
		local target = (bar:IsMouseOver() or F.PortalFlyout.IsShown()) and 1 or 0
		local alpha = bar.holder:GetAlpha()
		if alpha ~= target then
			local step = elapsed * FADE_SPEED
			alpha = target > alpha and min(target, alpha + step) or max(target, alpha - step)
			bar.holder:SetAlpha(alpha)
		end
	end

	bar.elapsed = (bar.elapsed or 0) + elapsed
	if bar.elapsed < UPDATE_THROTTLE then
		return
	end
	bar.elapsed = 0

	local scroll = module.buttons.scroll
	if scroll and scroll:IsShown() then
		local chat = GetTargetChat(db)
		local highlighted = chat and chat.AtBottom and not chat:AtBottom() or nil
		if highlighted ~= scroll.highlighted then
			scroll.highlighted = highlighted
			module:ColorButton(scroll)
		end
	end
end

function module:CreateSidebar()
	local bar = CreateFrame("Frame", "MER_ChatSidebar", E.UIParent)
	bar:EnableMouse(false)
	bar:SetScript("OnUpdate", Sidebar_OnUpdate)
	self.bar = bar

	-- Only shown while the sidebar sits outside the panel as its own block.
	bar:CreateBackdrop("Transparent", nil, nil, nil, nil, nil, nil, true)
	WS:CreateShadow(bar.backdrop)

	local holder = CreateFrame("Frame", nil, bar)
	holder:SetAllPoints()
	bar.holder = holder

	-- Two halves meeting in the middle, so the line fades out towards both ends.
	bar.dividerTop = bar:CreateTexture(nil, "OVERLAY")
	bar.dividerTop:SetTexture(E.media.blankTex)
	bar.dividerBottom = bar:CreateTexture(nil, "OVERLAY")
	bar.dividerBottom:SetTexture(E.media.blankTex)

	self.buttons = {}
	for _, info in ipairs(BUTTONS) do
		self.buttons[info.key] = self:CreateButton(info)
	end
end

-- Class gradient like the rest of the UI: the shifted class color in the middle,
-- running into the normal one while it fades out towards the ends.
function module:UpdateDivider(isLeft)
	local bar = self.bar
	local edge = isLeft and "RIGHT" or "LEFT"
	local top, bottom = bar.dividerTop, bar.dividerBottom

	local classColorMap = E.db.mui.themes.gradientMode.classColorMap
	local normal = classColorMap[I.Enum.GradientMode.Color.NORMAL][E.myclass]
	local shift = classColorMap[I.Enum.GradientMode.Color.SHIFT][E.myclass]
	local alpha = DIVIDER_ALPHA

	top:ClearAllPoints()
	top:SetWidth(E.mult)
	top:SetPoint("TOP" .. edge)
	top:SetPoint("BOTTOM" .. edge, bar, edge)

	bottom:ClearAllPoints()
	bottom:SetWidth(E.mult)
	bottom:SetPoint("BOTTOM" .. edge)
	bottom:SetPoint("TOP" .. edge, bar, edge)

	-- VERTICAL gradients run bottom (first color) to top (second color).
	F.Color.SetGradientRGB(top, "VERTICAL", shift.r, shift.g, shift.b, alpha, normal.r, normal.g, normal.b, 0)
	F.Color.SetGradientRGB(bottom, "VERTICAL", normal.r, normal.g, normal.b, 0, shift.r, shift.g, shift.b, alpha)

	local shown = self.db.divider and IsInside(self.db)
	top:SetShown(shown)
	bottom:SetShown(shown)
end

function module:UpdateSidebar()
	local db = self.db
	local bar = self.bar
	local panel = GetPanel(db)
	local isLeft = db.side ~= "RIGHT"

	bar:SetParent(panel)
	bar:SetFrameStrata(panel:GetFrameStrata())
	bar:SetFrameLevel(panel:GetFrameLevel() + 5)
	bar:ClearAllPoints()
	if IsInside(db) then
		if isLeft then
			bar:Point("TOPLEFT", panel, "TOPLEFT", EDGE_INSET, -EDGE_INSET)
			bar:Point("BOTTOMLEFT", panel, "BOTTOMLEFT", EDGE_INSET, EDGE_INSET)
		else
			bar:Point("TOPRIGHT", panel, "TOPRIGHT", -EDGE_INSET, -EDGE_INSET)
			bar:Point("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -EDGE_INSET, EDGE_INSET)
		end
	else
		local gap = db.attachSpacing
		if isLeft then
			bar:Point("TOPRIGHT", panel, "TOPLEFT", -gap, 0)
			bar:Point("BOTTOMRIGHT", panel, "BOTTOMLEFT", -gap, 0)
		else
			bar:Point("TOPLEFT", panel, "TOPRIGHT", gap, 0)
			bar:Point("BOTTOMLEFT", panel, "BOTTOMRIGHT", gap, 0)
		end
	end
	bar:Width(db.width)
	bar.backdrop:SetShown(not IsInside(db))

	self:UpdateDivider(isLeft)

	bar.holder:SetAlpha(db.visibility == "MOUSEOVER" and 0 or 1)

	-- Stack from the top, scroll button pinned to the bottom. Whatever no longer
	-- fits the panel height is left out instead of spilling over the edge.
	local size, spacing = db.iconSize, db.spacing
	local counterHeight = db.counterFontSize
	local _, panelHeight = GetPanelSize(db)
	local available = panelHeight - EDGE_INSET * 2 - spacing * 2

	local scroll = self.buttons.scroll
	if db.buttons.scroll then
		available = available - size - spacing
	end

	local stacked = self:GetButtonOrder()
	tinsert(stacked, "scroll")

	local used, prev = 0, nil
	self.visibleOrder = {}
	for _, key in ipairs(stacked) do
		local btn = self.buttons[key]
		local info = btn.info
		btn:ClearAllPoints()
		btn:Size(size)

		if btn.Text then
			btn.Text:FontTemplate(nil, db.counterFontSize, "SHADOWOUTLINE")
		end

		local show = db.buttons[info.key]
		if show and not info.pinned then
			local height = size + (btn.Text and counterHeight or 0)
			if used + height > available then
				show = false
			else
				if prev then
					btn:Point("TOP", prev, "BOTTOM", 0, -(spacing + (prev.Text and counterHeight or 0)))
				else
					btn:Point("TOP", bar, "TOP", 0, -spacing)
				end
				used = used + height + spacing
				prev = btn
				tinsert(self.visibleOrder, key)
			end
		end

		btn:SetShown(show)
		btn.hovered, btn.highlighted, btn.stateColor = nil, nil, nil
		self:ColorButton(btn)
	end

	self:UpdateVoice()

	if db.buttons.scroll then
		scroll:Point("BOTTOM", bar, "BOTTOM", 0, spacing)
	end
end

-------------------------------------------------------------------------------
-- ElvUI chat layout hooks: make room for the sidebar inside the panel
-------------------------------------------------------------------------------
function module:IsActive()
	return self.db and self.db.enable and E.private.chat.enable and CH.Initialized and true or false
end

-- ElvUI rebuilds the tab strip anchors on every reposition, so shifting the
-- side that faces the sidebar never adds up.
function module:PostRepositionChatDataPanels()
	if not self:IsActive() or not IsInside(self.db) then
		return
	end

	local db = self.db
	local _, tab = GetPanel(db)
	local shift = E:Scale(db.width + TAB_GAP)
	local side = db.side == "RIGHT" and "RIGHT" or "LEFT"

	local points = {}
	for i = 1, tab:GetNumPoints() do
		points[i] = { tab:GetPoint(i) }
	end

	tab:ClearAllPoints()
	for _, point in ipairs(points) do
		local anchor, relativeTo, relativePoint, x, y = unpack(point)
		if strfind(anchor, side) then
			x = x + (side == "LEFT" and shift or -shift)
		end
		tab:SetPoint(anchor, relativeTo, relativePoint, x, y)
	end
end

-- The sidebar's copy button replaces the one ElvUI puts on every chat window.
-- ElvUI's "inside" edit box positions stretch the box over the whole panel,
-- which would cover the sidebar; shift the edge that faces it.
function module:PostUpdateEditboxAnchors()
	if not self:IsActive() or not IsInside(self.db) then
		return
	end

	local position = CH.db.editBoxPosition
	if position ~= "BELOW_CHAT_INSIDE" and position ~= "ABOVE_CHAT_INSIDE" then
		return
	end

	local db = self.db
	local panel = GetPanel(db)
	local side = db.side == "RIGHT" and "RIGHT" or "LEFT"
	local shift = E:Scale(db.width + TAB_GAP)

	for _, frameName in ipairs(_G.CHAT_FRAMES) do
		local chat = _G[frameName]
		local editbox = chat and chat.editBox
		local _, relativeTo = editbox and editbox:GetPoint(1)

		-- Only boxes ElvUI anchored to this panel (classic chat style).
		if relativeTo == panel then
			local points = {}
			for i = 1, editbox:GetNumPoints() do
				points[i] = { editbox:GetPoint(i) }
			end

			editbox:ClearAllPoints()
			for _, point in ipairs(points) do
				local anchor, anchorTo, relativePoint, x, y = unpack(point)
				if strfind(anchor, side) then
					x = x + (side == "LEFT" and shift or -shift)
				end
				editbox:SetPoint(anchor, anchorTo, relativePoint, x, y)
			end
		end
	end
end

function module:PostToggleChatButton(_, button)
	if button and self:IsActive() and self.db.buttons.copy then
		button:Hide()
	end
end

function module:PostPositionChat(_, chat)
	if not self:IsActive() or not IsInside(self.db) then
		return
	end

	local db = self.db
	local panel, _, window = GetPanel(db)
	if not window or chat ~= window then
		return
	end

	local panelWidth = GetPanelSize(db)
	local x = CHAT_INSET + (db.side == "RIGHT" and 0 or db.width)

	chat:ClearAllPoints()
	chat:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", x, CHAT_INSET)
	chat:SetWidth(panelWidth - CHAT_INSET * 2 - db.width)
end

-------------------------------------------------------------------------------
-- Lifecycle
-------------------------------------------------------------------------------
function module:SettingsUpdate()
	if not self.sidebarInitialized then
		return
	end

	local active = self:IsActive()

	if active then
		if not self.bar then
			self:CreateSidebar()
		end

		self:UpdateSidebar()
		self.bar:Show()

		if not self.eventsRegistered then
			self.eventsRegistered = true
			self:RegisterCounterEvents()
		end
		self:UpdateCounters()
	else
		if self.bar then
			self.bar:Hide()
		end

		if self.eventsRegistered then
			self.eventsRegistered = nil
			self:UnregisterCounterEvents()
		end
	end

	self:UpdateBlizzardVoiceButtons()

	-- Hand the panel back to ElvUI's layout (or take it over), the hooks above
	-- decide which one it gets.
	if E.private.chat.enable then
		CH:PositionChats()
		CH:ToggleCopyChatButtons()
		CH:UpdateEditboxAnchors()
		CH:RepositionOverflowButton()
	end
end

function module:InitializeSidebar()
	self:SecureHook(LO, "RepositionChatDataPanels", "PostRepositionChatDataPanels")
	self:SecureHook(CH, "PositionChat", "PostPositionChat")
	self:SecureHook(CH, "ToggleChatButton", "PostToggleChatButton")
	self:SecureHook(CH, "UpdateEditboxAnchors", "PostUpdateEditboxAnchors")
	self:SecureHook(CH, "RepositionOverflowButton", "UpdateBlizzardVoiceButtons")

	F.Event.RegisterCallback("ChatSidebar.SettingsUpdate", self.SettingsUpdate, self)

	self.sidebarInitialized = true
end
