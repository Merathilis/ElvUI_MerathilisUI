local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule("muiUnits")
local UF = E.UnitFrames

--Cache global variables
--Lua functions
local _G = _G
local pairs = pairs
--WoW API / Variables
local UnitGetTotalAbsorbs = UnitGetTotalAbsorbs
local UnitHealthMax = UnitHealthMax
local UnitIsConnected = UnitIsConnected
local hooksecurefunc = hooksecurefunc
-- GLOBALS:

function module:Configure_HealComm(frame)
	if frame.db and frame.db.healPrediction and frame.db.healPrediction.enable then
		local healPrediction = frame.HealthPrediction

		if frame.db.health then
			local health = frame.Health
			local orientation = frame.db.health.orientation or frame.Health:GetOrientation()
			local reverseFill = not not frame.db.health.reverseFill
			local overAbsorbTexture = "Interface\\RaidFrame\\Shield-Overshield"

			if healPrediction.absorbBar and not healPrediction.absorbBar.overlay then
				healPrediction.absorbBar.overlay = healPrediction.absorbBar:CreateTexture(nil, "ARTWORK", nil, 1)
				healPrediction.absorbBar.overlay:SetAllPoints(healPrediction.absorbBar:GetStatusBarTexture())
				healPrediction.absorbBar.overlay:SetTexture("Interface\\RaidFrame\\Shield-Overlay", true, true)
				healPrediction.absorbBar.overlay.tileSize = 32
			end

			if orientation == "HORIZONTAL" then
				if healPrediction.overAbsorb then
					healPrediction.overAbsorb:SetTexture(overAbsorbTexture)
					healPrediction.overAbsorb:SetWidth(10)
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
					healPrediction.overAbsorb:SetHeight(10)
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

			if UF.statusbars and UF.statusbars[healPrediction.overAbsorb] then
				UF.statusbars[healPrediction.overAbsorb] = nil
			end
		end

		if healPrediction.overAbsorb then
			healPrediction.overAbsorb:SetVertexColor(1, 1, 1, 1)
			healPrediction.overAbsorb:SetParent(frame.RaisedElementParent)
		end

		if healPrediction.absorbBar then
			healPrediction.absorbBar:SetStatusBarColor(0.66, 1, 1, .6)
		end
	end
end

function module:UpdateHealComm(unit, myIncomingHeal, otherIncomingHeal, absorb, healAbsorb, hasOverAbsorb, hasOverHealAbsorb)
	if not self.absorbBar.overlay or not UnitIsConnected(unit) then return end

	local pred = self.frame and self.frame.db and self.frame.db.healPrediction
	local totalWidth, totalHeight = self.frame.Health:GetSize()
	local totalMax = UnitHealthMax(unit)
	absorb = pred and UnitGetTotalAbsorbs(unit) or absorb
	local barSize = (absorb / totalMax) * totalWidth
	local tileSize = 32
	self.absorbBar.overlay:SetTexCoord(0, barSize / tileSize, 0, totalHeight / tileSize)
end

function module:UpdatePredictionStatusBar(prediction, parent, name)
	if not (prediction and parent) then return end
	if name == "Health" then
		self:Configure_HealComm(parent:GetParent())
	end
end

function module:HealPrediction()
	if E.private.unitframe.enable ~= true or E.db.mui.unitframes.healPrediction ~= true then return end

	hooksecurefunc(UF, "Configure_HealComm", module.Configure_HealComm)
	hooksecurefunc(UF, "UpdatePredictionStatusBar", module.UpdatePredictionStatusBar)

	for _, object in pairs(_G.ElvUF.objects) do
		if object.HealthPrediction and object.HealthPrediction.PostUpdate then
			hooksecurefunc(object.HealthPrediction, "PostUpdate", module.UpdateHealComm)
		end
	end
end

