local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G
local hooksecurefunc = hooksecurefunc

function module:Blizzard_OrderHallUI()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.orderhall ~= true or E.private.mui.skins.blizzard.orderhall ~= true then return end

	local OrderHallTalentFrame = _G.OrderHallTalentFrame
	if not OrderHallTalentFrame.backdrop then
		OrderHallTalentFrame:CreateBackdrop('Transparent')
	end
	OrderHallTalentFrame.backdrop:Styling()

	MER:CreateBackdropShadow(OrderHallTalentFrame)

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
