local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local module = MER:GetModule('MER_Skins')

local _G = _G
local CreateFrame = CreateFrame

function module:ProjectAzilroka()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.pa then return end

	local f = CreateFrame("Frame")
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:SetScript("OnEvent", function(_, event)
		if event then
			local stFrame = _G.stAMFrame
			if stFrame and not stFrame.isSkinned then
				stFrame:SetTemplate("Transparent")
				stFrame.AddOns:SetTemplate("Transparent")
				stFrame:Styling()
				module:CreateShadow(stFrame)

				stFrame.isSkinned = true
			end
			f:UnregisterEvent("PLAYER_ENTERING_WORLD")
		end
	end)
end

module:AddCallbackForAddon("ProjectAzilroka")
