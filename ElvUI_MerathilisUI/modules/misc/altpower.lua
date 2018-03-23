local MER, E, L, V, P, G = unpack(select(2, ...))
local MI = E:GetModule("mUIMisc")

--Cache global variables

--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

function MI:AltPowerBar()
	local powerbar = CreateFrame("StatusBar", "mUI Alt Power", E.UIParent)
	powerbar:SetTemplate("Transparent")
	powerbar:SetStatusBarTexture(E.media.normTex)
	powerbar:SetMinMaxValues(0, 200)
	powerbar:SetSize(200, 20)
	powerbar:SetStatusBarColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)
	powerbar:SetPoint("CENTER", E.UIParent, "TOP", 0, -80)
	powerbar:Hide()

	E:CreateMover(powerbar, "mUI_AltPowerMover", L["mUI Alt PowerBar"], nil, nil, nil, "ALL,PARTY,RAID")

	powerbar.text = powerbar:CreateFontString(nil, "OVERLAY")
	powerbar.text:FontTemplate(nil, 13, "OUTLINE")
	powerbar.text:SetPoint("CENTER", powerbar, "CENTER")
	powerbar.text:SetJustifyH("CENTER")

	--Event handling
	powerbar:RegisterEvent("UNIT_POWER")
	powerbar:RegisterEvent("UNIT_POWER_BAR_SHOW")
	powerbar:RegisterEvent("UNIT_POWER_BAR_HIDE")
	powerbar:RegisterEvent("PLAYER_ENTERING_WORLD")
	powerbar:SetScript("OnEvent", function(self, event, arg1)
		if not powerbar then
			PlayerPowerBarAlt:RegisterEvent("UNIT_POWER_BAR_SHOW")
			PlayerPowerBarAlt:RegisterEvent("UNIT_POWER_BAR_HIDE")
			PlayerPowerBarAlt:RegisterEvent("PLAYER_ENTERING_WORLD")
			if (event == "UNIT_POWER_BAR_SHOW") then
				PlayerPowerBarAlt:Show()
			end

			self:Hide()

			return
		else
			PlayerPowerBarAlt:UnregisterEvent("UNIT_POWER_BAR_SHOW")
			PlayerPowerBarAlt:UnregisterEvent("UNIT_POWER_BAR_HIDE")
			PlayerPowerBarAlt:UnregisterEvent("PLAYER_ENTERING_WORLD")
			PlayerPowerBarAlt:Hide()
			if UnitAlternatePowerInfo("player") or UnitAlternatePowerInfo("target") then
				self:Show()

				self:SetMinMaxValues(0, UnitPowerMax("player", ALTERNATE_POWER_INDEX))
				local power = UnitPower("player", ALTERNATE_POWER_INDEX)
				local mpower = UnitPowerMax("player", ALTERNATE_POWER_INDEX)
				local perc = mpower > 0 and floor(power/mpower*100) or 0
				self:SetValue(power)
				self.text:SetText(power.."/"..mpower.." - "..perc.."%")
			else
				self:Hide()
			end
		end
	end)
end