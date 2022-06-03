local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.GMChat ~= true or not E.private.mui.skins.blizzard.GMChat then return end

	if _G.GMChatFrame.backdrop then
		_G.GMChatFrame.backdrop:Styling()
	end
	MER:CreateBackdropShadow(_G.GMChatFrame)

	if _G.GMChatTab.backdrop then
		_G.GMChatTab.backdrop:Styling()
	end
	MER:CreateBackdropShadow(_G.GMChatTab)
end

S:AddCallbackForAddon("Blizzard_GMChatUI", LoadSkin)
