local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Preview = module.Preview

-- The talent-change warning ("DONT MOVE" panel), built by the module itself
-- (CreateWarningPanel) and scaled down. Used as `dialogControl` on a
-- description named "loadoutManager".

local HEIGHT = 80
local PANEL_WIDTH = 560
local MAX_SCALE = 0.75

local function Build(widget)
	widget.panel = MER:GetModule("MER_LoadoutManager"):CreateWarningPanel(widget.frame)
	widget.panel:SetPoint("CENTER")
end

local function Update(widget)
	local db = E.private.mui.loadoutManager
	local width = Preview.Width(widget, PANEL_WIDTH * MAX_SCALE, 10)
	widget.panel:SetScale(width / PANEL_WIDTH)

	Preview.SetEnabled(widget, db.enable and db.specWarning)
end

Preview.Register("MERLoadoutManagerPreview", 1, HEIGHT, Build, Update)
