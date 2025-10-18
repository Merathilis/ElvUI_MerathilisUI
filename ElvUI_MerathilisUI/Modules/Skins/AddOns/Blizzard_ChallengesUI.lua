local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G

function module:Blizzard_ChallengesUI()
	if not self:CheckDB("lfg", "challenges") then
		return
	end

	self:CreateShadow(_G.ChallengesKeystoneFrame)
end

module:AddCallbackForAddon("Blizzard_ChallengesUI")
