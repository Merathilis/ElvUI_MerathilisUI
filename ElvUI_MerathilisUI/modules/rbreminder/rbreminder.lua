local MER, E, L, V, P, G = unpack(select(2, ...))
local RB = E:NewModule("mUIRaidBuffs")
RB.modName = L["Raid Buff Reminder"]

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
local UnitAura = UnitAura

-- Global variables that we don"t cache, list them here for the mikk"s Find Globals script
-- GLOBALS: FlaskFrame, FoodFrame, DARuneFrame, mUIRaidBuffReminder

local bsize = 22

RB.VisibilityStates = {
	["DEFAULT"] = "[noexists, nogroup] hide; show",
	["INPARTY"] = "[combat] hide; [group] show; [petbattle] hide; hide",
	["ALWAYS"] = "[petbattle] hide; show",
}

RB.ReminderBuffs = {
	Flask = {
		188031,	-- Flask of the Whispered Pact (Intellect)
		188033,	-- Flask of the Seventh Demon (Agility)
		188034,	-- Flask of the Countless Armies (Strenght)
		188035,	-- Flask of Ten Thousand Scars (Stamina)
	},
	DefiledAugmentRune = {
		224001,	-- Defiled Augment Rune
	},
	Food = {
		104280,	-- Well Fed
	},
}

local flaskbuffs = RB.ReminderBuffs["Flask"]
local foodbuffs = RB.ReminderBuffs["Food"]
local darunebuffs = RB.ReminderBuffs["DefiledAugmentRune"]
local flask, food, darune

local function OnAuraChange(self, event, arg1, unit)
	if event == "UNIT_AURA" and arg1 ~= "player" then return end

	if flaskbuffs and flaskbuffs[1] then
		FlaskFrame.t:SetTexture(select(3, GetSpellInfo(flaskbuffs[1])))
		for i, flaskbuffs in pairs(flaskbuffs) do
			local spellname = select(1, GetSpellInfo(flaskbuffs))
			if UnitAura("player", spellname) then
				FlaskFrame.t:SetTexture(select(3, GetSpellInfo(flaskbuffs)))
				FlaskFrame:SetAlpha(0.3)
				flask = true
				break
			else
				FlaskFrame:SetAlpha(1)
				food = false
			end
		end
	end

	if foodbuffs and foodbuffs[1] then
		FoodFrame.t:SetTexture(select(3, GetSpellInfo(foodbuffs[1])))
		for i, foodbuffs in pairs(foodbuffs) do
			local spellname = select(1, GetSpellInfo(foodbuffs))
			if UnitAura("player", spellname) then
				FoodFrame.t:SetTexture(select(3, GetSpellInfo(foodbuffs)))
				FoodFrame:SetAlpha(0.3)
				food = true
				break
			else
				FoodFrame:SetAlpha(1)
				food = false
			end
		end
	end

	if darunebuffs and darunebuffs[1] then
	DARuneFrame.t:SetTexture(select(3, GetSpellInfo(darunebuffs[1])))
		for i, darunebuffs in pairs(darunebuffs) do
			local spellname = select(1, GetSpellInfo(darunebuffs))
			if UnitAura("player", spellname) then
				DARuneFrame.t:SetTexture(select(3, GetSpellInfo(darunebuffs)))
				DARuneFrame:SetAlpha(0.3)
				darune = true
				break
			else
				DARuneFrame:SetAlpha(1)
				food = false
			end
		end
	end
end

function RB:CreateIconBuff(name, relativeTo, firstbutton)
	local button = CreateFrame("Frame", name, RB.frame)
	button:CreateBackdrop("Default")
	button:Size(bsize, bsize)
	if firstbutton == true then
		button:Point("RIGHT", relativeTo, "RIGHT", -4, 0)
	else
		button:Point("RIGHT", relativeTo, "LEFT", -3, 0)
	end

	button:SetFrameLevel(self.frame.backdrop:GetFrameLevel() + 2)
	button.t = button:CreateTexture(name..".t", "OVERLAY")
	button.t:SetTexCoord(unpack(E.TexCoords))
	button.t:SetAllPoints(button)
end

function RB:Visibility()
	local db = E.db.mui.raidBuffs
	if db.enable then
		RegisterStateDriver(self.frame, "visibility", db.visibility == "CUSTOM" and db.customVisibility or RB.VisibilityStates[db.visibility])
		E:EnableMover(self.frame.mover:GetName())
	else
		UnregisterStateDriver(self.frame, "visibility")
		self.frame:Hide()
		E:DisableMover(self.frame.mover:GetName())
	end
end

function RB:Initialize()
	self.frame = CreateFrame("Frame", "mUIRaidBuffReminder", E.UIParent)
	self.frame:CreateBackdrop("Transparent")
	self.frame.backdrop:SetAllPoints()
	self.frame:SetFrameStrata("BACKGROUND")
	self.frame:SetFrameLevel(0)
	self.frame:Size(bsize*3+14, bsize + 8)
	self.frame:Point("TOP", E.UIParent, "TOP", 0, -50)
	self.frame:Styling()

	self:CreateIconBuff("FlaskFrame", mUIRaidBuffReminder, true)
	self:CreateIconBuff("FoodFrame", FlaskFrame, false)
	self:CreateIconBuff("DARuneFrame", FoodFrame, false)

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

	E:CreateMover(self.frame, "RBMover", L["Raid Buffs Reminder"], nil, nil, nil, "ALL,PARTY,RAID")

	function RB:ForUpdateAll()
		RB.db = E.db.mui.raidBuffs
		self:Visibility()
	end

	self:ForUpdateAll()
end

local function InitializeCallback()
	RB:Initialize()
end

E:RegisterModule(RB:GetName(), InitializeCallback)