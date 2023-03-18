local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("pvp", "pvp") then
		return
	end

	local PVPMatchScoreboard = _G.PVPMatchScoreboard
	if not PVPMatchScoreboard.backdrop then
		PVPMatchScoreboard:CreateBackdrop('Transparent')
		PVPMatchScoreboard.backdrop:Styling()
	end
	module:CreateBackdropShadow(PVPMatchScoreboard)

	local PVPMatchResults = _G.PVPMatchResults
	if not PVPMatchResults.backdrop then
		PVPMatchResults:CreateBackdrop('Transparent')
		PVPMatchResults.backdrop:Styling()
	end
	module:CreateBackdropShadow(PVPMatchResults)
end

S:AddCallbackForAddon("Blizzard_PVPMatch", LoadSkin)
