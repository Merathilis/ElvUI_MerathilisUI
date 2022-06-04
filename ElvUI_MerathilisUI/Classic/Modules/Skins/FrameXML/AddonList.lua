local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.addonManager ~= true or not E.private.mui.skins.blizzard.addonManager then return end

	local AddonList = _G.AddonList
	if AddonList.backdrop then
		AddonList.backdrop:Styling()
	end
	MER:CreateBackdropShadow(AddonList)
	_G.AddonCharacterDropDown:SetWidth(170)
end

S:AddCallback("AddonList", LoadSkin)
