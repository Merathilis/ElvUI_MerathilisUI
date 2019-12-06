local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:NewModule("RaidBuffs")
local LCG = LibStub('LibCustomGlow-1.0')

-- Cache global variables
-- Lua functions
local _G = _G
local pairs, select, unpack = pairs, select, unpack
-- WoW API / Variables
local CreateFrame = CreateFrame
local IsInRaid = IsInRaid
local RegisterStateDriver = RegisterStateDriver
local UnregisterStateDriver = UnregisterStateDriver
local GetSpellInfo = GetSpellInfo
local AuraUtil_FindAuraByName = AuraUtil.FindAuraByName

-- Global variables that we don"t cache, list them here for the mikk"s Find Globals script
-- GLOBALS: mUIRaidBuffReminder, FlaskFrame, FoodFrame, DARuneFrame, IntellectFrame, StaminaFrame, AttackPowerFrame, CustomFrame

local bsize = 25
local r, g, b = unpack(E["media"].rgbvaluecolor)
local color = {r, g, b, 1}

module.VisibilityStates = {
	["DEFAULT"] = "[noexists, nogroup] hide; show",
	["INPARTY"] = "[combat] hide; [group] show; [petbattle] hide; hide",
	["ALWAYS"] = "[petbattle] hide; show",
}

module.ReminderBuffs = {
	Flask = {
		-- BFA
		251836,			-- Flask of the Currents (238 agi)
		251837,			-- Flask of Endless Fathoms (238 int)
		251838,			-- Flask of the Vast Horizon (357 sta)
		251839,			-- Flask of the Undertow (238 str)
		298836,			-- Greater Flask of the Currents
		298837,			-- Greater Flask of Endless Fathoms
		298839,			-- Greater Flask of the Vast Horizon
		298841,			-- Greater Flask of the Undertow

	},
	DefiledAugmentRune = {
		224001,			-- Defiled Augumentation (15 primary stat)
		270058,			-- Battle Scarred Augmentation (60 primary stat)
	},
	Food = {
		104280,	-- Well Fed
	},
	Intellect = {
		1459, -- Arcane Intellect
		264760, -- War-Scroll of Intellect
	},
	Stamina = {
		6307, -- Blood Pact
		21562, -- Power Word: Fortitude
		264764, -- War-Scroll of Fortitude
	},
	AttackPower = {
		6673, -- Battle Shout
		264761, -- War-Scroll of Battle
	},
	Custom = {
		-- spellID,	-- Spell name
	},
}

local flaskbuffs = module.ReminderBuffs["Flask"]
local foodbuffs = module.ReminderBuffs["Food"]
local darunebuffs = module.ReminderBuffs["DefiledAugmentRune"]
local intellectbuffs = module.ReminderBuffs["Intellect"]
local staminabuffs = module.ReminderBuffs["Stamina"]
local attackpowerbuffs = module.ReminderBuffs["AttackPower"]
local custombuffs = module.ReminderBuffs["Custom"]

local function OnAuraChange(self, event, arg1, unit)
	if (event == "UNIT_AURA" and arg1 ~= "player") then return end
	module.db = E.db.mui.raidBuffs

	if (flaskbuffs and flaskbuffs[1]) then
		FlaskFrame.t:SetTexture(select(3, GetSpellInfo(flaskbuffs[1])))
		for i, flaskbuffs in pairs(flaskbuffs) do
			local spellname = select(1, GetSpellInfo(flaskbuffs))
			if AuraUtil_FindAuraByName(spellname, "player") then
				FlaskFrame.t:SetTexture(select(3, GetSpellInfo(flaskbuffs)))
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

	if (foodbuffs and foodbuffs[1]) then
		FoodFrame.t:SetTexture(select(3, GetSpellInfo(foodbuffs[1])))
		for i, foodbuffs in pairs(foodbuffs) do
			local spellname = select(1, GetSpellInfo(foodbuffs))
			if AuraUtil_FindAuraByName(spellname, "player") then
				FoodFrame.t:SetTexture(select(3, GetSpellInfo(foodbuffs)))
				FoodFrame:SetAlpha(module.db.alpha)
				LCG.PixelGlow_Stop(FoodFrame)
				break
			else
				FoodFrame:SetAlpha(1)
				FoodFrame.t:SetTexture(select(3, GetSpellInfo(foodbuffs)))
				if module.db.glow then
					LCG.PixelGlow_Start(FoodFrame, color, nil, -0.25, nil, 1)
				end
			end
		end
	end

	if (darunebuffs and darunebuffs[1]) then
	DARuneFrame.t:SetTexture(select(3, GetSpellInfo(darunebuffs[1])))
		for i, darunebuffs in pairs(darunebuffs) do
			local spellname = select(1, GetSpellInfo(darunebuffs))
			if AuraUtil_FindAuraByName(spellname, "player") then
				DARuneFrame.t:SetTexture(select(3, GetSpellInfo(darunebuffs)))
				DARuneFrame:SetAlpha(module.db.alpha)
				LCG.PixelGlow_Stop(DARuneFrame)
				break
			else
				DARuneFrame:SetAlpha(1)
				DARuneFrame.t:SetTexture(select(3, GetSpellInfo(darunebuffs)))
				if module.db.glow then
					LCG.PixelGlow_Start(DARuneFrame, color, nil, -0.25, nil, 1)
				end
			end
		end
	end

	if module.db.class then
		if (intellectbuffs and intellectbuffs[1]) then
		IntellectFrame.t:SetTexture(select(3, GetSpellInfo(intellectbuffs[1])))
			for i, intellectbuffs in pairs(intellectbuffs) do
				local spellname = select(1, GetSpellInfo(intellectbuffs))
				if AuraUtil_FindAuraByName(spellname, "player") then
					IntellectFrame.t:SetTexture(select(3, GetSpellInfo(intellectbuffs)))
					IntellectFrame:SetAlpha(module.db.alpha)
					LCG.PixelGlow_Stop(IntellectFrame)
					break
				else
					IntellectFrame:SetAlpha(1)
					IntellectFrame.t:SetTexture(select(3, GetSpellInfo(1459)))
					if module.db.glow then
						LCG.PixelGlow_Start(IntellectFrame, color, nil, -0.25, nil, 1)
					end
				end
			end
		end

		if (staminabuffs and staminabuffs[1]) then
		StaminaFrame.t:SetTexture(select(3, GetSpellInfo(staminabuffs[1])))
			for i, staminabuffs in pairs(staminabuffs) do
				local spellname = select(1, GetSpellInfo(staminabuffs))
				if AuraUtil_FindAuraByName(spellname, "player") then
					StaminaFrame.t:SetTexture(select(3, GetSpellInfo(staminabuffs)))
					StaminaFrame:SetAlpha(module.db.alpha)
					LCG.PixelGlow_Stop(StaminaFrame)
					break
				else
					StaminaFrame:SetAlpha(1)
					StaminaFrame.t:SetTexture(select(3, GetSpellInfo(21562)))
					if module.db.glow then
						LCG.PixelGlow_Start(StaminaFrame, color, nil, -0.25, nil, 1)
					end
				end
			end
		end

		if (attackpowerbuffs and attackpowerbuffs[1]) then
		AttackPowerFrame.t:SetTexture(select(3, GetSpellInfo(attackpowerbuffs[1])))
			for i, attackpowerbuffs in pairs(attackpowerbuffs) do
				local spellname = select(1, GetSpellInfo(attackpowerbuffs))
				if AuraUtil_FindAuraByName(spellname, "player") then
					AttackPowerFrame.t:SetTexture(select(3, GetSpellInfo(attackpowerbuffs)))
					AttackPowerFrame:SetAlpha(module.db.alpha)
					LCG.PixelGlow_Stop(AttackPowerFrame)
					break
				else
					AttackPowerFrame:SetAlpha(1)
					AttackPowerFrame.t:SetTexture(select(3, GetSpellInfo(6673)))
					if module.db.glow then
						LCG.PixelGlow_Start(AttackPowerFrame, color, nil, -0.25, nil, 1)
					end
				end
			end
		end
	end

	if custombuffs and custombuffs[1] then
		for i, custombuffs in pairs(custombuffs) do
			local name, _, icon = GetSpellInfo(custombuffs)
			if i == 1 then
				CustomFrame.t:SetTexture(icon)
			end

			if MER:CheckPlayerBuff(name) then
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
		button:CreatePanel("Transparent", E.db.mui.raidBuffs.size, E.db.mui.raidBuffs.size, "BOTTOMLEFT", relativeTo, "BOTTOMLEFT", 0, 0)
	else
		button:CreatePanel("Transparent", E.db.mui.raidBuffs.size, E.db.mui.raidBuffs.size, "LEFT", relativeTo, "RIGHT", 3, 0)
	end
	button:SetFrameLevel(RaidBuffReminder:GetFrameLevel() + 2)

	button.t = button:CreateTexture(name..".t", "OVERLAY")
	button.t:SetTexCoord(unpack(E.TexCoords))
	button.t:SetPoint("TOPLEFT", 2, -2)
	button.t:SetPoint("BOTTOMRIGHT", -2, 2)
end

function module:Visibility()
	if module.db.enable then
		RegisterStateDriver(self.frame, "visibility", module.db.visibility == "CUSTOM" and module.db.customVisibility or module.VisibilityStates[module.db.visibility])
		E:EnableMover(self.frame.mover:GetName())
	else
		UnregisterStateDriver(self.frame, "visibility")
		self.frame:Hide()
		E:DisableMover(self.frame.mover:GetName())
	end
end

function module:Initialize()
	module.db = E.db.mui.raidBuffs
	MER:RegisterDB(self, "raidBuffs")

	-- Anchor
	self.Anchor = CreateFrame("Frame", "RaidBuffAnchor", E.UIParent)
	self.Anchor:SetWidth((E.db.mui.raidBuffs.size * 6) + 15)
	self.Anchor:SetHeight(E.db.mui.raidBuffs.size)
	self.Anchor:SetPoint("TOPLEFT", E.UIParent, "TOPLEFT", 11, -15)

	self.frame = CreateFrame("Frame", "RaidBuffReminder", E.UIParent)
	self.frame:CreatePanel("Invisible", (E.db.mui.raidBuffs.size * 6) + 15, E.db.mui.raidBuffs.size + 4, "TOPLEFT", RaidBuffAnchor, "TOPLEFT", 0, 4)

	if module.db.class then
		self:CreateIconBuff("IntellectFrame", RaidBuffReminder, true)
		self:CreateIconBuff("StaminaFrame", IntellectFrame, false)
		self:CreateIconBuff("AttackPowerFrame", StaminaFrame, false)
		self:CreateIconBuff("FlaskFrame", AttackPowerFrame, false)
		self:CreateIconBuff("FoodFrame", FlaskFrame, false)
		self:CreateIconBuff("DARuneFrame", FoodFrame, false)
		self:CreateIconBuff("CustomFrame", DARuneFrame, false)
	else
		self:CreateIconBuff("FlaskFrame", RaidBuffReminder, true)
		self:CreateIconBuff("FoodFrame", FlaskFrame, false)
		self:CreateIconBuff("DARuneFrame", FoodFrame, false)
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
	self.frame:SetScript("OnEvent", OnAuraChange)

	E:CreateMover(self.frame, "MER_RaidBuffReminderMover", L["Raid Buffs Reminder"], nil, nil, nil, "ALL,SOLO,PARTY,RAID,MERATHILISUI", nil, 'mui,modules,raidBuffs')

	function module:ForUpdateAll()
		module.db = E.db.mui.raidBuffs
		self:Visibility()
	end

	self:ForUpdateAll()
end

MER:RegisterModule(module:GetName())
