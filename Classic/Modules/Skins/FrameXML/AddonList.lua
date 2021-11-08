local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.addonManager ~= true or E.private.muiSkins.blizzard.addonManager ~= true then return end

	local AddonList = _G.AddonList
	AddonList.backdrop:Styling()
	MER:CreateBackdropShadow(AddonList)
	_G.AddonCharacterDropDown:SetWidth(170)
end

S:AddCallback("mUIAddonManager", LoadSkin)
