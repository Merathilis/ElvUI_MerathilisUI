local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_UnitFrames')
local UF = E:GetModule('UnitFrames')

local hooksecurefunc = hooksecurefunc

function module:Update_RaidFrames(frame)
	local db = E.db.mui.unitframes

	-- Only looks good on Transparent
	if E.db.unitframe.colors.transparentHealth then
		if db.style then
			if frame and frame.Health and not frame.__MERSkin then
				frame.Health:Styling(false, false, true)
				frame.__MERSkin = true
			end
		end
	end

	module:CreateHighlight(frame)
end

function module:InitRaid()
	if not E.db.unitframe.units.raid1.enable or not E.db.unitframe.units.raid2.enable or not E.db.unitframe.units.raid3.enable then return end

	hooksecurefunc(UF, "Update_RaidFrames", module.Update_RaidFrames)
end
