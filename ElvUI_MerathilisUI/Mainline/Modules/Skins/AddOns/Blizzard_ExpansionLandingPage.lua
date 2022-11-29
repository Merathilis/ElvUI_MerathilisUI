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

	if panel.MajorFactionList then
		hooksecurefunc(panel.MajorFactionList.ScrollBox, 'Update', function(self)
			for i = 1, self.ScrollTarget:GetNumChildren() do
				local child = select(i, self.ScrollTarget:GetChildren())
				if child.UnlockedState and not child.IsSkinned then
					S:HandleCheckBox(child.UnlockedState.WatchFactionButton)
					child.UnlockedState.WatchFactionButton:SetSize(32, 32)
					child.UnlockedState.WatchFactionButton.Label:SetFontObject(Game20Font)
					child.IsSkinned = true
				end
			end
		end)
	end

	module:CreateShadow(frame)
end

S:AddCallbackForAddon("Blizzard_ExpansionLandingPage", LoadSkin)
