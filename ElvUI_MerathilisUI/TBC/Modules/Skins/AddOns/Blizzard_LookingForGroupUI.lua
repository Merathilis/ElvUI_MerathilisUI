local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_LookingForGroupUI()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.lfg) or not E.private.mui.skins.blizzard.lfg then return end

	local LFGParentFrame = _G.LFGParentFrame
	if LFGParentFrame.backdrop then
		LFGParentFrame.backdrop:Styling()
	end
	MER:CreateBackdropShadow(LFGParentFrame)
end

module:AddCallbackForAddon("Blizzard_LookingForGroupUI")