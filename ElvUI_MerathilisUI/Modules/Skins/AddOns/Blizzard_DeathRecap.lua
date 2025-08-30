local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G

function module:Blizzard_DeathRecap()
	if not module:CheckDB("deathRecap", "deathRecap") then
		return
	end

	local DeathRecapFrame = _G.DeathRecapFrame
	module:CreateShadow(DeathRecapFrame)
end

module:AddCallbackForAddon("Blizzard_DeathRecap")
