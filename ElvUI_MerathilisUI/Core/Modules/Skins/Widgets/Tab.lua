local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local LSM = E.Libs.LSM
local S = E.Skins

function module:HandleTab(_, tab, noBackdrop, template)
	if not tab then return end

	if tab.backdrop then
		tab.backdrop:SetTemplate('Transparent')
		tab.backdrop:Styling()
	end

	MER:CreateBackdropShadow(tab)
end

module:SecureHook(S, 'HandleTab')