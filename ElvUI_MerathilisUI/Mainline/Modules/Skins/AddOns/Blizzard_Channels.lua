local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.channels ~= true or E.private.mui.skins.blizzard.channels ~= true then return end

	local ChannelFrame = _G.ChannelFrame
	ChannelFrame:Styling()
	MER:CreateBackdropShadow(ChannelFrame)

	local CreateChannelPopup = _G.CreateChannelPopup
	CreateChannelPopup:Styling()
	MER:CreateBackdropShadow(CreateChannelPopup)
end

S:AddCallbackForAddon("Blizzard_Channels", LoadSkin)
