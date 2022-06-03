local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

local _G = _G

local hooksecurefunc = hooksecurefunc

local function UpdateToken()
	local TokenFramePopup = _G.TokenFramePopup

	if TokenFramePopup.backdrop then
		if not TokenFramePopup.backdrop.styling then
			TokenFramePopup.backdrop:Styling()
			TokenFramePopup.backdrop.styling = true
		end
	end
	MER:CreateShadow(TokenFramePopup)
end

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.character ~= true or not E.private.mui.skins.blizzard.character then return end

	hooksecurefunc("TokenFrame_Update", UpdateToken)
	hooksecurefunc(_G.TokenFrameContainer, "update", UpdateToken)
end

S:AddCallbackForAddon("Blizzard_TokenUI", LoadSkin)
