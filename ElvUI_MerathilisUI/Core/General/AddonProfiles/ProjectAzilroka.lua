local MER, F, E, L, V, P, G = unpack((select(2, ...)))

local _G = _G

function MER:LoadPAProfile()
	--[[----------------------------------
	--	ProjectAzilroka - Settings
	--]]----------------------------------
	local PA = _G.ProjectAzilroka
	PA.data:SetProfile('MerathilisUI')

	PA.db["AuraReminder"]["Enable"] = false

	PA.db["BrokerLDB"]["Enable"] = false

	PA.db["EnhancedFriendsList"]["Enable"] = false

	PA.db["EnhancedShadows"]["Enable"] = false

	PA.db['DragonOverlay']["Enable"] = false

	PA.db["iFilger"]["Enable"] = false

	PA.db["MouseoverAuras"]["Enable"] = false

	PA.db['MovableFrames']['Enable'] = false

	PA.db["OzCooldowns"]["Enable"] = false

	PA.db['QuestSounds']['Enable'] = false

	PA.db['SquareMinimapButtons']['Enable'] = false

	PA.db["stAddonManager"]["Enable"] = true
	PA.db["stAddonManager"]["NumAddOns"] = 15
	PA.db["stAddonManager"]["ButtonHeight"] = 20
	PA.db["stAddonManager"]["ButtonWidth"] = 20
	PA.db["stAddonManager"]["Font"] = "Expressway"
	PA.db["stAddonManager"]["ClassColor"] = true
	PA.db["stAddonManager"]["CheckTexture"] = "Asphyxia"
end
