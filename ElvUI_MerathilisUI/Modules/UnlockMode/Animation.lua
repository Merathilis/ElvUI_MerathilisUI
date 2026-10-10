local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnlockMode")

-- Opening and closing animation: a padlock in the class color unlocks in the
-- middle of the screen (shackle lifts and swings open, a ring pulses out),
-- then the movers and the toolbar fade in. Closing locks it again.

local _G = _G
local ipairs, pairs, unpack = ipairs, pairs, unpack
local min, max = math.min, math.max
local tinsert, wipe = tinsert, wipe

local CreateFrame = CreateFrame
local UIParent = UIParent

local LOCK_SIZE = 96
-- The textures are drawn on a 48 unit grid
local UNIT = LOCK_SIZE / 48
-- The shackle texture is centered on its left leg, which sits here on the lock
local SHACKLE_X, SHACKLE_Y = -10 * UNIT, 2 * UNIT
local SHACKLE_LIFT = 5 * UNIT
local SHACKLE_ANGLE = 0.32
local TOOLBAR_SLIDE = 40

local OPEN_DURATION = 1.4
local CLOSE_DURATION = 0.8
-- Longest step of a single frame. Closing or opening the options window right
-- next to the animation stalls a frame for longer than the whole animation.
local MAX_STEP = 0.05

-------------------------------------------------------------------------------
--  Easing
-------------------------------------------------------------------------------
-- 0..1 progress of a phase that starts at `start` and lasts `duration`
local function Phase(t, start, duration)
	return min(1, max(0, (t - start) / duration))
end

local function OutCubic(p)
	local f = 1 - p
	return 1 - f * f * f
end

local function InCubic(p)
	return p * p * p
end

local function OutBack(p)
	local f = p - 1
	return 1 + 2.70158 * f * f * f + 1.70158 * f * f
end

-------------------------------------------------------------------------------
--  Frames
-------------------------------------------------------------------------------
function module:CreateAnimationFrames()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetFrameStrata("FULLSCREEN_DIALOG")
	frame:SetAllPoints(UIParent)
	frame:EnableMouse(false)
	frame:Hide()

	local dim = frame:CreateTexture(nil, "BACKGROUND")
	dim:SetAllPoints()
	dim:SetColorTexture(0, 0, 0, 1)
	frame.dim = dim

	local lock = CreateFrame("Frame", nil, frame)
	lock:SetSize(LOCK_SIZE, LOCK_SIZE)
	lock:SetPoint("CENTER", UIParent, "CENTER", 0, 40)
	frame.lock = lock

	local textures = I.Media.Textures.UnlockMode
	local function Layer(texture, layer, subLevel, size)
		local region = lock:CreateTexture(nil, layer, nil, subLevel)
		region:SetTexture(texture)
		region:SetSize(size, size)
		region:SetPoint("CENTER")
		region:SetVertexColor(F.r, F.g, F.b)
		-- Sub-pixel smooth movement while animating
		region:SetSnapToPixelGrid(false)
		region:SetTexelSnappingBias(0)
		return region
	end

	frame.glow = Layer(textures.Glow, "BACKGROUND", 0, LOCK_SIZE * 2.4)
	frame.ring = Layer(textures.Ring, "ARTWORK", 0, LOCK_SIZE)
	frame.shackle = Layer(textures.LockShackle, "ARTWORK", 1, LOCK_SIZE)
	frame.body = Layer(textures.LockBody, "ARTWORK", 2, LOCK_SIZE)

	local title = lock:CreateFontString(nil, "OVERLAY")
	title:FontTemplate(nil, 16, "SHADOW")
	title:SetPoint("TOP", lock, "BOTTOM", 0, -10)
	title:SetText(MER.Title .. L["Unlock Mode"])
	frame.title = title

	frame.fades = {}
	frame:SetScript("OnUpdate", function(_, elapsed)
		module:StepAnimation(elapsed)
	end)

	self.animation = frame
end

-- lift and angle are 0..1 of the open state
local function SetShackle(frame, lift, angle)
	frame.shackle:SetPoint("CENTER", frame.lock, "CENTER", SHACKLE_X, SHACKLE_Y + SHACKLE_LIFT * lift)
	frame.shackle:SetRotation(SHACKLE_ANGLE * angle)
end

local function SetRing(frame, progress)
	local size = LOCK_SIZE * (1 + 0.9 * OutCubic(progress))
	frame.ring:SetSize(size, size)
	frame.ring:SetAlpha(progress > 0 and 0.9 * (1 - progress) or 0)
end

local function SetLock(frame, alpha, scale)
	frame.lock:SetAlpha(alpha)
	frame.lock:SetScale(max(0.01, scale))
end

-------------------------------------------------------------------------------
--  Fading the mover mode in
-------------------------------------------------------------------------------
local function AddFade(fades, region, alpha)
	if region and region:IsShown() then
		tinsert(fades, { region = region, alpha = alpha })
	end
end

function module:CollectFades()
	local fades = self.animation.fades
	wipe(fades)

	for _, holder in pairs(E.CreatedMovers) do
		AddFade(fades, holder.mover, 1)
	end
	AddFade(fades, _G.ElvUIGrid, 0.4)
	AddFade(fades, self.anchorLines, 1)
	if self.editModeMarkers then
		for _, marker in pairs(self.editModeMarkers) do
			AddFade(fades, marker, 1)
		end
	end
end

local function ApplyFades(fades, progress)
	for _, fade in ipairs(fades) do
		fade.region:SetAlpha(fade.alpha * progress)
	end
end

-- The toolbar slides down from above its place, wherever the user dragged it
local function SetToolbar(bar, progress, slide)
	if not bar or not bar.animPoint then
		return
	end

	local point, relativeTo, relativePoint, x, y = unpack(bar.animPoint)
	bar:ClearAllPoints()
	bar:SetPoint(point, relativeTo, relativePoint, x, y + slide * (1 - progress))
	bar:SetAlpha(progress)
end

-------------------------------------------------------------------------------
--  Timeline
-------------------------------------------------------------------------------
local function OpenStep(frame, bar, t)
	frame.dim:SetAlpha(0.4 * OutCubic(Phase(t, 0, 0.25)) * (1 - Phase(t, 0.9, 0.4)))

	local appear = Phase(t, 0, 0.25)
	local vanish = OutCubic(Phase(t, 1.0, 0.4))
	SetLock(frame, appear * (1 - vanish), 0.7 + 0.3 * OutBack(appear) + 0.15 * vanish)

	SetShackle(frame, OutCubic(Phase(t, 0.3, 0.2)), OutBack(Phase(t, 0.45, 0.25)))
	SetRing(frame, Phase(t, 0.5, 0.5))
	frame.glow:SetAlpha(0.8 * Phase(t, 0.45, 0.2) * (1 - Phase(t, 0.65, 0.55)))

	local reveal = OutCubic(Phase(t, 0.55, 0.35))
	ApplyFades(frame.fades, reveal)
	SetToolbar(bar, reveal, TOOLBAR_SLIDE)
end

local function CloseStep(frame, bar, t)
	frame.dim:SetAlpha(0)

	local appear = Phase(t, 0, 0.15)
	local vanish = OutCubic(Phase(t, 0.45, 0.35))
	SetLock(frame, appear * (1 - vanish), 0.9 + 0.1 * OutCubic(appear) - 0.1 * vanish)

	SetShackle(frame, 1 - InCubic(Phase(t, 0.25, 0.15)), 1 - OutCubic(Phase(t, 0.1, 0.2)))
	SetRing(frame, Phase(t, 0.38, 0.4))
	frame.glow:SetAlpha(0.6 * Phase(t, 0.36, 0.06) * (1 - Phase(t, 0.42, 0.4)))

	SetToolbar(bar, 1 - OutCubic(Phase(t, 0, 0.25)), TOOLBAR_SLIDE)
end

function module:StepAnimation(elapsed)
	local frame = self.animation
	frame.time = frame.time + min(elapsed, MAX_STEP)

	local opening = frame.kind == "open"
	local duration = opening and OPEN_DURATION or CLOSE_DURATION
	local t = min(frame.time, duration)

	if opening then
		OpenStep(frame, self.toolbar, t)
	else
		CloseStep(frame, self.toolbar, t)
	end

	if frame.time >= duration then
		self:FinishAnimation()
	end
end

-- Leaves everything in its final state, also when an animation is cut short
function module:FinishAnimation()
	local frame = self.animation
	if not frame or not frame.kind then
		return
	end

	local bar = self.toolbar
	if frame.kind == "open" then
		ApplyFades(frame.fades, 1)
		SetToolbar(bar, 1, 0)
	elseif bar then
		SetToolbar(bar, 1, 0)
		bar:Hide()
	end

	if bar then
		bar.animPoint = nil
	end
	wipe(frame.fades)
	frame.kind = nil
	frame:Hide()

	local onFinish = frame.onFinish
	if onFinish then
		frame.onFinish = nil
		onFinish()
	end
end

-- Runs func once the running animation is done, or right away without one
function module:AfterAnimation(func)
	local frame = self.animation
	if frame and frame.kind then
		frame.onFinish = func
	else
		func()
	end
end

function module:PlayAnimation(kind)
	if not self.animation then
		self:CreateAnimationFrames()
	end

	self:FinishAnimation()

	local frame = self.animation
	frame.kind = kind
	frame.time = 0

	local bar = self.toolbar
	if bar and bar:IsShown() then
		bar.animPoint = { bar:GetPoint(1) }
	end

	if kind == "open" then
		self:CollectFades()
		ApplyFades(frame.fades, 0)
		SetShackle(frame, 0, 0)
	else
		SetShackle(frame, 1, 1)
	end

	SetRing(frame, 0)
	frame.glow:SetAlpha(0)
	self:StepAnimation(0)
	frame:Show()
end
