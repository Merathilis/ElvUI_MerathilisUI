local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local module = MER:GetModule('MER_InstanceDifficulty')
local MM = E:GetModule('Minimap')

local _G = _G
local format = format
local pairs = pairs
local select = select

local CreateFrame = CreateFrame
local GetInstanceInfo = GetInstanceInfo
local MinimapCluster = MinimapCluster
local IsInInstance = IsInInstance

local C_ChallengeMode_GetActiveKeystoneInfo = C_ChallengeMode.GetActiveKeystoneInfo

function module:UpdateFrame()
	local inInstance, instanceType = IsInInstance()
	local difficulty = select(3, GetInstanceInfo())
	local numplayers = select(9, GetInstanceInfo())
	local mplusdiff = select(1, C_ChallengeMode_GetActiveKeystoneInfo()) or ""

	local norm = format("|cff1eff00%s|r", L["Normal"])
	local hero = format("|cff0070dd%s|r", L["Heroic"])
	local myth = format("|cffa335ee%s|r", L["Mythic"])
	local lfr = format("|cffff8000%s|r", L["Looking for Raid"])

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
			self.frame.text:SetText(format("|cffff3860%s|r", L["Mythic Keystone"]) .. mplusdiff)
		elseif difficulty == 9 then -- 40 Player
			self.frame.text:SetText("40")
		elseif difficulty == 11 or difficulty == 39 then -- Heroic Scenario / Heroic
			self.frame.text:SetText(format("%s %s", hero, L["Scenario"]))
		elseif difficulty == 12 or difficulty == 38 then -- Normal Scenario / Normal
			self.frame.text:SetText(format("%s %s", norm, L["Scenario"]))
		elseif difficulty == 40 then -- Mythic Scenario
			self.frame.text:SetText(format("%s %s", myth, L["Scenario"]))
		elseif difficulty == 14 then -- Normal Raid
			self.frame.text:SetText(numplayers .. norm)
		elseif difficulty == 15 then -- Heroic Raid
			self.frame.text:SetText(numplayers .. hero)
		elseif difficulty == 16 then -- Mythic Raid
			self.frame.text:SetText(numplayers .. myth)
		elseif difficulty == 17 then -- LFR
			self.frame.text:SetText(numplayers .. lfr)
		elseif difficulty == 18 or difficulty == 19 or difficulty == 20 or difficulty == 30 then -- Event / Event Scenario
			self.frame.text:SetText(L["Event Scenario"])
		elseif difficulty == 23 then -- Mythic Party
			self.frame.text:SetText("5" .. myth)
		elseif difficulty == 24 or difficulty == 33 then -- Timewalking /Timewalking Raid
			self.frame.text:SetText(L["Timewalking"])
		elseif difficulty == 25 or difficulty == 32 or difficulty == 34 or difficulty == 45 then -- World PvP Scenario / PvP / PvP Heroic
			self.frame.text:SetText(format("|cffFFFF00%s |r", "PvP"))
		elseif difficulty == 29 then -- PvEvP Scenario
			self.frame.text:SetText("PvEvP")
		elseif difficulty == 147 then -- Normal Scenario (Warfronts)
			self.frame.text:SetText(L["[Warfronts"])
		elseif difficulty == 149 then -- Heroic Scenario (Warfronts)
			self.frame.text:SetText(format("|cffff7d0aH|r%s", L["Warfronts"]))
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
	self.db = E.db.mui.maps.instanceDifficulty

	if not self.db then
		return
	end

	local frame = CreateFrame("Frame", "MER_InstanceDifficultyFrame", _G.Minimap)
	frame:Size(64, 32)
	frame:Point("TOPLEFT", MM.MapHolder, "TOPLEFT", 10, -10)

	local texture = frame:CreateTexture(nil, 'BACKGROUND')
	texture:SetAllPoints()
	texture:SetTexture(MER.Media.Textures.MinimapDifficulty)
	texture:SetVertexColor(0, .75, .98, .45)
	frame.texture = texture

	local text = frame:CreateFontString(nil, "OVERLAY")
	F.SetFontDB(text, self.db.font)
	text:Point(self.db.align or "LEFT")
	frame.text = text

	E:CreateMover(frame, "MER_InstanceDifficultyFrameMover", L["Instance Difficulty"], nil, nil, nil, "ALL,MERATHILISUI", function() return E.db.mui.maps.minimap.difficulty.enable end, "mui,modules,maps")

	self.frame = frame
end

function module:HideBlizzardDifficulty(difficultyFrame, isShown)
	if not self.db or not self.db.hideBlizzard or not isShown then
		return
	end

	difficultyFrame:Hide()
end

function module:Initialize()
	self.db = E.db.mui.maps.instanceDifficulty

	if not self.db or not self.db.enable then
		return
	end

	self:ConstructFrame()

	local difficulty = MinimapCluster.InstanceDifficulty
	local instanceFrame = difficulty.Instance
	local guildFrame = difficulty.Guild
	local challengeModeFrame = difficulty.ChallengeMode

	for _, frame in pairs({instanceFrame, guildFrame, challengeModeFrame}) do
		if frame then
			frame:Hide()
			self:SecureHook(frame, "SetShown", "HideBlizzardDifficulty")
		end
	end

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
