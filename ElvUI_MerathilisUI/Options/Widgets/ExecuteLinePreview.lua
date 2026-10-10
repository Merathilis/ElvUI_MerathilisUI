local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Preview = module.Preview

local LSM = E.LSM or E.Libs.LSM

local CreateFrame = CreateFrame

-- Sample health bar with the Execute Line. Used as `dialogControl` on a
-- description whose name is the settings key ("unitframes" or "nameplates").
-- The line is built by MER.ConfigureExecuteLine itself on a stand-in for the
-- oUF frame, so zone, glow, notches and pulse match the game.

local MAX_WIDTH = 300
local HEIGHT = 60
local HEALTH = 0.6

local function ReturnTrue()
	return true
end

local function Build(widget)
	-- The backdrop is the parent, so the bar draws above it
	local holder = CreateFrame("Frame", nil, widget.frame, "BackdropTemplate")
	holder:SetPoint("CENTER")
	holder:SetTemplate("Transparent")
	widget.holder = holder

	local health = CreateFrame("StatusBar", nil, holder)
	health:SetAllPoints()
	health:SetMinMaxValues(0, 1)
	health:SetValue(HEALTH)
	health:SetOrientation("HORIZONTAL")

	-- Only what MER.ConfigureExecuteLine asks of an oUF frame
	widget.owner = {
		Health = health,
		IsElementEnabled = ReturnTrue,
	}
end

local function Update(widget, key)
	local db = E.db.mui[key] and E.db.mui[key].executeLine
	if not db or not MER.ConfigureExecuteLine then
		return
	end

	local width, height, statusbar
	if key == "nameplates" then
		width, height = Preview.NameplateSize(MAX_WIDTH)
		statusbar = E.db.nameplates.statusbar
	else
		width, height = Preview.UnitFrameSize("target", MAX_WIDTH)
		statusbar = E.db.unitframe.statusbar
	end

	widget.holder:SetSize(width, height)
	local health = widget.owner.Health
	health:SetStatusBarTexture(LSM:Fetch("statusbar", statusbar))
	health:SetStatusBarColor(Preview.HostileColor())

	MER.ConfigureExecuteLine(widget.owner, db, true)
	widget.owner.MER_ExecuteLine:Show()

	Preview.SetEnabled(widget, db.enable)
end

Preview.Register("MERExecuteLinePreview", 1, HEIGHT, Build, Update)
