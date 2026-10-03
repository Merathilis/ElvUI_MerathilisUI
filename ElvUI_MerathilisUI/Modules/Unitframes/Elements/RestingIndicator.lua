local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnitFrames")
local UF = E:GetModule("UnitFrames")

local CreateColor = CreateColor
local hooksecurefunc = hooksecurefunc

--[[
	Animated resting indicator

	Draws a looping "Zzz" flipbook over the icon of ElvUI's RestingIndicator element.
	ElvUI keeps owning the element (events, position, size, hide at max level, test
	display), the loop only mirrors the icon's visibility and hides it by alpha.
--]]

local TEXTURE = I.General.MediaPath .. "Textures\\UIUnitFrameRestingFlipBook.tga"
local BLIZZARD_ATLAS = "UI-HUD-UnitFrame-Player-Rest-Flipbook"
local BASE_DURATION = 1.5
-- The flipbook cells carry padding around the Zzz, so the loop is drawn larger than the icon
local SIZE_RATIO = 1.6
-- Cell size in pixels of the grayscale texture, the atlas derives it from rows and columns
local CELL_SIZE = 60

local WHITE = CreateColor(1, 1, 1, 1)

local function UpdateVisibility(icon)
	local loop = icon.MER_RestLoop
	if loop.enabled and icon:IsShown() then
		loop:Show()
		if not loop.Anim:IsPlaying() then
			loop.Anim:Play()
		end
	else
		loop.Anim:Stop()
		loop:Hide()
	end
end

local function CreateLoop(icon)
	local loop = icon:GetParent():CreateTexture(nil, "OVERLAY", nil, 1)
	loop:Hide()

	local anim = loop:CreateAnimationGroup()
	anim:SetLooping("REPEAT")
	loop.Anim = anim

	local flipBook = anim:CreateAnimation("FlipBook")
	flipBook:SetFlipBookRows(7)
	flipBook:SetFlipBookColumns(6)
	flipBook:SetFlipBookFrames(42)
	loop.FlipBook = flipBook

	icon.MER_RestLoop = loop

	-- Covers oUF updates, ElvUI's max level hide, its test display and disabling the element
	hooksecurefunc(icon, "Show", UpdateVisibility)
	hooksecurefunc(icon, "Hide", UpdateVisibility)
	hooksecurefunc(icon, "SetShown", UpdateVisibility)

	return loop
end

local function ApplyStyle(loop, db)
	local flipBook = loop.FlipBook

	if db.colorMode == "BLIZZARD" then
		loop:SetAtlas(BLIZZARD_ATLAS)
		flipBook:SetFlipBookFrameWidth(0)
		flipBook:SetFlipBookFrameHeight(0)
		loop:SetGradient("HORIZONTAL", WHITE, WHITE)
	else
		loop:SetTexture(TEXTURE)
		loop:SetTexCoord(0, 1, 0, 1)
		flipBook:SetFlipBookFrameWidth(CELL_SIZE)
		flipBook:SetFlipBookFrameHeight(CELL_SIZE)

		if db.colorMode == "CLASS" then
			local color = CreateColor(F.r, F.g, F.b, 1)
			loop:SetGradient("HORIZONTAL", color, color)
		elseif db.colorMode == "CUSTOM" then
			local c = db.customColor
			local color = CreateColor(c.r, c.g, c.b, 1)
			loop:SetGradient("HORIZONTAL", color, color)
		else
			local left, right = F.GradientColors(E.myclass)
			loop:SetGradient(
				"HORIZONTAL",
				CreateColor(left.r, left.g, left.b, 1),
				CreateColor(right.r, right.g, right.b, 1)
			)
		end
	end

	flipBook:SetDuration(BASE_DURATION / (db.speed or 1))
end

function module:Configure_RestingIndicator(frame)
	local icon = frame and frame.RestingIndicator
	if not icon then
		return
	end

	local db = E.db.mui.unitframes.restingIndicator
	local iconDb = frame.db and frame.db.RestIcon
	local loop = icon.MER_RestLoop

	if not (db.enable and iconDb and iconDb.enable) then
		if loop then
			loop.enabled = false
			icon:SetAlpha(1)
			UpdateVisibility(icon)
		end
		return
	end

	loop = loop or CreateLoop(icon)
	loop.enabled = true
	icon:SetAlpha(0)

	loop:Size(iconDb.size * SIZE_RATIO)
	loop:ClearAllPoints()
	loop:Point("CENTER", icon, "CENTER")

	-- Flipbook settings only apply cleanly to a stopped animation
	loop.Anim:Stop()
	ApplyStyle(loop, db)
	UpdateVisibility(icon)
end

function module:UpdateRestingIndicator()
	module:Configure_RestingIndicator(UF.player)
end

function module:RestingIndicator()
	hooksecurefunc(UF, "Configure_RestingIndicator", function(_, frame)
		module:Configure_RestingIndicator(frame)
	end)

	-- ElvUI spawns its frames before our hooks exist
	module:UpdateRestingIndicator()
end
