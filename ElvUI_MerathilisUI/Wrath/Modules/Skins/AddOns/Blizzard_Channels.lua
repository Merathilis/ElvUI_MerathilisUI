local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("channels", "channels") then
		return
	end

	local ChannelFrame = _G.ChannelFrame
	ChannelFrame:StripTextures()
	if ChannelFrame.backdrop then
		ChannelFrame.backdrop:Styling()
	end
	module:CreateBackdropShadow(ChannelFrame)

	local CreateChannelPopup = _G.CreateChannelPopup
	CreateChannelPopup.backdrop:Styling()
	module:CreateBackdropShadow(CreateChannelPopup)
end

S:AddCallbackForAddon("Blizzard_Channels", LoadSkin)
