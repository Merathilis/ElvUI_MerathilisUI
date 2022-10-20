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
		self.NineSlice:Hide()
		self.Background:Hide()
		self.BackgroundShadow:Hide()
		self.Divider:Hide()
		self.CloseButton.Border:Hide()
	end)

end

S:AddCallbackForAddon("Blizzard_MajorFactions", LoadSkin)
