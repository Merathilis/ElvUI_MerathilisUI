local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_Soulbinds()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.soulbinds) or not E.private.mui.skins.blizzard.soulbinds then return end

	local frame = _G.SoulbindViewer
	frame.Background:Hide()
	frame:Styling()
	MER:CreateBackdropShadow(frame)
end

module:AddCallbackForAddon('Blizzard_Soulbinds')
