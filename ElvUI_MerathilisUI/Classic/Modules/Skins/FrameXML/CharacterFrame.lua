local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("character", "character") then
		return
	end

	local CharacterFrame = _G.CharacterFrame
	if CharacterFrame.backdrop then
		CharacterFrame.backdrop:Styling()
	end
	module:CreateBackdropShadow(CharacterFrame)
end

S:AddCallback("CharacterFrame", LoadSkin)
