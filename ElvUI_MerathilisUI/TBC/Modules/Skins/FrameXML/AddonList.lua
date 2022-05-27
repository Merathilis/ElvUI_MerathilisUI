local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G

function module:AddonList()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.addonManager ~= true or not E.private.mui.skins.blizzard.addonManager then return end

	local AddonList = _G.AddonList
	if AddonList.backdrop then
		AddonList.backdrop:Styling()
	end
	MER:CreateBackdropShadow(AddonList)
	_G.AddonCharacterDropDown:SetWidth(170)
end

module:AddCallback("AddonList")
