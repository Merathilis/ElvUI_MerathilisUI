local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local module = MER.Modules.Skins
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
	module:CreateShadow(TokenFramePopup)
end

local function LoadSkin()
	if not module:CheckDB("auctionhouse", "auctionhouse") then
		return
	end

	hooksecurefunc("TokenFrame_Update", UpdateToken)
	-- hooksecurefunc(_G.TokenFrameContainer, "update", UpdateToken)
end

S:AddCallbackForAddon("Blizzard_TokenUI", LoadSkin)
