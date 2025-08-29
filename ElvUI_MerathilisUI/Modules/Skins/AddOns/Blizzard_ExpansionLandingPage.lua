local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G

function module:Blizzard_ExpansionLandingPage()
	if not module:CheckDB("expansionLanding", "expansionLanding") then
		return
	end

	local overlay = _G.ExpansionLandingPage.Overlay
	if overlay then
		local clean = E.private.skins.parchmentRemoverEnable
		for _, child in next, { overlay:GetChildren() } do
			if clean then
				self:CreateShadow(child)
			end
		end
	end

	local WarWithinOverlay = overlay.WarWithinLandingOverlay
	if WarWithinOverlay then
		if WarWithinOverlay.Header then
			WarWithinOverlay.Header.Title:FontTemplate(nil, 30)
		end
	end
end

module:AddCallbackForAddon("Blizzard_ExpansionLandingPage")
