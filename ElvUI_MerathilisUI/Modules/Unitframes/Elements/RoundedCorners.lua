local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnitFrames")
local UF = E:GetModule("UnitFrames")
local ElvUF = E.oUF

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local ipairs = ipairs
local max = math.max
local pairs = pairs
local unpack = unpack
local wipe = wipe

--[[
	Rounded corners for the health, power, class and cast bars
	of the single units and the party, raid, boss and arena frames

	ElvUI's pixel border is hidden and replaced by an own shell around the bar:
	a rounded border, a rounded background on top of it and a rounded mask on every bar texture.

	A texture takes at most 3 masks, so every shape is a single nine-slice mask.
	Masks only slice atlases: the margins set on an own texture file are ignored and
	the whole file gets stretched. The atlas corners keep their size on any bar width.
	A mask scale below 1 only shrinks them and one above 1 does not grow them,
	so the radius is the atlas' own.
--]]

-- A filled rounded rect with slice data, most other rounded atlases are outlines or see-through
local MASK_ATLAS = "uitools-button-background-default"

-- How far a flat side reaches past the bar, more than a corner of the atlas
local FLAT_REACH = 16

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

local function CreateMask(owner)
	local mask = owner:CreateMaskTexture()
	mask:SetAtlas(MASK_ATLAS, false, "TRILINEAR", true, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
	mask:SetSnapToPixelGrid(false)
	mask:SetTexelSnappingBias(0)
	return mask
end

-- A flat side reaches past the anchor, its rounded corners are never visible
local function LayoutMask(mask, anchor, inset, flat)
	local top = flat == "TOP" and FLAT_REACH or 0
	local bottom = flat == "BOTTOM" and FLAT_REACH or 0

	mask:ClearAllPoints()
	mask:SetPoint("TOPLEFT", anchor, "TOPLEFT", inset, top - inset)
	mask:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", -inset, inset - bottom)
end

-- Remembers the mask on the texture, ElvUI reuses the same texture objects
local function SetTextureMask(texture, mask)
	if texture.MER_RoundedMask == mask then
		return
	end

	if texture.MER_RoundedMask then
		texture:RemoveMaskTexture(texture.MER_RoundedMask)
	end
	if mask then
		texture:AddMaskTexture(mask)
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

-- The background covers the border's inside, a see-through one would let the border color in
local function Shell_SetBackgroundColor(shell, r, g, b)
	shell.bg:SetVertexColor(r, g, b, 1)
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

-- Follows ElvUI's backdrop colors, e.g. the threat border
local function Backdrop_SetBackdropColor(backdrop, r, g, b, a)
	local shell = backdrop.MER_RoundedShell
	if not shell or shell.clearing then
		return
	end

	shell.bgColor = { r, g, b, a }
	Shell_SetBackgroundColor(shell, r, g, b)
	if shell.clears and shell.active then
		ClearTemplate(backdrop, shell)
	end
end

local function Backdrop_SetBackdropBorderColor(backdrop, r, g, b, a)
	local shell = backdrop.MER_RoundedShell
	if not shell or shell.clearing then
		return
	end

	shell.borderColor = { r, g, b, a }
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
	shell.border:AddMaskTexture(shell.borderMask)

	shell.bg = shell:CreateTexture(nil, "BACKGROUND", nil, 1)
	shell.bg:SetTexture(E.media.blankTex)
	shell.bgMask = CreateMask(shell)
	shell.bg:AddMaskTexture(shell.bgMask)

	backdrop.MER_RoundedShell = shell
	hooksecurefunc(backdrop, "SetBackdropColor", Backdrop_SetBackdropColor)
	hooksecurefunc(backdrop, "SetBackdropBorderColor", Backdrop_SetBackdropBorderColor)
	backdrop:HookScript("OnShow", Backdrop_OnShow)
	backdrop:HookScript("OnHide", Backdrop_OnHide)

	return shell
end

-- A flat side keeps its border line: the background stops short of it
local function LayoutShell(shell, border, flat)
	LayoutMask(shell.borderMask, shell, 0, flat)

	shell.bg:ClearAllPoints()
	shell.bg:SetPoint("TOPLEFT", shell, "TOPLEFT", border, -border)
	shell.bg:SetPoint("BOTTOMRIGHT", shell, "BOTTOMRIGHT", -border, border)
	LayoutMask(shell.bgMask, shell, border, flat)
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

	LayoutShell(shell, E.mult, flat)

	-- A cleared template reads back as invisible, its colors are the ones seen before
	if not shell.active then
		shell.bgColor = { backdrop:GetBackdropColor() }
		shell.borderColor = { backdrop:GetBackdropBorderColor() }
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

-- Every texture masked for a frame, so turning it off finds them again
local function MaskTextures(bar, anchor, textures, flat)
	bar.MER_RoundedTextures = bar.MER_RoundedTextures or {}

	for _, tex in ipairs(textures) do
		local mask = GetMask(tex:GetParent(), anchor)
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

function module:Configure_RoundedCorners(frame)
	local unit = frame and UNITS[frame.unitframeType]
	if not unit then
		return
	end

	local db = E.db.mui.unitframes.roundedCorners
	local enabled = db.enable and db.units[unit]

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

	if frame.Castbar then
		if enabled and db.units.castbar then
			ApplyCastbar(frame.Castbar)
		else
			DisableCastbar(frame.Castbar)
		end
	end

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
	-- and can change without a full update, the class bar changes with the spec
	local function Configure(_, frame)
		module:Configure_RoundedCorners(frame)
	end
	hooksecurefunc(UF, "Configure_HealthBar", Configure)
	hooksecurefunc(UF, "Configure_Power", Configure)
	hooksecurefunc(UF, "Configure_ClassBar", Configure)
	hooksecurefunc(UF, "Configure_Castbar", Configure)

	-- ElvUI spawns its frames before our hooks exist
	module:UpdateRoundedCorners()
end
