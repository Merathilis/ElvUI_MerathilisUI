local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("addonManager", "addonManager") then
		return
	end

	local AddonList = _G.AddonList
	if AddonList.backdrop then
		AddonList.backdrop:Styling()
	end
	module:CreateBackdropShadow(AddonList)
	_G.AddonCharacterDropDown:SetWidth(170)
end

S:AddCallback("AddonList", LoadSkin)
