local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Preview = module.Preview

local cos, sin, rad, pi = math.cos, math.sin, math.rad, math.pi
local floor, max = math.floor, math.max
local tremove = table.remove
local CreateFrame = CreateFrame

-- Animated cursor scene for the Cursor module. Used as `dialogControl` on a
-- description named "cursor". A sample cursor with the ring and center dot; it
-- moves along a loop while the trail is on. The GCD and cast rings come from
-- the module's own ring factory and sweep over and over, rings that are not
-- attached to the cursor sit next to the scene.

local HEIGHT = 160
local CURSOR_SIZE = 24
local RING_TEX = I.General.MediaPath .. "Textures\\Cursor\\Ring.tga"
local DOT_TEX = I.General.MediaPath .. "Textures\\Cursor\\Dot.tga"
local CURSOR_TEX = [[Interface\CURSOR\Point]]

-- The cursor draws a figure eight while the trail is on
local PATH_X, PATH_Y, PATH_PERIOD = 45, 18, 3

local GCD_DURATION, GCD_PAUSE = 1.5, 0.6
local CAST_DURATION, CAST_PAUSE = 2.5, 0.8
local DETACHED_GAP = 24

-- Same numbers as the module's trail (Modules/Cursor/Core.lua)
local TRAIL_POOL_SIZE = 40
local TRAIL_DOT_SIZE = 18
local TRAIL_DOT_DURATION = 0.4
local TRAIL_SPAWN_INTERVAL = 0.02
local TRAIL_MIN_DISTANCE = 6

local function GetCursorModule()
	return MER:GetModule("MER_Cursor")
end

local function UpdateTrail(widget, elapsed)
	local active = widget.trailActive
	for i = #active, 1, -1 do
		local entry = active[i]
		entry.life = entry.life - elapsed
		if entry.life <= 0 then
			entry.tex:Hide()
			widget.trailPool[#widget.trailPool + 1] = entry.tex
			tremove(active, i)
		else
			local pct = entry.life / TRAIL_DOT_DURATION
			entry.tex:SetAlpha(pct)
			entry.tex:SetSize(TRAIL_DOT_SIZE * pct, TRAIL_DOT_SIZE * pct)
		end
	end
end

local function SpawnTrailDot(widget, x, y)
	local dot = tremove(widget.trailPool)
	if not dot then
		return
	end

	local r, g, b = GetCursorModule():ResolveColor(E.db.mui.cursor.ring)
	dot:SetVertexColor(r, g, b, 0.9)
	dot:SetSize(TRAIL_DOT_SIZE, TRAIL_DOT_SIZE)
	dot:ClearAllPoints()
	dot:SetPoint("CENTER", widget.frame, "LEFT", x, y)
	dot:Show()

	widget.trailActive[#widget.trailActive + 1] = { tex = dot, life = TRAIL_DOT_DURATION }
end

local function ClearTrail(widget)
	for i = #widget.trailActive, 1, -1 do
		local entry = widget.trailActive[i]
		entry.tex:Hide()
		widget.trailPool[#widget.trailPool + 1] = entry.tex
		widget.trailActive[i] = nil
	end
end

local function UpdateSpark(widget)
	local cast, spark = widget.cast, widget.spark
	local pct = cast.maxDuration > 0 and cast.duration / cast.maxDuration or 0
	if not widget.showSpark or pct <= 0 or pct >= 1 then
		spark:Hide()
		return
	end

	local angle = 90 - pct * 360
	spark:ClearAllPoints()
	spark:SetPoint("CENTER", cast, "CENTER", cos(rad(angle)) * cast.radius, sin(rad(angle)) * cast.radius)
	spark:SetRotation(rad(angle - 90))
	spark:Show()
end

local function OnUpdate(frame, elapsed)
	local widget = frame.obj
	widget.time = widget.time + elapsed

	if widget.moving then
		local angle = widget.time / PATH_PERIOD * 2 * pi
		local x = widget.sceneX + sin(angle) * PATH_X
		local y = sin(angle * 2) * PATH_Y
		widget.tracker:ClearAllPoints()
		widget.tracker:SetPoint("CENTER", frame, "LEFT", x, y)

		widget.trailTimer = widget.trailTimer + elapsed
		local dx, dy = x - widget.lastX, y - widget.lastY
		if
			widget.trailTimer >= TRAIL_SPAWN_INTERVAL
			and (dx * dx + dy * dy) >= TRAIL_MIN_DISTANCE * TRAIL_MIN_DISTANCE
		then
			widget.trailTimer = 0
			widget.lastX, widget.lastY = x, y
			SpawnTrailDot(widget, x, y)
		end
	end
	UpdateTrail(widget, elapsed)

	if widget.gcd:IsShown() then
		widget.gcdTimer = widget.gcdTimer - elapsed
		if widget.gcdTimer <= 0 then
			widget.gcdTimer = GCD_DURATION + GCD_PAUSE
			widget.gcd:StartRing(0, GCD_DURATION)
		end
	end

	if widget.cast:IsShown() then
		widget.castTimer = widget.castTimer - elapsed
		if widget.castTimer <= 0 then
			widget.castTimer = CAST_DURATION + CAST_PAUSE
			widget.cast:StartRing(0, CAST_DURATION)
		end
		UpdateSpark(widget)
	end
end

-- The GCD and cast rings only show while they sweep, like in the game
local function CreateSweepRing(frame, radius)
	local ring = GetCursorModule():CreateRing(frame, radius)
	ring.idleHidden = true
	ring.fg:Hide()
	return ring
end

local function Build(widget)
	local frame = widget.frame
	frame.obj = widget
	-- Large rings would draw over the options around the preview
	frame:SetClipsChildren(true)

	widget.tracker = CreateFrame("Frame", nil, frame)
	widget.tracker:SetSize(1, 1)

	local ring = CreateFrame("Frame", nil, frame)
	ring:SetPoint("CENTER", widget.tracker)
	ring.tex = ring:CreateTexture(nil, "ARTWORK")
	ring.tex:SetAllPoints()
	ring.tex:SetTexture(RING_TEX)
	ring.dot = ring:CreateTexture(nil, "OVERLAY")
	ring.dot:SetPoint("CENTER")
	ring.dot:SetTexture(DOT_TEX)
	widget.ring = ring

	widget.gcd = CreateSweepRing(frame, 21)
	widget.cast = CreateSweepRing(frame, 30)

	local sparkLayer = CreateFrame("Frame", nil, widget.cast)
	sparkLayer:SetAllPoints()
	sparkLayer:SetFrameLevel(widget.cast:GetFrameLevel() + 3)
	widget.spark = sparkLayer:CreateTexture(nil, "OVERLAY")
	widget.spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
	widget.spark:SetBlendMode("ADD")
	widget.spark:Hide()

	-- The hotspot of the arrow is its top left corner
	local cursorLayer = CreateFrame("Frame", nil, frame)
	cursorLayer:SetAllPoints()
	cursorLayer:SetFrameLevel(frame:GetFrameLevel() + 20)
	widget.cursor = cursorLayer:CreateTexture(nil, "OVERLAY")
	widget.cursor:SetSize(CURSOR_SIZE, CURSOR_SIZE)
	widget.cursor:SetTexture(CURSOR_TEX)
	widget.cursor:SetPoint("TOPLEFT", widget.tracker, "CENTER")

	widget.trailPool, widget.trailActive = {}, {}
	for i = 1, TRAIL_POOL_SIZE do
		local dot = frame:CreateTexture(nil, "ARTWORK")
		dot:SetTexture(DOT_TEX)
		dot:SetBlendMode("ADD")
		dot:Hide()
		widget.trailPool[i] = dot
	end

	widget.time, widget.trailTimer, widget.lastX, widget.lastY = 0, 0, 0, 0
	widget.gcdTimer, widget.castTimer = 0, 0
	frame:SetScript("OnUpdate", OnUpdate)
end

-- Places a sweep ring on the cursor or, when detached, in the next free slot
local function PlaceSweepRing(widget, ring, db, slotX)
	local cursorModule = GetCursorModule()
	ring:SetShown(db.enable)
	if not db.enable then
		return slotX
	end

	ring:SetRingRadius(db.radius)
	local r, g, b = cursorModule:ResolveColor(db)
	ring:SetRingColor(r, g, b, db.alpha)
	ring:ClearAllPoints()

	if db.attached ~= false then
		ring:SetPoint("CENTER", widget.tracker)
		return slotX
	end

	ring:SetPoint("CENTER", widget.frame, "LEFT", slotX + db.radius, 0)
	return slotX + db.radius * 2 + DETACHED_GAP
end

local function Update(widget)
	local db = E.db.mui.cursor
	local cursorModule = GetCursorModule()

	local detached = (db.gcd.enable and db.gcd.attached == false)
		or (db.castCircle.enable and db.castCircle.attached == false)
	local width = widget.frame:GetWidth()
	widget.sceneX = floor(width * (detached and 0.3 or 0.5))

	-- Ring and center dot
	local ringDb = db.ring
	local ring = widget.ring
	ring:SetShown(ringDb.enable)
	ring:SetSize(ringDb.radius * 2, ringDb.radius * 2)
	local r, g, b = cursorModule:ResolveColor(ringDb)
	ring.tex:SetVertexColor(r, g, b, ringDb.alpha)
	ring.dot:SetShown(ringDb.reticle)
	local dotSize = max(4, floor(ringDb.radius * 0.35 + 0.5))
	ring.dot:SetSize(dotSize, dotSize)
	ring.dot:SetVertexColor(r, g, b, ringDb.alpha)

	-- While steering the camera the game hides the hardware cursor
	widget.cursor:SetShown(not (ringDb.enable and ringDb.onlyWhenHidden))

	widget.moving = db.trail.enable
	if not widget.moving then
		ClearTrail(widget)
		widget.tracker:ClearAllPoints()
		widget.tracker:SetPoint("CENTER", widget.frame, "LEFT", widget.sceneX, 0)
	end

	local slotX = widget.sceneX + PATH_X + 60
	slotX = PlaceSweepRing(widget, widget.gcd, db.gcd, slotX)
	PlaceSweepRing(widget, widget.cast, db.castCircle, slotX)

	local castDb = db.castCircle
	widget.showSpark = castDb.enable and castDb.sparkEnable
	widget.spark:SetSize(castDb.radius * 0.6, castDb.radius * 0.6)
	local cr, cg, cb = cursorModule:ResolveColor(castDb)
	widget.spark:SetVertexColor(cr, cg, cb, 1)

	Preview.SetEnabled(widget, db.enable)
end

Preview.Register("MERCursorPreview", 1, HEIGHT, Build, Update, ClearTrail)
