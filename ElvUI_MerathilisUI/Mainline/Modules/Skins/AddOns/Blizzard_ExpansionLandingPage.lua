local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("expansionLanding", "expansionLanding") then
		return
	end

	local frame = _G.ExpansionLandingPage
	local panel

	if frame.Overlay then
		for i = 1, frame.Overlay:GetNumChildren() do
			local child = select(i, frame.Overlay:GetChildren())
			child:StripTextures()
			child:SetTemplate('Transparent')
			child:Styling()
			module:CreateShadow(child)

			if child.DragonridingPanel then
				panel = child
				break
			end
		end
	end

end

S:AddCallbackForAddon("Blizzard_ExpansionLandingPage", LoadSkin)
