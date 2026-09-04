local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Theme") ---@class Theme

local select = select
local UnitClass = UnitClass
local UnitGUID = UnitGUID
local UnitIsCharmed = UnitIsCharmed
local UnitIsConnected = UnitIsConnected
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsEnemy = UnitIsEnemy
local UnitIsPlayer = UnitIsPlayer
local UnitIsTapDenied = UnitIsTapDenied
local UnitPlayerControlled = UnitPlayerControlled
local UnitReaction = UnitReaction
local UnitTreatAsPlayerForDisplay = UnitTreatAsPlayerForDisplay

module.knownUnitClass = module.knownUnitClass or {}
module.knownIsPlayer = module.knownIsPlayer or {}

function module:GetHealthColor(frame, unit)
	local guid = UnitGUID(unit)
	local knownGUID = E:NotSecretValue(guid) and guid or nil

	local unitIsPlayer = UnitIsPlayer(unit)
	local treatAsPlayer = UnitTreatAsPlayerForDisplay(unit)
	local isPlayer = (E:NotSecretValue(unitIsPlayer) and unitIsPlayer)
		or (E:NotSecretValue(treatAsPlayer) and treatAsPlayer)

	if isPlayer then
		if knownGUID then
			self.knownIsPlayer[knownGUID] = true
		end
	elseif knownGUID and self.knownIsPlayer[knownGUID] then
		isPlayer = true
	end

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
		local classToken = select(2, UnitClass(unit))
		if E:NotSecretValue(classToken) and classToken then
			if knownGUID then
				self.knownUnitClass[knownGUID] = classToken
			end
			return "classColorMap", classToken
		elseif knownGUID and self.knownUnitClass[knownGUID] then
			return "classColorMap", self.knownUnitClass[knownGUID]
		end

		return "specialColorMap", "TAPPED"
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

	local guid = UnitGUID(unit)
	local unitChanged = false
	if E:NotSecretValue(guid) and guid ~= frame.lastColorGUID then
		unitChanged = true
		frame.lastColorGUID = guid
		frame.colorMap = nil
		frame.colorEntry = nil
		frame.currentColor = nil
		frame.normalColor = nil
		frame.shiftColor = nil
		frame.normalColorBG = nil
		frame.shiftColorBG = nil
	end

	local valueChanged = frame.currentPercent == nil
	if valueChanged then
		frame.currentPercent = 1
	end

	local colorChanged = unitChanged
	local unitDead = unit and UnitIsDeadOrGhost(unit)
	if unitDead ~= frame.unitDead then
		colorChanged = true
		frame.unitDead = unitDead
	end

	local colorMap, colorEntry = self:GetHealthColor(frame, unit)
	if colorMap ~= frame.colorMap or colorEntry ~= frame.colorEntry then
		colorChanged = true
	end
	self:SetGradientColors(frame, valueChanged, eR, eG, eB, colorChanged, colorMap, colorEntry)
end
