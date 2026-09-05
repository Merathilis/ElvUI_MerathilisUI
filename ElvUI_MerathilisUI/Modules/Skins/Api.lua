local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local WS = W:GetModule("Skins")
local S = E:GetModule("Skins")

local _G = _G
local assert, pairs, unpack, type = assert, pairs, unpack, type
local strfind, strmatch, tinsert, format, tostring = strfind, strmatch, tinsert, format, tostring
local rad = rad

local CreateColor = CreateColor
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local UIFrameFadeIn = UIFrameFadeIn
local UIFrameFadeOut = UIFrameFadeOut
local YES, NO = YES, NO
local StaticPopupDialogs = StaticPopupDialogs
local PanelTemplates_GetSelectedTab = PanelTemplates_GetSelectedTab

local unitFrameColorR, unitFrameColorG, unitFrameColorB
local rgbValueColorR, rgbValueColorG, rgbValueColorB, rgbValueColorA
local bordercolorr, bordercolorg, bordercolorb

module.ClassColor = _G.RAID_CLASS_COLORS[E.myclass]

module.NORMAL_QUEST_DISPLAY = "|cffffffff%s|r"
module.TRIVIAL_QUEST_DISPLAY = TRIVIAL_QUEST_DISPLAY:gsub("000000", "ffffff")

-- Depends on the arrow texture to be down by default.
module.ArrowRotation = {
	["UP"] = 3.14,
	["DOWN"] = 0,
	["LEFT"] = -1.57,
	["RIGHT"] = 1.57,
}

function module:CreateTex(f)
	assert(f, "doesn't exist!")

	if f.__bgTex then
		return
	end

	local frame = f
	if f:IsObjectType("Texture") then
		frame = f:GetParent()
	end

	local tex = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
	tex:SetAllPoints(f)
	tex:SetTexture(I.Media.Textures.EmptyTex, true, true)
	tex:SetHorizTile(true)
	tex:SetVertTile(true)
	tex:SetBlendMode("ADD")

	f.__bgTex = tex
end

-- Backdrop shadow
local shadowBackdrop = { edgeFile = I.Media.Textures.GlowTex }
function module:CreateSD(f, size)
	assert(f, "doesn't exist!")

	if f.__SDshadow then
		return
	end

	local frame = f
	if f:IsObjectType("Texture") then
		frame = f:GetParent()
	end

	shadowBackdrop.edgeSize = size or 5
	f.__SDshadow = CreateFrame("Frame", nil, frame, "BackdropTemplate")
	f.__SDshadow:SetOutside(f, size or 4, size or 4)
	f.__SDshadow:SetBackdrop(shadowBackdrop)
	f.__SDshadow:SetBackdropBorderColor(0, 0, 0, size and 1 or 0.4)
	f.__SDshadow:SetFrameLevel(1)

	return f.__SDshadow
end

function module:CreateBG(frame)
	assert(frame, "doesn't exist!")

	local f = frame
	if frame:IsObjectType("Texture") then
		f = frame:GetParent()
	end

	local bg = f:CreateTexture(nil, "BACKGROUND")
	bg:Point("TOPLEFT", frame, -E.mult, E.mult)
	bg:Point("BOTTOMRIGHT", frame, E.mult, -E.mult)
	bg:SetTexture(E.media.normTex)
	bg:SetVertexColor(0, 0, 0, 1)

	return bg
end

function module:CreateBackdrop(frame)
	if frame.backdrop then
		return
	end

	local parent = frame.IsObjectType and frame:IsObjectType("Texture") and frame:GetParent() or frame

	local backdrop = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	backdrop:SetOutside(frame)
	backdrop:SetTemplate("Transparent")

	if (parent:GetFrameLevel() - 1) >= 0 then
		backdrop:OffsetFrameLevel(-1, parent)
	else
		backdrop:SetFrameLevel(0)
	end

	frame.backdrop = backdrop
end

---@param f Frame|Texture The frame or texture to create a backdrop for
---@param alpha number? Optional alpha for the template (currently unused, reserved for future)
---@param gradient boolean? Optional gradient flag (currently unused, reserved for future)
function module:CreateBDFrame(f, alpha, gradient)
	assert(f, "doesn't exist!")

	local parent = f.IsObjectType and f:IsObjectType("Texture") and f:GetParent() or f

	local bg = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	bg:SetOutside(f)
	if (parent:GetFrameLevel() - 1) >= 0 then
		bg:OffsetFrameLevel(-1, parent)
	else
		bg:SetFrameLevel(0)
	end
	bg:SetTemplate("Transparent")

	-- Reserved for future use of alpha / gradient parameters
	if alpha then
		bg:SetBackdropColor(0, 0, 0, alpha)
	end

	return bg
end

function module:SetBD(f, x, y, x2, y2)
	assert(f, "doesn't exist!")

	local bg = module:CreateBDFrame(f)
	if x then
		bg:SetPoint("TOPLEFT", f, x, y)
		bg:SetPoint("BOTTOMRIGHT", f, x2, y2)
	end
	module:CreateSD(bg)
	module:CreateTex(bg)

	return bg
end

-- ClassColored ScrollBars
do
	local function GrabScrollBarElement(frame, element)
		local FrameName = frame:GetDebugName()
		return frame[element] or FrameName and (_G[FrameName .. element] or strfind(FrameName, element)) or nil
	end

	function module:HandleScrollBar(_, frame)
		local Thumb = GrabScrollBarElement(frame, "ThumbTexture")
			or GrabScrollBarElement(frame, "thumbTexture")
			or frame.GetThumbTexture and frame:GetThumbTexture()

		if Thumb and Thumb.backdrop then
			local r, g, b = unpack(E.media.rgbvaluecolor)
			Thumb.backdrop:SetBackdropColor(r, g, b)
		end
	end

	-- The modern "trim" ScrollBar (used by e.g. ReputationFrame) leaves its thumb at 25%
	-- alpha while idle (only ElvUI's own OnEnter/OnLeave hooks toggle it to 75%/25%), which
	-- reads as near-black against dark panel backgrounds. Re-hook OnLeave so the idle state
	-- also shows the full class color, matching the classic ScrollBar's always-on coloring.
	local function TrimThumbOnLeave(thumb)
		if thumb.backdrop and not thumb.__isActive then
			local r, g, b = unpack(E.media.rgbvaluecolor)
			thumb.backdrop:SetBackdropColor(r, g, b, 1)
		end
	end

	-- ElvUI's SetTemplate resets a backdrop to the plain template color on every re-template
	-- (e.g. our own E:UpdateFrameTemplates() refresh) unless the frame defines this callback,
	-- which SetTemplate calls instead of the default coloring - without it, the thumb loses
	-- its class color and goes back to black the next time templates get refreshed.
	local function TrimThumbBackdropColor(backdrop)
		local r, g, b = unpack(E.media.rgbvaluecolor)
		backdrop:SetBackdropColor(r, g, b, 1)
	end

	function module:HandleTrimScrollBar(_, frame)
		local thumb = frame.GetThumb and frame:GetThumb()
		if thumb and thumb.backdrop then
			thumb.backdrop.callbackBackdropColor = TrimThumbBackdropColor
			TrimThumbBackdropColor(thumb.backdrop)

			if not thumb.__MERTrimHooked then
				thumb:HookScript("OnLeave", TrimThumbOnLeave)
				thumb.__MERTrimHooked = true
			end
		end
	end
end

function module:ColorButton()
	if self.backdrop then
		self = self.backdrop
	end

	self:SetBackdropColor(rgbValueColorR, rgbValueColorG, rgbValueColorB, 0.3)
	self:SetBackdropBorderColor(rgbValueColorR, rgbValueColorG, rgbValueColorB)
end

function module:ClearButton()
	if self.backdrop then
		self = self.backdrop
	end

	self:SetBackdropColor(0, 0, 0, 0)

	if self.isUnitFrameElement then
		self:SetBackdropBorderColor(unitFrameColorR, unitFrameColorG, unitFrameColorB)
	else
		self:SetBackdropBorderColor(bordercolorr, bordercolorg, bordercolorb)
	end
end

function module:PixelIcon(frame, texture, highlight)
	if not frame then
		return
	end

	frame:CreateBackdrop()
	frame.backdrop:SetAllPoints()
	frame.Icon = frame:CreateTexture(nil, "ARTWORK")
	frame.Icon:SetInside(frame.backdrop)
	frame.Icon:SetTexCoords()
	if texture then
		local atlas = strmatch(texture, "Atlas:(.+)$")
		if atlas then
			frame.Icon:SetAtlas(atlas)
		else
			frame.Icon:SetTexture(texture)
		end
	end
	if highlight and type(highlight) == "boolean" then
		frame:EnableMouse(true)
		frame.HL = frame:CreateTexture(nil, "HIGHLIGHT")
		frame.HL:SetColorTexture(1, 1, 1, 0.25)
		frame.HL:SetInside(frame.backdrop)
	end
end

-- Handle arrows
local arrowDegree = {
	["up"] = 0,
	["down"] = 180,
	["left"] = 90,
	["right"] = -90,
}

function module:SetupArrow(direction)
	if not self then
		return
	end

	self:SetTexture(E.Media.Textures.ArrowUp)
	self:SetRotation(rad(arrowDegree[direction]))
end

function module:ReskinArrow(button, direction)
	button:SetSize(16, 16)
	S:HandleButton(button, true)
	button:SetDisabledTexture(E.media.normTex)

	local dis = button:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, 0.3)
	dis:SetDrawLayer("OVERLAY")
	dis:SetAllPoints()

	local tex = button:CreateTexture(nil, "ARTWORK")
	tex:SetAllPoints()
	module.SetupArrow(tex, direction)
	button.__texture = tex

	button:HookScript("OnEnter", F.Texture_OnEnter)
	button:HookScript("OnLeave", F.Texture_OnLeave)
end

function module:ReskinFilterReset()
	self:StripTextures()
	self:ClearAllPoints()
	self:SetPoint("TOPRIGHT", -5, 10)

	local tex = self:CreateTexture(nil, "ARTWORK")
	tex:SetInside(nil, 2, 2)
	tex:SetTexture(E.media.normTex)
	tex:SetVertexColor(1, 0, 0)
end

function module:ReskinFilterButton(button)
	if not button then
		return
	end

	button:StripTextures()
	S:HandleButton(button)
	if button.Text then
		button.Text:SetPoint("CENTER")
	end
	if button.Icon then
		module.SetupArrow(button.Icon, "right")
		button.Icon:SetPoint("RIGHT")
		button.Icon:SetSize(14, 14)
	end
	if button.ResetButton then
		module.ReskinFilterReset(button.ResetButton)
	end

	local tex = button:CreateTexture(nil, "ARTWORK")
	module.SetupArrow(tex, "right")
	tex:SetSize(16, 16)
	tex:SetPoint("RIGHT", -2, 0)
	button.__texture = tex
end

-- Handle collapse
local function updateCollapseTexture(texture, collapsed)
	if collapsed then
		texture:SetTexCoord(0, 0.4375, 0, 0.4375)
	else
		texture:SetTexCoord(0.5625, 1, 0, 0.4375)
	end
end

local function resetCollapseTexture(self, texture)
	if self.settingTexture then
		return
	end
	self.settingTexture = true
	self:SetNormalTexture("")

	if texture and texture ~= "" then
		if strfind(texture, "Plus") or strfind(texture, "Closed") then
			self.__texture:DoCollapse(true)
		elseif strfind(texture, "Minus") or strfind(texture, "Open") then
			self.__texture:DoCollapse(false)
		end
		self.bg:Show()
	else
		self.bg:Hide()
	end
	self.settingTexture = nil
end

function module:ReskinCollapse(button, isAtlas)
	button:SetHighlightTexture("")
	button:SetPushedTexture("")
	button:SetDisabledTexture("")

	local bg = module:CreateBDFrame(button, 0.25)
	bg:ClearAllPoints()
	bg:SetSize(13, 13)
	bg:SetPoint("TOPLEFT", button:GetNormalTexture())
	button.bg = bg

	button.__texture = bg:CreateTexture(nil, "OVERLAY")
	button.__texture:SetPoint("CENTER")
	button.__texture:SetSize(7, 7)
	button.__texture:SetTexture("Interface\\Buttons\\UI-PlusMinus-Buttons")
	button.__texture.DoCollapse = updateCollapseTexture

	button:HookScript("OnEnter", F.Texture_OnEnter)
	button:HookScript("OnLeave", F.Texture_OnLeave)
	if isAtlas then
		hooksecurefunc(button, "SetNormalAtlas", resetCollapseTexture)
	else
		hooksecurefunc(button, "SetNormalTexture", resetCollapseTexture)
	end
end

function module:SkinPanel(panel)
	panel.tex = panel:CreateTexture(nil, "ARTWORK")
	panel.tex:SetAllPoints()
	panel.tex:SetTexture(E.media.blankTex)
	panel.tex:SetGradient(
		"VERTICAL",
		CreateColor(rgbValueColorR, rgbValueColorG, rgbValueColorB, 1),
		CreateColor(0, 0, 0, 1)
	)
	WS:CreateShadow(panel)
end

local buttons = {
	"ElvUIMoverNudgeWindowUpButton",
	"ElvUIMoverNudgeWindowDownButton",
	"ElvUIMoverNudgeWindowLeftButton",
	"ElvUIMoverNudgeWindowRightButton",
}

local function replaceConfigArrows(button)
	-- remove the default icons
	local tex = _G[button:GetName() .. "Icon"]
	if tex then
		tex:SetTexture(nil)
	end

	-- add the new icon
	if not button.img then
		button.img = button:CreateTexture(nil, "ARTWORK")
		button.img:SetTexture(I.General.MediaPath .. "Textures\\arrow")
		button.img:SetSize(12, 12)
		button.img:Point("CENTER")
		button.img:SetVertexColor(1, 1, 1, 1)

		button:HookScript("OnMouseDown", function(btn)
			if btn:IsEnabled() then
				btn.img:Point("CENTER", -1, -1)
			end
		end)

		button:HookScript("OnMouseUp", function(btn)
			btn.img:Point("CENTER", 0, 0)
		end)
	end
end

function module:ApplyConfigArrows()
	for _, btn in pairs(buttons) do
		replaceConfigArrows(_G[btn])
	end

	-- Apply the rotation
	_G.ElvUIMoverNudgeWindowUpButton.img:SetRotation(module.ArrowRotation["UP"])
	_G.ElvUIMoverNudgeWindowDownButton.img:SetRotation(module.ArrowRotation["DOWN"])
	_G.ElvUIMoverNudgeWindowLeftButton.img:SetRotation(module.ArrowRotation["LEFT"])
	_G.ElvUIMoverNudgeWindowRightButton.img:SetRotation(module.ArrowRotation["RIGHT"])
end

hooksecurefunc(E, "CreateMoverPopup", module.ApplyConfigArrows)

-- Proxy function to call ElvUI Skins functions
---@param method string The function name in ElvUI Skins
---@param frame any The frame to pass to the function
---@param ... any Additional arguments to pass
function module:Proxy(method, frame, ...)
	if not frame then
		F.Developer.ThrowError("Failed to proxy function: frame is nil.", "\n funcName:", method)
		return
	end

	if not S[method] then
		F.Developer.ThrowError(
			format("Proxy: %s does not exist in ElvUI Skins", method),
			"\n frame:",
			frame.GetDebugName and frame:GetDebugName() or tostring(frame)
		)
		return
	end

	S[method](S, frame, ...)
end

-- Disable AddOnSkins Skin
function module:DisableAddOnSkins(optionName, value)
	if _G.AddOnSkins then
		local AS = _G.AddOnSkins[1]
		if AS and AS.db then
			AS.db[optionName] = value
			AS:SetOption(optionName, false)
		end
	end
end

-- Replace the Recap button script re-set function
function S:UpdateRecapButton()
	if self and self.button4 and self.button4:IsEnabled() then
		self.button4:SetScript("OnEnter", module.ColorButton)
		self.button4:SetScript("OnLeave", module.ClearButton)
	end
end

--[[----------------------------------
--	GUI Functions
--]]
----------------------------------
do
	function module:CreateButton(width, height, text, fontSize, outline)
		local bu = CreateFrame("Button", nil, self, "UIPanelButtonTemplate")
		bu:SetSize(width, height)
		if type(text) == "boolean" then
			module:PixelIcon(bu, fontSize, true)
		else
			S:HandleButton(bu)
			bu.text = bu:CreateFontString(nil, "OVERLAY")
			bu.text:FontTemplate(nil, fontSize or 14, outline or "SHADOWOUTLINE")
			bu.text:SetText(text)
		end

		return bu
	end

end

-- keep the colors updated
function module:UpdateMedia()
	rgbValueColorR, rgbValueColorG, rgbValueColorB, rgbValueColorA = unpack(E.media.rgbvaluecolor)
	unitFrameColorR, unitFrameColorG, unitFrameColorB = unpack(E.media.unitframeBorderColor)
	bordercolorr, bordercolorg, bordercolorb = unpack(E.media.bordercolor)
end

hooksecurefunc(E, "UpdateMedia", module.UpdateMedia)

-- hook the skin functions from ElvUI
module:SecureHook(S, "HandleScrollBar")
module:SecureHook(S, "HandleTrimScrollBar")

local function Menu_OnEnter(self)
	self.backdrop:SetBackdropBorderColor(F.r, F.g, F.b)
	UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
end

local function Menu_OnLeave(self)
	self.backdrop:SetBackdropBorderColor(0, 0, 0, 1)
	if E.private.mui.skins.embed.mouseOver then
		UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
	end
end

local function Menu_OnMouseUp(self)
	self.backdrop:SetBackdropColor(0, 0, 0, 0.45)
end

local function Menu_OnMouseDown(self)
	self.backdrop:SetBackdropColor(F.r, F.g, F.b, 0.25)
end

function module:ReskinMenuButton(button)
	assert(button, "doesn't exist!")

	button:StripTextures()

	if not button.backdrop then
		button:CreateBackdrop("Transparent")
	end
	button:SetScript("OnEnter", Menu_OnEnter)
	button:SetScript("OnLeave", Menu_OnLeave)
	button:HookScript("OnMouseUp", Menu_OnMouseUp)
	button:HookScript("OnMouseDown", Menu_OnMouseDown)
end

StaticPopupDialogs["RESET_DETAILS"] = {
	text = L["Reset Details check"],
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		module:ResetDetailsAnchor(true)
	end,
	whileDead = 1,
}

function module:GetToggleDirection()
	local direc = E.private.mui.skins.embed.toggleDirection
	if direc == 1 then
		return ">", "<", "RIGHT", "LEFT", -2, 0, 20, 80
	elseif direc == 2 then
		return "<", ">", "LEFT", "RIGHT", 2, 0, 20, 80
	elseif direc == 3 then
		return "∨", "∧", "BOTTOM", "TOP", 0, 2, 80, 20
	else
		return "∧", "∨", "TOP", "BOTTOM", 0, -2, 80, 20
	end
end

local toggleFrames = {}

local function CreateToggleButton(parent)
	local mouseOver = E.private.mui.skins.embed.mouseOver and true or false
	local bu = CreateFrame("Button", nil, parent)
	bu:SetSize(20, 80)
	bu:Hide()
	bu.text = bu:CreateFontString(nil, "OVERLAY")
	bu.text:FontTemplate(nil, 18)
	bu.text:SetAllPoints()
	module:ReskinMenuButton(bu)
	if mouseOver then
		UIFrameFadeOut(bu, 0.2, bu:GetAlpha(), 0)
	else
		UIFrameFadeIn(bu, 0.2, bu:GetAlpha(), 1)
	end

	return bu
end

function module:CreateToggle(frame)
	local close = CreateToggleButton(frame)
	frame.closeButton = close

	local open = CreateToggleButton(E.UIParent)
	open:Hide()
	frame.openButton = open

	open:SetScript("OnClick", function()
		open:Hide()
	end)
	close:SetScript("OnClick", function()
		open:Show()
	end)

	module:SetToggleDirection(frame)
	tinsert(toggleFrames, frame)

	return open, close
end

function module:SetToggleDirection(frame)
	local str1, str2, rel1, rel2, x, y, width, height = module:GetToggleDirection()
	local parent = frame.backdrop
	local close = frame.closeButton
	local open = frame.openButton
	close:ClearAllPoints()
	close:SetPoint(rel1, parent, rel2, x, y)
	close:SetSize(width, height)
	open:ClearAllPoints()
	open:SetPoint(rel1, parent, rel1, -x, -y)
	open:SetSize(width, height)

	if E.private.mui.skins.embed.toggleDirection == 5 then
		close:SetScale(0.001)
		close:SetAlpha(0)
		open:SetScale(0.001)
		open:SetAlpha(0)
		close.text:SetText("")
		open.text:SetText("")
	else
		close:SetScale(1)
		close:SetAlpha(1)
		open:SetScale(1)
		open:SetAlpha(1)
		close.text:SetText(str1)
		open.text:SetText(str2)
	end
end

function module:RefreshToggleDirection()
	for _, frame in pairs(toggleFrames) do
		module:SetToggleDirection(frame)
	end
end

local function UpdateTabLine(tab)
	if not tab or not tab.BottomLine then
		return
	end

	-- Check active (Blizzard Tabs often use GetID + SelectedState)
	local isActive = tab.isActive
		or tab.selected
		or (PanelTemplates_GetSelectedTab and PanelTemplates_GetSelectedTab(tab:GetParent()) == tab:GetID())

	if isActive then
		tab.BottomLine:SetColorTexture(F.r, F.g, F.b)
		tab.BottomLine:Show()
		tab.BottomLine:SetAlpha(1)
	else
		tab.BottomLine:SetAlpha(0)
		tab.BottomLine:Hide()
	end
end

local function CreateTabLine(tab)
	if tab.BottomLine then
		return
	end

	local line = tab:CreateTexture(nil, "OVERLAY")
	line:SetHeight(1)
	line:SetPoint("BOTTOMLEFT", tab, "BOTTOMLEFT", 4, 1)
	line:SetPoint("BOTTOMRIGHT", tab, "BOTTOMRIGHT", -4, 1)
	line:SetTexture(E.media.normTex)
	line:Hide()

	tab.BottomLine = line
	tab.UpdateTabLine = function()
		UpdateTabLine(tab)
	end
end

hooksecurefunc(S, "HandleTab", function(_, tab)
	if not tab then
		return
	end

	CreateTabLine(tab)

	-- initial state
	UpdateTabLine(tab)

	if not tab._MERHook then
		tab:HookScript("OnClick", function()
			UpdateTabLine(tab)
		end)

		hooksecurefunc(tab, "SetID", function()
			UpdateTabLine(tab)
		end)

		tab._MERHook = true
	end
end)

hooksecurefunc("PanelTemplates_SetTab", function(frame)
	if not frame then
		return
	end

	for _, tab in pairs({ frame:GetChildren() }) do
		if tab and tab.BottomLine then
			UpdateTabLine(tab)
		end
	end
end)
