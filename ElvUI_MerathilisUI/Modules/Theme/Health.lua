local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Theme") ---@class Theme

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
	local isConnected = UnitIsConnected(unit)
	local isDeadOrGhost = UnitIsDeadOrGhost(unit)
	local isCharmed = UnitIsCharmed(unit)
	local isEnemy = UnitIsEnemy(unit, "player")
	local isPlayerControlled = UnitPlayerControlled(unit)
	local isTapDenied = UnitIsTapDenied(unit)
	local reaction = UnitReaction(unit, "player")

	if isPlayer and not isConnected then
		return "specialColorMap", "DISCONNECTED"
	elseif frame.unitDead == true then
		return "specialColorMap", "DEAD"
	elseif isPlayer and not isDeadOrGhost and isCharmed and isEnemy then
		return "reactionColorMap", "BAD"
	elseif not isPlayerControlled and isTapDenied then
		return "specialColorMap", "TAPPED"
	elseif isPlayer then
		local _, classToken = UnitClass(unit)
		return "classColorMap", classToken or "PRIEST"
	elseif UnitReaction(unit, "player") then
		if reaction > 4 then
			return "reactionColorMap", "GOOD"
		elseif reaction > 3 then
			return "reactionColorMap", "NEUTRAL"
		else
			return "reactionColorMap", "BAD"
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
	local unitDead = unit and UnitIsDeadOrGhost(unit)
	if unitDead ~= frame.unitDead then
		colorChanged = true
		frame.unitDead = unitDead
	end

	local colorFunc = F.Event.GenerateClosure(self.GetHealthColor, self, frame, unit)
	self:SetGradientColors(frame, valueChanged, eR, eG, eB, colorChanged, colorFunc)
end
