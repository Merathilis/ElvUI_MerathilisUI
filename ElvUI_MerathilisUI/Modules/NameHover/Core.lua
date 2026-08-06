local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_NameHover")

local pcall, type = pcall, type
local max = math.max
local tconcat = table.concat
local find = string.find
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

_G.BINDING_NAME_MER_NAMEHOVER_INSPECT = _G.BINDING_NAME_MER_NAMEHOVER_INSPECT
	or "Name Hover: Hold to Show BlizzToolTip"

local INSTANCE_TYPES = {
	party = true,
	raid = true,
	scenario = true,
}

local CONTENT_INTERVAL = 0.05
local BLIZZ_ALPHA_INTERVAL = 0.1

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
		f.subText:SetText(tconcat(subTexts, "\n"))
	else
		f.subText:SetText("")
	end

	local width, height
	local text = f.mainText:GetText()

	if text and not issecretvalue(text) then
		local okW, w = pcall(f.mainText.GetStringWidth, f.mainText)
		local okH, h = pcall(f.mainText.GetStringHeight, f.mainText)
		if okW and type(w) == "number" then
			width = w
		end
		if okH and type(h) == "number" then
			height = h
		end
	end

	width = max(1, (width or 100) + 16)
	height = max(1, (height or 14) + (12 * subCount))

	f:SetSize(width, height)
	f.mainText:SetPoint("TOP", f, "TOP", 0, subCount > 0 and (12 * subCount) or 0)

	local top = 0
	if module:IsNotEmpty(guild) then
		top = SetAnchor(f.guildText, f.mainText, "TOPLEFT", top)
	end
	if module:IsNotEmpty(headerText) then
		top = SetAnchor(f.headerText, f.mainText, "TOPLEFT", top)
	end
	if module:IsNotEmpty(status) then
		top = SetAnchor(f.statusText, f.mainText, "TOPLEFT", top)
	end

	f.subText:SetPoint("BOTTOMLEFT", f.mainText, "BOTTOMLEFT", 12, -1 + (-12 * subCount))

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
