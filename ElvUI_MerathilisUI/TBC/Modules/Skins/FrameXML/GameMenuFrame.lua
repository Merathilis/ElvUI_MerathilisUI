local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G
local select, unpack = select, unpack

local function LoadSkin()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.misc) then return end

	local r, g, b = unpack(E.media.bordercolor)

	local GameMenuFrame = _G.GameMenuFrame
	if GameMenuFrame and not GameMenuFrame.IsStyled then
		GameMenuFrame:Styling()
		MER:CreateShadow(GameMenuFrame)
		GameMenuFrame.IsStyled = true
	end

	-- GameMenu Header Color
	for i = 1, GameMenuFrame:GetNumRegions() do
		local Region = select(i, GameMenuFrame:GetRegions())
		if Region.IsObjectType and Region:IsObjectType('FontString') then
			Region:SetTextColor(1, 1, 1)
		end
	end
end

S:AddCallback("mUIGameMenu", LoadSkin)
