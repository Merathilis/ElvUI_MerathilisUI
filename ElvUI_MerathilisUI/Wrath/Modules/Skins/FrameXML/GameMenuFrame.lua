local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G
local select = select

local function LoadSkin()
	if not module:CheckDB("misc", "misc") then
		return
	end

	local GameMenuFrame = _G.GameMenuFrame
	if GameMenuFrame and not GameMenuFrame.__MERSkin then
		GameMenuFrame:Styling()
		module:CreateShadow(GameMenuFrame)
		GameMenuFrame.__MERSkin = true
	end

	-- GameMenu Header Color
	for i = 1, GameMenuFrame:GetNumRegions() do
		local Region = select(i, GameMenuFrame:GetRegions())
		if Region.IsObjectType and Region:IsObjectType('FontString') then
			Region:SetTextColor(1, 1, 1)
		end
	end
end

S:AddCallback("GameMenuFrame", LoadSkin)
