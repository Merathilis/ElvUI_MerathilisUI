local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_KeystoneInfo")

local OR = E.Libs.OpenRaid
local KS = E.Libs.Keystone

local select = select

local Ambiguate = Ambiguate
local GetInstanceInfo = GetInstanceInfo
local UnitIsPlayer = UnitIsPlayer
local UnitName = UnitName

module.LibKeystoneInfo = {}
function module.RequestData()
	-- Disable in Delve
	local difficulty = select(3, GetInstanceInfo())
	if difficulty and difficulty == 208 then
		return
	end

	if not OR.RequestKeystoneDataFromRaid() then
		KS.Request("PARTY")
		OR.RequestKeystoneDataFromParty()
	end
end

KS.Register(module, function(keyLevel, keyChallengeMapID, playerRating, sender)
	module.LibKeystoneInfo[sender] = {
		level = keyLevel,
		challengeMapID = keyChallengeMapID,
		rating = playerRating,
	}
end)

function module:UnitData(unit)
	if not unit or not UnitIsPlayer(unit) then
		return
	end

	local data = OR.GetKeystoneInfo(unit)

	-- If Details! library no returns data, try to get it from Bigwigs library
	if not data and self.LibKeystoneInfo then
		local name = UnitName(unit)
		local sender = name and Ambiguate(name, "none")
		data = sender and self.LibKeystoneInfo[sender]
	end

	return data
end

module:RegisterEvent("GROUP_ROSTER_UPDATE", "RequestData")
module:RegisterEvent("CHALLENGE_MODE_COMPLETED", "RequestData")
module:RegisterEvent("CHALLENGE_MODE_START", "RequestData")
module:RegisterEvent("CHALLENGE_MODE_RESET", "RequestData")
F.TaskManager:AfterLogin(module.RequestData)
