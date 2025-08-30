local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc

function module:Blizzard_OrderHallUI()
	if not module:CheckDB("orderhall", "orderhall") then
		return
	end

	local OrderHallTalentFrame = _G.OrderHallTalentFrame
	module:CreateBackdropShadow(OrderHallTalentFrame)

	if OrderHallTalentFrame.SetTemplate then
		OrderHallTalentFrame.SetTemplate = nil
	end

	hooksecurefunc(OrderHallTalentFrame, "RefreshAllData", function(self)
		if self.talentRankPool then
			for rank in self.talentRankPool:EnumerateActive() do
				if not rank.styled then
					rank.Background:SetAlpha(0)
					rank.styled = true
				end
			end
		end
	end)
end

module:AddCallbackForAddon("Blizzard_OrderHallUI")
