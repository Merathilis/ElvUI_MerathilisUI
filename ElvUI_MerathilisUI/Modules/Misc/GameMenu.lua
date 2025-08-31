local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc") ---@class Misc

local _G = _G
local pairs = pairs
local random = math.random

local CreateFrame = CreateFrame
local GetGuildInfo = GetGuildInfo
local GetSpecialization = GetSpecialization
local GetSpecializationInfoForClassID = GetSpecializationInfoForClassID
local GetTotalAchievementPoints = GetTotalAchievementPoints
local UIFrameFadeIn = UIFrameFadeIn
local UnitClassBase = UnitClassBase
local UnitLevel = UnitLevel

local C_CurrencyInfo_GetCurrencyInfo = C_CurrencyInfo.GetCurrencyInfo
local C_MountJournal_GetMountInfoByID = C_MountJournal.GetMountInfoByID
local C_ToyBox_GetNumLearnedDisplayedToys = C_ToyBox.GetNumLearnedDisplayedToys
local C_PetJournal_GetNumPets = C_PetJournal.GetNumPets
local C_QuestLog_IsQuestFlaggedCompleted = C_QuestLog.IsQuestFlaggedCompleted
local C_MythicPlus_GetOwnedKeystoneChallengeMapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID
local C_MythicPlus_GetOwnedKeystoneLevel = C_MythicPlus.GetOwnedKeystoneLevel
local C_ChallengeMode_GetMapUIInfo = C_ChallengeMode.GetMapUIInfo
local C_ChallengeMode_GetKeystoneLevelRarityColor = C_ChallengeMode.GetKeystoneLevelRarityColor
local C_PlayerInfo_GetPlayerMythicPlusRatingSummary = C_PlayerInfo.GetPlayerMythicPlusRatingSummary
local C_ChallengeMode_GetDungeonScoreRarityColor = C_ChallengeMode.GetDungeonScoreRarityColor
local C_MythicPlus_GetRunHistory = C_MythicPlus.GetRunHistory

local GameMenuFrame = _G.GameMenuFrame

local delvesKeys = { 91175, 91176, 91177, 91178 }
local keyName = C_CurrencyInfo_GetCurrencyInfo(3028).name

-- Credit for the Class logos: ADDOriN @DevianArt
-- http://addorin.deviantart.com/gallery/43689290/World-of-Warcraft-Class-Logos

MER.NPCS = {
	86470, -- Pepe
	-- Shadowlands
	172854, -- Dredger Butler
	173992, -- Torghast Lurker
	-- Dragonflight
	188844, -- Humduck Livingsworth the Third
	184285, -- Gnomelia Gearheart
	-- The War Within
	222078, -- Wriggle
	222877, -- Ghostcap Menace
	222532, -- Bouncer
	223399, -- Tickler
	231713, -- Bluedoo
	237715, -- Swabbie
}

local Sequences = { 26, 52, 69, 111, 225 }

function module:GameMenu_OnShow()
	local db = F.GetDBFromPath("mui.gameMenu")

	local iconsDb = E.db.mui.armory.icons
	local guildName = GetGuildInfo("player")

	local specIcon = ""

	local _, classId = UnitClassBase("player")
	local specIndex = GetSpecialization()
	local id = GetSpecializationInfoForClassID(classId, specIndex)

	if id and id ~= 0 and iconsDb then
		specIcon = iconsDb[id]
	else
		specIcon = ""
	end

	local m = function(num)
		return num * 4
	end

	local outerSpacing = 100

	local collections
	local delves
	local mythic

	local mainFrame = CreateFrame("Frame", nil, E.UIParent)
	mainFrame:SetAllPoints(E.UIParent)
	mainFrame:SetFrameStrata("HIGH")
	mainFrame:OffsetFrameLevel(-1, GameMenuFrame)
	mainFrame:EnableMouse(true)

	mainFrame.bg = mainFrame:CreateTexture(nil, "BACKGROUND")
	mainFrame.bg:SetAllPoints(mainFrame)
	mainFrame.bg:SetTexture(I.Media.Textures.Clean)

	local bgColor = db.bgColor
	local alpha = db.bgColor.a
	mainFrame.bg:SetVertexColor(bgColor.r, bgColor.g, bgColor.b, alpha)

	local bottomPanel = CreateFrame("Frame", nil, mainFrame, "BackdropTemplate")
	bottomPanel:Point("BOTTOM", E.UIParent, "BOTTOM", 0, -E.Border)
	bottomPanel:Width(E.screenWidth + (E.Border * 2))
	bottomPanel:CreateBackdrop("Transparent")

	bottomPanel.ignoreFrameTemplates = true
	bottomPanel.ignoreBackdropColors = true
	E["frames"][bottomPanel] = true

	bottomPanel.anim = _G.CreateAnimationGroup(bottomPanel)
	bottomPanel.anim.height = bottomPanel.anim:CreateAnimation("Height")
	bottomPanel.anim.height:SetChange(E.screenHeight * (1 / 4))
	bottomPanel.anim.height:SetDuration(0.6)
	bottomPanel:Height(0)
	bottomPanel.anim.height:Play()

	bottomPanel.Logo = bottomPanel:CreateTexture(nil, "OVERLAY")
	bottomPanel.Logo:Size(100)
	bottomPanel.Logo:Point("CENTER", bottomPanel, "TOP", 0, -80)
	bottomPanel.Logo:SetTexture(I.General.MediaPath .. "Textures\\mUI1_Shadow.tga")

	bottomPanel.nameText = bottomPanel:CreateFontString(nil, "OVERLAY")
	bottomPanel.nameText:FontTemplate(nil, 32)
	bottomPanel.nameText:SetTextColor(1, 1, 1, 1)
	bottomPanel.nameText:Point("TOP", bottomPanel.Logo, "BOTTOM", 0, -5)
	bottomPanel.nameText:SetText(F.String.GradientClass(E.myname))

	bottomPanel.guildText = bottomPanel:CreateFontString(nil, "OVERLAY")
	bottomPanel.guildText:FontTemplate(nil, 16)
	bottomPanel.guildText:Point("TOP", bottomPanel.nameText, "BOTTOM", 0, 0)
	bottomPanel.guildText:SetTextColor(1, 1, 1, 1)
	bottomPanel.guildText:SetText(
		guildName and F.String.FastGradientHex("<" .. guildName .. ">", "06c910", "33ff3d") or ""
	)

	bottomPanel.specIcon = bottomPanel:CreateFontString(nil, "OVERLAY")
	bottomPanel.specIcon:SetFont("Interface\\AddOns\\ElvUI_MerathilisUI\\Media\\Fonts\\ToxiUIIcons.ttf", 20, "OUTLINE")
	bottomPanel.specIcon:Point("TOP", bottomPanel.guildText, "BOTTOM", 0, -15)
	bottomPanel.specIcon:SetTextColor(1, 1, 1, 1)
	if specIcon then
		bottomPanel.specIcon:SetText(F.String.Class(specIcon))
	end

	bottomPanel.levelText = bottomPanel:CreateFontString(nil, "OVERLAY")
	bottomPanel.levelText:FontTemplate(nil, 20, "OUTLINE")
	bottomPanel.levelText:Point("RIGHT", bottomPanel.specIcon, "LEFT", -4, 0)
	bottomPanel.levelText:SetTextColor(1, 1, 1, 1)
	bottomPanel.levelText:SetText("Lvl " .. E.mylevel)

	bottomPanel.classText = bottomPanel:CreateFontString(nil, "OVERLAY")
	bottomPanel.classText:FontTemplate(nil, 20, "OUTLINE")
	bottomPanel.classText:Point("LEFT", bottomPanel.specIcon, "RIGHT", 4, 0)
	bottomPanel.classText:SetTextColor(1, 1, 1, 1)
	bottomPanel.classText:SetText(F.String.GradientClass(E.myLocalizedClass, nil, true))

	local topPanel = CreateFrame("Frame", nil, mainFrame, "BackdropTemplate")
	topPanel:Point("TOP", E.UIParent, "TOP", 0, 0)
	topPanel:Width(E.screenWidth + (E.Border * 2))
	topPanel:CreateBackdrop("Transparent")

	topPanel.ignoreFrameTemplates = true
	topPanel.ignoreBackdropColors = true
	E["frames"][topPanel] = true

	topPanel.anim = _G.CreateAnimationGroup(topPanel)
	topPanel.anim.height = topPanel.anim:CreateAnimation("Height")
	topPanel.anim.height:SetChange(E.screenHeight * (1 / 4))
	topPanel.anim.height:SetDuration(0.6)
	topPanel:Height(0)
	topPanel.anim.height:Play()

	topPanel.factionLogo = topPanel:CreateTexture(nil, "ARTWORK")
	topPanel.factionLogo:Point("CENTER", topPanel, "CENTER", 0, 0)
	topPanel.factionLogo:Size(186, 186)
	topPanel.factionLogo:SetTexture(I.General.MediaPath .. "Textures\\ClassBanner\\CLASS-" .. E.myclass)

	local topTextHolderLeft = CreateFrame("Frame", nil, topPanel)
	topTextHolderLeft:Point("LEFT", topPanel, "BOTTOMLEFT", 5, 0)
	topTextHolderLeft:Width(E.screenWidth * 0.5)
	topTextHolderLeft:Height(E.screenHeight * (1 / 4) - 20)
	self.topTextHolderLeft = topTextHolderLeft

	if db and db.showCollections then
		collections = topTextHolderLeft:CreateFontString(nil, "ARTWORK")
		collections:Point("TOPLEFT", topTextHolderLeft, outerSpacing, outerSpacing)
		collections:FontTemplate(nil, 24, "SHADOWOUTLINE")
		collections:SetTextColor(1, 1, 1, 1)
		collections:SetText(F.String.GradientClass(L["Collections"]))

		local collectedMounts = 0
		if E.MountIDs then
			for _, value in pairs(E.MountIDs) do
				local _, _, _, _, _, _, _, _, _, _, isCollected = C_MountJournal_GetMountInfoByID(value)
				if isCollected then
					collectedMounts = collectedMounts + 1
				end
			end
		end

		collections.mount = topTextHolderLeft:CreateFontString(nil, "ARTWORK")
		collections.mount:Point("TOPLEFT", collections, "BOTTOMLEFT", 0, m(-6))
		collections.mount:FontTemplate(nil, 16, "SHADOWOUTLINE")
		collections.mount:SetTextColor(1, 1, 1, 1)
		collections.mount:SetText(L["Mounts: "] .. F.String.MERATHILISUI(collectedMounts))

		collections.toys = topTextHolderLeft:CreateFontString(nil, "OVERLAY")
		collections.toys:FontTemplate(nil, 16, "SHADOWOUTLINE")
		collections.toys:Point("TOPLEFT", collections.mount, "BOTTOMLEFT", 0, m(-1))
		collections.toys:SetTextColor(1, 1, 1, 1)
		collections.toys:SetText(L["Toys: "] .. F.String.MERATHILISUI(C_ToyBox_GetNumLearnedDisplayedToys()))

		local _, petsOwned = C_PetJournal_GetNumPets()
		collections.pets = topTextHolderLeft:CreateFontString(nil, "OVERLAY")
		collections.pets:Point("TOPLEFT", collections.toys, "BOTTOMLEFT", 0, m(-1))
		collections.pets:FontTemplate(nil, 16, "SHADOWOUTLINE")
		collections.pets:SetTextColor(1, 1, 1, 1)
		collections.pets:SetText(L["Pets: "] .. F.String.MERATHILISUI(petsOwned))

		collections.achievs = topTextHolderLeft:CreateFontString(nil, "OVERLAY")
		collections.achievs:SetPoint("TOPLEFT", collections.pets, "BOTTOMLEFT", 0, m(-3))
		collections.achievs:FontTemplate(nil, 16, "SHADOWOUTLINE")
		collections.achievs:SetTextColor(1, 1, 1, 1)
		collections.achievs:SetText(
			L["Achievement Points: "] .. F.String.MERATHILISUI(E:FormatLargeNumber(GetTotalAchievementPoints(), ","))
		)

		self.topTextHolderLeft.collections = collections
	end

	local topTextHolderRight = CreateFrame("Frame", nil, topPanel)
	topTextHolderRight:Point("RIGHT", topPanel, "BOTTOMRIGHT", -5, 0)
	topTextHolderRight:Width(E.screenWidth * 0.5)
	topTextHolderRight:Height(E.screenHeight * (1 / 4) - 20)
	self.topTextHolderRight = topTextHolderRight

	local currentKeys, maxKeys = 0, #delvesKeys
	for _, questID in pairs(delvesKeys) do
		if C_QuestLog_IsQuestFlaggedCompleted(questID) then
			currentKeys = currentKeys + 1
		end
	end

	if db and db.showWeeklyDevles and currentKeys > 0 then
		delves = topTextHolderRight:CreateFontString(nil, "ARTWORK")
		delves:FontTemplate(nil, 24, "SHADOWOUTLINE")
		delves:Point("TOPRIGHT", topTextHolderRight, -outerSpacing, outerSpacing)
		delves:SetTextColor(1, 1, 1, 1)
		delves:SetText(F.String.GradientClass(L["Weekly Delves Keys"]))

		local coloredCurrentKeys
		if currentKeys == maxKeys then
			coloredCurrentKeys = "|cffFF0000" .. currentKeys .. "|r"
		else
			coloredCurrentKeys = "|cff00FF00" .. currentKeys .. "|r"
		end

		delves.Info = topTextHolderRight:CreateFontString(nil, "ARTWORK")
		delves.Info:FontTemplate(nil, 16, "SHADOWOUTLINE")
		delves.Info:Point("TOPRIGHT", delves, "BOTTOMRIGHT", 0, m(-6))
		delves.Info:SetText(keyName .. ": " .. format("%s/%d", coloredCurrentKeys, #delvesKeys))

		self.topTextHolderLeft.delves = delves
	end

	local bottomTextHolderLeft = CreateFrame("Frame", nil, bottomPanel)
	bottomTextHolderLeft:Point("LEFT", bottomPanel, "TOPLEFT", 5, 0)
	bottomTextHolderLeft:Width(E.screenWidth * 0.5)
	bottomTextHolderLeft:Height(E.screenHeight * (1 / 4) - 20)
	self.bottomTextHolderLeft = bottomTextHolderLeft

	if db and db.showMythicKey and UnitLevel("player") >= I.MaxLevelTable[MER.MetaFlavor] then
		mythic = bottomTextHolderLeft:CreateFontString(nil, "OVERLAY")
		mythic:FontTemplate(nil, 24, "SHADOWOUTLINE")
		mythic:Point("TOPLEFT", bottomTextHolderLeft, outerSpacing, -outerSpacing * 1.5)
		mythic:SetTextColor(1, 1, 1, 1)
		mythic:SetText(F.String.GradientClass(L["Mythic+"]))

		mythic.keystone = bottomTextHolderLeft:CreateFontString(nil, "OVERLAY")
		mythic.keystone:FontTemplate(nil, 16, "SHADOWOUTLINE")
		mythic.keystone:Point("TOPLEFT", mythic, "BOTTOMLEFT", 0, m(-6))
		mythic.keystone:SetTextColor(1, 1, 1, 1)

		if db.showMythicScore then
			mythic.score = bottomTextHolderLeft:CreateFontString(nil, "OVERLAY")
			mythic.score:FontTemplate(nil, 16, "SHADOWOUTLINE")
			mythic.score:Point("TOPLEFT", mythic.keystone, "BOTTOMLEFT", 0, m(-1))
			mythic.score:SetTextColor(1, 1, 1, 1)
		end

		mythic.latestRuns = bottomTextHolderLeft:CreateFontString(nil, "OVERLAY")
		mythic.latestRuns:FontTemplate(nil, 16, "SHADOWOUTLINE")
		mythic.latestRuns:Point(
			"TOPLEFT",
			db.showMythicScore and mythic.score or mythic.keystone,
			"BOTTOMLEFT",
			0,
			m(-4)
		)

		for i = 1, 10 do
			mythic["history" .. i] = bottomTextHolderLeft:CreateFontString(nil, "OVERLAY")
			mythic["history" .. i]:FontTemplate(nil, 16, "SHADOWOUTLINE")
			mythic["history" .. i]:SetTextColor(1, 1, 1, 1)

			if i == 1 then
				mythic["history" .. i]:Point("TOPLEFT", mythic.latestRuns, "BOTTOMLEFT", 0, m(-2))
			else
				mythic["history" .. i]:Point("TOPLEFT", mythic["history" .. (i - 1)], "BOTTOMLEFT", 0, m(-1))
			end
		end

		self.bottomTextHolderLeft.mythic = mythic
		self.bottomTextHolderLeft.mythic.keystone = mythic.keystone
	end

	-- Use this frame to control the position of the model - taken from ElvUI
	local modelHolder = CreateFrame("Frame", nil, mainFrame)
	modelHolder:Size(150)
	modelHolder:Point("RIGHT", GameMenuFrame, "LEFT", -300, 0)

	local playerKey = random(1, 5)
	local playerEmote = Sequences[playerKey]

	local playerModel = CreateFrame("PlayerModel", nil, modelHolder)
	playerModel:Point("CENTER", modelHolder, "CENTER")
	playerModel:Size(E.screenWidth * 2, E.screenHeight * 2) --YES, double screen size. This prevents clipping of models.
	playerModel:SetScale(0.8)
	playerModel:SetAlpha(1)
	playerModel:ClearModel()
	playerModel:SetUnit("player")
	playerModel:SetFacing(6.5)
	playerModel:SetPortraitZoom(0.05)
	playerModel:SetCamDistanceScale(4.8)
	playerModel:SetAnimation(playerEmote)
	UIFrameFadeIn(playerModel, 1, playerModel:GetAlpha(), 1)
	playerModel.isIdle = nil

	local npcHolder = CreateFrame("Frame", nil, mainFrame)
	npcHolder:Size(150)
	npcHolder:Point("LEFT", GameMenuFrame, "RIGHT", 300, 0)

	local npc = MER.NPCS
	local mod = random(1, #npc)
	local npcID = npc[mod]
	local npcKey = random(1, 5)
	local npcEmote = Sequences[npcKey]

	local npcModel = CreateFrame("PlayerModel", nil, npcHolder)
	npcModel:Point("CENTER", npcHolder, "CENTER")
	npcModel:Size(256)
	npcModel:SetScale(0.8)
	npcModel:SetAlpha(1)

	npcModel:ClearModel()
	npcModel:SetCreature(npcID)
	npcModel:SetCamDistanceScale(1)
	npcModel:SetFacing(6)
	npcModel:SetAnimation(npcEmote)
	UIFrameFadeIn(self, 1, npcModel:GetAlpha(), 1)
	npcModel.isIdle = nil

	self.mainFrame = mainFrame
	self.mainFrame:Show()

	-- self.bottomTextHolderRight = bottomTextHolderRight

	self.modelHolder = modelHolder
	self.npcHolder = npcHolder

	if self.bottomTextHolderLeft.mythic then
		-- Update keystone text
		do
			local keystoneMapID = C_MythicPlus_GetOwnedKeystoneChallengeMapID()
			local keystoneLevel = C_MythicPlus_GetOwnedKeystoneLevel()
			local keystoneTextPrefix = L["Current Keystone: "]

			local text

			if keystoneMapID and keystoneMapID > 0 then
				local dungeonName = C_ChallengeMode_GetMapUIInfo(keystoneMapID) or L["Unknown"]
				local colorObj = C_ChallengeMode_GetKeystoneLevelRarityColor(keystoneLevel)
				local levelText = "+" .. keystoneLevel

				local levelColored = levelText
				if colorObj and colorObj.GenerateHexColor then
					levelColored = F.String.Color(levelText, colorObj:GenerateHexColor())
				end

				text = keystoneTextPrefix .. F.String.MERATHILISUI(dungeonName .. " (" .. levelColored .. ")")
			else
				text = keystoneTextPrefix .. F.String.MERATHILISUI("N/A")
			end

			mythic.keystone:SetText(text)
		end

		-- Update Mythic+ score
		do
			if db.showMythicScore then
				local info = C_PlayerInfo_GetPlayerMythicPlusRatingSummary("player")
				if info and info.currentSeasonScore then
					local prefix = L["M+ Score: "]
					local score = info.currentSeasonScore
					if score > 0 then
						local color = C_ChallengeMode_GetDungeonScoreRarityColor(score)
						mythic.score:SetText(prefix .. F.String.Color(score, color:GenerateHexColor()))
					else
						mythic.score:SetText(prefix .. F.String.MERATHILISUI(L["N/A"]))
					end
				end
			end
		end

		-- Update M+ history
		do
			local history = C_MythicPlus_GetRunHistory(false, true)
			local historyLimit = db.mythicHistoryLimit
			for i = 1, 10 do
				local historyFrame = mythic["history" .. i]
				if historyFrame then
					local historyRun = history[#history - i + 1]
					if historyRun and i <= historyLimit then
						if i == 1 then
							mythic.latestRuns:SetText(F.String.GradientClass(L["Latest runs"]))
						end

						local historyDungeonName = C_ChallengeMode_GetMapUIInfo(historyRun.mapChallengeModeID)
							or "Unknown"
						local colorObj = C_ChallengeMode_GetKeystoneLevelRarityColor(historyRun.level)
						local levelText = "+" .. historyRun.level
						local levelColored = levelText
						if colorObj and colorObj.GenerateHexColor then
							levelColored = F.String.Color(levelText, colorObj:GenerateHexColor())
						end
						local output = ("%s (%s)"):format(historyDungeonName, levelColored)
						historyFrame:SetText(historyRun.completed and F.String.Good(output) or F.String.Error(output))
					else
						historyFrame:SetText("")
					end
				end
			end
		end
	end
end

function module:GameMenu_OnHide()
	if self.mainFrame then
		self.mainFrame:Hide()
	end
end

function module:GameMenu()
	module.db = F.GetDBFromPath("mui.gameMenu")

	if not MER:HasRequirements(I.Requirements.GameMenu) or not module.db or not module.db.enable then
		return
	end

	self:SecureHookScript(GameMenuFrame, "OnShow", module.GameMenu_OnShow)
	self:SecureHookScript(GameMenuFrame, "OnHide", module.GameMenu_OnHide)
end

module:AddCallback("GameMenu")
