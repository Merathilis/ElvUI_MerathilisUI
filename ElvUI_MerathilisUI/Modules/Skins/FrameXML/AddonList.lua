local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins

local _G = _G

function module:AddonList()
	if not module:CheckDB("addonManager", "addonManager") then
		return
	end

	local AddonList = _G.AddonList
	module:CreateBackdropShadow(AddonList)
	_G.AddonCharacterDropDown:SetWidth(170)
end

module:AddCallback("AddonList")
