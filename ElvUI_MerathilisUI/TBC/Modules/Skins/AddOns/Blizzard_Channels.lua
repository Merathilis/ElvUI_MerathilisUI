local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_Channels()
	if not (E.private.skins.blizzard.enable or E.private.skins.blizzard.channels) or not E.private.mui.skins.blizzard.channels then return end

	local ChannelFrame = _G.ChannelFrame
	ChannelFrame:StripTextures()
	ChannelFrame.backdrop:Styling()
	MER:CreateBackdropShadow(ChannelFrame)

	local CreateChannelPopup = _G.CreateChannelPopup
	CreateChannelPopup.backdrop:Styling()
	MER:CreateBackdropShadow(CreateChannelPopup)
end

module:AddCallbackForAddon("Blizzard_Channels")
