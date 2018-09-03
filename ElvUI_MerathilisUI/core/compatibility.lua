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

local function Disable(tbl)
	tbl['enable'] = false
end

--Incompatibility print
function COMP:Print(addon, feature)
	if (E.private.mui.comp and E.private.mui.comp[addon] and E.private.mui.comp[addon][feature]) then
		return
	end
	print(MER.Title.."has |cffff2020disabled|r "..feature.." from "..addon.." due to incompatiblities.")
	E.private.mui.comp = E.private.mui.comp or {}
	E.private.mui.comp[addon] = E.private.mui.comp[addon] or {}
	E.private.mui.comp[addon][feature] = true
end

function COMP:BenikUICompatibility()
	local BUI = E:GetModule("BenikUI")

	E.db.benikui['general']['benikuiStyle'] = false
	self:Print(BUI.Title, "BenikUI Style")

	Disable(E.db.benikuiDatabars['experience'])
	Disable(E.db.benikuiDatabars['reputation'])
	Disable(E.db.benikuiDatabars['azerite'])
	Disable(E.db.benikuiDatabars['honor'])

	self:Print(BUI.Title, "Databars")

	Disable(E.db.benikui['datatexts']['chat'])
	Disable(E.db.benikui['datatexts']['middle'])
	self:Print(BUI.Title, "Chat and Middle DataTexts")

	for i = 1, 10 do
		E.db.benikui['actionbars']['style']['bar'..i] = false
	end

	E.db.benikui['actionbars']['style']['petbar'] = false
	E.db.benikui['actionbars']['style']['stancebar'] = false
	self:Print(BUI.Title, "Actionbar Styles")
end

function COMP:ProjectAzilrokaCompatibility()
	if (COMP.PA and _G.ProjectAzilroka.db.EFL == true) then
		_G.ProjectAzilroka.db.EFL = false
		self:Print("ProjectAzilroka", "EnhancedFriendsList")
	end
end

COMP.CompatibilityFunctions = {};

function COMP:RegisterCompatibilityFunction(addonName, compatFunc)
	COMP.CompatibilityFunctions[addonName] = compatFunc
end

COMP:RegisterCompatibilityFunction("ElvUI_BenikUI", "BenikUICompatibility")
COMP:RegisterCompatibilityFunction("ProjectAzilroka", "ProjectAzilrokaCompatibility")

function COMP:RunCompatibilityFunctions()
	for addonName, compatFunc in pairs(COMP.CompatibilityFunctions) do
		if (IsAddOnLoaded(addonName)) then
			self[compatFunc](self)
		end
	end
end

function COMP:Initialize()
end

local ECheckIncompatible = E.CheckIncompatible
E.CheckIncompatible = function(self)
	COMP:RunCompatibilityFunctions()
	ECheckIncompatible(E)
end

MER:RegisterModule(COMP:GetName())