local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local WS = W:GetModule("Skins")
local S = E:GetModule("Skins")

local _G = _G
local assert, pairs, unpack, type = assert, pairs, unpack, type
local strfind = strfind

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local UIFrameFadeIn = UIFrameFadeIn
local UIFrameFadeOut = UIFrameFadeOut

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

do
	local regions = {
		"Center",
		"BottomEdge",
		"LeftEdge",
		"RightEdge",
		"TopEdge",
		"BottomLeftCorner",
		"BottomRightCorner",
		"TopLeftCorner",
		"TopRightCorner",
	}

	--[[
		Strip edge textures
		@param {frame} frame
	]]
	function module:StripEdgeTextures(frame)
		for _, regionKey in pairs(regions) do
			if frame[regionKey] then
				frame[regionKey]:Kill()
			end
		end
	end
end

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
function module:CreateSD(f, size, override)
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

function module:CreateBDFrame(f)
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

local ReplacedRoleTex = {
	["Adventures-Tank"] = "Soulbinds_Tree_Conduit_Icon_Protect",
	["Adventures-Healer"] = "ui_adv_health",
	["Adventures-DPS"] = "ui_adv_atk",
	["Adventures-DPS-Ranged"] = "Soulbinds_Tree_Conduit_Icon_Utility",
}
local function replaceFollowerRole(roleIcon, atlas)
	local newAtlas = ReplacedRoleTex[atlas]
	if newAtlas then
		roleIcon:SetAtlas(newAtlas)
	end
end

function module:ReskinGarrisonPortrait()
	local level = self.Level or self.LevelText
	if level then
		level:ClearAllPoints()
		level:SetPoint("BOTTOM", self, 0, 15)
		if self.LevelCircle then
			self.LevelCircle:Hide()
		end
		if self.LevelBorder then
			self.LevelBorder:SetScale(0.0001)
		end
	end

	self.squareBG = module:CreateBDFrame(self.Portrait, 1)

	if self.PortraitRing then
		self.PortraitRing:Hide()
		self.PortraitRingQuality:SetTexture("")
		self.PortraitRingCover:SetColorTexture(0, 0, 0)
		self.PortraitRingCover:SetAllPoints(self.squareBG)
	end

	if self.Empty then
		self.Empty:SetColorTexture(0, 0, 0)
		self.Empty:SetAllPoints(self.Portrait)
	end
	if self.Highlight then
		self.Highlight:Hide()
	end
	if self.PuckBorder then
		self.PuckBorder:SetAlpha(0)
	end
	if self.TroopStackBorder1 then
		self.TroopStackBorder1:SetAlpha(0)
	end
	if self.TroopStackBorder2 then
		self.TroopStackBorder2:SetAlpha(0)
	end

	if self.HealthBar then
		self.HealthBar.Border:Hide()

		local roleIcon = self.HealthBar.RoleIcon
		roleIcon:ClearAllPoints()
		roleIcon:SetPoint("CENTER", self.squareBG, "TOPRIGHT", -2, -2)
		replaceFollowerRole(roleIcon, roleIcon:GetAtlas())
		hooksecurefunc(roleIcon, "SetAtlas", replaceFollowerRole)

		local background = self.HealthBar.Background
		background:SetAlpha(0)
		background:ClearAllPoints()
		background:SetPoint("TOPLEFT", self.squareBG, "BOTTOMLEFT", E.mult, 6)
		background:SetPoint("BOTTOMRIGHT", self.squareBG, "BOTTOMRIGHT", -E.mult, E.mult)
		self.HealthBar.Health:SetTexture(E.media.normTex)
	end
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
end

-- ClassColored Sliders
function module:HandleSliderFrame(_, frame)
	local thumb = frame:GetThumbTexture()
	if thumb then
		local r, g, b = unpack(E.media.rgbvaluecolor)
		thumb:SetVertexColor(r, g, b, 1)
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

function module:ReskinIcon(icon, backdrop)
	assert(icon, "doesn't exist!")

	icon:SetTexCoords()

	if icon:GetDrawLayer() ~= "ARTWORK" then
		icon:SetDrawLayer("ARTWORK")
	end

	if backdrop then
		icon:CreateBackdrop()
	end
end

function module:PixelIcon(self, texture, highlight)
	if not self then
		return
	end

	self:CreateBackdrop()
	self.backdrop:SetAllPoints()
	self.Icon = self:CreateTexture(nil, "ARTWORK")
	self.Icon:SetInside(self.backdrop)
	self.Icon:SetTexCoords()
	if texture then
		local atlas = strmatch(texture, "Atlas:(.+)$")
		if atlas then
			self.Icon:SetAtlas(atlas)
		else
			self.Icon:SetTexture(texture)
		end
	end
	if highlight and type(highlight) == "boolean" then
		self:EnableMouse(true)
		self.HL = self:CreateTexture(nil, "HIGHLIGHT")
		self.HL:SetColorTexture(1, 1, 1, 0.25)
		self.HL:SetInside(self.backdrop)
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

function module:ReskinArrow(self, direction)
	self:SetSize(16, 16)
	S:HandleButton(self, true)
	self:SetDisabledTexture(E.media.normTex)

	local dis = self:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, 0.3)
	dis:SetDrawLayer("OVERLAY")
	dis:SetAllPoints()

	local tex = self:CreateTexture(nil, "ARTWORK")
	tex:SetAllPoints()
	module.SetupArrow(tex, direction)
	self.__texture = tex

	self:HookScript("OnEnter", F.Texture_OnEnter)
	self:HookScript("OnLeave", F.Texture_OnLeave)
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

function module:ReskinCollapse(self, isAtlas)
	self:SetHighlightTexture("")
	self:SetPushedTexture("")
	self:SetDisabledTexture("")

	local bg = module:CreateBDFrame(self, 0.25, true)
	bg:ClearAllPoints()
	bg:SetSize(13, 13)
	bg:SetPoint("TOPLEFT", self:GetNormalTexture())
	self.bg = bg

	self.__texture = bg:CreateTexture(nil, "OVERLAY")
	self.__texture:SetPoint("CENTER")
	self.__texture:SetSize(7, 7)
	self.__texture:SetTexture("Interface\\Buttons\\UI-PlusMinus-Buttons")
	self.__texture.DoCollapse = updateCollapseTexture

	self:HookScript("OnEnter", F.Texture_OnEnter)
	self:HookScript("OnLeave", F.Texture_OnLeave)
	if isAtlas then
		hooksecurefunc(self, "SetNormalAtlas", resetCollapseTexture)
	else
		hooksecurefunc(self, "SetNormalTexture", resetCollapseTexture)
	end
end

function module:SkinPanel(panel)
	panel.tex = panel:CreateTexture(nil, "ARTWORK")
	panel.tex:SetAllPoints()
	panel.tex:SetTexture(E.media.blankTex)
	panel.tex:SetGradient("VERTICAL", rgbValueColorR, rgbValueColorG, rgbValueColorB)
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
	_G["ElvUIMoverNudgeWindowUpButton"].img:SetRotation(module.ArrowRotation["UP"])
	_G["ElvUIMoverNudgeWindowDownButton"].img:SetRotation(module.ArrowRotation["DOWN"])
	_G["ElvUIMoverNudgeWindowLeftButton"].img:SetRotation(module.ArrowRotation["LEFT"])
	_G["ElvUIMoverNudgeWindowRightButton"].img:SetRotation(module.ArrowRotation["RIGHT"])
end

hooksecurefunc(E, "CreateMoverPopup", module.ApplyConfigArrows)

---Reposition frame with parameters
---@param frame any The frame to reposition
---@param target any The frame relative to
---@param border number Border size
---@param top number Top offset
---@param bottom number Bottom offset
---@param left number Left offset
---@param right number Right offset
function module:Reposition(frame, target, border, top, bottom, left, right)
	frame:ClearAllPoints()
	frame:Point("TOPLEFT", target, "TOPLEFT", -left - border, top + border)
	frame:Point("TOPRIGHT", target, "TOPRIGHT", right + border, top + border)
	frame:Point("BOTTOMLEFT", target, "BOTTOMLEFT", -left - border, -bottom - border)
	frame:Point("BOTTOMRIGHT", target, "BOTTOMRIGHT", right + border, -bottom - border)
end

--Proxy function to call ElvUI Skins functions
---@param method string The function name in ElvUI Skins
---@param frame any The frame to pass to the function
---@param ... any Additional arguments to pass
function module:Proxy(method, frame, ...)
	if not frame then
		F.Developer.ThrowError(
			"Failed to proxy function: frame is nil.",
			"\n funcName:",
			method,
			"\n frame:",
			frame.GetDebugName and frame:GetDebugName() or tostring(frame)
		)
		return
	end

	if not S[method] then
		F.Developer.ThrowError(
			format("Proxy: %s is not exist in ElvUI Skins", method),
			"\n frame:",
			frame.GetDebugName and frame:GetDebugName() or tostring(frame)
		)
		return
	end

	S[method](S, frame, ...)
end

function module:ReskinTab(tab)
	if not tab then
		return
	end

	S:HandleTab(tab)
	WS:CreateBackdropShadow(tab)
end

function module:ReskinIconButton(button, icon, size, rotate)
	button:StripTextures()
	button.Icon = button:CreateTexture(nil, "ARTWORK")
	button.Icon:SetTexture(icon)
	button.Icon:Size(size, size)
	button.Icon:Point("CENTER")
	if rotate then
		button.Icon:SetRotation(rotate)
	end

	button:HookScript("OnEnter", function(self)
		self.Icon:SetVertexColor(E.media.rgbvaluecolor.r, E.media.rgbvaluecolor.g, E.media.rgbvaluecolor.b)
	end)

	button:HookScript("OnLeave", function(self)
		self.Icon:SetVertexColor(1, 1, 1)
	end)
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

function module:SetBorderColor()
	self:SetBackdropBorderColor(0, 0, 0, 1)
end

--[[----------------------------------
--	GUI Functions
--]]
----------------------------------
do
	function module:CreateButton(width, height, text, fontSize, outline)
		local bu = CreateFrame("Button", nil, self, "BackdropTemplate")
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

	function module:CreateCheckBox()
		local cb = CreateFrame("CheckButton", nil, self, "InterfaceOptionsBaseCheckButtonTemplate")
		cb:SetScript("OnClick", nil) -- reset onclick handler
		S:HandleCheckBox(cb)

		cb.Type = "CheckBox"
		return cb
	end

	local function editBoxClearFocus(self)
		self:ClearFocus()
	end

	function module:CreateEditBox(width, height)
		local eb = CreateFrame("EditBox", nil, self)
		eb:SetSize(width, height)
		eb:SetAutoFocus(false)
		eb:SetTextInsets(5, 5, 0, 0)
		eb:FontTemplate(nil, E.db.general.fontSize + 2)
		eb:CreateBackdrop("Transparent")
		eb.backdrop:SetAllPoints()
		eb:SetScript("OnEscapePressed", editBoxClearFocus)
		eb:SetScript("OnEnterPressed", editBoxClearFocus)

		eb.Type = "EditBox"
		return eb
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

-- Modified from ElvUI WorldMap skin
function module:ReskinWorldMapTab(tab)
	tab:CreateBackdrop()
	tab:Size(30, 40)

	if tab.Icon then
		F.InternalizeMethod(tab.Icon, "SetPoint", true)
		F.InternalizeMethod(tab.Icon, "ClearAllPoints", true)
		F.CallMethod(tab.Icon, "ClearAllPoints")
		F.CallMethod(tab.Icon, "SetPoint", "CENTER")
	end

	if tab.Background then
		tab.Background:SetAlpha(0)
	end

	if tab.SelectedTexture then
		tab.SelectedTexture:SetDrawLayer("ARTWORK")
		tab.SelectedTexture:SetColorTexture(1, 0.82, 0, 0.3)
		tab.SelectedTexture:SetAllPoints()
	end

	for _, region in next, { tab:GetRegions() } do
		if region:IsObjectType("Texture") and region:GetAtlas() == "QuestLog-Tab-side-Glow-hover" then
			region:SetColorTexture(1, 1, 1, 0.3)
			region:SetAllPoints()
		end
	end

	if tab.backdrop then
		WS:CreateBackdropShadow(tab)
		tab.backdrop:SetTemplate("Transparent")
	end
end
