local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_UnitFrames')
local UF = E:GetModule('UnitFrames')

local hooksecurefunc = hooksecurefunc

function module:Configure_Power(frame)
	local power = frame.Power

	if power and not power.__MERSkin then
		power:Styling(false, false, true)
		power.__MERSkin = true
	end
end

function module:InitPower()
	hooksecurefunc(UF, "Configure_Power", module.Configure_Power)
end
