local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins

local _G = _G

local hooksecurefunc = hooksecurefunc

local function UpdateToken()
	local TokenFramePopup = _G.TokenFramePopup

	module:CreateShadow(TokenFramePopup)
end

function module:Blizzard_TokenUI()
	if not module:CheckDB("auctionhouse", "auctionhouse") then
		return
	end

	hooksecurefunc("TokenFrame_Update", UpdateToken)
	-- hooksecurefunc(_G.TokenFrameContainer, "update", UpdateToken)
end

module:AddCallbackForAddon("Blizzard_TokenUI")
