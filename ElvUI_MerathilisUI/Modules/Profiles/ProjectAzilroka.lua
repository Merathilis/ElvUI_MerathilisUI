local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles")

local _G = _G

function module:LoadPAProfile()
	--[[----------------------------------
	--	ProjectAzilroka - Settings
	--]]
	----------------------------------
	local PA = _G.ProjectAzilroka
	PA.data:SetProfile("MerathilisUI")

	PA.db["AuraReminder"]["Enable"] = false

	PA.db["BrokerLDB"]["Enable"] = false

	PA.db["EnhancedFriendsList"]["Enable"] = false

	PA.db["EnhancedShadows"]["Enable"] = false

	PA.db["DragonOverlay"]["Enable"] = false

	PA.db["iFilger"]["Enable"] = false

	PA.db["MouseoverAuras"]["Enable"] = false

	PA.db["MovableFrames"]["Enable"] = false

	PA.db["OzCooldowns"]["Enable"] = false

	PA.db["QuestSounds"]["Enable"] = false

	PA.db["SquareMinimapButtons"]["Enable"] = false

	PA.db["stAddonManager"]["Enable"] = false
end
