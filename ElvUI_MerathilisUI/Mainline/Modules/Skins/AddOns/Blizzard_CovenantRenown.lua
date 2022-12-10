local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local hooksecurefunc = hooksecurefunc

local function LoadSkin()
	if not module:CheckDB("garrison", "garrison") then
		return
	end

	local frame = _G.CovenantRenownFrame
	frame:StripTextures()
	frame:SetTemplate('Transparent')
	frame:Styling()
	module:CreateShadow(frame)

	hooksecurefunc(frame, 'SetUpCovenantData', function(self)
		self.NineSlice:Hide()
		self.Background:Hide()
		self.BackgroundShadow:Hide()
		self.Divider:Hide()
		self.CloseButton.Border:Hide()
	end)
end

S:AddCallbackForAddon('Blizzard_CovenantRenown', LoadSkin)
