local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_NameHover")

local pcall, type = pcall, type
local max = math.max
local tconcat = table.concat
local issecretvalue = issecretvalue

local GetCursorPosition = GetCursorPosition
local hooksecurefunc = hooksecurefunc
local IsShiftKeyDown = IsShiftKeyDown
local IsControlKeyDown = IsControlKeyDown
local IsAltKeyDown = IsAltKeyDown
local UnitName = UnitName
local UnitIsUnit = UnitIsUnit
local UnitExists = UnitExists

local C_Timer_After = C_Timer.After

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

_G.BINDING_NAME_MER_NAMEHOVER_INSPECT = _G.BINDING_NAME_MER_NAMEHOVER_INSPECT or "Name Hover: Hold to Show BlizzToolTip"

local INSTANCE_TYPES = {
	party = true,
	raid = true,
	scenario = true,
}

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
	elseif key == "NONE" then
		return false
	end
	return false
end

local function IsInspectOverrideActive()
	return module.inspectBindingHeld or IsInspectKeyDown()
end

function module:IsDisabledInCurrentInstance()
	if not self.db or not self.db.disableInDungeons then
		return false
	end

	local inInstance, instanceType = IsInInstance()
	return inInstance and INSTANCE_TYPES[instanceType] or false
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

		if
			type(name) == "string"
			and (string.find(name, "NamePlate", 1, true) or string.find(name, "Plater", 1, true))
		then
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
	if not module.db then
		return false
	end

	if module:IsDisabledInCurrentInstance() or module.db.blizztooltip or IsInspectOverrideActive() then
		return false
	end

	return not UnitExists("mouseover")
end

local function ClearTooltipFadeSuppression()
	module.suppressTooltipFade = false
end

local function UpdateBlizzTooltipAlpha()
	if not GameTooltip or not GameTooltip.SetAlpha or not module.db then
		return
	end

	if module:IsDisabledInCurrentInstance() or IsInspectOverrideActive() or module.db.blizztooltip then
		ClearTooltipFadeSuppression()
		module.inspectMode = module:IsDisabledInCurrentInstance() and false or IsInspectOverrideActive()
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
	if not GameTooltip or not GameTooltip.Hide or not GameTooltip:IsShown() then
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

-- =========================
-- BLIZZARD TOOLTIP CONTROL
-- =========================
module.inspectMode = false

local function ApplyBlizzState(self)
	if not module.db then
		return
	end

	UpdateBlizzTooltipAlpha()
end

function module:SetInspectBindingState(isDown)
	self.inspectBindingHeld = isDown == true
	UpdateBlizzTooltipAlpha()

	if self.UpdateInstanceState then
		self:UpdateInstanceState()
	end
end

function MER_NameHover_SetInspectBindingState(isDown)
	module:SetInspectBindingState(isDown)
end

-- =========================
-- NAMEHOVER ALPHA CONTROL
-- =========================
local function ApplyNameHoverAlpha(frame)
	if not frame then
		return
	end

	if module:IsDisabledInCurrentInstance() then
		frame:Hide()
		return
	end

	-- ONLY hide during inspect key usage
	if module.inspectMode then
		if frame:GetAlpha() ~= 0 then
			frame:SetAlpha(0)
		end
	else
		if frame:GetAlpha() ~= 1 then
			frame:SetAlpha(1)
		end
	end
end

-- =========================
-- FRAME HELPERS
-- =========================
local function SetAnchor(element, anchor, position, top)
	local margin = 13
	margin = (top or 0) + margin
	top = margin + 2

	element:SetPoint(position, anchor, position, 0, margin)
	return top
end

-- =========================
-- CONTENT UPDATE
-- =========================
local function UpdateFrameContents(f)
	if module:IsDisabledInCurrentInstance() then
		f:Hide()
		return
	end

	if not IsAllowedMouseFocus() then
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
	local statusText = status
	local headerText = module:CombineText(faction, classification, creatureType, race)
	local guildText = guild

	f.lastUnitGUID = UnitGUID("mouseover")

	f.mainText:SetText(mainText)
	f.statusText:SetText(statusText)
	f.headerText:SetText(headerText)
	f.guildText:SetText(guildText)

	local offset = 0
	local subTexts = module:CombineTables(module:GetQuestText("mouseover", tooltips))

	if subTexts and #subTexts > 0 then
		offset = 12 * #subTexts
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

	width = width or 100
	height = height or 14

	local subCount = (subTexts and #subTexts) or 0
	width = max(1, width + 16)
	height = max(1, height + (12 * subCount))

	f:SetSize(width, height)
	f.mainText:SetPoint("TOP", f, "TOP", 0, offset)

	local top = 0
	if module:IsNotEmpty(guildText) then
		top = SetAnchor(f.guildText, f.mainText, "TOPLEFT", top)
	end
	if module:IsNotEmpty(headerText) then
		top = SetAnchor(f.headerText, f.mainText, "TOPLEFT", top)
	end
	if module:IsNotEmpty(statusText) then
		top = SetAnchor(f.statusText, f.mainText, "TOPLEFT", top)
	end

	f.subText:SetPoint("BOTTOMLEFT", f.mainText, "BOTTOMLEFT", 12, -1 + (-12 * subCount))

	f:Show()

	ApplyNameHoverAlpha(f)
end

-- =========================
-- POSITION UPDATE
-- =========================
local function UpdateFramePosition(f)
	if module:IsDisabledInCurrentInstance() or not UnitExists("mouseover") then
		f:Hide()
		return
	end

	local x, y = GetCursorPosition()
	local scale = UIParent:GetEffectiveScale()

	f:ClearAllPoints()
	f:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x / scale, y / scale + 15)

	-- FORCE ABOVE BLIZZ TOOLTIP
	if GameTooltip and GameTooltip:IsShown() then
		f:SetFrameStrata("TOOLTIP")
		f:SetFrameLevel(GameTooltip:GetFrameLevel() + 10)
	end

	ApplyNameHoverAlpha(f)
end

function module:UpdateInstanceState()
	if not self.frame then
		return
	end

	if self:IsDisabledInCurrentInstance() then
		self.inspectMode = false
		self.frame:Hide()
	else
		if UnitExists("mouseover") then
			UpdateFrameContents(self.frame)
			UpdateFramePosition(self.frame)
		else
			self.frame:Hide()
		end
	end

	if GameTooltip and GameTooltip:IsShown() then
		ApplyBlizzState(GameTooltip)
	end
end

-- =========================
-- INIT
-- =========================
function module:Initialize()
	module.db = E.db.mui.nameHover

	if not module.db.enable or module.Initialized then
		return
	end

	local frame = CreateFrame("Frame", "MER_NameHoverFrame", E.UIParent)
	frame:SetFrameStrata("TOOLTIP")

	module.frame = frame

	frame.mainText = frame:CreateFontString(nil, "OVERLAY")
	frame.mainText:FontTemplate(
		nil,
		module.db.mainTextSize or 14,
		module.db.mainTextOutline and "SHADOWOUTLINE" or "NONE"
	)

	frame.statusText = frame:CreateFontString(nil, "OVERLAY")
	frame.statusText:FontTemplate(
		nil,
		module.db.statusTextSize or 11,
		module.db.statusTextOutline and "SHADOWOUTLINE" or "NONE"
	)

	frame.headerText = frame:CreateFontString(nil, "OVERLAY")
	frame.headerText:FontTemplate(
		nil,
		module.db.headerTextSize or 11,
		module.db.headerTextOutline and "SHADOWOUTLINE" or "NONE"
	)

	frame.guildText = frame:CreateFontString(nil, "OVERLAY")
	frame.guildText:FontTemplate(
		nil,
		module.db.guildTextSize or 11,
		module.db.guildTextOutline and "SHADOWOUTLINE" or "NONE"
	)

	frame.subText = frame:CreateFontString(nil, "OVERLAY", "GameTooltipText")
	frame.subText:FontTemplate(nil, module.db.subTextSize or 11, module.db.subTextOutline and "SHADOWOUTLINE" or "NONE")

	frame:SetScript("OnUpdate", function(self, elapsed)
		UpdateFramePosition(self)
		UpdateBlizzTooltipAlpha()
		HideBlizzTooltipIfStale()

		self.refreshElapsed = (self.refreshElapsed or 0) + (elapsed or 0)
		if self.refreshElapsed < 0.05 then
			return
		end

		self.refreshElapsed = 0

		if module:IsDisabledInCurrentInstance() or self.updateQueued or not UnitExists("mouseover") then
			return
		end

		local unitGUID = UnitGUID("mouseover")
		if not self:IsShown() or unitGUID ~= self.lastUnitGUID then
			UpdateFrameContents(self)
			if self:IsShown() then
				UpdateFramePosition(self)
			end
		end
	end)

	frame:SetScript("OnEvent", function(self, event)
		if event == "MODIFIER_STATE_CHANGED" then
			UpdateBlizzTooltipAlpha()

			if module:IsDisabledInCurrentInstance() then
				self:Hide()
			elseif UnitExists("mouseover") then
				UpdateFrameContents(self)
				if self:IsShown() then
					UpdateFramePosition(self)
				end
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

			if module:IsDisabledInCurrentInstance() or not UnitExists("mouseover") then
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

	-- BLIZZ TOOLTIP HOOKS
	if not module.TooltipHooked then
		local function Apply(self)
			ApplyBlizzState(self)
		end

		local function ApplyHyperlink(self)
			ClearTooltipFadeSuppression()
			ApplyBlizzState(self)
		end

		hooksecurefunc(GameTooltip, "SetUnit", Apply)
		hooksecurefunc(GameTooltip, "SetUnitAura", Apply)
		hooksecurefunc(GameTooltip, "SetHyperlink", ApplyHyperlink)
		-- GameTooltip:HookScript("OnTooltipSetUnit", Apply)
		GameTooltip:HookScript("OnShow", Apply)
		GameTooltip:HookScript("OnHide", ClearTooltipFadeSuppression)
		GameTooltip:HookScript("OnUpdate", Apply)

		module.TooltipHooked = true
	end

	module.Initialized = true
	module:UpdateInstanceState()
end

MER:RegisterModule(module:GetName())
