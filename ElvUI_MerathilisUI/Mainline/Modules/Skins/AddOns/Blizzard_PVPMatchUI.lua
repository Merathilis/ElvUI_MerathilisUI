local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_PVPMatch()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.pvp ~= true or E.private.mui.skins.blizzard.pvp ~= true then return end

	local PVPMatchScoreboard = _G.PVPMatchScoreboard
	if not PVPMatchScoreboard.backdrop then
		PVPMatchScoreboard:CreateBackdrop('Transparent')
		PVPMatchScoreboard.backdrop:Styling()
	end
	MER:CreateBackdropShadow(PVPMatchScoreboard)

	local PVPMatchResults = _G.PVPMatchResults
	if not PVPMatchResults.backdrop then
		PVPMatchResults:CreateBackdrop('Transparent')
		PVPMatchResults.backdrop:Styling()
	end
	MER:CreateBackdropShadow(PVPMatchResults)
end

module:AddCallbackForAddon("Blizzard_PVPMatch")
