local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc") ---@class Misc

local _G = _G
local date = date
local ipairs, pairs, format, random = ipairs, pairs, format, math.random
local abs, cos, sin, tan, max, pi = math.abs, math.cos, math.sin, math.tan, math.max, math.pi
local sort = table.sort

local CreateFrame = CreateFrame
local GetGuildInfo = GetGuildInfo
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
local C_DateAndTime_GetCurrentCalendarTime = C_DateAndTime and C_DateAndTime.GetCurrentCalendarTime
local C_DateAndTime_GetSecondsUntilWeeklyReset = C_DateAndTime and C_DateAndTime.GetSecondsUntilWeeklyReset
local C_WeeklyRewards_GetActivities = C_WeeklyRewards and C_WeeklyRewards.GetActivities
local GameTime_GetTime = GameTime_GetTime
local SecondsToTime = SecondsToTime
local CALENDAR_WEEKDAY_NAMES = _G.CALENDAR_WEEKDAY_NAMES
local CALENDAR_FULLDATE_MONTH_NAMES = _G.CALENDAR_FULLDATE_MONTH_NAMES

local GameMenuFrame = _G.GameMenuFrame
local CreateAnimationGroup = _G.CreateAnimationGroup

local delvesKeys = { 91175, 91176, 91177, 91178 }
local keyName = C_CurrencyInfo_GetCurrencyInfo(3028).name

-- Credit for the Class logos: ADDOriN @DevianArt
-- http://addorin.deviantart.com/gallery/43689290/World-of-Warcraft-Class-Logos

-- Creature display IDs (the model viewer's display ID on the wowhead NPC page), NPC ID in brackets
local NPC_DISPLAY_IDS = {
	59624, -- Pepe (86470)
	-- Shadowlands
	99901, -- Dredger Butler (172854)
	99923, -- Torghast Lurker (173992)
	-- Dragonflight
	113909, -- Humduck Livingsworth the Third (188844)
	105003, -- Gnomelia Gearheart (184285)
	-- The War Within
	114831, -- Wriggle (222078)
	118222, -- Ghostcap Menace (222877)
	119179, -- Bouncer (222532)
	114052, -- Tickler (223399)
	123008, -- Bluedoo (231713)
	121701, -- Swabbie (237715)
	-- Midnight
	139771, -- Roofus (256698)
	128292, -- Nova (257695)
	136053, -- Voldy (257546)
	-- Midnight 12.1
	145543, -- Cat'Thuzad (268672)
	123070, -- Lil'Kruul (262210)
	143092, -- Furiostraza (262220)
	145546, -- Amewbisath (268676)
	145535, -- Archmage's Familiar (268636)
	142375, -- Pale Hexscale (269712)
	143111, -- Zesty (271086)
}

-- Every NPC model is scaled until its largest side has the same length, so small
-- critters and big pets end up the same size on screen
local NPC_FIT_SIZE = 1
local NPC_CAMERA_FOV = pi / 6
-- Room around the measured box, the emote animations reach past the standing pose
local NPC_CAMERA_MARGIN = 1.6
local NPC_CAMERA_DISTANCE = NPC_FIT_SIZE * 0.5 / tan(NPC_CAMERA_FOV * 0.5) * NPC_CAMERA_MARGIN
local NPC_YAW = 6 -- turned slightly towards the menu
-- Right after a model swap the actor can still report the previous model's box,
-- so measurements only count after NPC_FIT_MIN; NPC_FIT_TIMEOUT shows it in any case
local NPC_FIT_MIN = 0.3
local NPC_FIT_TIMEOUT = 1.5

local Sequences = { 26, 52, 69, 111, 225 }

local function m(num)
	return num * 4
end

local OUTER_SPACING = 100

-- The panels need 0.6s to open, the content blocks follow one after the other
local FADE_START = 0.45
local FADE_STEP = 0.1
local FADE_DURATION = 0.5
local CLOCK_INTERVAL = 1

-- Great Vault rows in the order of Blizzard's own window
local VAULT_ROWS = {}
do
	local types = Enum.WeeklyRewardChestThresholdType
	for _, row in ipairs({ { "Raid", RAIDS }, { "Activities", DUNGEONS }, { "World", WORLD } }) do
		if types and types[row[1]] then
			VAULT_ROWS[#VAULT_ROWS + 1] = { type = types[row[1]], label = row[2] }
		end
	end
end
local VAULT_SLOTS = 3
local VAULT_SLOT_SIZE = 12

local function SetupFadeIn(frame, delay)
	local group = CreateAnimationGroup(frame)

	group.hold = group:CreateAnimation("Sleep")
	group.hold:SetDuration(delay)
	group.hold:SetOrder(1)

	group.fade = group:CreateAnimation("Fade")
	group.fade:SetChange(1)
	group.fade:SetDuration(FADE_DURATION)
	group.fade:SetEasing("out-quintic")
	group.fade:SetOrder(2)

	frame.fadeIn = group
end

---Scale the actor to NPC_FIT_SIZE and aim the camera at it, returns the measured size
local function FitNPC(scene, actor)
	local bottomX, bottomY, bottomZ, topX, topY, topZ = actor:GetActiveBoundingBox()
	if not topZ then
		return
	end

	local size = max(topX - bottomX, topY - bottomY, topZ - bottomZ)
	if size <= 0 then
		return
	end

	local changed = not scene.lastSize or abs(size - scene.lastSize) > size * 0.01
	if changed and F.Developer.IsDebugging("GameMenu") then
		local maxBottomX, maxBottomY, maxBottomZ, maxTopX, maxTopY, maxTopZ = actor:GetMaxBoundingBox()
		F.Developer.Debug(
			"GameMenu",
			format(
				"NPC %d: active %.2f x %.2f x %.2f, max %.2f x %.2f x %.2f, scale %.2f -> %.2f",
				scene.displayID or 0,
				topX - bottomX,
				topY - bottomY,
				topZ - bottomZ,
				(maxTopX or 0) - (maxBottomX or 0),
				(maxTopY or 0) - (maxBottomY or 0),
				(maxTopZ or 0) - (maxBottomZ or 0),
				actor:GetScale(),
				NPC_FIT_SIZE / size
			)
		)
	end

	local scale = NPC_FIT_SIZE / size
	actor:SetScale(scale)

	-- Aim at the middle of the scaled model, the box is in model space before the yaw
	local centerX, centerY = (bottomX + topX) * 0.5, (bottomY + topY) * 0.5
	local yaw = actor:GetYaw()
	local targetX = (centerX * cos(yaw) - centerY * sin(yaw)) * scale
	local targetY = (centerX * sin(yaw) + centerY * cos(yaw)) * scale
	local targetZ = (bottomZ + topZ) * 0.5 * scale
	scene:SetCameraPosition(targetX + NPC_CAMERA_DISTANCE, targetY, targetZ)

	return size
end

local function StartNPCFit(scene)
	scene.fitTime = 0
	scene.lastSize = nil
end

-- Refits until the measured size holds for two frames, then shows the NPC
local function NPCScene_OnUpdate(scene, elapsed)
	if not scene.fitTime then
		return
	end

	local actor = scene.actor
	scene.fitTime = scene.fitTime + elapsed

	if actor:IsLoaded() then
		local size = FitNPC(scene, actor)
		local lastSize = scene.lastSize
		if size and lastSize and scene.fitTime >= NPC_FIT_MIN and abs(size - lastSize) <= size * 0.01 then
			-- Done, the animation would keep changing the box from here on
			scene.fitTime = nil
			if not scene.shown then
				scene.shown = true
				actor:SetAnimation(scene.animation)
				actor:SetAlpha(1)
			end
			return
		end
		scene.lastSize = size
	end

	if scene.fitTime >= NPC_FIT_TIMEOUT then
		scene.fitTime = nil
		if not scene.shown then
			scene.shown = true
			actor:SetAnimation(scene.animation)
			actor:SetAlpha(1)
		end
	end
end

local function UpdateClock(holder)
	local timeText = GameTime_GetTime and GameTime_GetTime(true) or date("%H:%M")
	holder.time:SetText(F.String.GradientClass(timeText))

	local dateText
	local now = C_DateAndTime_GetCurrentCalendarTime and C_DateAndTime_GetCurrentCalendarTime()
	if now and CALENDAR_WEEKDAY_NAMES and CALENDAR_FULLDATE_MONTH_NAMES then
		dateText = format(
			FULLDATE,
			CALENDAR_WEEKDAY_NAMES[now.weekday],
			CALENDAR_FULLDATE_MONTH_NAMES[now.month],
			now.monthDay,
			now.year
		)
	else
		dateText = date("%d.%m.%Y")
	end
	holder.date:SetText(dateText)

	local reset = C_DateAndTime_GetSecondsUntilWeeklyReset and C_DateAndTime_GetSecondsUntilWeeklyReset()
	if reset and reset > 0 then
		holder.reset:SetText(
			format(L["Weekly reset in %s"], F.String.MERATHILISUI(SecondsToTime(reset, true, false, 2)))
		)
	else
		holder.reset:SetText("")
	end
end

local function Clock_OnUpdate(holder, elapsed)
	holder.elapsed = (holder.elapsed or 0) + elapsed
	if holder.elapsed < CLOCK_INTERVAL then
		return
	end

	holder.elapsed = 0
	UpdateClock(holder)
end

---Build the static Game Menu UI once
function module:CreateGameMenuUI()
	if self.mainFrame then
		return
	end

	local db = E.db.mui.gameMenu

	local mainFrame = CreateFrame("Frame", "MER_GameMenuFrame", E.UIParent)
	mainFrame:SetAllPoints(E.UIParent)
	mainFrame:SetFrameStrata("HIGH")
	mainFrame:OffsetFrameLevel(-1, GameMenuFrame)
	mainFrame:EnableMouse(true)
	mainFrame:Hide()

	mainFrame.bg = mainFrame:CreateTexture(nil, "BACKGROUND")
	mainFrame.bg:SetAllPoints(mainFrame)
	mainFrame.bg:SetTexture(I.Media.Textures.Clean)

	-- Bottom panel
	local bottomPanel = CreateFrame("Frame", nil, mainFrame, "BackdropTemplate")
	bottomPanel:Point("BOTTOM", E.UIParent, "BOTTOM", 0, -E.Border)
	bottomPanel:Width(E.screenWidth + (E.Border * 2))
	bottomPanel:CreateBackdrop("Transparent")
	bottomPanel.ignoreFrameTemplates = true
	bottomPanel.ignoreBackdropColors = true
	E.frames[bottomPanel] = true

	bottomPanel.anim = CreateAnimationGroup(bottomPanel)
	bottomPanel.anim.height = bottomPanel.anim:CreateAnimation("Height")
	bottomPanel.anim.height:SetDuration(0.6)

	bottomPanel.Logo = bottomPanel:CreateTexture(nil, "OVERLAY")
	bottomPanel.Logo:Size(100)
	bottomPanel.Logo:Point("CENTER", bottomPanel, "TOP", 0, -80)
	bottomPanel.Logo:SetTexture(I.General.MediaPath .. "Textures\\mUI1_Shadow.tga")

	-- Name, guild and spec fade in together
	local infoHolder = CreateFrame("Frame", nil, bottomPanel)
	infoHolder:SetAllPoints(bottomPanel)

	bottomPanel.nameText = infoHolder:CreateFontString(nil, "OVERLAY")
	bottomPanel.nameText:FontTemplate(nil, 32)
	bottomPanel.nameText:SetTextColor(1, 1, 1, 1)
	bottomPanel.nameText:Point("TOP", bottomPanel.Logo, "BOTTOM", 0, -5)

	bottomPanel.guildText = infoHolder:CreateFontString(nil, "OVERLAY")
	bottomPanel.guildText:FontTemplate(nil, 16)
	bottomPanel.guildText:Point("TOP", bottomPanel.nameText, "BOTTOM", 0, 0)
	bottomPanel.guildText:SetTextColor(1, 1, 1, 1)

	bottomPanel.specIcon = infoHolder:CreateFontString(nil, "OVERLAY")
	bottomPanel.specIcon:SetFont("Interface\\AddOns\\ElvUI_MerathilisUI\\Media\\Fonts\\Armory_Icons.ttf", 20, "OUTLINE")
	bottomPanel.specIcon:Point("TOP", bottomPanel.guildText, "BOTTOM", 0, -15)
	bottomPanel.specIcon:SetTextColor(1, 1, 1, 1)

	bottomPanel.levelText = infoHolder:CreateFontString(nil, "OVERLAY")
	bottomPanel.levelText:FontTemplate(nil, 20, "OUTLINE")
	bottomPanel.levelText:Point("RIGHT", bottomPanel.specIcon, "LEFT", -4, 0)
	bottomPanel.levelText:SetTextColor(1, 1, 1, 1)

	bottomPanel.classText = infoHolder:CreateFontString(nil, "OVERLAY")
	bottomPanel.classText:FontTemplate(nil, 20, "OUTLINE")
	bottomPanel.classText:Point("LEFT", bottomPanel.specIcon, "RIGHT", 4, 0)
	bottomPanel.classText:SetTextColor(1, 1, 1, 1)

	-- Top panel
	local topPanel = CreateFrame("Frame", nil, mainFrame, "BackdropTemplate")
	topPanel:Point("TOP", E.UIParent, "TOP", 0, 0)
	topPanel:Width(E.screenWidth + (E.Border * 2))
	topPanel:CreateBackdrop("Transparent")
	topPanel.ignoreFrameTemplates = true
	topPanel.ignoreBackdropColors = true
	E.frames[topPanel] = true

	topPanel.anim = CreateAnimationGroup(topPanel)
	topPanel.anim.height = topPanel.anim:CreateAnimation("Height")
	topPanel.anim.height:SetDuration(0.6)

	topPanel.factionLogo = topPanel:CreateTexture(nil, "ARTWORK")
	topPanel.factionLogo:Point("CENTER", topPanel, "CENTER", 0, 0)
	topPanel.factionLogo:Size(186, 186)
	topPanel.factionLogo:SetTexture(I.General.MediaPath .. "Textures\\ClassBanner\\CLASS-" .. E.myclass)

	-- Top left holder (collections)
	local topTextHolderLeft = CreateFrame("Frame", nil, topPanel)
	topTextHolderLeft:Point("LEFT", topPanel, "BOTTOMLEFT", 5, 0)
	topTextHolderLeft:Width(E.screenWidth * 0.5)
	topTextHolderLeft:Height(E.screenHeight * (1 / 4) - 20)

	if db.showCollections then
		local collections = topTextHolderLeft:CreateFontString(nil, "ARTWORK")
		collections:Point("TOPLEFT", topTextHolderLeft, OUTER_SPACING, OUTER_SPACING)
		collections:FontTemplate(nil, 24, "SHADOWOUTLINE")
		collections:SetTextColor(1, 1, 1, 1)
		collections:SetText(F.String.GradientClass(L["Collections"]))

		collections.mount = topTextHolderLeft:CreateFontString(nil, "ARTWORK")
		collections.mount:Point("TOPLEFT", collections, "BOTTOMLEFT", 0, m(-6))
		collections.mount:FontTemplate(nil, 16, "SHADOWOUTLINE")
		collections.mount:SetTextColor(1, 1, 1, 1)

		collections.toys = topTextHolderLeft:CreateFontString(nil, "OVERLAY")
		collections.toys:FontTemplate(nil, 16, "SHADOWOUTLINE")
		collections.toys:Point("TOPLEFT", collections.mount, "BOTTOMLEFT", 0, m(-1))
		collections.toys:SetTextColor(1, 1, 1, 1)

		collections.pets = topTextHolderLeft:CreateFontString(nil, "OVERLAY")
		collections.pets:Point("TOPLEFT", collections.toys, "BOTTOMLEFT", 0, m(-1))
		collections.pets:FontTemplate(nil, 16, "SHADOWOUTLINE")
		collections.pets:SetTextColor(1, 1, 1, 1)

		collections.achievs = topTextHolderLeft:CreateFontString(nil, "OVERLAY")
		collections.achievs:SetPoint("TOPLEFT", collections.pets, "BOTTOMLEFT", 0, m(-3))
		collections.achievs:FontTemplate(nil, 16, "SHADOWOUTLINE")
		collections.achievs:SetTextColor(1, 1, 1, 1)

		topTextHolderLeft.collections = collections
	end

	-- Top right holder (delves)
	local topTextHolderRight = CreateFrame("Frame", nil, topPanel)
	topTextHolderRight:Point("RIGHT", topPanel, "BOTTOMRIGHT", -5, 0)
	topTextHolderRight:Width(E.screenWidth * 0.5)
	topTextHolderRight:Height(E.screenHeight * (1 / 4) - 20)

	-- Clock, date and weekly reset, mirrors the collections block; the delves keys go below it
	local clockHolder = CreateFrame("Frame", nil, topPanel)
	clockHolder:Size(400, 80)
	clockHolder:Point("TOPRIGHT", topTextHolderRight, -OUTER_SPACING, OUTER_SPACING)

	clockHolder.time = clockHolder:CreateFontString(nil, "OVERLAY")
	clockHolder.time:FontTemplate(nil, 24, "SHADOWOUTLINE")
	clockHolder.time:Point("TOPRIGHT", clockHolder, "TOPRIGHT")

	clockHolder.date = clockHolder:CreateFontString(nil, "OVERLAY")
	clockHolder.date:FontTemplate(nil, 16, "SHADOWOUTLINE")
	clockHolder.date:Point("TOPRIGHT", clockHolder.time, "BOTTOMRIGHT", 0, m(-6))
	clockHolder.date:SetTextColor(1, 1, 1, 1)

	clockHolder.reset = clockHolder:CreateFontString(nil, "OVERLAY")
	clockHolder.reset:FontTemplate(nil, 16, "SHADOWOUTLINE")
	clockHolder.reset:Point("TOPRIGHT", clockHolder.date, "BOTTOMRIGHT", 0, m(-1))
	clockHolder.reset:SetTextColor(1, 1, 1, 1)

	clockHolder:SetScript("OnUpdate", Clock_OnUpdate)

	if db.showWeeklyDevles then
		local delves = topTextHolderRight:CreateFontString(nil, "ARTWORK")
		delves:FontTemplate(nil, 24, "SHADOWOUTLINE")
		delves:Point("TOPRIGHT", topTextHolderRight, -OUTER_SPACING, OUTER_SPACING)
		delves:SetTextColor(1, 1, 1, 1)
		delves:SetText(F.String.GradientClass(L["Weekly Delves Keys"]))

		delves.Info = topTextHolderRight:CreateFontString(nil, "ARTWORK")
		delves.Info:FontTemplate(nil, 16, "SHADOWOUTLINE")
		delves.Info:Point("TOPRIGHT", delves, "BOTTOMRIGHT", 0, m(-6))

		topTextHolderRight.delves = delves
	end

	-- Bottom left holder (mythic+)
	local bottomTextHolderLeft = CreateFrame("Frame", nil, bottomPanel)
	bottomTextHolderLeft:Point("LEFT", bottomPanel, "TOPLEFT", 5, 0)
	bottomTextHolderLeft:Width(E.screenWidth * 0.5)
	bottomTextHolderLeft:Height(E.screenHeight * (1 / 4) - 20)

	if db.showMythicKey then
		local mythic = bottomTextHolderLeft:CreateFontString(nil, "OVERLAY")
		mythic:FontTemplate(nil, 24, "SHADOWOUTLINE")
		mythic:Point("TOPLEFT", bottomTextHolderLeft, OUTER_SPACING, -OUTER_SPACING * 1.5)
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

		bottomTextHolderLeft.mythic = mythic
	end

	-- Bottom right holder (great vault)
	local bottomTextHolderRight = CreateFrame("Frame", nil, bottomPanel)
	bottomTextHolderRight:Point("RIGHT", bottomPanel, "TOPRIGHT", -5, 0)
	bottomTextHolderRight:Width(E.screenWidth * 0.5)
	bottomTextHolderRight:Height(E.screenHeight * (1 / 4) - 20)

	-- Off on Forever like the delves and Mythic+ blocks
	if db.showGreatVault and not E.Forever and C_WeeklyRewards_GetActivities and #VAULT_ROWS > 0 then
		local vault = bottomTextHolderRight:CreateFontString(nil, "OVERLAY")
		vault:FontTemplate(nil, 24, "SHADOWOUTLINE")
		vault:Point("TOPRIGHT", bottomTextHolderRight, -OUTER_SPACING, -OUTER_SPACING * 1.5)
		vault:SetTextColor(1, 1, 1, 1)
		vault:SetText(F.String.GradientClass(L["Great Vault"]))

		-- Per row: name, one box per vault slot (filled once unlocked) and the progress of the next slot
		vault.rows = {}
		local anchor = vault
		for i, info in ipairs(VAULT_ROWS) do
			local row = CreateFrame("Frame", nil, bottomTextHolderRight)
			row:Size(300, 20)
			row:Point("TOPRIGHT", anchor, "BOTTOMRIGHT", 0, i == 1 and m(-6) or m(-1))
			row.type = info.type

			row.progress = row:CreateFontString(nil, "OVERLAY")
			row.progress:FontTemplate(nil, 16, "SHADOWOUTLINE")
			row.progress:SetJustifyH("RIGHT")
			row.progress:Width(50)
			row.progress:Point("RIGHT", row, "RIGHT")

			row.slots = {}
			for slotIndex = VAULT_SLOTS, 1, -1 do
				local slot = CreateFrame("Frame", nil, row)
				slot:Size(VAULT_SLOT_SIZE)
				slot:SetTemplate()

				-- A texture instead of the backdrop color, ElvUI's template refresh would reset that
				slot.fill = slot:CreateTexture(nil, "ARTWORK")
				slot.fill:SetInside()
				slot.fill:SetTexture(E.media.blankTex)
				slot.fill:Hide()

				if slotIndex == VAULT_SLOTS then
					slot:Point("RIGHT", row.progress, "LEFT", -10, 0)
				else
					slot:Point("RIGHT", row.slots[slotIndex + 1], "LEFT", -4, 0)
				end
				row.slots[slotIndex] = slot
			end

			row.label = row:CreateFontString(nil, "OVERLAY")
			row.label:FontTemplate(nil, 16, "SHADOWOUTLINE")
			row.label:SetTextColor(1, 1, 1, 1)
			row.label:Point("RIGHT", row.slots[1], "LEFT", -10, 0)
			row.label:SetText(info.label)

			vault.rows[i] = row
			anchor = row
		end

		bottomTextHolderRight.vault = vault
	end

	-- Player model
	local modelHolder = CreateFrame("Frame", nil, mainFrame)
	modelHolder:Size(150)
	modelHolder:Point("RIGHT", GameMenuFrame, "LEFT", -300, 0)

	local playerModel = CreateFrame("PlayerModel", nil, modelHolder)
	playerModel:Point("CENTER", modelHolder, "CENTER")
	playerModel:Size(E.screenWidth * 2, E.screenHeight * 2)
	playerModel:SetScale(0.8)
	playerModel:SetAlpha(1)

	-- Optional NPC, a model scene instead of a model frame: only an actor tells its size
	local npcHolder, npcScene
	if db.showRandomPets then
		npcHolder = CreateFrame("Frame", nil, mainFrame)
		npcHolder:Size(150)
		npcHolder:Point("LEFT", GameMenuFrame, "RIGHT", 300, 0)

		npcScene = CreateFrame("ModelScene", nil, npcHolder)
		npcScene:Point("CENTER", npcHolder, "CENTER")
		npcScene:Size(320)
		npcScene:SetScale(0.8)
		npcScene:SetCameraFieldOfView(NPC_CAMERA_FOV)
		npcScene:SetCameraNearClip(0.01)
		npcScene:SetCameraFarClip(100)
		npcScene:SetCameraOrientationByYawPitchRoll(pi, 0, 0) -- looking at the model's front
		npcScene:SetLightVisible(true)
		npcScene:SetLightType(Enum.ModelLightType.Directional)
		npcScene:SetLightDirection(-0.8, 0.3, -0.5)
		npcScene:SetLightAmbientColor(0.7, 0.7, 0.7)
		npcScene:SetLightDiffuseColor(0.8, 0.8, 0.8)

		npcScene.actor = npcScene:CreateActor()
		npcScene.actor:SetYaw(NPC_YAW)
		npcScene:SetScript("OnUpdate", NPCScene_OnUpdate)
	end

	-- Content blocks fade in one after the other once the panels open
	self.fadeFrames = {
		infoHolder,
		clockHolder,
		topTextHolderLeft,
		topTextHolderRight,
		bottomTextHolderLeft,
		bottomTextHolderRight,
	}
	for i, frame in ipairs(self.fadeFrames) do
		SetupFadeIn(frame, FADE_START + (i - 1) * FADE_STEP)
	end

	-- Store refs
	self.mainFrame = mainFrame
	self.infoHolder = infoHolder
	self.clockHolder = clockHolder
	self.bottomTextHolderRight = bottomTextHolderRight
	self.bottomPanel = bottomPanel
	self.topPanel = topPanel
	self.topTextHolderLeft = topTextHolderLeft
	self.topTextHolderRight = topTextHolderRight
	self.bottomTextHolderLeft = bottomTextHolderLeft
	self.modelHolder = modelHolder
	self.playerModel = playerModel
	self.npcHolder = npcHolder
	self.npcScene = npcScene
end

---Refresh dynamic player/spec info on the bottom panel
local function UpdatePlayerInfo(self)
	local bottomPanel = self.bottomPanel
	local iconsDb = E.db.mui.armory and E.db.mui.armory.icons
	local guildName = GetGuildInfo("player")

	local _, classId = UnitClassBase("player")
	local specIndex = F.GetPlayerSpec()
	local id = specIndex and GetSpecializationInfoForClassID(classId, specIndex)
	local specIcon = (id and id ~= 0 and iconsDb and iconsDb[id]) or ""

	bottomPanel.nameText:SetText(F.String.GradientClass(E.myname))
	bottomPanel.guildText:SetText(
		guildName and F.String.FastGradientHex("<" .. guildName .. ">", "06c910", "33ff3d") or ""
	)
	bottomPanel.specIcon:SetText(specIcon ~= "" and F.String.Class(specIcon) or "")
	bottomPanel.levelText:SetText("Lvl " .. E.mylevel)
	bottomPanel.classText:SetText(F.String.GradientClass(E.myLocalizedClass, nil, true))
end

---Refresh collections counts
local function UpdateCollections(self)
	local collections = self.topTextHolderLeft and self.topTextHolderLeft.collections
	if not collections then
		return
	end

	local collectedMounts = 0
	if E.MountIDs then
		for _, value in pairs(E.MountIDs) do
			local _, _, _, _, _, _, _, _, _, _, isCollected = C_MountJournal_GetMountInfoByID(value)
			if isCollected then
				collectedMounts = collectedMounts + 1
			end
		end
	end

	collections.mount:SetText(L["Mounts: "] .. F.String.MERATHILISUI(collectedMounts))
	collections.toys:SetText(L["Toys: "] .. F.String.MERATHILISUI(C_ToyBox_GetNumLearnedDisplayedToys()))

	local _, petsOwned = C_PetJournal_GetNumPets()
	collections.pets:SetText(L["Pets: "] .. F.String.MERATHILISUI(petsOwned))
	collections.achievs:SetText(
		L["Achievement Points: "] .. F.String.MERATHILISUI(E:FormatLargeNumber(GetTotalAchievementPoints(), ","))
	)
end

---Refresh weekly delves key progress
local function UpdateDelves(self)
	local delves = self.topTextHolderRight and self.topTextHolderRight.delves
	if not delves then
		return
	end

	local currentKeys, maxKeys = 0, #delvesKeys
	for _, questID in pairs(delvesKeys) do
		if C_QuestLog_IsQuestFlaggedCompleted(questID) then
			currentKeys = currentKeys + 1
		end
	end

	if currentKeys > 0 then
		delves:Show()
		delves.Info:Show()
		local coloredCurrentKeys = currentKeys == maxKeys and ("|cffFF0000" .. currentKeys .. "|r")
			or ("|cff00FF00" .. currentKeys .. "|r")
		delves.Info:SetText(keyName .. ": " .. format("%s/%d", coloredCurrentKeys, maxKeys))
	else
		delves:Hide()
		delves.Info:Hide()
	end
end

---Refresh mythic+ keystone, score and history
local function UpdateMythic(self, db)
	local mythic = self.bottomTextHolderLeft and self.bottomTextHolderLeft.mythic
	if not mythic then
		return
	end

	local maxLevel = I.MaxLevelTable[MER.MetaFlavor]
	if UnitLevel("player") < maxLevel then
		mythic:Hide()
		return
	end
	mythic:Show()

	-- Keystone
	local keystoneMapID = C_MythicPlus_GetOwnedKeystoneChallengeMapID()
	local keystoneLevel = C_MythicPlus_GetOwnedKeystoneLevel()
	local keystoneTextPrefix = L["Current Keystone: "]

	if keystoneMapID and keystoneMapID > 0 then
		local dungeonName = C_ChallengeMode_GetMapUIInfo(keystoneMapID) or L["Unknown"]
		local colorObj = C_ChallengeMode_GetKeystoneLevelRarityColor(keystoneLevel)
		local levelText = "+" .. keystoneLevel
		local levelColored = levelText
		if colorObj and colorObj.GenerateHexColor then
			levelColored = F.String.Color(levelText, colorObj:GenerateHexColor())
		end
		mythic.keystone:SetText(keystoneTextPrefix .. F.String.MERATHILISUI(dungeonName .. " (" .. levelColored .. ")"))
	else
		mythic.keystone:SetText(keystoneTextPrefix .. F.String.MERATHILISUI("N/A"))
	end

	-- Score
	if db.showMythicScore and mythic.score then
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

	-- History
	local history = C_MythicPlus_GetRunHistory(false, true)
	local historyLimit = db.mythicHistoryLimit or 0
	local hasAny = false

	for i = 1, 10 do
		local historyFrame = mythic["history" .. i]
		if historyFrame then
			local historyRun = history[#history - i + 1]
			if historyRun and i <= historyLimit then
				hasAny = true
				local historyDungeonName = C_ChallengeMode_GetMapUIInfo(historyRun.mapChallengeModeID) or "Unknown"
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

	mythic.latestRuns:SetText(hasAny and F.String.GradientClass(L["Latest runs"]) or "")
end

---Refresh the great vault slots
local function UpdateGreatVault(self)
	local holder = self.bottomTextHolderRight
	local vault = holder and holder.vault
	if not vault then
		return
	end

	if UnitLevel("player") < I.MaxLevelTable[MER.MetaFlavor] then
		holder:Hide()
		return
	end
	holder:Show()

	local color = E:ClassColor(E.myclass, true)
	for _, row in ipairs(vault.rows) do
		local activities = C_WeeklyRewards_GetActivities(row.type) or {}
		sort(activities, function(a, b)
			return a.index < b.index
		end)

		local nextActivity
		for slotIndex, slot in ipairs(row.slots) do
			local activity = activities[slotIndex]
			local unlocked = activity and activity.progress >= activity.threshold
			slot.fill:SetVertexColor(color.r, color.g, color.b, 1)
			slot.fill:SetShown(unlocked and true or false)

			if activity and not unlocked and not nextActivity then
				nextActivity = activity
			end
		end

		local last = activities[#activities]
		if nextActivity then
			row.progress:SetText(F.String.MERATHILISUI(format("%d/%d", nextActivity.progress, nextActivity.threshold)))
		elseif last then
			-- Every slot is unlocked
			row.progress:SetText(F.String.Good(format("%d/%d", last.progress, last.threshold)))
		else
			row.progress:SetText("")
		end
	end
end

---Refresh player + optional NPC models
local function UpdateModels(self, db)
	local playerModel = self.playerModel
	if playerModel then
		local playerEmote = Sequences[random(1, #Sequences)]
		playerModel:ClearModel()
		playerModel:SetUnit("player")
		playerModel:SetFacing(6.5)
		playerModel:SetPortraitZoom(0.05)
		playerModel:SetCamDistanceScale(4.8)
		playerModel:SetAnimation(playerEmote)
		playerModel:SetAlpha(0)
		UIFrameFadeIn(playerModel, 1, 0, 1)
	end

	local npcScene = self.npcScene
	if db.showRandomPets and npcScene then
		local actor = npcScene.actor
		-- Hidden until FitNPC has scaled it, the model loads in the background
		actor:SetAlpha(0)
		actor:SetScale(1)
		npcScene.shown = nil
		npcScene.animation = Sequences[random(1, #Sequences)]
		npcScene.displayID = NPC_DISPLAY_IDS[random(1, #NPC_DISPLAY_IDS)]
		actor:SetModelByCreatureDisplayID(npcScene.displayID)
		StartNPCFit(npcScene)

		npcScene:SetAlpha(0)
		UIFrameFadeIn(npcScene, 1, 0, 1)
	end
end

function module:GameMenu_OnShow()
	local db = E.db.mui.gameMenu
	if not db or not db.enable then
		return
	end

	-- Create once
	if not self.mainFrame then
		self:CreateGameMenuUI()
	end

	local mainFrame = self.mainFrame
	local bottomPanel = self.bottomPanel
	local topPanel = self.topPanel

	-- Background color (may change via options)
	local bgColor = db.bgColor
	mainFrame.bg:SetVertexColor(bgColor.r, bgColor.g, bgColor.b, bgColor.a)

	-- Panel animation reset + play
	local panelHeight = E.screenHeight * (1 / 4)
	bottomPanel:Height(0)
	bottomPanel.anim.height:SetChange(panelHeight)
	bottomPanel.anim.height:Play()

	topPanel:Height(0)
	topPanel.anim.height:SetChange(panelHeight)
	topPanel.anim.height:Play()

	-- Dynamic content only
	UpdatePlayerInfo(self)
	UpdateCollections(self)
	UpdateDelves(self)
	UpdateMythic(self, db)
	UpdateGreatVault(self)
	UpdateModels(self, db)

	local clockHolder = self.clockHolder
	clockHolder:SetShown(db.showClock)
	if db.showClock then
		clockHolder.elapsed = 0
		UpdateClock(clockHolder)
	end

	-- Both share the top right corner, the delves keys follow the clock
	local delves = self.topTextHolderRight.delves
	if delves then
		delves:ClearAllPoints()
		if db.showClock then
			delves:Point("TOPRIGHT", clockHolder.reset, "BOTTOMRIGHT", 0, m(-6))
		else
			delves:Point("TOPRIGHT", self.topTextHolderRight, -OUTER_SPACING, OUTER_SPACING)
		end
	end

	for _, frame in ipairs(self.fadeFrames) do
		frame.fadeIn:Stop()
		if db.animations then
			frame:SetAlpha(0)
			frame.fadeIn:Play()
		else
			frame:SetAlpha(1)
		end
	end

	mainFrame:Show()
end

function module:GameMenu_OnHide()
	if not self.mainFrame then
		return
	end

	for _, frame in ipairs(self.fadeFrames) do
		frame.fadeIn:Stop()
	end
	self.mainFrame:Hide()
end

function module:GameMenu()
	local db = E.db.mui.gameMenu

	if not MER:HasRequirements(I.Requirements.GameMenu) or not db or not db.enable then
		return
	end

	-- Pre-build UI so first ESC is cheap
	self:CreateGameMenuUI()

	self:SecureHookScript(GameMenuFrame, "OnShow", "GameMenu_OnShow")
	self:SecureHookScript(GameMenuFrame, "OnHide", "GameMenu_OnHide")
end

module:AddCallback("GameMenu")
