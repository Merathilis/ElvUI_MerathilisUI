local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnitFrames")
local UF = E:GetModule("UnitFrames")
local LSM = E.LSM

local _, powertype, unitframe
local headergroup, group, groupbutton

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

local forced = false
function module:ApplyUnitGradientPower(unit, name)
	if unit == "testunit" then
		forced = true
		unit = "player"
	else
		forced = false
	end

	_, powertype = UnitPowerType(unit)
	if UnitExists(unit) and powertype then
		unitframe = _G["ElvUF_" .. name]
		if unitframe and unitframe.Power then
			if powertypes and powertypes[powertype] then
				if E.db.mui.gradient.customColor.enablePower then
					if unit == "target" then
						if E.db.unitframe.colors.transparentPower then
							unitframe.Power.backdrop.Center:SetGradient(
								"HORIZONTAL",
								F.GradientColorsCustom(powertype, true, true)
							)
						else
							unitframe.Power
								:GetStatusBarTexture()
								:SetGradient("HORIZONTAL", F.GradientColorsCustom(powertype, true, false))
						end
						if not E.db.unitframe.colors.custompowerbackdrop then
							if unitframe.Power and unitframe.Power.BG then
								unitframe.Power.BG:SetGradient(
									"HORIZONTAL",
									F.GradientColorsCustom(powertype, true, false, true)
								)
							end
						end
					else
						if E.db.unitframe.colors.transparentPower then
							unitframe.Power.backdrop.Center:SetGradient(
								"HORIZONTAL",
								F.GradientColorsCustom(powertype, false, true)
							)
						else
							unitframe.Power
								:GetStatusBarTexture()
								:SetGradient("HORIZONTAL", F.GradientColorsCustom(powertype, false, false))
						end
						if not E.db.unitframe.colors.custompowerbackdrop then
							unitframe.Power.BG:SetGradient(
								"HORIZONTAL",
								F.GradientColorsCustom(powertype, false, false, true)
							)
						end
					end
				else
					if unit == "target" then
						if E.db.unitframe.colors.transparentPower then
							unitframe.Power.backdrop.Center:SetGradient(
								"HORIZONTAL",
								F.GradientColors(powertype, true, true)
							)
						else
							unitframe.Power
								:GetStatusBarTexture()
								:SetGradient("HORIZONTAL", F.GradientColors(powertype, true, false))
						end
						if not E.db.unitframe.colors.custompowerbackdrop then
							unitframe.Power.BG:SetGradient("HORIZONTAL", F.GradientColors(powertype, true, false, true))
						end
					else
						if E.db.unitframe.colors.transparentPower then
							unitframe.Power.backdrop.Center:SetGradient(
								"HORIZONTAL",
								F.GradientColors(powertype, false, true)
							)
						else
							unitframe.Power
								:GetStatusBarTexture()
								:SetGradient("HORIZONTAL", F.GradientColors(powertype, false, false))
						end
						if not E.db.unitframe.colors.custompowerbackdrop then
							unitframe.Power.BG:SetGradient(
								"HORIZONTAL",
								F.GradientColors(powertype, false, false, true)
							)
						end
					end
				end
			end
		end
	end
end

function module:ApplyGroupGradientPower(groupunitframe)
	if groupunitframe and groupunitframe.unit then
		_, powertype = UnitPowerType(groupunitframe.unit)
		if powertype then
			if groupunitframe.Power then
				if E.db.unitframe.colors.transparentPower and E.db.unitframe.colors.custompowerbackdrop then --fix transparent power custom backdrop
					groupunitframe.Power.backdrop.Center:SetTexture(E.LSM:Fetch("statusbar", E.db.unitframe.statusbar))
					groupunitframe.Power.BG:SetVertexColor(
						E.db.unitframe.colors.power_backdrop.r,
						E.db.unitframe.colors.power_backdrop.g,
						E.db.unitframe.colors.power_backdrop.b,
						E.db.general.backdropfadecolor.a
					)
				end
				if powertypes and powertypes[powertype] then
					if E.db.mui.gradient.customColor.enablePower then
						if E.db.unitframe.colors.transparentPower then
							groupunitframe.Power.backdrop.Center:SetGradient(
								"HORIZONTAL",
								F.GradientColorsCustom(powertype, false, true)
							)
						else
							groupunitframe.Power
								:GetStatusBarTexture()
								:SetGradient("HORIZONTAL", F.GradientColorsCustom(powertype, false, false))
						end
						if not E.db.unitframe.colors.custompowerbackdrop then
							groupunitframe.Power.BG:SetGradient(
								"HORIZONTAL",
								F.GradientColorsCustom(powertype, false, false, true)
							)
						end
					else
						if E.db.unitframe.colors.transparentPower then
							groupunitframe.Power.backdrop.Center:SetGradient(
								"HORIZONTAL",
								F.GradientColors(powertype, false, true)
							)
						else
							groupunitframe.Power
								:GetStatusBarTexture()
								:SetGradient("HORIZONTAL", F.GradientColors(powertype, false, false))
						end
						if not E.db.unitframe.colors.custompowerbackdrop then
							groupunitframe.Power.BG:SetGradient(
								"HORIZONTAL",
								F.GradientColors(powertype, false, false, true)
							)
						end
					end
				else
					local r, g, b = groupunitframe.Power:GetStatusBarColor()
					if r ~= 1 and g ~= 1 and b ~= 1 then
						groupunitframe.Power:GetStatusBarTexture():SetGradient(
							"HORIZONTAL",
							{ r = r - 0.4, g = g - 0.4, b = b - 0.4, a = 1 },
							{ r = r + 0.2, g = g + 0.2, b = b + 0.2, a = 1 }
						)
						if not E.db.unitframe.colors.custompowerbackdrop then
							groupunitframe.Power.BG:SetGradient(
								"HORIZONTAL",
								{ r = (r - 0.4) - 0.05, g = (g - 0.4) - 0.05, b = (b - 0.4) - 0.05, a = 1 },
								{ r = (r + 0.2) - 0.05, g = (g + 0.2) - 0.05, b = (b + 0.2) - 0.05, a = 1 }
							)
						end
					end
				end
			end

			if groupunitframe.AlternativePower then
				local r, g, b = groupunitframe.AlternativePower:GetStatusBarColor()
				if r ~= 1 and g ~= 1 and b ~= 1 then
					groupunitframe.AlternativePower:GetStatusBarTexture():SetGradient(
						"HORIZONTAL",
						{ r = r - 0.4, g = g - 0.4, b = b - 0.4, a = 1 },
						{ r = r + 0.2, g = g + 0.2, b = b + 0.2, a = 1 }
					)
					if not E.db.unitframe.colors.custompowerbackdrop then
						groupunitframe.AlternativePower.BG:SetGradient(
							"HORIZONTAL",
							{ r = (r - 0.4) - 0.05, g = (g - 0.4) - 0.05, b = (b - 0.4) - 0.05, a = 1 },
							{ r = (r + 0.2) - 0.05, g = (g + 0.2) - 0.05, b = (b + 0.2) - 0.05, a = 1 }
						)
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
	module:ApplyUnitGradientPower("target", "Target")
	module:ApplyUnitGradientPower("targettarget", "TargetTarget")
	module:ApplyUnitGradientPower("pet", "Pet")
	module:ApplyUnitGradientPower("targettargettarget", "TargetTargetTarget")

	module:ApplyUnitGradientPower("boss1", "Boss1")
	module:ApplyUnitGradientPower("boss2", "Boss2")
	module:ApplyUnitGradientPower("boss3", "Boss3")
	module:ApplyUnitGradientPower("boss4", "Boss4")
	module:ApplyUnitGradientPower("boss5", "Boss5")
	module:ApplyUnitGradientPower("boss6", "Boss6")
	module:ApplyUnitGradientPower("boss7", "Boss7")
	module:ApplyUnitGradientPower("boss8", "Boss8")
	module:ApplyUnitGradientPower("focus", "Focus")
	module:ApplyUnitGradientPower("focustarget", "FocusTarget")
	module:ApplyUnitGradientPower("arena1", "Arena1")
	module:ApplyUnitGradientPower("arena2", "Arena2")
	module:ApplyUnitGradientPower("arena3", "Arena3")
	module:ApplyUnitGradientPower("arena4", "Arena4")
	module:ApplyUnitGradientPower("arena5", "Arena5")

	if unit == "testunit" then
		forced = true
	else
		forced = false
	end

	module:ApplyUnitGradientPower("testunit", "Boss1")
	module:ApplyUnitGradientPower("testunit", "Boss2")
	module:ApplyUnitGradientPower("testunit", "Boss3")
	module:ApplyUnitGradientPower("testunit", "Boss4")
	module:ApplyUnitGradientPower("testunit", "Boss5")
	module:ApplyUnitGradientPower("testunit", "Boss6")
	module:ApplyUnitGradientPower("testunit", "Boss7")
	module:ApplyUnitGradientPower("testunit", "Boss8")
	module:ApplyUnitGradientPower("testunit", "Focus")
	module:ApplyUnitGradientPower("testunit", "FocusTarget")
	module:ApplyUnitGradientPower("testunit", "Arena1")
	module:ApplyUnitGradientPower("testunit", "Arena2")
	module:ApplyUnitGradientPower("testunit", "Arena3")
	module:ApplyUnitGradientPower("testunit", "Arena4")
	module:ApplyUnitGradientPower("testunit", "Arena5")

	--group/raid unitframes
	if IsInGroup() or forced then
		headergroup = nil
		if
			_G["ElvUF_Raid1"]
			and _G["ElvUF_Raid1"]:IsShown()
			and E.db["unitframe"]["units"]["raid1"]["power"]["enable"]
		then
			headergroup = _G["ElvUF_Raid1"]
		elseif
			_G["ElvUF_Raid2"]
			and _G["ElvUF_Raid2"]:IsShown()
			and E.db["unitframe"]["units"]["raid2"]["power"]["enable"]
		then
			headergroup = _G["ElvUF_Raid2"]
		elseif
			_G["ElvUF_Raid3"]
			and _G["ElvUF_Raid3"]:IsShown()
			and E.db["unitframe"]["units"]["raid3"]["power"]["enable"]
		then
			headergroup = _G["ElvUF_Raid3"]
		elseif
			_G["ElvUF_Party"]
			and _G["ElvUF_Party"]:IsShown()
			and E.db["unitframe"]["units"]["party"]["power"]["enable"]
		then
			headergroup = _G["ElvUF_Party"]
		end
		if headergroup ~= nil then
			for i = 1, headergroup:GetNumChildren() do
				group = select(i, headergroup:GetChildren())
				for j = 1, group:GetNumChildren() do
					groupbutton = select(j, group:GetChildren())
					if groupbutton and groupbutton.Power and groupbutton.Power:IsShown() and groupbutton.unit then
						module:ApplyGroupGradientPower(groupbutton)
					end
				end
			end
		end
	end
end

hooksecurefunc(UF, "Construct_PowerBar", module.Configure_GradientPower)
hooksecurefunc(UF, "PostUpdatePowerColor", module.Configure_GradientPower)

function module:UFClassPower_SetBarColor(bar, r, g, b, custom_backdrop)
	if not E.db.mui.gradient.enable then
		return
	end

	bar:GetStatusBarTexture()
		:SetGradient("HORIZONTAL", { r = r - 0.3, g = g - 0.3, b = b - 0.3, a = 1 }, { r = r, g = g, b = b, a = 1 })
	if E.db.unitframe.units.player.classbar.fill == "spaced" then
		bar.bg:SetAlpha(0)

		if E.db.unitframe.colors.customclasspowerbackdrop then
			bar.backdrop.Center:SetVertexColor(
				E.db.unitframe.colors.classpower_backdrop.r,
				E.db.unitframe.colors.classpower_backdrop.g,
				E.db.unitframe.colors.classpower_backdrop.b
			)
		end
	else
		bar.bg:SetAlpha(E.db.general.backdropfadecolor.a)
	end
end

hooksecurefunc(UF, "ClassPower_SetBarColor", module.UFClassPower_SetBarColor)
