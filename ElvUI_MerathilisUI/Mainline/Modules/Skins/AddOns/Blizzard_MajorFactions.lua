local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("majorFactions", "majorFactions") then
		return
	end

	local frame = _G.MajorFactionRenownFrame
	frame:Styling()
	module:CreateShadow(frame)

	hooksecurefunc(frame, 'SetUpMajorFactionData', function(self)
		if self.NineSlice then self.NineSlice:Hide() end
		if self.Background then self.Background:Hide() end
		if self.BackgroundShadow then self.BackgroundShadow:Hide() end
		if self.Divider then self.Divider:Hide() end
		if self.CloseButton.Border then self.CloseButton.Border:Hide() end
	end)
end

S:AddCallbackForAddon("Blizzard_MajorFactions", LoadSkin)
