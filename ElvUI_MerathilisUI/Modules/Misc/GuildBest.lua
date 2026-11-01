local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc") ---@class Misc
local WS = W:GetModule("Skins")

-- Mythic+ is not part of Forever
if E.Forever then
	return
end

local _G = _G
local format = format
local hooksecurefunc = hooksecurefunc
local ipairs = ipairs
local sort = sort

local CreateFrame = CreateFrame
local GameTooltip = GameTooltip
local GameTooltip_Hide = GameTooltip_Hide
local IsInGuild = IsInGuild
local C_ChallengeMode_GetGuildLeaders = C_ChallengeMode.GetGuildLeaders
local C_ChallengeMode_GetKeystoneLevelRarityColor = C_ChallengeMode.GetKeystoneLevelRarityColor
local C_ChallengeMode_GetMapUIInfo = C_ChallengeMode.GetMapUIInfo

local PANEL_WIDTH = 190
local ROW_HEIGHT = 16
local TITLE_HEIGHT = 26
local PADDING = 8
local LEVEL_WIDTH = 28

local panel

---@param a table
---@param b table
---@return boolean
local function SortByLevel(a, b)
	if a.keystoneLevel ~= b.keystoneLevel then
		return a.keystoneLevel > b.keystoneLevel
	end

	return a.mapChallengeModeID < b.mapChallengeModeID
end

---@param tooltip GameTooltip
---@param name string
---@param class string
local function AddClassLine(tooltip, name, class)
	local color = E:ClassColor(class, true)
	if color then
		tooltip:AddLine(name, color.r, color.g, color.b)
	else
		tooltip:AddLine(name)
	end
end

local function Row_OnEnter(self)
	local run = self.run
	if not run then
		return
	end

	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:AddLine(format("%s +%d", self.dungeon:GetText(), run.keystoneLevel), 1, 1, 1)
	for _, member in ipairs(run.members) do
		AddClassLine(GameTooltip, member.name, member.classFileName)
	end
	GameTooltip:Show()
end

---@param index number
---@return Frame
local function GetRow(index)
	local row = panel.rows[index]
	if row then
		return row
	end

	row = CreateFrame("Frame", nil, panel)
	row:SetPoint("TOPLEFT", panel, "TOPLEFT", PADDING, -TITLE_HEIGHT - (index - 1) * ROW_HEIGHT)
	row:SetPoint("RIGHT", panel, "RIGHT", -PADDING, 0)
	row:SetHeight(ROW_HEIGHT)
	row:EnableMouse(true)
	row:SetScript("OnEnter", Row_OnEnter)
	row:SetScript("OnLeave", GameTooltip_Hide)

	row.level = row:CreateFontString(nil, "OVERLAY")
	row.level:FontTemplate(nil, 12, "SHADOWOUTLINE")
	row.level:SetPoint("LEFT")
	row.level:SetWidth(LEVEL_WIDTH)
	row.level:SetJustifyH("LEFT")

	row.dungeon = row:CreateFontString(nil, "OVERLAY")
	row.dungeon:FontTemplate(nil, 12, "SHADOWOUTLINE")
	row.dungeon:SetPoint("LEFT", row.level, "RIGHT", 2, 0)
	row.dungeon:SetPoint("RIGHT")
	row.dungeon:SetJustifyH("LEFT")
	row.dungeon:SetWordWrap(false)

	panel.rows[index] = row
	return row
end

local function CreatePanel()
	panel = CreateFrame("Frame", "MER_GuildBest", _G.ChallengesFrame)
	panel:SetPoint("TOPRIGHT", _G.ChallengesFrame, "TOPRIGHT", -6, -22)
	panel:SetWidth(PANEL_WIDTH)
	panel:CreateBackdrop("Transparent")
	WS:CreateBackdropShadow(panel)
	panel.rows = {}

	panel.title = panel:CreateFontString(nil, "OVERLAY")
	panel.title:FontTemplate(nil, 13, "SHADOWOUTLINE")
	panel.title:SetPoint("TOPLEFT", PADDING, -PADDING)
	panel.title:SetText(L["Guild Best"])

	local classColor = E:ClassColor(E.myclass, true)
	panel.title:SetTextColor(classColor.r, classColor.g, classColor.b)

	panel.empty = panel:CreateFontString(nil, "OVERLAY")
	panel.empty:FontTemplate(nil, 12, "SHADOWOUTLINE")
	panel.empty:SetPoint("TOPLEFT", PADDING, -TITLE_HEIGHT)
	panel.empty:SetTextColor(0.7, 0.7, 0.7)
	panel.empty:SetText(L["No runs this week"])
end

-- Runs on every Blizzard update of the window, which also covers the leaders arriving after it opened
local function Refresh()
	-- RaiderIO's own panel sits in the same spot and only exists while its option is on
	if _G.RaiderIO_GuildWeeklyFrame or not IsInGuild() then
		if panel then
			panel:Hide()
		end
		return
	end

	if not panel then
		CreatePanel()
	end

	local runs = C_ChallengeMode_GetGuildLeaders() or {}
	sort(runs, SortByLevel)

	for index, run in ipairs(runs) do
		local row = GetRow(index)
		local color = C_ChallengeMode_GetKeystoneLevelRarityColor(run.keystoneLevel)
		row.run = run
		row.level:SetFormattedText("+%d", run.keystoneLevel)
		row.level:SetTextColor(color:GetRGB())
		row.dungeon:SetText(C_ChallengeMode_GetMapUIInfo(run.mapChallengeModeID) or "")
		row:Show()
	end

	for index = #runs + 1, #panel.rows do
		panel.rows[index].run = nil
		panel.rows[index]:Hide()
	end

	panel.empty:SetShown(#runs == 0)
	panel:SetHeight(TITLE_HEIGHT + (#runs > 0 and #runs or 1) * ROW_HEIGHT + PADDING)
	panel:Show()
end

function module:GuildBest()
	if E.db.mui.misc.guildBest then
		hooksecurefunc(_G.ChallengesFrame, "Update", Refresh)
	end
end

module:AddCallbackForAddon("Blizzard_ChallengesUI", module.GuildBest)
