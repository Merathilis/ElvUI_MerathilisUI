local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Filter')

local ConsoleExec = ConsoleExec
local GetCVar = GetCVar
local C_BattleNet = C_BattleNet
local C_BattleNet_GetFriendGameAccountInfo = C_BattleNet.GetFriendGameAccountInfo

do
	local updated = false
	function module:UpdateAPI()
		if updated then
			return
		end

		-- Solution from https://nga.178.com/read.php?tid=27432996
		function C_BattleNet.GetFriendGameAccountInfo(...)
			local gameAccountInfo = C_BattleNet_GetFriendGameAccountInfo(...)
			gameAccountInfo.isInCurrentRegion = true
			return gameAccountInfo
		end

		updated = true
	end
end

function module:LOADING_SCREEN_DISABLED()
	if GetCVar("portal") == "CN" and GetCVar("profanityFilter") == "1" then
		ConsoleExec("portal TW")
		ConsoleExec("profanityFilter 0")
	end

	self:UpdateAPI()
end

function module:Initialize()
	if not E.db.mui.blizzard.filter.enable then
		return
	end

	self.db = E.db.mui.blizzard.filter

	if self.db.unblockProfanityFilter then
		self:RegisterEvent("LOADING_SCREEN_DISABLED")
	end
end

function module:ProfileUpdate()
	self.db =  E.db.mui.blizzard.filter

	if self.db.unblockProfanityFilter then
		self:RegisterEvent("LOADING_SCREEN_DISABLED")
	else
		self:UnregisterEvent("LOADING_SCREEN_DISABLED")
	end
end

MER:RegisterModule(module:GetName())