local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Options") ---@class Options

-- Sub-settings in a small popup instead of on the page, see module.CogGroup in
-- Options/Core.lua for how a group gets there.
--
-- MERCogButton (dialogControl of an "execute"): a row like MERDropdown, the
-- name on top and a box with a short summary of the settings and a gear. A
-- click opens the popup with the group `arg.group` next to the button's own
-- option; `arg.summary` is a function returning the summary text.
--
-- The popup renders that group with AceConfigDialog itself (Open into our own
-- container), so the settings use the same widgets, get/set and disabled
-- states as on the page. A change in the popup refreshes the page behind it.
local AceGUI = E.Libs.AceGUI or LibStub("AceGUI-3.0")
local S = E:GetModule("Skins")

local ipairs, pairs, type, unpack = ipairs, pairs, type, unpack
local CreateFrame, UIParent = CreateFrame, UIParent
local InCombatLockdown = InCombatLockdown
local PlaySound = PlaySound
local C_Timer_After = C_Timer.After

local APP_NAME = "ElvUI"

local COLOR_ACCENT = { I.Colors.Accent.r, I.Colors.Accent.g, I.Colors.Accent.b }
local COLOR_BOX = { 0.16, 0.16, 0.16, 1 }
local COLOR_BOX_HOVER = { I.Colors.Accent.r * 0.3, I.Colors.Accent.g * 0.3, I.Colors.Accent.b * 0.3, 1 }
local COLOR_TEXT_NORMAL = { 1, 1, 1 }
local COLOR_TEXT_MUTED = { 0.7, 0.7, 0.7 }
local COLOR_TEXT_DISABLED = { 0.5, 0.5, 0.5 }

--[[-----------------------------------------------------------------------------
Popup
-------------------------------------------------------------------------------]]
local POPUP_WIDTH = 400
local PAD = 12
local TITLE_HEIGHT = 26

local popup
local current = {} -- path, container, layouts

local function GetDialog()
	return E.Libs.AceConfigDialog
end

local function ClosePopup()
	if popup and popup:IsShown() then
		popup:Hide()
	end
end

local function ReleaseContainer()
	local container = current.container
	if not container then
		return
	end

	current.container = nil
	container.LayoutFinished = container.merStockLayoutFinished
	container.merStockLayoutFinished = nil
	AceGUI:Release(container)
end

-- The page behind shows the changed settings too (previews, summaries,
-- disabled states). Once per frame at most, a change can lay the popup out
-- several times.
local refreshPending
local function RefreshPage()
	refreshPending = nil
	E.Libs.AceConfigRegistry:NotifyChange(APP_NAME)
end

local function Container_LayoutFinished(container, width, height)
	container.merStockLayoutFinished(container, width, height)
	if container ~= current.container then
		return
	end

	popup:SetHeight(TITLE_HEIGHT + 4 + (height or 0) + PAD)

	-- The first layouts belong to opening the popup, later ones to a change
	if current.opening then
		return
	end
	if not refreshPending then
		refreshPending = true
		C_Timer_After(0, RefreshPage)
	end
end

local function Popup_OnKeyDown(frame, key)
	if InCombatLockdown() then
		return
	end

	if key == "ESCAPE" then
		frame:SetPropagateKeyboardInput(false)
		ClosePopup()
	else
		frame:SetPropagateKeyboardInput(true)
	end
end

-- See ColorPickerPopup.lua: no keyboard in combat, it could not pass keys on
local function Popup_OnShow(frame)
	if InCombatLockdown() then
		frame:EnableKeyboard(false)
	else
		frame:EnableKeyboard(true)
		frame:SetPropagateKeyboardInput(true)
	end
end

local function Popup_OnHide()
	ReleaseContainer()
	current.path = nil
	current.anchor = nil
end

local function BuildPopup()
	popup = CreateFrame("Frame", "MER_CogPopup", UIParent)
	popup:SetWidth(POPUP_WIDTH)
	popup:SetFrameStrata("FULLSCREEN_DIALOG")
	popup:SetToplevel(true)
	popup:SetClampedToScreen(true)
	popup:SetMovable(true)
	popup:EnableMouse(true)
	popup:Hide()
	popup:CreateBackdrop("Transparent")
	W:GetModule("Skins"):CreateShadow(popup.backdrop)

	local titleBar = CreateFrame("Frame", nil, popup)
	titleBar:SetPoint("TOPLEFT")
	titleBar:SetPoint("TOPRIGHT")
	titleBar:SetHeight(TITLE_HEIGHT)
	titleBar:EnableMouse(true)
	titleBar:RegisterForDrag("LeftButton")
	titleBar:SetScript("OnDragStart", function()
		popup:StartMoving()
	end)
	titleBar:SetScript("OnDragStop", function()
		popup:StopMovingOrSizing()
	end)

	local accentBar = titleBar:CreateTexture(nil, "OVERLAY")
	accentBar:SetSize(3, 12)
	accentBar:SetPoint("LEFT", PAD, -2)
	accentBar:SetColorTexture(COLOR_ACCENT[1], COLOR_ACCENT[2], COLOR_ACCENT[3], 1)

	local title = titleBar:CreateFontString(nil, "OVERLAY")
	title:FontTemplate(nil, 12)
	title:SetPoint("LEFT", accentBar, "RIGHT", 6, 0)
	title:SetPoint("RIGHT", -28, 0)
	title:SetJustifyH("LEFT")
	title:SetWordWrap(false)
	popup.title = title

	local close = CreateFrame("Button", nil, popup, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", 2, 2)
	S:HandleCloseButton(close)
	close:SetScript("OnClick", ClosePopup)

	popup:SetScript("OnKeyDown", Popup_OnKeyDown)
	popup:SetScript("OnShow", Popup_OnShow)
	popup:SetScript("OnHide", Popup_OnHide)
end

-- Next to the button, at a fixed screen position: the page rebuilds after
-- every change in the popup and the button gets released with it
local function Place(anchor)
	popup:ClearAllPoints()
	local left, bottom, top = anchor:GetLeft(), anchor:GetBottom(), anchor:GetTop()
	if not left or not bottom or not top then
		popup:SetPoint("CENTER")
		return
	end

	local scale = anchor:GetEffectiveScale() / popup:GetEffectiveScale()
	left, bottom, top = left * scale, bottom * scale, top * scale
	if bottom - 300 < 0 then
		popup:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", left, top + 4)
	else
		popup:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", left, bottom - 4)
	end
end

-- Closes with the options window
local hookedFrames = {}
local function HookOptionsFrame()
	local dialog = GetDialog()
	local frame = dialog and dialog.OpenFrames and dialog.OpenFrames[APP_NAME]
	frame = frame and frame.frame
	if frame and not hookedFrames[frame] then
		hookedFrames[frame] = true
		frame:HookScript("OnHide", ClosePopup)
	end
end

local function OpenPopup(path, title, anchor)
	if not popup then
		BuildPopup()
		module.WatchClickOutside(popup, ClosePopup, function()
			return current.anchor
		end)
	end

	ReleaseContainer()
	current.path = path
	current.anchor = anchor
	popup.title:SetText(title or "")

	local container = AceGUI:Create("SimpleGroup")
	container:SetLayout("Flow")
	container.frame:SetParent(popup)
	container.frame:ClearAllPoints()
	container.frame:SetPoint("TOPLEFT", PAD, -(TITLE_HEIGHT + 4))
	container:SetWidth(POPUP_WIDTH - PAD * 2)
	container.merStockLayoutFinished = container.LayoutFinished
	container.LayoutFinished = Container_LayoutFinished
	container.frame:Show()
	current.container = container

	Place(anchor)
	popup:Show()
	popup:Raise()

	current.opening = true
	GetDialog():Open(APP_NAME, container, unpack(path))
	current.opening = nil

	HookOptionsFrame()
end

--[[-----------------------------------------------------------------------------
MERCogButton
-------------------------------------------------------------------------------]]
do
	local Type, Version = "MERCogButton", 1

	-- Same geometry as MERDropdown
	local BOX_HEIGHT = 16
	local BOX_TOP_OFFSET = 18
	local LABEL_HEIGHT = 16
	local FRAME_HEIGHT = 46
	local GEAR_SIZE = 12

	local function UpdateVisual(self)
		local hover = self.hover and not self.disabled
		self.box.backdrop:SetBackdropColor(unpack(hover and COLOR_BOX_HOVER or COLOR_BOX))
		self.label:SetTextColor(unpack(self.disabled and COLOR_TEXT_DISABLED or COLOR_TEXT_NORMAL))
		self.summary:SetTextColor(unpack(self.disabled and COLOR_TEXT_DISABLED or COLOR_TEXT_MUTED))
		if self.disabled then
			self.gear:SetVertexColor(0.5, 0.5, 0.5)
		elseif hover then
			self.gear:SetVertexColor(1, 1, 1)
		else
			self.gear:SetVertexColor(COLOR_ACCENT[1], COLOR_ACCENT[2], COLOR_ACCENT[3])
		end
	end

	local function Box_OnEnter(box)
		local self = box.obj
		self.hover = true
		UpdateVisual(self)
		self:Fire("OnEnter")
	end

	local function Box_OnLeave(box)
		local self = box.obj
		self.hover = nil
		UpdateVisual(self)
		self:Fire("OnLeave")
	end

	local function Box_OnClick(box)
		local self = box.obj
		if self.disabled or not self.group then
			return
		end

		AceGUI:ClearFocus()
		local path = {}
		for i, key in ipairs(self:GetUserData("path") or {}) do
			path[i] = key
		end
		if #path == 0 then
			return
		end
		path[#path] = self.group

		-- A second click on the same button closes it again
		local open = popup and popup:IsShown() and current.path
		if open and #open == #path and open[#open] == path[#path] and open[#open - 1] == path[#path - 1] then
			PlaySound(857) -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF
			ClosePopup()
			return
		end

		PlaySound(856) -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON
		OpenPopup(path, self.label:GetText(), box)
	end

	local methods = {
		["OnAcquire"] = function(self)
			self:SetWidth(200)
			self:SetHeight(FRAME_HEIGHT)
			self.hover = nil
			self.group = nil
			self.summary:SetText("")
			self:SetText("")
			self:SetDisabled(false)
		end,

		["SetText"] = function(self, text)
			self.label:SetText(text or "")
		end,

		-- AceConfigDialog calls these for every execute, the button has its own gear
		["SetImage"] = function() end,
		["SetImageSize"] = function() end,

		["SetDisabled"] = function(self, disabled)
			self.disabled = disabled
			self.box:EnableMouse(not disabled)
			if disabled then
				self.hover = nil
			end
			UpdateVisual(self)
		end,

		["SetCustomData"] = function(self, data)
			if type(data) ~= "table" then
				return
			end

			self.group = data.group
			local summary = data.summary
			if type(summary) == "function" then
				summary = summary()
			end
			self.summary:SetText(summary or "")
		end,
	}

	local function Constructor()
		local frame = CreateFrame("Frame", nil, UIParent)
		frame:Hide()

		local label = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		label:SetHeight(LABEL_HEIGHT)
		label:SetJustifyH("LEFT")
		label:SetWordWrap(false)
		label:SetPoint("TOPLEFT")
		label:SetPoint("TOPRIGHT")

		local box = CreateFrame("Button", nil, frame)
		box:SetHeight(BOX_HEIGHT)
		box:SetPoint("TOPLEFT", 0, -BOX_TOP_OFFSET)
		box:SetPoint("TOPRIGHT", 0, -BOX_TOP_OFFSET)
		-- ignoreUpdates=true keeps it out of E.frames, see Button.lua
		box:CreateBackdrop("Transparent", nil, true)

		local gear = box:CreateTexture(nil, "ARTWORK")
		gear:SetSize(GEAR_SIZE, GEAR_SIZE)
		gear:SetPoint("RIGHT", -3, 0)
		gear:SetTexture(I.Media.Icons.Categories.Config)

		local summary = box:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		summary:SetJustifyH("LEFT")
		summary:SetWordWrap(false)
		summary:SetPoint("LEFT", 4, 0)
		summary:SetPoint("RIGHT", gear, "LEFT", -4, 0)

		local widget = {
			frame = frame,
			label = label,
			box = box,
			gear = gear,
			summary = summary,
			type = Type,
			-- Same as MERDropdown, so the button lines up with dropdowns and sliders
			alignoffset = BOX_TOP_OFFSET + (BOX_HEIGHT / 2),
		}
		for method, func in pairs(methods) do
			widget[method] = func
		end

		box.obj = widget
		box:RegisterForClicks("LeftButtonUp")
		box:SetScript("OnEnter", Box_OnEnter)
		box:SetScript("OnLeave", Box_OnLeave)
		box:SetScript("OnClick", Box_OnClick)

		return AceGUI:RegisterAsWidget(widget)
	end

	AceGUI:RegisterWidgetType(Type, Constructor, Version)
end
