local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_UnitFrames')
local UF = E.UnitFrames

local hooksecurefunc = hooksecurefunc

function module:Configure_Castbar(frame)
	local castbar = frame.Castbar

	if castbar.backdrop and not castbar.__MERSkin then
		castbar.backdrop:Styling(false, false, true)
		castbar.__MERSkin = true
	end
end

function module:InitCastBar()
	hooksecurefunc(UF, "Configure_Castbar", module.Configure_Castbar)
end
