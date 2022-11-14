local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_UnitFrames')
local UF = E:GetModule('UnitFrames')

local hooksecurefunc = hooksecurefunc

function module:Update_PartyFrames(frame)
	local db = E.db.mui.unitframes

	-- Only looks good on Transparent
	if E.db.unitframe.colors.transparentHealth then
		if db.style then
			if frame and frame.Health and not frame.__MERSkin then
				frame.Health:Styling()
				frame.__MERSkin = true
			end
		end
	end

	module:CreateHighlight(frame)
end
