local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not (E.private.skins.blizzard.enable or E.private.skins.blizzard.channels) or E.private.muiSkins.blizzard.channels ~= true then return end

	local ChannelFrame = _G.ChannelFrame
	ChannelFrame:StripTextures()
	ChannelFrame.backdrop:Styling()
	MER:CreateBackdropShadow(ChannelFrame)

	local CreateChannelPopup = _G.CreateChannelPopup
	CreateChannelPopup.backdrop:Styling()
	MER:CreateBackdropShadow(CreateChannelPopup)
end

S:AddCallbackForAddon("Blizzard_Channels", "mUIChannels", LoadSkin)
