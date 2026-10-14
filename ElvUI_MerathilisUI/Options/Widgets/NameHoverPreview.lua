local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options
local Preview = module.Preview

local CreateFrame = CreateFrame
local GetQuestDifficultyColor = GetQuestDifficultyColor
local UnitFactionGroup = UnitFactionGroup
local C_CreatureInfo_GetRaceInfo = C_CreatureInfo and C_CreatureInfo.GetRaceInfo

-- Name Hover next to a sample cursor: a player of the opposing faction and an
-- elite enemy with a quest objective and the Enemy Forces line. Used as
-- `dialogControl` on a description named "nameHover". Colors, toggles, font
-- sizes, outlines and the line layout follow Modules/NameHover/Core.lua.

local HEIGHT = 160
local CURSOR_SIZE = 20
local CURSOR_TEX = [[Interface\CURSOR\Point]]
-- The frame sits 15 pixels above the cursor
local CURSOR_GAP = 15

-- Same numbers as the module's Layout table
local SUB_LEFT_INSET = 12
local SUB_BOTTOM_OFFSET = 1
local FORCES_GAP_RIGHT = 6
local FORCES_GAP_UNDER = 2

local SAMPLE_NAME = "Merathilis"
local SAMPLE_GUILD = "MerathilisUI"
local SAMPLE_CLASS = "PALADIN"
local SAMPLE_ENEMY_LEVEL_OFFSET = 2

local FORCES_SAMPLES = {
	PERCENT = "+1.25%",
	NUMBER = "+5",
	BOTH = "+5 (1.25%)",
}
local PROGRESS_SAMPLES = {
	PERCENT = "(45% / 100%)",
	NUMBER = "(212 / 470)",
	BOTH = "(212 (45%) / 470 (100%))",
}
local CONTEXT_COLOR = { r = 0.7, g = 0.7, b = 0.7 }

-- font string = { size key, outline key, fallback size }, like the module's FONTS
local FONTS = {
	main = { "mainTextSize", "mainTextOutline", 14 },
	status = { "statusTextSize", "statusTextOutline", 11 },
	header = { "headerTextSize", "headerTextOutline", 11 },
	guild = { "guildTextSize", "guildTextOutline", 11 },
	sub = { "subTextSize", "subTextOutline", 11 },
	forces = { "mythicPlus_FontSize", "mythicPlusFontOutline", 11 },
}

local function GetNameHover()
	return MER:GetModule("MER_NameHover")
end

local function Color(text, color)
	return GetNameHover():GetTextWithColor(text, color)
end

local function IsEmpty(text)
	return text == nil or text == ""
end

-- The opposing faction and one of its races
local function GetSampleFaction(NH)
	if UnitFactionGroup("player") == "Horde" then
		return _G.FACTION_ALLIANCE, NH.COLOR_ALLIANCE, 1
	end
	return _G.FACTION_HORDE, NH.COLOR_HORDE, 2
end

local function LevelText(db, level)
	if not db.level then
		return nil
	end
	return Color(tostring(level), GetQuestDifficultyColor(level))
end

local function CreateSample(parent)
	local sample = CreateFrame("Frame", nil, parent)
	sample:SetSize(1, 1)

	for key in pairs(FONTS) do
		sample[key] = sample:CreateFontString(nil, "OVERLAY")
	end

	sample.cursor = sample:CreateTexture(nil, "OVERLAY")
	sample.cursor:SetSize(CURSOR_SIZE, CURSOR_SIZE)
	sample.cursor:SetTexture(CURSOR_TEX)
	sample.cursor:SetPoint("TOPLEFT", sample, "CENTER", 0, -CURSOR_GAP)

	return sample
end

-- Lines above the name stack up like the module's SetAnchor
local function LayoutSample(sample, lines)
	local main = sample.main
	main:ClearAllPoints()
	main:SetPoint("BOTTOM", sample, "CENTER")

	local top = 0
	for _, key in ipairs({ "guild", "header", "status" }) do
		local fontString = sample[key]
		fontString:ClearAllPoints()
		local shown = not IsEmpty(lines[key])
		fontString:SetShown(shown)
		if shown then
			local margin = 13 + top
			fontString:SetPoint("TOPLEFT", main, "TOPLEFT", 0, margin)
			top = margin + 2
		end
	end

	local dropY = 0
	local forces = sample.forces
	forces:ClearAllPoints()
	forces:SetShown(not IsEmpty(lines.forces))
	if forces:IsShown() then
		if lines.forcesRight then
			forces:SetPoint("LEFT", main, "RIGHT", FORCES_GAP_RIGHT, 0)
		else
			dropY = dropY + FORCES_GAP_UNDER
			forces:SetPoint("TOPLEFT", main, "BOTTOMLEFT", SUB_LEFT_INSET, -dropY)
			dropY = dropY + forces:GetStringHeight()
		end
	end

	local sub = sample.sub
	sub:ClearAllPoints()
	sub:SetShown(not IsEmpty(lines.sub))
	if sub:IsShown() then
		sub:SetPoint("TOPLEFT", main, "BOTTOMLEFT", SUB_LEFT_INSET, -(dropY + SUB_BOTTOM_OFFSET))
	end
end

local function SetLines(sample, db, lines)
	for key, keys in pairs(FONTS) do
		local fontString = sample[key]
		fontString:FontTemplate(nil, db[keys[1]] or keys[3], db[keys[2]] or "SHADOWOUTLINE")
		fontString:SetText(lines[key] or "")
	end

	LayoutSample(sample, lines)
end

local function JoinWithSpace(...)
	return GetNameHover():CombineText(...)
end

local function PlayerLines(db)
	local NH = GetNameHover()
	local factionName, factionColor, raceID = GetSampleFaction(NH)
	local raceInfo = C_CreatureInfo_GetRaceInfo and C_CreatureInfo_GetRaceInfo(raceID)

	local target
	if db.targettarget then
		target = Color(">", NH.COLOR_DEFAULT) .. Color(E.myname, E:ClassColor(E.myclass, true))
	end

	local guild
	if db.guildName or db.guildRank then
		guild = ""
		if db.guildName then
			guild = "<" .. Color(SAMPLE_GUILD, NH.COLOR_GUILD) .. ">"
		end
		if db.guildRank then
			guild = guild .. (guild ~= "" and " " or "") .. "[" .. Color(_G.OFFICER or "Officer", NH.COLOR_GUILD) .. "]"
		end
	end

	return {
		main = JoinWithSpace(LevelText(db, E.mylevel), Color(SAMPLE_NAME, _G.RAID_CLASS_COLORS[SAMPLE_CLASS]), target),
		guild = guild,
		header = JoinWithSpace(
			db.faction and Color(factionName, factionColor) or nil,
			db.race and raceInfo and Color(raceInfo.raceName, NH.COLOR_DEFAULT) or nil
		),
		status = db.status and Color("<AFK>", NH.COLOR_DEAD) or nil,
	}
end

local function EnemyLines(db)
	local NH = GetNameHover()
	local forces
	if db.mythicPlus_ShowForces then
		forces = Color(FORCES_SAMPLES[db.mythicPlus_ContributionFormat] or FORCES_SAMPLES.PERCENT, NH.COLOR_DEFAULT)
		if db.mythicPlus_ShowProgress then
			local progress = PROGRESS_SAMPLES[db.mythicPlus_ProgressFormat] or PROGRESS_SAMPLES.PERCENT
			forces = forces .. " " .. Color(progress, CONTEXT_COLOR)
		end
	end

	return {
		main = JoinWithSpace(
			LevelText(db, E.mylevel + SAMPLE_ENEMY_LEVEL_OFFSET),
			Color(_G.ENEMY or "Enemy", NH.COLOR_HOSTILE)
		),
		header = JoinWithSpace(Color("Elite", NH.COLOR_ELITE)),
		sub = NH.ICON_LIST .. "3/8 " .. (_G.QUESTS_LABEL or ""),
		forces = forces,
		forcesRight = db.mythicPlus_DisplayRight,
	}
end

local function Build(widget)
	widget.frame:SetClipsChildren(true)
	widget.player = CreateSample(widget.frame)
	widget.enemy = CreateSample(widget.frame)
end

local function Update(widget)
	local db = E.db.mui.nameHover
	local width = widget.frame:GetWidth()

	-- The cursor tips sit in the lower half, the lines grow upwards from there
	widget.player:ClearAllPoints()
	widget.player:SetPoint("CENTER", widget.frame, "BOTTOMLEFT", width * 0.28, HEIGHT * 0.45)
	widget.enemy:ClearAllPoints()
	widget.enemy:SetPoint("CENTER", widget.frame, "BOTTOMLEFT", width * 0.7, HEIGHT * 0.45)

	SetLines(widget.player, db, PlayerLines(db))
	SetLines(widget.enemy, db, EnemyLines(db))

	Preview.SetEnabled(widget, db.enable)
end

Preview.Register("MERNameHoverPreview", 1, HEIGHT, Build, Update)
