local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.dressingroom ~= true or E.private.muiSkins.blizzard.dressingroom ~= true then return end

	_G.DressUpFrame.backdrop:Styling()
	MER:CreateBackdropShadow(_G.DressUpFrame)
end

S:AddCallback("mUIDressingRoom", LoadSkin)
