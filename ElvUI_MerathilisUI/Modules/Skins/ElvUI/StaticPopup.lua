local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

function module:RaidUtility()
	if not E.private.mui.skins.enable then
		return
	end

	for _, popup in pairs(E.StaticPopupFrames) do
		self:CreateShadow(popup)
	end
end

module:AddCallback("RaidUtility")
