local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnlockMode")

-- Extends ElvUI's own mover mode instead of replacing it: positions stay in
-- E.db.movers, every feature here hooks the movers ElvUI already creates.
-- Idea from EllesmereUI's Unlock Mode, by EllesmereGaming.

local _G = _G
local max = math.max
local ipairs, next, pairs, sort, tinsert, wipe = ipairs, next, pairs, sort, tinsert, wipe

local CopyTable = CopyTable
local CreateFrame = CreateFrame
local GetTime = GetTime
local hooksecurefunc = hooksecurefunc
local InCombatLockdown = InCombatLockdown
local IsAltKeyDown = IsAltKeyDown
local IsControlKeyDown = IsControlKeyDown
local IsShiftKeyDown = IsShiftKeyDown
local UIParent = UIParent

-- Movers are sorted into this frame level range, below ElvUI's nudge window (500)
local SORT_BASE_LEVEL = 100
-- A mouse up this soon after a drag ended belongs to the drag, not to a click
local DRAG_CLICK_GUARD = 0.1

local ARROW_KEYS = {
	LEFT = { -1, 0 },
	RIGHT = { 1, 0 },
	UP = { 0, 1 },
	DOWN = { 0, -1 },
}

module.hookedMovers = {}

function module:IsActive()
	return self.db and self.db.enable
end

local function IterateMovers(func)
	for _, holder in pairs(E.CreatedMovers) do
		if holder.mover then
			func(holder.mover)
		end
	end
end

-------------------------------------------------------------------------------
--  Overlays
--  Plain BackdropTemplate frames on top of a mover, kept out of E.frames so
--  ElvUI's template sweep never repaints them.
-------------------------------------------------------------------------------
function module:ShowOverlay(mover, key, r, g, b, fillAlpha, pulse)
	local overlay = mover[key]
	if not overlay then
		overlay = CreateFrame("Frame", nil, mover, "BackdropTemplate")
		overlay:SetAllPoints()
		overlay:EnableMouse(false)
		overlay:SetBackdrop({ bgFile = E.media.blankTex, edgeFile = E.media.blankTex, edgeSize = E.mult * 2 })

		local anim = overlay:CreateAnimationGroup()
		anim:SetLooping("BOUNCE")
		local alpha = anim:CreateAnimation("Alpha")
		alpha:SetFromAlpha(1)
		alpha:SetToAlpha(0.35)
		alpha:SetDuration(0.45)
		overlay.pulse = anim

		mover[key] = overlay
	end

	overlay:SetFrameLevel(mover:GetFrameLevel() + 2)
	overlay:SetBackdropColor(r, g, b, fillAlpha)
	overlay:SetBackdropBorderColor(r, g, b, 1)
	overlay:Show()

	if pulse then
		overlay.pulse:Play()
	else
		overlay.pulse:Stop()
		overlay:SetAlpha(1)
	end
end

function module:HideOverlay(mover, key)
	local overlay = mover and mover[key]
	if overlay then
		overlay.pulse:Stop()
		overlay:Hide()
	end
end

-------------------------------------------------------------------------------
--  Selection
--  The selected mover is the one the arrow keys and ElvUI's nudge window move.
-------------------------------------------------------------------------------
-- Same placement as ElvUI's own nudge update (local UpdateCoords in Movers.lua)
function module:AttachNudge(mover)
	local nudge = E.MoverNudgeFrame
	if not nudge then
		return
	end

	nudge.child = mover
	local x, y, _, nudgePoint, nudgeInversePoint = E:CalculateMoverPoints(mover)
	local coordX, coordY = E:GetXYOffset(nudgeInversePoint, 1)
	nudge:ClearAllPoints()
	nudge:SetPoint(nudgePoint, mover, nudgeInversePoint, coordX, coordY)
	E:UpdateNudgeFrame(mover, x, y)
end

function module:Select(mover)
	if self.selected ~= mover then
		self:HideOverlay(self.selected, "MER_SelectOverlay")
		self.selected = mover
	end

	if mover then
		self:ShowOverlay(mover, "MER_SelectOverlay", 1, 1, 1, 0.12)
		self:AttachNudge(mover)
	end

	if E.MoverNudgeFrame then
		E.MoverNudgeFrame:SetShown(mover ~= nil)
	end

	self:UpdateAnchorLines()
	if self.toolbar then
		self:UpdateToolbarAnchor()
	end
end

function module:HandleKey(key)
	local mover = self.selected
	if not mover or not mover:IsShown() then
		return false
	end

	if key == "ESCAPE" then
		self:Select(nil)
		return true
	end

	local direction = self.db.keyboardNudge and ARROW_KEYS[key]
	if not direction then
		return false
	end

	local step = (IsShiftKeyDown() or IsControlKeyDown() or IsAltKeyDown()) and self.db.bigStep or 1
	E.MoverNudgeFrame.child = mover
	E:NudgeMover(direction[1] * step, direction[2] * step)

	return true
end

function module:CreateKeyCatcher()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:Hide()
	frame:EnableKeyboard(true)
	frame:SetPropagateKeyboardInput(true)
	frame:SetScript("OnKeyDown", function(catcher, key)
		local handled = module:HandleKey(key)
		-- Only the keys we use are swallowed, everything else keeps working
		if not InCombatLockdown() then
			catcher:SetPropagateKeyboardInput(not handled)
		end
	end)

	self.keyCatcher = frame
end

-------------------------------------------------------------------------------
--  Mover hooks
-------------------------------------------------------------------------------
local function OnDragStart(mover)
	if not module:IsActive() then
		return
	end

	module.dragging = true
	module:Select(mover)
	module:StartSnap(mover)
end

local function OnDragStop(mover)
	module.dragging = false
	module.lastDragStop = GetTime()

	if not module:IsActive() then
		return
	end

	module:StopSnap()
	if module.selected == mover then
		module:Select(mover)
	end

	-- A drag never shows a hidden grid, ElvUI only fades its alpha
	if not module.db.showGrid then
		E:Grid_Hide()
	end
end

local function OnMouseUp(mover, button)
	if not module:IsActive() or button ~= "LeftButton" or IsShiftKeyDown() then
		return
	end

	-- ElvUI toggled its nudge window on this mouse up, the selection decides instead
	local selected = module.selected
	if module.dragging or GetTime() - (module.lastDragStop or 0) < DRAG_CLICK_GUARD then
		module:Select(selected)
	elseif IsAltKeyDown() and selected and selected ~= mover then
		module:ToggleAnchor(selected, mover)
		module:Select(selected)
	elseif selected == mover then
		module:Select(nil)
	else
		module:Select(mover)
	end
end

local function OnEnter(mover)
	if not module:IsActive() or module.dragging then
		return
	end

	-- ElvUI hands the nudge window to the hovered mover, keep it on the selected one
	local selected = module.selected
	if selected and selected ~= mover and selected:IsShown() then
		module:AttachNudge(selected)
	end
end

local function OnHide(mover)
	if module.selected == mover then
		module:Select(nil)
	end
	module:HideOverlay(mover, "MER_SnapOverlay")

	-- Shift+Right-click hides a single mover, its anchor line goes with it
	if E.ConfigurationMode and module:IsActive() then
		module:UpdateAnchorLines()
	end
end

function module:HookMover(mover)
	if not mover or self.hookedMovers[mover] then
		return
	end
	self.hookedMovers[mover] = true

	mover:HookScript("OnDragStart", OnDragStart)
	mover:HookScript("OnDragStop", OnDragStop)
	mover:HookScript("OnMouseUp", OnMouseUp)
	mover:HookScript("OnEnter", OnEnter)
	mover:HookScript("OnHide", OnHide)
end

function module:HookAllMovers()
	for _, holder in pairs(E.CreatedMovers) do
		self:HookMover(holder.mover)
	end
	for _, holder in pairs(E.DisabledMovers) do
		self:HookMover(holder.mover)
	end
end

-------------------------------------------------------------------------------
--  Sorting
--  Small movers end up above big ones, so a castbar inside a unit frame mover
--  stays reachable.
-------------------------------------------------------------------------------
local sortList = {}

local function SortByArea(a, b)
	return a:GetWidth() * a:GetHeight() > b:GetWidth() * b:GetHeight()
end

function module:SortMovers()
	wipe(sortList)
	IterateMovers(function(mover)
		if mover:IsShown() then
			tinsert(sortList, mover)
		end
	end)
	sort(sortList, SortByArea)

	for index, mover in ipairs(sortList) do
		-- Never below the level ElvUI gave it, that one keeps it above its own frame
		mover.MER_BaseLevel = mover.MER_BaseLevel or mover:GetFrameLevel()
		mover:SetFrameLevel(max(mover.MER_BaseLevel, SORT_BASE_LEVEL + index))
	end

	wipe(sortList)
end

-------------------------------------------------------------------------------
--  Grid
-------------------------------------------------------------------------------
-- ElvUI draws the center lines red on draw sublevel 1, all others on 0
function module:StyleGrid()
	local grid = _G.ElvUIGrid
	if not grid then
		return
	end

	local accent = self:IsActive() and self.db.gridAccent
	for _, region in next, { grid:GetRegions() } do
		if region:IsObjectType("Texture") then
			local _, subLevel = region:GetDrawLayer()
			if subLevel == 1 then
				if accent then
					region:SetColorTexture(F.r, F.g, F.b)
				else
					region:SetColorTexture(1, 0, 0)
				end
			end
		end
	end
end

-------------------------------------------------------------------------------
--  Session
--  A snapshot of E.db.movers taken when the mover mode opens, so the changes
--  of this session can be thrown away again.
-------------------------------------------------------------------------------
function module:StartSession()
	self.snapshot = {
		movers = E.db.movers and CopyTable(E.db.movers),
		anchors = CopyTable(self.db.anchors),
	}
	self:UpdateChanges()
end

function module:CountChanges()
	if not self.snapshot then
		return 0
	end

	local before = self.snapshot.movers or {}
	local now = E.db.movers or {}
	local count = 0
	for name, point in pairs(now) do
		if before[name] ~= point then
			count = count + 1
		end
	end
	for name in pairs(before) do
		if now[name] == nil then
			count = count + 1
		end
	end

	return count
end

function module:UpdateChanges()
	if self.toolbar then
		self:UpdateToolbarChanges(self:CountChanges())
	end
end

function module:RevertChanges()
	if not self.snapshot or InCombatLockdown() then
		return
	end

	E.db.movers = self.snapshot.movers and CopyTable(self.snapshot.movers) or nil
	self.db.anchors = CopyTable(self.snapshot.anchors)

	-- Same steps as ElvUI's E:ResetMovers, for every mover
	for name, holder in pairs(E.CreatedMovers) do
		E:SetMoverPoints(name)

		local mover = holder.mover
		if mover and mover.postdrag then
			mover.postdrag(mover, E:GetScreenQuadrant(mover))
		end
	end

	if self.selected then
		self:AttachNudge(self.selected)
	end
	self:AnchorsChanged()
end

function module:EndSession()
	self.snapshot = nil
	self.dragging = false
	self:StopSnap()
	self:Select(nil)
	self:UpdateAnchorLines()
	self:HideEditModeHints()

	if self.keyCatcher then
		self.keyCatcher:Hide()
	end

	-- The close animation hides the toolbar when it is done
	if self.db.animation then
		self:PlayAnimation("close")
	elseif self.toolbar then
		self.toolbar:Hide()
	end
end

-- Lock and leave, like ElvUI's own "Lock" button
function module:CloseMoveMode()
	E:ToggleMoveMode()

	if E.ConfigurationToggled then
		E.ConfigurationToggled = nil
		-- Building the options window stalls the game, the close animation would be skipped
		self:AfterAnimation(function()
			if not E.ConfigurationMode and not InCombatLockdown() and _G.C_AddOns.IsAddOnLoaded("ElvUI_Options") then
				E:Config_OpenWindow()
			end
		end)
	end
end

-------------------------------------------------------------------------------
--  ElvUI hooks
-------------------------------------------------------------------------------
-- which: ElvUI's layout filter (nil or "" for all)
function module:OnMoveModeToggled(which)
	if not self:IsActive() then
		return
	end

	if not E.ConfigurationMode then
		self:EndSession()
		return
	end

	-- Also runs when the layout filter switches while the mode is open
	local starting = not self.snapshot
	if starting then
		self:StartSession()
	else
		-- Movers the filter shows now must not keep a half faded alpha
		self:FinishAnimation()
	end

	self:HookAllMovers()

	if self.db.sortBySize then
		self:SortMovers()
	end

	if not self.db.showGrid then
		E:Grid_Hide()
	end

	if self.db.keyboardNudge then
		-- Created here and not at login, the mover mode never opens in combat
		if not self.keyCatcher then
			self:CreateKeyCatcher()
		end
		self.keyCatcher:Show()
	end

	if self.db.toolbar then
		-- Hiding ElvUI's popup also hides the nudge window, so it comes first
		if E.MoverPopupWindow then
			E.MoverPopupWindow:Hide()
		end
		self:ShowToolbar()
	end

	-- The layout filter may have hidden the selected mover, and hiding ElvUI's
	-- popup closed the nudge window of a selected one
	local selected = self.selected
	if selected then
		self:Select(selected:IsShown() and selected or nil)
	end
	self:UpdateAnchorLines()
	self:UpdateEditModeHints(which)

	if starting and self.db.animation then
		self:PlayAnimation("open")
	end
end

-- ElvUI's popup closes the mover mode on combat only while it is shown
function module:PLAYER_REGEN_DISABLED()
	if not E.ConfigurationMode or not self:IsActive() then
		return
	end

	if not (E.MoverPopupWindow and E.MoverPopupWindow:IsShown()) then
		E:ToggleMoveMode()
	end
end

-- ElvUI can call the hooked functions at any time, also in the middle of a profile switch
-- before this module's ProfileUpdate ran. AceDB strips the defaults (like the empty anchors
-- table) from the old profile then, so they always read the current one.
function module:SyncDB()
	self.db = E.db.mui.unlockMode
	return self.db
end

function module:HookElvUI()
	if self.elvuiHooked then
		return
	end
	self.elvuiHooked = true

	hooksecurefunc(E, "ToggleMoveMode", function(_, which)
		module:SyncDB()
		module:OnMoveModeToggled(which)
	end)

	hooksecurefunc(E, "CreateMover", function(_, _, name)
		module:SyncDB()
		local holder = E.CreatedMovers[name]
		if holder and module:IsActive() then
			module:HookMover(holder.mover)
		end
		module:ApplyAnchors(name)
	end)

	hooksecurefunc(E, "Grid_Create", function()
		module:StyleGrid()
	end)

	hooksecurefunc(E, "SaveMoverPosition", function(_, name)
		module:SyncDB()
		module:KeepAnchor(name)
		if module.snapshot then
			module:UpdateChanges()
		end
	end)

	hooksecurefunc(E, "ResetMovers", function(_, text)
		module:SyncDB()
		module:DropAnchors(text)
		if module.snapshot then
			module:UpdateChanges()
		end
	end)
end

function module:SettingsUpdate()
	if not self.db then
		return
	end

	-- Anchors are positions, they are kept up also with the module turned off
	self:HookElvUI()

	if self:IsActive() then
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
	else
		self:UnregisterEvent("PLAYER_REGEN_DISABLED")
	end

	-- Grid_Show only rebuilds the grid when its size changed, so recolor it here
	self:StyleGrid()
end

function module:Initialize()
	self.db = E.db.mui.unlockMode
	self:SettingsUpdate()
	self:ApplyAnchors()
end

function module:ProfileUpdate()
	self.db = E.db.mui.unlockMode
	self:SettingsUpdate()
	self:ApplyAnchors()

	-- The positions of the new profile are no longer the ones in the snapshot
	if self.snapshot then
		self:StartSession()
	end
end

MER:RegisterModule(module:GetName())
