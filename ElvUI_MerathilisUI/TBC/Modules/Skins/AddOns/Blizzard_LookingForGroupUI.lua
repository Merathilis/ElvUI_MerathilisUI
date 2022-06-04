local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.lfg) or not E.private.mui.skins.blizzard.lfg then return end

	local LFGParentFrame = _G.LFGParentFrame
	if LFGParentFrame.backdrop then
		LFGParentFrame.backdrop:Styling()
	end
	MER:CreateBackdropShadow(LFGParentFrame)
end

S:AddCallbackForAddon("Blizzard_LookingForGroupUI", LoadSkin)