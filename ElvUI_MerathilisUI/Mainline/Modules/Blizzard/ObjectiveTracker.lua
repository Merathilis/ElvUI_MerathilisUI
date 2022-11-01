local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_ObjectiveTracker')
local S = MER:GetModule('MER_Skins')
local LSM = E.LSM or E.Libs.LSM

local _G = _G
local pairs, tonumber = pairs, tonumber
local format = format
local max = max
local strmatch = strmatch

local CreateColor = CreateColor
local C_QuestLog_GetTitleForQuestID = C_QuestLog.GetTitleForQuestID
local CreateFrame = CreateFrame
local ObjectiveTracker_Update = ObjectiveTracker_Update

local replaceRule = {}

local function AddQuestTitleToReplaceRule(questID, text)
	F.SetCallback(function(title)
		if title then
			replaceRule[title] = text
			ObjectiveTracker_Update()
			return true
		end
		return false
	end,
	C_QuestLog_GetTitleForQuestID, nil,	questID)
end

AddQuestTitleToReplaceRule(57693, L["Torghast"])

local classColor = _G.RAID_CLASS_COLORS[E.myclass]

local function SetTextColorHook(text)
	if not text.IsHooked then
		local SetTextColorOld = text.SetTextColor
		text.SetTextColor = function(self, r, g, b, a)
			if
				r == _G.OBJECTIVE_TRACKER_COLOR["Header"].r and g == _G.OBJECTIVE_TRACKER_COLOR["Header"].g and
					b == _G.OBJECTIVE_TRACKER_COLOR["Header"].b
			 then
				if module.db and module.db.enable and module.db.titleColor and module.db.titleColor.enable then
					r = module.db.titleColor.classColor and classColor.r or module.db.titleColor.customColorNormal.r
					g = module.db.titleColor.classColor and classColor.g or module.db.titleColor.customColorNormal.g
					b = module.db.titleColor.classColor and classColor.b or module.db.titleColor.customColorNormal.b
				end
			elseif
				r == _G.OBJECTIVE_TRACKER_COLOR["HeaderHighlight"].r and
					g == _G.OBJECTIVE_TRACKER_COLOR["HeaderHighlight"].g and
					b == _G.OBJECTIVE_TRACKER_COLOR["HeaderHighlight"].b
			 then
				if module.db and module.db.enable and module.db.titleColor and module.db.titleColor.enable then
					r = module.db.titleColor.classColor and classColor.r or module.db.titleColor.customColorHighlight.r
					g = module.db.titleColor.classColor and classColor.g or module.db.titleColor.customColorHighlight.g
					b = module.db.titleColor.classColor and classColor.b or module.db.titleColor.customColorHighlight.b
				end
			end
			SetTextColorOld(self, r, g, b, a)
		end
		text:SetTextColor(_G.OBJECTIVE_TRACKER_COLOR["Header"].r, _G.OBJECTIVE_TRACKER_COLOR["Header"].g, _G.OBJECTIVE_TRACKER_COLOR["Header"].b, 1)

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
			bar.backdrop.shadow:Show()
		else
			bar.backdrop.shadow:Hide()
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
		if MER.IsNewPatch then
			bar:SetGradient(
				"HORIZONTAL", CreateColor(
				self.db.cosmeticBar.color.gradientColor1.r,
				self.db.cosmeticBar.color.gradientColor1.g,
				self.db.cosmeticBar.color.gradientColor1.b,
				self.db.cosmeticBar.color.gradientColor1.a),
				CreateColor(
				self.db.cosmeticBar.color.gradientColor2.r,
				self.db.cosmeticBar.color.gradientColor2.g,
				self.db.cosmeticBar.color.gradientColor2.b,
				self.db.cosmeticBar.color.gradientColor2.a)
			)
		else
			bar:SetGradientAlpha(
				"HORIZONTAL",
					self.db.cosmeticBar.color.gradientColor1.r,
					self.db.cosmeticBar.color.gradientColor1.g,
					self.db.cosmeticBar.color.gradientColor1.b,
					self.db.cosmeticBar.color.gradientColor1.a,
					self.db.cosmeticBar.color.gradientColor2.r,
					self.db.cosmeticBar.color.gradientColor2.g,
					self.db.cosmeticBar.color.gradientColor2.b,
					self.db.cosmeticBar.color.gradientColor2.a
			)
		end
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

function module:ChangeQuestHeaderStyle()
	local frame = _G.ObjectiveTrackerFrame.MODULES
	if not self.db or not self.db.header or not frame then
		return
	end

	for i = 1, #frame do
		local modules = frame[i]
		if modules and modules.Header and modules.Header.Text then
			self:CosmeticBar(modules.Header)
			F.SetFontDB(modules.Header.Text, self.db.header)
			modules.Header.Text:SetShadowColor(0, 0, 0, 0)
			modules.Header.Text.SetShadowColor = E.noop

			local r = self.db.header.classColor and F.r or self.db.header.color.r
			local g = self.db.header.classColor and F.g or self.db.header.color.g
			local b = self.db.header.classColor and F.b or self.db.header.color.b

			modules.Header.Text:SetTextColor(r, g, b)
			if self.db.header.shortHeader then
				modules.Header.Text:SetText(self:ShortTitle(modules.Header.Text:GetText()))
			end
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
	local height = text:GetStringHeight() + 2
	if height ~= text:GetHeight() then
		text:SetHeight(height)
	end

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

function module:HandleInfoText(text)
	self:ColorfulProgression(text)
	F.SetFontDB(text, self.db.info)
	text:SetHeight(text:GetStringHeight())

	local line = text:GetParent()
	local dash = line.Dash or line.Icon

	if self.db.noDash and dash then
		dash:Hide()
		text:ClearAllPoints()
		text:Point("TOPLEFT", dash, "TOPLEFT", 0, 0)
	else
		if dash.SetText then
			F.SetFontDB(dash, self.db.info)
		end
		if line.Check and line.Check:IsShown() or line.state and line.state == "COMPLETED" or line.dashStyle == 2 then
			dash:Hide()
		else
			dash:Show()
		end
		text:ClearAllPoints()
		text:Point("TOPLEFT", dash, "TOPRIGHT", -1, 0)
	end
end

function module:ChangeQuestFontStyle(_, block)
	if not self.db or not block then
		return
	end

	if block.HeaderText then
		self:HandleTitleText(block.HeaderText)
	end

	if block.currentLine then
		if block.currentLine.objectiveKey == 0 then
			self:HandleTitleText(block.currentLine.Text)
		else
			self:HandleInfoText(block.currentLine.Text)
		end
	end
end

function module:ScenarioObjectiveBlock_UpdateCriteria()
	if _G.ScenarioObjectiveBlock then
		local childs = {_G.ScenarioObjectiveBlock:GetChildren()}
		for _, child in pairs(childs) do
			if child.Text then
				self:HandleInfoText(child.Text)
			end
		end
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

function module:UpdateTextWidth()
	if self.db.noDash then
		_G.OBJECTIVE_DASH_STYLE_SHOW = 2
	else
		_G.OBJECTIVE_DASH_STYLE_SHOW = 1
	end
end

function module:ShortTitle(str)
	for longName, shortName in pairs(replaceRule) do
		if longName == str then
			return shortName
		end
	end
	return str
end

function module:UpdateBackdrop()
	if not _G.ObjectiveTrackerBlocksFrame then
		return
	end

	local db = self.db.backdrop
	local backdrop = _G.ObjectiveTrackerBlocksFrame.backdrop

	if not db.enable then
		if backdrop then
			backdrop:Hide()
		end

		return
	end

	if not backdrop then
		if self.db.backdrop.enable then
			_G.ObjectiveTrackerBlocksFrame:CreateBackdrop()
			backdrop = _G.ObjectiveTrackerBlocksFrame.backdrop
			S:CreateShadow(backdrop)
			backdrop:Styling()
		end
	end

	backdrop:Show()
	backdrop:SetTemplate(db.transparent and "Transparent")
	backdrop:ClearAllPoints()
	backdrop:SetPoint("TOPLEFT", _G.ObjectiveTrackerBlocksFrame, "TOPLEFT", db.topLeftOffsetX - 30, db.topLeftOffsetY + 10)
	backdrop:SetPoint("BOTTOMRIGHT", _G.ObjectiveTrackerBlocksFrame, "BOTTOMRIGHT", db.bottomRightOffsetX + 10, db.bottomRightOffsetY - 10)
end

function module:Initialize()
	self.db = E.db.mui.blizzard.objectiveTracker
	if not self.db.enable then
		return
	end

	self:UpdateTextWidth()
	self:UpdateBackdrop()

	if not self.initialized then
		local trackerModules = {
			_G.UI_WIDGET_TRACKER_MODULE,
			_G.BONUS_OBJECTIVE_TRACKER_MODULE,
			_G.WORLD_QUEST_TRACKER_MODULE,
			_G.CAMPAIGN_QUEST_TRACKER_MODULE,
			_G.QUEST_TRACKER_MODULE,
			_G.ACHIEVEMENT_TRACKER_MODULE
		}

		for _, module in pairs(trackerModules) do
			self:SecureHook(module, "AddObjective", "ChangeQuestFontStyle")
		end

		self:SecureHook("ObjectiveTracker_Update", "ChangeQuestHeaderStyle")
		self:SecureHook(_G.SCENARIO_CONTENT_TRACKER_MODULE, "UpdateCriteria", "ScenarioObjectiveBlock_UpdateCriteria")

		self.initialized = true
	end

	E:Delay(1,function()
		for _, child in pairs {_G.ObjectiveTrackerBlocksFrame:GetChildren()} do
			if child and child.HeaderText then
				SetTextColorHook(child.HeaderText)
			end
		end
	end)

	if _G.ObjectiveTrackerFrame.HeaderMenu then
		self:HandleMenuText(_G.ObjectiveTrackerFrame.HeaderMenu.Title)
	end

	ObjectiveTracker_Update()
end


MER:RegisterModule(module:GetName())
