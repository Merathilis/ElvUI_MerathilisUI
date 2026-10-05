local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnlockMode")
local S = E:GetModule("Skins")
local WS = W:GetModule("Skins")

-- Toolbar at the top of the screen that replaces ElvUI's mover popup: layout
-- filter, grid, snapping, the changes of this session and save / revert.

local _G = _G
local format = format
local max, tonumber = math.max, tonumber
local tconcat, tinsert, wipe = table.concat, tinsert, wipe

local CreateFrame = CreateFrame
local EditBox_ClearFocus = EditBox_ClearFocus
local EditBox_HighlightText = EditBox_HighlightText
local GameTooltip = GameTooltip

local PADDING = 8
local SPACING = 12
local ROW_HEIGHT = 24
local HINT_HEIGHT = 14
local HINT_SEPARATOR = "  |cff666666|||r  "

local function AddTooltip(widget, title, text)
	widget:HookScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -4)
		GameTooltip:AddLine(title, 1, 1, 1)
		GameTooltip:AddLine(text, nil, nil, nil, true)
		GameTooltip:Show()
	end)
	widget:HookScript("OnLeave", function()
		GameTooltip:Hide()
	end)
end

local function CreateText(parent, size)
	local text = parent:CreateFontString(nil, "OVERLAY")
	text:FontTemplate(nil, size or 12, "SHADOW")
	text:SetJustifyH("LEFT")
	return text
end

local function CreateButton(parent, text, width, onClick)
	local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	button:Size(width, ROW_HEIGHT - 2)
	button:SetText(text)
	button:SetScript("OnClick", onClick)
	S:HandleButton(button)
	return button
end

local function CreateCheckBox(parent, text, onClick)
	local checkBox = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
	checkBox:Size(ROW_HEIGHT)
	checkBox:SetScript("OnClick", function(self)
		onClick(self:GetChecked())
	end)
	S:HandleCheckBox(checkBox)

	local label = CreateText(checkBox)
	label:SetPoint("LEFT", checkBox, "RIGHT", 2, 0)
	label:SetText(text)
	-- The label clicks the box too
	checkBox:SetHitRectInsets(0, -(label:GetStringWidth() + 2), 0, 0)
	checkBox.label = label

	return checkBox, ROW_HEIGHT + 2 + label:GetStringWidth()
end

-------------------------------------------------------------------------------
--  Grid size box, works like the one in ElvUI's popup
-------------------------------------------------------------------------------
local function CreateGridSizeBox(parent)
	local box = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
	box:Size(34, ROW_HEIGHT - 4)
	box:SetAutoFocus(false)
	box:SetJustifyH("CENTER")
	S:HandleEditBox(box)

	local function Reset(self)
		self:SetText(E.db.gridSize)
	end

	box:SetScript("OnEscapePressed", function(self)
		Reset(self)
		EditBox_ClearFocus(self)
	end)
	box:SetScript("OnEnterPressed", function(self)
		local size = tonumber(self:GetText())
		if size and size >= 4 and size <= 256 then
			E.db.gridSize = size
			if module.db.showGrid then
				E:Grid_Show()
				_G.ElvUIGrid:SetAlpha(0.4)
			end
		end
		Reset(self)
		EditBox_ClearFocus(self)
	end)
	box:SetScript("OnEditFocusLost", Reset)
	box:SetScript("OnEditFocusGained", EditBox_HighlightText)
	box:SetScript("OnShow", Reset)

	AddTooltip(box, L["Grid Size"], L["Number of grid cells across the screen, from 4 to 256."])

	return box
end

-------------------------------------------------------------------------------
--  Toolbar
-------------------------------------------------------------------------------
function module:CreateToolbar()
	local bar = CreateFrame("Frame", "MER_UnlockModeToolbar", E.UIParent)
	bar:SetFrameStrata("DIALOG")
	bar:SetFrameLevel(1000)
	bar:SetClampedToScreen(true)
	bar:SetMovable(true)
	bar:SetDontSavePosition(true)
	bar:EnableMouse(true)
	bar:RegisterForDrag("LeftButton")
	bar:SetScript("OnDragStart", bar.StartMoving)
	bar:SetScript("OnDragStop", bar.StopMovingOrSizing)
	bar:CreateBackdrop("Transparent")
	WS:CreateBackdropShadow(bar)
	bar:Point("TOP", E.UIParent, "TOP", 0, -110)
	bar:Hide()
	self.toolbar = bar

	-- Row of controls, placed from left to right
	local x = PADDING
	local rowY = -(PADDING + ROW_HEIGHT * 0.5)
	local function Place(widget, width, gap)
		x = x + (gap or 0)
		widget:SetPoint("LEFT", bar, "TOPLEFT", x, rowY)
		x = x + width
	end

	local title = CreateText(bar, 14)
	title:SetText(MER.Title .. L["Unlock Mode"])
	Place(title, title:GetStringWidth())

	local layout = CreateFrame("DropdownButton", nil, bar, "WowStyle1DropdownTemplate")
	S:HandleDropDownBox(layout, 150)
	layout:SetupMenu(E.ConfigMode_Initialize)
	Place(layout, 150, SPACING + 4)
	bar.layout = layout

	local grid, gridWidth = CreateCheckBox(bar, L["Grid"], function(checked)
		module.db.showGrid = checked
		if checked then
			E:Grid_Show()
			_G.ElvUIGrid:SetAlpha(0.4)
		else
			E:Grid_Hide()
		end
	end)
	Place(grid, gridWidth, SPACING)
	bar.grid = grid

	local gridSize = CreateGridSizeBox(bar)
	Place(gridSize, 34, 6)
	bar.gridSize = gridSize

	local snap, snapWidth = CreateCheckBox(bar, L["Snap"], function(checked)
		module.db.snap.enable = checked
		module:UpdateToolbarHint()
	end)
	AddTooltip(
		snap,
		L["Snap"],
		L["Edges and centers snap to the other movers and to the screen while you drag. Hold Shift to drag freely."]
	)
	Place(snap, snapWidth, SPACING)
	bar.snap = snap

	local changes = CreateText(bar)
	changes:SetWidth(110)
	changes:SetJustifyH("CENTER")
	Place(changes, 110, SPACING)
	bar.changes = changes

	local revert = CreateButton(bar, L["Revert"], 80, function()
		module:RevertChanges()
	end)
	AddTooltip(revert, L["Revert"], L["Puts every mover back where it was when the unlock mode opened."])
	Place(revert, 80, SPACING)
	bar.revert = revert

	local reset = CreateButton(bar, L["Reset All"], 80, function()
		E:ResetUI()
	end)
	AddTooltip(reset, L["Reset All"], L["Puts every mover back to its default position."])
	Place(reset, 80, 4)

	local save = CreateButton(bar, L["Save & Lock"], 100, function()
		module:CloseMoveMode()
	end)
	Place(save, 100, 4)

	-- Anchor of the selected mover, text and detach button centered as one
	local anchorRow = CreateFrame("Frame", nil, bar)
	anchorRow:Height(ROW_HEIGHT)
	anchorRow:SetPoint("TOP", bar, "TOP", 0, -(PADDING + ROW_HEIGHT + 6))
	bar.anchorRow = anchorRow

	local anchorText = CreateText(anchorRow)
	anchorText:SetPoint("LEFT", anchorRow, "LEFT")
	bar.anchorText = anchorText

	local detach = CreateButton(anchorRow, L["Detach"], 70, function()
		if module.selected then
			module:Detach(module.selected.name)
			module:AnchorsChanged()
		end
	end)
	detach:SetPoint("LEFT", anchorText, "RIGHT", 8, 0)
	bar.detach = detach

	local hint = CreateText(bar, 11)
	hint:SetTextColor(0.7, 0.7, 0.7)
	hint:SetJustifyH("CENTER")
	hint:SetPoint("TOP", anchorRow, "BOTTOM", 0, -4)
	bar.hint = hint

	bar.rowWidth = x + PADDING
	bar:Height(PADDING * 2 + ROW_HEIGHT * 2 + 10 + HINT_HEIGHT)
end

local function MoverLabel(name)
	local mover = _G[name]
	return "|cffffffff" .. (mover and mover.textString or name) .. "|r"
end

function module:UpdateToolbarAnchor()
	local bar = self.toolbar
	local selected = self.selected
	local anchor = selected and self:GetAnchor(selected.name)

	if anchor then
		bar.anchorText:SetText(format(L["%s is anchored to %s."], MoverLabel(selected.name), MoverLabel(anchor.target)))
		bar.anchorText:SetTextColor(1, 0.82, 0)
	elseif selected then
		bar.anchorText:SetText(format(L["Alt-click another mover to anchor %s to it."], MoverLabel(selected.name)))
		bar.anchorText:SetTextColor(0.7, 0.7, 0.7)
	else
		bar.anchorText:SetText(L["Select a mover, then Alt-click another one to anchor it there."])
		bar.anchorText:SetTextColor(0.7, 0.7, 0.7)
	end

	bar.detach:SetShown(anchor ~= nil)
	local width = bar.anchorText:GetStringWidth()
	if anchor then
		width = width + 8 + bar.detach:GetWidth()
	end
	bar.anchorRow:SetWidth(width)
end

local hintParts = {}

function module:UpdateToolbarHint()
	local bar = self.toolbar
	wipe(hintParts)

	tinsert(hintParts, L["Click: select"])
	if self.db.keyboardNudge then
		tinsert(hintParts, format(L["Arrow keys: nudge, with Shift %d px"], self.db.bigStep))
	end
	if self.db.snap.enable then
		tinsert(hintParts, L["Shift while dragging: no snapping"])
	end
	tinsert(hintParts, L["Right-click: settings"])
	tinsert(hintParts, L["Ctrl+Right-click: reset"])
	tinsert(hintParts, L["Shift+Right-click: hide"])

	bar.hint:SetText(tconcat(hintParts, HINT_SEPARATOR))
	bar:Width(max(bar.rowWidth, bar.hint:GetStringWidth() + PADDING * 2))
end

function module:UpdateToolbarChanges(count)
	local bar = self.toolbar
	if count > 0 then
		bar.changes:SetText(format(count == 1 and L["%d change"] or L["%d changes"], count))
		bar.changes:SetTextColor(F.r, F.g, F.b)
	else
		bar.changes:SetText(L["No changes"])
		bar.changes:SetTextColor(0.5, 0.5, 0.5)
	end
	bar.revert:SetEnabled(count > 0)
end

function module:ShowToolbar()
	if not self.toolbar then
		self:CreateToolbar()
	end

	local bar = self.toolbar
	bar.grid:SetChecked(self.db.showGrid)
	bar.snap:SetChecked(self.db.snap.enable)
	bar.layout:GenerateMenu()
	self:UpdateToolbarHint()
	self:UpdateToolbarAnchor()
	self:UpdateChanges()
	bar:Show()
end
