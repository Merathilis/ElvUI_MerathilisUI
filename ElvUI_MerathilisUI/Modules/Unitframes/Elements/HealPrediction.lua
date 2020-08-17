local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule("muiUnits")
local UF = E.UnitFrames
local ElvUF = ElvUF

local pairs = pairs
local UnitIsConnected = UnitIsConnected
local hooksecurefunc = hooksecurefunc

function module:Construct_HealComm(frame)
	local healPrediction = frame.HealthPrediction
	--healPrediction.absorbBar.overlay = healPrediction.absorbBar:CreateTexture(nil, "ARTWORK", nil, 1)
	--healPrediction.absorbBar.overlay:SetAllPoints(healPrediction.absorbBar:GetStatusBarTexture())
	--healPrediction.absorbBar.overlay:SetTexture("Interface\\RaidFrame\\Shield-Overlay", true, true)
	--healPrediction.absorbBar.overlay.tileSize = 32

	if not healPrediction.overAbsorb then
	    local overAbsorb = frame.Health:CreateTexture(nil, "OVERLAY")
	    overAbsorb:SetPoint('TOP')
	    overAbsorb:SetPoint('BOTTOM')
	    overAbsorb:SetPoint('LEFT', frame.Health, 'RIGHT')
	    overAbsorb:SetWidth(10)

	    healPrediction.overAbsorb = overAbsorb
	end
end

function module:Configure_HealComm(frame)
	if frame.db and frame.db.healPrediction and frame.db.healPrediction.enable then
		local healPrediction = frame.HealthPrediction

		if frame.db.health then
			local health = frame.Health
			local orientation = health:GetOrientation()
			local reverseFill = health:GetReverseFill()
			local overAbsorbTexture = "Interface\\RaidFrame\\Shield-Overshield"

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
		end
	end
end

do
	--local tileSize = 32
	function module:UpdateHealComm(unit, myIncomingHeal, otherIncomingHeal, absorb, healAbsorb, hasOverAbsorb, hasOverHealAbsorb, health, maxHealth)
		if --[[not self.absorbBar.overlay or]] not UnitIsConnected(unit) then return end

		--local totalWidth, totalHeight = self.frame.Health:GetSize()
		--local barSize = (absorb / maxHealth) * totalWidth
		--self.absorbBar.overlay:SetTexCoord(0, barSize / tileSize, 0, totalHeight / tileSize)

		if hasOverAbsorb and health == maxHealth then
			local db = self.frame.db and self.frame.db.healPrediction
			if db and db.absorbStyle == 'NORMAL' then
				self.absorbBar:SetValue(0)
			end
		end

		if self.absorbBar then
			self.absorbBar:SetStatusBarColor(0.66, 1, 1, .6)
		end

		if self.overAbsorb then
			self.overAbsorb:SetVertexColor(1, 1, 1, 1)
		end
	end
end

function module:HealPrediction()
	if E.private.unitframe.enable ~= true or E.db.mui.unitframes.healPrediction ~= true then return end

	hooksecurefunc(UF, "Construct_HealComm", module.Construct_HealComm)
	hooksecurefunc(UF, "Configure_HealComm", module.Configure_HealComm)

	for _, object in pairs(ElvUF.objects) do
		if object.HealthPrediction then
			module:Construct_HealComm(object)
			module:Configure_HealComm(object)

			if object.HealthPrediction.PostUpdate then
				hooksecurefunc(object.HealthPrediction, "PostUpdate", module.UpdateHealComm)
			end
		end
	end
end
