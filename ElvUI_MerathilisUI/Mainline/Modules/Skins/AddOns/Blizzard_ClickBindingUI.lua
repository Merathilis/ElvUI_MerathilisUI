local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G
local hooksecurefunc = hooksecurefunc

local function HandleScrollChild(self)
	for i = 1, self.ScrollTarget:GetNumChildren() do
		local child = select(i, self.ScrollTarget:GetChildren())
		local icon = child and child.Icon
		if icon and not icon.IsChanged then
			if child and child.backdrop then
				child.backdrop:SetTemplate('Transparent')
				MERS:CreateGradient(child.backdrop)
			end
			icon.IsChanged = true
		end
	end
end

local function LoadSkin()
	if not E.private.skins.blizzard.enable and E.private.skins.blizzard.binding or not E.private.muiSkins.blizzard.binding then return end

	local frame = _G.ClickBindingFrame
	frame:Styling()

	hooksecurefunc(frame.ScrollBox, 'Update', HandleScrollChild)
end

S:AddCallbackForAddon("Blizzard_ClickBindingUI", "mUIClickBinding", LoadSkin)
