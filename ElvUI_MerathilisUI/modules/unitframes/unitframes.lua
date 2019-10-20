local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:NewModule("muiUnits", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
local UF = E:GetModule("UnitFrames")

--Cache global variables
--Lua functions
--WoW API / Variables
local IsAddOnLoaded = IsAddOnLoaded

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: UF

function module:UpdateUF()
	if E.db.unitframe.units.player.enable then
		module:ArrangePlayer()
	end

	if E.db.unitframe.units.target.enable then
		module:ArrangeTarget()
	end

	if E.db.unitframe.units.party.enable then
		UF:CreateAndUpdateHeaderGroup("party")
	end
end

function module:ADDON_LOADED(event, addon)
	if addon ~= "ElvUI_Config" then return end

	module:UnregisterEvent(event)
end

function module:Initialize()
	if E.private.unitframe.enable ~= true then return end

	local db = E.db.mui.unitframes
	MER:RegisterDB(self, "unitframes")

	self:InitPlayer()
	self:InitTarget()
	self:InitPet()

	-- self:InitParty()
	-- self:InitRaid()
	-- self:InitRaid40()

	self:InfoPanelColor()

	-- RaidIcons
	hooksecurefunc(UF, "Configure_RaidIcon", module.Configure_RaidIcon)

	self:RegisterEvent("ADDON_LOADED")
end

MER:RegisterModule(module:GetName())
