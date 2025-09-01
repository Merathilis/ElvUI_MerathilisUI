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

---@type ObjectiveTrackerModuleTemplate[]
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
	---@type table<string, string>
	local replaceRules = {}
	local numReplaceRules = #GetKeysArray(replaceRules)

	---Shorten the header text based on the rules defined in `replaceRules`
	---@param headerText ObjectiveTrackerModuleHeaderTemplate_Text
	function module:ShortHeader(headerText)
		if numReplaceRules == 0 or not self.db or not self.db.header or not self.db.header.shortHeader then
			return
		end

		local key = F.Strings.Replace(headerText:GetText(), {
			["\239\188\140"] = ", ",
			["\239\188\141"] = ".",
		})

		if replaceRules[key] then
			headerText:SetText(replaceRules[key])
		end
	end
end

---@class RGB
---@field r number
---@field g number
---@field b number

---@class RGBA : RGB
---@field a number

---Override the Blizzard text color used in objective tracker
---@param rgba RGBA The RGBA color table
---@param config {classColor: boolean, customColorNormal: RGB, customColorHighlight: RGB} The configuration table
---@param normal string The key of normal color in OBJECTIVE_TRACKER_COLOR
---@param highlight string The key of highlight color in OBJECTIVE_TRACKER_COLOR
---@return RGBA newRGBA The overridden RGBA color table
local function OverrideColor(rgba, config, normal, highlight)
	local targetColor ---@type RGB?
	if C.IsRGBEqual(_G.OBJECTIVE_TRACKER_COLOR[normal], rgba) then
		targetColor = config.classColor and E.myClassColor or config.customColorNormal
	elseif C.IsRGBEqual(_G.OBJECTIVE_TRACKER_COLOR[highlight], rgba) then
		targetColor = config.classColor and E.myClassColor or config.customColorHighlight
	end

	if targetColor then
		rgba.r, rgba.g, rgba.b = targetColor.r, targetColor.g, targetColor.b
	end

	return rgba
end

function module:TitleText_SetTextColor(text, r, g, b, a)
	if not self.db or not self.db.enable or not self.db.titleColor then
		return self.hooks[text].SetTextColor(text, r, g, b, a)
	end

	local rgba = { r = r, g = g, b = b, a = a }
	rgba = OverrideColor(rgba, self.db.titleColor, "Header", "HeaderHighlight")
	self.hooks[text].SetTextColor(text, rgba.r, rgba.g, rgba.b, rgba.a)
end

function module:InfoText_SetTextColor(text, r, g, b, a)
	if not self.db or not self.db.enable or not self.db.infoColor then
		return self.hooks[text].SetTextColor(text, r, g, b, a)
	end

	local rgba = { r = r, g = g, b = b, a = a }
	rgba = OverrideColor(rgba, self.db.infoColor, "Normal", "NormalHighlight")
	self.hooks[text].SetTextColor(text, rgba.r, rgba.g, rgba.b, rgba.a)
end

function module:CosmeticBar(header)
	local bar = header.MERCosmeticBar
	self.db = E.private.mui.quest.objectiveTracker

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
		bar:SetVertexColor(C.ExtractColorFromTable(E.myClassColor))
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
	bar:Point("LEFT", header.Text, "LEFT", self.db.cosmeticBar.offsetX, self.db.cosmeticBar.offsetY)

	-- Size
	local width = self.db.cosmeticBar.width
	local height = self.db.cosmeticBar.height
	if self.db.cosmeticBar.widthMode == "DYNAMIC" then
		width = width + header.Text:GetStringWidth()
	end
	if self.db.cosmeticBar.heightMode == "DYNAMIC" then
		height = height + header.Text:GetStringHeight()
	end

	bar:Size(max(width, 1), max(height, 1))

	bar:Show()
end

---@param tracker ObjectiveTrackerModuleTemplate
function module:ObjectiveTrackerModule_Update(tracker)
	if not tracker or not tracker.Header or not tracker.Header.Text then
		return
	end

	self:CosmeticBar(tracker.Header)
	local headerText = tracker.Header.Text
	F.SetFontDB(headerText, self.db.header)
	if not headerText.__MERSetFontObject then
		headerText.__MERSetFontObject = headerText.SetFontObject
		headerText:SetFontObject(nil)
		headerText.SetFontObject = E.noop
	end

	self:ShortHeader(headerText)

	local color = self.db.header.classColor and E.myClassColor or self.db.header.color
	headerText:SetTextColor(color.r, color.g, color.b)
end

---@param text ObjectiveTrackerModuleHeaderTemplate_Text
function module:HandleTitleText(text)
	F.SetFontDB(text, self.db.title)

	local height = text:GetStringHeight() + 2
	if height ~= text:GetHeight() then
		text:Height(height)
	end

	if not self:IsHooked(text, "SetTextColor") then
		self:RawHook(text, "SetTextColor", "TitleText_SetTextColor", true)
		self:TitleText_SetTextColor(text, C.ExtractColorFromTable(_G.OBJECTIVE_TRACKER_COLOR["Header"], { a = 1 }))
	end
end

---@param text ObjectiveTrackerContainerHeaderTemplate_Text
function module:HandleMenuText(text)
	if not self.db.menuTitle.enable then
		return
	end

	F.SetFontDB(text, self.db.menuTitle.font)

	if not text.MERHooked then
		text.MERHooked = true
		if self.db.menuTitle.classColor then
			text:SetTextColor(C.ExtractColorFromTable(E.myClassColor))
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

	if not self:IsHooked(line.Text, "SetTextColor") then
		self:RawHook(line.Text, "SetTextColor", "InfoText_SetTextColor", true)
		self:InfoText_SetTextColor(line.Text, C.ExtractColorFromTable(_G.OBJECTIVE_TRACKER_COLOR["Normal"], { a = 1 }))
	end

	self:ColorfulProgression(line.Text)
	line:Height(line.Text:GetHeight())
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
	if not self.db or not self.db.enable then
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
