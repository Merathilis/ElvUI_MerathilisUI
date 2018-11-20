local MER, E, L, V, P, G = unpack(select(2, ...))
local MI = MER:GetModule("mUIMisc")

-- Cache global variables
-- Lua functions
local _G = _G
local select = select
-- WoW API / Variables
local CreateFrame = CreateFrame
local C_ChallengeMode_GetGuildLeaders = C_ChallengeMode.GetGuildLeaders
local C_ChallengeMode_GetMapUIInfo = C_ChallengeMode.GetMapUIInfo
local IsAddOnLoaded = IsAddOnLoaded

-- Global variables that we don"t cache, list them here for the mikk"s Find Globals script
-- GLOBALS: hooksecurefunc, CHALLENGE_MODE_GUILD_BEST_LINE, CHALLENGE_MODE_POWER_LEVEL, CHALLENGE_MODE_GUILD_BEST_LINE
-- GLOBALS: CHALLENGE_MODE_THIS_WEEK, CHALLENGE_MODE_GUILD_BEST_LINE_YOU

function MI:GuildBest()
	local frame

	local function UpdateTooltip(self)
		local leaderInfo = self.leaderInfo
		if not leaderInfo then return end

		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		local name = C_ChallengeMode_GetMapUIInfo(leaderInfo.mapChallengeModeID)
		GameTooltip:SetText(name, 1, 1, 1)
		GameTooltip:AddLine(CHALLENGE_MODE_POWER_LEVEL:format(leaderInfo.keystoneLevel))

		for i = 1, #leaderInfo.members do
			local classColorStr = MER.ClassColors[leaderInfo.members[i].classFileName].colorStr
			GameTooltip:AddLine(CHALLENGE_MODE_GUILD_BEST_LINE:format(classColorStr,leaderInfo.members[i].name))
		end
		GameTooltip:Show()
	end

	local function CreateBoard()
		frame = CreateFrame("Frame", nil, _G["ChallengesFrame"])
		frame:SetPoint("BOTTOMRIGHT", -6, 80)
		frame:SetSize(170, 105)
		frame:CreateBackdrop("Transparent")
		MER:CreateFS(frame, 16, CHALLENGE_MODE_THIS_WEEK , "system", "TOPLEFT", 16, -6)

		frame.entries = {}
		for i = 1, 4 do
			local entry = CreateFrame("Frame", nil, frame)
			entry:SetPoint("LEFT", 10, 0)
			entry:SetPoint("RIGHT", -10, 0)
			entry:SetHeight(18)
			entry.CharacterName = MER:CreateFS(entry, 14, "", false, "LEFT", 6, 0)
			entry.CharacterName:SetPoint("RIGHT", -30, 0)
			entry.CharacterName:SetJustifyH("LEFT")
			entry.Level = MER:CreateFS(entry, 14, "", "system")
			entry.Level:SetJustifyH("LEFT")
			entry.Level:ClearAllPoints()
			entry.Level:SetPoint("LEFT", entry, "RIGHT", -22, 0)
			entry:SetScript("OnEnter", UpdateTooltip)
			entry:SetScript("OnLeave", GameTooltip_Hide)

			if i == 1 then
				entry:SetPoint("TOP", frame, 0, -26)
			else
				entry:SetPoint("TOP", frame.entries[i-1], "BOTTOM")
			end

			frame.entries[i] = entry
		end
	end

	local function SetUpRecord(self, leaderInfo)
		self.leaderInfo = leaderInfo
		local str = CHALLENGE_MODE_GUILD_BEST_LINE
		if leaderInfo.isYou then
			str = CHALLENGE_MODE_GUILD_BEST_LINE_YOU
		end

		local classColorStr = MER.ClassColors[leaderInfo.classFileName].colorStr
		self.CharacterName:SetText(str:format(classColorStr, leaderInfo.name))
		self.Level:SetText(leaderInfo.keystoneLevel)
	end

	local resize
	local function UpdateGuildBest(self)
		if not frame then CreateBoard() end
		if self.leadersAvailable then
			local leaders = C_ChallengeMode_GetGuildLeaders()
			if leaders and #leaders > 0 then
				for i = 1, #leaders do
					SetUpRecord(frame.entries[i], leaders[i])
				end
				frame:Show()
			else
				frame:Hide()
			end
		end

		if not resize and IsAddOnLoaded("AngryKeystones") then
			local scheduel = select(4, self:GetChildren())
			frame:SetWidth(246)
			frame:ClearAllPoints()
			frame:SetPoint("BOTTOMLEFT", scheduel, "TOPLEFT", 0, 10)

			self.WeeklyInfo.Child.Label:SetPoint("TOP", -135, -25)
			local affix = self.WeeklyInfo.Child.Affixes[1]
			if affix then
				affix:ClearAllPoints()
				affix:SetPoint("TOPLEFT", 20, -55)
			end

			resize = true
		end
	end

	local function ChallengesOnLoad(event, addon)
		if addon == "Blizzard_ChallengesUI" then
			hooksecurefunc("ChallengesFrame_Update", UpdateGuildBest)

			MER:UnregisterEvent(event)
		end
	end
	MER:RegisterEvent("ADDON_LOADED", ChallengesOnLoad)
end
