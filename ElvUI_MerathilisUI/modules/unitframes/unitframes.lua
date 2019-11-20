local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:NewModule("muiUnits", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
local UF = E:GetModule("UnitFrames")

--Cache global variables
--Lua functions
--WoW API / Variables
local hooksecurefunc = hooksecurefunc
-- GLOBALS:

function module:ADDON_LOADED(event, addon)
	if addon ~= "ElvUI_Config" then return end

	module:UnregisterEvent(event)
end

function module:Initialize()
	if E.private.unitframe.enable ~= true then return end

	local db = E.db.mui.unitframes
	MER:RegisterDB(self, "unitframes")

	-- Player
	self.InitPlayer()

	-- Auras
	self:LoadAuras()

	-- RaidIcons
	hooksecurefunc(UF, "Configure_RaidIcon", module.Configure_RaidIcon)

	-- Health Prediction
	self:HealPrediction()

	self:RegisterEvent("ADDON_LOADED")
end

MER:RegisterModule(module:GetName())
