local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G

function module:AddonList()
	if not module:CheckDB("addonManager", "addonManager") then
		return
	end

	local AddonList = _G.AddonList
	module:CreateBackdropShadow(AddonList)
end

module:AddCallback("AddonList")
