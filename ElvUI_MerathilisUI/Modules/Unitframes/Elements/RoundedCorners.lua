local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnitFrames")
local UF = E:GetModule("UnitFrames")
local ElvUF = E.oUF

local CreateFrame = CreateFrame
local floor = math.floor
local format = format
local hooksecurefunc = hooksecurefunc
local ipairs = ipairs
local max = math.max
local min = math.min
local pairs = pairs
local unpack = unpack
local wipe = wipe

--[[
	Rounded corners for the health, power, class and cast bars
	of the single units and the party, raid, boss and arena frames

	ElvUI's pixel border is hidden and replaced by an own shell around the bar:
	a rounded border, a rounded background on top of it and a rounded mask on every bar texture.

	A texture takes at most 3 masks, so every shape is a single nine-slice mask.
	Radius 0: a Blizzard atlas with slice data, its corners keep their size on any bar width.
	A mask scale below 1 only shrinks them and one above 1 does not grow them,
	so the radius is the atlas' own.

	Any other radius: own mask files (Media/Textures/Rounded). Each file is (2r + 1) texels square
	and sliced at r texels, never bigger, the client shrinks the corners of a sliced texture
	bigger than its region. A mask takes a new shape only while no texture carries it.
	The border is a ring: the filled shape with the inverse of the background's shape cut out,
	so the background may be see-through.
--]]

-- A filled rounded rect with slice data, most other rounded atlases are outlines or see-through
local MASK_ATLAS = "uitools-button-background-default"

-- How far a flat side reaches past the bar, more than a corner of the atlas
local FLAT_REACH = 16

local MASK_PATH = I.General.MediaPath .. "Textures\\Rounded\\"
local MAX_RADIUS = 16
local STRETCHED = Enum.UITextureSliceMode.Stretched

-- The round corners of a shape with a flat side, as in the file names (1 TL, 2 TR, 4 BL, 8 BR)
local FLAT_CORNERS = { TOP = "-12", BOTTOM = "-3" }

local PREDICTION_BARS = { "healingPlayer", "healingOther", "damageAbsorb", "healAbsorb" }

-- Every class bar element ElvUI may build on a frame, frame.ClassBar names the active one
local CLASS_BARS = {
	"ClassPower",
	"Runes",
	"Totems",
	"Stagger",
	"EclipseBar",
	"AlternativePower",
	"AdditionalPower",
	"ThirdPower",
}

-- Segmented class bars: one box around all buttons, or a box per button in mini mode
local SEGMENTED = {
	ClassPower = true,
	Runes = true,
	Totems = true,
}

-- The shape is set by ShapeMask, MER_Textures holds every texture carrying the mask
local function CreateMask(owner)
	local mask = owner:CreateMaskTexture()
	mask:SetSnapToPixelGrid(false)
	mask:SetTexelSnappingBias(0)
	mask.MER_Textures = {}
	return mask
end

local function AttachMask(texture, mask)
	if not mask.MER_Textures[texture] then
		texture:AddMaskTexture(mask)
		mask.MER_Textures[texture] = true
	end
end

local function DetachMask(texture, mask)
	if mask.MER_Textures[texture] then
		texture:RemoveMaskTexture(mask)
		mask.MER_Textures[texture] = nil
	end
end

-- r: the radius of the own files, nil for the atlas. A mask only takes a new shape while
-- no texture carries it, so it comes off every texture and goes back on afterwards.
local function ShapeMask(mask, r, flat, inverse)
	local key = r and format("rounded-%s%d%s", inverse and "inv-" or "", r, FLAT_CORNERS[flat] or "") or MASK_ATLAS
	if mask.MER_Shape == key then
		return
	end

	for texture in pairs(mask.MER_Textures) do
		texture:RemoveMaskTexture(mask)
	end

	if r then
		local wrap = inverse and "CLAMPTOWHITE" or "CLAMPTOBLACKADDITIVE"
		mask:SetTexture(MASK_PATH .. key, wrap, wrap)
		mask:SetTextureSliceMargins(r, r, r, r)
		mask:SetTextureSliceMode(STRETCHED)
	else
		mask:ClearTextureSlice()
		mask:SetAtlas(MASK_ATLAS, false, "TRILINEAR", true, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
	end
	mask.MER_Shape = key

	for texture in pairs(mask.MER_Textures) do
		texture:AddMaskTexture(mask)
	end
end

-- Atlas: a flat side reaches past the anchor, its rounded corners are never visible.
-- Own files have square corners on the flat side.
local function LayoutMask(mask, anchor, inset, flat)
	local reach = mask.MER_Shape == MASK_ATLAS and FLAT_REACH or 0
	local top = flat == "TOP" and reach or 0
	local bottom = flat == "BOTTOM" and reach or 0

	mask:ClearAllPoints()
	mask:SetPoint("TOPLEFT", anchor, "TOPLEFT", inset, top - inset)
	mask:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", -inset, inset - bottom)
end

-- The outer radius for a shell and the one inside its border, nil for the atlas.
-- A (2r + 1) file never gets bigger than the shape's short side.
local function GetRadii(rect, border)
	local radius = E.db.mui.unitframes.roundedCorners.radius
	if not radius or radius <= 0 then
		return
	end

	local outer = min(radius, MAX_RADIUS)
	local short = min(rect:GetWidth(), rect:GetHeight())
	if short > 0 then
		outer = min(outer, max(1, floor((short - 1) / 2)))
	end
	return outer, max(1, floor(outer - border + 0.5))
end

-- Remembers the mask on the texture, ElvUI reuses the same texture objects
local function SetTextureMask(texture, mask)
	local old = texture.MER_RoundedMask
	if old == mask then
		return
	end

	if old then
		DetachMask(texture, old)
	end
	if mask then
		AttachMask(texture, mask)
	end
	texture.MER_RoundedMask = mask
end

-- The mask lives on the frame that owns the texture, one per shape it follows
local function GetMask(owner, anchor)
	owner.MER_RoundedMasks = owner.MER_RoundedMasks or {}
	local mask = owner.MER_RoundedMasks[anchor]
	if not mask then
		mask = CreateMask(owner)
		owner.MER_RoundedMasks[anchor] = mask
	end
	return mask
end

-- Atlas: the background covers the border's inside, a see-through one would let the border color in.
-- Own files cut the background's shape out of the border, the alpha stays.
local function Shell_SetBackgroundColor(shell, r, g, b, a)
	shell.bg:SetVertexColor(r, g, b, shell.ring and a or 1)
end

-- A template on the frame itself (the castbar icon) keeps its children visible:
-- its colors are cleared instead of its alpha
local function ClearTemplate(backdrop, shell)
	shell.clearing = true
	backdrop:SetBackdropColor(0, 0, 0, 0)
	backdrop:SetBackdropBorderColor(0, 0, 0, 0)
	shell.clearing = nil

	-- ElvUI's extra border lines without thin borders
	if backdrop.iborder then
		backdrop.iborder:SetAlpha(0)
	end
	if backdrop.oborder then
		backdrop.oborder:SetAlpha(0)
	end
end

local function RestoreTemplate(backdrop, shell)
	shell.clearing = true
	backdrop:SetBackdropColor(unpack(shell.bgColor))
	backdrop:SetBackdropBorderColor(unpack(shell.borderColor))
	shell.clearing = nil

	if backdrop.iborder then
		backdrop.iborder:SetAlpha(1)
	end
	if backdrop.oborder then
		backdrop.oborder:SetAlpha(1)
	end
end

-- Kept in place, the threat border recolors on every threat change
local function StoreColor(color, r, g, b, a)
	color[1], color[2], color[3], color[4] = r, g, b, a
end

-- Follows ElvUI's backdrop colors, e.g. the threat border
local function Backdrop_SetBackdropColor(backdrop, r, g, b, a)
	local shell = backdrop.MER_RoundedShell
	if not shell or shell.clearing then
		return
	end

	StoreColor(shell.bgColor, r, g, b, a)
	Shell_SetBackgroundColor(shell, r, g, b, a)
	if shell.clears and shell.active then
		ClearTemplate(backdrop, shell)
	end
end

local function Backdrop_SetBackdropBorderColor(backdrop, r, g, b, a)
	local shell = backdrop.MER_RoundedShell
	if not shell or shell.clearing then
		return
	end

	StoreColor(shell.borderColor, r, g, b, a)
	shell.border:SetVertexColor(r, g, b, a)
	if shell.clears and shell.active then
		ClearTemplate(backdrop, shell)
	end
end

-- Shown and hidden together with ElvUI's backdrop, the class bars toggle theirs
local function Backdrop_OnShow(backdrop)
	backdrop.MER_RoundedShell:Show()
end

local function Backdrop_OnHide(backdrop)
	backdrop.MER_RoundedShell:Hide()
end

local function CreateShell(backdrop)
	-- Below the backdrop: in mini mode the class bar buttons put their bg on the backdrop itself
	local shell = CreateFrame("Frame", nil, backdrop:GetParent())
	shell:SetFrameLevel(max(backdrop:GetFrameLevel() - 1, 0))

	-- The whole outer shape, the background on top leaves only the ring visible
	shell.border = shell:CreateTexture(nil, "BACKGROUND", nil, -1)
	shell.border:SetTexture(E.media.blankTex)
	shell.border:SetAllPoints()
	shell.borderMask = CreateMask(shell)
	AttachMask(shell.border, shell.borderMask)
	-- Own files only: the background's shape cut out of the border
	shell.holeMask = CreateMask(shell)

	shell.bg = shell:CreateTexture(nil, "BACKGROUND", nil, 1)
	shell.bg:SetTexture(E.media.blankTex)
	shell.bgMask = CreateMask(shell)
	AttachMask(shell.bg, shell.bgMask)

	shell.bgColor = {}
	shell.borderColor = {}

	backdrop.MER_RoundedShell = shell
	hooksecurefunc(backdrop, "SetBackdropColor", Backdrop_SetBackdropColor)
	hooksecurefunc(backdrop, "SetBackdropBorderColor", Backdrop_SetBackdropBorderColor)
	backdrop:HookScript("OnShow", Backdrop_OnShow)
	backdrop:HookScript("OnHide", Backdrop_OnHide)

	return shell
end

-- A flat side keeps its border line: the background stops short of it.
-- Returns the radius inside the border for the bar textures, nil for the atlas.
local function LayoutShell(shell, border, flat)
	local outer, inner = GetRadii(shell, border)

	ShapeMask(shell.borderMask, outer, flat)
	LayoutMask(shell.borderMask, shell, 0, flat)

	shell.bg:ClearAllPoints()
	shell.bg:SetPoint("TOPLEFT", shell, "TOPLEFT", border, -border)
	shell.bg:SetPoint("BOTTOMRIGHT", shell, "BOTTOMRIGHT", -border, border)
	ShapeMask(shell.bgMask, inner, flat)
	LayoutMask(shell.bgMask, shell, border, flat)

	-- The hole has the background's exact shape and place, so border and body meet without a gap
	shell.ring = outer ~= nil
	if shell.ring then
		ShapeMask(shell.holeMask, inner, flat, true)
		LayoutMask(shell.holeMask, shell, border, flat)
		AttachMask(shell.border, shell.holeMask)
	else
		DetachMask(shell.border, shell.holeMask)
	end

	return inner
end

-- Replaces the backdrop of a frame with the rounded shell, same rect as ElvUI's backdrop.
-- clears: the template sits on the frame itself, see ClearTemplate
local function ApplyShell(bar, flat, backdrop, clears)
	backdrop = backdrop or bar.backdrop
	if not backdrop then
		return
	end

	local shell = backdrop.MER_RoundedShell or CreateShell(backdrop)
	shell:ClearAllPoints()
	shell:SetAllPoints(backdrop)
	shell:SetShown(backdrop:IsShown())

	bar.MER_RoundedRadius = LayoutShell(shell, E.mult, flat)

	-- A cleared template reads back as invisible, its colors are the ones seen before
	if not shell.active then
		StoreColor(shell.bgColor, backdrop:GetBackdropColor())
		StoreColor(shell.borderColor, backdrop:GetBackdropBorderColor())
	end
	Shell_SetBackgroundColor(shell, unpack(shell.bgColor))
	shell.border:SetVertexColor(unpack(shell.borderColor))

	shell.clears = clears
	shell.active = true
	if clears then
		ClearTemplate(backdrop, shell)
	else
		backdrop:SetAlpha(0)
	end
	bar.MER_RoundedBackdrop = backdrop
end

-- Every texture masked for a frame, so turning it off finds them again.
-- The bar fills the shell's inside, its textures take the background's radius.
local function MaskTextures(bar, anchor, textures, flat)
	bar.MER_RoundedTextures = bar.MER_RoundedTextures or {}

	for _, tex in ipairs(textures) do
		local mask = GetMask(tex:GetParent(), anchor)
		ShapeMask(mask, bar.MER_RoundedRadius, flat)
		LayoutMask(mask, anchor, 0, flat)
		SetTextureMask(tex, mask)
		bar.MER_RoundedTextures[#bar.MER_RoundedTextures + 1] = tex
	end
end

local function Disable(bar)
	if not bar then
		return
	end

	local backdrop = bar.MER_RoundedBackdrop
	if backdrop then
		local shell = backdrop.MER_RoundedShell
		shell:Hide()
		shell.active = nil
		if shell.clears then
			RestoreTemplate(backdrop, shell)
		else
			backdrop:SetAlpha(1)
		end
		bar.MER_RoundedBackdrop = nil
	end

	if bar.MER_RoundedTextures then
		for _, tex in ipairs(bar.MER_RoundedTextures) do
			SetTextureMask(tex, nil)
		end
		wipe(bar.MER_RoundedTextures)
	end
end

local function AddStatusBar(textures, bar)
	if bar and bar.GetStatusBarTexture then
		textures[#textures + 1] = bar:GetStatusBarTexture()
		if bar.bg then
			textures[#textures + 1] = bar.bg
		end
	end
	return textures
end

local function ApplyHealth(frame, flat)
	local health = frame.Health
	if not health then
		return
	end

	local textures = AddStatusBar({}, health)
	if frame.HealthPrediction then
		for _, key in ipairs(PREDICTION_BARS) do
			local predictionBar = frame.HealthPrediction[key]
			if predictionBar then
				textures[#textures + 1] = predictionBar:GetStatusBarTexture()
			end
		end
	end

	Disable(health)
	ApplyShell(health, flat)
	MaskTextures(health, health, textures, flat)
end

local function ApplyBar(bar, flat)
	if not bar then
		return
	end

	Disable(bar)
	ApplyShell(bar, flat)
	MaskTextures(bar, bar, AddStatusBar({}, bar), flat)
end

local function ApplyClassBar(frame, key)
	local bars = frame[key]
	if not bars then
		return
	end

	Disable(bars)

	if not SEGMENTED[key] then
		if bars.GetStatusBarTexture then
			ApplyBar(bars)
		else
			-- Eclipse: two bars in one box
			ApplyShell(bars)
			local textures = {}
			for _, child in pairs({ bars:GetChildren() }) do
				AddStatusBar(textures, child)
			end
			MaskTextures(bars, bars, textures)
		end
		return
	end

	if frame.USE_MINI_CLASSBAR then
		for _, button in ipairs(bars) do
			-- ElvUI puts the bg on the backdrop in mini mode, hiding the backdrop would take it along
			if button.bg and button.backdrop and button.bg:GetParent() == button.backdrop then
				button.bg:SetParent(button)
				button.MER_RoundedBgParent = button.backdrop
			end
			ApplyBar(button)
		end
	else
		-- One mask for all buttons: the first and the last one get the rounded ends
		ApplyShell(bars)
		local textures = {}
		for _, button in ipairs(bars) do
			-- ElvUI has moved the bg back to the bars already
			button.MER_RoundedBgParent = nil
			Disable(button)
			AddStatusBar(textures, button)
		end
		MaskTextures(bars, bars, textures)
	end
end

local function DisableClassBars(frame)
	for _, key in ipairs(CLASS_BARS) do
		local bars = frame[key]
		if bars then
			Disable(bars)
			if SEGMENTED[key] then
				for _, button in ipairs(bars) do
					Disable(button)
					if button.MER_RoundedBgParent then
						button.bg:SetParent(button.MER_RoundedBgParent)
						button.MER_RoundedBgParent = nil
					end
				end
			end
		end
	end
end

-- Every texture on the castbar: fill, bg, the shield and latency overlays, the spark,
-- the tick lines and the Interrupt Ready tint and window
local function ApplyCastbar(castbar)
	Disable(castbar)
	ApplyShell(castbar)

	local textures = {}
	for _, region in ipairs({ castbar:GetRegions() }) do
		if region:GetObjectType() == "Texture" then
			textures[#textures + 1] = region
		end
	end
	MaskTextures(castbar, castbar, textures)

	-- The icon's template is on its own frame, the icon a texture of it
	local icon = castbar.ButtonIcon
	local button = icon and icon.bg
	if button then
		Disable(button)
		ApplyShell(button, nil, button, true)
		MaskTextures(button, icon, { icon })
	end
end

local function DisableCastbar(castbar)
	Disable(castbar)
	if castbar.ButtonIcon then
		Disable(castbar.ButtonIcon.bg)
	end
end

-- An attached power bar shares the border with the health bar, they round as one block
local function IsPowerAttached(frame)
	return frame.USE_POWERBAR
		and frame.POWERBAR_SHOWN
		and not frame.POWERBAR_DETACHED
		and not frame.USE_INSET_POWERBAR
		and not frame.USE_MINI_POWERBAR
		and not frame.USE_POWERBAR_OFFSET
end

-- unitframeType to the option key, the raid groups share one
local UNITS = {
	player = "player",
	target = "target",
	focus = "focus",
	targettarget = "targettarget",
	pet = "pet",
	pettarget = "pettarget",
	party = "party",
	raid1 = "raid",
	raid2 = "raid",
	raid3 = "raid",
	boss = "boss",
	arena = "arena",
}

-- Returns the settings and whether the frame's unit is rounded, nil for frames without an option
local function GetSettings(frame)
	local unit = frame and UNITS[frame.unitframeType]
	if not unit then
		return
	end

	local db = E.db.mui.unitframes.roundedCorners
	return db, (db.enable and db.units[unit]) or false
end

-- Health and power together, the attached power bar decides the flat sides of both
local function ConfigureBars(frame, enabled)
	if not enabled then
		Disable(frame.Health)
		Disable(frame.Power)
	elseif IsPowerAttached(frame) then
		ApplyHealth(frame, "BOTTOM")
		ApplyBar(frame.Power, "TOP")
	else
		ApplyHealth(frame)
		-- The shell hangs on the power bar, it hides with it
		if frame.USE_POWERBAR then
			ApplyBar(frame.Power)
		else
			Disable(frame.Power)
		end
	end
end

local function ConfigureCastbar(frame, db, enabled)
	if frame.Castbar then
		if enabled and db.units.castbar then
			ApplyCastbar(frame.Castbar)
		else
			DisableCastbar(frame.Castbar)
		end
	end
end

local function ConfigureClassBars(frame, db, enabled)
	if frame.ClassBar then
		if enabled and db.units.classbar then
			for _, key in ipairs(CLASS_BARS) do
				ApplyClassBar(frame, key)
			end
		else
			DisableClassBars(frame)
		end
	end
end

function module:Configure_RoundedCorners(frame)
	local db, enabled = GetSettings(frame)
	if not db then
		return
	end

	ConfigureBars(frame, enabled)
	ConfigureCastbar(frame, db, enabled)
	ConfigureClassBars(frame, db, enabled)
end

-- oUF keeps every spawned frame, the group headers' children included
function module:UpdateRoundedCorners()
	-- The mask atlas is not known to exist on Forever
	if E.Forever then
		return
	end

	for _, frame in ipairs(ElvUF.objects) do
		module:Configure_RoundedCorners(frame)
	end
end

function module:RoundedCorners()
	if E.Forever then
		return
	end

	-- All run after ElvUI placed a bar; the power bar is placed after the health bar
	-- and can change without a full update, the class bar changes with the spec.
	-- Each hook only redoes its own bar: ElvUI also runs these in combat whenever an
	-- auto-hiding power or class bar shows or hides (e.g. combo points at zero).
	local function ConfigureHealthPower(_, frame)
		local db, enabled = GetSettings(frame)
		if db then
			ConfigureBars(frame, enabled)
		end
	end
	hooksecurefunc(UF, "Configure_HealthBar", ConfigureHealthPower)
	hooksecurefunc(UF, "Configure_Power", ConfigureHealthPower)

	hooksecurefunc(UF, "Configure_ClassBar", function(_, frame)
		local db, enabled = GetSettings(frame)
		if db then
			ConfigureClassBars(frame, db, enabled)
		end
	end)

	hooksecurefunc(UF, "Configure_Castbar", function(_, frame)
		local db, enabled = GetSettings(frame)
		if db then
			ConfigureCastbar(frame, db, enabled)
		end
	end)

	-- ElvUI spawns its frames before our hooks exist
	module:UpdateRoundedCorners()
end
