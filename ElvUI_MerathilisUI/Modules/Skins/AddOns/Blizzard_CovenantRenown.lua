local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins

local _G = _G

local hooksecurefunc = hooksecurefunc

function module:Blizzard_CovenantRenown()
	if not module:CheckDB("garrison", "garrison") then
		return
	end

	local frame = _G.CovenantRenownFrame
	frame:StripTextures()
	frame:SetTemplate("Transparent")
	module:CreateShadow(frame)

	hooksecurefunc(frame, "SetUpCovenantData", function(self)
		self.NineSlice:Hide()
		self.Background:Hide()
		self.BackgroundShadow:Hide()
		self.Divider:Hide()
		self.CloseButton.Border:Hide()
	end)
end

module:AddCallbackForAddon("Blizzard_CovenantRenown")
