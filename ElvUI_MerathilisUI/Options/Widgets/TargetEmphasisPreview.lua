local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Preview = module.Preview

local min = math.min

-- Three sample nameplate health bars with the Target Emphasis. Used as
-- `dialogControl` on a description named "nameplates". The target moves on to
-- the next bar now and then, so the fade and the pop play like in the game.
-- Shade, alpha, pop and ElvUI's border glow come from the module itself.

local MAX_WIDTH = 140
local SPACING = 16
local HEIGHT = 70
local NUM_BARS = 3
local SWITCH_INTERVAL = 2.5
local HEALTH = { 0.85, 0.6, 0.35 }

local function Apply(widget, animate)
	local MNP = MER:GetModule("MER_Nameplates")
	for index, bar in ipairs(widget.bars) do
		MNP:TargetEmphasis_UpdatePreview(bar, bar.emphasis, index == widget.target, true, animate)
		MNP:TargetGlow_UpdatePreview(bar.glow, bar, index == widget.target)
	end
end

local function OnUpdate(frame, elapsed)
	frame.elapsed = (frame.elapsed or 0) + elapsed
	if frame.elapsed < SWITCH_INTERVAL then
		return
	end

	frame.elapsed = 0
	local widget = frame.obj
	widget.target = widget.target % NUM_BARS + 1
	Apply(widget, true)
end

local function Build(widget)
	local MNP = MER:GetModule("MER_Nameplates")

	widget.frame.obj = widget
	widget.target = 2
	widget.bars = {}
	for index = 1, NUM_BARS do
		local bar = Preview.CreateBar(widget.frame)
		bar.emphasis = MNP:TargetEmphasis_CreatePreview(bar)
		bar.glow = MNP:TargetGlow_CreatePreview(bar)
		widget.bars[index] = bar
	end

	widget.frame:SetScript("OnUpdate", OnUpdate)
end

local function Update(widget)
	local db = E.db.mui.nameplates.targetEmphasis
	local width, height = Preview.NameplateSize(MAX_WIDTH)
	width = min(width, (Preview.Width(widget, MAX_WIDTH * NUM_BARS) - SPACING * (NUM_BARS - 1)) / NUM_BARS)

	local total = width * NUM_BARS + SPACING * (NUM_BARS - 1)
	for index, bar in ipairs(widget.bars) do
		Preview.UpdateBar(bar, width, height, HEALTH[index], E.db.nameplates.statusbar, Preview.HostileColor())
		bar:ClearAllPoints()
		bar:SetPoint("LEFT", widget.frame, "CENTER", -total / 2 + (index - 1) * (width + SPACING), 0)
	end

	Apply(widget, false)
	widget.frame.elapsed = 0

	Preview.SetEnabled(widget, db.enable)
end

Preview.Register("MERTargetEmphasisPreview", 1, HEIGHT, Build, Update)
