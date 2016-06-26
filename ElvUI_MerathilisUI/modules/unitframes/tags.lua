local E, L, V, P, G = unpack(ElvUI)
local MER = E:GetModule('MerathilisUI')
local ElvUF = ElvUI.oUF

-- Cache global variables
-- WoW API / Variables
local DEAD = DEAD
local GetNumGroupMembers = GetNumGroupMembers
local IsInGroup, IsInRaid = IsInGroup, IsInRaid
local UnitClass = UnitClass
local UnitIsDead, UnitIsGhost, UnitIsConnected, UnitIsUnit = UnitIsDead, UnitIsGhost, UnitIsConnected, UnitIsUnit
local UnitHealth, UnitHealthMax = UnitHealth, UnitHealthMax

-- GLOBALS: Hex, _COLORS

ElvUF.Tags.Events["health:percent_short"] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED'
ElvUF.Tags.Methods["health:percent_short"] = function(unit)
	local status = UnitIsDead(unit) and DEAD or UnitIsGhost(unit) and L["Ghost"] or not UnitIsConnected(unit) and L["Offline"]

	if (status) then
		return status
	else
		return MER:GetFormattedText('PERCENT_SHORT', UnitHealth(unit), UnitHealthMax(unit))
	end
end

ElvUF.Tags.Methods["classcolor:player"] = function()
	local _, unitClass = UnitClass("player")
	local String

	if unitClass then
		String = Hex(_COLORS.class[unitClass])
	else
		String = "|cFFC2C2C2"
	end

	return String
end

ElvUF.Tags.Methods["classcolor:hunter"] = function()
	return Hex(_COLORS.class["HUNTER"])
end

ElvUF.Tags.Methods["classcolor:warrior"] = function()
	return Hex(_COLORS.class["WARRIOR"])
end

ElvUF.Tags.Methods["classcolor:paladin"] = function()
	return Hex(_COLORS.class["PALADIN"])
end

ElvUF.Tags.Methods["classcolor:mage"] = function()
	return Hex(_COLORS.class["MAGE"])
end

ElvUF.Tags.Methods["classcolor:priest"] = function()
	return Hex(_COLORS.class["PRIEST"])
end

ElvUF.Tags.Methods["classcolor:warlock"] = function()
	return Hex(_COLORS.class["WARLOCK"])
end

ElvUF.Tags.Methods["classcolor:shaman"] = function()
	return Hex(_COLORS.class["SHAMAN"])
end

ElvUF.Tags.Methods["classcolor:deathknight"] = function()
	return Hex(_COLORS.class["DEATHKNIGHT"])
end

ElvUF.Tags.Methods["classcolor:druid"] = function()
	return Hex(_COLORS.class["DRUID"])
end

ElvUF.Tags.Methods["classcolor:monk"] = function()
	return Hex(_COLORS.class["MONK"])
end

ElvUF.Tags.Methods["classcolor:rogue"] = function()
	return Hex(_COLORS.class["ROGUE"])
end
