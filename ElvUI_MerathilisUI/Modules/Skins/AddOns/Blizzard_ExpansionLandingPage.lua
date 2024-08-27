local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

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
end

module:AddCallbackForAddon("Blizzard_ExpansionLandingPage")
