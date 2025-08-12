local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

function module:StaticPopup()
	if not self:CheckDB(nil, "staticPopup") then
		return
	end

	for i = 1, E.MAX_STATIC_POPUPS do
		self:CreateShadow(_G["StaticPopup" .. i])
	end
end

module:AddCallback("StaticPopup")
