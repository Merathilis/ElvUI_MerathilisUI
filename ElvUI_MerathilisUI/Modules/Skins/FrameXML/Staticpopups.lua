local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G

function module:StaticPopup()
	if not self:CheckDB(nil, "staticPopup") then
		return
	end

	for i = 1, E.MAX_STATIC_POPUPS do
		self:CreateShadow(_G["StaticPopup" .. i])
	end
end

module:AddCallback("StaticPopup")
