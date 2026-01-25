local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local ElvUF = E.oUF
assert(ElvUF, "ElvUI was unable to locate oUF.")

local _G = _G
local len = string.len

local UnitClass = UnitClass
local UnitName = UnitName
local UnitInPartyIsAI = UnitInPartyIsAI
local UnitIsPlayer = UnitIsPlayer
local UnitIsUnit = UnitIsUnit
local UnitReaction = UnitReaction

E:AddTag("name:gradient", "UNIT_NAME_UPDATE", function(unit)
	local name = UnitName(unit)
	local _, unitClass = UnitClass(unit)
	local isTarget = UnitIsUnit(unit, "target") and not unit:match("nameplate") and not unit:match("party")
	if name and len(name) > 10 then
		name = name:gsub("(%S+) ", function(t)
			return t:utf8sub(1, 1) .. ". "
		end)
	end

	if UnitIsPlayer(unit) or UnitInPartyIsAI(unit) then
		return F.GradientName(name, unitClass, isTarget)
	elseif not UnitIsPlayer(unit) then
		local reaction = UnitReaction(unit, "player")
		if reaction then
			if reaction >= 5 then
				return F.GradientName(name, "NPCFRIENDLY", isTarget)
			elseif reaction == 4 then
				return F.GradientName(name, "NPCNEUTRAL", isTarget)
			elseif reaction == 3 then
				return F.GradientName(name, "NPCUNFRIENDLY", isTarget)
			elseif reaction == 2 or reaction == 1 then
				return F.GradientName(name, "NPCHOSTILE", isTarget)
			end
		end
	end
end)
E:AddTagInfo("name:gradient", MER.Title, "Displays a shorten name in gradient classcolor")
