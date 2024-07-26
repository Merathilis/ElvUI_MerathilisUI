local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G

function module:Blizzard_PVPMatch()
	if not module:CheckDB("pvp", "pvp") then
		return
	end

	local PVPMatchScoreboard = _G.PVPMatchScoreboard
	module:CreateBackdropShadow(PVPMatchScoreboard)

	local PVPMatchResults = _G.PVPMatchResults
	module:CreateBackdropShadow(PVPMatchResults)
end

module:AddCallbackForAddon("Blizzard_PVPMatch")
