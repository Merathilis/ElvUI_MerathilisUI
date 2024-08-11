local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_ObjectiveTracker")
local S = MER:GetModule("MER_Skins")
local LSM = E.LSM or E.Libs.LSM

local _G = _G
local pairs, tonumber = pairs, tonumber
local format = format
local max = max
local strmatch = strmatch

local CreateColor = CreateColor
local GetNumQuestLogEntries = C_QuestLog.GetNumQuestLogEntries
local SortQuestWatches = C_QuestLog.SortQuestWatches
local CreateFrame = CreateFrame

local MAX_QUESTS = 35
local classColor = _G.RAID_CLASS_COLORS[E.myclass]

local trackers = {
	_G.ScenarioObjectiveTracker,
	_G.UIWidgetObjectiveTracker,
	_G.CampaignQuestObjectiveTracker,
	_G.QuestObjectiveTracker,
	_G.AdventureObjectiveTracker,
	_G.AchievementObjectiveTracker,
	_G.MonthlyActivitiesObjectiveTracker,
	_G.ProfessionsRecipeTracker,
	_G.BonusObjectiveTracker,
	_G.WorldQuestObjectiveTracker,
}

do
	local replaceRule = {}

	function module:ShortTitle(title)
		if not title then
			return
		end

		title = F.String.Replace(title, {
			["\239\188\140"] = ", ",
			["\239\188\141"] = ".",
		})

		for longName, shortName in pairs(replaceRule) do
			if longName == title then
				return shortName
			end
		end
		return title
	end
end

local function SetTextColorHook(text)
	if not text.IsHooked then
		local SetTextColorOld = text.SetTextColor
		text.SetTextColor = function(self, r, g, b, a)
			if
				r == _G.OBJECTIVE_TRACKER_COLOR["Header"].r
				and g == _G.OBJECTIVE_TRACKER_COLOR["Header"].g
				and b == _G.OBJECTIVE_TRACKER_COLOR["Header"].b
			then
				if module.db and module.db.enable and module.db.titleColor and module.db.titleColor.enable then
					r = module.db.titleColor.classColor and classColor.r or module.db.titleColor.customColorNormal.r
					g = module.db.titleColor.classColor and classColor.g or module.db.titleColor.customColorNormal.g
					b = module.db.titleColor.classColor and classColor.b or module.db.titleColor.customColorNormal.b
				end
			elseif
				r == _G.OBJECTIVE_TRACKER_COLOR["HeaderHighlight"].r
				and g == _G.OBJECTIVE_TRACKER_COLOR["HeaderHighlight"].g
				and b == _G.OBJECTIVE_TRACKER_COLOR["HeaderHighlight"].b
			then
				if module.db and module.db.enable and module.db.titleColor and module.db.titleColor.enable then
					r = module.db.titleColor.classColor and classColor.r or module.db.titleColor.customColorHighlight.r
					g = module.db.titleColor.classColor and classColor.g or module.db.titleColor.customColorHighlight.g
					b = module.db.titleColor.classColor and classColor.b or module.db.titleColor.customColorHighlight.b
				end
			end
			SetTextColorOld(self, r, g, b, a)
		end
		text:SetTextColor(
			_G.OBJECTIVE_TRACKER_COLOR["Header"].r,
			_G.OBJECTIVE_TRACKER_COLOR["Header"].g,
			_G.OBJECTIVE_TRACKER_COLOR["Header"].b,
			1
		)

		text.IsHooked = true
	end
end

function module:CosmeticBar(header)
	local bar = header.MERCosmeticBar

	if not self.db or not self.db.cosmeticBar then
		return
	end

	if not self.db.cosmeticBar.enable then
		if bar then
			bar:Hide()
			bar.backdrop:Hide()
		end
		return
	end

	if not bar then
		bar = header:CreateTexture()
		local backdrop = CreateFrame("Frame", nil, header)
		backdrop:SetFrameStrata("BACKGROUND")
		backdrop:SetTemplate()
		backdrop:SetOutside(bar, 1, 1)
		backdrop.Center:SetAlpha(0)
		S:CreateShadow(backdrop, 2, nil, nil, nil, true)
		bar.backdrop = backdrop
		header.MERCosmeticBar = bar
	end

	-- Border
	if self.db.cosmeticBar.border == "NONE" then
		bar.backdrop:Hide()
	else
		if self.db.cosmeticBar.border == "SHADOW" then
			bar.backdrop.MERshadow:Show()
		else
			bar.backdrop.MERshadow:Hide()
		end
		bar.backdrop:Show()
	end

	-- Texture
	bar:SetTexture(LSM:Fetch("statusbar", self.db.cosmeticBar.texture) or E.media.normTex)

	-- Color
	if self.db.cosmeticBar.color.mode == "CLASS" then
		bar:SetVertexColor(classColor.r, classColor.g, classColor.b)
	elseif self.db.cosmeticBar.color.mode == "NORMAL" then
		bar:SetVertexColor(
			self.db.cosmeticBar.color.normalColor.r,
			self.db.cosmeticBar.color.normalColor.g,
			self.db.cosmeticBar.color.normalColor.b,
			self.db.cosmeticBar.color.normalColor.a
		)
	elseif self.db.cosmeticBar.color.mode == "GRADIENT" then
		bar:SetVertexColor(1, 1, 1, 1)
		bar:SetGradient(
			"HORIZONTAL",
			CreateColor(
				self.db.cosmeticBar.color.gradientColor1.r,
				self.db.cosmeticBar.color.gradientColor1.g,
				self.db.cosmeticBar.color.gradientColor1.b,
				self.db.cosmeticBar.color.gradientColor1.a
			),
			CreateColor(
				self.db.cosmeticBar.color.gradientColor2.r,
				self.db.cosmeticBar.color.gradientColor2.g,
				self.db.cosmeticBar.color.gradientColor2.b,
				self.db.cosmeticBar.color.gradientColor2.a
			)
		)
	end

	bar.backdrop:SetAlpha(self.db.cosmeticBar.borderAlpha)

	-- Position
	bar:ClearAllPoints()
	bar:SetPoint("LEFT", header.Text, "LEFT", self.db.cosmeticBar.offsetX, self.db.cosmeticBar.offsetY)

	-- Size
	local width = self.db.cosmeticBar.width
	local height = self.db.cosmeticBar.height
	if self.db.cosmeticBar.widthMode == "DYNAMIC" then
		width = width + header.Text:GetStringWidth()
	end
	if self.db.cosmeticBar.heightMode == "DYNAMIC" then
		height = height + header.Text:GetStringHeight()
	end

	bar:SetSize(max(width, 1), max(height, 1))

	bar:Show()
end

function module:ObjectiveTrackerModule_Update(tracker)
	local NumQuests = select(2, GetNumQuestLogEntries())

	if tracker and tracker.Header and tracker.Header.Text then
		if
			(_G.QuestObjectiveTracker and (tracker.Header == _G.QuestObjectiveTracker.Header))
			and NumQuests >= (MAX_QUESTS - 5)
		then
			tracker.Header.Text:SetText(format("|Cffff0000%d/%d|r - %s", NumQuests, MAX_QUESTS, _G.QUESTS_LABEL))
		end
		self:CosmeticBar(tracker.Header)
		F.SetFontDB(tracker.Header.Text, self.db.header)
		tracker.Header.Text:SetFontObject(nil)
		tracker.Header.Text.SetFontObject = E.noop
		tracker.Header.Text:SetShadowOffset(1, -1)
		tracker.Header.Text:SetShadowColor(0, 0, 0)

		local r = self.db.header.classColor and MER.ClassColor.r or self.db.header.color.r
		local g = self.db.header.classColor and MER.ClassColor.g or self.db.header.color.g
		local b = self.db.header.classColor and MER.ClassColor.b or self.db.header.color.b

		tracker.Header.Text:SetTextColor(r, g, b)
		if self.db.header.shortHeader then
			tracker.Header.Text:SetText(self:ShortTitle(tracker.Header.Text:GetText()))
		end
	end
end

function module:HandleTitleText(text)
	F.SetFontDB(text, self.db.title)
	local height = text:GetStringHeight() + 2
	if height ~= text:GetHeight() then
		text:SetHeight(height)
	end
	SetTextColorHook(text)
end

function module:HandleMenuText(text)
	F.SetFontDB(text, self.db.menuTitle.font)

	if not text.IsHooked then
		text.IsHooked = true
		if self.db.menuTitle.classColor then
			text:SetTextColor(F.r, F.g, F.b)
		else
			text:SetTextColor(self.db.menuTitle.color.r, self.db.menuTitle.color.g, self.db.menuTitle.color.b)
		end
		text.SetTextColor = E.noop
	end
end

function module:HandleObjectiveLine(line)
	if not line or not line.Text or not self.db then
		return
	end

	if line.objectiveKey == 0 then -- World Quest Title
		self:HandleTitleText(line.Text)
		return
	end

	F.SetFontDB(line.Text, self.db.info)

	if self.db.noDash then
		if line.Dash then
			line.Dash:Hide()
			line.Dash:SetText(nil)
		end
	end

	if line.Text.GetText then
		local rawText = line.Text:GetText()
		if self.db.noDash then
			-- Sometimes Blizzard not use dash icon, just put a dash in front of text
			-- We need to force update the text first
			if rawText and rawText ~= "" and strfind(rawText, "^%- ") then
				rawText = gsub(rawText, "^%- ", "")
			end
		end

		line.Text:SetText(rawText)
	end

	self:ColorfulProgression(line.Text)
	line:SetHeight(line.Text:GetHeight())
end

function module:ObjectiveTrackerBlock_AddObjective(block)
	self:HandleObjectiveLine(block.lastRegion)
end

function module:ScenarioObjectiveTracker_UpdateCriteria(tracker, numCriteria)
	if not self.db or not self.db.noDash then
		return
	end

	local objectivesBlock = tracker.ObjectivesBlock
	for criteriaIndex = 1, numCriteria do
		local existingLine = objectivesBlock:GetExistingLine(criteriaIndex)
		existingLine.Icon:Hide()
	end
end

function module:ColorfulProgression(text)
	if not self.db or not text then
		return
	end

	local info = text:GetText()
	if not info then
		return
	end

	local current, required, details = strmatch(info, "^(%d-)/(%d-) (.+)")

	if not (current and required and details) then
		details, current, required = strmatch(info, "(.+): (%d-)/(%d-)$")
	end

	if not (current and required and details) then
		return
	end

	local progress = tonumber(current) / tonumber(required)

	if self.db.colorfulProgress then
		info = F.CreateColorString(current .. "/" .. required, F.GetProgressColor(progress))
		info = info .. " " .. details
	end

	if self.db.percentage then
		local percentage = format("[%.f%%]", progress * 100)
		if self.db.colorfulPercentage then
			percentage = F.CreateColorString(percentage, F.GetProgressColor(progress))
		end
		info = info .. " " .. percentage
	end

	text:SetText(info)
end

function module:UpdateBackdrop()
	if not _G.ObjectiveTrackerFrame then
		return
	end

	local db = self.db.backdrop
	local backdrop = _G.ObjectiveTrackerFrame.backdrop

	if not db.enable then
		if backdrop then
			backdrop:Hide()
		end

		return
	end

	if not backdrop then
		if self.db.backdrop.enable then
			_G.ObjectiveTrackerFrame:CreateBackdrop()
			backdrop = _G.ObjectiveTrackerFrame.backdrop
			S:CreateShadow(backdrop)
		end
	end

	backdrop:Show()
	backdrop:SetTemplate(db.transparent and "Transparent")
	backdrop:ClearAllPoints()
	backdrop:SetPoint(
		"TOPLEFT",
		_G.ObjectiveTrackerFrame.NineSlice,
		"TOPLEFT",
		db.topLeftOffsetX - 20,
		db.topLeftOffsetY + 10
	)
	backdrop:SetPoint(
		"BOTTOMRIGHT",
		_G.ObjectiveTrackerFrame.NineSlice,
		"BOTTOMRIGHT",
		db.bottomRightOffsetX + 10,
		db.bottomRightOffsetY - 10
	)
end

function module:ReskinTextInsideBlock(_, block)
	if not self.db then
		return
	end

	if block.HeaderText then
		self:HandleTitleText(block.HeaderText)
	end

	for _, line in pairs(block.usedLines or {}) do
		self:HandleObjectiveLine(line)
	end
end

function module:RefreshAllCosmeticBars()
	for _, tracker in pairs(trackers) do
		if tracker.Header then
			self:CosmeticBar(tracker.Header)
		end
	end
	SortQuestWatches()
end

function module:ObjectiveTrackerModule_AddBlock(_, block)
	if block.__MERHooked then
		return
	end

	self:ReskinTextInsideBlock(nil, block)
	if block.AddObjective then
		self:SecureHook(block, "AddObjective", "ObjectiveTrackerBlock_AddObjective")
	end

	block.__MERHooked = true
end

function module:Initialize()
	self.db = E.db.mui.blizzard.objectiveTracker
	if not self.db.enable then
		return
	end

	self:UpdateBackdrop()

	if not self.initialized then
		for _, tracker in pairs(trackers) do
			for _, block in pairs(tracker.usedBlocks or {}) do
				self:ObjectiveTrackerModule_AddBlock(nil, block)
			end
			self:SecureHook(tracker, "Update", "ObjectiveTrackerModule_Update")
			self:SecureHook(tracker, "AddBlock", "ObjectiveTrackerModule_AddBlock")
		end

		self:SecureHook(_G.ScenarioObjectiveTracker, "UpdateCriteria", "ScenarioObjectiveTracker_UpdateCriteria")
		self:HandleMenuText(_G.ObjectiveTrackerFrame.Header.Text)

		self.initialized = true
	end

	-- Force update all modules once we get into the game
	E:Delay(0.5, function()
		SortQuestWatches()
	end)
end

MER:RegisterModule(module:GetName())
