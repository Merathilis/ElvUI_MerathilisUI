local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc") ---@class Misc

--[[
	Dialog Keys: answer NPC windows from the keyboard. The dialog key (Space unless
	changed) presses the window's main button: Accept, Continue, Complete Quest, or in a
	gossip window the top choice (a quest ready to turn in, else a new quest, else the
	first open option). Number keys 1-9 and 0, top row or numpad, press the numbered
	choices (gossip rows, greeting quests, quest rewards); each of those shows its number,
	in gold on a quest ready to turn in. Confirm Popups (off by default) lets the dialog
	key press Yes on the abandon quest popups.

	Taint: every press is a real click on Blizzard's own button, made by the secure
	"click" action of a SecureActionButtonTemplate proxy that a priority override binding
	fires. Blizzard's handler runs exactly as it does for the mouse. Blizzard's frames are
	only read here, the button to click reaches the proxy as an attribute.

	Combat: binding writes and secure attributes are combat-restricted, so keys are laid
	down only out of combat and all lifted at PLAYER_REGEN_DISABLED (protected writes are
	still legal until that handler returns). Changes in combat wait for combat end.

	Cost: nothing is built until the first enable. Events and the gossip list callback are
	registered only while on, the hooks (installed once) return at once while off.
]]

local _G = _G
local next = next
local pairs = pairs
local setmetatable = setmetatable
local wipe = wipe

local ClearOverrideBindings = ClearOverrideBindings
local CreateFrame = CreateFrame
local GetActiveTitle = GetActiveTitle
local GetNumActiveQuests = GetNumActiveQuests
local GetNumQuestChoices = GetNumQuestChoices
local GetTime = GetTime
local hooksecurefunc = hooksecurefunc
local InCombatLockdown = InCombatLockdown
local SetOverrideBinding = SetOverrideBinding
local SetOverrideBindingClick = SetOverrideBindingClick

local C_Timer_After = C_Timer.After
local C_Timer_NewTimer = C_Timer.NewTimer

local LOCKOUT = 0.5 -- seconds the dialog key stays ours after an answer, so a quick extra press never jumps
local HOLD_LIMIT = 3 -- longest a pressed key stays ours after its window closed, waiting for the release
local LABEL_SIZE = 12 -- reward tile numbers
local ROW_LABEL_SIZE = 9 -- dialog row numbers, small enough to clear the 16 px quest icon's ! or ?
local READY = "|cffffd100" -- number of a quest ready to turn in (NORMAL_FONT_COLOR)
local NUM_KEYS = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" } -- slot n presses choice n
local NUMPAD_KEYS = {
	"NUMPAD1",
	"NUMPAD2",
	"NUMPAD3",
	"NUMPAD4",
	"NUMPAD5",
	"NUMPAD6",
	"NUMPAD7",
	"NUMPAD8",
	"NUMPAD9",
	"NUMPAD0",
}
local MAX_SLOT = #NUM_KEYS -- slot 0 is the dialog key

-- Popups the dialog key may press Yes on: only confirmations of something the player just
-- asked for. Never one another player or the game sends (summons, invites, duels): the
-- dialog key is usually the jump key, and a jump at the wrong moment would accept it.
local POPUPS = { ABANDON_QUEST = true, ABANDON_QUEST_WITH_ITEMS = true }

local EVENTS = {
	"GOSSIP_SHOW",
	"GOSSIP_CLOSED",
	"QUEST_GREETING",
	"QUEST_DETAIL",
	"QUEST_PROGRESS",
	"QUEST_COMPLETE",
	"QUEST_FINISHED",
	"PLAYER_REGEN_DISABLED",
}

local enabled, built = false, false
local owner -- event frame and override binding owner
local proxies = {} -- [slot] secure click proxy, built on first use
local bound = {} -- [key] = slot whose proxy the key is laid on
local boundTo = {} -- [slot] Blizzard button the proxy clicks (nil = a press does nothing)
local heldAt = {} -- [slot] when a press began whose release has not arrived yet
local want = {} -- Sync scratch: [slot] = button, false (bound, does nothing) or nil (not bound)
local wantKey = {} -- Sync scratch: [key] = slot the key should be laid on
local keyed = {} -- Sync scratch: [slot] = true when the slot holds at least one key
local ready = {} -- Sync scratch: [Blizzard button] = true on a quest ready to turn in
local labels = setmetatable({}, { __mode = "k" }) -- [Blizzard button] = our number FontString on it
local shown = {} -- [Blizzard button] = true while its number shows
local pickable = {} -- [gossip row type] = "active" | "available" | "option"
local popups = {} -- StaticPopup1-4, hooked once Confirm Popups is first on
local lockUntil = 0
local syncQueued, expiry, combatQueued
local Sync -- forward

local function DB()
	return E.db.mui.misc.dialogKeys
end

local function QueueSync()
	if syncQueued then
		return
	end

	syncQueued = true
	C_Timer_After(0, Sync)
end

-- One pending catch-up after combat, however often it is asked for
local function SyncAfterCombat()
	if combatQueued then
		return
	end

	combatQueued = true
	F.Event.ContinueOutOfCombat(function()
		combatQueued = false
		module:DialogKeys()
	end)
end

-- An empty key means the player cleared it
local function DialogKey()
	local key = DB().key
	return key ~= "" and key or nil
end

-------------------------------------------------------------------------------
--  Proxies and bindings
-------------------------------------------------------------------------------
-- The press is marked held and the lockout started ahead of the click: a window or popup
-- the click closes (and the Sync that runs inside it) must still find the key ours.
local function OnPreClick(self, _, down)
	local slot = self.slot
	if down then
		heldAt[slot] = GetTime()
	elseif not heldAt[slot] and boundTo[slot] then
		-- A release whose press began before the key was ours (held while the window
		-- opened). With cast on key up it would click, so it goes nowhere and Sync re-aims
		-- after. Keys are only ever bound out of combat, so the write is allowed.
		self:SetAttribute("clickbutton", nil)
		boundTo[slot] = nil
	end

	-- Either phase can click (the one matching the cast on key down setting), so the
	-- lockout runs from whichever came last
	if slot == 0 and boundTo[0] then
		lockUntil = GetTime() + LOCKOUT
	end
end

local function OnPostClick(self, _, down)
	if not down then
		heldAt[self.slot] = nil
		QueueSync()
	end
end

local function Proxy(slot)
	local proxy = proxies[slot]
	if not proxy then
		proxy = CreateFrame("Button", "MER_DialogKeysButton" .. slot, E.UIParent, "SecureActionButtonTemplate")
		proxy:SetSize(1, 1)
		proxy:SetAlpha(0)
		proxy:EnableMouse(false)
		-- Both phases: the secure handler acts on the one matching the cast on key down setting
		proxy:RegisterForClicks("AnyDown", "AnyUp")
		proxy:SetAttribute("type", "click")
		proxy.slot = slot
		proxy:SetScript("PreClick", OnPreClick)
		proxy:SetScript("PostClick", OnPostClick)
		proxies[slot] = proxy
	end

	return proxy
end

-- The keys each wanted slot should hold: the dialog key on slot 0, both number keys of
-- every wanted choice. A dialog key set to a number key takes that key from its choice.
local function CollectKeys()
	wipe(wantKey)
	for slot = 0, MAX_SLOT do
		keyed[slot] = nil
	end

	local dialogKey = DialogKey()
	if want[0] ~= nil and dialogKey then
		wantKey[dialogKey] = 0
		keyed[0] = true
	end

	if not DB().numbers then
		return
	end

	for slot = 1, MAX_SLOT do
		if want[slot] ~= nil then
			local top, pad = NUM_KEYS[slot], NUMPAD_KEYS[slot]
			if top ~= dialogKey then
				wantKey[top] = slot
				keyed[slot] = true
			end
			if pad ~= dialogKey then
				wantKey[pad] = slot
				keyed[slot] = true
			end
		end
	end
end

-------------------------------------------------------------------------------
--  What each window's keys press (reads only)
-------------------------------------------------------------------------------
-- A listed popup sits on top of everything, so it comes first
local function ActiveWindow()
	if DB().popups then
		for i = 1, #popups do
			local popup = popups[i]
			if popup:IsVisible() and POPUPS[popup.which] then
				return "popup", popup
			end
		end
	end

	local questFrame = _G.QuestFrame
	if questFrame and questFrame:IsVisible() then
		if _G.QuestFrameRewardPanel:IsVisible() then
			return "reward"
		elseif _G.QuestFrameProgressPanel:IsVisible() then
			return "progress"
		elseif _G.QuestFrameDetailPanel:IsVisible() then
			return "detail"
		elseif _G.QuestFrameGreetingPanel:IsVisible() then
			return "greeting"
		end
	end

	local gossipFrame = _G.GossipFrame
	if gossipFrame and gossipFrame:IsVisible() then
		return "gossip"
	end
end

-- Gossip rows in view, numbered by Blizzard's own row index. The dialog key takes the
-- best rank, the lowest number within it.
local topRank, topIndex, topButton
local function ConsiderGossipRow(frame, elementData)
	local index = elementData and elementData.index
	local kind = index and pickable[elementData.buttonType]
	if not kind then
		return
	end

	if index <= MAX_SLOT then
		want[index] = frame
	end

	local info, rank = elementData.info, nil
	if kind == "active" then
		if info and info.isComplete then
			rank = 1
			ready[frame] = true
		end
	elseif kind == "available" then
		rank = 2
	else
		local status = info and info.status
		if status == nil or status == Enum.GossipOptionStatus.Available then
			rank = 3
		end
	end

	if rank and (not topRank or rank < topRank or (rank == topRank and index < topIndex)) then
		topRank, topIndex, topButton = rank, index, frame
	end
end

local function GossipBox()
	local panel = _G.GossipFrame and _G.GossipFrame.GreetingPanel
	return panel and panel.ScrollBox
end

local function GossipTargets()
	local scrollBox = GossipBox()
	if not (scrollBox and scrollBox.ForEachFrame) then
		return
	end

	topRank, topIndex, topButton = nil, nil, nil
	scrollBox:ForEachFrame(ConsiderGossipRow)
	want[0] = topButton or false
	topButton = nil
end

-- Greeting quests in Blizzard's order: current quests first, then available ones
local function GreetingTargets()
	local pool = _G.QuestFrameGreetingPanel.titleButtonPool
	if not pool then
		return
	end

	local numActive = GetNumActiveQuests()
	local turnIn, turnInIndex, offer, offerIndex
	for button in pool:EnumerateActive() do
		local id = button:GetID()
		local isActive = button.isActive == 1
		local index = isActive and id or numActive + id
		if index >= 1 and index <= MAX_SLOT then
			want[index] = button
		end

		if isActive then
			local _, isComplete = GetActiveTitle(id)
			if isComplete then
				ready[button] = true
				if not turnInIndex or index < turnInIndex then
					turnIn, turnInIndex = button, index
				end
			end
		elseif not offerIndex or index < offerIndex then
			offer, offerIndex = button, index
		end
	end

	want[0] = turnIn or offer or false
end

local function QuestTargets(window)
	if window == "detail" then
		want[0] = _G.QuestFrameAcceptButton
	elseif window == "progress" then
		want[0] = _G.QuestFrameCompleteButton
	else
		want[0] = _G.QuestFrameCompleteQuestButton

		-- With several rewards a number key picks one (Blizzard's own pick and
		-- highlight), the dialog key then completes with it
		local numChoices = GetNumQuestChoices()
		local rewardsFrame = _G.QuestInfoRewardsFrame
		local buttons = numChoices > 1 and rewardsFrame and rewardsFrame.RewardButtons
		if buttons then
			for i = 1, #buttons do
				local button = buttons[i]
				if button.type == "choice" and button:IsVisible() then
					local id = button:GetID()
					if id >= 1 and id <= numChoices and id <= MAX_SLOT then
						want[id] = button
					end
				end
			end
		end
	end
end

-------------------------------------------------------------------------------
--  Number labels: own FontStrings parented to the buttons they number, so they scroll,
--  clip and hide with them. Blizzard's text and icons are untouched.
-------------------------------------------------------------------------------
local function Label(button, size)
	local label = labels[button]
	if not label then
		label = button:CreateFontString(nil, "OVERLAY")
		label:SetDrawLayer("OVERLAY", 7) -- above a reward tile's quality ring and overlays
		labels[button] = label
	end

	if label.merSize ~= size then
		label:FontTemplate(nil, size, "SHADOWOUTLINE")
		label:SetTextColor(1, 1, 1)
		label.merSize = size
	end

	return label
end

local function HideLabels()
	for button in pairs(shown) do
		labels[button]:Hide()
		shown[button] = nil
	end
end

-- A number shows exactly on the buttons a number key is bound to right now
local function UpdateLabels()
	for button in pairs(shown) do
		shown[button] = false
	end

	for _, slot in pairs(bound) do
		local button = slot > 0 and boundTo[slot]
		if button and not shown[button] then
			local choice = button.type == "choice"
			local label = Label(button, choice and LABEL_SIZE or ROW_LABEL_SIZE)
			local icon = button.Icon or button
			label:ClearAllPoints()
			if choice then
				label:SetPoint("TOPLEFT", icon, "TOPLEFT", 2, -2) -- inside the item icon's corner
			else
				label:SetPoint("TOPLEFT", icon, "TOPLEFT", -2, 1) -- the bullet icon's corner, into the margin
			end

			-- Gold goes into the text: skins may set every FontString of a row white
			label:SetText(ready[button] and READY .. NUM_KEYS[slot] .. "|r" or NUM_KEYS[slot])
			label:Show()
			shown[button] = true
		end
	end

	for button, on in pairs(shown) do
		if not on then
			labels[button]:Hide()
			shown[button] = nil
		end
	end
end

-------------------------------------------------------------------------------
--  Sync: the one place keys are laid down, re-aimed and lifted
-------------------------------------------------------------------------------
local function ScheduleExpiry()
	if expiry then
		expiry:Cancel()
		expiry = nil
	end

	local now, at = GetTime(), nil
	if lockUntil > now then
		at = lockUntil
	end

	for slot = 0, MAX_SLOT do
		local pressed = heldAt[slot]
		if pressed then
			pressed = pressed + HOLD_LIMIT
			if not at or pressed < at then
				at = pressed
			end
		end
	end

	if at then
		expiry = C_Timer_NewTimer(at - now + 0.02, function()
			expiry = nil
			Sync()
		end)
	end
end

Sync = function()
	syncQueued = false
	if not owner then
		return
	end

	if InCombatLockdown() then
		-- Nothing is bound in combat (all lifted at PLAYER_REGEN_DISABLED), catch up after
		if enabled then
			SyncAfterCombat()
		end
		return
	end

	for slot = 0, MAX_SLOT do
		want[slot] = nil
	end
	wipe(ready)

	if enabled then
		local window, popup = ActiveWindow()
		if window == "popup" then
			-- Yes, the number keys stay the game's. Older popup code has no getter.
			want[0] = (popup.GetButton1 and popup:GetButton1() or popup.button1) or false
		elseif window == "gossip" then
			GossipTargets()
		elseif window == "greeting" then
			GreetingTargets()
		elseif window then
			QuestTargets(window)
		end

		local now = GetTime()
		-- Right after an answer the dialog key stays ours, doing nothing, so a quick extra
		-- press cannot jump
		if want[0] == nil and lockUntil > now then
			want[0] = false
		end

		-- A pressed key stays ours (doing nothing) until it is released: a lifted override
		-- would hand the release to the game's own binding, and an action button set to
		-- cast on key up would fire. Once its window is gone it waits at most HOLD_LIMIT.
		for slot = 0, MAX_SLOT do
			local pressed = heldAt[slot]
			if pressed and want[slot] == nil then
				if now - pressed > HOLD_LIMIT then
					heldAt[slot] = nil
				else
					want[slot] = false
				end
			end
		end
	end

	CollectKeys()

	-- Lift first: a key can move between slots (a number key becoming the dialog key),
	-- a lift after the lay down would clear its new owner
	for key, slot in pairs(bound) do
		if wantKey[key] ~= slot then
			SetOverrideBinding(owner, true, key, nil)
			bound[key] = nil
		end
	end

	-- Aim each proxy before its keys go down
	for slot = 0, MAX_SLOT do
		if keyed[slot] then
			local target = want[slot] or nil
			if boundTo[slot] ~= target then
				Proxy(slot):SetAttribute("clickbutton", target)
				boundTo[slot] = target
			end
		end
	end

	for key, slot in pairs(wantKey) do
		if bound[key] ~= slot then
			SetOverrideBindingClick(owner, true, key, Proxy(slot):GetName(), "LeftButton")
			bound[key] = slot
		end
	end

	UpdateLabels()
	ScheduleExpiry()
end

-- InCombatLockdown() already reports true at PLAYER_REGEN_DISABLED, but protected writes
-- stay legal until this handler returns: lift every key now
local function ReleaseForCombat()
	local had = next(bound) ~= nil
	wipe(bound)
	for slot = 0, MAX_SLOT do
		heldAt[slot] = nil
	end

	if had then
		ClearOverrideBindings(owner)
	end

	lockUntil = 0
	if expiry then
		expiry:Cancel()
		expiry = nil
	end

	HideLabels()
	if had then
		SyncAfterCombat()
	end
end

local function OnEvent(_, event)
	if event == "PLAYER_REGEN_DISABLED" then
		ReleaseForCombat()
		return
	end

	-- Now for whatever Blizzard has already shown, and again next frame, once every
	-- handler of this event has run
	Sync()
	QueueSync()
end

-- Blizzard rebuilt a list (gossip rows, greeting quests, reward tiles): re-aim in the
-- same call, before another key press can arrive
local function OnListRefresh()
	if enabled then
		Sync()
	end
end

local function OnPopupChange()
	if enabled and DB().popups then
		Sync()
	end
end

-- Blizzard never refills a showing popup for another one: it hides it, sets its which
-- and shows it again, so OnShow and OnHide see every change
local popupsHooked = false
local function InstallPopupHooks()
	if popupsHooked then
		return
	end

	popupsHooked = true
	for i = 1, _G.STATICPOPUP_NUMDIALOGS or 4 do
		local popup = _G["StaticPopup" .. i]
		if popup then
			popups[#popups + 1] = popup
			popup:HookScript("OnShow", OnPopupChange)
			popup:HookScript("OnHide", OnPopupChange)
		end
	end
end

local function Build()
	built = true
	owner = CreateFrame("Frame")
	owner:SetScript("OnEvent", OnEvent)

	if _G.GOSSIP_BUTTON_TYPE_ACTIVE_QUEST then
		pickable[_G.GOSSIP_BUTTON_TYPE_ACTIVE_QUEST] = "active"
	end
	if _G.GOSSIP_BUTTON_TYPE_AVAILABLE_QUEST then
		pickable[_G.GOSSIP_BUTTON_TYPE_AVAILABLE_QUEST] = "available"
	end
	if _G.GOSSIP_BUTTON_TYPE_OPTION then
		pickable[_G.GOSSIP_BUTTON_TYPE_OPTION] = "option"
	end

	-- QUEST_LOG_UPDATE rebuilds call the greeting function directly, while the XML OnShow
	-- holds the original function, so both are hooked
	hooksecurefunc("QuestFrameGreetingPanel_OnShow", OnListRefresh)
	_G.QuestFrameGreetingPanel:HookScript("OnShow", OnListRefresh)
	hooksecurefunc("QuestInfo_Display", OnListRefresh)
end

local function SetGossipCallback(on)
	local scrollBox = GossipBox()
	if not scrollBox then
		return
	end

	if on and scrollBox.RegisterCallback then
		scrollBox:RegisterCallback(_G.ScrollBoxListMixin.Event.OnUpdate, OnListRefresh, owner)
	elseif not on and scrollBox.UnregisterCallback then
		scrollBox:UnregisterCallback(_G.ScrollBoxListMixin.Event.OnUpdate, owner)
	end
end

local function SetEvents(on)
	for i = 1, #EVENTS do
		if on then
			owner:RegisterEvent(EVENTS[i])
		else
			owner:UnregisterEvent(EVENTS[i])
		end
	end

	SetGossipCallback(on)
end

-- Login, the options and the key picker share this path
function module:DialogKeys()
	local db = DB()
	local on = db.enable == true

	if InCombatLockdown() then
		if enabled and not on then
			-- Nothing is bound in combat, so turning off needs no protected call
			enabled = false
			SetEvents(false)
			HideLabels()
		end

		-- Turning on, or a new key, waits for combat end
		SyncAfterCombat()
		return
	end

	if on and not built then
		Build()
	end

	if on and db.popups then
		InstallPopupHooks()
	end

	if on ~= enabled then
		enabled = on
		SetEvents(on)
		if not on then
			lockUntil = 0
			for slot = 0, MAX_SLOT do
				heldAt[slot] = nil
			end
		end
	end

	if built then
		Sync()
	end
end

module:AddCallback("DialogKeys")
