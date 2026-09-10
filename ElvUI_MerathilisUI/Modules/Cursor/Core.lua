local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Cursor")

local _G = _G
local floor, max = math.floor, math.max
local tremove = table.remove

local CreateFrame = CreateFrame
local GetCursorPosition = GetCursorPosition
local GetTime = GetTime
local InCombatLockdown = InCombatLockdown
local IsInInstance = IsInInstance
local UIParent = UIParent
local hooksecurefunc = hooksecurefunc

local Enum_OnUpdateMode_RunWhenVisible = Enum.OnUpdateMode and Enum.OnUpdateMode.RunWhenVisible

local RING_TEX = I.General.MediaPath .. "Textures\\Cursor\\Ring.tga"
local DOT_TEX = I.General.MediaPath .. "Textures\\Cursor\\Dot.tga"

local INSTANCE_TYPES = { party = true, raid = true, scenario = true }

local TRAIL_POOL_SIZE = 60
local TRAIL_DOT_DURATION = 0.4
local TRAIL_SPAWN_INTERVAL = 0.02
local TRAIL_MIN_DISTANCE = 6

--[[
Ported and adapted from EllesmereUI's cursor QoL feature (EllesmereUIQoL_Cursor.lua)
by EllesmereGaming, with full credit to the original author. Rebuilt from scratch for
MerathilisUI's own module/options/DB conventions, using original ring/dot textures
instead of the source addon's media.
https://github.com/EllesmereGaming/EllesmereUI
]]

-------------------------------------------------------------------------------
--  Utility
-------------------------------------------------------------------------------
function module:ResolveColor(db)
	if db and db.useClassColor then
		local cc = E:ClassColor(E.myclass, true)
		return cc.r, cc.g, cc.b
	end
	local c = db and db.color or {}
	return c.r or 1, c.g or 1, c.b or 1
end

function module:InInstance()
	local inInstance, instanceType = IsInInstance()
	return inInstance and INSTANCE_TYPES[instanceType] or false
end

local function PositionAtCursor(frame)
	local scale = UIParent:GetEffectiveScale()
	local x, y = GetCursorPosition()
	frame:ClearAllPoints()
	frame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x / scale, y / scale)
end

-------------------------------------------------------------------------------
--  Ring factory (shared by the cursor ring, GCD ring and cast ring)
--  Static display: ring:fg:Show(). Sweeping countdown: ring:StartRing(elapsed, max).
-------------------------------------------------------------------------------
function module:CreateRing(parent, radius)
	local ring = CreateFrame("Frame", nil, parent)
	ring:SetSize(radius * 2, radius * 2)
	ring:SetPoint("CENTER", parent, "CENTER", 0, 0)
	ring:SetFrameLevel(parent:GetFrameLevel() + 1)

	ring.radius = radius
	ring.duration = 0
	ring.maxDuration = 0

	ring.fg = ring:CreateTexture(nil, "ARTWORK")
	ring.fg:SetAllPoints(ring)
	ring.fg:SetTexture(RING_TEX)

	ring.cd = CreateFrame("Cooldown", nil, ring, "CooldownFrameTemplate")
	ring.cd:SetAllPoints(ring)
	ring.cd:SetFrameLevel(ring:GetFrameLevel() + 1)
	ring.cd:SetHideCountdownNumbers(true)
	ring.cd:SetDrawEdge(false)
	ring.cd:SetDrawBling(false)
	ring.cd:SetReverse(true)
	ring.cd:SetSwipeTexture(RING_TEX)
	ring.cd:Hide()

	function ring:SetRingColor(r, g, b, a)
		self.fg:SetVertexColor(r, g, b, a)
		self.cd:SetSwipeColor(r, g, b, a)
	end

	function ring:SetRingRadius(newRadius)
		self.radius = newRadius
		self:SetSize(newRadius * 2, newRadius * 2)
	end

	function ring:StartRing(elapsed, maxDuration)
		if not maxDuration or maxDuration <= 0 then
			return
		end
		self.duration = max(elapsed, 0)
		self.maxDuration = maxDuration
		self.fg:Hide()
		self.cd:SetCooldown(GetTime() - self.duration, maxDuration)
		self.cd:Show()
	end

	function ring:StopRing()
		self.cd:Hide()
		if not self.idleHidden then
			self.fg:Show()
		end
		self.duration, self.maxDuration = 0, 0
	end

	if ring.SetOnUpdateMode and Enum_OnUpdateMode_RunWhenVisible then
		-- Skip the sweep tick while the ring's root (GCD/cast) is hidden
		ring:SetOnUpdateMode(Enum_OnUpdateMode_RunWhenVisible)
	end

	ring:SetScript("OnUpdate", function(self, elapsed)
		if self.maxDuration <= 0 then
			return
		end
		self.duration = self.duration + elapsed
		if self.duration >= self.maxDuration then
			self:StopRing()
		end
	end)

	return ring
end

-------------------------------------------------------------------------------
--  Always-on cursor tracker: the single frame allowed to run every-frame
--  OnUpdate, so the ring/GCD/cast frames just anchor to it and never need
--  their own per-frame positioning logic.
-------------------------------------------------------------------------------
function module:CreateTracker()
	if self.tracker then
		return
	end

	local t = CreateFrame("Frame", nil, E.UIParent)
	t:SetSize(1, 1)
	t:EnableMouse(false)
	self.tracker = t

	self.trailLastCX, self.trailLastCY, self.trailSpawnTimer = 0, 0, 0
end

function module:TrackerOnUpdate(elapsed)
	PositionAtCursor(self.tracker)

	local trailDB = self.db and self.db.trail
	if trailDB and trailDB.enable then
		local cx, cy = GetCursorPosition()
		self.trailSpawnTimer = self.trailSpawnTimer + elapsed
		local dx, dy = cx - self.trailLastCX, cy - self.trailLastCY
		if
			self.trailSpawnTimer >= TRAIL_SPAWN_INTERVAL
			and (dx * dx + dy * dy) >= (TRAIL_MIN_DISTANCE * TRAIL_MIN_DISTANCE)
		then
			self.trailSpawnTimer = 0
			self.trailLastCX, self.trailLastCY = cx, cy
			self:SpawnTrailDot(cx, cy)
		end
	end

	if self.trailActive and #self.trailActive > 0 then
		self:UpdateTrail(elapsed)
	end
end

-------------------------------------------------------------------------------
--  Cursor Ring
-------------------------------------------------------------------------------
function module:CreateCursorFrame()
	if self.ringFrame then
		return
	end

	local f = CreateFrame("Frame", "MER_CursorRingFrame", E.UIParent)
	f:SetFrameStrata("TOOLTIP")
	f:SetFrameLevel(9999)
	f:EnableMouse(false)
	f:SetPoint("CENTER", self.tracker, "CENTER")

	f.ring = f:CreateTexture(nil, "ARTWORK")
	f.ring:SetAllPoints(f)
	f.ring:SetTexture(RING_TEX)

	f.dot = f:CreateTexture(nil, "OVERLAY")
	f.dot:SetPoint("CENTER")
	f.dot:SetTexture(DOT_TEX)
	f.dot:Hide()

	f:Hide()
	self.ringFrame = f
end

function module:ApplyRing()
	local f = self.ringFrame
	local db = self.db and self.db.ring
	if not f or not db then
		return
	end

	local radius = db.radius or 14
	f:SetSize(radius * 2, radius * 2)

	local r, g, b = self:ResolveColor(db)
	local a = db.alpha or 1
	f.ring:SetVertexColor(r, g, b, a)

	if db.reticle then
		local dotSize = max(4, floor(radius * 0.35 + 0.5))
		f.dot:SetSize(dotSize, dotSize)
		f.dot:SetVertexColor(r, g, b, a)
		f.dot:Show()
	else
		f.dot:Hide()
	end
end

function module:ShouldShowRing()
	local db = self.db and self.db.ring
	if not db or not db.enable then
		return false
	end
	if db.instanceOnly and not self:InInstance() then
		return false
	end
	if db.combatOnly and not InCombatLockdown() then
		return false
	end
	if db.onlyWhenHidden and not self.mouselookActive then
		return false
	end
	return true
end

-------------------------------------------------------------------------------
--  Cursor Trail
-------------------------------------------------------------------------------
function module:CreateTrail()
	if self.trailContainer then
		return
	end

	local c = CreateFrame("Frame", nil, E.UIParent)
	c:SetAllPoints(E.UIParent)
	c:SetFrameStrata("TOOLTIP")
	c:SetFrameLevel(9998)
	c:EnableMouse(false)
	self.trailContainer = c

	self.trailPool = {}
	self.trailActive = {}
	for i = 1, TRAIL_POOL_SIZE do
		local dot = c:CreateTexture(nil, "ARTWORK")
		dot:SetTexture(DOT_TEX)
		dot:SetBlendMode("ADD")
		dot:Hide()
		self.trailPool[i] = dot
	end
end

function module:SpawnTrailDot(cx, cy)
	if not self.trailPool or #self.trailPool == 0 then
		return
	end

	local dot = tremove(self.trailPool)
	local r, g, b = self:ResolveColor(self.db and self.db.ring)
	local size = 18
	dot:SetVertexColor(r, g, b, 0.9)
	dot:SetSize(size, size)
	dot:ClearAllPoints()
	local scale = UIParent:GetEffectiveScale()
	dot:SetPoint("CENTER", self.trailContainer, "BOTTOMLEFT", cx / scale, cy / scale)
	dot:Show()

	self.trailActive[#self.trailActive + 1] = { tex = dot, life = TRAIL_DOT_DURATION }
end

function module:UpdateTrail(elapsed)
	local active = self.trailActive
	for i = #active, 1, -1 do
		local entry = active[i]
		entry.life = entry.life - elapsed
		if entry.life <= 0 then
			entry.tex:Hide()
			self.trailPool[#self.trailPool + 1] = entry.tex
			tremove(active, i)
		else
			local pct = entry.life / TRAIL_DOT_DURATION
			entry.tex:SetAlpha(pct)
			entry.tex:SetSize(18 * pct, 18 * pct)
		end
	end
end

function module:HideTrail()
	if not self.trailActive then
		return
	end
	for i = #self.trailActive, 1, -1 do
		local entry = self.trailActive[i]
		entry.tex:Hide()
		self.trailPool[#self.trailPool + 1] = entry.tex
		self.trailActive[i] = nil
	end
end

function module:ApplyTrail()
	local db = self.db and self.db.trail
	if db and db.enable then
		self:CreateTrail()
	else
		self:HideTrail()
	end
end

-------------------------------------------------------------------------------
--  "Only While Steering Camera" (mouselook) visibility
--  Post-hooks WoW's world mouse handlers, which only fire for presses on the
--  3D world (never for UI clicks/drags). A press must be held past HOLD_DELAY
--  to count, so quick UI clicks near the world edge don't trigger it.
-------------------------------------------------------------------------------
local ML_HOLD_DELAY = 0.15

function module:MouselookShow()
	self.mlPending = false
	local db = self.db and self.db.ring
	if db and db.onlyWhenHidden and (self.mlLeftWorld or self.mlRight) and not self.mouselookActive then
		self.mouselookActive = true
		self:UpdateVisibility()
	end
end

function module:MouselookControlStart()
	local db = self.db and self.db.ring
	if not (db and db.onlyWhenHidden) or self.mouselookActive or self.mlPending then
		return
	end
	self.mlPending = true
	C_Timer.After(ML_HOLD_DELAY, function()
		self:MouselookShow()
	end)
end

function module:MouselookControlStop()
	local db = self.db and self.db.ring
	if db and db.onlyWhenHidden and not (self.mlLeftWorld or self.mlRight) and self.mouselookActive then
		self.mouselookActive = false
		self:UpdateVisibility()
	end
end

function module:InstallMouselookHooks()
	if self.mouselookHooked then
		return
	end
	self.mouselookHooked = true

	if type(_G.CameraOrSelectOrMoveStart) == "function" then
		hooksecurefunc("CameraOrSelectOrMoveStart", function()
			self.mlLeftWorld = true
			self:MouselookControlStart()
		end)
		hooksecurefunc("CameraOrSelectOrMoveStop", function()
			self.mlLeftWorld = false
			self:MouselookControlStop()
		end)
	end
	if type(_G.TurnOrActionStart) == "function" then
		hooksecurefunc("TurnOrActionStart", function()
			self.mlRight = true
			self:MouselookControlStart()
		end)
		hooksecurefunc("TurnOrActionStop", function()
			self.mlRight = false
			self:MouselookControlStop()
		end)
	end
end

-------------------------------------------------------------------------------
--  Visibility / settings glue
-------------------------------------------------------------------------------
function module:UpdateVisibility()
	local f = self.ringFrame
	if f then
		local show = self:ShouldShowRing()
		if show and not f:IsShown() then
			f:Show()
		elseif not show and f:IsShown() then
			f:Hide()
		end
	end

	self:UpdateGCDVisibility()
	self:UpdateCastVisibility()
end

function module:SettingsApply()
	if not self.Initialized or not self.db or not self.db.enable then
		return
	end
	self:ApplyRing()
	self:ApplyTrail()
	self:ApplyGCD()
	self:ApplyCast()
	self:UpdateVisibility()
end

-------------------------------------------------------------------------------
--  Ace event handlers (combat / zone edges only re-check visibility gating)
-------------------------------------------------------------------------------
function module:PLAYER_REGEN_DISABLED()
	self:UpdateVisibility()
end
module.PLAYER_REGEN_ENABLED = module.PLAYER_REGEN_DISABLED
module.PLAYER_ENTERING_WORLD = module.PLAYER_REGEN_DISABLED
module.ZONE_CHANGED_NEW_AREA = module.PLAYER_REGEN_DISABLED

-------------------------------------------------------------------------------
--  Lifecycle
-------------------------------------------------------------------------------
function module:Disable()
	if not self.Initialized then
		return
	end

	self:UnregisterAllEvents()

	if self.tracker then
		self.tracker:SetScript("OnUpdate", nil)
	end
	if self.ringFrame then
		self.ringFrame:Hide()
	end
	if self.gcdRoot then
		self.gcdRoot:Hide()
		self.gcdRoot:UnregisterAllEvents()
	end
	if self.castRoot then
		self.castRoot:Hide()
		self.castRoot:UnregisterAllEvents()
	end
	self:HideTrail()

	self.mlLeftWorld, self.mlRight, self.mlPending = false, false, false
	self.mouselookActive = false
end

function module:Enable()
	if not self.Initialized then
		return
	end

	self:CreateTracker()
	self:CreateCursorFrame()
	self:CreateGCDRing()
	self:CreateCastRing()
	self:InstallMouselookHooks()

	self.tracker:SetScript("OnUpdate", function(_, elapsed)
		self:TrackerOnUpdate(elapsed)
	end)

	self:ApplyRing()
	self:ApplyTrail()
	self:ApplyGCD()
	self:ApplyCast()

	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")

	self:UpdateVisibility()
end

function module:DatabaseUpdate()
	self:Disable()

	self.db = E.db.mui.cursor

	F.Event.ContinueOutOfCombat(function()
		if self.db and self.db.enable then
			self:Enable()
		end
	end)
end

function module:Initialize()
	if self.Initialized then
		return
	end

	F.Event.RegisterOnceCallback("MER.InitializedSafe", F.Event.GenerateClosure(self.DatabaseUpdate, self))
	F.Event.RegisterCallback("MER.DatabaseUpdate", self.DatabaseUpdate, self)
	F.Event.RegisterCallback("Cursor.DatabaseUpdate", self.DatabaseUpdate, self)

	self.Initialized = true
end

MER:RegisterModule(module:GetName())
