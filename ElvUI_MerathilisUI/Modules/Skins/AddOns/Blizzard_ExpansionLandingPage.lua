local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local _G = _G

function module:Blizzard_ExpansionLandingPage()
	if not module:CheckDB("expansionLanding", "expansionLanding") then
		return
	end

	local frame = _G.ExpansionLandingPage
	module:CreateShadow(frame)

	if frame.Overlay and frame.Overlay.DragonflightLandingOverlay then
		if
			frame.Overlay.DragonflightLandingOverlay.Header and frame.Overlay.DragonflightLandingOverlay.Header.Title
		then
			frame.Overlay.DragonflightLandingOverlay.Header.Title:FontTemplate(nil, 30)
		end

		if frame.Overlay.DragonflightLandingOverlay.DragonridingPanel then
			if frame.Overlay.DragonflightLandingOverlay.DragonridingPanel.Title then
				frame.Overlay.DragonflightLandingOverlay.DragonridingPanel.Title:FontTemplate(nil, 26)
			end
			if frame.Overlay.DragonflightLandingOverlay.DragonridingPanel.Subtitle then
				frame.Overlay.DragonflightLandingOverlay.DragonridingPanel.Subtitle:FontTemplate(nil, 18)
			end
		end
	end
end

module:AddCallbackForAddon("Blizzard_ExpansionLandingPage")
