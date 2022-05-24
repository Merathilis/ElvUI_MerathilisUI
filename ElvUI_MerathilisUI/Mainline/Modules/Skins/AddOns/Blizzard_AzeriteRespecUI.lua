local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_AzeriteRespecUI()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.azeriteRespec ~= true or E.private.mui.skins.blizzard.AzeriteRespec ~= true then return end

	local AzeriteRespecFrame = _G.AzeriteRespecFrame
	AzeriteRespecFrame:Styling()
	MER:CreateBackdropShadow(AzeriteRespecFrame)
end

module:AddCallbackForAddon("Blizzard_AzeriteRespecUI")
