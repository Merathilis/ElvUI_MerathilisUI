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
			healPrediction.overAbsorb:SetVertexColor(1, 1, 1)
			healPrediction.overAbsorb:SetParent(frame.RaisedElementParent)
		end

		if healPrediction.absorbBar then
			if not healPrediction.absorbBar.overlay then
				healPrediction.absorbBar.overlay = healPrediction.absorbBar:CreateTexture(nil, "ARTWORK", nil, 1)
				healPrediction.absorbBar.overlay:SetAllPoints(healPrediction.absorbBar:GetStatusBarTexture())
				healPrediction.absorbBar.overlay:SetTexture("Interface\\RaidFrame\\Shield-Overlay", true, true)
				healPrediction.absorbBar.overlay.tileSize = 32
			end
			-- healPrediction.absorbBar.overlay:Hide()
		end
	end
end

function MUF:UpdateHealComm(unit, myIncomingHeal, otherIncomingHeal, absorb, healAbsorb, hasOverAbsorb, hasOverHealAbsorb)
	if not self.absorbBar.overlay or not UnitIsConnected(unit) then return end

	local totalWidth, totalHeight = self.frame.Health:GetSize()
	local totalMax = UnitHealthMax(unit)
	local barSize = (absorb / totalMax) * totalWidth
	self.absorbBar.overlay:SetTexCoord(0, barSize / self.absorbBar.overlay.tileSize, 0, totalHeight / self.absorbBar.overlay.tileSize)
end

function MUF:HealPrediction()
	if E.private.unitframe.enable ~= true or E.db.mui.unitframes.healPrediction ~= true then return end

	hooksecurefunc(UF, "Configure_HealComm", MUF.Configure_HealComm)

	for _, object in pairs(ElvUF.objects) do
		if object.HealthPrediction and object.HealthPrediction.PostUpdate then
			hooksecurefunc(object.HealthPrediction, "PostUpdate", MUF.UpdateHealComm)
		end
	end
end

