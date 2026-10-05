local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnlockMode")

-- Anchors: a mover docked to another one follows it. The position is kept in
-- ElvUI's own format with the target mover as the relative frame, e.g.
-- "TOPLEFT,ElvUF_PlayerMover,BOTTOMLEFT,0,-4", which ElvUI applies by itself.
-- db.anchors[child] = { target, point, relativePoint } remembers the docking
-- sides, so a drag or nudge of the child (saved by ElvUI relative to UIParent)
-- is turned back into an offset to the target.

local _G = _G
local abs, max = math.abs, math.max
local format, strfind, strsplit = format, strfind, strsplit
local pairs, pcall, tonumber, wipe = pairs, pcall, tonumber, wipe

local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local UIParent = UIParent

local LINE_COLOR = { r = 1, g = 0.82, b = 0 }
-- Movers closer than this still count as side by side (ElvUI's snap gap overlaps a bit)
local SIDE_TOLERANCE = 4
-- Guards the dependency walk against broken data
local MAX_CHAIN = 50

local function GetMover(name)
	local holder = E:GetMoverHolder(name)
	return holder and holder.mover
end

local function PointPosition(frame, point)
	local left, right, top, bottom = frame:GetLeft(), frame:GetRight(), frame:GetTop(), frame:GetBottom()
	if not left then
		return
	end

	local x = (strfind(point, "LEFT") and left) or (strfind(point, "RIGHT") and right) or (left + right) * 0.5
	local y = (strfind(point, "TOP") and top) or (strfind(point, "BOTTOM") and bottom) or (top + bottom) * 0.5
	return x, y
end

-- Which edges of the target line up best: min edge, max edge or center
local function Align(childMin, childMax, targetMin, targetMax, minName, maxName)
	local toMin = abs(childMin - targetMin)
	local toMax = abs(childMax - targetMax)
	local toCenter = abs((childMin + childMax) - (targetMin + targetMax)) * 0.5

	if toCenter <= toMin and toCenter <= toMax then
		return ""
	end
	return toMin <= toMax and minName or maxName
end

-- Docking sides from where the child sits now: below, above, right or left of
-- the target, or on top of it
local function ChoosePoints(child, target)
	local cLeft, cRight, cTop, cBottom = child:GetLeft(), child:GetRight(), child:GetTop(), child:GetBottom()
	local tLeft, tRight, tTop, tBottom = target:GetLeft(), target:GetRight(), target:GetTop(), target:GetBottom()

	local below = tBottom - cTop
	local above = cBottom - tTop
	local right = cLeft - tRight
	local left = tLeft - cRight
	local best = max(below, above, right, left)

	local horizontal = Align(cLeft, cRight, tLeft, tRight, "LEFT", "RIGHT")
	local vertical = Align(cBottom, cTop, tBottom, tTop, "BOTTOM", "TOP")

	if best >= -SIDE_TOLERANCE then
		if best == below then
			return "TOP" .. horizontal, "BOTTOM" .. horizontal
		elseif best == above then
			return "BOTTOM" .. horizontal, "TOP" .. horizontal
		elseif best == right then
			return vertical .. "LEFT", vertical .. "RIGHT"
		else
			return vertical .. "RIGHT", vertical .. "LEFT"
		end
	end

	local point = vertical .. horizontal
	if point == "" then
		point = "CENTER"
	end
	return point, point
end

-------------------------------------------------------------------------------
--  Data
-------------------------------------------------------------------------------
function module:GetAnchor(name)
	return name and self.db and self.db.anchors[name]
end

-- True when `name` follows `on`, directly or through other anchors
function module:DependsOn(name, on)
	local anchors = self.db.anchors
	for _ = 1, MAX_CHAIN do
		if name == on then
			return true
		end

		local anchor = anchors[name]
		if not anchor then
			return false
		end
		name = anchor.target
	end

	return true
end

function module:SetAnchoredPoint(name, mover, anchor, x, y)
	x, y = E:Round(x), E:Round(y)

	mover:ClearAllPoints()
	mover:SetPoint(anchor.point, anchor.target, anchor.relativePoint, x, y)

	E.db.movers = E.db.movers or {}
	E.db.movers[name] = format("%s,%s,%s,%d,%d", anchor.point, anchor.target, anchor.relativePoint, x, y)
end

-- Offset of the child's docking point to the target's, both in UIParent units
function module:AnchorFromCurrentPosition(name, mover, anchor)
	local target = _G[anchor.target]
	if not target then
		return false
	end

	local childX, childY = PointPosition(mover, anchor.point)
	local targetX, targetY = PointPosition(target, anchor.relativePoint)
	if not (childX and targetX) then
		return false
	end

	self:SetAnchoredPoint(name, mover, anchor, childX - targetX, childY - targetY)
	return true
end

-------------------------------------------------------------------------------
--  Anchor / detach
-------------------------------------------------------------------------------
function module:Anchor(mover, target)
	local name = mover.name
	if self:DependsOn(target.name, name) then
		F.Print(
			format(
				L["%s can't be anchored to %s, because %s already follows it."],
				mover.textString,
				target.textString,
				target.textString
			)
		)
		return
	end

	local x, y, oldPoint = E:CalculateMoverPoints(mover)
	local point, relativePoint = ChoosePoints(mover, target)
	local anchor = { target = target.name, point = point, relativePoint = relativePoint }
	self.db.anchors[name] = anchor

	-- SetPoint refuses anchors the client sees as circular, the mover stays where it was then
	local ok = pcall(self.AnchorFromCurrentPosition, self, name, mover, anchor)
	if not ok then
		self.db.anchors[name] = nil
		mover:ClearAllPoints()
		mover:SetPoint(oldPoint, UIParent, oldPoint, x, y)
	end
end

-- Back to a position relative to the screen, where the mover is now
function module:Detach(name)
	self.db.anchors[name] = nil

	local mover = GetMover(name)
	if not mover or not mover:GetCenter() then
		return
	end

	local x, y, point = E:CalculateMoverPoints(mover)
	x, y = E:Round(x), E:Round(y)
	mover:ClearAllPoints()
	mover:SetPoint(point, UIParent, point, x, y)

	E.db.movers = E.db.movers or {}
	E.db.movers[name] = format("%s,%s,%s,%d,%d", point, "UIParent", point, x, y)
end

-- Alt-click: anchor the selected mover to the clicked one, a second time detaches it
function module:ToggleAnchor(mover, target)
	if InCombatLockdown() or mover == target then
		return
	end

	local anchor = self:GetAnchor(mover.name)
	if anchor and anchor.target == target.name then
		self:Detach(mover.name)
	else
		self:Anchor(mover, target)
	end

	self:AnchorsChanged()
end

function module:DetachAll()
	if InCombatLockdown() then
		return
	end

	for name in pairs(self.db.anchors) do
		self:Detach(name)
	end
	wipe(self.db.anchors)

	self:AnchorsChanged()
end

function module:AnchorsChanged()
	self:UpdateChanges()
	self:UpdateAnchorLines()
	if self.toolbar then
		self:UpdateToolbarAnchor()
	end
end

-------------------------------------------------------------------------------
--  ElvUI hooks
-------------------------------------------------------------------------------
-- ElvUI saved the mover relative to UIParent (drag, nudge), keep the anchor
function module:KeepAnchor(name)
	local anchor = self:GetAnchor(name)
	local mover = anchor and GetMover(name)
	if not mover or InCombatLockdown() then
		return
	end

	if not self:AnchorFromCurrentPosition(name, mover, anchor) then
		self.db.anchors[name] = nil
	end
end

-- A reset puts the mover back to its default, which is never anchored by us
function module:DropAnchors(text)
	local anchors = self.db.anchors
	if not text or text == "" then
		wipe(anchors)
	else
		for name in pairs(anchors) do
			local mover = GetMover(name)
			if mover and mover.textString == text then
				anchors[name] = nil
			end
		end
	end

	self:UpdateAnchorLines()
end

-- ElvUI places a mover when it is created; an anchor to a mover that does not
-- exist yet falls back to the default position, so it is set again later
function module:ApplyAnchor(name, anchor)
	local mover = GetMover(name)
	local saved = E.db.movers and E.db.movers[name]
	if not mover or not saved or not _G[anchor.target] then
		return
	end

	local delimiter = strfind(saved, "\031") and "\031" or ","
	local point, relativeTo, relativePoint, x, y = strsplit(delimiter, saved)
	if relativeTo ~= anchor.target then
		-- Replaced by something else, e.g. an imported profile
		self.db.anchors[name] = nil
		return
	end

	mover:ClearAllPoints()
	mover:SetPoint(point, relativeTo, relativePoint, tonumber(x) or 0, tonumber(y) or 0)
end

-- targetName limits it to the movers anchored to that one
function module:ApplyAnchors(targetName)
	if not self.db then
		return
	end

	-- Unit frames hang on their movers, those can't be moved in combat
	if InCombatLockdown() then
		self.pendingAnchors = true
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end

	for name, anchor in pairs(self.db.anchors) do
		if not targetName or anchor.target == targetName then
			self:ApplyAnchor(name, anchor)
		end
	end
end

function module:PLAYER_REGEN_ENABLED()
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	if self.pendingAnchors then
		self.pendingAnchors = nil
		self:ApplyAnchors()
	end
end

-------------------------------------------------------------------------------
--  Lines between anchored movers, shown in the mover mode
-------------------------------------------------------------------------------
function module:UpdateAnchorLines()
	local frame = self.anchorLines
	if not E.ConfigurationMode or not self:IsActive() or not self.db.anchorLines then
		if frame then
			frame:Hide()
		end
		return
	end

	if not frame then
		frame = CreateFrame("Frame", nil, UIParent)
		frame:SetFrameStrata("DIALOG")
		frame:SetFrameLevel(450) -- above the movers, below ElvUI's nudge window
		frame:SetAllPoints(UIParent)
		frame:EnableMouse(false)
		frame.lines = {}
		self.anchorLines = frame
	end

	local index = 0
	local selected = self.selected and self.selected.name
	for name, anchor in pairs(self.db.anchors) do
		local mover, target = GetMover(name), _G[anchor.target]
		if mover and target and mover:IsShown() and target:IsShown() then
			index = index + 1
			local line = frame.lines[index]
			if not line then
				line = frame:CreateLine(nil, "OVERLAY")
				line:SetThickness(2)
				frame.lines[index] = line
			end

			local active = name == selected or anchor.target == selected
			line:SetColorTexture(LINE_COLOR.r, LINE_COLOR.g, LINE_COLOR.b, active and 1 or 0.45)
			line:SetStartPoint("CENTER", mover)
			line:SetEndPoint("CENTER", target)
			line:Show()
		end
	end

	for i = index + 1, #frame.lines do
		frame.lines[i]:Hide()
	end

	frame:Show()
end
