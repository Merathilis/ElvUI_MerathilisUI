local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
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
	MER:CreateBackdropShadow(AddonList)
	_G.AddonCharacterDropDown:SetWidth(170)
end

S:AddCallback("AddonList", LoadSkin)
