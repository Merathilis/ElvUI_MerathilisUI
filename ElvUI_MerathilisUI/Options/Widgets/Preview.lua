local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options

local AceGUI = E.Libs.AceGUI or LibStub("AceGUI-3.0")
local LSM = E.LSM or E.Libs.LSM

local max, min = math.max, math.min
local CreateFrame, UIParent = CreateFrame, UIParent

-- Shared base of the live previews on the option pages. A preview is the
-- `dialogControl` of a description, the description's name is its key (which
-- settings it shows). AceConfigDialog acquires the widgets again after every
-- change, so `update` runs with the current settings each time.

local Preview = {}
module.Preview = Preview

local function Noop() end

-- Every preview sits on a stage: its content scaled down a bit, never wider
-- than STAGE_MAX_WIDTH and centered in the row. The previews draw on the
-- stage (widget.stage, `widget.frame` inside the Register callbacks), the row
-- itself (widget.frame) only takes the stage's scaled height.
local STAGE_SCALE = 0.85
local STAGE_MAX_WIDTH = 560

---Puts the frame of a preview widget on a stage, see above. Call it at the
---end of the constructor, before RegisterAsWidget; the preview then draws on
---widget.stage and sizes it through Preview.SetStageWidth.
---@param widget table
---@return table widget
function Preview.Contain(widget)
	local stage = widget.frame
	local row = CreateFrame("Frame", nil, UIParent)
	row:Hide()

	stage:SetParent(row)
	stage:ClearAllPoints()
	stage:SetPoint("TOP", row, "TOP")
	stage:SetScale(STAGE_SCALE)
	stage:Show()

	-- The row follows every height the preview gives its stage
	local stageSetHeight = stage.SetHeight
	stage.SetHeight = function(frame, height)
		stageSetHeight(frame, height)
		row:SetHeight(height * STAGE_SCALE)
	end
	row:SetHeight(stage:GetHeight() * STAGE_SCALE)

	widget.frame = row
	widget.stage = stage

	-- Widgets without an own SetWidth get their width through OnWidthSet
	local onWidthSet = widget.OnWidthSet
	widget.OnWidthSet = function(self, width)
		self.stage:SetWidth(min(width / STAGE_SCALE, STAGE_MAX_WIDTH))
		if onWidthSet then
			onWidthSet(self, width)
		end
	end

	return widget
end

---Width of the row, the stage gets its scaled share of it
---@param widget table contained by Preview.Contain
---@param width number
function Preview.SetStageWidth(widget, width)
	widget.frame:SetWidth(width)
	widget.stage:SetWidth(min(width / STAGE_SCALE, STAGE_MAX_WIDTH))
end

---Registers an AceGUI preview widget
---@param widgetType string AceGUI widget type
---@param version number
---@param height number height of the preview frame
---@param build fun(widget: table) creates the regions on widget.frame
---@param update fun(widget: table, key: string) applies the settings of the key
---@param release? fun(widget: table) stops what the preview runs while shown
function Preview.Register(widgetType, version, height, build, update, release)
	local function Constructor()
		local stage = CreateFrame("Frame", nil, UIParent)
		stage:SetHeight(height)

		local widget = {
			type = widgetType,
			frame = stage,
		}

		-- The callbacks see the stage as widget.frame, everything else they
		-- read or store goes to the widget itself
		local view = setmetatable({ frame = stage }, { __index = widget, __newindex = widget })
		widget.view = view
		build(view)

		local function Update(self)
			if self._key then
				update(self.view, self._key)
			end
		end

		widget.OnAcquire = function(self)
			self.frame:Show()
		end

		widget.OnRelease = function(self)
			if release then
				release(self.view)
			end
			self.frame:Hide()
			self._key = nil
		end

		widget.SetText = function(self, text)
			self._key = text ~= "" and text or nil
			Update(self)
		end

		widget.SetWidth = function(self, width)
			Preview.SetStageWidth(self, width)
			Update(self)
		end

		-- Full width rows get their width from the layout after SetText
		widget.OnWidthSet = Update

		widget.SetLabel = Noop
		widget.SetDisabled = Noop
		widget.SetImage = Noop
		widget.SetImageSize = Noop
		widget.SetFontObject = Noop
		widget.SetJustifyH = Noop
		widget.SetJustifyV = Noop
		widget.SetColor = Noop

		Preview.Contain(widget)
		return AceGUI:RegisterAsWidget(widget)
	end

	AceGUI:RegisterWidgetType(widgetType, Constructor, version)
end

---Width for a sample inside the preview, never wider than maxWidth
---@param widget table
---@param maxWidth number
---@param inset? number space kept free on both sides
---@return number
function Preview.Width(widget, maxWidth, inset)
	return max(min(widget.frame:GetWidth() - (inset or 0) * 2, maxWidth), 1)
end

---Dims the preview while the feature is off
---@param widget table
---@param enabled any
function Preview.SetEnabled(widget, enabled)
	widget.frame:SetAlpha(enabled and 1 or 0.4)
end

---A health bar like the ones of ElvUI: dark backdrop with a filled part
---@param parent Frame
---@return Frame bar with .fill
function Preview.CreateBar(parent)
	local bar = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	bar:SetTemplate("Transparent")

	bar.fill = bar:CreateTexture(nil, "ARTWORK", nil, 1)
	bar.fill:SetPoint("TOPLEFT")
	bar.fill:SetPoint("BOTTOMLEFT")

	return bar
end

---@param bar Frame from Preview.CreateBar
---@param width number
---@param height number
---@param value number filled part, 0 to 1
---@param texture string LSM statusbar name
function Preview.UpdateBar(bar, width, height, value, texture, r, g, b)
	bar:SetSize(width, height)
	bar.fill:SetTexture(LSM:Fetch("statusbar", texture))
	bar.fill:SetVertexColor(r, g, b, 1)
	bar.fill:SetWidth(max(width * value, 1))
end

---The color of a hostile unit, like a health bar without any indicator
---@return number r, number g, number b
function Preview.HostileColor()
	local colors = E.db.nameplates and E.db.nameplates.colors
	local color = colors and colors.reactions and colors.reactions[1]
	if color then
		return color.r, color.g, color.b
	end

	return 0.8, 0.3, 0.21
end

---Health bar size of a hostile player nameplate, kept inside the preview
---@param maxWidth number
---@return number width, number height
function Preview.NameplateSize(maxWidth)
	local health = E.db.nameplates.units.ENEMY_PLAYER.health
	return min(health.width, maxWidth), min(max(health.height, 4), 40)
end

---Size of an ElvUI unitframe, kept inside the preview
---@param unit string key under E.db.unitframe.units
---@param maxWidth number
---@return number width, number height
function Preview.UnitFrameSize(unit, maxWidth)
	local db = E.db.unitframe.units[unit]
	return min(db.width, maxWidth), min(max(db.height, 10), 80)
end
