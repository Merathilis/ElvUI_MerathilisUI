local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnitFrames")

function module:Update_PlayerFrame(frame)
	local db = E.db.mui.unitframes

	if not frame.Swing then
		module:Construct_Swing(frame)
	end

	if not frame.CounterBar then
		module:Construct_CounterBar(frame)
	end

	if not frame.GCD then
		module:Construct_GCD(frame)
	end

	if not frame.__MERAnim then
		module:CreateAnimatedBars(frame.Power)
	end

	module:CreateHighlight(frame)

	if db.swing.enable then
		if not frame:IsElementEnabled("Swing_MER") then
			frame:EnableElement("Swing_MER")
		end
	else
		if frame:IsElementEnabled("Swing_MER") then
			frame:DisableElement("Swing_MER")
		end
	end

	if db.gcd.enable then
		if not frame:IsElementEnabled("GCD") then
			frame:EnableElement("GCD")
		end
	else
		if frame:IsElementEnabled("GCD") then
			frame:DisableElement("GCD")
		end
	end

	if db.counterBar.enable then
		if not frame:IsElementEnabled("CounterBar") then
			frame:EnableElement("CounterBar")
		end
	else
		if frame:IsElementEnabled("CounterBar") then
			frame:DisableElement("CounterBar")
		end
	end
end
