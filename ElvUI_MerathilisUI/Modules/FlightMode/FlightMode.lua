local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_FlightMode')
local COMP = MER:GetModule('MER_Compatibility')
local MERS = MER:GetModule('MER_Skins')
local AB = E:GetModule('ActionBars')
local LO = E:GetModule('Layout')

-- All Credits belong to the insane Benik <3

local _G = _G
local ipairs, pairs, unpack = ipairs, pairs, unpack
local floor = math.floor
local format = string.format
local date = date

local C_Map_GetBestMapForUnit = C_Map.GetBestMapForUnit
local C_Timer_After = C_Timer.After
local CreateAnimationGroup = CreateAnimationGroup
local GetBattlefieldStatus = GetBattlefieldStatus
local GetClampedCurrentExpansionLevel = GetClampedCurrentExpansionLevel
local GetExpansionDisplayInfo = GetExpansionDisplayInfo
local GetMinimapZoneText = GetMinimapZoneText
local GetRealZoneText = GetRealZoneText
local GetZonePVPInfo = GetZonePVPInfo
local GetScreenWidth = GetScreenWidth
local GetTime = GetTime
local InCombatLockdown = InCombatLockdown
local IsAddOnLoaded = IsAddOnLoaded
local IsInInstance = IsInInstance
local PlaySound = PlaySound
local UnitOnTaxi = UnitOnTaxi
local CreateFrame = CreateFrame
local UIParent = UIParent
local UIFrameFadeIn = UIFrameFadeIn
local UIFrameFadeOut = UIFrameFadeOut
local TaxiRequestEarlyLanding = TaxiRequestEarlyLanding

local r, g, b = unpack(E.media.rgbvaluecolor)
local CAMERA_SPEED = 0.075

local function AutoColoring()
	local pvpType = GetZonePVPInfo()

	if (pvpType == 'sanctuary') then
		return 0.41, 0.8, 0.94
	elseif(pvpType == 'arena') then
		return 1, 0.1, 0.1
	elseif(pvpType == 'friendly') then
		return 0.1, 1, 0.1
	elseif(pvpType == 'hostile') then
		return 1, 0.1, 0.1
	elseif(pvpType == 'contested') then
		return 1, 0.7, 0.10
	elseif(pvpType == 'combat') then
		return 1, 0.1, 0.1
	else
		return 1, 1, 0
	end
end

function module:UpdateLocation()
	local subZoneText = GetMinimapZoneText() or ''
	local zoneText = GetRealZoneText() or _G.UNKNOWN
	local displayLine

	if (subZoneText ~= '') and (subZoneText ~= zoneText) then
		displayLine = zoneText .. ': ' .. subZoneText
	else
		displayLine = subZoneText
	end

	local r, g, b = AutoColoring()
	module.FlightMode.Top.Location:AddMessage(displayLine)
	module.FlightMode.Top.Location:SetTextColor(r, g, b)
end


local noFlightMapIDs = {
	-- Antoran Wastes (Legion)
	830, -- Krokuun
	831,
	882, -- Mac'Aree
	883,
	885, -- Antoran Wastes
	887, -- The Vindicaar
}

function module:CheckFlightMapID()
	for _, id in pairs (noFlightMapIDs) do
		local noFlightMapIDs = C_Map_GetBestMapForUnit('player')
		if id == noFlightMapIDs then
			return true
		end
	end
end

local function Pepe_Model(self)
	self:ClearModel()
	self:SetModel(1386540) -- Traveller Pepe
	self:SetSize(150, 150)
	self:SetCamDistanceScale(1)
	self:SetFacing(6)
	self:SetAlpha(1)
	UIFrameFadeIn(self, 1, self:GetAlpha(), 1)
end

local AddonsToHide = {
	-- addon, frame
	{'ZygorGuidesViewer', 'ZygorGuidesViewerFrame'},
	{'ZygorGuidesViewer', 'Zygor_Notification_Center'},
	{'WorldQuestTracker', 'WorldQuestTrackerScreenPanel'},
	{'WorldQuestTracker', 'WorldQuestTrackerFinderFrame'},
	{'XIV_Databar', 'XIV_Databar'},
	{'VuhDo', 'VuhDoBuffWatchMainFrame'},
	{'WeakAuras', 'WeakAurasFrame'},
	{'HeroRotation','HeroRotation_ToggleIconFrame'},
	{'ConRO', 'ConROWindow'},
	{'ConRO', 'ConROInterruptWindow'},
	{'ConRO', 'ConROPurgeWindow'},
	{'ConRO', 'ConROButtonFrame'},
	{'ConRO', 'ConRODefenseWindow'},
	{'ConRO', 'ConRO_BurstButton'},
	{'ConRO', 'ConRO_AutoButton'},
}

local function ConvertTime(h, m)
	local AmPm
	if E.global.datatexts.settings.Time.time24 == true then
		return h, m, -1
	else
		if h >= 12 then
			if h > 12 then h = h - 12 end
			AmPm = 1
		else
			if h == 0 then h = 12 end
			AmPm = 2
		end
	end
	return h, m, AmPm
end

local function CreateTime()
	local hour, hour24, minute, ampm = tonumber(date("%I")), tonumber(date("%H")), tonumber(date("%M")), date("%p"):lower()
	local sHour, sMinute = ConvertTime(GetGameTime())

	local localTime = format("|cffb3b3b3%s|r %d:%02d|cffb3b3b3%s|r", TIMEMANAGER_TOOLTIP_LOCALTIME, hour, minute, ampm)
	local localTime24 = format("|cffb3b3b3%s|r %02d:%02d", TIMEMANAGER_TOOLTIP_LOCALTIME, hour24, minute)
	local realmTime = format("|cffb3b3b3%s|r %d:%02d|cffb3b3b3%s|r", TIMEMANAGER_TOOLTIP_REALMTIME, sHour, sMinute, ampm)
	local realmTime24 = format("|cffb3b3b3%s|r %02d:%02d", TIMEMANAGER_TOOLTIP_REALMTIME, sHour, sMinute)

	if E.global.datatexts.settings.Time.localTime then
		if E.global.datatexts.settings.Time.time24 == true then
			return localTime24
		else
			return localTime
		end
	else
		if E.global.datatexts.settings.Time.time24 == true then
			return realmTime24
		else
			return realmTime
		end
	end
end

local monthAbr = {
	[1] = L["Jan"],
	[2] = L["Feb"],
	[3] = L["Mar"],
	[4] = L["Apr"],
	[5] = L["May"],
	[6] = L["Jun"],
	[7] = L["Jul"],
	[8] = L["Aug"],
	[9] = L["Sep"],
	[10] = L["Oct"],
	[11] = L["Nov"],
	[12] = L["Dec"],
}

local daysAbr = {
	[1] = L["Sun"],
	[2] = L["Mon"],
	[3] = L["Tue"],
	[4] = L["Wed"],
	[5] = L["Thu"],
	[6] = L["Fri"],
	[7] = L["Sat"],
}

-- Create Date
local function CreateDate()
	local date = C_DateAndTime.GetCurrentCalendarTime()
	local presentWeekday = date.weekday
	local presentMonth = date.month
	local presentDay = date.monthDay
	local presentYear = date.year
	module.FlightMode.DateText:SetFormattedText("%s, %s %d, %d", daysAbr[presentWeekday], monthAbr[presentMonth], presentDay, presentYear)
end

function module:UpdateTimer()
	local createdTime = CreateTime()
	local time = GetTime() - module.startTime
	module.FlightMode.TimeFlying:SetFormattedText('%02d:%02d', floor(time/60), time % 60)

	module.FlightMode.ClockText:SetFormattedText(createdTime)

	CreateDate()
end

local VisibleFrames = {}

function module:SetFlightMode(status)
	if InCombatLockdown() then return end

	if status then
		module.FlightMode:Show()

		E.UIParent:Hide()

		MoveViewLeftStart(CAMERA_SPEED)

		-- Hide some frames
		if _G.ObjectiveTrackerFrame then _G.ObjectiveTrackerFrame:Hide() end
		if E.private.general.minimap.enable then
			_G.Minimap:Hide()
		end

		-- Bags
		if _G.ElvUI_ContainerFrame then
			_G.ElvUI_ContainerFrame:SetParent(module.FlightMode)
		end

		-- Chat
		if E.private.chat.enable then
			_G.LeftChatPanel:SetParent(module.FlightMode)
			_G.LeftChatPanel:ClearAllPoints()
			_G.LeftChatPanel:Point('RIGHT', module.FlightMode.Panel, "LEFT", -5, 0)
			_G.LeftChatDataPanel:Hide()

			_G.RightChatPanel:SetParent(module.FlightMode)
			_G.RightChatPanel:Hide()
		end

		for i, v in ipairs(AddonsToHide) do
			local addon, frame = unpack(v)
			if IsAddOnLoaded(addon) then
				if _G[frame] then
					if _G[frame]:IsVisible() then
						VisibleFrames[frame] = true
						_G[frame]:Hide()
					end
				end
			end
		end

		-- Handle ActionBars. This needs to be done if Global Fade is active
		for _, bar in pairs(AB.handledBars) do
			if bar then
				if bar:GetParent() == AB.fadeParent then
					bar:SetAlpha(0)
				end
			end
		end

		if _G.ElvUI_StanceBar then
			_G.ElvUI_StanceBar:SetAlpha(0)
		end

		-- Hide AutoButtons
		for i = 1, 12 do
			if _G['AutoQuestButton' .. i] then _G['AutoQuestButton' .. i]:Hide() end
			if _G['AutoSlotButton' .. i] then _G['AutoSlotButton' .. i]:Hide() end
			if _G['AutoUsableButton' .. i] then _G['AutoUsableButton' .. i]:Hide() end
		end

		C_Timer_After(0.05, function() _G.MainMenuBarVehicleLeaveButton:Hide() end)

		-- Disable Blizz location messsages
		_G.ZoneTextFrame:UnregisterAllEvents()

		module.startTime = GetTime()
		module.timer = self:ScheduleRepeatingTimer('UpdateTimer', 1)
		module.locationTimer = self:ScheduleRepeatingTimer('UpdateLocation', 0.2)

		module.inFlightMode = true
	elseif module.inFlightMode then
		_G.MainMenuBarVehicleLeaveButton:SetParent(_G.UIParent)

		E.UIParent:Show()

		MoveViewLeftStop()

		-- Show hidden frames
		if _G.ObjectiveTrackerFrame then _G.ObjectiveTrackerFrame:Show() end
		if E.private.general.minimap.enable then
			_G.Minimap:Show()
		end

		module.FlightMode:Hide()

		-- Enable Blizz location messsages.
		_G.ZoneTextFrame:RegisterEvent('ZONE_CHANGED_NEW_AREA')
		_G.ZoneTextFrame:RegisterEvent('ZONE_CHANGED_INDOORS')
		_G.ZoneTextFrame:RegisterEvent('ZONE_CHANGED')

		module:CancelAllTimers()

		module.FlightMode.TimeFlying:SetText('00:00')
		module.FlightMode.RequestStop:EnableMouse(true)
		module.FlightMode.RequestStop.img:SetVertexColor(1, 1, 1, .7)
		module.FlightMode.Message:Hide()
		module.FlightMode.Message:SetAlpha(1)
		module.FlightMode.Message:SetWidth(10)
		module.FlightMode.Message.text:SetAlpha(0)

		-- Revert Bags
		if _G.ElvUI_ContainerFrame then
			_G.ElvUI_ContainerFrame:SetParent(E.UIParent)
		end

		if MER.AS then
			local AS = unpack(AddOnSkins) or nil
			if AS.db.EmbedSystem or AS.db.EmbedSystemDual then AS:Embed_Show() end
		end

		for i, v in ipairs(AddonsToHide) do
			local addon, frame = unpack(v)
			if IsAddOnLoaded(addon) then
				if _G[frame] then
					if VisibleFrames[frame] then
						_G[frame]:Show()
					end
				end
			end
		end

		-- Revert ActionBars
		for _, bar in pairs(AB.handledBars) do
			if bar then
				bar:SetAlpha(1)
			end
		end

		if _G.ElvUI_StanceBar then
			_G.ElvUI_StanceBar:SetAlpha(1)
		end

		for i = 1, 12 do
			if _G['AutoQuestButton' .. i] then _G['AutoQuestButton' .. i]:Show() end
			if _G['AutoSlotButton' .. i] then _G['AutoSlotButton' .. i]:Show() end
			if _G['AutoUsableButton' .. i] then _G['AutoUsableButton' .. i]:Show() end
		end

		-- Revert Chat
		if E.private.chat.enable then
			_G.LeftChatPanel:SetParent(E.UIParent)

			_G.LeftChatPanel:ClearAllPoints()
			_G.LeftChatPanel:SetPoint('BOTTOMLEFT', _G.LeftChatMover, 'BOTTOMLEFT')
			_G.LeftChatPanel:SetFrameStrata('BACKGROUND')

			_G.RightChatPanel:SetParent(E.UIParent)
			_G.RightChatPanel:Show()

			LO:RepositionChatDataPanels()
			LO:ToggleChatPanels()
		end

		module.inFlightMode = false
	end
end

function module:OnEvent(event, ...)
	local forbiddenArea = module:CheckFlightMapID()
	if forbiddenArea then return end

	if event == 'LFG_PROPOSAL_SHOW' or event == 'UPDATE_BATTLEFIELD_STATUS' then
		if event == 'UPDATE_BATTLEFIELD_STATUS' then
			local status = GetBattlefieldStatus(...)
			if status == 'confirm' then
				module:SetFlightMode(false)
			end
		else
			module:SetFlightMode(false)
		end
		return
	end

	if IsInInstance() then return end

	if UnitOnTaxi('player') then
		module:SetFlightMode(true)
	else
		module:SetFlightMode(false)
	end
end

function module:Toggle()
	if E.db.mui.flightMode.enable then
		self:RegisterEvent('UPDATE_BONUS_ACTIONBAR', 'OnEvent')
		self:RegisterEvent('UPDATE_MULTI_CAST_ACTIONBAR', 'OnEvent')
		self:RegisterEvent('LFG_PROPOSAL_SHOW', 'OnEvent')
		self:RegisterEvent('UPDATE_BATTLEFIELD_STATUS', 'OnEvent')
		self:RegisterEvent('PLAYER_ENTERING_WORLD', 'OnEvent')
	else
		self:UnregisterEvent('UPDATE_BONUS_ACTIONBAR')
		self:UnregisterEvent('UPDATE_MULTI_CAST_ACTIONBAR')
		self:UnregisterEvent('LFG_PROPOSAL_SHOW')
		self:UnregisterEvent('UPDATE_BATTLEFIELD_STATUS')
		self:UnregisterEvent('PLAYER_ENTERING_WORLD')
	end
end

function module:Resize()
	local panelSize = E.db.mui.panels.panelSize or 427

	module.FlightMode.Top.LeftStyle:Size(panelSize, 4)
	module.FlightMode.Top.LeftStyle1:Size(panelSize, 36)
	module.FlightMode.Top.LeftStyle2:Size(panelSize, E.mult)

	module.FlightMode.Top.RightStyle:Size(panelSize, 4)
	module.FlightMode.Top.RightStyle1:Size(panelSize, 36)
	module.FlightMode.Top.RightStyle2:Size(panelSize, E.mult)
end

function module:CreateFlightMode()
	module.FlightMode = CreateFrame('Frame', 'MER_FlightModeFrame', UIParent)
	module.FlightMode:SetFrameLevel(1)
	module.FlightMode:SetFrameStrata('BACKGROUND')
	module.FlightMode:SetAllPoints(UIParent)
	module.FlightMode:Hide()

	module.FlightMode.Top = CreateFrame('Frame', nil, module.FlightMode, 'BackdropTemplate')
	module.FlightMode.Top:SetFrameLevel(0)
	module.FlightMode.Top:SetFrameStrata('MEDIUM')
	module.FlightMode.Top:Point('TOP', module.FlightMode, 'TOP', 0, E.Border)
	module.FlightMode.Top:CreateBackdrop('Transparent')
	module.FlightMode.Top:SetBackdropBorderColor(.3, .3, .3, 1)
	module.FlightMode.Top:Width(GetScreenWidth() + (E.Border*2))
	module.FlightMode.Top:Height(52)
	module.FlightMode.Top:Styling()

	E['frames'][module.FlightMode.Top] = true
	module.FlightMode.Top.ignoreFrameTemplates = true
	module.FlightMode.Top.ignoreBackdropColors = true

	local panelSize = E.db.mui.panels.panelSize or 427

	module.FlightMode.Top.LeftStyle = CreateFrame('Frame', nil, module.FlightMode)
	module.FlightMode.Top.LeftStyle:SetFrameStrata('HIGH')
	module.FlightMode.Top.LeftStyle:SetFrameLevel(2)
	module.FlightMode.Top.LeftStyle:Size(panelSize, 4)
	module.FlightMode.Top.LeftStyle:Point('TOPLEFT', module.FlightMode, 'TOPLEFT', 2, 0)
	MERS:SkinPanel(module.FlightMode.Top.LeftStyle)

	module.FlightMode.Top.LeftStyle1 = CreateFrame('Frame', nil, module.FlightMode)
	module.FlightMode.Top.LeftStyle1:Point('TOPLEFT', module.FlightMode, 'TOPLEFT', 2, -16)
	MER:CreateGradientFrame(module.FlightMode.Top.LeftStyle1, panelSize, 36, 'Horizontal', 0, 0, 0, .0, 0)

	module.FlightMode.Top.LeftStyle2 = CreateFrame('Frame', nil, module.FlightMode.Top.LeftStyle1)
	module.FlightMode.Top.LeftStyle2:Point('TOP', module.FlightMode.Top.LeftStyle1, 'BOTTOM')
	MER:CreateGradientFrame(module.FlightMode.Top.LeftStyle2, panelSize, E.mult, 'Horizontal', r, g, b, .7, 0)

	module.FlightMode.Top.RightStyle = CreateFrame('Frame', nil, module.FlightMode)
	module.FlightMode.Top.RightStyle:SetFrameStrata('HIGH')
	module.FlightMode.Top.RightStyle:SetFrameLevel(2)
	module.FlightMode.Top.RightStyle:Size(panelSize, 4)
	module.FlightMode.Top.RightStyle:Point('TOPRIGHT', module.FlightMode, 'TOPRIGHT', -2, 0)
	MERS:SkinPanel(module.FlightMode.Top.RightStyle)

	module.FlightMode.Top.RightStyle1 = CreateFrame('Frame', nil, module.FlightMode)
	module.FlightMode.Top.RightStyle1:Point('TOPRIGHT', module.FlightMode, 'TOPRIGHT', 2, -16)
	MER:CreateGradientFrame(module.FlightMode.Top.RightStyle1, panelSize, 36, 'Horizontal', 0, 0, 0, 0, 0)

	module.FlightMode.Top.RightStyle2 = CreateFrame('Frame', nil, module.FlightMode.Top.RightStyle1)
	module.FlightMode.Top.RightStyle2:Point('TOP', module.FlightMode.Top.RightStyle1,'BOTTOM')
	MER:CreateGradientFrame(module.FlightMode.Top.RightStyle2, panelSize, E.mult, 'Horizontal', r, g, b, 0, .7)

	-- WoW logo
	module.FlightMode.Top.wowlogo = CreateFrame('Frame', nil, module.FlightMode) -- need this to upper the logo layer
	module.FlightMode.Top.wowlogo:Point('TOP', module.FlightMode.Top, 'CENTER', 0, 35)
	module.FlightMode.Top.wowlogo:SetFrameStrata("HIGH")
	module.FlightMode.Top.wowlogo:Size(300, 150)

	module.FlightMode.Top.wowlogo.tex = module.FlightMode.Top.wowlogo:CreateTexture(nil, 'OVERLAY')
	local currentExpansionLevel = GetClampedCurrentExpansionLevel()
	local expansionDisplayInfo = GetExpansionDisplayInfo(currentExpansionLevel)
	if expansionDisplayInfo then
		module.FlightMode.Top.wowlogo.tex:SetTexture(expansionDisplayInfo.logo)
	end
	module.FlightMode.Top.wowlogo.tex:SetInside()

	module.FlightMode.Top.CloseButton = CreateFrame('Button', nil, module.FlightMode.Top, 'BackdropTemplate')
	module.FlightMode.Top.CloseButton:Size(24)
	module.FlightMode.Top.CloseButton:Point('RIGHT', module.FlightMode.Top, 'RIGHT', -6, -3)

	module.FlightMode.Top.CloseButton.img = module.FlightMode.Top.CloseButton:CreateTexture(nil, 'OVERLAY')
	module.FlightMode.Top.CloseButton.img:Point('CENTER')
	module.FlightMode.Top.CloseButton.img:SetTexture('Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\close.tga')
	module.FlightMode.Top.CloseButton.img:SetVertexColor(1, 1, 1, .7)

	module.FlightMode.Top.CloseButton:SetScript('OnEnter', function()
		_G.GameTooltip:SetOwner(module.FlightMode.Top.CloseButton, 'ANCHOR_BOTTOMLEFT', -4, -4)
		_G.GameTooltip:ClearLines()
		_G.GameTooltip:AddLine(L["Exit FlightMode"])
		_G.GameTooltip:Show()

		module.FlightMode.Top.CloseButton.img:SetVertexColor(unpack(E.media.rgbvaluecolor))
	end)

	module.FlightMode.Top.CloseButton:SetScript('OnLeave', function()
		module.FlightMode.Top.CloseButton.img:SetVertexColor(1, 1, 1, .7)
		_G.GameTooltip:Hide()
	end)

	module.FlightMode.Top.CloseButton:SetScript('OnClick', function()
		module:SetFlightMode(false)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
	end)

	module.FlightMode.Top.Location = CreateFrame('ScrollingMessageFrame', nil, module.FlightMode.Top, 'BackdropTemplate')
	module.FlightMode.Top.Location:Point('LEFT', module.FlightMode.Top, 'LEFT', 0, -2)
	module.FlightMode.Top.Location:FontTemplate(nil, 16, 'OUTLINE')
	module.FlightMode.Top.Location:SetFading(true)
	module.FlightMode.Top.Location:SetFadeDuration(1)
	module.FlightMode.Top.Location:SetTimeVisible(1)
	module.FlightMode.Top.Location:SetMaxLines(1)
	module.FlightMode.Top.Location:Width(450)
	module.FlightMode.Top.Location:Height(20)

	module.FlightMode.Panel = CreateFrame('Frame', nil, module.FlightMode, 'BackdropTemplate')
	module.FlightMode.Panel:Point('BOTTOM', E.UIParent, 'BOTTOM', 0, 100)
	module.FlightMode.Panel:Size((GetScreenWidth()/2), 80)
	module.FlightMode.Panel:CreateBackdrop('Transparent')
	module.FlightMode.Panel:SetFrameStrata('FULLSCREEN')
	module.FlightMode.Panel:Styling()

	module.FlightMode.PanelIcon = CreateFrame('Frame', nil, module.FlightMode.Panel, 'BackdropTemplate')
	module.FlightMode.PanelIcon:Size(70)
	module.FlightMode.PanelIcon:Point('CENTER', module.FlightMode.Panel, 'TOP', 0, 0)

	E['frames'][module.FlightMode.Panel] = true
	module.FlightMode.Panel.ignoreFrameTemplates = true
	module.FlightMode.Panel.ignoreBackdropColors = true

	module.FlightMode.PanelIcon.Texture = module.FlightMode.PanelIcon:CreateTexture(nil, 'ARTWORK')
	module.FlightMode.PanelIcon.Texture:Point('TOPLEFT', 2, -2)
	module.FlightMode.PanelIcon.Texture:Point('BOTTOMRIGHT', -2, 2)
	module.FlightMode.PanelIcon.Texture:SetTexture('Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\mUI1_Shadow.tga')

	module.FlightMode.MERVersion = module.FlightMode.Panel:CreateFontString(nil, 'OVERLAY')
	module.FlightMode.MERVersion:Point('CENTER', module.FlightMode.Panel, 'CENTER', 0, -10)
	module.FlightMode.MERVersion:FontTemplate(nil, 24, 'OUTLINE')
	module.FlightMode.MERVersion:SetText(MER.Title.."|cFF00c0fa"..MER.Version.."|r")

	module.FlightMode.DateText = module.FlightMode.Panel:CreateFontString(nil, 'OVERLAY')
	module.FlightMode.DateText:Point('RIGHT', module.FlightMode.Panel, 'RIGHT', -5, 24)
	module.FlightMode.DateText:FontTemplate(nil, 15, 'OUTLINE')

	module.FlightMode.ClockText = module.FlightMode.Panel:CreateFontString(nil, 'OVERLAY')
	module.FlightMode.ClockText:Point('RIGHT', module.FlightMode.Panel, 'RIGHT', -5, 0)
	module.FlightMode.ClockText:FontTemplate(nil, 20, 'OUTLINE')

	-- Dynamic time & date
	local interval = 0
	module.FlightMode.Panel:SetScript('OnUpdate', function(self, elapsed)
		interval = interval - elapsed
		if interval <= 0 then
			module:UpdateTimer()
			interval = 0.5
		end
	end)

	-- Message frame. Shows when request stop is pressed
	module.FlightMode.Message = CreateFrame('Frame', nil, module.FlightMode, 'BackdropTemplate')
	module.FlightMode.Message:SetFrameLevel(0)
	module.FlightMode.Message:CreateBackdrop('Transparent')
	module.FlightMode.Message:SetPoint('TOP', module.FlightMode.Panel, 'BOTTOM', 0, (E.PixelMode and -8 or -10))
	module.FlightMode.Message:SetSize(10, 30)
	module.FlightMode.Message.backdrop:Styling()
	module.FlightMode.Message:Hide()
	-- Create animation
	module.FlightMode.Message.anim = CreateAnimationGroup(module.FlightMode.Message)
	module.FlightMode.Message.anim.sizing = module.FlightMode.Message.anim:CreateAnimation("Width")

	self.FlightMode.Message.text = module.FlightMode.Message:CreateFontString(nil, 'OVERLAY')
	self.FlightMode.Message.text:FontTemplate(nil, 14)
	self.FlightMode.Message.text:SetFormattedText('%s', _G.TAXI_CANCEL_DESCRIPTION)
	self.FlightMode.Message.text:Point('CENTER')
	self.FlightMode.Message.text:SetTextColor(1, 1, 0, .7)
	self.FlightMode.Message.text:SetAlpha(0)

	-- Request Stop button
	module.FlightMode.RequestStop = CreateFrame('Button', nil, module.FlightMode.Panel)
	module.FlightMode.RequestStop:Size(32, 32)
	module.FlightMode.RequestStop:Point('LEFT', module.FlightMode.Panel, 'LEFT', 10, 0)
	module.FlightMode.RequestStop:EnableMouse(true)

	module.FlightMode.RequestStop.img = module.FlightMode.RequestStop:CreateTexture(nil, 'OVERLAY')
	module.FlightMode.RequestStop.img:Point('CENTER')
	module.FlightMode.RequestStop.img:SetTexture('Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\arrow.tga')
	module.FlightMode.RequestStop.img:SetVertexColor(1, 1, 1, .7)

	module.FlightMode.RequestStop:SetScript('OnEnter', function()
		_G.GameTooltip:SetOwner(module.FlightMode.RequestStop, 'ANCHOR_RIGHT', 1, 0)
		_G.GameTooltip:ClearLines()
		_G.GameTooltip:AddLine(_G.TAXI_CANCEL_DESCRIPTION, selectioncolor)
		_G.GameTooltip:AddLine(L["LeftClick to Request Stop"], 0.7, 0.7, 1)
		_G.GameTooltip:Show()

		module.FlightMode.RequestStop.img:SetVertexColor(MER:unpackColor(E.db.general.valuecolor))
	end)

	module.FlightMode.RequestStop:SetScript('OnLeave', function()
		module.FlightMode.RequestStop.img:SetVertexColor(1, 1, 1, .7)
		_G.GameTooltip:Hide()
	end)

	module.FlightMode.RequestStop:SetScript('OnClick', function()
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
		TaxiRequestEarlyLanding()
		module.FlightMode.RequestStop:EnableMouse(false)
		module.FlightMode.RequestStop.img:SetVertexColor(1, 0, 0, .7)
		module.FlightMode.Message:Show()
		module.FlightMode.Message.anim.sizing:SetChange(module.FlightMode.Message.text:GetStringWidth() + 24)
		module.FlightMode.Message.anim:Play()
		C_Timer_After(.5, function()
			UIFrameFadeIn(module.FlightMode.Message.text, 1, 0, 1)
		end)
		C_Timer_After(8, function()
			UIFrameFadeOut(module.FlightMode.Message, 1, 1, 0)
		end)
	end)

	-- Time flying
	module.FlightMode.TimeFlying = module.FlightMode.Panel:CreateFontString(nil, 'OVERLAY')
	module.FlightMode.TimeFlying:FontTemplate(nil, 16, 'OUTLINE')
	module.FlightMode.TimeFlying:SetText('00:00')
	module.FlightMode.TimeFlying:Point('RIGHT', module.FlightMode.Panel, 'RIGHT', -5, -26)
	module.FlightMode.TimeFlying:SetTextColor(1, 1, 1)

	if not module.FlightMode.pepeHolder then
		module.FlightMode.pepeHolder = CreateFrame('Frame', nil, module.FlightMode.Panel)
		module.FlightMode.pepeHolder:Size(150, 150)
		module.FlightMode.pepeHolder:Point('LEFT', module.FlightMode.Panel, 'LEFT', 50, 65)

		module.FlightMode.pepeModel = CreateFrame('PlayerModel', nil, module.FlightMode.pepeHolder)
		module.FlightMode.pepeModel:Point('CENTER', module.FlightMode.pepeHolder, 'CENTER')
		module.FlightMode.pepeModel:SetScript('OnShow', Pepe_Model)
		module.FlightMode.pepeModel.isIdle = nil
		module.FlightMode.pepeModel:Show()
	end

	module:Resize()
end

function module:Initialize()
	module.db = E.db.mui.flightMode
	MER:RegisterDB(self, 'flightMode')

	if (COMP.BUI and E.db.benikui.misc.flightMode.enable) then return end
	if module.db.enable ~= true then return end

	module:CreateFlightMode()

	function module:ForUpdateAll()
		module.db = E.db.mui.flightMode
		module:Resize()
	end
	module:ForUpdateAll()

	E:UpdateBorderColors()
	module:Toggle()
	module:Resize()

	-- force databars parent. This should fix databars showing after a Pet Battle
	E.FrameLocks['ElvUI_ExperienceBar'] = { parent = E.UIParent }
	E.FrameLocks['ElvUI_ReputationBar'] = { parent = E.UIParent }
	E.FrameLocks['ElvUI_HonorBar'] = { parent = E.UIParent }
	E.FrameLocks['ElvUI_AzeriteBar'] = { parent = E.UIParent }
end

MER:RegisterModule(module:GetName())
