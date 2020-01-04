local MER, E, L, V, P, G = unpack(select(2, ...))

--Cache global variables
--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

function MER:LoadPAProfile()
	--[[----------------------------------
	--	ProjectAzilroka - Settings
	--]]----------------------------------
	local PA = _G.ProjectAzilroka
	PA.data:SetProfile('MerathilisUI')

	PA.db["EnhancedFriendsList"]["InfoFontSize"] = 10
	PA.db["EnhancedFriendsList"]["App"] = "Animated"
	PA.db["EnhancedFriendsList"]["StatusIconPack"] = "Square"
	PA.db["EnhancedFriendsList"]["NameFontSize"] = 11
	PA.db["EnhancedFriendsList"]["NameFont"] = "Merathilis Expressway"
	PA.db["EnhancedFriendsList"]["InfoFont"] = "Merathilis Expressway"

	PA.db['DragonOverlay']['Enable'] = false

	PA.db['MovableFrames']['Enable'] = false

	PA.db['SquareMinimapButtons']['Enable'] = false

	PA.db["stAddonManager"]["NumAddOns"] = 15
	PA.db["stAddonManager"]["ButtonHeight"] = 20
	PA.db["stAddonManager"]["ButtonWidth"] = 20
	PA.db["stAddonManager"]["Font"] = "Merathilis Expressway"
	PA.db["stAddonManager"]["ClassColor"] = true
	PA.db["stAddonManager"]["CheckTexture"] = "Melli"

	PA.db["OzCooldowns"]["BuffTimer"] = false
end
