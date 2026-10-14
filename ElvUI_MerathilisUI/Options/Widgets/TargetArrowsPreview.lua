local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Preview = module.Preview

-- Sample nameplate health bar with the Target Arrows. Used as `dialogControl`
-- on a description named "nameplates". The arrows come from the module itself,
-- so layout, animation, size, spacing, color and texture match the game.

local MAX_WIDTH = 200
local HEIGHT = 120
-- The slide in only plays once, the preview repeats it now and then
local REPLAY_INTERVAL = 2.5

local function OnUpdate(frame, elapsed)
	frame.elapsed = (frame.elapsed or 0) + elapsed
	if frame.elapsed < REPLAY_INTERVAL then
		return
	end

	frame.elapsed = 0
	local widget = frame.obj
	if E.db.mui.nameplates.targetArrows.animation == "slide" then
		MER:GetModule("MER_Nameplates"):TargetArrows_ReplayPreview(widget.arrows)
	end
end

local function Build(widget)
	widget.frame.obj = widget
	widget.bar = Preview.CreateBar(widget.frame)
	-- Room above the bar for the top arrow
	widget.bar:SetPoint("CENTER", 0, -12)
	widget.arrows = MER:GetModule("MER_Nameplates"):TargetArrows_CreatePreview(widget.bar)
	widget.frame:SetScript("OnUpdate", OnUpdate)
end

local function Update(widget)
	local db = E.db.mui.nameplates.targetArrows
	local width, height = Preview.NameplateSize(MAX_WIDTH)

	Preview.UpdateBar(widget.bar, width, height, 0.7, E.db.nameplates.statusbar, Preview.HostileColor())
	widget.arrows:SetFrameLevel(widget.bar:GetFrameLevel() + 5)
	MER:GetModule("MER_Nameplates"):TargetArrows_UpdatePreview(widget.arrows)
	widget.frame.elapsed = 0

	Preview.SetEnabled(widget, db.enable)
end

Preview.Register("MERTargetArrowsPreview", 1, HEIGHT, Build, Update)
