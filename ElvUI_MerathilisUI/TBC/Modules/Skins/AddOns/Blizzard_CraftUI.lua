local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_CraftUI()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.craft) or not E.private.mui.skins.blizzard.craft then return end

	local CraftFrame = _G.CraftFrame
	if CraftFrame.backdrop then
		CraftFrame.backdrop:Styling()
	end
	MER:CreateBackdropShadow(CraftFrame)
end

module:AddCallbackForAddon("Blizzard_CraftUI")
