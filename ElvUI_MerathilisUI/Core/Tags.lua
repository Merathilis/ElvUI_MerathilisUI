local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local ElvUF = E.oUF
assert(ElvUF, "ElvUI was unable to locate oUF.")

local tonumber = tonumber
local len = string.len

local UnitClass = UnitClass
local UnitName = UnitName
local UnitInPartyIsAI = UnitInPartyIsAI
local UnitIsPlayer = UnitIsPlayer
local UnitReaction = UnitReaction

E:AddTag("name:MER:gradient", "UNIT_NAME_UPDATE", function(unit, _, args)
	local name = UnitName(unit)
	if not name then
		return
	end

	if not args then
		args = 16
	end

	args = tonumber(args)
	local isTarget
	if not F.CheckInstanceSecret() then
		isTarget = UnitIsUnit(unit, "target") and not unit:match("nameplate") and not unit:match("party")
		if len(name) > tonumber(args) then
			name = F.String.ShortenString(name, tonumber(args))
		end
		if len(name) > tonumber(args) then
			name = E:ShortenString(name, tonumber(args))
		end
	else
		isTarget = false
	end
	if UnitIsPlayer(unit) or UnitInPartyIsAI(unit) then
		local _, unitClass = UnitClass(unit)
		if not unitClass then
			return
		end
		return F.GradientName(name, unitClass, isTarget, true)
	elseif not UnitIsPlayer(unit) then
		local reaction = UnitReaction(unit, "player")
		if reaction then
			if reaction >= 5 then
				return F.GradientName(name, "NPCFRIENDLY", isTarget, true)
			elseif reaction == 4 then
				return F.GradientName(name, "NPCNEUTRAL", isTarget, true)
			elseif reaction == 3 then
				return F.GradientName(name, "NPCUNFRIENDLY", isTarget, true)
			elseif reaction == 2 or reaction == 1 then
				return F.GradientName(name, "NPCHOSTILE", isTarget, true)
			end
		end
	end
end)
E:AddTagInfo("name:MER:gradient", MER.Title, "Displays a shorten name in gradient classcolor")
