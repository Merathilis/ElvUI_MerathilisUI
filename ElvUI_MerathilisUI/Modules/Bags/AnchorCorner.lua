local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_BagCategories") ---@class BagCategories

-- Anchor to Nearest Corner: the bag and the bank window each hold the screen
-- corner nearest to them, so a size change (more or fewer items, collapsed
-- categories, view mode, UI scale) grows or shrinks them toward that corner
-- instead of off the screen. ElvUI's mover owns the position, so the mover is
-- pinned to UIParent by that corner and the window to the same corner of the
-- mover. ElvUI resizes the mover along with the window, which keeps the corner
-- in place. The corner is saved in ElvUI's own mover format and kept across
-- reloads; it is picked again after a drag or nudge and when the option is
-- switched. A mover docked to another one in the unlock mode is left alone.

local next, pairs = next, pairs
local hooksecurefunc = hooksecurefunc
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local UIParent = UIParent

local MOVERS = {
	MER_BagCategoriesMover = true,
	MER_BankCategoriesMover = true,
}

local CORNERS = { TOPLEFT = true, TOPRIGHT = true, BOTTOMLEFT = true, BOTTOMRIGHT = true }

-- Our own SaveMoverPosition call must not run the hook again
local saving = false
-- [mover name] = repick, for anchors that have to wait for the combat end or a shown window
local pending = {}
local waitFrame

local function IsEnabled()
	-- Read from the live profile: ElvUI moves the movers before module.db follows a profile switch
	local db = E.db.mui and E.db.mui.bags and E.db.mui.bags.categorizedBags
	return db and db.anchorToCorner
end

local function IsDocked(name, relativeTo)
	if relativeTo and relativeTo ~= UIParent and relativeTo ~= E.UIParent then
		return true
	end

	local UM = MER:GetModule("MER_UnlockMode", true)
	return UM and UM.GetAnchor and UM:GetAnchor(name) and true or false
end

local function SaveMover(name)
	saving = true
	E:SaveMoverPosition(name)
	saving = false
end

-- Nearest screen corner of the window and its offset to that corner, in UIParent units
local function GetNearestCorner(frame)
	local left, right, top, bottom = frame:GetLeft(), frame:GetRight(), frame:GetTop(), frame:GetBottom()
	if not (left and right and top and bottom) then
		return
	end

	-- The window lives on ElvUIParent, the mover on UIParent
	local ratio = frame:GetEffectiveScale() / UIParent:GetEffectiveScale()
	left, right, top, bottom = left * ratio, right * ratio, top * ratio, bottom * ratio

	local screenWidth, screenHeight = UIParent:GetRight(), UIParent:GetTop()
	local isRight = left + right > screenWidth
	local isTop = top + bottom > screenHeight

	local point = (isTop and "TOP" or "BOTTOM") .. (isRight and "RIGHT" or "LEFT")
	local x = isRight and (right - screenWidth) or left
	local y = isTop and (top - screenHeight) or bottom

	return point, E:Round(x), E:Round(y)
end

local function ProcessPending()
	for name, repick in pairs(pending) do
		pending[name] = nil
		module:AnchorWindowToCorner(name, repick)
	end
end

local function Defer(name, frame, repick)
	pending[name] = pending[name] or repick

	if not waitFrame then
		waitFrame = CreateFrame("Frame")
		waitFrame:SetScript("OnEvent", function(self)
			self:UnregisterEvent("PLAYER_REGEN_ENABLED")
			ProcessPending()
		end)
	end

	if InCombatLockdown() then
		waitFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
	elseif not frame.merCornerShowHooked then
		-- Not laid out yet: the first open has the geometry
		frame.merCornerShowHooked = true
		frame:HookScript("OnShow", function()
			if next(pending) and not InCombatLockdown() then
				ProcessPending()
			end
		end)
	end
end

-- repick: choose the nearest corner from where the window stands (after a
-- drag, nudge or the option switch). Otherwise a corner the mover already
-- holds is kept, so the window does not change corners as it grows.
function module:AnchorWindowToCorner(name, repick)
	local holder = E.CreatedMovers[name]
	local frame, mover = holder and holder.parent, holder and holder.mover
	if not (frame and mover) then
		return
	end

	if InCombatLockdown() then
		Defer(name, frame, repick)
		return
	end

	local point, relativeTo, relativePoint = mover:GetPoint()
	if IsDocked(name, relativeTo) then
		return
	end

	if not repick and CORNERS[point] and point == relativePoint then
		frame:ClearAllPoints()
		frame:SetPoint(point, mover, point, 0, 0)
		return
	end

	local corner, x, y = GetNearestCorner(frame)
	if not corner then
		Defer(name, frame, repick)
		return
	end

	-- Mover and window share that corner, so nothing moves on screen
	mover:ClearAllPoints()
	mover:SetPoint(corner, UIParent, corner, x, y)
	frame:ClearAllPoints()
	frame:SetPoint(corner, mover, corner, 0, 0)

	if repick or E:HasMoverBeenMoved(name) then
		SaveMover(name)
	end
end

-- Option switched off: back to ElvUI's own anchoring, the mover by its screen
-- quadrant and the window by the point it was created with
function module:RestoreWindowAnchor(name)
	local holder = E.CreatedMovers[name]
	local frame, mover = holder and holder.parent, holder and holder.mover
	if not (frame and mover) or InCombatLockdown() then
		return
	end

	pending[name] = nil

	local _, relativeTo = mover:GetPoint()
	if E:HasMoverBeenMoved(name) and not IsDocked(name, relativeTo) then
		local x, y, point = E:CalculateMoverPoints(mover)
		mover:ClearAllPoints()
		mover:SetPoint(point, UIParent, point, x, y)
		SaveMover(name)
	end

	local origin = holder.originPoint and holder.originPoint[1] or "CENTER"
	frame:ClearAllPoints()
	frame:SetPoint(origin, mover, origin, 0, 0)
end

-- Called by the option toggle
function module:UpdateCornerAnchors()
	local enabled = IsEnabled()
	for name in pairs(MOVERS) do
		if enabled then
			self:AnchorWindowToCorner(name, true)
		else
			self:RestoreWindowAnchor(name)
		end
	end
end

-- Mover created, reset, profile switch, unlock mode revert
hooksecurefunc(E, "SetMoverPoints", function(_, name)
	if MOVERS[name] and not saving and IsEnabled() then
		module:AnchorWindowToCorner(name, false)
	end
end)

-- Drag or nudge
hooksecurefunc(E, "SaveMoverPosition", function(_, name)
	if MOVERS[name] and not saving and IsEnabled() then
		module:AnchorWindowToCorner(name, true)
	end
end)
