local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_DeathRecap()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.deathRecap ~= true or E.private.mui.skins.blizzard.deathRecap ~= true then return end

	local DeathRecapFrame = _G.DeathRecapFrame
	DeathRecapFrame:Styling()
	MER:CreateBackdropShadow(DeathRecapFrame)
end

module:AddCallbackForAddon("Blizzard_DeathRecap")
