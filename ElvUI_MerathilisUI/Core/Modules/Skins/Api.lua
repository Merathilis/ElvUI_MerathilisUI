local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local LSM = E.Libs.LSM
local S = E.Skins

local _G = _G
local assert, next, pairs, select, unpack, type = assert, next, pairs, select, unpack, type
local xpcall = xpcall
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

module.addonsToLoad = {}
module.nonAddonsToLoad = {}
module.updateProfile = {}
module.aceWidgets = {}
module.enteredLoad = {}

module.NORMAL_QUEST_DISPLAY = "|cffffffff%s|r"
module.TRIVIAL_QUEST_DISPLAY = TRIVIAL_QUEST_DISPLAY:gsub("000000", "ffffff")
TEXTURE_ITEM_QUEST_BANG = [[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Textures\UI-Icon-QuestBang]]

local buttons = {
	"UI-Panel-MinimizeButton-Disabled",
	"UI-Panel-MinimizeButton-Up",
	"UI-Panel-SmallerButton-Up",
	"UI-Panel-BiggerButton-Up",
}

-- Depends on the arrow texture to be down by default.
module.ArrowRotation = {
	['UP'] = 3.14,
	['DOWN'] = 0,
	['LEFT'] = -1.57,
	['RIGHT'] = 1.57,
}


local function errorhandler(err)
	return _G.geterrorhandler()(err)
end

function module:AddCallback(name, func)
	tinsert(self.nonAddonsToLoad, func or self[name])
end

function module:AddCallbackForAceGUIWidget(name, func)
	self.aceWidgets[name] = func or self[name]
end

function module:AddCallbackForAddon(addonName, func)
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

function module:AddCallbackForEnterWorld(name, func)
	tinsert(self.enteredLoad, func or self[name])
end

function module:PLAYER_ENTERING_WORLD()
	if not E.initialized then
		return
	end

	for index, func in next, self.enteredLoad do
		xpcall(func, errorhandler, self)
		self.enteredLoad[index] = nil
	end
end

function module:AddCallbackForUpdate(name, func)
	tinsert(self.updateProfile, func or self[name])
end

function module:CallLoadedAddon(addonName, object)
	for _, func in next, object do
		xpcall(func, errorhandler, self)
	end

	self.addonsToLoad[addonName] = nil
end

function module:ADDON_LOADED(_, addonName)
	if not E.initialized then
		return
	end

	local object = self.addonsToLoad[addonName]
	if object then
		self:CallLoadedAddon(addonName, object)
	end
end

function module:DisableAddOnSkin(key)
	if _G.AddOnSkins then
		local AS = _G.AddOnSkins[1]
		if AS and AS.db[key] then
			AS:SetOption(key, false)
		end
	end
end

-- Create shadow for textures
function module:CreateSD(f, m, s, n)
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

function module:CreateBG(frame)
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
function module:CreateGradient(f)
	assert(f, "doesn't exist!")

	local tex = f:CreateTexture(nil, "BORDER")
	tex:SetInside()
	tex:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Textures\gradient.tga]])
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

function module:CreateBDFrame(f, a)
	assert(f, "doesn't exist!")

	local parent = f.IsObjectType and f:IsObjectType("Texture") and f:GetParent() or f

	local bg = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	bg:SetOutside(f)
	if (parent:GetFrameLevel() - 1) >= 0 then
		bg:SetFrameLevel(parent:GetFrameLevel() - 1)
	else
		bg:SetFrameLevel(0)
	end
	module:CreateBD(bg, a or .5)

	return bg
end

function module:CreateBD(f, a)
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

	function module:HandleScrollBar(_, frame, thumbTrimY, thumbTrimX)
		local parent = frame:GetParent()

		local Thumb = GrabScrollBarElement(frame, 'ThumbTexture') or GrabScrollBarElement(frame, 'thumbTexture') or frame.GetThumbTexture and frame:GetThumbTexture()

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
		thumb:SetVertexColor(r, g, b)
	end
end

-- Overwrite ElvUI Tabs function to be transparent
function module:HandleTab(tab)
	if not tab then return end

	if tab.backdrop then
		tab.backdrop:SetTemplate("Transparent")
		tab.backdrop:Styling()
	end

	MER:CreateBackdropShadow(tab)
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

local function Frame_OnEnter(frame)
	if not frame:IsEnabled() or not frame.merAnimated then
		return
	end

	if not frame.selected then
		if frame.merAnimated.bgOnLeave:IsPlaying() then
			frame.merAnimated.bgOnLeave:Stop()
		end
		frame.merAnimated.bgOnEnter:Play()
	end
end

local function Frame_OnLeave(frame)
	if not frame:IsEnabled() or not frame.merAnimated then
		return
	end

	if not frame.selected then
		if frame.merAnimated.bgOnEnter:IsPlaying() then
			frame.merAnimated.bgOnEnter:Stop()
		end
		frame.merAnimated.bgOnLeave:Play()
	end
end

local function CreateAnimation(texture, aType, direction, duration, data)
	local aType = strlower(aType)
	local group = texture:CreateAnimationGroup()
	local event = direction == "in" and "OnPlay" or "OnFinished"

	local startAlpha = data and data[1] or (direction == "in" and 0 or 1)
	local endAlpha = data and data[2] or (direction == "in" and 1 or 0)

	if aType == "fade" then
		group.anim = group:CreateAnimation("Alpha")
		group.anim:SetFromAlpha(startAlpha)
		group.anim:SetToAlpha(endAlpha)
		group.anim:SetSmoothing(direction == "in" and "IN" or "OUT")
		group.anim:SetDuration(duration)
	elseif aType == "scale" then
	end

	if group.anim then
		group:SetScript(event, function()
			texture:SetAlpha(endAlpha)
		end)
		group.anim:SetDuration(duration)

		return group
	end
end

-- Buttons
function module:HandleButton(_, button)
	if not button or button.MERSkin then return end

	local db = E.private.mui.skins.widgets.button

	if button.Icon then
		local Texture = button.Icon:GetTexture()
		if Texture and strfind(Texture, [[Interface\ChatFrame\ChatFrameExpandArrow]]) then
			button.Icon:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Textures\Arrow]])
			button.Icon:SetVertexColor(1, 1, 1)
			button.Icon:SetRotation(module.ArrowRotation['RIGHT'])
		end
	end

	if db.text.enable then
		local text = button.Text or button:GetName() and _G[button:GetName() .. "Text"]
		if text and text.GetTextColor then
			F.SetFontDB(text, db.text.font)
		end
	end

	if button.template and db.backdrop.enable then
		-- Create background
		local bg = button:CreateTexture()
		bg:SetInside(button, 1, 1)
		bg:SetAlpha(0)
		bg:SetTexture(LSM:Fetch("statusbar", db.backdrop.texture) or E.media.normTex)
		F.SetVertexColorDB(bg, db.backdrop.classColor and MER.ClassColor or db.backdrop.color)

		-- Animations
		button.merAnimated = { bg = bg, bgOnEnter = CreateAnimation(bg, db.backdrop.animationType, "in", db.backdrop.animationDuration, {0, db.backdrop.alpha}), bgOnLeave = CreateAnimation(bg, db.backdrop.animationType, "out", db.backdrop.animationDuration, {db.backdrop.alpha, 0})}

		button:HookScript("OnEnter", Frame_OnEnter)
		button:HookScript("OnLeave", Frame_OnLeave)

		if db.backdrop.removeBorderEffect then
			button.SetBackdropBorderColor = E.noop
		end
	end

	module:CreateGradient(button)

	button.MERSkin = true
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

function module:SkinPanel(panel)
	panel.tex = panel:CreateTexture(nil, "ARTWORK")
	panel.tex:SetAllPoints()
	panel.tex:SetTexture(E.media.blankTex)
	panel.tex:SetGradient("VERTICAL", rgbValueColorR, rgbValueColorG, rgbValueColorB)
	MER:CreateShadow(panel)
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

function module:ReskinAS(AS)
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
			for _, Region in pairs(module.Blizzard.Regions) do
				if _G[TabName..Region] then
					_G[TabName..Region]:SetTexture(nil)
				end
			end
		end

		for _, Region in pairs(module.Blizzard.Regions) do
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

		Button:HookScript("OnEnter", module.OnEnter)
		Button:HookScript("OnLeave", module.OnLeave)
	end
end

-- Replace the Recap button script re-set function
function S:UpdateRecapButton()
	if self and self.button4 and self.button4:IsEnabled() then
		self.button4:SetScript("OnEnter", module.ColorButton)
		self.button4:SetScript("OnLeave", module.ClearButton)
	end
end

--[[ HOOK TO THE UIWIDGET TYPES ]]
function module:SkinTextWithStateWidget(_, widgetFrame)
	local text = widgetFrame.Text
	if text then
		text:SetTextColor(1, 1, 1)
	end
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

-- hook the skin functions from ElvUI
module:SecureHook(S, "HandleTab")
module:SecureHook(S, "HandleButton")
module:SecureHook(S, "HandleScrollBar")
module:SecureHook(S, "HandleSliderFrame")
module:SecureHook(S, "SkinTextWithStateWidget")

function module:Initialize()
	self.db = E.private.mui.skins

	updateMedia()
	self:StyleElvUIConfig()

	if IsAddOnLoaded("AddOnSkins") then
		if AddOnSkins then
			module:ReskinAS(unpack(AddOnSkins))
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

module:RegisterEvent("ADDON_LOADED")
module:RegisterEvent("PLAYER_ENTERING_WORLD")
MER:RegisterModule(module:GetName())
