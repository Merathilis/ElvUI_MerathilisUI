local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Preview = module.Preview

local min = math.min
local CreateFrame = CreateFrame

-- The Loot Roll bars with the test items of the module (uncommon to legendary).
-- Used as `dialogControl` on a description named "lootRoll". The bars come
-- from the module itself (CreateBar, LayoutBar and the test fill), stacked in
-- the grow direction up to Max Bars. The preview grows with the stack.

local PADDING = 8
local MIN_HEIGHT = 60

local function GetLootRoll()
	return MER:GetModule("MER_LootRoll")
end

local function Build(widget)
	widget.holder = CreateFrame("Frame", nil, widget.frame)
	widget.bars = GetLootRoll():CreatePreviewBars(widget.holder)
end

local function Update(widget)
	local db = E.db.mui.lootRoll
	local bars = widget.bars
	local count = min(db.maxBars, #bars)

	local height = count * db.height + (count - 1) * db.spacing
	widget.frame:SetHeight(height + PADDING * 2)

	-- Same point on the holder as on the mover: top when growing down, bottom when growing up
	local holder = widget.holder
	holder:SetSize(db.width, height)
	holder:ClearAllPoints()
	holder:SetPoint("CENTER", widget.frame, "CENTER")
	holder:SetFrameLevel(widget.frame:GetFrameLevel() + 1)

	GetLootRoll():UpdatePreviewBars(bars)

	local up = db.growDirection == "UP"
	local last
	-- The bars are made for the HIGH strata, here they belong to the options window
	local strata, level = widget.frame:GetFrameStrata(), holder:GetFrameLevel() + 1
	for index, bar in ipairs(bars) do
		bar:SetFrameStrata(strata)
		bar:SetFrameLevel(level)
		bar:SetShown(index <= count)
		bar:ClearAllPoints()
		if not last then
			bar:SetPoint(up and "BOTTOM" or "TOP", holder, up and "BOTTOM" or "TOP")
		elseif up then
			bar:SetPoint("BOTTOM", last, "TOP", 0, db.spacing)
		else
			bar:SetPoint("TOP", last, "BOTTOM", 0, -db.spacing)
		end
		last = bar
	end

	Preview.SetEnabled(widget, db.enable)
end

Preview.Register("MERLootRollPreview", 1, MIN_HEIGHT, Build, Update)
