local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G

function module:Blizzard_Channels()
	if not module:CheckDB("channels", "channels") then
		return
	end

	local ChannelFrame = _G.ChannelFrame
	module:CreateBackdropShadow(ChannelFrame)

	local CreateChannelPopup = _G.CreateChannelPopup
	module:CreateBackdropShadow(CreateChannelPopup)
end

module:AddCallbackForAddon("Blizzard_Channels")
