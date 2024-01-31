local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G

function module:Blizzard_ExpansionLandingPage()
	if not module:CheckDB("expansionLanding", "expansionLanding") then
		return
	end

	local frame = _G.ExpansionLandingPage
	local panel

	module:CreateShadow(frame)

	if frame.Overlay then
		for i = 1, frame.Overlay:GetNumChildren() do
			local child = select(i, frame.Overlay:GetChildren())
			child:StripTextures()
			child:SetTemplate('Transparent')
			module:CreateShadow(child)

			if child.DragonridingPanel then
				panel = child
				break
			end
		end
	end

	if not panel then return end

	panel.NineSlice:SetAlpha(0)
	panel.Background:SetAlpha(0)

	if panel.MajorFactionList then
		hooksecurefunc(panel.MajorFactionList.ScrollBox, 'Update', function(self)
			for i = 1, self.ScrollTarget:GetNumChildren() do
				local child = select(i, self.ScrollTarget:GetChildren())
				if child.UnlockedState and not child.IsSkinned then
					child.UnlockedState.WatchFactionButton:SetSize(28, 28)
					S:HandleCheckBox(child.UnlockedState.WatchFactionButton)
					child.UnlockedState.WatchFactionButton.Label:SetFontObject(Game20Font)
					child.IsSkinned = true
				end
			end
		end)
	end
end

module:AddCallbackForAddon("Blizzard_ExpansionLandingPage")
