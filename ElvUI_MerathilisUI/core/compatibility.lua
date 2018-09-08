local MER, E, L, V, P, G = unpack(select(2, ...))
local COMP = MER:NewModule("mUICompatibility")

--Cache global variables
local _G = _G
local pairs, print = pairs, print
--WoW API / Variables
local GetAddOnEnableState = GetAddOnEnableState
local IsAddOnLoaded = IsAddOnLoaded

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

function COMP:IsAddOnEnabled(addon) -- Credit: Azilroka
	return GetAddOnEnableState(E.myname, addon) == 2
end

-- Check other addons
COMP.SLE = COMP:IsAddOnEnabled('ElvUI_SLE')
COMP.PA = COMP:IsAddOnEnabled('ProjectAzilroka')
COMP.LP = COMP:IsAddOnEnabled('ElvUI_LocPlus')
COMP.LL = COMP:IsAddOnEnabled('ElvUI_LocLite')
COMP.AS = COMP:IsAddOnEnabled('AddOnSkins')
COMP.BUI = COMP:IsAddOnEnabled("ElvUI_BenikUI")
COMP.CUI = COMP:IsAddOnEnabled("ElvUI_ChaoticUI")

local function Disable(tbl, key)
	key = key or 'enable'
	if (tbl[key]) then
		tbl[key] = false
		return true
	end
	return false
end

--Incompatibility print
function COMP:Print(addon, feature)
	if (E.private.mui.comp and E.private.mui.comp[addon] and E.private.mui.comp[addon][feature]) then
		return
	end

	print(MER.Title..L["has |cffff2020disabled|r "]..feature..L[" from "]..addon..L[" due to incompatiblities."])

	E.private.mui.comp = E.private.mui.comp or {}
	E.private.mui.comp[addon] = E.private.mui.comp[addon] or {}
	E.private.mui.comp[addon][feature] = true
end

-- Print for disable my modules
function COMP:ModulePrint(addon, module)
	if (E.private.mui.comp and E.private.mui.comp[addon] and E.private.mui.comp[addon][module]) then
		return
	end

	print(MER.Title..L["has |cffff2020disabled|r "]..module..L[" due to incompatiblities with: "]..addon)

	E.private.mui.comp = E.private.mui.comp or {}
	E.private.mui.comp[addon] = E.private.mui.comp[addon] or {}
	E.private.mui.comp[addon][module] = true
end

function COMP:BenikUICompatibility()
	local BUI = E:GetModule("BenikUI")

	if (Disable(E.db.benikuiDatabars['experience']) or Disable(E.db.benikuiDatabars['reputation']) or Disable(E.db.benikuiDatabars['azerite']) or Disable(E.db.benikuiDatabars['honor'])) then
		self:Print(BUI.Title, "Databars")
	end

	if (Disable(E.db.benikui['datatexts']['chat'])) then
		self:Print(BUI.Title, "Chat and Middle DataTexts");
	end
end

function COMP:ProjectAzilrokaCompatibility()
	if Disable(_G.ProjectAzilrokaDB, "EFL") then
		self:Print("ProjectAzilroka", "EnhancedFriendsList")
	end
end

function COMP:LocationPlusCompatibility()
	local LP = E:GetModule("LocationPlus")

	if Disable(E.db.mui['locPanel']) then
		self:ModulePrint("ElvUI_LocPlus", "Location Panel")
	end
end

function COMP:LocationLiteCompatibility()
	local LLB = E:GetModule("LocationLite")

	if Disable(E.db.mui['locPanel']) then
		self:ModulePrint("ElvUI_LocLite", "Location Panel")
	end
end

function COMP:SLECompatibility()
	local SLE = ElvUI_SLE[1]

	--Location Panel
	if Disable(E.db.sle["minimap"]["locPanel"]) then
		self:Print(SLE.Title, "Location Panel")
	end

	-- Raid Markers
	if Disable(E.db.sle["raidmarkers"]) then
		self:Print(SLE.Title, "Raid Markers")
	end

	-- Objective Tracker
	if Disable(E.private.sle["skins"]["objectiveTracker"]) then
		self:Print(SLE.Title, "ObjectiveTracker skin")
	end
end

COMP.CompatibilityFunctions = {};

function COMP:RegisterCompatibilityFunction(addonName, compatFunc)
	COMP.CompatibilityFunctions[addonName] = compatFunc
end

COMP:RegisterCompatibilityFunction("BUI", "BenikUICompatibility")
COMP:RegisterCompatibilityFunction("PA", "ProjectAzilrokaCompatibility")
COMP:RegisterCompatibilityFunction("LP", "LocationPlusCompatibility")
COMP:RegisterCompatibilityFunction("LL", "LocationLiteCompatibility")
COMP:RegisterCompatibilityFunction("SLE", "SLECompatibility")

function COMP:RunCompatibilityFunctions()
	for key, compatFunc in pairs(COMP.CompatibilityFunctions) do
		if (COMP[key]) then
			self[compatFunc](self)
		end
	end
end

function COMP:Initialize()
end

hooksecurefunc(E, "CheckIncompatible", function(self)
	COMP:RunCompatibilityFunctions()
end)

MER:RegisterModule(COMP:GetName())