local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Preview = module.Preview

local min, pi = math.min, math.pi
local CreateFrame = CreateFrame
local C_Spell_GetSpellTexture = C_Spell.GetSpellTexture

-- A row of player buffs with the Collapse & Expand Button. Used as
-- `dialogControl` on a description named "auras". Click the arrow to see the
-- row collapse to the buffs that run out soonest, like the button on ElvUI's
-- Player Buffs; the preview keeps its own state, your buffs stay as they are.
-- Size, spacing and the side of the button follow ElvUI's buff settings.

local HEIGHT = 70
local GAP = 2
local ARROW_SIZE = 22
local MAX_ICONS = 10
-- Collapsed, only the ones that run out soonest stay
local COLLAPSED_COUNT = 4

-- Raid buffs and a few short ones, the short ones first when collapsed
local SAMPLES = {
	{ spellID = 2825, time = "28s", short = true },
	{ spellID = 1022, time = "6s", short = true },
	{ spellID = 10060, time = "12s", short = true },
	{ spellID = 194249, time = "15s", short = true },
	{ spellID = 21562, time = "58m" },
	{ spellID = 1459, time = "59m" },
	{ spellID = 1126, time = "55m" },
	{ spellID = 6673, time = "57m" },
	{ spellID = 462854, time = "54m" },
	{ spellID = 381748, time = "56m" },
}

-- Same mirrored rotations as Modules/Auras/Core.lua
local ROTATION_RIGHT, ROTATION_LEFT = pi, 0

local function IsLeftGrowth()
	local growth = E.db.auras.buffs.growthDirection or "LEFT_DOWN"
	return growth:find("^LEFT") ~= nil
end

local function Update(widget)
	local db = E.db.mui.auras.buffsCollapse
	local buffs = E.db.auras.buffs
	local size = min(buffs.size or 32, 40)
	local spacing = buffs.horizontalSpacing or 6
	local collapsed = widget.collapsed
	local count = collapsed and COLLAPSED_COUNT or min(buffs.wrapAfter or MAX_ICONS, MAX_ICONS)
	local growLeft = IsLeftGrowth()

	local rowWidth = count * size + (count - 1) * spacing
	local holder = widget.holder
	holder:SetSize(rowWidth, size)
	holder:ClearAllPoints()
	-- The row starts on the button side and grows away from it
	if growLeft then
		holder:SetPoint("RIGHT", widget.frame, "CENTER", rowWidth / 2, 4)
	else
		holder:SetPoint("LEFT", widget.frame, "CENTER", -rowWidth / 2, 4)
	end

	local shown = 0
	for _, button in ipairs(widget.icons) do
		local visible = shown < count and (not collapsed or button.sample.short)
		button:SetShown(visible)
		if visible then
			button:SetSize(size, size)
			button:ClearAllPoints()
			local offset = shown * (size + spacing)
			if growLeft then
				button:SetPoint("TOPRIGHT", holder, "TOPRIGHT", -offset, 0)
			else
				button:SetPoint("TOPLEFT", holder, "TOPLEFT", offset, 0)
			end
			shown = shown + 1
		end
	end

	-- Outside the start of the row, the arrow points the way the row opens
	local arrow = widget.arrow
	arrow:ClearAllPoints()
	if growLeft then
		arrow:SetPoint("LEFT", holder, "RIGHT", GAP, 0)
	else
		arrow:SetPoint("RIGHT", holder, "LEFT", -GAP, 0)
	end
	local opensRight = not growLeft
	local rotation
	if collapsed then
		rotation = opensRight and ROTATION_LEFT or ROTATION_RIGHT
	else
		rotation = opensRight and ROTATION_RIGHT or ROTATION_LEFT
	end
	arrow.tex:SetRotation(rotation)
	arrow.highlight:SetRotation(rotation)
	arrow:SetShown(db.enable)

	Preview.SetEnabled(widget, db.enable)
end

local function Build(widget)
	local frame = widget.frame
	widget.collapsed = false

	widget.holder = CreateFrame("Frame", nil, frame)

	widget.icons = {}
	for index, sample in ipairs(SAMPLES) do
		local button = CreateFrame("Frame", nil, widget.holder, "BackdropTemplate")
		button:SetTemplate()
		button.sample = sample

		button.icon = button:CreateTexture(nil, "ARTWORK")
		button.icon:SetInside()
		button.icon:SetTexCoord(unpack(E.TexCoords))
		button.icon:SetTexture(C_Spell_GetSpellTexture(sample.spellID) or 134400)

		button.time = button:CreateFontString(nil, "OVERLAY")
		button.time:FontTemplate(nil, 11)
		button.time:SetPoint("TOP", button, "BOTTOM", 0, -1)
		button.time:SetText(sample.time)
		if sample.short then
			button.time:SetTextColor(1, 0.82, 0)
		end

		widget.icons[index] = button
	end

	local arrow = CreateFrame("Button", nil, frame)
	arrow:SetSize(20, 40)
	arrow.tex = arrow:CreateTexture(nil, "ARTWORK")
	arrow.tex:SetTexture(E.Media.Textures.ArrowRight)
	arrow.tex:SetSize(ARROW_SIZE, ARROW_SIZE)
	arrow.tex:SetPoint("CENTER")
	arrow.highlight = arrow:CreateTexture(nil, "HIGHLIGHT")
	arrow.highlight:SetTexture(E.Media.Textures.ArrowRight)
	arrow.highlight:SetSize(ARROW_SIZE, ARROW_SIZE)
	arrow.highlight:SetPoint("CENTER")
	arrow.highlight:SetAlpha(0.4)
	arrow.highlight:SetBlendMode("ADD")
	arrow:SetScript("OnClick", function()
		widget.collapsed = not widget.collapsed
		Update(widget)
	end)
	widget.arrow = arrow
end

Preview.Register("MERAurasPreview", 1, HEIGHT, Build, Update)
