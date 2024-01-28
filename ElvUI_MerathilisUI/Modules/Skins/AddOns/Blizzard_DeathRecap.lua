local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_DeathRecap()
	if not module:CheckDB("deathRecap", "deathRecap") then
		return
	end

	local DeathRecapFrame = _G.DeathRecapFrame
	module:CreateShadow(DeathRecapFrame)
end

module:AddCallbackForAddon("Blizzard_DeathRecap")
