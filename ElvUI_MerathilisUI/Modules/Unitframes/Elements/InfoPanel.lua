local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_UnitFrames')
local S = MER:GetModule('MER_Skins')

function module:UnitFrames_Configure_InfoPanel(_, f)
	if f.MERshadow then return end

	local isShown = f.USE_INFO_PANEL

	if isShown then
		local shadow = f.InfoPanel.backdrop.MERshadow
		f.InfoPanel.backdrop:Styling()

		if not shadow then
			S:CreateBackdropShadow(f.InfoPanel, true)
		else
			shadow:Show()
		end
	end
end
