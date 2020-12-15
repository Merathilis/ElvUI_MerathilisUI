local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

local _G = _G

local hooksecurefunc = hooksecurefunc
local CreateFrame = CreateFrame

local function LoadSkin()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.covenantRenown) or E.private.muiSkins.blizzard.covenantRenown ~= true then return end

	local frame = _G.CovenantRenownFrame
	frame:CreateBackdrop('Transparent')
	frame.backdrop:Styling()

	hooksecurefunc(frame, 'SetUpCovenantData', function(self)
		self.NineSlice:Hide()
		self.Background:Hide()
		self.BackgroundShadow:Hide()
		self.Divider:Hide()
		self.CloseButton.Border:Hide()
	end)

	hooksecurefunc(frame, 'SetRewards', function(self)
		for reward in self.rewardsPool:EnumerateActive() do
			if not reward.backdrop then
				reward:CreateBackdrop('Transparent')
				reward.backdrop:SetPoint("TOPLEFT", reward, 2, -15)
				reward.backdrop:SetPoint("BOTTOMRIGHT", reward, -2, 15)

				reward.Toast:SetAlpha(0)
				reward.Highlight:SetAlpha(0)
				reward.CircleMask:Hide()
				reward.IconBorder:SetAlpha(0)

				reward.b = CreateFrame("Frame", nil, reward, 'BackdropTemplate')
				reward.b:SetTemplate()
				reward.b:SetPoint("TOPLEFT", reward.Icon, "TOPLEFT", -2, 2)
				reward.b:SetPoint("BOTTOMRIGHT", reward.Icon, "BOTTOMRIGHT", 2, -2)
				reward.Icon:SetParent(reward.b)
				reward.Icon:SetTexCoord(0.15, 0.85, 0.15, 0.85)
				reward.Check:SetParent(reward.b)
			end
		end
	end)
end

S:AddCallbackForAddon('Blizzard_CovenantRenown', 'muiCovenantRenown', LoadSkin)
