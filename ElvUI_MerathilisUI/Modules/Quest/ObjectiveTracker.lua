local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_ObjectiveTracker")
local S = MER:GetModule("MER_Skins")
local C = MER.Utilities.Color
local LSM = E.Libs.LSM

local _G = _G
local format = format
local gsub = gsub
local max = max
local pairs = pairs
local strfind = strfind
local strmatch = strmatch
local tonumber = tonumber

local CreateFrame = CreateFrame
local SortQuestWatches = C_QuestLog.SortQuestWatches

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

local function SetHeaderTextColorHook(text)
	if not text.MERHooked then
		text.__MERSetTextColor = text.SetTextColor
		text.SetTextColor = function(self, r, g, b, a)
			local rgbTable = { r = r, g = g, b = b, a = a }

			if C.IsRGBEqual(_G.OBJECTIVE_TRACKER_COLOR["Header"], rgbTable) then
				if module.db and module.db.enable and module.db.titleColor and module.db.titleColor.enable then
					r = module.db.titleColor.classColor and MER.ClassColor.r or module.db.titleColor.customColorNormal.r
					g = module.db.titleColor.classColor and MER.ClassColor.g or module.db.titleColor.customColorNormal.g
					b = module.db.titleColor.classColor and MER.ClassColor.b or module.db.titleColor.customColorNormal.b
				end
			elseif C.IsRGBEqual(_G.OBJECTIVE_TRACKER_COLOR["HeaderHighlight"], rgbTable) then
				if module.db and module.db.enable and module.db.titleColor and module.db.titleColor.enable then
					r = module.db.titleColor.classColor and MER.ClassColor.r
						or module.db.titleColor.customColorHighlight.r
					g = module.db.titleColor.classColor and MER.ClassColor.g
						or module.db.titleColor.customColorHighlight.g
					b = module.db.titleColor.classColor and MER.ClassColor.b
						or module.db.titleColor.customColorHighlight.b
				end
			end
			self:__MERSetTextColor(r, g, b, a)
		end
		text:SetTextColor(C.ExtractColorFromTable(_G.OBJECTIVE_TRACKER_COLOR["Header"], { a = 1 }))
		text.MERHooked = true
	end
end

local function SetInfoTextColorHook(text)
	if not text.MERHooked then
		text.__MERSetTextColor = text.SetTextColor
		text.SetTextColor = function(self, r, g, b, a)
			local rgbTable = { r = r, g = g, b = b, a = a }

			if C.IsRGBEqual(_G.OBJECTIVE_TRACKER_COLOR["Normal"], rgbTable) then
				if module.db and module.db.enable and module.db.infoColor and module.db.infoColor.enable then
					r = module.db.infoColor.classColor and MER.ClassColor.r or module.db.infoColor.customColorNormal.r
					g = module.db.infoColor.classColor and MER.ClassColor.g or module.db.infoColor.customColorNormal.g
					b = module.db.infoColor.classColor and MER.ClassColor.b or module.db.infoColor.customColorNormal.b
				end
			elseif C.IsRGBEqual(_G.OBJECTIVE_TRACKER_COLOR["NormalHighlight"], rgbTable) then
				if module.db and module.db.enable and module.db.infoColor and module.db.infoColor.enable then
					r = module.db.infoColor.classColor and MER.ClassColor.r
						or module.db.infoColor.customColorHighlight.r
					g = module.db.infoColor.classColor and MER.ClassColor.g
						or module.db.infoColor.customColorHighlight.g
					b = module.db.infoColor.classColor and MER.ClassColor.b
						or module.db.infoColor.customColorHighlight.b
				end
			end
			self:__MERSetTextColor(r, g, b, a)
		end
		text:SetTextColor(C.ExtractColorFromTable(_G.OBJECTIVE_TRACKER_COLOR["Normal"], { a = 1 }))
		text.MERHooked = true
	end
end

function module:CosmeticBar(header)
	local bar = header.MERCosmeticBar

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
		bar:SetVertexColor(C.ExtractColorFromTable(MER.ClassColor))
	elseif self.db.cosmeticBar.color.mode == "NORMAL" then
		bar:SetVertexColor(C.ExtractColorFromTable(self.db.cosmeticBar.color.normalColor))
	elseif self.db.cosmeticBar.color.mode == "GRADIENT" then
		bar:SetVertexColor(1, 1, 1)
		bar:SetGradient(
			"HORIZONTAL",
			C.CreateColorFromTable(self.db.cosmeticBar.color.gradientColor1),
			C.CreateColorFromTable(self.db.cosmeticBar.color.gradientColor2)
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
	if tracker and tracker.Header and tracker.Header.Text then
		self:CosmeticBar(tracker.Header)
		F.SetFontDB(tracker.Header.Text, self.db.header)
		if not tracker.Header.Text.__MERUnbind then
			tracker.Header.Text.__MERUnbind = true
			tracker.Header.Text:SetFontObject(nil)
			tracker.Header.Text.SetFontObject = E.noop
		end

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
	SetHeaderTextColorHook(text)
end

function module:HandleMenuText(text)
	if not self.db.menuTitle.enable then
		return
	end

	F.SetFontWithDB(text, self.db.menuTitle.font)

	if not text.MERHooked then
		text.MERHooked = true
		if self.db.menuTitle.classColor then
			text:SetTextColor(C.ExtractColorFromTable(MER.ClassColor))
		else
			text:SetTextColor(C.ExtractColorFromTable(self.db.menuTitle.color))
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

	SetInfoTextColorHook(line.Text)

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
	backdrop:SetPoint("TOPLEFT", _G.ObjectiveTrackerFrame, "TOPLEFT", db.topLeftOffsetX - 20, db.topLeftOffsetY + 10)
	backdrop:SetPoint(
		"BOTTOMRIGHT",
		_G.ObjectiveTrackerFrame,
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
	self.db = E.private.mui.quest.objectiveTracker
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
