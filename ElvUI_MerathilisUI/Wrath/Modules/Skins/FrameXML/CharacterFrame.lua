local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("character", "character") then
		return
	end

	local CharacterFrame = _G.CharacterFrame
	CharacterFrame.backdrop:Styling() -- need to be on the backdrop otherwise its huuuuge
	module:CreateBackdropShadow(CharacterFrame)

	local GearManager = _G.GearManagerDialog
	GearManager:Styling()
	module:CreateShadow(GearManager)
end

S:AddCallback("CharacterFrame", LoadSkin)
