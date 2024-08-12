local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

function module:AltPowerBar()
	if not E.private.mui.skins.shadow.enable then
		return
	end

	local bar = _G.ElvUI_AltPowerBar

	if not bar then
		return
	end

	module:CreateBackdropShadow(bar)

	bar.text:ClearAllPoints()
	bar.text:SetPoint("CENTER", bar, "CENTER", 0, 1)
end

module:AddCallback("AltPowerBar")
