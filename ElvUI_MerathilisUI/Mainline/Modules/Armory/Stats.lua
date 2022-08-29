local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Armory')
local M = E:GetModule('Misc')
local LSM = E.LSM or E.Libs.LSM

local _G = _G
local unpack = unpack
local format = string.format
local math_min, math_max = math.min, math.max

local GetCombatRating, GetCombatRatingBonus = GetCombatRating, GetCombatRatingBonus
local GetMeleeHaste, UnitAttackSpeed = GetMeleeHaste, UnitAttackSpeed
local GetVersatilityBonus = GetVersatilityBonus
local GetMasteryEffect, Mastery_OnEnter = GetMasteryEffect, Mastery_OnEnter
local GetLifesteal = GetLifesteal
local GetAvoidance = GetAvoidance
local GetAverageItemLevel = GetAverageItemLevel
local GetDodgeChance, GetParryChance = GetDodgeChance, GetParryChance
local GetSpellCritChance, GetRangedCritChance, GetCritChance, GetCritChanceProvidesParryEffect = GetSpellCritChance, GetRangedCritChance, GetCritChance, GetCritChanceProvidesParryEffect
local GetCombatRatingBonusForCombatRatingValue = GetCombatRatingBonusForCombatRatingValue
local GetHaste = GetHaste
local BreakUpLargeNumbers = BreakUpLargeNumbers
local PaperDollFrame_SetLabelAndText = PaperDollFrame_SetLabelAndText
local UnitSex = UnitSex
local MovementSpeed_OnEnter, MovementSpeed_OnUpdate = MovementSpeed_OnEnter, MovementSpeed_OnUpdate
local UnitClass, GetSpecialization, GetSpecializationRole = UnitClass, GetSpecialization, GetSpecializationRole
local CreateFrame = CreateFrame

module.totalShown = 0
module.ScrollStepMultiplier = 5
module.OriginalPaperdollStats = PAPERDOLL_STATCATEGORIES

function module:BuildNewStats()
	module:CreateStatCategory("OffenseCategory", STAT_CATEGORY_ATTACK)
	module:CreateStatCategory("DefenseCategory", DEFENSE)

	module.ChangedStats = {
		[1] = {
			categoryFrame = "AttributesCategory",
			stats = {
				[1] = { stat = "STRENGTH", primary = LE_UNIT_STAT_STRENGTH },
				[2] = { stat = "AGILITY", primary = LE_UNIT_STAT_AGILITY },
				[3] = { stat = "INTELLECT", primary = LE_UNIT_STAT_INTELLECT },
				[4] = { stat = "STAMINA" },
				[5] = { stat = "HEALTH", option = true },
				[6] = { stat = "POWER", option = true },
				[7] = { stat = "ALTERNATEMANA", option = true, classes = {"PRIEST", "SHAMAN", "DRUID"} },
				[8] = { stat = "MOVESPEED", option = true },
			},
		},
		[2] = {
			categoryFrame = "OffenseCategory",
			stats = {
				[1] = { stat = "ATTACK_DAMAGE", option = true, hideAt = 0 },
				[2] = { stat = "ATTACK_AP", option = true, hideAt = 0 },
				[3] = { stat = "ATTACK_ATTACKSPEED", option = true, hideAt = 0 },
				[4] = { stat = "SPELLPOWER", option = true, hideAt = 0 },
				[5] = { stat = "MANAREGEN", option = true, power = "MANA" },
				[6] = { stat = "ENERGY_REGEN", option = true, power = "ENERGY", hideAt = 0, roles = {"TANK", "DAMAGER"}, classes = {"ROUGE", "DRUID", "MONK"} },
				[7] = { stat = "FOCUS_REGEN", option = true, power = "FOCUS", hideAt = 0, classes = {"HUNTER"} },
				[8] = { stat = "RUNE_REGEN", option = true, power = "RUNIC_POWER", hideAt = 0, classes = {"DEATHKNIGHT"} },
			},
		},
		[3] = {
			categoryFrame = "EnhancementsCategory",
			stats = {
				[1] = { stat = "CRITCHANCE", hideAt = 0 },
				[2] = { stat = "HASTE", hideAt = 0 },
				[3] = { stat = "MASTERY", hideAt = 0 },
				[4] = { stat = "VERSATILITY", hideAt = 0 },
				[5] = { stat = "LIFESTEAL", hideAt = 0 },
			},
		},
		[4] = {
			categoryFrame = "DefenseCategory",
			stats = {
				[1] = { stat = "ARMOR", roles = { "TANK" } },
				[2] = { stat = "AVOIDANCE", hideAt = 0 },
				[3] = { stat = "DODGE", roles = {"TANK"} },
				[4] = { stat = "PARRY", hideAt = 0, roles = {"TANK"} },
				[5] = { stat = "BLOCK", hideAt = 0, roles = {"TANK"} },
				[6] = { stat = "STAGGER", hideAt = 0, roles = {"TANK"}, classes = {"MONK"} },
			},
		},
	}
end

local function CharacterStatFrameCategoryTemplate(Button)
	local bg = Button.Background
	local r, g, b = unpack(E["media"].rgbvaluecolor)
	bg:SetTexture([[Interface\LFGFrame\UI-LFG-SEPARATOR]])
	bg:SetTexCoord(0, 0.6640625, 0, 0.3125)
	bg:ClearAllPoints()
	bg:Point("CENTER", 0, -5)
	bg:Size(210, 30)
	bg:SetVertexColor(r * 0.7, g * 0.7, b * 0.7)
end

function module:CreateStatCategory(catName, text, noop)
	if not _G["CharacterStatsPane"][catName] then
		_G["CharacterStatsPane"][catName] = CreateFrame("Frame", nil, _G["CharacterStatsPane"], "CharacterStatFrameCategoryTemplate")
		_G["CharacterStatsPane"][catName].Title:SetText(text)
		_G["CharacterStatsPane"][catName].Title:SetTextColor(unpack(E.media.rgbvaluecolor))
		_G["CharacterStatsPane"][catName]:StripTextures()

		CharacterStatFrameCategoryTemplate(_G["CharacterStatsPane"][catName])
	end

	return catName
end

--Replacing broken Blizz function and adding some decimals
function module:ReplaceBlizzGlobals()

	--Atteack speed
	function PaperDollFrame_SetAttackSpeed(statFrame, unit)
		local meleeHaste = GetMeleeHaste()
		local speed, offhandSpeed = UnitAttackSpeed(unit)
		local displaySpeedxt

		local displaySpeed = format("%.2f", speed)
		if ( offhandSpeed ) then
			offhandSpeed = format("%.2f", offhandSpeed)
		end
		if ( offhandSpeed ) then
			displaySpeedxt =  BreakUpLargeNumbers(displaySpeed).." / ".. offhandSpeed
		else
			displaySpeedxt =  BreakUpLargeNumbers(displaySpeed)
		end
		PaperDollFrame_SetLabelAndText(statFrame, WEAPON_SPEED, displaySpeed, false, speed)

		statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE..format(PAPERDOLLFRAME_TOOLTIP_FORMAT, ATTACK_SPEED).." "..displaySpeed..FONT_COLOR_CODE_CLOSE
		statFrame.tooltip2 = format(STAT_ATTACK_SPEED_BASE_TOOLTIP, BreakUpLargeNumbers(meleeHaste))

		statFrame:Show()
	end

	--Moving speed
	function PaperDollFrame_SetMovementSpeed(statFrame, unit)
		statFrame.wasSwimming = nil
		statFrame.unit = unit
		MovementSpeed_OnUpdate(statFrame)

		statFrame.onEnterFunc = MovementSpeed_OnEnter
		-- TODO: Fix if we decide to show movement speed
		-- statFrame:SetScript("OnUpdate", MovementSpeed_OnUpdate)

		statFrame:Show()
	end

	-- Versatility
	function PaperDollFrame_SetVersatility(statFrame, unit)
		if unit ~= "player" then
			statFrame:Hide()
			return
		end

		local versatility = GetCombatRating(CR_VERSATILITY_DAMAGE_DONE)
		local versatilityDamageBonus = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)
		local versatilityDamageTakenReduction = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_TAKEN) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_TAKEN)
		-- PaperDollFrame_SetLabelAndText Format Change
		PaperDollFrame_SetLabelAndText(statFrame, STAT_VERSATILITY, format("%.2f%%", versatilityDamageBonus) .. " / " .. format("%.2f%%", versatilityDamageTakenReduction), false, versatilityDamageBonus)

		statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE .. format(VERSATILITY_TOOLTIP_FORMAT, STAT_VERSATILITY, versatilityDamageBonus, versatilityDamageTakenReduction) .. FONT_COLOR_CODE_CLOSE
		statFrame.tooltip2 = format(CR_VERSATILITY_TOOLTIP, versatilityDamageBonus, versatilityDamageTakenReduction, BreakUpLargeNumbers(versatility), versatilityDamageBonus, versatilityDamageTakenReduction)

		statFrame:Show()
	end

	-- Mastery
	function PaperDollFrame_SetMastery(statFrame, unit)
		if unit ~= "player" then
			statFrame:Hide()
			return
		end
		--if (UnitLevel("player") < SHOW_MASTERY_LEVEL) then
			--statFrame:Hide()
			--return
		--end

		local mastery = GetMasteryEffect()
		-- PaperDollFrame_SetLabelAndText Format Change
		PaperDollFrame_SetLabelAndText(statFrame, STAT_MASTERY, format("%.2f%%", mastery), false, mastery)
		statFrame.onEnterFunc = Mastery_OnEnter
		statFrame:Show()
	end

	-- Leech (Lifesteal)
	function PaperDollFrame_SetLifesteal(statFrame, unit)
		if unit ~= "player" then
			statFrame:Hide()
			return
		end

		local lifesteal = GetLifesteal()
		-- PaperDollFrame_SetLabelAndText Format Change
		PaperDollFrame_SetLabelAndText(statFrame, STAT_LIFESTEAL, format("%.2f%%", lifesteal), false, lifesteal)
		statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE .. format(PAPERDOLLFRAME_TOOLTIP_FORMAT, STAT_LIFESTEAL) .. " " .. format("%.2f%%", lifesteal) .. FONT_COLOR_CODE_CLOSE

		statFrame.tooltip2 = format(CR_LIFESTEAL_TOOLTIP, BreakUpLargeNumbers(GetCombatRating(CR_LIFESTEAL)), GetCombatRatingBonus(CR_LIFESTEAL))

		statFrame:Show()
	end

	-- Avoidance
	function PaperDollFrame_SetAvoidance(statFrame, unit)
		if unit ~= "player" then
			statFrame:Hide()
			return
		end

		local avoidance = GetAvoidance()
		-- PaperDollFrame_SetLabelAndText Format Change
		PaperDollFrame_SetLabelAndText(statFrame, STAT_AVOIDANCE, format("%.2f%%", avoidance), false, avoidance)
		statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE .. format(PAPERDOLLFRAME_TOOLTIP_FORMAT, STAT_AVOIDANCE) .. " " .. format("%.2f%%", avoidance) .. FONT_COLOR_CODE_CLOSE

		statFrame.tooltip2 = format(CR_AVOIDANCE_TOOLTIP, BreakUpLargeNumbers(GetCombatRating(CR_AVOIDANCE)), GetCombatRatingBonus(CR_AVOIDANCE))

		statFrame:Show()
	end

	-- Dodge Chance
	function PaperDollFrame_SetDodge(statFrame, unit)
		if unit ~= "player" then
			statFrame:Hide()
			return
		end

		local chance = GetDodgeChance()
		-- PaperDollFrame_SetLabelAndText Format Change
		PaperDollFrame_SetLabelAndText(statFrame, STAT_DODGE, format("%.2f%%", chance), false, chance)
		statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE..format(PAPERDOLLFRAME_TOOLTIP_FORMAT, DODGE_CHANCE).." "..format("%.2f", chance).."%"..FONT_COLOR_CODE_CLOSE
		statFrame.tooltip2 = format(CR_DODGE_TOOLTIP, GetCombatRating(CR_DODGE), GetCombatRatingBonus(CR_DODGE))
		statFrame:Show()
	end

	-- Parry Chance
	function PaperDollFrame_SetParry(statFrame, unit)
		if unit ~= "player" then
			statFrame:Hide()
			return
		end

		local chance = GetParryChance()
		-- PaperDollFrame_SetLabelAndText Format Change
		PaperDollFrame_SetLabelAndText(statFrame, STAT_PARRY, format("%.2f%%", chance), false, chance)
		statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE..format(PAPERDOLLFRAME_TOOLTIP_FORMAT, PARRY_CHANCE).." "..format("%.2f", chance).."%"..FONT_COLOR_CODE_CLOSE
		statFrame.tooltip2 = format(CR_PARRY_TOOLTIP, GetCombatRating(CR_PARRY), GetCombatRatingBonus(CR_PARRY))
		statFrame:Show()
	end

	-- Crit Chance
	function PaperDollFrame_SetCritChance(statFrame, unit)
		if unit ~= "player" then
			statFrame:Hide()
			return
		end

		local rating
		local spellCrit, rangedCrit, meleeCrit
		local critChance

		-- Start at 2 to skip physical damage
		local holySchool = 2
		local minCrit = GetSpellCritChance(holySchool)
		statFrame.spellCrit = {}
		statFrame.spellCrit[holySchool] = minCrit

		for i = (holySchool+1), MAX_SPELL_SCHOOLS do
			spellCrit = GetSpellCritChance(i)
			minCrit = math_min(minCrit, spellCrit)
			statFrame.spellCrit[i] = spellCrit
		end
		spellCrit = minCrit
		rangedCrit = GetRangedCritChance()
		meleeCrit = GetCritChance()

		if (spellCrit >= rangedCrit and spellCrit >= meleeCrit) then
			critChance = spellCrit
			rating = CR_CRIT_SPELL
		elseif (rangedCrit >= meleeCrit) then
			critChance = rangedCrit
			rating = CR_CRIT_RANGED
		else
			critChance = meleeCrit
			rating = CR_CRIT_MELEE
		end

		-- PaperDollFrame_SetLabelAndText Format Change
		PaperDollFrame_SetLabelAndText(statFrame, STAT_CRITICAL_STRIKE, format("%.2f%%", critChance), false, critChance)

		statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE..format(PAPERDOLLFRAME_TOOLTIP_FORMAT, STAT_CRITICAL_STRIKE).." "..format("%.2f%%", critChance)..FONT_COLOR_CODE_CLOSE
		local extraCritChance = GetCombatRatingBonus(rating)
		local extraCritRating = GetCombatRating(rating)
		if (GetCritChanceProvidesParryEffect()) then
			statFrame.tooltip2 = format(CR_CRIT_PARRY_RATING_TOOLTIP, BreakUpLargeNumbers(extraCritRating), extraCritChance, GetCombatRatingBonusForCombatRatingValue(CR_PARRY, extraCritRating))
		else
			statFrame.tooltip2 = format(CR_CRIT_TOOLTIP, BreakUpLargeNumbers(extraCritRating), extraCritChance)
		end
		statFrame:Show()
	end

	-- Haste
	function PaperDollFrame_SetHaste(statFrame, unit)
		if unit ~= "player" then
			statFrame:Hide()
			return
		end

		local haste = GetHaste()
		local rating = CR_HASTE_MELEE

		local hasteFormatString
		if haste < 0 then
			hasteFormatString = RED_FONT_COLOR_CODE.."%s"..FONT_COLOR_CODE_CLOSE
		else
			hasteFormatString = "%s"
		end
		-- PaperDollFrame_SetLabelAndText Format Change
		PaperDollFrame_SetLabelAndText(statFrame, STAT_HASTE, format(hasteFormatString, format("%.2f%%", haste)), false, haste)
		statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE .. format(PAPERDOLLFRAME_TOOLTIP_FORMAT, STAT_HASTE) .. " " .. format(hasteFormatString, format("%.2f%%", haste)) .. FONT_COLOR_CODE_CLOSE

		local _, class = UnitClass(unit)
		statFrame.tooltip2 = _G["STAT_HASTE_"..class.."_TOOLTIP"]
		if (not statFrame.tooltip2) then
			statFrame.tooltip2 = STAT_HASTE_TOOLTIP
		end
		statFrame.tooltip2 = statFrame.tooltip2 .. format(STAT_HASTE_BASE_TOOLTIP, BreakUpLargeNumbers(GetCombatRating(rating)), GetCombatRatingBonus(rating))

		statFrame:Show()
	end
end

function module:UpdateCharacterItemLevel(frame, which)
	if not frame or which ~= 'Character' then return end

	if not E.db.general.itemLevel.displayCharacterInfo then return end
	local total, equipped = GetAverageItemLevel()
	if E.db.mui.armory.stats.IlvlFull then
		if E.db.mui.armory.stats.IlvlColor then
			local r, g, b = E:ColorGradient((equipped / total), 1, 0, 0, 1, 1, 0, 0, 1, 0)
			local avColor = E.db.mui.armory.stats.AverageColor
			frame.ItemLevelText:SetFormattedText('%s%.2f|r |cffffffff/|r %s%.2f|r', E:RGBToHex(r, g, b), equipped, E:RGBToHex(avColor.r, avColor.g, avColor.b), total)
		else
			frame.ItemLevelText:SetFormattedText('%.2f / %.2f', equipped, total)
		end
	end
end

function module:PaperDollFrame_UpdateStats()
	module.totalShown = 0

	_G["CharacterStatsPane"].ItemLevelCategory:Point("TOP", _G["CharacterStatsPane"], "TOP", 0, 5)
	_G["CharacterStatsPane"].AttributesCategory:Point("TOP", _G["CharacterStatsPane"].ItemLevelFrame, "BOTTOM", 0, 4)

	local categoryYOffset = 5
	local statYOffset = 0

	_G["CharacterStatsPane"].ItemLevelCategory:Show()
	_G["CharacterStatsPane"].ItemLevelCategory.Title:FontTemplate(LSM:Fetch('font', E.db.mui.armory.stats.catFonts.font), E.db.mui.armory.stats.catFonts.size, E.db.mui.armory.stats.catFonts.outline)
	_G["CharacterStatsPane"].ItemLevelFrame:Show()

	local spec = GetSpecialization()
	local role = GetSpecializationRole(spec)
	local _, powerType = UnitPowerType("player")
	-- print(GetSpecializationInfo(spec))

	_G["CharacterStatsPane"].statsFramePool:ReleaseAll()
	-- we need a stat frame to first do the math to know if we need to show the stat frame
	-- so effectively we'll always pre-allocate
	local statFrame = _G["CharacterStatsPane"].statsFramePool:Acquire()

	local lastAnchor
	for catIndex = 1, #PAPERDOLL_STATCATEGORIES do
		local catFrame = _G["CharacterStatsPane"][PAPERDOLL_STATCATEGORIES[catIndex].categoryFrame]
		catFrame.Title:FontTemplate(LSM:Fetch('font', E.db.mui.armory.stats.catFonts.font), E.db.mui.armory.stats.catFonts.size, E.db.mui.armory.stats.catFonts.outline)
		local numStatInCat = 0
		for statIndex = 1, #PAPERDOLL_STATCATEGORIES[catIndex].stats do
			local stat = PAPERDOLL_STATCATEGORIES[catIndex].stats[statIndex]
			local showStat = true
			if stat.option and not E.db.mui.armory.stats.List[stat.stat] then showStat = false end

			if showStat and stat.primary then
				local primaryStat = select(6, GetSpecializationInfo(spec, nil, nil, nil, UnitSex("player")))
				if stat.primary ~= primaryStat and E.db.mui.armory.stats.OnlyPrimary then
					showStat = false
				end
			end

			if showStat and stat.roles then
				local foundRole = false
				for _, statRole in pairs(stat.roles) do
					if role == statRole then
						foundRole = true
						break
					end
				end
				if foundRole and stat.classes then
					for _, statClass in pairs(stat.classes) do
						if E.myclass == statClass then
							showStat = true
							break
						end
					end
				else
					showStat = foundRole
				end
			end

			if stat.power and stat.power ~= powerType then showStat = false end
			if showStat then
				statFrame.onEnterFunc = nil
				PAPERDOLL_STATINFO[stat.stat].updateFunc(statFrame, "player")
				statFrame.Label:FontTemplate(LSM:Fetch('font', E.db.mui.armory.stats.statFonts.font), E.db.mui.armory.stats.statFonts.size, E.db.mui.armory.stats.statFonts.outline)
				statFrame.Value:FontTemplate(LSM:Fetch('font', E.db.mui.armory.stats.statFonts.font), E.db.mui.armory.stats.statFonts.size, E.db.mui.armory.stats.statFonts.outline)
				if not stat.hideAt or stat.hideAt ~= statFrame.numericValue then
					if numStatInCat == 0 then
						if lastAnchor then
							catFrame:Point("TOP", lastAnchor, "BOTTOM", 0, categoryYOffset)
						end
						lastAnchor = catFrame
						statFrame:Point("TOP", catFrame, "BOTTOM", 0, 6)
					else
						statFrame:Point("TOP", lastAnchor, "BOTTOM", 0, statYOffset)
					end
					if statFrame:IsShown() then
						module.totalShown = module.totalShown + 1
						numStatInCat = numStatInCat + 1
						-- statFrame.Background:SetShown((numStatInCat % 2) == 0)
						lastAnchor = statFrame
					end
					-- done with this stat frame, get the next one
					statFrame = _G["CharacterStatsPane"].statsFramePool:Acquire()
				end
			end
		end
		catFrame:SetShown(numStatInCat > 0)
	end
	-- release the current stat frame
	_G["CharacterStatsPane"].statsFramePool:Release(statFrame)
	if module.totalShown > 12 then
		module.Scrollbar:Show()
	else
		module.Scrollbar:Hide()
	end
end

function module:ToggleArmory()
	PAPERDOLL_STATCATEGORIES = E.db.mui.armory.stats.enable and module.ChangedStats or module.OriginalPaperdollStats

	if E.db.mui.armory.stats.enable then
		_G['CharacterStatsPane']['OffenseCategory']:Show()
		_G['CharacterStatsPane']['DefenceCategory']:Show()
		_G.CharacterFrame.ItemLevelText:SetText('')
	else
		_G['CharacterStatsPane']['OffenseCategory']:Hide()
		_G['CharacterStatsPane']['DefenceCategory']:Hide()
	end

	PaperDollFrame_UpdateStats()
	M:UpdateCharacterItemLevel()
	if not E.db.general.itemLevel.displayCharacterInfo then
		_G.CharacterFrame.ItemLevelText:SetText('')
	end
end

function module:BuildScrollBar()
	local CharacterFrameInsetRight = _G.CharacterFrameInsetRight
	module.ScrollframeParentFrame = CreateFrame("Frame", nil, CharacterFrameInsetRight)
	module.ScrollframeParentFrame:Size(198, 352)
	module.ScrollframeParentFrame:Point("TOP", CharacterFrameInsetRight, "TOP", 0, -4)

	--Scrollframe
	module.ScrollFrame = CreateFrame("ScrollFrame", "MER_ScrollFrame", module.ScrollframeParentFrame)
	module.ScrollFrame:Point("TOP")
	module.ScrollFrame:Size(module.ScrollframeParentFrame:GetSize())

	--Scrollbar
	module.Scrollbar = CreateFrame("Slider", "module_Scrollbar", module.ScrollFrame, "UIPanelScrollBarTemplate")
	module.Scrollbar:Point("TOPLEFT", CharacterFrameInsetRight, "TOPRIGHT", -12, -20)
	module.Scrollbar:Point("BOTTOMLEFT", CharacterFrameInsetRight, "BOTTOMRIGHT", -12, 18)
	module.Scrollbar:SetMinMaxValues(1, 2)
	module.Scrollbar:SetValueStep(1)
	module.Scrollbar.scrollStep = 1
	module.Scrollbar:SetValue(0)
	module.Scrollbar:SetWidth(8)
	module.Scrollbar:SetScript("OnValueChanged", function (self, value)
		self:GetParent():SetVerticalScroll(value)
	end)
	E:GetModule("Skins"):HandleScrollBar(module.Scrollbar)
	module.Scrollbar:Hide()

	--module.ScrollChild Frame
	module.ScrollChild = CreateFrame("Frame", nil, module.ScrollFrame)
	module.ScrollChild:Size(module.ScrollFrame:GetSize())
	module.ScrollFrame:SetScrollChild(module.ScrollChild)

	local CharacterStatsPane = _G.CharacterStatsPane
	CharacterStatsPane:ClearAllPoints()
	CharacterStatsPane:SetParent(module.ScrollChild)
	CharacterStatsPane:Size(module.ScrollChild:GetSize())
	CharacterStatsPane:Point("TOP", module.ScrollChild, "TOP", 0, 0)

	CharacterStatsPane.ClassBackground:ClearAllPoints()
	CharacterStatsPane.ClassBackground:SetParent(CharacterFrameInsetRight)
	CharacterStatsPane.ClassBackground:Point("CENTER")

	-- Enable mousewheel scrolling
	module.ScrollFrame:EnableMouseWheel(true)
	module.ScrollFrame:SetScript("OnMouseWheel", function(_, delta)
		local cur_val = module.Scrollbar:GetValue()

		module.Scrollbar:SetValue(cur_val - delta*module.totalShown)
	end)

	PaperDollSidebarTab1:HookScript("OnShow", function(self, event)
		module.ScrollframeParentFrame:Show()
	end)

	PaperDollSidebarTab1:HookScript("OnClick", function(self, event)
		module.ScrollframeParentFrame:Show()
	end)

	PaperDollSidebarTab2:HookScript("OnClick", function(self, event)
		module.ScrollframeParentFrame:Hide()
	end)

	PaperDollSidebarTab3:HookScript("OnClick", function(self, event)
		module.ScrollframeParentFrame:Hide()
	end)
end

function module:InitStats()
	if IsAddOnLoaded("DejaCharacterStats") then return end
	if not E.db.mui.armory.stats.enable then return end

	module:ReplaceBlizzGlobals()
	hooksecurefunc("PaperDollFrame_UpdateStats", module.PaperDollFrame_UpdateStats)
	hooksecurefunc(M, 'UpdateCharacterItemLevel', module.UpdateCharacterItemLevel)
	hooksecurefunc(M, 'ToggleItemLevelInfo', module.UpdateCharacterItemLevel)
	hooksecurefunc(M, 'UpdateAverageString', module.UpdateCharacterItemLevel)

	module:BuildScrollBar()
	module:BuildNewStats()
	module:ToggleArmory()

	_G.CharacterFrame:HookScript('OnShow', module.UpdateCharacterItemLevel)
end
