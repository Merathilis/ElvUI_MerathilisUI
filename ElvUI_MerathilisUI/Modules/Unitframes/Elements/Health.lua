local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_UnitFrames')
local UF = E:GetModule('UnitFrames')
local S = MER:GetModule('MER_Skins')

local buttonclass

function module:UnitFrames_UpdateNameSettings(_, f)
	if f.shadow then return end

	S:CreateBackdropShadow(f.Health, true)
	if f.USE_PORTRAIT then
		S:CreateBackdropShadow(f.Portrait, true)
	end
end

function module:ApplyUnitGradient(unit, name)
	if UnitExists(unit) then
		local _, classunit = UnitClass(unit)
		local reaction = UnitReaction(unit, "player")
		local unitframe = _G["ElvUF_" .. name]


		local isPlayer = UnitIsPlayer(unit)
		local isCharmed = UnitIsCharmed(unit)
		local isActualPlayer = false

		if unitframe and unitframe.Health then
			if unitframe.realUnit then
				if name == "Player" and unitframe.unit == "vehicle" then
					isPlayer = false
					isActualPlayer = false
				end
				if name == "Pet" and unitframe.unit == "player" then
					isPlayer = true
					isActualPlayer = true
					classunit = E.myclass
				end
			end

			if (isPlayer and not isCharmed) or isActualPlayer then
				if E.db.mui.gradient.customColor.enableUF then
					unitframe.Health:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColorsCustom(classunit, false, E.db.unitframe.colors.transparentHealth, false, false, true))
				else
					unitframe.Health:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColors(classunit, false, E.db.unitframe.colors.transparentHealth, false, false, true))
				end
			else
				if E.db.mui.gradient.customColor.enableUF then
					if UnitIsTapDenied(unit) and not UnitPlayerControlled(unit) then
						unitframe.Health:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColorsCustom("TAPPED"))
					else
						if reaction and reaction >= 5 then
							unitframe.Health:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColorsCustom("NPCFRIENDLY"))
						elseif reaction and reaction == 4 then
							unitframe.Health:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColorsCustom("NPCNEUTRAL"))
						elseif reaction and reaction == 3 then
							unitframe.Health:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColorsCustom("NPCUNFRIENDLY"))
						elseif reaction and reaction == 2 or reaction == 1 then
							unitframe.Health:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColorsCustom("NPCHOSTILE"))
						end
					end
				else
					if UnitIsPlayer(unit) and not UnitIsCharmed(unit) then
						if unit == "target" then
							unitframe.Health:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColors(classunit, true, true))
						else
							unitframe.Health:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColors(classunit, false, true))
						end
					else
						if UnitIsTapDenied(unit) and not UnitPlayerControlled(unit) then
							unitframe.Health:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColors("TAPPED", true, true))
						else
							if reaction and reaction >= 5 then
								unitframe.Health:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColors("NPCFRIENDLY", true, true))
							elseif reaction and reaction == 4 then
								unitframe.Health:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColors("NPCNEUTRAL", true, true))
							elseif reaction and reaction == 3 then
								unitframe.Health:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColors("NPCUNFRIENDLY", true, true))
							elseif reaction and reaction == 2 or reaction == 1 then
								unitframe.Health:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColors("NPCHOSTILE", true, true))
							end
						end
					end
				end
			end
		end
	end
end

function module:ApplyGroupGradient(button)
	if UnitIsPlayer(button.unit) then
		_, buttonclass = UnitClass(button.unit)
	else
		buttonclass = "NPCFRIENDLY"
	end

	if buttonclass and button.Health then
		if E.db.mui.gradient.customColor.enableUF then
			button.Health:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColorsCustom(buttonclass, false, E.db.unitframe.colors.transparentHealth, false, false, true))
		else
			button.Health:GetStatusBarTexture():SetGradient("HORIZONTAL", F.GradientColors(buttonclass, false, E.db.unitframe.colors.transparentHealth, false, false, true))
		end
	end
end

local forced = false
function module:Configure_GradientBackdropColor(unit)
	local colorDB = E.db.mui.gradient
	if not colorDB.enable then
		return
	end

	module:ApplyUnitGradient("player", "Player")
	if UnitExists("target") then
		module:ApplyUnitGradient("target", "Target")
	end
	if UnitExists("targettarget") then
		module:ApplyUnitGradient("targettarget", "TargetTarget")
	end
	if UnitExists("targettargettarget") then
		module:ApplyUnitGradient("targettargettarget", "TargetTargetTarget")
	end
	if UnitExists("pet") then
		module:ApplyUnitGradient("pet", "Pet")
	end

	if UnitExists("boss1") then
		module:ApplyUnitGradient("boss1", "Boss1")
	end
	if UnitExists("boss2") then
		module:ApplyUnitGradient("boss2", "Boss2")
	end
	if UnitExists("boss3") then
		module:ApplyUnitGradient("boss3", "Boss3")
	end
	if UnitExists("boss4") then
		module:ApplyUnitGradient("boss4", "Boss4")
	end
	if UnitExists("boss5") then
		module:ApplyUnitGradient("boss5", "Boss5")
	end
	if UnitExists("boss6") then
		module:ApplyUnitGradient("boss6", "Boss6")
	end
	if UnitExists("boss7") then
		module:ApplyUnitGradient("boss7", "Boss7")
	end
	if UnitExists("boss8") then
		module:ApplyUnitGradient("boss8", "Boss8")
	end
	if UnitExists("focus") then
		module:ApplyUnitGradient("focus", "Focus")
	end
	if UnitExists("focustarget") then
		module:ApplyUnitGradient("focustarget", "FocusTarget")
	end
	if UnitExists("arena1") then
		module:ApplyUnitGradient("arena1", "Arena1")
	end
	if UnitExists("arena2") then
		module:ApplyUnitGradient("arena2", "Arena2")
	end
	if UnitExists("arena3") then
		module:ApplyUnitGradient("arena3", "Arena3")
	end
	if UnitExists("arena4") then
		module:ApplyUnitGradient("arena4", "Arena4")
	end
	if UnitExists("arena5") then
		module:ApplyUnitGradient("arena5", "Arena5")
	end

	if unit == "testunit" then
		forced = true
		unit = "player"
	else
		forced = false
	end

	if forced then
		module:ApplyUnitGradient("player", "Boss1")
		module:ApplyUnitGradient("player", "Boss2")
		module:ApplyUnitGradient("player", "Boss3")
		module:ApplyUnitGradient("player", "Boss4")
		module:ApplyUnitGradient("player", "Boss5")
		module:ApplyUnitGradient("player", "Boss6")
		module:ApplyUnitGradient("player", "Boss7")
		module:ApplyUnitGradient("player", "Boss8")
		module:ApplyUnitGradient("player", "Arena1")
		module:ApplyUnitGradient("player", "Arena2")
		module:ApplyUnitGradient("player", "Arena3")
		module:ApplyUnitGradient("player", "Arena4")
		module:ApplyUnitGradient("player", "Arena5")
	end

	if (IsInGroup() and UnitExists(unit)) or forced then
		if _G["ElvUF_Party"] and _G["ElvUF_Party"]:IsShown() then
			local partymembers = { _G["ElvUF_PartyGroup1"]:GetChildren() }
			for _, frame in pairs(partymembers) do
				if frame and frame.Health then
					module:ApplyGroupGradient(frame)
				end
			end
		end
	end

	if _G["ElvUF_Raid1"] and _G["ElvUF_Raid1"]:IsShown() then
		for i = 1, 8 do
			if _G["ElvUF_Raid1Group" .. i] then
				local raidmembers = { _G["ElvUF_Raid1Group" .. i]:GetChildren() }
				for _, frame in pairs(raidmembers) do
					if frame and frame.Health then
						module:ApplyGroupGradient(frame)
					end
				end
			end
		end
	end

	if _G["ElvUF_Raid2"] and _G["ElvUF_Raid2"]:IsShown() then
		for i = 1, 8 do
			if _G["ElvUF_Raid2Group" .. i] then
				local raidmembers = { _G["ElvUF_Raid2Group" .. i]:GetChildren() }
				for _, frame in pairs(raidmembers) do
					if frame and frame.Health then
						module:ApplyGroupGradient(frame)
					end
				end
			end
		end
	end

	if _G["ElvUF_Raid3"] and _G["ElvUF_Raid3"]:IsShown() then
		for i = 1, 8 do
			if _G["ElvUF_Raid3Group" .. i] then
				local raidmembers = { _G["ElvUF_Raid3Group" .. i]:GetChildren() }
				for _, frame in pairs(raidmembers) do
					if frame and frame.Health then
						module:ApplyGroupGradient(frame)
					end
				end
			end
		end
	end
end

hooksecurefunc(UF, "PostUpdateHealthColor", module.Configure_GradientBackdropColor)
hooksecurefunc(UF, "ToggleForceShowGroupFrames", function()
	module:Configure_GradientBackdropColor("testunit")
end)
hooksecurefunc(UF, "HeaderConfig", function()
	module:Configure_GradientBackdropColor("testunit")
end)
