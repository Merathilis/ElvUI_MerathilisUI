local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_InstanceDifficulty')

local _G = _G
local pairs = pairs
local format = string.format

local CreateFrame = CreateFrame
local GetInstanceInfo = GetInstanceInfo
local IsInInstance = IsInInstance

local C_ChallengeMode_GetActiveKeystoneInfo = C_ChallengeMode.GetActiveKeystoneInfo

function module:UpdateFrame()
	local inInstance, instanceType = IsInInstance()
	local difficulty = select(3, GetInstanceInfo())
	local numplayers = select(9, GetInstanceInfo())
	local mplusdiff = select(1, C_ChallengeMode_GetActiveKeystoneInfo()) or ""

	local norm = format("|cff1eff00%s|r", "N")
	local hero = format("|cff0070dd%s|r", "H")
	local myth = format("|cffa335ee%s|r", "M")
	local lfr = format("|cffff8000%s|r", "LFR")

	if instanceType == "party" or instanceType == "raid" or instanceType == "scenario" then
		if (difficulty == 1) then -- Normal
			self.frame.text:SetText("5" .. norm)
		elseif difficulty == 2 then -- Heroic
			self.frame.text:SetText("5" .. hero)
		elseif difficulty == 3 then -- 10 Player
			self.frame.text:SetText("10" .. norm)
		elseif difficulty == 4 then -- 25 Player
			self.frame.text:SetText("25" .. norm)
		elseif difficulty == 5 then -- 10 Player (Heroic)
			self.frame.text:SetText("10" .. hero)
		elseif difficulty == 6 then -- 25 Player (Heroic)
			self.frame.text:SetText("25" .. hero)
		elseif difficulty == 7 then -- LFR (Legacy)
			self.frame.text:SetText(lfr)
		elseif difficulty == 8 then -- Mythic Keystone
			self.frame.text:SetText(format("|cffff0000%s|r", "M+") .. mplusdiff)
		elseif difficulty == 9 then -- 40 Player
			self.frame.text:SetText("40")
		elseif difficulty == 11 or difficulty == 39 then -- Heroic Scenario / Heroic
			self.frame.text:SetText(format("%s %s", hero, "Scen"))
		elseif difficulty == 12 or difficulty == 38 then -- Normal Scenario / Normal
			self.frame.text:SetText(format("%s %s", norm, "Scen"))
		elseif difficulty == 40 then -- Mythic Scenario
			self.frame.text:SetText(format("%s %s", myth, "Scen"))
		elseif difficulty == 14 then -- Normal Raid
			self.frame.text:SetText(numplayers .. norm)
		elseif difficulty == 15 then -- Heroic Raid
			self.frame.text:SetText(numplayers .. hero)
		elseif difficulty == 16 then -- Mythic Raid
			self.frame.text:SetText(numplayers .. myth)
		elseif difficulty == 17 then -- LFR
			self.frame.text:SetText(numplayers .. lfr)
		elseif difficulty == 18 or difficulty == 19 or difficulty == 20 or difficulty == 30 then -- Event / Event Scenario
			self.frame.text:SetText('EScen')
		elseif difficulty == 23 then -- Mythic Party
			self.frame.text:SetText("5" .. myth)
		elseif difficulty == 24 or difficulty == 33 then -- Timewalking /Timewalking Raid
			self.frame.text:SetText('TW')
		elseif difficulty == 25 or difficulty == 32 or difficulty == 34 or difficulty == 45 then -- World PvP Scenario / PvP / PvP Heroic
			self.frame.text:SetText(format("|cffFFFF00%s |r", "PvP"))
		elseif difficulty == 29 then -- PvEvP Scenario
			self.frame.text:SetText("PvEvP")
		elseif difficulty == 147 then -- Normal Scenario (Warfronts)
			self.frame.text:SetText(L["[ABBR] Warfronts"])
		elseif difficulty == 149 then -- Heroic Scenario (Warfronts)
			self.frame.text:SetText(format('|cffff7d0aH|rWF'))
		end
	elseif instanceType == "pvp" or instanceType == "arena" then
		self.frame.text:SetText(format("|cffFFFF00%s|r", "PvP"))
	else
		self.frame.text:SetText("")
	end

	if not inInstance then
		self.frame:Hide()
	else
		self.frame:Show()
	end
end

function module:ConstructFrame()
	if not self.db then
		return
	end

	local frame = CreateFrame("Frame", "InstanceDifficultyFrame", _G.Minimap)
	frame:Size(30, 20)
	frame:Point("TOPLEFT", _G.MMHolder, "TOPLEFT", 10, -10)

	local text = frame:CreateFontString(nil, "OVERLAY")
	F.SetFontDB(text, self.db.font)
	text:Point("CENTER")
	frame.text = text

	E:CreateMover(frame, "InstanceDifficultyFrameMover", L["Instance Difficulty"], nil, nil, nil, "ALL,MERATHILISUI", function() return E.db.mui.maps.minimap.difficulty.enable end, "mui,modules,maps")

	self.frame = frame
end

function module:UpdateBlizzardDifficulty()
	if not self or not self.db or not self.db.hideBlizzard then
		return
	end

	local frames = {
		"MiniMapInstanceDifficulty",
		"GuildInstanceDifficulty",
		"MiniMapChallengeMode"
	}

	for _, v in pairs(frames) do
		if _G[v] then
			_G[v]:Kill()
		end
	end
end

function module:Initialize()
	self.db = E.db.mui.maps.minimap.instanceDifficulty

	if not self.db or not self.db.enable then
		return
	end

	self:ConstructFrame()
	self:UpdateBlizzardDifficulty()

	self:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdateFrame")
	self:RegisterEvent("CHALLENGE_MODE_START", "UpdateFrame")
	self:RegisterEvent("CHALLENGE_MODE_COMPLETED", "UpdateFrame")
	self:RegisterEvent("CHALLENGE_MODE_RESET", "UpdateFrame")
	self:RegisterEvent("PLAYER_DIFFICULTY_CHANGED", "UpdateFrame")
	self:RegisterEvent("GUILD_PARTY_STATE_UPDATED", "UpdateFrame")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "UpdateFrame")
	self:RegisterEvent("GROUP_ROSTER_UPDATE", "UpdateFrame")
end

MER:RegisterModule(module:GetName())
