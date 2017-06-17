local MER, E, L, V, P, G = unpack(select(2, ...))
local MUF = E:GetModule("muiUnits")
local UF = E:GetModule("UnitFrames")

function MUF:Configure_Infopanel(frame)
	if frame.ORIENTATION == "RIGHT" and not (frame.unitframeType == "arena") then
		if frame.PORTRAIT_AND_INFOPANEL then
			frame.InfoPanel:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -frame.PORTRAIT_WIDTH -frame.BORDER - frame.SPACING, frame.BORDER + frame.SPACING)
		else
			frame.InfoPanel:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -frame.BORDER - frame.SPACING, frame.BORDER + frame.SPACING)
		end
		if(frame.USE_POWERBAR and not frame.USE_INSET_POWERBAR and not frame.POWERBAR_DETACHED) then
			frame.InfoPanel:SetPoint("TOPLEFT", frame.Power.backdrop, "BOTTOMLEFT", frame.BORDER, -(frame.SPACING*3))
		else
			frame.InfoPanel:SetPoint("TOPLEFT", frame.Health.backdrop, "BOTTOMLEFT", frame.BORDER, -(frame.SPACING*3))
		end
	else
		if frame.PORTRAIT_AND_INFOPANEL then
			frame.InfoPanel:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", frame.PORTRAIT_WIDTH +frame.BORDER + frame.SPACING, frame.BORDER + frame.SPACING)
		else
			frame.InfoPanel:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", frame.BORDER + frame.SPACING, frame.BORDER + frame.SPACING)
		end
		if(frame.USE_POWERBAR and not frame.USE_INSET_POWERBAR and not frame.POWERBAR_DETACHED) then
			frame.InfoPanel:SetPoint("TOPRIGHT", frame.Power.backdrop, "BOTTOMRIGHT", -frame.BORDER, -(frame.SPACING*3))
		else
			frame.InfoPanel:SetPoint("TOPRIGHT", frame.Health.backdrop, "BOTTOMRIGHT", -frame.BORDER, -(frame.SPACING*3))
		end
	end
end