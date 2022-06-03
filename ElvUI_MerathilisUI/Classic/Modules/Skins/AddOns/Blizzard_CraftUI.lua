local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.craft) or not E.private.mui.skins.blizzard.craft then return end

	local CraftFrame = _G.CraftFrame
	if CraftFrame.backdrop then
		CraftFrame.backdrop:Styling()
	end
	MER:CreateBackdropShadow(CraftFrame)
end

S:AddCallbackForAddon("Blizzard_CraftUI", LoadSkin)
