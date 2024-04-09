local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_InstanceDifficulty")
local MM = E:GetModule("Minimap")

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

	if instanceType == "party" or instanceType == "raid" or instanceType == "scenario" then
		local text = module:GetTextForDifficulty(difficulty, false)

		if not text then
			self:Log("debug", format("difficutly %s not found", difficulty))
			text = ""
		end

		text = gsub(text, "%%mplus%%", mplusdiff)
		text = gsub(text, "%%numPlayers%%", numplayers)
		self.frame.text:SetText(text)
	elseif instanceType == "pvp" or instanceType == "arena" then
		self.frame.text:SetText(module:GetTextForDifficulty(-1, false))
	else
		self.frame.text:SetText("")
	end

	if not inInstance then
		self.frame:Hide()
	else
		self.frame:Show()
	end
end

function module:GetTextForDifficulty(difficulty, useDefault)
	local db = useDefault and P.maps.instanceDifficulty.customStrings or self.db.customStrings
	local text = {
		[-1] = db["PvP"],
		[1] = db["5-player Normal"],
		[2] = db["5-player Heroic"],
		[3] = db["10-player Normal"],
		[4] = db["25-player Normal"],
		[5] = db["10-player Heroic"],
		[6] = db["25-player Heroic"],
		[7] = db["Looking for Raid"],
		[8] = db["Mythic Keystone"],
		[9] = db["40-player"],
		[11] = db["Heroic Scenario"],
		[12] = db["Normal Scenario"],
		[14] = db["Normal Raid"],
		[15] = db["Heroic Raid"],
		[16] = db["Mythic Raid"],
		[17] = db["Looking for Raid"],
		[18] = db["Event Scenario"],
		[19] = db["Event Scenario"],
		[20] = db["Event Scenario"],
		[23] = db["Mythic Party"],
		[24] = db["Timewalking"],
		[25] = db["World PvP Scenario"],
		[29] = db["PvEvP Scenario"],
		[30] = db["Event Scenario"],
		[32] = db["PvP"],
		[33] = db["Timewalking Raid"],
		[34] = db["PvP Heroic"],
		[38] = db["Normal Scenario"],
		[39] = db["Heroic Scenario"],
		[40] = db["Mythic Scenario"],
		[45] = db["PvP"],
		[147] = db["Warfronts Normal"],
		[149] = db["Warfronts Heroic"],
	}

	return text[difficulty]
end

function module:ConstructFrame()
	self.db = E.db.mui.maps.instanceDifficulty

	if not self.db then
		return
	end

	local frame = CreateFrame("Frame", "MER_InstanceDifficultyFrame", _G.Minimap)
	frame:Size(64, 32)
	frame:Point("TOPLEFT", MM.MapHolder, "TOPLEFT", 10, -10)

	local texture = frame:CreateTexture(nil, "BACKGROUND")
	texture:SetAllPoints()
	texture:SetTexture(I.Media.Textures.Difficulty)
	texture:SetVertexColor(0, 0.75, 0.98, 0.45)
	frame.texture = texture

	local text = frame:CreateFontString(nil, "OVERLAY")
	F.SetFontDB(text, self.db.font)
	text:Point(self.db.align or "LEFT")
	frame.text = text

	E:CreateMover(
		frame,
		"MER_InstanceDifficultyFrameMover",
		L["Instance Difficulty"],
		nil,
		nil,
		nil,
		"ALL,MERATHILISUI",
		function()
			return E.db.mui.maps.minimap.difficulty.enable
		end,
		"mui,modules,maps"
	)

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

	for _, frame in pairs({ instanceFrame, guildFrame, challengeModeFrame }) do
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
