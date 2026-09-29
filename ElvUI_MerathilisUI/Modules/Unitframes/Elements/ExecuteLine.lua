local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnitFrames")
local UF = E:GetModule("UnitFrames")
local ElvUF = E.oUF

local CreateColor = CreateColor
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local max = math.max
local unpack = unpack
local UnitCanAttack = UnitCanAttack

local MAX_ARENA_FRAMES = 5
local MAX_BOSS_FRAMES = 8

--[[
	oUF element: MER_ExecuteLine

	A line on the health bar at a fixed health percent, e.g. for execute abilities.
	Shared by the MerathilisUI unitframe and nameplate integrations.

	The position never measures the bar: the widget is an invisible StatusBar on
	top of the health bar with the percent as its value, the line sits at the edge
	of its fill. It follows the bar's size, orientation and fill direction, and
	it needs no health value at all (secret-safe).

	Widget: frame.MER_ExecuteLine - a StatusBar, .line is the Texture
	Options: element.hostileOnly - only show it on units the player can attack
--]]

local function Update(self, event, unit)
	if unit and unit ~= self.__unit then
		return
	end

	local element = self.MER_ExecuteLine
	unit = self.__unit

	local show = unit ~= nil
	if show and element.hostileOnly then
		-- A secret answer keeps the line, it is only a hint
		local canAttack = UnitCanAttack("player", unit)
		show = E:IsSecretValue(canAttack) or canAttack
	end

	element:SetShown(show)
end

local function Path(self, ...)
	return (self.MER_ExecuteLine.Override or Update)(self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, "ForceUpdate", element.__owner.__unit)
end

local function Enable(self)
	local element = self.MER_ExecuteLine
	if element then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent("UNIT_FACTION", Path)

		return true
	end
end

local function Disable(self)
	local element = self.MER_ExecuteLine
	if element then
		element:Hide()

		self:UnregisterEvent("UNIT_FACTION", Path)
	end
end

ElvUF:AddElement("MER_ExecuteLine", Path, Enable, Disable)

local function GetLineColor(db)
	if db.colorMode == "CUSTOM" then
		return db.customColor.r, db.customColor.g, db.customColor.b
	end

	local color = E:ClassColor(E.myclass, true)
	return color.r, color.g, color.b
end

local GLOW_PADDING = 3
local PULSE_DURATION = 0.9

-- ElvUI's arrow points up, the coords turn it towards the line
local NOTCH_COORDS = {
	down = { 1, 1, 1, 0, 0, 1, 0, 0 },
	up = { 0, 0, 0, 1, 1, 0, 1, 1 },
	right = { 1, 1, 0, 1, 1, 0, 0, 0 },
	left = { 1, 0, 0, 0, 1, 1, 0, 1 },
}

local function Element_OnShow(element)
	if element.pulse then
		element.glowPulse:Play()
	end
end

local function CreateElement(health)
	local element = CreateFrame("StatusBar", nil, health)
	element:SetStatusBarTexture(E.media.blankTex)
	element:GetStatusBarTexture():SetAlpha(0)
	element:SetMinMaxValues(0, 100)
	element:SetScript("OnShow", Element_OnShow)
	element:Hide()

	-- White textures tinted by vertex color, a second SetColorTexture did not recolor them
	element.line = element:CreateTexture(nil, "OVERLAY", nil, 7)
	element.line:SetTexture(E.media.blankTex)

	-- The execute range: the invisible fill spans from 0 to the percent
	element.zone = element:CreateTexture(nil, "ARTWORK")
	element.zone:SetTexture(E.media.blankTex)
	element.zone:SetAllPoints(element:GetStatusBarTexture())

	element.glow = element:CreateTexture(nil, "OVERLAY", nil, 5)
	element.glow:SetTexture(E.Media.Textures.Spark)
	element.glow:SetBlendMode("ADD")

	local pulse = element.glow:CreateAnimationGroup()
	pulse:SetLooping("BOUNCE")
	local fade = pulse:CreateAnimation("Alpha")
	fade:SetFromAlpha(1)
	fade:SetToAlpha(0.3)
	fade:SetDuration(PULSE_DURATION)
	fade:SetSmoothing("IN_OUT")
	element.glowPulse = pulse

	element.notchA = element:CreateTexture(nil, "OVERLAY", nil, 6)
	element.notchA:SetTexture(E.Media.Textures.ArrowUp)
	element.notchB = element:CreateTexture(nil, "OVERLAY", nil, 6)
	element.notchB:SetTexture(E.Media.Textures.ArrowUp)

	return element
end

-- Fades in towards the line, so the range reads without covering the bar
local function ConfigureZone(element, db, vertical, reverse, r, g, b)
	local zone = element.zone
	zone:SetShown(db.zone)
	if not db.zone then
		return
	end

	local clear = CreateColor(r, g, b, 0)
	local strong = CreateColor(r, g, b, db.zoneAlpha)
	-- min is left (or bottom), the line is at the far end of the fill
	if reverse then
		zone:SetGradient(vertical and "VERTICAL" or "HORIZONTAL", strong, clear)
	else
		zone:SetGradient(vertical and "VERTICAL" or "HORIZONTAL", clear, strong)
	end
end

local function ConfigureGlow(element, db, vertical, r, g, b)
	local glow = element.glow
	local line = element.line

	glow:SetShown(db.glow)
	element.pulse = db.glow and db.pulse
	if element.pulse then
		if element:IsShown() then
			element.glowPulse:Play()
		end
	else
		element.glowPulse:Stop()
	end

	if not db.glow then
		return
	end

	local size = max(10, db.width * 6)
	glow:ClearAllPoints()
	glow:SetVertexColor(r, g, b, 1)

	-- The spark is a vertical glow, turned for vertical bars
	if vertical then
		glow:SetRotation(math.pi / 2)
		glow:SetPoint("LEFT", line, "LEFT", -GLOW_PADDING, 0)
		glow:SetPoint("RIGHT", line, "RIGHT", GLOW_PADDING, 0)
		glow:SetHeight(size)
	else
		glow:SetRotation(0)
		glow:SetPoint("TOP", line, "TOP", 0, GLOW_PADDING)
		glow:SetPoint("BOTTOM", line, "BOTTOM", 0, -GLOW_PADDING)
		glow:SetWidth(size)
	end
end

-- Small arrows just outside the bar that point at the line
local function ConfigureNotches(element, db, vertical, r, g, b)
	local notchA, notchB, line = element.notchA, element.notchB, element.line

	notchA:SetShown(db.notches)
	notchB:SetShown(db.notches)
	if not db.notches then
		return
	end

	local size = max(6, db.width * 3 + 2)
	notchA:SetSize(size, size)
	notchB:SetSize(size, size)
	notchA:SetVertexColor(r, g, b, 1)
	notchB:SetVertexColor(r, g, b, 1)
	notchA:ClearAllPoints()
	notchB:ClearAllPoints()

	if vertical then
		notchA:SetTexCoord(unpack(NOTCH_COORDS.right))
		notchA:SetPoint("RIGHT", line, "LEFT")
		notchB:SetTexCoord(unpack(NOTCH_COORDS.left))
		notchB:SetPoint("LEFT", line, "RIGHT")
	else
		notchA:SetTexCoord(unpack(NOTCH_COORDS.down))
		notchA:SetPoint("BOTTOM", line, "TOP")
		notchB:SetTexCoord(unpack(NOTCH_COORDS.up))
		notchB:SetPoint("TOP", line, "BOTTOM")
	end
end

---Configures the execute line on a unitframe or nameplate
---@param frame table oUF frame with a Health bar
---@param db table settings (enable, percent, width, colorMode, customColor, hostileOnly)
---@param enabled boolean
function MER.ConfigureExecuteLine(frame, db, enabled)
	local health = frame and frame.Health
	if not health then
		return
	end

	if not enabled then
		if frame.MER_ExecuteLine and frame:IsElementEnabled("MER_ExecuteLine") then
			frame:DisableElement("MER_ExecuteLine")
		end
		return
	end

	local element = frame.MER_ExecuteLine
	if not element then
		element = CreateElement(health)
		frame.MER_ExecuteLine = element
	end

	local vertical = health:GetOrientation() == "VERTICAL"
	local reverse = health:GetReverseFill() and true or false

	element:SetAllPoints(health)
	element:SetFrameLevel(health:GetFrameLevel() + 2)
	element:SetOrientation(vertical and "VERTICAL" or "HORIZONTAL")
	element:SetReverseFill(reverse)
	element:SetValue(db.percent)
	element.hostileOnly = db.hostileOnly

	local fill = element:GetStatusBarTexture()
	local line = element.line
	line:ClearAllPoints()
	local r, g, b = GetLineColor(db)
	line:SetVertexColor(r, g, b, 1)

	if vertical then
		local edge = reverse and "BOTTOM" or "TOP"
		line:SetPoint("LEFT", fill, edge .. "LEFT")
		line:SetPoint("RIGHT", fill, edge .. "RIGHT")
		line:SetHeight(db.width)
	else
		local edge = reverse and "LEFT" or "RIGHT"
		line:SetPoint("TOP", fill, "TOP" .. edge)
		line:SetPoint("BOTTOM", fill, "BOTTOM" .. edge)
		line:SetWidth(db.width)
	end

	ConfigureZone(element, db, vertical, reverse, r, g, b)
	ConfigureGlow(element, db, vertical, r, g, b)
	ConfigureNotches(element, db, vertical, r, g, b)

	if not frame:IsElementEnabled("MER_ExecuteLine") then
		frame:EnableElement("MER_ExecuteLine")
	end

	if frame.__unit then
		element:ForceUpdate()
	end
end

-- Unitframe integration
local UNITS = {
	target = true,
	focus = true,
	boss = true,
	arena = true,
}

function module:Configure_ExecuteLine(frame)
	if not frame or not UNITS[frame.unitframeType] then
		return
	end

	local db = E.db.mui.unitframes.executeLine
	MER.ConfigureExecuteLine(frame, db, db.enable and db.units[frame.unitframeType])
end

function module:UpdateExecuteLines()
	module:Configure_ExecuteLine(UF.target)
	module:Configure_ExecuteLine(UF.focus)

	for i = 1, MAX_BOSS_FRAMES do
		module:Configure_ExecuteLine(UF["boss" .. i])
	end
	for i = 1, MAX_ARENA_FRAMES do
		module:Configure_ExecuteLine(UF["arena" .. i])
	end
end

function module:ExecuteLine()
	-- Runs after ElvUI set the bar's orientation and fill direction
	hooksecurefunc(UF, "Configure_HealthBar", function(_, frame)
		module:Configure_ExecuteLine(frame)
	end)

	-- ElvUI spawns its frames before our hooks exist
	module:UpdateExecuteLines()
end
