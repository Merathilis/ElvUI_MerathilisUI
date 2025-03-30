local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_RaidBuffs")
local LCG = E.Libs.CustomGlow

local ipairs, pairs, unpack = ipairs, pairs, unpack

local CreateFrame = CreateFrame
local RegisterStateDriver = RegisterStateDriver
local UnregisterStateDriver = UnregisterStateDriver
local AuraUtil_FindAuraByName = AuraUtil.FindAuraByName
local GetWeaponEnchantInfo = GetWeaponEnchantInfo
local GetInventoryItemTexture = GetInventoryItemTexture

local GetSpellName = C_Spell.GetSpellName
local GetSpellTexture = C_Spell.GetSpellTexture

local r, g, b = unpack(E["media"].rgbvaluecolor)
local color = { r, g, b, 1 }

module.VisibilityStates = {
	["DEFAULT"] = "[noexists, nogroup] hide; show",
	["INPARTY"] = "[combat] hide; [group] show; [petbattle] hide; hide",
	["ALWAYS"] = "[petbattle] hide; show",
}

module.ReminderBuffs = {
	Flask = {
		-- TWW
		431971, -- Flask of Tempered Aggression
		431972, -- Flask of Tempered Swiftness
		431973, -- Flask of Tempered Versatility
		431974, -- Flask of Tempered Mastery
		432021, -- Flask of Alchemical Chaos
		432021, -- Flask of Alchemical Chaos
		432473, -- Flask of Saving Graces
	},
	DefiledAugmentRune = {
		393438, -- Dreambound Augment Rune
	},
	Food = {
		104280, -- Well Fed
		462210, -- Hearty Well Fed
	},
	Intellect = {
		1459, -- Arcane Intellect
	},
	Stamina = {
		21562, -- Power Word: Fortitude
	},
	AttackPower = {
		6673, -- Battle Shout
	},
	Versatility = {
		1126, -- Mark of the Wild
	},
	Mastery = {
		462854, -- Skyfury
	},
	Cooldown_Reduce = {
		381748, -- Blessing of the Bronze
	},
	Weapon = {
		1, -- just a fallback
	},
	Custom = {
		-- spellID,	-- Spell name
	},
}

module.Weapon_Enchants = {
	6188, -- Shadowcore Oil
	6190, -- Embalmer's Oil
	6200, -- Shaded Sharpening Stone
	6201, -- Shaded Weightstone
}

local function EnchantsID(id)
	for i, v in ipairs(module.Weapon_Enchants) do
		if id == v then
			return true
		end
	end
	return false
end

local flaskbuffs = module.ReminderBuffs["Flask"]
local foodbuffs = module.ReminderBuffs["Food"]
local darunebuffs = module.ReminderBuffs["DefiledAugmentRune"]
local cooldowns = module.ReminderBuffs["Cooldown_Reduce"]
local intellectbuffs = module.ReminderBuffs["Intellect"]
local staminabuffs = module.ReminderBuffs["Stamina"]
local attackpowerbuffs = module.ReminderBuffs["AttackPower"]
local versatilitybuffs = module.ReminderBuffs["Versatility"]
local masterybuffs = module.ReminderBuffs["Mastery"]
local custombuffs = module.ReminderBuffs["Custom"]
local weaponEnch = module.ReminderBuffs["Weapon"]

local function OnAuraChange(_, event, arg1)
	if event == "UNIT_AURA" and arg1 ~= "player" then
		return
	end
	module.db = E.db.mui.raidBuffs

	if flaskbuffs and flaskbuffs[1] then
		FlaskFrame.t:SetTexture(GetSpellTexture(flaskbuffs[1]))
		for i, flaskbuffs in pairs(flaskbuffs) do
			local spellname = GetSpellName(flaskbuffs)
			if AuraUtil_FindAuraByName(spellname, "player") then
				FlaskFrame.t:SetTexture(GetSpellTexture(flaskbuffs))
				FlaskFrame:SetAlpha(module.db.alpha)
				LCG.PixelGlow_Stop(FlaskFrame)
				break
			else
				FlaskFrame:SetAlpha(1)
				if module.db.glow then
					LCG.PixelGlow_Start(FlaskFrame, color, nil, -0.25, nil, 1)
				end
			end
		end
	end

	if foodbuffs and foodbuffs[1] then
		FoodFrame.t:SetTexture(GetSpellTexture(foodbuffs[1]))
		for i, foodbuffs in pairs(foodbuffs) do
			local spellname = GetSpellName(foodbuffs)
			if AuraUtil_FindAuraByName(spellname, "player") then
				FoodFrame.t:SetTexture(GetSpellTexture(foodbuffs))
				FoodFrame:SetAlpha(module.db.alpha)
				LCG.PixelGlow_Stop(FoodFrame)
				break
			else
				FoodFrame:SetAlpha(1)
				FoodFrame.t:SetTexture(GetSpellTexture(foodbuffs))
				if module.db.glow then
					LCG.PixelGlow_Start(FoodFrame, color, nil, -0.25, nil, 1)
				end
			end
		end
	end

	if darunebuffs and darunebuffs[1] then
		DARuneFrame.t:SetTexture(GetSpellTexture(darunebuffs[1]))
		for i, darunebuffs in pairs(darunebuffs) do
			local spellname = GetSpellName(darunebuffs)
			if AuraUtil_FindAuraByName(spellname, "player") then
				DARuneFrame.t:SetTexture(GetSpellTexture(darunebuffs))
				DARuneFrame:SetAlpha(module.db.alpha)
				LCG.PixelGlow_Stop(DARuneFrame)
				break
			else
				DARuneFrame:SetAlpha(1)
				DARuneFrame.t:SetTexture(GetSpellTexture(darunebuffs))
				if module.db.glow then
					LCG.PixelGlow_Start(DARuneFrame, color, nil, -0.25, nil, 1)
				end
			end
		end
	end

	if module.db.class then
		if intellectbuffs and intellectbuffs[1] then
			IntellectFrame.t:SetTexture(GetSpellTexture(intellectbuffs[1]))
			for i, intellectbuffs in pairs(intellectbuffs) do
				local spellname = GetSpellName(intellectbuffs)
				if AuraUtil_FindAuraByName(spellname, "player") then
					IntellectFrame.t:SetTexture(GetSpellTexture(intellectbuffs))
					IntellectFrame:SetAlpha(module.db.alpha)
					LCG.PixelGlow_Stop(IntellectFrame)
					break
				else
					IntellectFrame:SetAlpha(1)
					IntellectFrame.t:SetTexture(GetSpellTexture(1459))
					if module.db.glow then
						LCG.PixelGlow_Start(IntellectFrame, color, nil, -0.25, nil, 1)
					end
				end
			end
		end

		if staminabuffs and staminabuffs[1] then
			StaminaFrame.t:SetTexture(GetSpellTexture(staminabuffs[1]))
			for i, staminabuffs in pairs(staminabuffs) do
				local spellname = GetSpellName(staminabuffs)
				if AuraUtil_FindAuraByName(spellname, "player") then
					StaminaFrame.t:SetTexture(GetSpellTexture(staminabuffs))
					StaminaFrame:SetAlpha(module.db.alpha)
					LCG.PixelGlow_Stop(StaminaFrame)
					break
				else
					StaminaFrame:SetAlpha(1)
					StaminaFrame.t:SetTexture(GetSpellTexture(21562))
					if module.db.glow then
						LCG.PixelGlow_Start(StaminaFrame, color, nil, -0.25, nil, 1)
					end
				end
			end
		end

		if attackpowerbuffs and attackpowerbuffs[1] then
			AttackPowerFrame.t:SetTexture(GetSpellTexture(attackpowerbuffs[1]))
			for i, attackpowerbuffs in pairs(attackpowerbuffs) do
				local spellname = GetSpellName(attackpowerbuffs)
				if AuraUtil_FindAuraByName(spellname, "player") then
					AttackPowerFrame.t:SetTexture(GetSpellTexture(attackpowerbuffs))
					AttackPowerFrame:SetAlpha(module.db.alpha)
					LCG.PixelGlow_Stop(AttackPowerFrame)
					break
				else
					AttackPowerFrame:SetAlpha(1)
					AttackPowerFrame.t:SetTexture(GetSpellTexture(6673))
					if module.db.glow then
						LCG.PixelGlow_Start(AttackPowerFrame, color, nil, -0.25, nil, 1)
					end
				end
			end
		end

		if versatilitybuffs and versatilitybuffs[1] then
			VersatilityFrame.t:SetTexture(GetSpellTexture(versatilitybuffs[1]))
			for i, versatilitybuffs in pairs(versatilitybuffs) do
				local spellname = GetSpellName(versatilitybuffs)
				if AuraUtil_FindAuraByName(spellname, "player") then
					VersatilityFrame.t:SetTexture(GetSpellTexture(versatilitybuffs))
					VersatilityFrame:SetAlpha(module.db.alpha)
					LCG.PixelGlow_Stop(VersatilityFrame)
					break
				else
					VersatilityFrame:SetAlpha(1)
					VersatilityFrame.t:SetTexture(GetSpellTexture(1126))
					if module.db.glow then
						LCG.PixelGlow_Start(VersatilityFrame, color, nil, -0.25, nil, 1)
					end
				end
			end
		end

		if masterybuffs and masterybuffs[1] then
			MasteryFrame.t:SetTexture(GetSpellTexture(masterybuffs[1]))
			for i, masterybuffs in pairs(masterybuffs) do
				local spellname = GetSpellName(masterybuffs)
				if AuraUtil_FindAuraByName(spellname, "player") then
					MasteryFrame.t:SetTexture(GetSpellTexture(masterybuffs))
					MasteryFrame:SetAlpha(module.db.alpha)
					LCG.PixelGlow_Stop(MasteryFrame)
					break
				else
					MasteryFrame:SetAlpha(1)
					MasteryFrame.t:SetTexture(GetSpellTexture(462854))
					if module.db.glow then
						LCG.PixelGlow_Start(MasteryFrame, color, nil, -0.25, nil, 1)
					end
				end
			end
		end

		if cooldowns and cooldowns[1] then
			CooldownFrame.t:SetTexture(GetSpellTexture(cooldowns[1]))
			for i, cooldowns in pairs(cooldowns) do
				local spellname = GetSpellName(cooldowns)
				if AuraUtil_FindAuraByName(spellname, "player") then
					CooldownFrame.t:SetTexture(GetSpellTexture(cooldowns))
					CooldownFrame:SetAlpha(module.db.alpha)
					LCG.PixelGlow_Stop(CooldownFrame)
				else
					CooldownFrame:SetAlpha(1)
					CooldownFrame.t:SetTexture(GetSpellTexture(381748))
					if module.db.glow then
						LCG.PixelGlow_Start(CooldownFrame, color, nil, -0.25, nil, 1)
					end
				end
			end
		end
	end

	--[[
	if (weaponEnch and weaponEnch[1]) then
		local hasMainHandEnchant, _, _, mainHandEnchantID, hasOffHandEnchant, _, _, offHandEnchantId = GetWeaponEnchantInfo()
		if (hasMainHandEnchant and EnchantsID(mainHandEnchantID)) or (hasOffHandEnchant and EnchantsID(offHandEnchantId)) then
			WeaponFrame.t:SetTexture(GetInventoryItemTexture('player', 16))
			WeaponFrame:SetAlpha(module.db.alpha)
			LCG.PixelGlow_Stop(WeaponFrame)
		else
			WeaponFrame:SetAlpha(1)
			WeaponFrame.t:SetTexture(GetInventoryItemTexture('player', 16))
			if module.db.glow then
				LCG.PixelGlow_Start(WeaponFrame, color, nil, -0.25, nil, 1)
			end
		end
	end]]

	if custombuffs and custombuffs[1] then
		for i, custombuffs in pairs(custombuffs) do
			local icon = GetSpellTexture(icon)
			if i == 1 then
				CustomFrame.t:SetTexture(icon)
			end

			if F.CheckPlayerBuff(name) then
				CustomFrame:SetAlpha(module.db.alpha)
				custom = true
				LCG.PixelGlow_Stop(CustomFrame)
				break
			else
				CustomFrame:SetAlpha(1)
				custom = false
				if module.db.glow then
					LCG.PixelGlow_Start(CustomFrame, color, nil, -0.25, nil, 1)
				end
			end
		end
	else
		CustomFrame:Hide()
		custom = true
	end
end

function module:CreateIconBuff(name, relativeTo, firstbutton)
	local button = CreateFrame("Button", name, module.frame)

	if firstbutton == true then
		F.CreatePanel(
			button,
			"Transparent",
			E.db.mui.raidBuffs.size,
			E.db.mui.raidBuffs.size,
			"BOTTOMLEFT",
			relativeTo,
			"BOTTOMLEFT",
			0,
			0
		)
	else
		F.CreatePanel(
			button,
			"Transparent",
			E.db.mui.raidBuffs.size,
			E.db.mui.raidBuffs.size,
			"LEFT",
			relativeTo,
			"RIGHT",
			3,
			0
		)
	end
	button:SetFrameLevel(_G.RaidBuffReminder:GetFrameLevel() + 2)

	button.t = button:CreateTexture(name .. ".t", "OVERLAY")
	button.t:SetTexCoord(unpack(E.TexCoords))
	button.t:SetPoint("TOPLEFT", 2, -2)
	button.t:SetPoint("BOTTOMRIGHT", -2, 2)
end

function module:Visibility()
	if module.db.enable then
		RegisterStateDriver(
			self.frame,
			"visibility",
			module.db.visibility == "CUSTOM" and module.db.customVisibility
				or module.VisibilityStates[module.db.visibility]
		)
		E:EnableMover(self.Anchor.mover:GetName())
	else
		UnregisterStateDriver(self.frame, "visibility")
		self.frame:Hide()
		E:DisableMover(self.Anchor.mover:GetName())
	end
end

function module:Initialize()
	module.db = E.db.mui.raidBuffs
	if not module.db.enable then
		return
	end

	-- Anchor
	self.Anchor = CreateFrame("Frame", "MER_RaidBuffAnchor", E.UIParent)
	self.Anchor:SetWidth((E.db.mui.raidBuffs.size * 8) + 25)
	self.Anchor:SetHeight(E.db.mui.raidBuffs.size)
	self.Anchor:SetPoint("TOPLEFT", E.UIParent, "TOPLEFT", 2, -20)

	self.frame = CreateFrame("Frame", "RaidBuffReminder", self.Anchor)
	F.CreatePanel(
		self.frame,
		"Invisible",
		(E.db.mui.raidBuffs.size * 8) + 15,
		E.db.mui.raidBuffs.size,
		"TOPLEFT",
		self.Anchor,
		"TOPLEFT",
		0,
		4
	)

	if module.db.class then
		self:CreateIconBuff("IntellectFrame", RaidBuffReminder, true)
		self:CreateIconBuff("StaminaFrame", IntellectFrame, false)
		self:CreateIconBuff("AttackPowerFrame", StaminaFrame, false)
		self:CreateIconBuff("VersatilityFrame", AttackPowerFrame, false)
		self:CreateIconBuff("CooldownFrame", VersatilityFrame, false)
		self:CreateIconBuff("MasteryFrame", CooldownFrame, false)
		self:CreateIconBuff("FlaskFrame", MasteryFrame, false)
		self:CreateIconBuff("FoodFrame", FlaskFrame, false)
		self:CreateIconBuff("DARuneFrame", FoodFrame, false)
		-- self:CreateIconBuff("WeaponFrame", DARuneFrame, false)
		self:CreateIconBuff("CustomFrame", DARuneFrame, false)
	else
		self:CreateIconBuff("FlaskFrame", RaidBuffReminder, true)
		self:CreateIconBuff("FoodFrame", FlaskFrame, false)
		self:CreateIconBuff("DARuneFrame", FoodFrame, false)
		-- self:CreateIconBuff("WeaponFrame", DARuneFrame, false)
		self:CreateIconBuff("CustomFrame", DARuneFrame, false)
	end

	self.frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	self.frame:RegisterEvent("UNIT_INVENTORY_CHANGED")
	self.frame:RegisterEvent("UNIT_AURA")
	self.frame:RegisterEvent("PLAYER_REGEN_ENABLED")
	self.frame:RegisterEvent("PLAYER_REGEN_DISABLED")
	self.frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	self.frame:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
	self.frame:RegisterEvent("CHARACTER_POINTS_CHANGED")
	self.frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self.frame:RegisterEvent("GROUP_ROSTER_UPDATE")
	self.frame:SetScript("OnEvent", OnAuraChange) -- 11.0 FIX ME

	E:CreateMover(
		self.Anchor,
		"MER_RaidBuffReminderMover",
		MER.Title .. L["Raid Buffs Reminder"],
		nil,
		nil,
		nil,
		"ALL,SOLO,PARTY,RAID,MERATHILISUI",
		nil,
		"mui,modules,raidBuffs"
	)

	self:Visibility()
end

MER:RegisterModule(module:GetName())
