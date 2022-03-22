local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.deathRecap ~= true or E.private.muiSkins.blizzard.deathRecap ~= true then return end

	local DeathRecapFrame = _G.DeathRecapFrame
	DeathRecapFrame:Styling()
	MER:CreateBackdropShadow(DeathRecapFrame)
end

S:AddCallbackForAddon("Blizzard_DeathRecap", "muiDeathRecap", LoadSkin)
