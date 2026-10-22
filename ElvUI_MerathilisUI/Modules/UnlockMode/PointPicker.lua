local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnlockMode")

-- Point picker: Shift+Alt-click anchors with points chosen by hand instead of
-- the ones taken from where the mover sits. Nine dots on the selected mover
-- pick its point, nine on the target the point it docks to; both points are
-- then put on top of each other. Esc, right-click or a click next to the dots
-- cancels.

local format, ipairs = format, ipairs

local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local UIParent = UIParent

local POINTS = { "TOPLEFT", "TOP", "TOPRIGHT", "LEFT", "CENTER", "RIGHT", "BOTTOMLEFT", "BOTTOM", "BOTTOMRIGHT" }
local DOT_SIZE = 10
local DOT_HOVER_SIZE = 14
local HIT_SIZE = 20
local CURRENT_COLOR = { r = 1, g = 0.82, b = 0 }

-------------------------------------------------------------------------------
--  Dots
-------------------------------------------------------------------------------
local function PaintDot(dot)
	local size = dot.hovered and DOT_HOVER_SIZE or DOT_SIZE
	dot.border:Size(size + 2)
	dot.fill:Size(size)

	if dot.hovered then
		dot.fill:SetVertexColor(F.r, F.g, F.b)
	elseif dot.current then
		dot.fill:SetVertexColor(CURRENT_COLOR.r, CURRENT_COLOR.g, CURRENT_COLOR.b)
	else
		dot.fill:SetVertexColor(1, 1, 1)
	end
end

local function Dot_OnEnter(dot)
	dot.hovered = true
	PaintDot(dot)
	module:PreviewPointLine(dot)
end

local function Dot_OnLeave(dot)
	dot.hovered = false
	PaintDot(dot)
	module:PreviewPointLine(nil)
end

local function Dot_OnClick(dot, button)
	if button == "LeftButton" then
		module:PickPoint(dot.point)
	else
		module:CancelPointPicker()
	end
end

local function CreateDot(parent, point)
	local dot = CreateFrame("Button", nil, parent)
	dot:Size(HIT_SIZE)
	dot:SetFrameLevel(parent:GetFrameLevel() + 2)
	dot:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	dot.point = point

	dot.border = dot:CreateTexture(nil, "ARTWORK")
	dot.border:SetTexture(E.media.blankTex)
	dot.border:SetVertexColor(0, 0, 0)
	dot.border:SetPoint("CENTER")

	dot.fill = dot:CreateTexture(nil, "OVERLAY")
	dot.fill:SetTexture(E.media.blankTex)
	dot.fill:SetPoint("CENTER")

	dot:SetScript("OnEnter", Dot_OnEnter)
	dot:SetScript("OnLeave", Dot_OnLeave)
	dot:SetScript("OnClick", Dot_OnClick)

	PaintDot(dot)
	return dot
end

-------------------------------------------------------------------------------
--  Frame
-------------------------------------------------------------------------------
function module:CreatePointPicker()
	-- Covers the screen so a click next to the dots cancels instead of hitting a mover
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetFrameStrata("FULLSCREEN_DIALOG")
	frame:SetFrameLevel(10)
	frame:SetAllPoints(UIParent)
	frame:EnableMouse(true)
	frame:SetScript("OnMouseDown", function()
		module:CancelPointPicker()
	end)
	frame:Hide()

	local box = CreateFrame("Frame", nil, frame, "BackdropTemplate")
	box:SetFrameLevel(frame:GetFrameLevel() + 1)
	box:SetBackdrop({ bgFile = E.media.blankTex, edgeFile = E.media.blankTex, edgeSize = E.mult * 2 })
	box:SetBackdropColor(F.r, F.g, F.b, 0.15)
	box:SetBackdropBorderColor(F.r, F.g, F.b, 1)
	frame.box = box

	frame.label = frame:CreateFontString(nil, "OVERLAY")
	frame.label:FontTemplate(nil, 13, "SHADOW")
	frame.label:SetPoint("BOTTOM", box, "TOP", 0, 8)

	-- The point already picked on the mover, while the target's dots are shown
	frame.marker = frame:CreateTexture(nil, "OVERLAY")
	frame.marker:SetTexture(E.media.blankTex)
	frame.marker:SetVertexColor(F.r, F.g, F.b)
	frame.marker:Size(DOT_SIZE)

	frame.line = frame:CreateLine(nil, "OVERLAY")
	frame.line:SetThickness(2)
	frame.line:SetColorTexture(F.r, F.g, F.b, 0.8)
	frame.line:Hide()

	frame.dots = {}
	for _, point in ipairs(POINTS) do
		frame.dots[#frame.dots + 1] = CreateDot(frame, point)
	end

	self.pointPicker = frame
end

local function Label(mover)
	return "|cffffffff" .. (mover.textString or mover.name) .. "|r"
end

-- Puts the dots on `frame`, the one of `current` marked as the point in use
function module:ShowPointDots(frame, current, text)
	local picker = self.pointPicker
	picker.box:ClearAllPoints()
	picker.box:SetAllPoints(frame)
	picker.label:SetText(text .. "\n|cff999999" .. L["Esc or right-click: cancel"] .. "|r")

	for _, dot in ipairs(picker.dots) do
		dot:ClearAllPoints()
		dot:SetPoint("CENTER", frame, dot.point)
		dot.current = dot.point == current
		dot.hovered = false
		PaintDot(dot)
	end
end

-------------------------------------------------------------------------------
--  Flow
-------------------------------------------------------------------------------
function module:OpenPointPicker(mover, target)
	if InCombatLockdown() or mover == target or not self:CanAnchor(mover, target) then
		return
	end

	if not self.pointPicker then
		self:CreatePointPicker()
	end

	-- Re-picking an existing anchor starts from its points
	local anchor = self:GetAnchor(mover.name)
	if anchor and anchor.target ~= target.name then
		anchor = nil
	end
	self.picking = { mover = mover, target = target, anchor = anchor }

	-- The nudge window would sit on top of the dots
	if E.MoverNudgeFrame then
		E.MoverNudgeFrame:Hide()
	end

	local picker = self.pointPicker
	picker.marker:Hide()
	picker.line:Hide()
	self:ShowPointDots(mover, anchor and anchor.point, format(L["Pick a point on %s."], Label(mover)))
	picker:Show()
end

function module:PickPoint(point)
	local picking = self.picking
	if not picking or InCombatLockdown() then
		self:CancelPointPicker()
		return
	end

	local picker = self.pointPicker
	if not picking.point then
		picking.point = point

		picker.marker:ClearAllPoints()
		picker.marker:SetPoint("CENTER", picking.mover, point)
		picker.marker:Show()

		local anchor = picking.anchor
		self:ShowPointDots(
			picking.target,
			anchor and anchor.relativePoint,
			format(L["Pick the point on %s that %s docks to."], Label(picking.target), Label(picking.mover))
		)
		return
	end

	local mover = picking.mover
	self:Anchor(mover, picking.target, picking.point, point)
	self:CancelPointPicker()
	self:AnchorsChanged()
end

function module:PreviewPointLine(dot)
	local picker = self.pointPicker
	if not dot or not self.picking or not self.picking.point then
		picker.line:Hide()
		return
	end

	picker.line:SetStartPoint("CENTER", picker.marker)
	picker.line:SetEndPoint("CENTER", dot)
	picker.line:Show()
end

function module:CancelPointPicker()
	if not self.picking then
		return
	end

	self.picking = nil
	self.pointPicker:Hide()

	-- Brings the nudge window back on the selected mover
	if E.ConfigurationMode and self.selected then
		self:Select(self.selected)
	end
end
