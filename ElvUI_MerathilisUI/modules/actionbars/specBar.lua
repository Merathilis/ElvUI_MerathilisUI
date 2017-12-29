local MER, E, L, V, P, G = unpack(select(2, ...))
local MAB = E:GetModule("mUIActionbars")

--Cache global variables
--Lua functions
local _G = _G

--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

function MAB:SpecBar()
	if E.db.mui.actionbars.specBar ~= true then return end

	local SpecBar = CreateFrame("Frame", "SpecBar", E.UIParent)
	SpecBar:SetFrameStrata("BACKGROUND")
	SpecBar:SetFrameLevel(0)
	SpecBar:SetSize(40, 40)
	SpecBar:SetTemplate("Transparent")
	SpecBar:Styling()
	SpecBar:Point("BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -2, 177)

	SpecBar.Button = {}

	local Spacing, Mult = 4, 1
	local Size = 24
	local Specs = GetNumSpecializations()

	for i = 1, Specs do
		local ID, Name, Description, Icon = GetSpecializationInfo(i)
		SpecBar.Button[i] = CreateFrame("Button", "SpecBar.Button"..i, SpecBar)
		SpecBar.Button[i]:SetSize(Size, Size)
		SpecBar.Button[i]:SetID(i)
		SpecBar.Button[i]:SetTemplate()
		SpecBar.Button[i]:SetNormalTexture(Icon)
		SpecBar.Button[i]:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
		SpecBar.Button[i]:GetNormalTexture():SetInside()
		SpecBar.Button[i]:RegisterForClicks("AnyDown")
		SpecBar.Button[i]:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:AddLine(Name)
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(Description, true)
			GameTooltip:Show()
		end)
		SpecBar.Button[i]:SetScript("OnClick", function(self, button)
			if button == "LeftButton" then
				if self:GetID() ~= GetSpecialization() then
					SetSpecialization(self:GetID())
				end
			elseif button == "RightButton" then
				local SpecID = GetSpecializationInfo(self:GetID())
				if (GetLootSpecialization() == SpecID) then
					SpecID = 0
				end
				SetLootSpecialization(SpecID)
			end
		end)
		SpecBar.Button[i]:SetScript("OnLeave", GameTooltip_Hide)
		SpecBar.Button[i]:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
		SpecBar.Button[i]:RegisterEvent("PLAYER_ENTERING_WORLD")
		SpecBar.Button[i]:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED")
		SpecBar.Button[i]:SetScript("OnEvent", function(self)
			local Spec = GetSpecialization()
			if Spec == self:GetID() then
				self:SetBackdropBorderColor(0, 0.44, .87)
			else
				self:SetTemplate()
			end
			if (GetLootSpecialization() == GetSpecializationInfo(self:GetID())) and (GetLootSpecialization() ~= GetSpecializationInfo(Spec)) then
				self:SetBackdropBorderColor(1, 0.44, .4)
			end
		end)
		SpecBar.Button[i]:SetPoint("LEFT", i == 1 and SpecBar or SpecBar.Button[i - 1], i == 1 and "LEFT" or "RIGHT", Spacing, 0)
	end

	local BarWidth = (Spacing + ((Size * (Specs * Mult)) + ((Spacing * (Specs - 1)) * Mult) + (Spacing * Mult)))
	local BarHeight = (Spacing + (Size * Mult) + (Spacing * Mult))

	SpecBar:SetSize(BarWidth, BarHeight)

	if E.myclass == "HUNTER" then
		local Events = { "PET_BAR_UPDATE", "PET_BAR_HIDE", "PET_UI_UPDATE", "PLAYER_ENTERING_WORLD", "UPDATE_VEHICLE_ACTIONBAR" }

		local PetSpecBar = CreateFrame("Frame", "PetSpecBar", E.UIParent)
		PetSpecBar:SetFrameStrata("BACKGROUND")
		PetSpecBar:SetFrameLevel(0)
		PetSpecBar:SetSize(40, 40)
		PetSpecBar:SetTemplate("Transparent")
		PetSpecBar:Styling()
		PetSpecBar:SetPoint("RIGHT", SpecBar, "LEFT", -.5, 0)

		for _, Event in pairs(Events) do
			PetSpecBar:RegisterEvent(Event)
		end

		PetSpecBar:RegisterUnitEvent("UNIT_PET", "player")
		PetSpecBar:RegisterUnitEvent("UNIT_FLAGS", "pet")
		PetSpecBar:SetScript("OnEvent", function(self)
			self:SetShown(PetHasActionBar() and not UnitIsDead('pet') and not UnitAffectingCombat('player') and not C_PetBattles.IsInBattle() and UnitCreatureFamily('pet'))
		end)

		PetSpecBar.Button = {}

		local Specs = GetNumSpecializations(false, true)

		for i = 1, Specs do
			local ID, Name, Description, Icon = GetSpecializationInfo(i, false, true)
			PetSpecBar.Button[i] = CreateFrame("Button", "PetSpecBar.Button"..i, PetSpecBar)
			PetSpecBar.Button[i]:SetSize(Size, Size)
			PetSpecBar.Button[i]:SetID(i)
			PetSpecBar.Button[i]:SetTemplate()
			PetSpecBar.Button[i]:SetNormalTexture(Icon)
			PetSpecBar.Button[i]:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
			PetSpecBar.Button[i]:GetNormalTexture():SetInside()
			PetSpecBar.Button[i]:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				GameTooltip:AddLine(Name)
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine(Description, true)
				GameTooltip:Show()
			end)
			PetSpecBar.Button[i]:SetScript("OnClick", function(self)
				if i ~= GetSpecialization(nil, true) then
					SetSpecialization(i, true)
				end
			end)
			PetSpecBar.Button[i]:SetScript('OnLeave', GameTooltip_Hide)

			for _, Event in pairs(Events) do
				PetSpecBar.Button[i]:RegisterEvent(Event)
			end

			PetSpecBar.Button[i]:RegisterUnitEvent("UNIT_PET", "player")
			PetSpecBar.Button[i]:RegisterUnitEvent("UNIT_FLAGS", "pet")
			PetSpecBar.Button[i]:SetScript('OnEvent', function(self, event)
				if GetSpecialization(nil, true) == self:GetID() then
					self:SetBackdropBorderColor(0, 0.44, .87)
				else
					self:SetTemplate()
				end
			end)
			PetSpecBar.Button[i]:SetPoint("LEFT", i == 1 and PetSpecBar or PetSpecBar.Button[i - 1], i == 1 and "LEFT" or "RIGHT", Spacing, 0)
		end

		local BarWidth = (Spacing + ((Size * (Specs * Mult)) + ((Spacing * (Specs - 1)) * Mult) + (Spacing * Mult)))
		local BarHeight = (Spacing + (Size * Mult) + (Spacing * Mult))

		PetSpecBar:SetSize(BarWidth, BarHeight)
	end
end