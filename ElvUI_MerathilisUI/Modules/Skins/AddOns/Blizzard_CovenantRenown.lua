local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

local _G = _G
local hooksecurefunc = hooksecurefunc

local function LoadSkin()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.covenantRenown) or E.private.muiSkins.blizzard.covenantRenown ~= true then return end

	local frame = _G.CovenantRenownFrame
	frame:StripTextures()
	frame:CreateBackdrop('Transparent')
	frame.backdrop:Styling()

	hooksecurefunc(frame, 'SetUpCovenantData', function(self)
		self:StripTextures()
		self.CloseButton.Border:Hide()
	end)
end

S:AddCallbackForAddon('Blizzard_CovenantRenown', 'muiCovenantRenown', LoadSkin)
