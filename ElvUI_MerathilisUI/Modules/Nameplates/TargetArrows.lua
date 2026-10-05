local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Nameplates")
local NP = E:GetModule("NamePlates")
local ElvUF = E.oUF

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local max = math.max
local pairs = pairs
local unpack = unpack

--[[
	oUF element: MER_TargetArrows

	Animated arrows next to the health bar of the target's nameplate. While it is
	enabled, the arrows of ElvUI's own target indicator are hidden, its glow stays.

	Widget: nameplate.MER_TargetArrows - a Frame parented to the health bar, so
	name-only plates (health bar reparented to a hidden frame) never show it
	Options: element.animation - "slide", "bounce", "slideBounce" or "none"
--]]

local INTRO_DURATION = 0.3
local BOUNCE_DURATION = 0.55

-- ElvUI's arrow textures point up, the coords turn them towards the health bar
local ARROWS = {
	left = {
		coords = { 1, 1, 0, 1, 1, 0, 0, 0 },
		dirX = -1,
		dirY = 0,
	},
	right = {
		coords = { 1, 0, 0, 0, 1, 1, 0, 1 },
		dirX = 1,
		dirY = 0,
	},
	top = {
		coords = { 1, 1, 1, 0, 0, 1, 0, 0 },
		dirX = 0,
		dirY = 1,
	},
}

local LAYOUTS = {
	sides = { left = true, right = true },
	top = { top = true },
	all = { left = true, right = true, top = true },
}

local function StopArrow(arrow)
	arrow.intro:Stop()
	arrow.bounce:Stop()
	arrow:SetAlpha(1)
end

local function PlayArrow(element, arrow)
	StopArrow(arrow)

	local animation = element.animation
	if animation == "slide" or animation == "slideBounce" then
		arrow.intro:Play()
	elseif animation == "bounce" then
		arrow.bounce:Play()
	end
end

local function Intro_OnFinished(intro)
	local arrow = intro.arrow
	if arrow.element.animation == "slideBounce" and arrow:IsVisible() then
		arrow.bounce:Play()
	end
end

local function CreateArrow(element, key)
	local arrow = element:CreateTexture(nil, "OVERLAY")
	arrow:SetTexCoord(unpack(ARROWS[key].coords))
	arrow:Hide()
	arrow.element = element
	arrow.key = key

	-- Starts outside, then slides in towards the bar while fading in
	local intro = arrow:CreateAnimationGroup()
	intro.arrow = arrow
	intro.offset = intro:CreateAnimation("Translation")
	intro.offset:SetDuration(0)
	intro.offset:SetOrder(1)
	intro.hold = intro:CreateAnimation("Alpha")
	intro.hold:SetFromAlpha(0)
	intro.hold:SetToAlpha(0)
	intro.hold:SetDuration(0)
	intro.hold:SetOrder(1)
	intro.slide = intro:CreateAnimation("Translation")
	intro.slide:SetDuration(INTRO_DURATION)
	intro.slide:SetSmoothing("OUT")
	intro.slide:SetOrder(2)
	intro.fade = intro:CreateAnimation("Alpha")
	intro.fade:SetFromAlpha(0)
	intro.fade:SetToAlpha(1)
	intro.fade:SetDuration(INTRO_DURATION)
	intro.fade:SetOrder(2)
	intro:SetScript("OnFinished", Intro_OnFinished)
	arrow.intro = intro

	-- Nudges towards the bar and back
	local bounce = arrow:CreateAnimationGroup()
	bounce:SetLooping("BOUNCE")
	bounce.move = bounce:CreateAnimation("Translation")
	bounce.move:SetDuration(BOUNCE_DURATION)
	bounce.move:SetSmoothing("IN_OUT")
	arrow.bounce = bounce

	return arrow
end

local function Element_OnShow(element)
	for _, arrow in pairs(element.arrows) do
		if arrow:IsShown() then
			PlayArrow(element, arrow)
		end
	end
end

-- Also fires when the plate (or the reparented health bar) hides. Hiding the
-- element itself makes the next target plate play the intro again.
local function Element_OnHide(element)
	for _, arrow in pairs(element.arrows) do
		StopArrow(arrow)
	end

	element:Hide()
end

local function Update(self, event, unit)
	local element = self.MER_TargetArrows

	if element.PreUpdate then
		element:PreUpdate()
	end

	local isTarget = self.__unit and E:UnitIsUnit(self.__unit, "target")
	if isTarget then
		element:Show()
	else
		element:Hide()
	end

	if element.PostUpdate then
		return element:PostUpdate(isTarget)
	end
end

local function Path(self, ...)
	return (self.MER_TargetArrows.Override or Update)(self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, "ForceUpdate", element.__owner.__unit)
end

local function Enable(self)
	local element = self.MER_TargetArrows
	if element then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent("PLAYER_TARGET_CHANGED", Path, true)

		return true
	end
end

local function Disable(self)
	local element = self.MER_TargetArrows
	if element then
		element:Hide()

		self:UnregisterEvent("PLAYER_TARGET_CHANGED", Path)
	end
end

ElvUF:AddElement("MER_TargetArrows", Path, Enable, Disable)

-- Nameplate integration
local function HideElvUIArrows(indicator)
	if indicator.TopIndicator then
		indicator.TopIndicator:Hide()
	end
	if indicator.LeftIndicator then
		indicator.LeftIndicator:Hide()
	end
	if indicator.RightIndicator then
		indicator.RightIndicator:Hide()
	end
end

local function UpdateElvUIArrows(nameplate, hide)
	local indicator = nameplate.TargetIndicator
	if not indicator then
		return
	end

	if hide then
		indicator.PostUpdate = HideElvUIArrows
	elseif indicator.PostUpdate == HideElvUIArrows then
		indicator.PostUpdate = nil
	end

	if indicator.ForceUpdate and nameplate:IsElementEnabled("TargetIndicator") then
		indicator:ForceUpdate()
	end
end

local function GetArrowColor(db)
	if db.colorMode == "CUSTOM" then
		return db.customColor.r, db.customColor.g, db.customColor.b
	end

	local color = E:ClassColor(E.myclass, true)
	return color.r, color.g, color.b
end

-- The side arrows move out by the width of a castbar icon that sticks out next to them
local function PlaceArrow(element, arrow)
	local anchor, spacing = element.anchor, element.spacing
	arrow:ClearAllPoints()

	if arrow.key == "left" then
		arrow:Point("RIGHT", anchor, "LEFT", -spacing - element.dodge.left, 0)
	elseif arrow.key == "right" then
		arrow:Point("LEFT", anchor, "RIGHT", spacing + element.dodge.right, 0)
	else
		arrow:Point("BOTTOM", anchor, "TOP", 0, spacing)
	end
end

local function SetDodge(element, left, right)
	if element.dodge.left == left and element.dodge.right == right then
		return
	end

	element.dodge.left, element.dodge.right = left, right
	PlaceArrow(element, element.arrows.left)
	PlaceArrow(element, element.arrows.right)
end

-- Position of an anchor point inside a box, relative to the box center
local POINT_OFFSETS = {
	TOPLEFT = { -0.5, 0.5 },
	TOP = { 0, 0.5 },
	TOPRIGHT = { 0.5, 0.5 },
	LEFT = { -0.5, 0 },
	CENTER = { 0, 0 },
	RIGHT = { 0.5, 0 },
	BOTTOMLEFT = { -0.5, -0.5 },
	BOTTOM = { 0, -0.5 },
	BOTTOMRIGHT = { 0.5, -0.5 },
}

-- Nameplates are restricted regions that can't be measured, so the icon position is
-- worked out from the same settings ElvUI lays it out with (Update_Castbar), in
-- coordinates relative to the nameplate center where the health bar sits
local function UpdateDodge(element, nameplate)
	local plateDB = NP:PlateDB(nameplate)
	local db = plateDB and plateDB.castbar
	local plateWidth, plateHeight = nameplate.width, nameplate.height
	if not (db and db.showIcon and plateWidth and plateHeight) then
		SetDodge(element, 0, 0)
		return
	end

	local anchor = POINT_OFFSETS[db.anchorPoint]
	local inverse = POINT_OFFSETS[E.InversePoints[db.anchorPoint]]
	if not (anchor and inverse) then
		SetDodge(element, 0, 0)
		return
	end

	local castbarX = anchor[1] * plateWidth + db.xOffset - inverse[1] * db.width
	local castbarY = anchor[2] * plateHeight + db.yOffset - inverse[2] * db.height
	local castbarBottom = castbarY - db.height / 2

	local size = db.iconSize
	local buttonLeft
	if db.iconPosition == "RIGHT" then
		buttonLeft = castbarX + db.width / 2 + db.iconOffsetX
	else
		buttonLeft = castbarX - db.width / 2 + db.iconOffsetX - size
	end
	local buttonBottom = castbarBottom + db.iconOffsetY

	-- Only an icon at the height of the arrows is in their way
	local half = E.db.mui.nameplates.targetArrows.size / 2
	if buttonBottom >= half or buttonBottom + size <= -half then
		SetDodge(element, 0, 0)
		return
	end

	local healthHalf = plateDB.health.width / 2
	SetDodge(element, max(0, -healthHalf - buttonLeft), max(0, buttonLeft + size - healthHalf))
end

local function ConfigureArrow(element, arrow, db, r, g, b)
	local info = ARROWS[arrow.key]
	local size = db.size

	arrow:SetTexture(E.Media.Arrows[db.arrow] or E.Media.Arrows.Arrow9)
	arrow:SetVertexColor(r, g, b)
	arrow:Size(size)
	PlaceArrow(element, arrow)

	local distance = size * 0.75
	arrow.intro.offset:SetOffset(info.dirX * distance, info.dirY * distance)
	arrow.intro.slide:SetOffset(-info.dirX * distance, -info.dirY * distance)

	local nudge = max(2, size * 0.2)
	arrow.bounce.move:SetOffset(-info.dirX * nudge, -info.dirY * nudge)
end

function module:Configure_TargetArrows(nameplate)
	if not nameplate or nameplate == NP.TestFrame or not nameplate.Health then
		return
	end

	local db = E.db.mui.nameplates.targetArrows
	local enabled = db and db.enable and nameplate.frameType ~= "PLAYER"

	if not enabled then
		if nameplate.MER_TargetArrows and nameplate:IsElementEnabled("MER_TargetArrows") then
			nameplate:DisableElement("MER_TargetArrows")
		end
		UpdateElvUIArrows(nameplate, false)
		return
	end

	local element = nameplate.MER_TargetArrows
	if not element then
		element = CreateFrame("Frame", nil, nameplate.Health)
		element:SetAllPoints(nameplate.Health)
		element:Hide()
		element.arrows = {}
		for key in pairs(ARROWS) do
			element.arrows[key] = CreateArrow(element, key)
		end
		element:SetScript("OnShow", Element_OnShow)
		element:SetScript("OnHide", Element_OnHide)
		element.dodge = { left = 0, right = 0 }
		nameplate.MER_TargetArrows = element

		-- A castbar only shows while the unit casts, its icon may cover an arrow
		local castbar = nameplate.Castbar
		if castbar then
			castbar:HookScript("OnShow", function()
				UpdateDodge(element, nameplate)
			end)
			castbar:HookScript("OnHide", function()
				SetDodge(element, 0, 0)
			end)
		end
	end

	element:SetFrameLevel(nameplate.Health:GetFrameLevel() + 5)
	element.animation = db.animation
	element.anchor = nameplate.Health
	element.spacing = db.spacing

	local r, g, b = GetArrowColor(db)
	local layout = LAYOUTS[db.layout] or LAYOUTS.sides
	for key, arrow in pairs(element.arrows) do
		ConfigureArrow(element, arrow, db, r, g, b)
		arrow:SetShown(layout[key] == true)
	end

	-- Replays the animation with the new settings on the current target
	if element:IsShown() then
		Element_OnShow(element)
	end

	if not nameplate:IsElementEnabled("MER_TargetArrows") then
		nameplate:EnableElement("MER_TargetArrows")
	end

	UpdateElvUIArrows(nameplate, true)

	if nameplate.__unit then
		element:ForceUpdate()
	end
end

function module:UpdateTargetArrows()
	if not NP.Plates then
		return
	end

	for nameplate in pairs(NP.Plates) do
		module:Configure_TargetArrows(nameplate)
	end
end

function module:TargetArrows()
	-- Runs for every plate that gets (re)configured with a health bar
	hooksecurefunc(NP, "Update_TargetIndicator", function(_, nameplate)
		module:Configure_TargetArrows(nameplate)
	end)

	-- Plates that already existed before the hook
	module:UpdateTargetArrows()
end
