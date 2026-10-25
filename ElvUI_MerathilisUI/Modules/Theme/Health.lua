local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Theme") ---@class Theme

local select, wipe = select, wipe
local UnitClass = UnitClass
local UnitGUID = UnitGUID
local UnitInPartyIsAI = UnitInPartyIsAI
local UnitIsCharmed = UnitIsCharmed
local UnitIsConnected = UnitIsConnected
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsEnemy = UnitIsEnemy
local UnitIsPlayer = UnitIsPlayer
local UnitIsTapDenied = UnitIsTapDenied
local UnitPlayerControlled = UnitPlayerControlled
local UnitReaction = UnitReaction
local UnitTreatAsPlayerForDisplay = UnitTreatAsPlayerForDisplay

-- Players seen while their unit info was readable, for the moments it turns secret.
-- Capped, a long session in cities or battlegrounds would otherwise keep every GUID.
module.knownUnitClass = module.knownUnitClass or {}
module.knownIsPlayer = module.knownIsPlayer or {}

local CACHE_LIMIT = 500
local cacheSize = 0

local function RememberPlayer(guid, classToken)
	if not module.knownIsPlayer[guid] then
		if cacheSize >= CACHE_LIMIT then
			wipe(module.knownIsPlayer)
			wipe(module.knownUnitClass)
			cacheSize = 0
		end

		module.knownIsPlayer[guid] = true
		cacheSize = cacheSize + 1
	end

	if classToken then
		module.knownUnitClass[guid] = classToken
	end
end

-- Runs on every health tick, so each unit API call is only made when its branch needs it
function module:GetHealthColor(frame, unit)
	local guid = UnitGUID(unit)
	local knownGUID = E:NotSecretValue(guid) and guid or nil

	local isPlayer = UnitIsPlayer(unit)
	isPlayer = E:NotSecretValue(isPlayer) and isPlayer

	if not isPlayer then
		local treatAsPlayer = UnitTreatAsPlayerForDisplay(unit)
		isPlayer = E:NotSecretValue(treatAsPlayer) and treatAsPlayer
	end

	-- Follower dungeon NPCs are neither players nor always treated as such for display
	if not isPlayer and UnitInPartyIsAI then
		local partyAI = UnitInPartyIsAI(unit)
		isPlayer = E:NotSecretValue(partyAI) and partyAI
	end

	if isPlayer then
		if knownGUID then
			RememberPlayer(knownGUID)
		end
	elseif knownGUID and self.knownIsPlayer[knownGUID] then
		isPlayer = true
	end

	if isPlayer then
		local isConnected = UnitIsConnected(unit)
		if E:NotSecretValue(isConnected) and not isConnected then
			return "specialColorMap", "DISCONNECTED"
		end
	end

	-- frame.unitDead is set from UnitIsDeadOrGhost right before this is called
	if frame.unitDead == true then
		return "specialColorMap", "DEAD"
	end

	if isPlayer then
		local isCharmed = UnitIsCharmed(unit)
		if E:NotSecretValue(isCharmed) and isCharmed then
			local isEnemy = UnitIsEnemy("player", unit)
			if E:NotSecretValue(isEnemy) and isEnemy then
				return "reactionColorMap", "BAD"
			end
		end
	else
		-- Players and follower NPCs are never tap denied
		local playerControlled = UnitPlayerControlled(unit)
		if E:NotSecretValue(playerControlled) and not playerControlled then
			local tapDenied = UnitIsTapDenied(unit)
			if E:NotSecretValue(tapDenied) and tapDenied then
				return "specialColorMap", "TAPPED"
			end
		end
	end

	if isPlayer then
		local classToken = select(2, UnitClass(unit))
		if E:NotSecretValue(classToken) and classToken then
			if knownGUID then
				RememberPlayer(knownGUID, classToken)
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
		-- Reset in place, the color object itself is kept for the next unit
		frame.resetCurrentColor = true
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
	unitDead = E:NotSecretValue(unitDead) and unitDead
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
