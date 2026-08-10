local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_NameHover")

local pcall, type = pcall, type
local find = string.find
local max = math.max
local issecretvalue = issecretvalue

local CreateFrame = CreateFrame
local GetCursorPosition = GetCursorPosition
local hooksecurefunc = hooksecurefunc
local IsShiftKeyDown = IsShiftKeyDown
local IsControlKeyDown = IsControlKeyDown
local IsAltKeyDown = IsAltKeyDown
local IsInInstance = IsInInstance
local UnitName = UnitName
local UnitIsUnit = UnitIsUnit
local UnitExists = UnitExists
local UnitGUID = UnitGUID

local C_Timer_After = C_Timer.After
local GameTooltip = GameTooltip
local UIParent = UIParent
local WorldFrame = WorldFrame

local LOP
if type(LibStub) == "table" and type(LibStub.GetLibrary) == "function" then
	LOP = LibStub:GetLibrary("LibObjectiveProgress-1.0", true)
end
module.LOP = LOP

module.COLOR_ALLIANCE = { r = 0 / 255, g = 112 / 255, b = 221 / 255 }
module.COLOR_COMPLETE = { r = 136 / 255, g = 136 / 255, b = 136 / 255 }
module.COLOR_DEFAULT = { r = 1, g = 1, b = 1 }
module.COLOR_DEAD = { r = 136 / 255, g = 136 / 255, b = 136 / 255 }
module.COLOR_HOSTILE = { r = 1, g = 68 / 255, b = 68 / 255 }
module.COLOR_NEUTRAL = { r = 1, g = 1, b = 68 / 255 }
module.COLOR_HOSTILE_UNATTACKABLE = { r = 210 / 255, g = 76 / 255, b = 56 / 255 }
module.COLOR_RARE = { r = 226 / 255, g = 228 / 255, b = 226 / 255 }
module.COLOR_GUILD = { r = 24 / 255, g = 222 / 255, b = 0 }
module.COLOR_HORDE = { r = 1, g = 0, b = 0 }
module.COLOR_ELITE = { r = 213 / 255, g = 154 / 255, b = 18 / 255 }
module.ICON_CHECKMARK = "|TInterface\\RaidFrame\\ReadyCheck-Ready:11|t"
module.ICON_LIST = "- "
module.inspectBindingHeld = false
module.suppressTooltipFade = false
module.inspectMode = false

-- Cached instance state (refreshed on zone events)
module._disabledInInstance = false

local Layout = {
	LINE_STEP = 13, -- Vertical spacing between stacked top labels (guild/header/status).
	LINE_OFFSET = 2, -- Small extra offset added after each top label anchor step.
	MAIN_MIN_HEIGHT = 14, -- Fallback minimum height reserved for mainText line.
	SUB_BOTTOM_OFFSET = 1, -- Bottom offset used for subText anchoring and height math.
	SUB_LINE_STEP = 12, -- Per-line vertical step used by the subText block.
	SUB_LEFT_INSET = 12, -- Horizontal inset of subText relative to mainText.
	FRAME_MIN_WIDTH = 1, -- Keep >0 to avoid invalid size, but do not add visual padding.
	FRAME_MIN_HEIGHT = 1, -- Keep >0 to avoid invalid size, but do not add visual padding.
	CURSOR_OFFSET_VERTICAL_DEFAULT = 4, -- Fallback vertical offset from cursor when setting is unavailable.
	CURSOR_OFFSET_HORIZONTAL_DEFAULT = 0, -- Fallback horizontal offset from cursor when setting is unavailable.
	FORCES_GAP_RIGHT = 6, -- Horizontal gap between the name and the Enemy Forces text (right mode).
	FORCES_GAP_UNDER = 2, -- Vertical gap below the subtext block before the Enemy Forces line (under mode).
}

_G.BINDING_NAME_MER_NAMEHOVER_INSPECT = _G.BINDING_NAME_MER_NAMEHOVER_INSPECT or "Name Hover: Hold to Show BlizzToolTip"

local INSTANCE_TYPES = {
	party = true,
	raid = true,
	scenario = true,
}

local CONTENT_INTERVAL = 0.05
local BLIZZ_ALPHA_INTERVAL = 0.1

local function GetBackgroundPadding()
	local value = tonumber(MER.db.profile.nameHover.display_BackgroundPadding)
	if value then
		return max(0, value)
	end
	return 0
end

-- =========================
-- INSPECT KEY SYSTEM
-- =========================
local function IsInspectKeyDown()
	local key = module.db and module.db.inspectKey or "NONE"
	if key == "SHIFT" then
		return IsShiftKeyDown()
	elseif key == "CTRL" then
		return IsControlKeyDown()
	elseif key == "ALT" then
		return IsAltKeyDown()
	end
	return false
end

local function IsInspectOverrideActive()
	return module.inspectBindingHeld or IsInspectKeyDown()
end

function module:RefreshInstanceState()
	local db = self.db
	if not db or not db.disableInDungeons then
		self._disabledInInstance = false
		return
	end

	local inInstance, instanceType = IsInInstance()
	self._disabledInInstance = inInstance and INSTANCE_TYPES[instanceType] or false
end

function module:IsDisabledInCurrentInstance()
	return self._disabledInInstance
end

local function IsAllowedMouseFocus()
	local focus = module:GetTopMouseFocus()
	if not focus then
		return true
	end

	local current = focus
	for _ = 1, 6 do
		if not current then
			break
		end

		if current == WorldFrame then
			return true
		end

		local name = current.GetName and current:GetName()
		if name == "WorldFrame" then
			return true
		end

		local unit = current.unit
		if not unit and type(current.GetAttribute) == "function" then
			unit = current:GetAttribute("unit")
		end

		if unit and UnitExists(unit) and UnitIsUnit(unit, "mouseover") then
			return true
		end

		if type(name) == "string" and (find(name, "NamePlate", 1, true) or find(name, "Plater", 1, true)) then
			return true
		end

		current = current.GetParent and current:GetParent() or nil
	end

	return false
end

local function GetTooltipUnit(self)
	if not self or type(self.GetUnit) ~= "function" then
		return nil
	end

	local ok, _, unit = pcall(self.GetUnit, self)
	if not ok then
		return nil
	end

	if unit and UnitExists(unit) then
		return unit
	end

	if self == GameTooltip and UnitExists("mouseover") then
		return "mouseover"
	end

	return nil
end

local function HasVisibleMouseoverUnit()
	return UnitExists("mouseover") and IsAllowedMouseFocus()
end

local function ShouldForceHideBlizzTooltip()
	local db = module.db
	if not db then
		return false
	end

	if module._disabledInInstance or db.blizztooltip or IsInspectOverrideActive() then
		return false
	end

	return not UnitExists("mouseover")
end

local function ClearTooltipFadeSuppression()
	module.suppressTooltipFade = false
end

local function UpdateBlizzTooltipAlpha()
	local db = module.db
	if not GameTooltip or not GameTooltip.SetAlpha or not db then
		return
	end

	if module._disabledInInstance or IsInspectOverrideActive() or db.blizztooltip then
		ClearTooltipFadeSuppression()
		module.inspectMode = (not module._disabledInInstance) and IsInspectOverrideActive()
		GameTooltip:SetAlpha(1)
		return
	end

	module.inspectMode = false

	if HasVisibleMouseoverUnit() then
		module.suppressTooltipFade = true
		GameTooltip:SetAlpha(0)
		return
	end

	if module.suppressTooltipFade and GameTooltip:IsShown() then
		GameTooltip:SetAlpha(0)
		return
	end

	GameTooltip:SetAlpha(1)
end

local function HideBlizzTooltipIfStale()
	if not GameTooltip or not GameTooltip:IsShown() then
		return
	end

	if not ShouldForceHideBlizzTooltip() then
		return
	end

	local unit = GetTooltipUnit(GameTooltip)
	if unit or module.suppressTooltipFade then
		ClearTooltipFadeSuppression()
		GameTooltip:Hide()
	end
end

local function ApplyBlizzState()
	if not module.db then
		return
	end
	UpdateBlizzTooltipAlpha()
end

function module:SetInspectBindingState(isDown)
	self.inspectBindingHeld = isDown == true
	UpdateBlizzTooltipAlpha()
	self:UpdateInstanceState()
end

function MER_NameHover_SetInspectBindingState(isDown)
	module:SetInspectBindingState(isDown)
end

local function ApplyNameHoverAlpha(frame)
	if not frame then
		return
	end

	if module._disabledInInstance then
		frame:Hide()
		return
	end

	local desired = module.inspectMode and 0 or 1
	if frame:GetAlpha() ~= desired then
		frame:SetAlpha(desired)
	end
end

local function SetAnchor(element, anchor, position, top)
	local margin = 13 + (top or 0)
	element:SetPoint(position, anchor, position, 0, margin)
	return margin + 2
end

local function UpdateFrameContents(f)
	if module._disabledInInstance or not IsAllowedMouseFocus() then
		f:Hide()
		return
	end

	local unitName = UnitName("mouseover")
	if unitName == nil then
		f:Hide()
		return
	end

	local unitText = module:GetTextWithColor(unitName, module:GetUnitNameColor("mouseover"))
	local level = module:GetLevelText()
	local targetName = module:GetTargetText()
	local status = module:GetStatusText()
	local classification = module:GetClassificationText()
	local guild = module:GetGuildText()
	local faction = module:GetFactionText()
	local race = module:GetRaceText()
	local creatureType = module:GetCreatureType()
	local tooltips = module:GetTooltipData()

	local mainText = module:CombineText(level, unitText, targetName)
	local headerText = module:CombineText(faction, classification, creatureType, race)

	f.lastUnitGUID = UnitGUID("mouseover")

	f.mainText:SetText(mainText)
	f.statusText:SetText(status)
	f.headerText:SetText(headerText)
	f.guildText:SetText(guild)

	local subTexts = module:CombineTables(module:GetQuestText("mouseover", tooltips))
	local subCount = (subTexts and #subTexts) or 0

	if subCount > 0 then
		local joined = subTexts[1]
		for i = 2, subCount do
			joined = joined .. "\n" .. subTexts[i]
		end
		f.subText:SetText(joined)
	else
		f.subText:SetText("")
	end

	local forcesArr = module:GetForcesText("mouseover")
	local hasForces = forcesArr ~= nil
	local forcesRight = false
	if hasForces then
		forcesRight = E.db.mui.nameHover.mythicPlus_DisplayRight and true or false
	end

	local function Measure(fs)
		local w, h = 0, 0
		local okW, rw = pcall(fs.GetStringWidth, fs)
		local okH, rh = pcall(fs.GetStringHeight, fs)
		if okW and type(rw) == "number" and not issecretvalue(rw) then
			w = rw
		end
		if okH and type(rh) == "number" and not issecretvalue(rh) then
			h = rh
		end
		return w, h
	end

	local mainW, mainH = Measure(f.mainText)
	local guildW = Measure(f.guildText)
	local headerW = Measure(f.headerText)
	local statusW = Measure(f.statusText)
	local subW, subH = Measure(f.subText)
	local fontSize = tonumber(E.db.mui.nameHover.displayFontSize) or Layout.MAIN_MIN_HEIGHT
	local mpFontSize = tonumber(E.db.mui.nameHover.mythicPlus_FontSize) or fontSize

	local forcesW, forcesH = 0, 0
	if hasForces then
		f.forcesText:SetText(module:GetReserveText())
		forcesW = Measure(f.forcesText)
		f.forcesText:SetText(forcesArr[1])
		forcesH = mpFontSize
	else
		f.forcesText:SetText("")
	end

	mainW = max(mainW, 1)
	mainH = max(mainH, fontSize)

	local topLines = 0
	if module:IsNotEmpty(guild) then
		topLines = topLines + 1
	end
	if module:IsNotEmpty(headerText) then
		topLines = topLines + 1
	end
	if module:IsNotEmpty(status) then
		topLines = topLines + 1
	end

	local padding = GetBackgroundPadding()
	local topExtra = (topLines * Layout.LINE_STEP) + padding

	local dropY = 0
	local forcesUnderY, questY
	local forcesUnder = hasForces and not forcesRight

	if forcesUnder then
		dropY = dropY + Layout.FORCES_GAP_UNDER
		forcesUnderY = -dropY
		dropY = dropY + forcesH
	end

	if subCount > 0 then
		dropY = dropY + Layout.SUB_BOTTOM_OFFSET
		questY = -dropY
		dropY = dropY + ((subH > 0) and subH or (Layout.SUB_LINE_STEP * subCount))
	end

	local belowMain = dropY
	if belowMain > 0 then
		belowMain = belowMain + Layout.SUB_BOTTOM_OFFSET
	end

	local rightExtra = 0
	if hasForces and forcesRight then
		rightExtra = Layout.FORCES_GAP_RIGHT + forcesW
		mainH = max(mainH, forcesH)
	end
	local forcesUnderWidth = forcesUnder and (forcesW + Layout.SUB_LEFT_INSET) or 0

	local width = max(mainW + rightExtra, guildW, headerW, statusW, subW + Layout.SUB_LEFT_INSET, forcesUnderWidth)
	width = max(Layout.FRAME_MIN_WIDTH, width + (padding * 2))

	local height = topExtra + mainH + belowMain + padding
	height = max(Layout.FRAME_MIN_HEIGHT, height)

	f:SetSize(width, height)
	f.mainText:ClearAllPoints()
	f.mainText:SetPoint("TOP", f, "TOP", 0, subCount > 0 and (12 * subCount) or 0)

	local top = 0
	if module:IsNotEmpty(guild) then
		top = SetAnchor(f.guildText, f.mainText, "TOPLEFT", top)
	end
	if module:IsNotEmpty(header) then
		top = SetAnchor(f.headerText, f.mainText, "TOPLEFT", top)
	end
	if module:IsNotEmpty(status) then
		top = SetAnchor(f.statusText, f.mainText, "TOPLEFT", top)
	end
	f.subText:ClearAllPoints()
	if subCount > 0 then
		f.subText:SetPoint("TOPLEFT", f.mainText, "BOTTOMLEFT", Layout.SUB_LEFT_INSET, questY)
	end

	f.forcesText:ClearAllPoints()
	if hasForces then
		if forcesRight then
			f.forcesText:SetPoint("LEFT", f.mainText, "RIGHT", Layout.FORCES_GAP_RIGHT, 0)
		else
			f.forcesText:SetPoint("TOPLEFT", f.mainText, "BOTTOMLEFT", Layout.SUB_LEFT_INSET, forcesUnderY)
		end
	end

	f:Show()
	ApplyNameHoverAlpha(f)
end

local function UpdateFramePosition(f)
	if module._disabledInInstance or not UnitExists("mouseover") then
		f:Hide()
		return
	end

	local x, y = GetCursorPosition()
	local scale = UIParent:GetEffectiveScale()

	f:ClearAllPoints()
	f:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x / scale, y / scale + 15)

	if GameTooltip and GameTooltip:IsShown() then
		f:SetFrameStrata("TOOLTIP")
		f:SetFrameLevel(GameTooltip:GetFrameLevel() + 10)
	end

	ApplyNameHoverAlpha(f)
end

function module:UpdateInstanceState()
	self:RefreshInstanceState()

	if not self.frame then
		return
	end

	if self._disabledInInstance then
		self.inspectMode = false
		self.frame:Hide()
	elseif UnitExists("mouseover") then
		UpdateFrameContents(self.frame)
		UpdateFramePosition(self.frame)
	else
		self.frame:Hide()
	end

	if GameTooltip and GameTooltip:IsShown() then
		ApplyBlizzState()
	end
end

function module:Initialize()
	local db = E.db.mui.nameHover
	module.db = db

	if not db.enable or module.Initialized then
		return
	end

	self:RefreshInstanceState()

	local frame = CreateFrame("Frame", "MER_NameHoverFrame", E.UIParent)
	frame:SetFrameStrata("TOOLTIP")
	module.frame = frame

	local function fontOpts(sizeKey, outlineKey, defaultSize)
		return nil, db[sizeKey] or defaultSize, db[outlineKey] and "SHADOWOUTLINE" or "NONE"
	end

	frame.mainText = frame:CreateFontString(nil, "OVERLAY")
	frame.mainText:FontTemplate(fontOpts("mainTextSize", "mainTextOutline", 14))

	frame.statusText = frame:CreateFontString(nil, "OVERLAY")
	frame.statusText:FontTemplate(fontOpts("statusTextSize", "statusTextOutline", 11))

	frame.headerText = frame:CreateFontString(nil, "OVERLAY")
	frame.headerText:FontTemplate(fontOpts("headerTextSize", "headerTextOutline", 11))

	frame.guildText = frame:CreateFontString(nil, "OVERLAY")
	frame.guildText:FontTemplate(fontOpts("guildTextSize", "guildTextOutline", 11))

	frame.subText = frame:CreateFontString(nil, "OVERLAY", "GameTooltipText")
	frame.subText:FontTemplate(fontOpts("subTextSize", "subTextOutline", 11))

	frame.forcesText = frame:CreateFontString(nil, "OVERLAY", "GameTooltipText")
	frame.forcesText:FontTemplate(fontOpts("mythicPlusFontSize", "mythicPlusFontOutline", 11))

	frame.refreshElapsed = 0
	frame.blizzElapsed = 0

	frame:SetScript("OnUpdate", function(self, elapsed)
		-- Visibility every frame: hide when mouseover ends (critical)
		if module._disabledInInstance or not UnitExists("mouseover") then
			if self:IsShown() then
				self:Hide()
				self.lastUnitGUID = nil
			end
		else
			-- Cursor follow while hovering a unit
			UpdateFramePosition(self)
		end

		-- Blizz tooltip alpha throttled
		self.blizzElapsed = self.blizzElapsed + (elapsed or 0)
		if self.blizzElapsed >= BLIZZ_ALPHA_INTERVAL then
			self.blizzElapsed = 0
			UpdateBlizzTooltipAlpha()
			HideBlizzTooltipIfStale()
		end

		-- Content refresh only while mouseover is valid
		if module._disabledInInstance or self.updateQueued or not UnitExists("mouseover") then
			return
		end

		self.refreshElapsed = self.refreshElapsed + (elapsed or 0)
		if self.refreshElapsed < CONTENT_INTERVAL then
			return
		end
		self.refreshElapsed = 0

		local unitGUID = UnitGUID("mouseover")
		if E:NotSecretValue(unitGUID) and unitGUID then
			if not self:IsShown() or self.lastUnitGUID ~= unitGUID then
				UpdateFrameContents(self)
				if self:IsShown() then
					UpdateFramePosition(self)
				end
			end
		end
	end)

	frame:SetScript("OnEvent", function(self, event)
		if event == "MODIFIER_STATE_CHANGED" then
			UpdateBlizzTooltipAlpha()
			if module._disabledInInstance then
				self:Hide()
			elseif UnitExists("mouseover") then
				UpdateFrameContents(self)
				if self:IsShown() then
					UpdateFramePosition(self)
				end
			end
			return
		end

		if event == "QUEST_LOG_UPDATE" or event == "UNIT_QUEST_LOG_CHANGED" then
			if module.InvalidateQuestCache then
				module.InvalidateQuestCache()
			end
			return
		end

		if event == "PLAYER_ENTERING_WORLD" or event == "ZONE_CHANGED_NEW_AREA" then
			module:UpdateInstanceState()
			if module.InvalidateQuestCache then
				module.InvalidateQuestCache()
			end
			return
		end

		if event ~= "UPDATE_MOUSEOVER_UNIT" then
			module:UpdateInstanceState()
			return
		end

		UpdateBlizzTooltipAlpha()

		if self.updateQueued then
			return
		end
		self.updateQueued = true

		C_Timer_After(0.01, function()
			self.updateQueued = false

			if module._disabledInInstance or not UnitExists("mouseover") then
				UpdateBlizzTooltipAlpha()
				HideBlizzTooltipIfStale()
				self:Hide()
				return
			end

			UpdateBlizzTooltipAlpha()
			UpdateFrameContents(self)
			if self:IsShown() then
				UpdateFramePosition(self)
			end
		end)
	end)

	frame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	frame:RegisterEvent("MODIFIER_STATE_CHANGED")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	frame:RegisterEvent("QUEST_LOG_UPDATE")
	frame:RegisterEvent("UNIT_QUEST_LOG_CHANGED")

	-- Blizz tooltip hooks (no OnUpdate — handled by frame throttle)
	if not module.TooltipHooked then
		local function Apply()
			ApplyBlizzState()
		end

		local function ApplyHyperlink()
			ClearTooltipFadeSuppression()
			ApplyBlizzState()
		end

		hooksecurefunc(GameTooltip, "SetUnit", Apply)
		hooksecurefunc(GameTooltip, "SetUnitAura", Apply)
		hooksecurefunc(GameTooltip, "SetHyperlink", ApplyHyperlink)
		GameTooltip:HookScript("OnShow", Apply)
		GameTooltip:HookScript("OnHide", ClearTooltipFadeSuppression)

		module.TooltipHooked = true
	end

	module.Initialized = true
	module:UpdateInstanceState()
end

MER:RegisterModule(module:GetName())
