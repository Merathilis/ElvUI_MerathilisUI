local MER, E, L, V, P, G = unpack(select(2, ...))
local MUF = MER:GetModule("muiUnits")
local UF = E.UnitFrames

--Cache global variables
--Lua functions
local _G = _G
local pairs = pairs
--WoW API / Variables
local UnitHealthMax = UnitHealthMax
local UnitIsConnected = UnitIsConnected
local hooksecurefunc = hooksecurefunc
-- GLOBALS:

function MUF:Configure_HealComm(frame)
	print(frame)
	if frame.db and frame.db.healPrediction and frame.db.healPrediction.enable then
		local healPrediction = frame.HealthPrediction

		if frame.db.health then
			local health = frame.Health
			local orientation = frame.db.health.orientation or frame.Health:GetOrientation()
			local reverseFill = not not frame.db.health.reverseFill
			local overAbsorbTexture = "Interface\\RaidFrame\\Shield-Overshield"

			if orientation == "HORIZONTAL" then
				if healPrediction.overAbsorb then
					healPrediction.overAbsorb:SetTexture(overAbsorbTexture)
					healPrediction.overAbsorb:SetWidth(15)
					healPrediction.overAbsorb:SetBlendMode("ADD")
					healPrediction.overAbsorb:ClearAllPoints()

					if reverseFill then
						healPrediction.overAbsorb:SetPoint("TOPRIGHT", health, "TOPLEFT", 5, 3)
						healPrediction.overAbsorb:SetPoint("BOTTOMRIGHT", health, "BOTTOMLEFT", 5, -3)
					else
						healPrediction.overAbsorb:SetPoint("TOPLEFT", health, "TOPRIGHT", -5, 3)
						healPrediction.overAbsorb:SetPoint("BOTTOMLEFT", health, "BOTTOMRIGHT", -5, -3)
					end
				end
			else
				if healPrediction.overAbsorb then
					healPrediction.overAbsorb:SetTexture(overAbsorbTexture)
					healPrediction.overAbsorb:SetHeight(15)
					healPrediction.overAbsorb:SetBlendMode("ADD")
					healPrediction.overAbsorb:ClearAllPoints()

					if reverseFill then
						healPrediction.overAbsorb:SetPoint("TOPLEFT", health, "BOTTOMLEFT", -3, 5)
						healPrediction.overAbsorb:SetPoint("TOPRIGHT", health, "BOTTOMRIGHT", 3, 5)
					else
						healPrediction.overAbsorb:SetPoint("BOTTOMLEFT", health, "TOPLEFT", -3, -5)
						healPrediction.overAbsorb:SetPoint("BOTTOMRIGHT", health, "TOPRIGHT", 3, -5)
					end
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
	for _, object in pairs(_G.ElvUF.objects) do
		if object.HealthPrediction then
			MUF:Configure_HealComm(object)
		end
	end
end

