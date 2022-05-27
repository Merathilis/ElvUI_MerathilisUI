local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G

function module:DressUpFrame()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.dressingroom ~= true or not E.private.mui.skins.blizzard.dressingroom then return end

	local DressUpFrame = _G.DressUpFrame
	if DressUpFrame.backdrop then
		DressUpFrame.backdrop:Styling()
	end
	MER:CreateBackdropShadow(_G.DressUpFrame)
end

module:AddCallback("DressUpFrame")
