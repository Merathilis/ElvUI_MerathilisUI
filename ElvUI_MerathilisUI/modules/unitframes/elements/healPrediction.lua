local MER, E, L, V, P, G = unpack(select(2, ...))
local MUF = MER:GetModule("muiUnits")
local UF = E:GetModule("UnitFrames")

--Cache global variables
--Lua functions
local pairs = pairs
--WoW API / Variables
local UnitHealthMax = UnitHealthMax
local UnitIsConnected = UnitIsConnected
local hooksecurefunc = hooksecurefunc
-- GLOBALS:

function MUF:Configure_HealComm(frame)
	if frame.db.healPrediction and frame.db.healPrediction.enable and frame.db.health then
		local healPrediction = frame.HealthPrediction
		local orientation = frame.db.health.orientation or frame.Health:GetOrientation()
		local reverseFill = not not frame.db.health.reverseFill

		if orientation == "HORIZONTAL" then
			if healPrediction.overAbsorb then
				healPrediction.overAbsorb:SetTexture("Interface\\RaidFrame\\Shield-Overshield")
				healPrediction.overAbsorb:SetWidth(15)
				healPrediction.overAbsorb:SetBlendMode("ADD")
				healPrediction.overAbsorb:ClearAllPoints()
				if reverseFill then
					healPrediction.overAbsorb:SetPoint("TOPRIGHT", frame.Health, "TOPLEFT", 5, 3)
					healPrediction.overAbsorb:SetPoint("BOTTOMRIGHT", frame.Health, "BOTTOMLEFT", 5, -3)
				else
					healPrediction.overAbsorb:SetPoint("TOPLEFT", frame.Health, "TOPRIGHT", -5, 3)
					healPrediction.overAbsorb:SetPoint("BOTTOMLEFT", frame.Health, "BOTTOMRIGHT", -5, -3)
				end
			end
		else
			if healPrediction.overAbsorb then
				healPrediction.overAbsorb:SetTexture("Interface\\RaidFrame\\Shield-Overshield")
				healPrediction.overAbsorb:SetHeight(15)
				healPrediction.overAbsorb:SetBlendMode("ADD")
				healPrediction.overAbsorb:ClearAllPoints()
				if reverseFill then
					healPrediction.overAbsorb:SetPoint("TOPLEFT", frame.Health, "BOTTOMLEFT", -3, 5)
					healPrediction.overAbsorb:SetPoint("TOPRIGHT", frame.Health, "BOTTOMRIGHT", 3, 5)
				else
					healPrediction.overAbsorb:SetPoint("BOTTOMLEFT", frame.Health, "TOPLEFT", -3, -5)
					healPrediction.overAbsorb:SetPoint("BOTTOMRIGHT", frame.Health, "TOPRIGHT", 3, -5)
				end
			end
		end

		if healPrediction.overAbsorb then
			healPrediction.overAbsorb:SetVertexColor(1, 1, 1, 1)
			healPrediction.overAbsorb:SetParent(frame.RaisedElementParent)
		end
	end
end

function MUF:HealPrediction()
	if E.private.unitframe.enable ~= true or E.db.mui.unitframes.healPrediction ~= true then return end

	hooksecurefunc(UF, "Configure_HealComm", MUF.Configure_HealComm)
end

