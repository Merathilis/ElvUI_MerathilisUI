local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G
local assert, pairs, select, unpack, type = assert, pairs, select, unpack, type
local find, lower, strfind = string.find, string.lower, strfind
local tinsert = table.insert

local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local IsAddOnLoaded = IsAddOnLoaded
local hooksecurefunc = hooksecurefunc
local RaiseFrameLevel = RaiseFrameLevel
local LowerFrameLevel = LowerFrameLevel

local alpha
local backdropcolorr, backdropcolorg, backdropcolorb
local backdropfadecolorr, backdropfadecolorg, backdropfadecolorb
local unitFrameColorR, unitFrameColorG, unitFrameColorB
local rgbValueColorR, rgbValueColorG, rgbValueColorB, rgbValueColorA
local bordercolorr, bordercolorg, bordercolorb

MERS.addonsToLoad = {}
MERS.nonAddonsToLoad = {}
MERS.updateProfile = {}
MERS.aceWidgets = {}
MERS.enteredLoad = {}

MERS.NORMAL_QUEST_DISPLAY = "|cffffffff%s|r"
MERS.TRIVIAL_QUEST_DISPLAY = TRIVIAL_QUEST_DISPLAY:gsub("000000", "ffffff")
TEXTURE_ITEM_QUEST_BANG = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\UI-Icon-QuestBang]]

local buttons = {
	"UI-Panel-MinimizeButton-Disabled",
	"UI-Panel-MinimizeButton-Up",
	"UI-Panel-SmallerButton-Up",
	"UI-Panel-BiggerButton-Up",
}

-- Depends on the arrow texture to be down by default.
MERS.ArrowRotation = {
	['UP'] = 3.14,
	['DOWN'] = 0,
	['LEFT'] = -1.57,
	['RIGHT'] = 1.57,
}

-- Create shadow for textures
function MERS:CreateSD(f, m, s, n)
	if f.Shadow then return end

	local frame = f
	if f:GetObjectType() == "Texture" then
		frame = f:GetParent()
	end

	local lvl = frame:GetFrameLevel()
	f.Shadow = CreateFrame("Frame", nil, frame)
	f.Shadow:SetPoint("TOPLEFT", f, -m, m)
	f.Shadow:SetPoint("BOTTOMRIGHT", f, m, -m)
	f.Shadow:CreateBackdrop()
	f.Shadow.backdrop:SetBackdropBorderColor(0, 0, 0, 1)
	f.Shadow.backdrop:SetFrameLevel(n or lvl)

	return f.Shadow
end

function MERS:CreateBG(frame)
	assert(frame, "doesn't exist!")

	local f = frame
	if frame:IsObjectType('Texture') then f = frame:GetParent() end

	local bg = f:CreateTexture(nil, "BACKGROUND")
	bg:Point("TOPLEFT", frame, -E.mult, E.mult)
	bg:Point("BOTTOMRIGHT", frame, E.mult, -E.mult)
	bg:SetTexture(E.media.blankTex)
	bg:SetVertexColor(0, 0, 0)

	return bg
end

-- Gradient Texture
function MERS:CreateGradient(f)
	assert(f, "doesn't exist!")

	local tex = f:CreateTexture(nil, "BORDER")
	tex:SetInside()
	tex:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Textures\gradient.tga]])
	tex:SetVertexColor(.3, .3, .3, .15)

	return tex
end

function MERS:CreateBackdrop(frame)
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

function MERS:CreateBDFrame(f, a)
	assert(f, "doesn't exist!")

	local parent = f.IsObjectType and f:IsObjectType("Texture") and f:GetParent() or f

	local bg = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	bg:SetOutside(f)
	if (parent:GetFrameLevel() - 1) >= 0 then
		bg:SetFrameLevel(parent:GetFrameLevel() - 1)
	else
		bg:SetFrameLevel(0)
	end
	MERS:CreateBD(bg, a or .5)

	return bg
end

function MERS:CreateBD(f, a)
	assert(f, "doesn't exist!")

	f:CreateBackdrop()
	f.backdrop:SetBackdropColor(backdropfadecolorr, backdropfadecolorg, backdropfadecolorb, a or alpha)
	f.backdrop:SetBackdropBorderColor(bordercolorr, bordercolorg, bordercolorb)
end

-- ClassColored ScrollBars
do
	local function GrabScrollBarElement(frame, element)
		local FrameName = frame:GetDebugName()
		return frame[element] or FrameName and (_G[FrameName..element] or strfind(FrameName, element)) or nil
	end

	function MERS:ReskinScrollBar(frame, thumbTrimY, thumbTrimX)
		local parent = frame:GetParent()

		local Thumb = GrabScrollBarElement(frame, 'ThumbTexture') or GrabScrollBarElement(frame, 'thumbTexture') or frame.GetThumbTexture and frame:GetThumbTexture()

		if Thumb and Thumb.backdrop then
			local r, g, b = unpack(E.media.rgbvaluecolor)
			Thumb.backdrop:SetBackdropColor(r, g, b)
		end
	end
end

-- ClassColored Sliders
function MERS:ReskinSliderFrame(frame)
	local thumb = frame:GetThumbTexture()
	if thumb then
		local r, g, b = unpack(E.media.rgbvaluecolor)
		thumb:SetVertexColor(r, g, b)
	end
end

-- Overwrite ElvUI Tabs function to be transparent
function MERS:ReskinTab(tab)
	if not tab then return end

	if tab.backdrop then
		tab.backdrop:SetTemplate("Transparent")
		tab.backdrop:Styling()
	end

	MER:CreateBackdropShadow(tab)
end

function MERS:ColorButton()
	if self.backdrop then self = self.backdrop end

	self:SetBackdropColor(rgbValueColorR, rgbValueColorG, rgbValueColorB, .3)
	self:SetBackdropBorderColor(rgbValueColorR, rgbValueColorG, rgbValueColorB)
end

function MERS:ClearButton()
	if self.backdrop then self = self.backdrop end

	self:SetBackdropColor(0, 0, 0, 0)

	if self.isUnitFrameElement then
		self:SetBackdropBorderColor(unitFrameColorR, unitFrameColorG, unitFrameColorB)
	else
		self:SetBackdropBorderColor(bordercolorr, bordercolorg, bordercolorb)
	end
end

function MERS:OnEnter()
	if self:IsEnabled() then
		if self.backdrop then self = self.backdrop end
		if self.SetBackdropBorderColor then
			self:SetBackdropBorderColor(rgbValueColorR, rgbValueColorG, rgbValueColorB)
			self:SetBackdropColor(rgbValueColorR, rgbValueColorG, rgbValueColorB, rgbValueColorA or .75)

			if not self.wasRaised then
				RaiseFrameLevel(self)
				self.wasRaised = true
			end
		end
	end
end

function MERS:OnLeave()
	if self:IsEnabled() then
		if self.backdrop then self = self.backdrop end
		if self.SetBackdropBorderColor then
			self:SetBackdropBorderColor(bordercolorr, bordercolorg, bordercolorb)
			self:SetBackdropColor(backdropfadecolorr, backdropfadecolorg, backdropfadecolorb, alpha)

			if self.wasRaised then
				LowerFrameLevel(self)
				self.wasRaised = nil
			end
		end
	end
end

-- Buttons
function MERS:Reskin(button, strip, isDecline, noStyle, createBackdrop, template, noGlossTex, overrideTex, frameLevel, defaultTemplate, noGradient)
	assert(button, "doesn't exist!")

	if not button or button.IsSkinned then return end
	if strip then button:StripTextures() end

	if button.Icon then
		local Texture = button.Icon:GetTexture()
		if Texture and strfind(Texture, [[Interface\ChatFrame\ChatFrameExpandArrow]]) then
			button.Icon:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Textures\Arrow]])
			button.Icon:SetVertexColor(1, 1, 1)
			button.Icon:SetRotation(MERS.ArrowRotation['RIGHT'])
		end
	end

	if isDecline then
		if button.Icon then
			button.Icon:SetTexture(E.Media.Textures.Close)
		end
	end

	if not noStyle then
		if createBackdrop then
			button:CreateBackdrop(defaultTemplate and template or 'Transparent', not noGlossTex, nil, nil, nil, nil, true, frameLevel)
		else
			button:SetTemplate(defaultTemplate and template or 'Transparent', not noGlossTex)
		end

		button:HookScript('OnEnter', MERS.OnEnter)
		button:HookScript('OnLeave', MERS.OnLeave)
	end

	if not noGradient then
		MERS:CreateGradient(button)
	end

	button.IsSkinned = true
end

function MERS:StyleButton(button)
	if button.isStyled then return end

	if button.SetHighlightTexture then
		button:SetHighlightTexture(E["media"].blankTex)
		button:GetHighlightTexture():SetVertexColor(1, 1, 1, .2)
		button:GetHighlightTexture():SetInside()
		button.SetHighlightTexture = E.noop
	end

	if button.SetPushedTexture then
		button:SetPushedTexture(E["media"].blankTex)
		button:GetPushedTexture():SetVertexColor(.9, .8, .1, .5)
		button:GetPushedTexture():SetInside()
		button.SetPushedTexture = E.noop
	end

	if button.GetCheckedTexture then
		button:SetPushedTexture(E["media"].blankTex)
		button:GetCheckedTexture():SetVertexColor(0, 1, 0, .5)
		button:GetCheckedTexture():SetInside()
		button.GetCheckedTexture = E.noop
	end

	local Cooldown = button:GetName() and _G[button:GetName()..'Cooldown'] or button.Cooldown or button.cooldown or nil

	if Cooldown then
		Cooldown:SetInside()
		if Cooldown.SetSwipeColor then
			Cooldown:SetSwipeColor(0, 0, 0, 1)
		end
	end

	button.isStyled = true
end

function MERS:ReskinIcon(icon, backdrop)
	assert(icon, "doesn't exist!")

	icon:SetTexCoord(unpack(E.TexCoords))

	if icon:GetDrawLayer() ~= 'ARTWORK' then
		icon:SetDrawLayer("ARTWORK")
	end

	if backdrop then
		MERS:CreateBackdrop(icon)
	end
end

function MERS:SkinPanel(panel)
	panel.tex = panel:CreateTexture(nil, "ARTWORK")
	panel.tex:SetAllPoints()
	panel.tex:SetTexture(E.media.blankTex)
	panel.tex:SetGradient("VERTICAL", rgbValueColorR, rgbValueColorG, rgbValueColorB)
	MER:CreateShadow(panel)
end

function MERS:ReskinGarrisonPortrait(self)
	self.Portrait:ClearAllPoints()
	self.Portrait:SetPoint("TOPLEFT", 4, -4)
	self.PortraitRing:Hide()
	self.PortraitRingQuality:SetTexture("")
	if self.Highlight then self.Highlight:Hide() end

	self.LevelBorder:SetScale(.0001)
	self.Level:ClearAllPoints()
	self.Level:SetPoint("BOTTOM", self, 0, 12)

	self.squareBG = MERS:CreateBDFrame(self, 1)
	self.squareBG:SetFrameLevel(self:GetFrameLevel())
	self.squareBG:SetPoint("TOPLEFT", 3, -3)
	self.squareBG:SetPoint("BOTTOMRIGHT", -3, 11)

	if self.PortraitRingCover then
		self.PortraitRingCover:SetColorTexture(0, 0, 0)
		self.PortraitRingCover:SetAllPoints(self.squareBG)
	end

	if self.Empty then
		self.Empty:SetColorTexture(0, 0, 0)
		self.Empty:SetAllPoints(self.Portrait)
	end
end

local buttons = {
	"ElvUIMoverNudgeWindowUpButton",
	"ElvUIMoverNudgeWindowDownButton",
	"ElvUIMoverNudgeWindowLeftButton",
	"ElvUIMoverNudgeWindowRightButton",
}

local function replaceConfigArrows(button)
	-- remove the default icons
	local tex = _G[button:GetName().."Icon"]
	if tex then
		tex:SetTexture(nil)
	end

	-- add the new icon
	if not button.img then
		button.img = button:CreateTexture(nil, 'ARTWORK')
		button.img:SetTexture('Interface\\AddOns\\ElvUI_MerathilisUI\\Core\\Media\\Textures\\arrow')
		button.img:SetSize(12, 12)
		button.img:Point('CENTER')
		button.img:SetVertexColor(1, 1, 1)

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

function MERS:ApplyConfigArrows()
	for _, btn in pairs(buttons) do
		replaceConfigArrows(_G[btn])
	end

	-- Apply the rotation
	_G["ElvUIMoverNudgeWindowUpButton"].img:SetRotation(MERS.ArrowRotation['UP'])
	_G["ElvUIMoverNudgeWindowDownButton"].img:SetRotation(MERS.ArrowRotation['DOWN'])
	_G["ElvUIMoverNudgeWindowLeftButton"].img:SetRotation(MERS.ArrowRotation['LEFT'])
	_G["ElvUIMoverNudgeWindowRightButton"].img:SetRotation(MERS.ArrowRotation['RIGHT'])

end
hooksecurefunc(E, "CreateMoverPopup", MERS.ApplyConfigArrows)

function MERS:ReskinAS(AS)
	-- Reskin AddOnSkins
	function AS:SkinFrame(frame, template, override, kill)
		local name = frame and frame.GetName and frame:GetName()
		local insetFrame = name and _G[name..'Inset'] or frame.Inset
		local closeButton = name and _G[name..'CloseButton'] or frame.CloseButton

		if not override then
			AS:StripTextures(frame, kill)
		end

		AS:SetTemplate(frame, template)
		MER:CreateShadow(frame)

		if insetFrame then
			AS:SkinFrame(insetFrame)
		end

		if closeButton then
			AS:SkinCloseButton(closeButton)
		end
	end

	function AS:SkinBackdropFrame(frame, template, override, kill)
		local name = frame and frame.GetName and frame:GetName()
		local insetFrame = name and _G[name..'Inset'] or frame.Inset
		local closeButton = name and _G[name..'CloseButton'] or frame.CloseButton

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
			MER:CreateShadow(frame.Backdrop)
		end
	end

	function AS:SkinTab(Tab, Strip)
		if Tab.isSkinned then return end
		local TabName = Tab:GetName()

		if TabName then
			for _, Region in pairs(S.Blizzard.Regions) do
				if _G[TabName..Region] then
					_G[TabName..Region]:SetTexture(nil)
				end
			end
		end

		for _, Region in pairs(S.Blizzard.Regions) do
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

		Tab.isSkinned = true
	end

	function AS:SkinButton(Button, Strip)
		if Button.isSkinned then return end

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
			Region = ButtonName and _G[ButtonName..Region] or Button[Region]
			if Region then
				Region:SetAlpha(0)
			end
		end

		if foundArrow then
			Button.Icon:SetTexture([[Interface\AddOns\AddOnSkins\Media\Textures\Arrow]])
			Button.Icon:SetSnapToPixelGrid(false)
			Button.Icon:SetTexelSnappingBias(0)
			Button.Icon:SetVertexColor(1, 1, 1)
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

		Button:HookScript("OnEnter", MERS.OnEnter)
		Button:HookScript("OnLeave", MERS.OnLeave)
	end
end

-- Replace the Recap button script re-set function
function S:UpdateRecapButton()
	if self and self.button4 and self.button4:IsEnabled() then
		self.button4:SetScript("OnEnter", MERS.ColorButton)
		self.button4:SetScript("OnLeave", MERS.ClearButton)
	end
end

--[[ HOOK TO THE UIWIDGET TYPES ]]
function MERS:ReskinSkinTextWithStateWidget(widgetFrame)
	local text = widgetFrame.Text
	if text then
		text:SetTextColor(1, 1, 1)
	end
end

-- hook the skin functions
hooksecurefunc(S, "HandleTab", MERS.ReskinTab)
hooksecurefunc(S, "HandleButton", MERS.Reskin)
hooksecurefunc(S, "HandleScrollBar", MERS.ReskinScrollBar)
hooksecurefunc(S, "HandleSliderFrame", MERS.ReskinSliderFrame)
-- New Widget Types
hooksecurefunc(S, "SkinTextWithStateWidget", MERS.ReskinSkinTextWithStateWidget)

function MERS:SetOutside(obj, anchor, xOffset, yOffset, anchor2)
	xOffset = xOffset or 1
	yOffset = yOffset or 1
	anchor = anchor or obj:GetParent()

	assert(anchor)
	if obj:GetPoint() then
		obj:ClearAllPoints()
	end

	obj:SetPoint('TOPLEFT', anchor, 'TOPLEFT', -xOffset, yOffset)
	obj:SetPoint('BOTTOMRIGHT', anchor2 or anchor, 'BOTTOMRIGHT', xOffset, -yOffset)
end

-- keep the colors updated
local function updateMedia()
	rgbValueColorR, rgbValueColorG, rgbValueColorB, rgbValueColorA = unpack(E.media.rgbvaluecolor)
	unitFrameColorR, unitFrameColorG, unitFrameColorB = unpack(E.media.unitframeBorderColor)
	backdropfadecolorr, backdropfadecolorg, backdropfadecolorb, alpha = unpack(E.media.backdropfadecolor)
	backdropcolorr, backdropcolorg, backdropcolorb = unpack(E.media.backdropcolor)
	bordercolorr, bordercolorg, bordercolorb = unpack(E.media.bordercolor)
end
hooksecurefunc(E, "UpdateMedia", updateMedia)

local function errorhandler(err)
	return _G.geterrorhandler()(err)
end

function MERS:AddCallback(name, func)
	tinsert(self.nonAddonsToLoad, func or self[name])
end

function MERS:AddCallbackForAceGUIWidget(name, func)
	self.aceWidgets[name] = func or self[name]
end

function MERS:AddCallbackForAddon(addonName, func)
	local addon = self.addonsToLoad[addonName]
	if not addon then
		self.addonsToLoad[addonName] = {}
		addon = self.addonsToLoad[addonName]
	end

	if type(func) == "string" then
		func = self[func]
	end

	tinsert(addon, func or self[addonName])
end

function MERS:AddCallbackForEnterWorld(name, func)
	tinsert(self.enteredLoad, func or self[name])
end

function MERS:PLAYER_ENTERING_WORLD()
	if not E.initialized then
		return
	end

	for index, func in next, self.enteredLoad do
		xpcall(func, errorhandler, self)
		self.enteredLoad[index] = nil
	end
end

function MERS:ADDON_LOADED(_, addonName)
	if not E.initialized then
		return
	end

	local object = self.addonsToLoad[addonName]
	if object then
		self:CallLoadedAddon(addonName, object)
	end
end

function MERS:DisableAddOnSkin(key)
	if _G.AddOnSkins then
		local AS = _G.AddOnSkins[1]
		if AS and AS.db[key] then
			AS:SetOption(key, false)
		end
	end
end

function MERS:Initialize()
	self.db = E.private.muiSkins

	updateMedia()
	self:StyleElvUIConfig()

	if IsAddOnLoaded("AddOnSkins") then
		if AddOnSkins then
			MERS:ReskinAS(unpack(AddOnSkins))
		end
	end

	for index, func in next, self.nonAddonsToLoad do
		xpcall(func, errorhandler, self)
		self.nonAddonsToLoad[index] = nil
	end

	for addonName, object in pairs(self.addonsToLoad) do
		local isLoaded, isFinished = IsAddOnLoaded(addonName)
		if isLoaded and isFinished then
			self:CallLoadedAddon(addonName, object)
		end
	end
end

MERS:RegisterEvent("ADDON_LOADED")
MERS:RegisterEvent("PLAYER_ENTERING_WORLD")
MER:RegisterModule(MERS:GetName())
