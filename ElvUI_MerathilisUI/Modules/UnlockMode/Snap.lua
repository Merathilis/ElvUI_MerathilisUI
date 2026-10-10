local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnlockMode")

-- Alignment snapping: while a mover is dragged, its edges and center snap to
-- the edges and centers of the other movers and of the screen, and a guide
-- line shows what it snapped to. Holding Shift drags freely, like ElvUI.

local abs, max = math.abs, math.max
local pairs, tinsert, wipe = pairs, tinsert, wipe

local CreateFrame = CreateFrame
local IsShiftKeyDown = IsShiftKeyDown
local UIParent = UIParent

local Sticky = E.Libs.SimpleSticky

-- Rects of the other movers, taken once per drag (they don't move meanwhile)
local targets = {}
local targetPool = {}

-- Result of the last snap pass
local snapX, snapY = {}, {}

local function ResetSnap(snap)
	snap.delta, snap.line, snap.target = nil, nil, nil
end

local function TrySnap(snap, delta, line, target, distance)
	if abs(delta) <= distance and (not snap.delta or abs(delta) < abs(snap.delta)) then
		snap.delta, snap.line, snap.target = delta, line, target
	end
end

-------------------------------------------------------------------------------
--  Guide lines
-------------------------------------------------------------------------------
function module:CreateGuides()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetFrameStrata("FULLSCREEN")
	frame:SetAllPoints(UIParent)
	frame:EnableMouse(false)
	frame:Hide()

	frame.vertical = frame:CreateTexture(nil, "OVERLAY")
	frame.horizontal = frame:CreateTexture(nil, "OVERLAY")

	self.guides = frame
end

function module:UpdateGuides()
	local guides = self.guides
	if not self.db.snap.guides or not (snapX.line or snapY.line) then
		if guides then
			guides:Hide()
		end
		return
	end

	if not guides then
		self:CreateGuides()
		guides = self.guides
	end

	local half = E.mult * 0.5
	local width, height = UIParent:GetSize()

	local vertical = guides.vertical
	if snapX.line then
		vertical:SetColorTexture(F.r, F.g, F.b, 0.9)
		vertical:ClearAllPoints()
		vertical:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", snapX.line - half, height)
		vertical:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMLEFT", snapX.line + half, 0)
		vertical:Show()
	else
		vertical:Hide()
	end

	local horizontal = guides.horizontal
	if snapY.line then
		horizontal:SetColorTexture(F.r, F.g, F.b, 0.9)
		horizontal:ClearAllPoints()
		horizontal:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", 0, snapY.line + half)
		horizontal:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMLEFT", width, snapY.line - half)
		horizontal:Show()
	else
		horizontal:Hide()
	end

	guides:Show()
end

-- Pulses the border of the movers the dragged one snapped to
function module:UpdateSnapTargets()
	local x, y = snapX.target, snapY.target
	if x == self.snapTargetX and y == self.snapTargetY then
		return
	end

	for _, mover in pairs({ self.snapTargetX, self.snapTargetY }) do
		if mover ~= x and mover ~= y then
			self:HideOverlay(mover, "MER_SnapOverlay")
		end
	end

	self.snapTargetX, self.snapTargetY = x, y

	for _, mover in pairs({ x, y }) do
		self:ShowOverlay(mover, "MER_SnapOverlay", F.r, F.g, F.b, 0.15, true)
	end
end

function module:HideSnapVisuals()
	ResetSnap(snapX)
	ResetSnap(snapY)

	if self.guides then
		self.guides:Hide()
	end
	self:UpdateSnapTargets()
end

-------------------------------------------------------------------------------
--  Snapping
-------------------------------------------------------------------------------
function module:CacheTargets(dragged)
	for _, target in pairs(targets) do
		tinsert(targetPool, target)
	end
	wipe(targets)

	for _, holder in pairs(E.CreatedMovers) do
		local mover = holder.mover
		-- Movers anchored to the dragged one move along, their old place means nothing
		if mover and mover ~= dragged and mover:IsShown() and not self:DependsOn(mover.name, dragged.name) then
			local left, right, top, bottom = mover:GetLeft(), mover:GetRight(), mover:GetTop(), mover:GetBottom()
			if left then
				local target = targetPool[#targetPool] or {}
				targetPool[#targetPool] = nil

				target.mover = mover
				target.left, target.right, target.top, target.bottom = left, right, top, bottom
				target.centerX, target.centerY = (left + right) * 0.5, (top + bottom) * 0.5
				tinsert(targets, target)
			end
		end
	end
end

function module:SnapMover(mover)
	ResetSnap(snapX)
	ResetSnap(snapY)

	local left, right, top, bottom = mover:GetLeft(), mover:GetRight(), mover:GetTop(), mover:GetBottom()
	if not left or IsShiftKeyDown() then
		self:HideSnapVisuals()
		return
	end

	local db = self.db.snap
	local distance = db.distance
	local centerX, centerY = (left + right) * 0.5, (top + bottom) * 0.5
	-- Side by side movers keep the gap ElvUI's sticky frames use for this mover
	local gap = max(0, -(mover.snapOffset or -2))

	for _, target in pairs(targets) do
		-- Edges and centers in line
		TrySnap(snapX, target.left - left, target.left, target.mover, distance)
		TrySnap(snapX, target.right - right, target.right, target.mover, distance)
		TrySnap(snapX, target.centerX - centerX, target.centerX, target.mover, distance)
		TrySnap(snapY, target.top - top, target.top, target.mover, distance)
		TrySnap(snapY, target.bottom - bottom, target.bottom, target.mover, distance)
		TrySnap(snapY, target.centerY - centerY, target.centerY, target.mover, distance)

		-- Next to each other, only when they are close on the other axis
		if bottom <= target.top + distance and top >= target.bottom - distance then
			TrySnap(snapX, target.right + gap - left, target.right, target.mover, distance)
			TrySnap(snapX, target.left - gap - right, target.left, target.mover, distance)
		end
		if left <= target.right + distance and right >= target.left - distance then
			TrySnap(snapY, target.bottom - gap - top, target.bottom, target.mover, distance)
			TrySnap(snapY, target.top + gap - bottom, target.top, target.mover, distance)
		end
	end

	if db.screen then
		local width, height = UIParent:GetSize()
		TrySnap(snapX, width * 0.5 - centerX, width * 0.5, nil, distance)
		TrySnap(snapX, -left, 0, nil, distance)
		TrySnap(snapX, width - right, width, nil, distance)
		TrySnap(snapY, height * 0.5 - centerY, height * 0.5, nil, distance)
		TrySnap(snapY, height - top, height, nil, distance)
		TrySnap(snapY, -bottom, 0, nil, distance)
	end

	if snapX.delta or snapY.delta then
		mover:ClearAllPoints()
		mover:SetPoint("CENTER", UIParent, "BOTTOMLEFT", centerX + (snapX.delta or 0), centerY + (snapY.delta or 0))
	end

	self:UpdateGuides()
	self:UpdateSnapTargets()
end

-- Replaces the OnUpdate SimpleSticky sets for the drag
local function DragUpdate(mover)
	Sticky.GetUpdateFunc(mover)
	module:SnapMover(mover)
end

-- Runs after ElvUI's OnDragStart, which started SimpleSticky on the mover
function module:StartSnap(mover)
	if not self.db.snap.enable then
		return
	end

	local data = Sticky.data[mover]
	if not data or (data.anchor and data.anchor ~= mover) then
		return
	end

	-- SimpleSticky only follows the cursor now, the snapping is ours
	data.frameList = nil
	self:CacheTargets(mover)
	mover:SetScript("OnUpdate", DragUpdate)
end

-- SimpleSticky's StopMoving already restored the mover's own OnUpdate
function module:StopSnap()
	self:HideSnapVisuals()

	for _, target in pairs(targets) do
		target.mover = nil
		tinsert(targetPool, target)
	end
	wipe(targets)
end
