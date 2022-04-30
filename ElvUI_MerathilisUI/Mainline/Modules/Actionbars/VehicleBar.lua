local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_VehicleBar')
local AB = E:GetModule('ActionBars')
local LAB = LibStub('LibActionButton-1.0-ElvUI')
local Masque = LibStub('Masque', true)
local MasqueGroup = Masque and Masque:Group('ElvUI', 'ActionBars')

--[[
	Code is now from Shadow&Light
]]--

local _G = _G
local format = format
local ipairs, pairs = ipairs, pairs
local strsplit = strsplit
local RegisterStateDriver = RegisterStateDriver
local UnregisterStateDriver = UnregisterStateDriver
local GetVehicleBarIndex, GetOverrideBarIndex = GetVehicleBarIndex, GetOverrideBarIndex
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc

local defaultFont, defaultFontSize, defaultFontOutline

module.barDefaults = {
	vehicle = {
		page = 1,
		bindButtons = 'ACTIONBUTTON',
		conditions = format('[overridebar] %d; [vehicleui] %d; [possessbar] %d; [shapeshift] 13;', GetOverrideBarIndex(), GetVehicleBarIndex(), GetVehicleBarIndex()),
		position = 'BOTTOM,ElvUIParent,BOTTOM,0,176',
	}
}
module.handledBars = {}

function module:Animate(bar, x, y, duration)
	bar.anim = bar:CreateAnimationGroup('Move_In')
	bar.anim.in1 = bar.anim:CreateAnimation('Translation')
	bar.anim.in1:SetDuration(0)
	bar.anim.in1:SetOrder(1)
	bar.anim.in2 = bar.anim:CreateAnimation('Translation')
	bar.anim.in2:SetDuration(duration)
	bar.anim.in2:SetOrder(2)
	bar.anim.in2:SetSmoothing('OUT')
	bar.anim.out1 = bar:CreateAnimationGroup('Move_Out')
	bar.anim.out2 = bar.anim.out1:CreateAnimation('Translation')
	bar.anim.out2:SetDuration(duration)
	bar.anim.out2:SetOrder(1)
	bar.anim.out2:SetSmoothing('IN')
	bar.anim.in1:SetOffset(x, y)
	bar.anim.in2:SetOffset(-x, -y)
	bar.anim.out2:SetOffset(x, y)
	bar.anim.out1:SetScript('OnFinished', function() bar:Hide() end)
end

function module:AnimSlideIn(bar)
	if not bar.anim then
		module:Animate(bar)
	end

	bar.anim.out1:Stop()
	bar.anim:Play()
end

function module:AnimSlideOut(bar)
	if bar.anim then
		bar.anim:Finish()
	end

	bar.anim:Stop()
	bar.anim.out1:Play()
end

function module:PositionAndSizeBar()
	if not module.bar then return end
	local db = E.db.mui.actionbars.vehicle
	local bar = module.bar
	local buttonSpacing = db.buttonSpacing
	local backdropSpacing = db.backdropSpacing
	local buttonsPerRow = db.buttonsPerRow <= 7 and db.buttonsPerRow or 7
	local point = db.point
	local numButtons = 7
	db.buttons = numButtons --Hard code it here for AB:HandleButton() needs it

	bar.db = db
	bar.mouseover = db.mouseover

	bar:EnableMouse(bar.mouseover or not db.clickThrough)
	bar:SetAlpha(bar.mouseover and 0 or db.alpha)
	bar:SetFrameStrata(db.frameStrata or 'LOW')
	bar:SetFrameLevel(db.frameLevel)

	AB:FadeBarBlings(bar, bar.mouseover and 0 or db.alpha) --* Prob not needed/wanted tbh
	bar.backdrop:SetShown(db.backdrop)
	bar.backdrop:SetFrameStrata(db.frameStrata or 'LOW')
	bar.backdrop:SetFrameLevel(db.frameLevel - 1)
	bar.backdrop:ClearAllPoints()

	AB:MoverMagic(bar)

	local _, horizontal, anchorUp, anchorLeft = AB:GetGrowth(point)
	local button, lastButton, lastColumnButton, anchorRowButton, lastShownButton

	for i = 1, db.buttons do
		lastButton = bar.buttons[i-1]
		lastColumnButton = bar.buttons[i-buttonsPerRow]
		button = bar.buttons[i]
		button.db = db

		if i == 1 or i == buttonsPerRow then
			anchorRowButton = button
		end

		if i > db.buttons then
			button:Hide()
			button.handleBackdrop = nil
		else
			button:Show()
			button.handleBackdrop = true
			lastShownButton = button
		end

		AB:HandleButton(bar, button, i, lastButton, lastColumnButton)
		AB:StyleButton(button, nil, MasqueGroup and E.private.actionbar.masque.actionbars)

		local hotkey = _G[bar.buttons[i]:GetName()..'HotKey']
		local hotkeytext

		local hotkeyPosition = db and db.hotkeyTextPosition or 'TOPRIGHT'
		local hotkeyXOffset = db and db.hotkeyTextXOffset or 0
		local hotkeyYOffset = db and db.hotkeyTextYOffset or -3
		local color = db and db.useHotkeyColor and db.hotkeyColor or AB.db.fontColor

		if i == 7 then
			hotkeytext = _G['ElvUI_Bar1Button12HotKey']:GetText()
		else
			hotkeytext = _G['ElvUI_Bar1Button'..i..'HotKey']:GetText()
		end

		local justify = 'RIGHT'
		if hotkeyPosition == 'TOPLEFT' or hotkeyPosition == 'BOTTOMLEFT' then
			justify = 'LEFT'
		elseif hotkeyPosition == 'TOP' or hotkeyPosition == 'BOTTOM' then
			justify = 'CENTER'
		end

		if hotkeytext then
			if hotkeytext == _G.RANGE_INDICATOR then
				hotkey:SetFont(defaultFont, defaultFontSize, defaultFontOutline)
				hotkey.SetVertexColor = nil
			else
				hotkey:FontTemplate(E.Libs.LSM:Fetch('font', db and db.hotkeyFont or AB.db.font), db and db.hotkeyFontSize or AB.db.fontSize, db and db.hotkeyFontOutline or AB.db.fontOutline)
				hotkey.SetVertexColor = E.noop
			end
			hotkey:SetText(hotkeytext)
			hotkey:SetJustifyH(justify)
		end

		hotkey:SetTextColor(color.r, color.g, color.b)

		if db and not db.hotkeytext then
			hotkey:Hide()
		else
			hotkey:Show()
		end

		if not bar.buttons[i].useMasque then
			hotkey:ClearAllPoints()
			hotkey:Point(hotkeyPosition, hotkeyXOffset, hotkeyYOffset)
		end
	end

	AB:HandleBackdropMultiplier(bar, backdropSpacing, buttonSpacing, db.widthMult, db.heightMult, anchorUp, anchorLeft, horizontal, lastShownButton, anchorRowButton)
	AB:HandleBackdropMover(bar, backdropSpacing)

	local page = format('[overridebar] %d; [vehicleui] %d; [possessbar] %d; [shapeshift] 13;', GetOverrideBarIndex(), GetVehicleBarIndex(), GetVehicleBarIndex())
	RegisterStateDriver(bar, 'page', page)

	if db.enable then
		E:EnableMover(bar.mover:GetName())
		RegisterStateDriver(bar, 'visibility', '[petbattle] hide; [vehicleui][overridebar][shapeshift][possessbar] show; hide')
		bar:Show()
	else
		E:DisableMover(bar.mover:GetName())
		UnregisterStateDriver(bar, 'visibility')
		bar:Hide()
	end

	E:SetMoverSnapOffset('MER_VehicleBarMover', db.buttonSpacing / 2)

	if MasqueGroup and E.private.actionbar.masque.actionbars then
		MasqueGroup:ReSkin()

		-- masque retrims them all so we have to too
		for btn in pairs(AB.handledbuttons) do
			AB:TrimIcon(btn, true)
		end
	end
end

function module:CreateBar()
	local bar = CreateFrame('Frame', 'MER_VehicleBar', E.UIParent, 'SecureHandlerStateTemplate,BackdropTemplate')
	module.handledBars['vehicle'] = bar
	module.bar = bar

	local defaults = module.barDefaults['vehicle']
	local elvButton = 'ElvUI_Bar1Button'
	bar.id = 1

	local point, anchor, attachTo, x, y = strsplit(',', defaults.position)
	bar:Point(point, anchor, attachTo, x, y)
	bar:HookScript('OnShow', function(frame) self:AnimSlideIn(frame) end)

	bar:CreateBackdrop(AB.db.transparent and 'Transparent', nil, nil, nil, nil, nil, nil, nil, 0)
	if bar.backdrop then
		bar.backdrop:Styling()
		MER:CreateBackdropShadow(bar)
	end

	bar.buttons = {}

	AB:HookScript(bar, 'OnEnter', 'Bar_OnEnter')
	AB:HookScript(bar, 'OnLeave', 'Bar_OnLeave')

	for i = 1, 7 do
		bar.buttons[i] = LAB:CreateButton(i, format(bar:GetName()..'Button%d', i), bar, nil)
		bar.buttons[i]:SetState(0, 'action', i)

		for k = 1, 14 do
			bar.buttons[i]:SetState(k, 'action', (k - 1) * 12 + i)
		end

		if i == 7 then
			bar.buttons[i]:SetState(12, 'custom', AB.customExitButton)
			_G[elvButton..i].slvehiclebutton = bar.buttons[i]:GetName()
		else
			_G[elvButton..i].slvehiclebutton = bar.buttons[i]:GetName()
		end

		--Masuqe Support
		if MasqueGroup and E.private.actionbar.masque.actionbars then
			bar.buttons[i]:AddToMasque(MasqueGroup)
		end

		AB:HookScript(bar.buttons[i], 'OnEnter', 'Button_OnEnter')
		AB:HookScript(bar.buttons[i], 'OnLeave', 'Button_OnLeave')
	end

	bar:SetAttribute('_onstate-page', [[
		newstate = ((HasTempShapeshiftActionBar() and self:GetAttribute('hasTempBar')) and GetTempShapeshiftBarIndex()) or (UnitHasVehicleUI('player') and GetVehicleBarIndex()) or (HasOverrideActionBar() and GetOverrideBarIndex()) or newstate
		if not newstate then return end
		if newstate ~= 0 then
			self:SetAttribute('state', newstate)
			control:ChildUpdate('state', newstate)
		else
			local newCondition = self:GetAttribute('newCondition')
			if newCondition then
				newstate = SecureCmdOptionParse(newCondition)
				self:SetAttribute('state', newstate)
				control:ChildUpdate('state', newstate)
			end
		end
	]])

	local db = E.db.mui.actionbars.vehicle
	local animationDistance = db.keepSizeRatio and db.buttonSize or db.buttonHeight
	module:Animate(bar, 0, -(animationDistance), 1)

	E:CreateMover(bar, 'MER_VehicleBarMover', L["Vehicle Bar Mover"], nil, nil, nil, 'ALL,ACTIONBARS,MERATHILISUI', nil, 'mui,modules,actionbars')
end

function module:UpdateButtonSettings()
	if not E.private.actionbar.enable then return end

	for barName, bar in pairs(module.handledBars) do
		module:UpdateButtonConfig(barName, bar.bindButtons)
		module:PositionAndSizeBar()
	end
end

function module:UpdateButtonConfig(barName)
	local barDB = E.db.mui.actionbars[barName]
	local bar = module.handledBars[barName]

	if not bar.buttonConfig then bar.buttonConfig = { hideElements = {}, colors = {} } end

	bar.buttonConfig.hideElements.hotkey = not barDB.hotkeytext
	bar.buttonConfig.showGrid = barDB.showGrid
	bar.buttonConfig.clickOnDown = AB.db.keyDown
	bar.buttonConfig.outOfRangeColoring = (AB.db.useRangeColorText and 'hotkey') or 'button'
	bar.buttonConfig.colors.range = E:SetColorTable(bar.buttonConfig.colors.range, AB.db.noRangeColor)
	bar.buttonConfig.colors.mana = E:SetColorTable(bar.buttonConfig.colors.mana, AB.db.noPowerColor)
	bar.buttonConfig.colors.usable = E:SetColorTable(bar.buttonConfig.colors.usable, AB.db.usableColor)
	bar.buttonConfig.colors.notUsable = E:SetColorTable(bar.buttonConfig.colors.notUsable, AB.db.notUsableColor)
	bar.buttonConfig.useDrawBling = not AB.db.hideCooldownBling
	bar.buttonConfig.useDrawSwipeOnCharges = AB.db.useDrawSwipeOnCharges
	bar.buttonConfig.handleOverlay = AB.db.handleOverlay

	for _, button in ipairs(bar.buttons) do
		button:UpdateConfig(bar.buttonConfig)
	end
end

--* Ghetto way to get the pushed texture to work
function module:LAB_MouseUp()
	if not E.private.actionbar.enable or not E.db.mui.actionbars.vehicle.enable then return end
	local slbutton = _G[self.slvehiclebutton]
	if slbutton and slbutton.config.clickOnDown then
		slbutton:GetPushedTexture():Hide()
	end
end
hooksecurefunc(AB, 'LAB_MouseUp', module.LAB_MouseUp)

function module:LAB_MouseDown()
	if not E.private.actionbar.enable or not E.db.mui.actionbars.vehicle.enable then return end
	local slbutton = _G[self.slvehiclebutton]
	if slbutton and slbutton.config.clickOnDown then
		slbutton:GetPushedTexture():Show()
	end
end
hooksecurefunc(AB, 'LAB_MouseDown', module.LAB_MouseDown)

function module:Initialize()
	module.db = E.db.mui.actionbars.vehicle
	if not module.db.enable then return end

	MER:RegisterDB(self, "vehicle")

	if E.locale == 'koKR' then
		defaultFont, defaultFontSize, defaultFontOutline = [[Fonts\2002.TTF]], 11, "MONOCHROME, THICKOUTLINE"
	elseif E.locale == 'zhTW' then
		defaultFont, defaultFontSize, defaultFontOutline = [[Fonts\arheiuhk_bd.TTF]], 11, "MONOCHROME, THICKOUTLINE"
	elseif E.locale == 'zhCN' then
		defaultFont, defaultFontSize, defaultFontOutline = [[Fonts\FRIZQT__.TTF]], 11, 'MONOCHROME, OUTLINE'
	else
		defaultFont, defaultFontSize, defaultFontOutline = [[Fonts\ARIALN.TTF]], 12, "MONOCHROME, THICKOUTLINE"
	end

	module:CreateBar()
	module:UpdateButtonSettings()

	hooksecurefunc(AB, 'UpdateButtonSettings', module.UpdateButtonSettings)
end

MER:RegisterModule(module:GetName())
