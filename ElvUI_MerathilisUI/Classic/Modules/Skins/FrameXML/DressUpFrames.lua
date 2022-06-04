local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.dressingroom ~= true or not E.private.mui.skins.blizzard.dressingroom then return end

	local DressUpFrame = _G.DressUpFrame
	if DressUpFrame.backdrop then
		DressUpFrame.backdrop:Styling()
	end
	MER:CreateBackdropShadow(_G.DressUpFrame)
end

S:AddCallback("DressUpFrame", LoadSkin)
