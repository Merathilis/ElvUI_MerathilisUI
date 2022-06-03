local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.character) or not E.private.mui.skins.blizzard.character then return end

	-- Hide ElvUI Backdrop
	local CharacterFrame = _G.CharacterFrame
	if CharacterFrame.backdrop then
		CharacterFrame.backdrop:Styling()
	end
	MER:CreateBackdropShadow(CharacterFrame)
end

S:AddCallback("CharacterFrame", LoadSkin)
