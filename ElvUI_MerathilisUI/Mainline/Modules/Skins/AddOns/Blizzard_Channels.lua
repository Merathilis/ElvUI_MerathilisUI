local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_Channels()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.channels ~= true or E.private.mui.skins.blizzard.channels ~= true then return end

	local ChannelFrame = _G.ChannelFrame
	ChannelFrame:StripTextures()
	ChannelFrame:Styling()
	MER:CreateBackdropShadow(ChannelFrame)

	local CreateChannelPopup = _G.CreateChannelPopup
	CreateChannelPopup:Styling()
	MER:CreateBackdropShadow(CreateChannelPopup)
end

module:AddCallbackForAddon("Blizzard_Channels")
