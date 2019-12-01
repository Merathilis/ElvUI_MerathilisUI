local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:NewModule("SpellAlerts", "AceEvent-3.0")
module.modName = L["SpellAlerts"]

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API / Variables
local GetCVar = GetCVar
-- Global variables that we don"t cache, list them here for the mikk"s Find Globals script
-- GLOBALS:

function module:UpdatePosition()
	-- Spell Alert frame
	_G["SpellActivationOverlayFrame"]:SetScale(0.65)

	_G["SpellActivationOverlayFrame"]:SetFrameStrata("MEDIUM")
	_G["SpellActivationOverlayFrame"]:SetFrameLevel(1)
end

function module:UpdateAppearance()
	_G["SpellActivationOverlayFrame"]:SetAlpha(GetCVar("spellActivationOverlayOpacity"))
end

function module:PLAYER_LOGIN()
	module:UpdatePosition()
	module:UpdateAppearance()
end

function module:Initialize()
	self:RegisterEvent("PLAYER_LOGIN")
end

MER:RegisterModule(module:GetName())
