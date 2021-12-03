local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.craft) or E.private.muiSkins.blizzard.craft ~= true then return end

	local CraftFrame = _G.CraftFrame
	CraftFrame.backdrop:Styling()
	MER:CreateBackdropShadow(CraftFrame)
end

S:AddCallbackForAddon("Blizzard_CraftUI", "mUICraft", LoadSkin)
