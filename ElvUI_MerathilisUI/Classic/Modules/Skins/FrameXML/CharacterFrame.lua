local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.character) or E.private.mui.skins.blizzard.character ~= true then return end

	-- Hide ElvUI Backdrop
	local CharacterFrame = _G.CharacterFrame

	CharacterFrame.backdrop:Styling()
	MER:CreateBackdropShadow(CharacterFrame)
end

S:AddCallback("mUICharacter", LoadSkin)
