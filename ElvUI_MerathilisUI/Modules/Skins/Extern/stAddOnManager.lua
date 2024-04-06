local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G
local CreateFrame = CreateFrame

function module:ProjectAzilroka()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.pa then
		return
	end

	local f = CreateFrame("Frame")
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:SetScript("OnEvent", function(_, event)
		if event then
			local stFrame = _G.stAMFrame
			if stFrame and not stFrame.isSkinned then
				stFrame:SetTemplate("Transparent")
				stFrame.AddOns:SetTemplate("Transparent")
				module:CreateShadow(stFrame)

				stFrame.isSkinned = true
			end
			f:UnregisterEvent("PLAYER_ENTERING_WORLD")
		end
	end)
end

module:AddCallbackForAddon("ProjectAzilroka")
