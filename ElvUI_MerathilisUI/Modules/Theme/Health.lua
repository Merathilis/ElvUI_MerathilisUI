local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Theme") ---@class Theme

local UnitClassFromGUID = UnitClassFromGUID
local UnitIsCharmed = UnitIsCharmed
local UnitIsConnected = UnitIsConnected
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsEnemy = UnitIsEnemy
local UnitIsPlayer = UnitIsPlayer
local UnitIsTapDenied = UnitIsTapDenied
local UnitGUID = UnitGUID
local UnitPlayerControlled = UnitPlayerControlled
local UnitReaction = UnitReaction
local UnitTreatAsPlayerForDisplay = UnitTreatAsPlayerForDisplay

function module:GetHealthColor(frame, unit)
	local unitIsPlayer = UnitIsPlayer(unit)
	local treatAsPlayer = UnitTreatAsPlayerForDisplay(unit)
	local isPlayer = (E:NotSecretValue(unitIsPlayer) and unitIsPlayer)
		or (E:NotSecretValue(treatAsPlayer) and treatAsPlayer)

	local isConnected = UnitIsConnected(unit)
	local isDeadOrGhost = UnitIsDeadOrGhost(unit)
	local isCharmed = UnitIsCharmed(unit)
	local isEnemy = UnitIsEnemy("player", unit)
	local playerControlled = UnitPlayerControlled(unit)
	local tapDenied = UnitIsTapDenied(unit)

	if isPlayer and E:NotSecretValue(isConnected) and not isConnected then
		return "specialColorMap", "DISCONNECTED"
	elseif frame.unitDead == true then
		return "specialColorMap", "DEAD"
	elseif
		isPlayer
		and E:NotSecretValue(isDeadOrGhost)
		and not isDeadOrGhost
		and E:NotSecretValue(isCharmed)
		and isCharmed
		and E:NotSecretValue(isEnemy)
		and isEnemy
	then
		return "reactionColorMap", "BAD"
	elseif
		E:NotSecretValue(playerControlled)
		and not playerControlled
		and E:NotSecretValue(tapDenied)
		and tapDenied
	then
		return "specialColorMap", "TAPPED"
	elseif isPlayer then
		local unitGUID = UnitGUID(unit)
		if E:NotSecretValue(unitGUID) then
			local classToken = select(2, UnitClassFromGUID(unitGUID))
			if E:NotSecretValue(classToken) and classToken then
				return "classColorMap", classToken
			end
		end
	end

	local reaction = UnitReaction(unit, "player")
	if E:NotSecretValue(reaction) and reaction then
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

	-- Health values are secret in Midnight, use fixed percentage
	local valueChanged = frame.currentPercent == nil
	if valueChanged then
		frame.currentPercent = 1
	end

	local colorChanged = false
	local unitDead = unit and UnitIsDeadOrGhost(unit)
	if E:NotSecretValue(unitDead) and unitDead ~= frame.unitDead then
		colorChanged = true
		frame.unitDead = unitDead
	end

	local colorMap, colorEntry = self:GetHealthColor(frame, unit)
	self:SetGradientColors(frame, valueChanged, eR, eG, eB, true, colorMap, colorEntry)
end
