local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')
local LSM = E.LSM or E.Libs.LSM

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
	['UP'] = 3.14,
	['DOWN'] = 0,
	['LEFT'] = -1.57,
	['RIGHT'] = 1.57,
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
		"TopRightCorner"
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

function module:CreateShadow(frame, size, r, g, b, force)
	if not force then
		if not E.private.mui.skins.enable or not E.private.mui.skins.shadow.enable then
			return
		end
	end

	if not frame or frame.__MERshadow or frame.MERshadow and frame.shadow.__MER then
		return
	end

	if frame:GetObjectType() == "Texture" then
		frame = frame:GetParent()
	end

	r = r or E.private.mui.skins.shadow.color.r or 0
	g = g or E.private.mui.skins.shadow.color.g or 0
	b = b or E.private.mui.skins.shadow.color.b or 0

	size = size or 3
	size = size + E.private.mui.skins.shadow.increasedSize or 0

	local shadow = CreateFrame("Frame", nil, frame, "BackdropTemplate")
	shadow:SetFrameStrata(frame:GetFrameStrata())
	shadow:SetFrameLevel(frame:GetFrameLevel() or 1)
	shadow:SetOutside(frame, size, size)
	shadow:SetBackdrop({ edgeFile = LSM:Fetch("border", "ElvUI GlowBorder"), edgeSize = E:Scale(size + 1) })
	shadow:SetBackdropColor(r, g, b, 0)
	shadow:SetBackdropBorderColor(r, g, b, 0.618)
	shadow.__MER = true

	frame.MERshadow = shadow
	frame.__MERshadow = 1
end

function module:CreateLowerShadow(frame, force)
	if not force then
		if not E.private.mui.skins.enable or not E.private.mui.skins.shadow.enable then
			return
		end
	end

	module:CreateShadow(frame)
	if frame.shadow and frame.SetFrameStrata and frame.SetFrameLevel then
		local function refreshFrameLevel()
			local parentFrameLevel = frame:GetFrameLevel()
			frame.shadow:SetFrameLevel(parentFrameLevel > 0 and parentFrameLevel - 1 or 0)
		end

		-- avoid the shadow level is reset when the frame strata/level is changed
		hooksecurefunc(frame, "SetFrameStrata", refreshFrameLevel)
		hooksecurefunc(frame, "SetFrameLevel", refreshFrameLevel)
	end
end

function module:UpdateShadowColor(shadow, r, g, b)
	if not shadow or not shadow.__MER then
		return
	end

	r = r or E.private.mui.skins.shadow.color.r or 0
	g = g or E.private.mui.skins.shadow.color.g or 0
	b = b or E.private.mui.skins.shadow.color.b or 0

	shadow:SetBackdropColor(r, g, b, 0)
	shadow:SetBackdropBorderColor(r, g, b, 0.618)
end

do
	local function colorCallback(shadow, r, g, b)
		if not r or not g or not b then
			return
		end

		if r == E.db.general.bordercolor.r and g == E.db.general.bordercolor.g and b == E.db.general.bordercolor.b then
			module:UpdateShadowColor(shadow)
		else
			module:UpdateShadowColor(shadow, r, g, b)
		end
	end

	function module:BindShadowColorWithBorder(shadow, borderParent)
		if not shadow or not shadow.__MER or not borderParent or not borderParent.SetBackdropBorderColor then
			return
		end

		hooksecurefunc(borderParent, "SetBackdropBorderColor", function(_, ...)
			colorCallback(shadow, ...)
		end)

		colorCallback(shadow, borderParent:GetBackdropBorderColor())
	end
end

do
	local function createBackdropShadow(frame, defaultTemplate)
		if not E.private.mui.skins.enable or not E.private.mui.skins.shadow.enable then
			return
		end

		if not defaultTemplate then
			frame.backdrop:SetTemplate("Transparent")
		end

		module:CreateShadow(frame.backdrop)

		if frame.backdrop.MERshadow.__MER then
			frame.__MERshadow = frame.backdrop.__MERshadow + 1
		end
	end

	--[[
		Create a shadow for the backdrop of the frame
		@param {frame} frame
		@param {string} template
	]]
	function module:CreateBackdropShadow(frame, template)
		if not frame or frame.__MERshadow then
			return
		end

		if frame.backdrop then
			createBackdropShadow(frame, template)
		elseif frame.CreateBackdrop and not self:IsHooked(frame, "CreateBackdrop") then
			self:SecureHook(frame, "CreateBackdrop", function(...)
				if self:IsHooked(frame, "CreateBackdrop") then
					self:Unhook(frame, "CreateBackdrop")
				end
				createBackdropShadow(...)
			end)
		end
	end

	--[[
	Create shadow of backdrop that created by ElvUI skin function
	The function is automatically repeat several times for waiting ElvUI done
		the modifying/creating of backdrop
	!!! It only check for 2 seconds (20 times in total)
	@param {object} frame
	@param {string} [tried=20] time
]]
	function module:TryCreateBackdropShadow(frame, tried)
		if not frame or frame.__MERshadow then
			return
		end

		tried = tried or 20

		if frame.backdrop then
			createBackdropShadow(frame)
		else
			if tried >= 0 then
				E:Delay(0.1, self.TryCreateBackdropShadow, self, frame, tried - 1)
			end
		end
	end
end

function module:CreateShadowModule(frame)
	if not frame then return end

	if E.private.mui.skins.enable and E.private.mui.skins.shadow.enable then
		module:CreateShadow(frame)
	end
end

function module:CreateTex(f)
	assert(f, "doesn't exist!")

	if f.__bgTex then return end

	local frame = f
	if f:IsObjectType("Texture") then frame = f:GetParent() end

	local tex = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
	tex:SetAllPoints(f)
	tex:SetTexture(MER.Media.Textures.emptyTex, true, true)
	tex:SetHorizTile(true)
	tex:SetVertTile(true)
	tex:SetBlendMode("ADD")

	f.__bgTex = tex
end

-- Backdrop shadow
local shadowBackdrop = { edgeFile = MER.Media.Textures.glowTex }
function module:CreateSD(f, size, override)
	assert(f, "doesn't exist!")

	if f.__SDshadow then return end

	local frame = f
	if f:IsObjectType("Texture") then
		frame = f:GetParent()
	end

	shadowBackdrop.edgeSize = size or 5
	f.__SDshadow = CreateFrame("Frame", nil, frame, "BackdropTemplate")
	f.__SDshadow:SetOutside(f, size or 4, size or 4)
	f.__SDshadow:SetBackdrop(shadowBackdrop)
	f.__SDshadow:SetBackdropBorderColor(0, 0, 0, size and 1 or .4)
	f.__SDshadow:SetFrameLevel(1)

	return f.__SDshadow
end

function module:CreateBG(frame)
	assert(frame, "doesn't exist!")

	local f = frame
	if frame:IsObjectType('Texture') then f = frame:GetParent() end

	local bg = f:CreateTexture(nil, "BACKGROUND")
	bg:Point("TOPLEFT", frame, -E.mult, E.mult)
	bg:Point("BOTTOMRIGHT", frame, E.mult, -E.mult)
	bg:SetTexture(E.media.normTex)
	bg:SetVertexColor(0, 0, 0, 1)

	return bg
end

-- Gradient Texture
function module:CreateGradient(f)
	assert(f, "doesn't exist!")

	local tex = f:CreateTexture(nil, "BORDER")
	tex:SetInside(f)
	tex:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\gradient.tga]])
	tex:SetVertexColor(.3, .3, .3, .15)

	return tex
end

function module:CreateBackdrop(frame)
	if frame.backdrop then return end

	local parent = frame.IsObjectType and frame:IsObjectType("Texture") and frame:GetParent() or frame

	local backdrop = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	backdrop:SetOutside(frame)
	backdrop:SetTemplate("Transparent")

	if (parent:GetFrameLevel() - 1) >= 0 then
		backdrop:SetFrameLevel(parent:GetFrameLevel() - 1)
	else
		backdrop:SetFrameLevel(0)
	end

	frame.backdrop = backdrop
end

function module:CreateBDFrame(f)
	assert(f, "doesn't exist!")

	local parent = f.IsObjectType and f:IsObjectType('Texture') and f:GetParent() or f

	local bg = CreateFrame('Frame', nil, parent, 'BackdropTemplate')
	bg:SetOutside(f)
	if (parent:GetFrameLevel() - 1) >= 0 then
		bg:SetFrameLevel(parent:GetFrameLevel() - 1)
	else
		bg:SetFrameLevel(0)
	end
	bg:SetTemplate('Transparent')

	return bg
end

function module:SetBD(f, x, y, x2, y2, gradient)
	assert(f, "doesn't exist!")

	local bg = module:CreateBDFrame(f)
	if x then
		bg:SetPoint("TOPLEFT", f, x, y)
		bg:SetPoint("BOTTOMRIGHT", f, x2, y2)
	end
	module:CreateSD(bg)
	module:CreateTex(bg)

	if gradient then
		module:CreateGradient(bg)
	end

	return bg
end

-- ClassColored ScrollBars
do
	local function GrabScrollBarElement(frame, element)
		local FrameName = frame:GetDebugName()
		return frame[element] or FrameName and (_G[FrameName .. element] or strfind(FrameName, element)) or nil
	end

	function module:HandleScrollBar(_, frame)
		local Thumb = GrabScrollBarElement(frame, 'ThumbTexture') or GrabScrollBarElement(frame, 'thumbTexture') or
			frame.GetThumbTexture and frame:GetThumbTexture()

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
	if self.backdrop then self = self.backdrop end

	self:SetBackdropColor(rgbValueColorR, rgbValueColorG, rgbValueColorB, .3)
	self:SetBackdropBorderColor(rgbValueColorR, rgbValueColorG, rgbValueColorB)
end

function module:ClearButton()
	if self.backdrop then self = self.backdrop end

	self:SetBackdropColor(0, 0, 0, 0)

	if self.isUnitFrameElement then
		self:SetBackdropBorderColor(unitFrameColorR, unitFrameColorG, unitFrameColorB)
	else
		self:SetBackdropBorderColor(bordercolorr, bordercolorg, bordercolorb)
	end
end

function module:ReskinIcon(icon, backdrop)
	assert(icon, "doesn't exist!")

	icon:SetTexCoord(unpack(E.TexCoords))

	if icon:GetDrawLayer() ~= 'ARTWORK' then
		icon:SetDrawLayer("ARTWORK")
	end

	if backdrop then
		icon:CreateBackdrop()
	end
end

function module:PixelIcon(self, texture, highlight)
	if not self then return end

	self:CreateBackdrop()
	self.backdrop:SetAllPoints()
	self.Icon = self:CreateTexture(nil, "ARTWORK")
	self.Icon:SetInside(self.backdrop)
	self.Icon:SetTexCoord(unpack(E.TexCoords))
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
		self.HL:SetColorTexture(1, 1, 1, .25)
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
function module:SetupArrow(self, direction)
	if not self then return end

	self:SetTexture(MER.Media.Textures.arrowUp)
	self:SetRotation(rad(arrowDegree[direction]))
end

function module:ReskinArrow(self, direction)
	self:SetSize(16, 16)
	S:HandleButton(self, true)
	self:SetDisabledTexture(E.media.normTex)

	local dis = self:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .3)
	dis:SetDrawLayer("OVERLAY")
	dis:SetAllPoints()

	local tex = self:CreateTexture(nil, "ARTWORK")
	tex:SetAllPoints()
	-- module.SetupArrow(tex, direction)
	self.__texture = tex

	self:HookScript("OnEnter", F.Texture_OnEnter)
	self:HookScript("OnLeave", F.Texture_OnLeave)
end

-- Handle collapse
local function updateCollapseTexture(texture, collapsed)
	if collapsed then
		texture:SetTexCoord(0, .4375, 0, .4375)
	else
		texture:SetTexCoord(.5625, 1, 0, .4375)
	end
end

local function resetCollapseTexture(self, texture)
	if self.settingTexture then return end
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

	local bg = module:CreateBDFrame(self, .25, true)
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
	module:CreateShadow(panel)
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
		button.img = button:CreateTexture(nil, 'ARTWORK')
		button.img:SetTexture('Interface\\AddOns\\ElvUI_MerathilisUI\\Media\\Textures\\arrow')
		button.img:SetSize(12, 12)
		button.img:Point('CENTER')
		button.img:SetVertexColor(1, 1, 1, 1)

		button:HookScript('OnMouseDown', function(btn)
			if btn:IsEnabled() then
				btn.img:Point("CENTER", -1, -1);
			end
		end)

		button:HookScript('OnMouseUp', function(btn)
			btn.img:Point("CENTER", 0, 0);
		end)
	end
end

function module:ApplyConfigArrows()
	for _, btn in pairs(buttons) do
		replaceConfigArrows(_G[btn])
	end

	-- Apply the rotation
	_G["ElvUIMoverNudgeWindowUpButton"].img:SetRotation(module.ArrowRotation['UP'])
	_G["ElvUIMoverNudgeWindowDownButton"].img:SetRotation(module.ArrowRotation['DOWN'])
	_G["ElvUIMoverNudgeWindowLeftButton"].img:SetRotation(module.ArrowRotation['LEFT'])
	_G["ElvUIMoverNudgeWindowRightButton"].img:SetRotation(module.ArrowRotation['RIGHT'])
end

hooksecurefunc(E, "CreateMoverPopup", module.ApplyConfigArrows)

function module:Reposition(frame, target, border, top, bottom, left, right)
	frame:ClearAllPoints()
	frame:SetPoint("TOPLEFT", target, "TOPLEFT", -left - border, top + border)
	frame:SetPoint("TOPRIGHT", target, "TOPRIGHT", right + border, top + border)
	frame:SetPoint("BOTTOMLEFT", target, "BOTTOMLEFT", -left - border, -bottom - border)
	frame:SetPoint("BOTTOMRIGHT", target, "BOTTOMRIGHT", right + border, -bottom - border)
end

function module:ReskinTab(tab)
	if not tab then
		return
	end

	if tab.backdrop then
		tab.backdrop:Styling()
	end
	self:CreateBackdropShadow(tab)
end

function module:ReskinAS(AS)
	-- Reskin AddOnSkins
	function AS:SkinFrame(frame, template, override, kill)
		local name = frame and frame.GetName and frame:GetName()
		local insetFrame = name and _G[name .. 'Inset'] or frame.Inset
		local closeButton = name and _G[name .. 'CloseButton'] or frame.CloseButton

		if not override then
			AS:StripTextures(frame, kill)
		end

		AS:SetTemplate(frame, template)
		module:CreateShadow(frame)

		if insetFrame then
			AS:SkinFrame(insetFrame)
		end

		if closeButton then
			AS:SkinCloseButton(closeButton)
		end
	end

	function AS:SkinBackdropFrame(frame, template, override, kill)
		local name = frame and frame.GetName and frame:GetName()
		local insetFrame = name and _G[name .. 'Inset'] or frame.Inset
		local closeButton = name and _G[name .. 'CloseButton'] or frame.CloseButton

		if not override then
			AS:StripTextures(frame, kill)
		end

		AS:CreateBackdrop(frame, template)
		AS:SetOutside(frame.Backdrop)

		if insetFrame then
			AS:SkinFrame(insetFrame)
		end

		if closeButton then
			AS:SkinCloseButton(closeButton)
		end

		if frame.Backdrop then
			module:CreateShadow(frame.Backdrop)
		end
	end

	function AS:SkinTab(Tab, Strip)
		if Tab.__MERSkin then return end
		local TabName = Tab:GetName()

		if TabName then
			for _, Region in pairs(AS.Blizzard.Regions) do
				if _G[TabName .. Region] then
					_G[TabName .. Region]:SetTexture(nil)
				end
			end
		end

		for _, Region in pairs(AS.Blizzard.Regions) do
			if Tab[Region] then
				Tab[Region]:SetAlpha(0)
			end
		end

		if Tab.GetHighlightTexture and Tab:GetHighlightTexture() then
			Tab:GetHighlightTexture():SetTexture(nil)
		else
			Strip = true
		end

		if Strip then
			AS:StripTextures(Tab)
		end

		AS:CreateBackdrop(Tab, 'Transparent')

		if AS:CheckAddOn("ElvUI") and AS:CheckOption("ElvUISkinModule") then
			-- Check if ElvUI already provides the backdrop. Otherwise we have two backdrops (e.g. Auctionhouse)
			if Tab.backdrop then
				Tab.Backdrop:Hide()
			else
				AS:SetTemplate(Tab.Backdrop, "Transparent") -- Set it to transparent
				Tab.Backdrop:Styling()
			end
		end

		Tab.Backdrop:Point("TOPLEFT", 10, AS.PixelPerfect and -1 or -3)
		Tab.Backdrop:Point("BOTTOMRIGHT", -10, 3)

		Tab.__MERSkin = true
	end

	function AS:SkinButton(Button, Strip)
		if Button.__MERSkin then return end

		local ButtonName = Button.GetName and Button:GetName()
		local foundArrow

		if Button.Icon then
			local Texture = Button.Icon:GetTexture()
			if Texture and (type(Texture) == 'string' and strfind(Texture, [[Interface\ChatFrame\ChatFrameExpandArrow]])) then
				foundArrow = true
			end
		end

		if Strip then
			AS:StripTextures(Button)
		end

		for _, Region in pairs(AS.Blizzard.Regions) do
			Region = ButtonName and _G[ButtonName .. Region] or Button[Region]
			if Region then
				Region:SetAlpha(0)
			end
		end

		if foundArrow then
			Button.Icon:SetTexture([[Interface\AddOns\AddOnSkins\Media\Textures\Arrow]])
			Button.Icon:SetSnapToPixelGrid(false)
			Button.Icon:SetTexelSnappingBias(0)
			Button.Icon:SetVertexColor(1, 1, 1, 1)
			Button.Icon:SetRotation(AS.ArrowRotation['right'])
		end

		if Button.SetNormalTexture then Button:SetNormalTexture('') end
		if Button.SetHighlightTexture then Button:SetHighlightTexture('') end
		if Button.SetPushedTexture then Button:SetPushedTexture('') end
		if Button.SetDisabledTexture then Button:SetDisabledTexture('') end

		AS:SetTemplate(Button, 'Transparent')

		if Button.GetFontString and Button:GetFontString() ~= nil then
			if Button:IsEnabled() then
				Button:GetFontString():SetTextColor(1, 1, 1)
			else
				Button:GetFontString():SetTextColor(.5, .5, .5)
			end
		end

		Button:HookScript("OnEnable", function(self)
			if self.GetFontString and self:GetFontString() ~= nil then
				self:GetFontString():SetTextColor(1, 1, 1)
			end
		end)
		Button:HookScript("OnDisable", function(self)
			if self.GetFontString and self:GetFontString() ~= nil then
				self:GetFontString():SetTextColor(.5, .5, .5)
			end
		end)
	end
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
	self:SetBackdropBorderColor(0, 0, 0)
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
		eb:CreateBackdrop('Transparent')
		eb.backdrop:SetAllPoints()
		module:CreateGradient(eb.backdrop)
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
	self.backdrop:SetBackdropColor(0, 0, 0, .45)
end

local function Menu_OnMouseDown(self)
	self.backdrop:SetBackdropColor(F.r, F.g, F.b, .25)
end

function module:ReskinMenuButton(button)
	assert(button, "doesn't exist!")

	button:StripTextures()

	if not button.backdrop then
		button:CreateBackdrop('Transparent')
		button.backdrop:Styling()
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
		close:SetScale(.001)
		close:SetAlpha(0)
		open:SetScale(.001)
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
