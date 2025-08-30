local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G

function module:Blizzard_MajorFactions1()
	if not module:CheckDB("majorFactions", "majorFactions") then
		return
	end

	local frame = _G.MajorFactionRenownFrame
	module:CreateShadow(frame)

	hooksecurefunc(frame, "SetUpMajorFactionData", function(self)
		if self.NineSlice then
			self.NineSlice:Hide()
		end
		if self.Background then
			self.Background:Hide()
		end
		if self.BackgroundShadow then
			self.BackgroundShadow:Hide()
		end
		if self.Divider then
			self.Divider:Hide()
		end
		if self.CloseButton.Border then
			self.CloseButton.Border:Hide()
		end
	end)
end

module:AddCallbackForAddon("Blizzard_MajorFactions")
