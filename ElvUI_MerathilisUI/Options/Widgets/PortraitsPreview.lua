local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Preview = module.Preview

local ipairs = ipairs
local max, min = math.max, math.min
local SetPortraitTexture = SetPortraitTexture

-- Sample unitframes with the Portraits. Used as `dialogControl` on a description
-- named "player:target" (both sides, the general settings) or a single unit key.
-- The portraits are built by the module itself and show the player's own face,
-- the units other than the player with a sample classification.

local MAX_WIDTH = 180
local HEIGHT = 120
local GAP = 20
local PORTRAIT_ROOM = 60

local function Build(widget)
	-- Large offsets would draw over the options around the preview
	widget.frame:SetClipsChildren(true)

	local MUF = MER:GetModule("MER_UnitFrames")
	widget.samples = {}
	for i = 1, 2 do
		local bar = Preview.CreateBar(widget.frame)
		local portrait = MUF:CreatePortrait(bar)
		portrait:SetFrameLevel(bar:GetFrameLevel() + 5)
		widget.samples[i] = { bar = bar, portrait = portrait }
	end
end

-- The first classification that is shown, elite first
local SAMPLE_ORDER = { "elite", "boss", "rareelite", "rare" }

local function GetSampleClassification()
	local types = E.db.mui.unitframes.portraits.classification.types
	for _, kind in ipairs(SAMPLE_ORDER) do
		if types[kind] then
			return kind
		end
	end
end

local function UpdateSample(sample, unit, width, offset)
	local MUF = MER:GetModule("MER_UnitFrames")
	local db = E.db.mui.unitframes.portraits
	local unitDb = db.units[unit]
	local portrait = sample.portrait

	local _, height = Preview.UnitFrameSize(unit, MAX_WIDTH)
	local color = E:ClassColor(E.myclass, true)
	Preview.UpdateBar(sample.bar, width, height, 0.8, E.db.unitframe.statusbar, color.r, color.g, color.b)
	sample.bar:ClearAllPoints()
	sample.bar:SetPoint("CENTER", offset, -8)
	sample.bar:Show()

	MUF:StylePortrait(portrait, unitDb.size, unitDb.mirror)
	portrait:ClearAllPoints()
	portrait:SetPoint(unitDb.point, sample.bar, unitDb.relativePoint, unitDb.xOffset, unitDb.yOffset)

	SetPortraitTexture(portrait.portrait, "player", true)
	if unitDb.mirror then
		portrait.portrait:SetTexCoord(1, 0, 0, 1)
	else
		portrait.portrait:SetTexCoord(0, 1, 0, 1)
	end

	-- Every unit but the player shows a sample classification
	MUF:ApplyClassification(portrait, unit ~= "player" and GetSampleClassification() or nil)

	-- The player stands in for every unit, like the face
	MUF:ColorPortraitRing(portrait, "player")
	portrait:SetShown(unitDb.enable)
end

local function Update(widget, key)
	local units = {}
	for unit in key:gmatch("[^:]+") do
		units[#units + 1] = unit
	end

	-- Room for the portraits outside the bars
	local count = #units
	local width = Preview.Width(widget, MAX_WIDTH, PORTRAIT_ROOM)
	if count > 1 then
		width = max(min(widget.frame:GetWidth() / 2 - GAP - PORTRAIT_ROOM, MAX_WIDTH), 1)
	end

	for i, sample in ipairs(widget.samples) do
		local unit = units[i]
		if unit then
			local offset = count > 1 and (i == 1 and -1 or 1) * (width / 2 + GAP / 2) or 0
			UpdateSample(sample, unit, width, offset)
		else
			sample.bar:Hide()
		end
	end

	Preview.SetEnabled(widget, E.db.mui.unitframes.portraits.enable)
end

Preview.Register("MERPortraitsPreview", 1, HEIGHT, Build, Update)
