local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

local _G = _G

local hooksecurefunc = hooksecurefunc

local function LoadSkin()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.covenantRenown) or E.private.mui.skins.blizzard.covenantRenown ~= true then return end

	local frame = _G.CovenantRenownFrame
	frame:StripTextures()
	frame:CreateBackdrop('Transparent')
	frame.backdrop:Styling()
	MER:CreateBackdropShadow(frame)

	hooksecurefunc(frame, 'SetUpCovenantData', function(self)
		self.NineSlice:Hide()
		self.Background:Hide()
		self.BackgroundShadow:Hide()
		self.Divider:Hide()
		self.CloseButton.Border:Hide()
	end)
end

S:AddCallbackForAddon('Blizzard_CovenantRenown', LoadSkin)
