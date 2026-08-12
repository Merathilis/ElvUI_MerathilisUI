local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Theme") ---@class Theme

local select = select
local UnitClass = UnitClass
local UnitIsCharmed = UnitIsCharmed
local UnitIsConnected = UnitIsConnected
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsEnemy = UnitIsEnemy
local UnitIsPlayer = UnitIsPlayer
local UnitIsTapDenied = UnitIsTapDenied
local UnitPlayerControlled = UnitPlayerControlled
local UnitReaction = UnitReaction
local UnitTreatAsPlayerForDisplay = UnitTreatAsPlayerForDisplay

function module:GetHealthColor(frame, unit)
	if not unit then
		return
	end

	local isPlayer = UnitIsPlayer(unit) or UnitTreatAsPlayerForDisplay(unit)

	if isPlayer and not UnitIsConnected(unit) then
		return "specialColorMap", "DISCONNECTED"
	elseif frame.unitDead then
		return "specialColorMap", "DEAD"
	elseif
		isPlayer
		and not E:IsSecretValue(UnitIsDeadOrGhost(unit))
		and E:IsSecretValue(UnitIsCharmed(unit))
		and E:IsSecretValue(UnitIsEnemy("player", unit))
	then
		return "reactionColorMap", "BAD"
	elseif not UnitPlayerControlled(unit) and UnitIsTapDenied(unit) then
		return "specialColorMap", "TAPPED"
	elseif isPlayer then
		return "classColorMap", select(2, UnitClass(unit))
	else
		local reaction = UnitReaction(unit, "player")
		if reaction then
			if reaction > 4 then
				return "reactionColorMap", "GOOD"
			elseif reaction > 3 then
				return "reactionColorMap", "NEUTRAL"
			else
				return "reactionColorMap", "BAD"
			end
		end
	end
end

function module:PostUpdateHealthColor(frame, unit, eR, eG, eB)
	if not self.isEnabled or not self.db or not self.db.enable then
		return
	end
	if not unit then
		return
	end

	local valueChanged = frame.currentPercent == nil
	if valueChanged then
		frame.currentPercent = 1
	end

	local colorChanged = false
	local unitDead = UnitIsDeadOrGhost(unit)
	if unitDead ~= frame.unitDead then
		colorChanged = true
		frame.unitDead = unitDead
	end

	-- Closure only allocated when SetGradientColors actually needs the getter
	self:SetGradientColors(frame, valueChanged, eR, eG, eB, colorChanged, function()
		return module:GetHealthColor(frame, unit)
	end)
end
