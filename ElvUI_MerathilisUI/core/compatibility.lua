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

-- Check other addons
COMP.SLE = MER:IsAddOnEnabled('ElvUI_SLE')
COMP.PA = MER:IsAddOnEnabled("ProjectAzilroka")
COMP.LP = MER:IsAddOnEnabled("ElvUI_LocPlus")
COMP.LL = MER:IsAddOnEnabled("ElvUI_LocLite")
COMP.AS = MER:IsAddOnEnabled("AddOnSkins")
COMP.BUI = MER:IsAddOnEnabled("ElvUI_BenikUI")
COMP.CUI = MER:IsAddOnEnabled("ElvUI_ChaoticUI")

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

function COMP:ProjectAzilrokaCompatibility()
	if Disable(_G.ProjectAzilrokaDB, "EFL") then
		self:Print("ProjectAzilroka", "EnhancedFriendsList")
	end

	if Disable(_G.ProjectAzilroka.db, "SMB") then
		self:Print("ProjectAzilroka", "SquareMinimapButtons")
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

	-- MinimapButtons
	if Disable(E.private.sle["minimap"]["mapicons"]) then
		self:Print(SLE.Title, "Minimap Buttons")
	end
end

COMP.CompatibilityFunctions = {};

function COMP:RegisterCompatibilityFunction(addonName, compatFunc)
	COMP.CompatibilityFunctions[addonName] = compatFunc
end

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