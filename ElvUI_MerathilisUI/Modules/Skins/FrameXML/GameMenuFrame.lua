local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G

function module:GameMenuFrame()
	if not module:CheckDB("misc", "misc") then
		return
	end

	local GameMenuFrame = _G.GameMenuFrame

	if GameMenuFrame and not GameMenuFrame.__MERSkin then
		module:CreateShadow(GameMenuFrame)
		GameMenuFrame.__MERSkin = true
	end

	-- GameMenu Header Color
	for i = 1, GameMenuFrame:GetNumRegions() do
		local Region = select(i, GameMenuFrame:GetRegions())
		if Region.IsObjectType and Region:IsObjectType("FontString") then
			Region:SetTextColor(1, 1, 1)
		end
	end
end

module:AddCallback("GameMenuFrame")
