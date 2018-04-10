local MER, E, L, V, P, G = unpack(select(2, ...))
-- local MI = E:GetModule("mUIMisc")

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API / Variables

-- Global variables that we don"t cache, list them here for the mikk"s Find Globals script
-- GLOBALS: hooksecurefunc

local bsize = 22

ReminderBuffs = {
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

local flaskbuffs = ReminderBuffs["Flask"]
local foodbuffs = ReminderBuffs["Food"]
local darunebuffs = ReminderBuffs["DefiledAugmentRune"]
local flask, food, darune

local function OnAuraChange(self, event, arg1, unit)
	if event == "UNIT_AURA" and arg1 ~= "player" then return end

	if flaskbuffs and flaskbuffs[1] then
		FlaskFrame.t:SetTexture(select(3, GetSpellInfo(flaskbuffs[1])))
		for i, flaskbuffs in pairs(flaskbuffs) do
			local spellname = select(1, GetSpellInfo(flaskbuffs))
			if UnitAura("player", spellname) then
				FlaskFrame.t:SetTexture(select(3, GetSpellInfo(flaskbuffs)))
				FlaskFrame:SetAlpha(1)
				flask = true
				break
			else
				FlaskFrame:SetAlpha(0.3)
				food = false
			end
		end
	end

	if foodbuffs and foodbuffs[1] then
		FoodFrame.t:SetTexture(select(3, GetSpellInfo(foodbuffs[1])))
		for i, foodbuffs in pairs(foodbuffs) do
			local spellname = select(1, GetSpellInfo(foodbuffs))
			if UnitAura("player", spellname) then
				FoodFrame:SetAlpha(1)
				FoodFrame.t:SetTexture(select(3, GetSpellInfo(foodbuffs)))
				food = true
				break
			else
				FoodFrame:SetAlpha(0.3)
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
				DARuneFrame:SetAlpha(1)
				darune = true
				break
			else
				DARuneFrame:SetAlpha(0.3)
				food = false
			end
		end
	end
end

local raidbuff_reminder = CreateFrame("Frame", MER.Title.."RaidBuffReminder", E.UIParent)
raidbuff_reminder:SetTemplate("Transparent")
raidbuff_reminder:SetFrameStrata("BACKGROUND")
raidbuff_reminder:SetFrameLevel(0)
raidbuff_reminder:Size(bsize*3+14, bsize + 8)
raidbuff_reminder:Point("TOP", E.UIParent, "TOP", 0, -50)
raidbuff_reminder:Styling()

local function CreateIconBuff(name, relativeTo, firstbutton)
	local button = CreateFrame("Frame", name, raidbuff_reminder)
	button:CreateBackdrop("Default")
	button:Size(bsize, bsize)
	if firstbutton == true then
		button:Point("RIGHT", relativeTo, "RIGHT", -4, 0)
	else
		button:Point("RIGHT", relativeTo, "LEFT", -3, 0)
	end

	button:SetFrameLevel(raidbuff_reminder:GetFrameLevel() + 2)
	button.t = button:CreateTexture(name..".t", "OVERLAY")
	button.t:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	button.t:SetAllPoints(button)
end

CreateIconBuff("FlaskFrame", RaidBuffReminder, true)
CreateIconBuff("FoodFrame", FlaskFrame, false)
CreateIconBuff("DARuneFrame", FoodFrame, false)

raidbuff_reminder:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
raidbuff_reminder:RegisterEvent("UNIT_INVENTORY_CHANGED")
raidbuff_reminder:RegisterEvent("UNIT_AURA")
raidbuff_reminder:RegisterEvent("PLAYER_REGEN_ENABLED")
raidbuff_reminder:RegisterEvent("PLAYER_REGEN_DISABLED")
raidbuff_reminder:RegisterEvent("PLAYER_ENTERING_WORLD")
raidbuff_reminder:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
raidbuff_reminder:RegisterEvent("CHARACTER_POINTS_CHANGED")
raidbuff_reminder:RegisterEvent("ZONE_CHANGED_NEW_AREA")
raidbuff_reminder:SetScript("OnEvent", OnAuraChange)

E:CreateMover(raidbuff_reminder, "RBMover", L["Raid Buffs Reminder"])