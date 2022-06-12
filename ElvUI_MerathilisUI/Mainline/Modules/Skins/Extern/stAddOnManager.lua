local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')
if not IsAddOnLoaded("ProjectAzilroka") then return end

local _G = _G
local CreateFrame = CreateFrame

local function LoadSkin()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.pa then return end

	local f = CreateFrame("Frame")
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:SetScript("OnEvent", function(self, event)
		if event then
			local stFrame = _G.stAMFrame
			if stFrame then
				stFrame:Styling()
				stFrame.AddOns:SetTemplate("Transparent")
				module:CreateBackdropShadow(stFrame)
			end
			f:UnregisterEvent("PLAYER_ENTERING_WORLD")
		end
	end)
end

module:AddCallbackForAddon("ProjectAzilroka", LoadSkin)
