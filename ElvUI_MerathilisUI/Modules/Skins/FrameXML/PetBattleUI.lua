local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local S = E:GetModule("Skins")

local _G = _G

local C_PetBattles_GetPetType = C_PetBattles.GetPetType
local C_PetBattles_GetBreedQuality = C_PetBattles.GetBreedQuality
local C_PetBattles_GetNumPets = C_PetBattles.GetNumPets
local C_PetBattles_GetNumAuras = C_PetBattles.GetNumAuras
local C_PetBattles_GetAuraInfo = C_PetBattles.GetAuraInfo

local hooksecurefunc = hooksecurefunc

function module:PetBattleUI()
	if not module:CheckDB("petbattleui", "petBattle") then
		return
	end

	-- Head Frame
	local frame = _G.PetBattleFrame
	frame.TopVersusText:SetPoint("TOP", 0, -45)

	-- Weather
	local weather = frame.WeatherFrame
	weather:ClearAllPoints()
	weather:SetPoint("TOP", frame.TopVersusText, "BOTTOM", 0, -15)
	weather.Icon:ClearAllPoints()
	weather.Icon:SetPoint("TOP", frame.TopVersusText, "BOTTOM", 0, -15)

	weather.Duration:ClearAllPoints()
	weather.Duration:SetPoint("CENTER", weather.Icon, 1, 0)

	-- Current Pets
	local units = { frame.ActiveAlly, frame.ActiveEnemy }
	for index, unit in pairs(units) do
		unit.petIcon = unit:CreateTexture(nil, "ARTWORK")
		unit.petIcon:SetSize(25, 25)
		S:HandleIcon(unit.petIcon, true)

		if unit.SpeedIcon then
			unit.SpeedUnderlay:SetAlpha(0)
			unit.SpeedIcon:SetSize(30, 30)
			unit.SpeedIcon:ClearAllPoints()
		end

		if index == 1 then
			unit.ActualHealthBar:SetGradient("VERTICAL", CreateColor(0.26, 1, 0.22, 1), CreateColor(0.13, 0.5, 0.11, 1))
			unit.Name:SetPoint("LEFT", unit.petIcon, "RIGHT", 5, 0)
			unit.Level:SetPoint("BOTTOMLEFT", unit.Icon, 2, 2)
			if unit.SpeedIcon then
				unit.SpeedIcon:SetPoint("LEFT", unit.ActualHealthBar.backdrop, "RIGHT", 5, 0)
				unit.SpeedIcon:SetTexCoord(0, 0.5, 0.5, 1)
			end
		else
			unit.ActualHealthBar:SetGradient("VERTICAL", CreateColor(1, 0.12, 0.24, 1), CreateColor(0.5, 0.06, 0.12, 1))
			unit.Name:SetPoint("RIGHT", unit.petIcon, "LEFT", -5, 0)
			unit.Level:SetPoint("BOTTOMRIGHT", unit.Icon, 2, 2)
			if unit.SpeedIcon then
				unit.SpeedIcon:SetPoint("RIGHT", unit.ActualHealthBar.backdrop, "LEFT", -5, 0)
				unit.SpeedIcon:SetTexCoord(0.5, 0, 0.5, 1)
			end
		end
	end

	-- Pending Pets
	local buddy = { frame.Ally2, frame.Ally3, frame.Enemy2, frame.Enemy3 }
	for index, unit in pairs(buddy) do
		unit:ClearAllPoints()
		unit.HealthBarBG:SetAlpha(0)
		unit.HealthDivider:SetAlpha(0)
		unit.BorderAlive:SetAlpha(0)
		unit.BorderDead:SetAlpha(0)

		unit.deadIcon = unit:CreateTexture(nil, "ARTWORK")
		unit.deadIcon:SetAllPoints(unit.Icon)
		unit.deadIcon:SetTexture("Interface\\PETBATTLES\\DeadPetIcon")
		unit.deadIcon:Hide()

		unit.healthBarWidth = 36
		unit.ActualHealthBar:ClearAllPoints()
		unit.ActualHealthBar:SetPoint("TOPLEFT", unit.Icon, "BOTTOMLEFT", 1, -4)
		unit.ActualHealthBar:CreateBackdrop("Transparent")
		unit.ActualHealthBar.backdrop:ClearAllPoints()
		unit.ActualHealthBar.backdrop:SetPoint("TOPLEFT", unit.ActualHealthBar, -E.mult, E.mult)
		unit.ActualHealthBar.backdrop:SetPoint("BOTTOMLEFT", unit.ActualHealthBar, -E.mult, -E.mult)
		unit.ActualHealthBar.backdrop:SetWidth(unit.healthBarWidth + 2 * E.mult)
		unit.ActualHealthBar.backdrop:OffsetFrameLevel(nil, unit)

		if index < 3 then
			unit.ActualHealthBar:SetGradient("VERTICAL", CreateColor(0.26, 1, 0.22, 1), CreateColor(0.13, 0.5, 0.11, 1))
		else
			unit.ActualHealthBar:SetGradient("VERTICAL", CreateColor(1, 0.12, 0.24, 1), CreateColor(0.5, 0.06, 0.12, 1))
		end
	end
	frame.Ally2:SetPoint("BOTTOMRIGHT", frame.ActiveAlly, "BOTTOMLEFT", -10, 20)
	frame.Ally3:SetPoint("BOTTOMRIGHT", frame.Ally2, "BOTTOMLEFT", -8, 0)
	frame.Enemy2:SetPoint("BOTTOMLEFT", frame.ActiveEnemy, "BOTTOMRIGHT", 10, 20)
	frame.Enemy3:SetPoint("BOTTOMLEFT", frame.Enemy2, "BOTTOMRIGHT", 8, 0)

	-- Update Status
	hooksecurefunc("PetBattleUnitFrame_UpdatePetType", function(self)
		if self.PetType and self.petIcon then
			local petType = C_PetBattles_GetPetType(self.petOwner, self.petIndex)
			self.petIcon:SetTexture("Interface\\ICONS\\Icon_PetFamily_" .. PET_TYPE_SUFFIX[petType])
		end
	end)
	hooksecurefunc("PetBattleUnitFrame_UpdateDisplay", function(self)
		local petOwner = self.petOwner
		if (not petOwner) or self.petIndex > C_PetBattles_GetNumPets(petOwner) then
			return
		end

		if self.Icon then
			if petOwner == Enum.BattlePetOwner.Ally then
				self.Icon:SetTexCoord(0.92, 0.08, 0.08, 0.92)
			else
				self.Icon:SetTexCoord(unpack(E.TexCoords))
			end
		end
		if self.glow then
			self.glow:Hide()
		end
		if self.Icon.backdrop then
			local quality = C_PetBattles_GetBreedQuality(self.petOwner, self.petIndex) or 1
			local color = E:GetQualityColor(quality)
			self.Icon.backdrop:SetBackdropBorderColor(color.r, color.g, color.b)
		end
	end)
	hooksecurefunc("PetBattleUnitFrame_UpdateHealthInstant", function(self)
		if self.BorderDead and self.BorderDead:IsShown() and self.Icon.backdrop then
			self.Icon.backdrop:SetBackdropBorderColor(1, 0.12, 0.24)
		end
		if self.BorderDead and self.deadIcon then
			self.deadIcon:SetShown(self.BorderDead:IsShown())
		end
	end)
	hooksecurefunc("PetBattleAuraHolder_Update", function(self)
		if not self.petOwner or not self.petIndex then
			return
		end

		local nextFrame = 1
		for i = 1, C_PetBattles_GetNumAuras(self.petOwner, self.petIndex) do
			local _, _, _, isBuff = C_PetBattles_GetAuraInfo(self.petOwner, self.petIndex, i)
			if (isBuff and self.displayBuffs) or (not isBuff and self.displayDebuffs) then
				local frame = self.frames[nextFrame]
				frame.DebuffBorder:Hide()
				if not frame.MERSkin then
					S:HandleIcon(frame.Icon, true)
					frame.MERSkin = true
				end

				nextFrame = nextFrame + 1
			end
		end
	end)
end

module:AddCallback("PetBattleUI")
