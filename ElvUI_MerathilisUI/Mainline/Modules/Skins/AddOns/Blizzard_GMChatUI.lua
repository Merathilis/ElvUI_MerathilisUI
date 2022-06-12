local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("gmChat", "GMChat") then
		return
	end

	if _G.GMChatFrame.backdrop then
		_G.GMChatFrame.backdrop:Styling()
	end
	module:CreateBackdropShadow(_G.GMChatFrame)

	if _G.GMChatTab.backdrop then
		_G.GMChatTab.backdrop:Styling()
	end
	module:CreateBackdropShadow(_G.GMChatTab)
end

S:AddCallbackForAddon("Blizzard_GMChatUI", LoadSkin)
