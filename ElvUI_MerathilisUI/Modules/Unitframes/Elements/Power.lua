local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_UnitFrames')
local S = MER:GetModule('MER_Skins')
local UF = E:GetModule('UnitFrames')
local LSM = E.LSM

local _, powertype, unitframe

local powertypes = {
	["MANA"] = true,
	["RAGE"] = true,
	["FOCUS"] = true,
	["ENERGY"] = true,
	["RUNIC_POWER"] = true,
	["LUNAR_POWER"] = true,
	["ALT_POWER"] = true,
	["MAELSTROM"] = true,
	["INSANITY"] = true,
	["FURY"] = true,
	["PAIN"] = true,
}

function module:Configure_Power(frame)
	local db = frame.db
	local power = frame.Power
	power.origParent = frame

	if power and not power.__MERSkin then
		power:Styling()

		power.__MERSkin = true
	end
end

function module:UnitFrames_Configure_Power(_, f)
	if f.MERshadow then return end

	if f.USE_POWERBAR then
		local shadow = f.Power.backdrop.MERshadow
		if f.POWERBAR_DETACHED then
			if not shadow then
				S:CreateBackdropShadow(f.Power, true)
			else
				shadow:Show()
			end
		else
			if shadow then
				shadow:Hide()
			end
		end
	end
end

function module:ChangeUnitPowerBarTexture()
	local bar = LSM:Fetch("statusbar", E.db.mui.unitframes.power.texture)

	for _, frame in pairs(UF.units) do
		if frame.Power then
			frame.Power:SetStatusBarTexture(bar)
		end
	end
end

function module:ChangePowerBarTexture()
	module:ChangeUnitPowerBarTexture()
end

function module:ApplyUnitGradientPower(unit, name)
	if not unit then
		return
	end

	_, powertype = UnitPowerType(unit)
	if UnitExists(unit) and powertype then
		unitframe = _G["ElvUF_"..name]
		if unitframe and unitframe.Power then
			if powertypes and powertypes[powertype] then
				if E.db.mui.gradient.customColor.enablePower then
					if unit == "target" then
						if E.db.unitframe.colors.transparentPower then
							unitframe.Power.backdrop.Center:SetGradient("HORIZONTAL", F.GradientColorsCustom(powertype))
						else
							unitframe.Power:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColorsCustom(powertype))
						end
						if not E.db.unitframe.colors.custompowerbackdrop then
							if unitframe.Power and unitframe.Power.BG then
								unitframe.Power.BG:SetGradient("HORIZONTAL", F.GradientColorsCustom(powertype))
							end
						end
					else
						if E.db.unitframe.colors.transparentPower then
							unitframe.Power.backdrop.Center:SetGradient("HORIZONTAL", F.GradientColorsCustom(powertype))
						else
							unitframe.Power:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColorsCustom(powertype))
						end
						if not E.db.unitframe.colors.custompowerbackdrop then
							unitframe.Power.BG:SetGradient("HORIZONTAL", F.GradientColorsCustom(powertype))
						end
					end
				else
					if unit == "target" then
						if E.db.unitframe.colors.transparentPower then
							unitframe.Power.backdrop.Center:SetGradient("HORIZONTAL", F.GradientColors(powertype))
						else
							unitframe.Power:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColors(powertype))
						end
						if not E.db.unitframe.colors.custompowerbackdrop then
							if unitframe.Power and unitframe.Power.BG then
								unitframe.Power.BG:SetGradient("HORIZONTAL", F.GradientColors(powertype))
							end
						end
					else
						if E.db.unitframe.colors.transparentPower then
							unitframe.Power.backdrop.Center:SetGradient("HORIZONTAL", F.GradientColors(powertype))
						else
							unitframe.Power:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColors(powertype))
						end
						if not E.db.unitframe.colors.custompowerbackdrop then
							unitframe.Power.BG:SetGradient("HORIZONTAL", F.GradientColors(powertype))
						end
					end
				end
			end
		end
	end
end

function module:Configure_GradientPower(unit)
	local colorDB = E.db.mui.gradient
	if not colorDB.enable then
		return
	end

	module:ApplyUnitGradientPower("player", "Player")
end

hooksecurefunc(UF, "Construct_PowerBar", module.Configure_GradientPower)
hooksecurefunc(UF, "PostUpdatePowerColor", module.Configure_GradientPower)
