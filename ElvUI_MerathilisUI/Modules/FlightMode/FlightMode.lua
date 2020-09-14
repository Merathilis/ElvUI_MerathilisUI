local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:NewModule('mUIFlightMode', 'AceHook-3.0', 'AceTimer-3.0', 'AceEvent-3.0')
local AB = E:GetModule('ActionBars')
local LO = E:GetModule('Layout')

-- All Credits belong to the insane Benik <3

local _G = _G
local ipairs, pairs, unpack = ipairs, pairs, unpack
local C_Map_GetBestMapForUnit = C_Map.GetBestMapForUnit
local GetScreenWidth = GetScreenWidth
local GetTime = GetTime
local InCombatLockdown = InCombatLockdown
local IsAddOnLoaded = IsAddOnLoaded
local IsInInstance = IsInInstance
local PlaySound = PlaySound
local UnitOnTaxi = UnitOnTaxi
local CreateFrame = CreateFrame
local UIParent = UIParent

local noFlightMapIDs = {
	-- Antoran Wastes (Legion)
	830, -- Krokuun
	831,
	882, -- Mac'Aree
	885, -- Antoran Wastes
	887, -- The Vindicaar
}

function module:CheckFlightMapID()
	for _, id in pairs (noFlightMapIDs) do
		local noFlightMapIDs = C_Map_GetBestMapForUnit("player")
		if id == noFlightMapIDs then
			return true
		end
	end
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
	{'HeroRotation','HeroRotation_ToggleIconFrame'}
}

local VisibleFrames = {}

function module:SetFlightMode(status)
	if InCombatLockdown() then return end

	if(status) then
		module.inFlightMode = true
		module.FlightMode:Show()

		E.UIParent:Hide()

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
			_G.LeftChatPanel:Point('RIGHT', module.FlightMode.Panel, "LEFT", -10, 0)
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

		-- Disable Blizz location messsages
		_G.ZoneTextFrame:UnregisterAllEvents()

		module.startTime = GetTime()
		--self.timer = self:ScheduleRepeatingTimer('UpdateTimer', 1)
		--self.locationTimer = self:ScheduleRepeatingTimer('UpdateLocation', 0.2)
		--self.coordsTimer = self:ScheduleRepeatingTimer('UpdateCoords', 0.2)
		--self.fpsTimer = self:ScheduleRepeatingTimer('UpdateFps', 1)
	elseif(module.inFlightMode) then
		module.inFlightMode = false

		_G.MainMenuBarVehicleLeaveButton:SetParent(_G.UIParent)

		E.UIParent:Show()

		-- Show hidden frames
		if _G.ObjectiveTrackerFrame then _G.ObjectiveTrackerFrame:Show() end
		if E.private.general.minimap.enable then
			_G.Minimap:Show()
		end

		module.FlightMode:Hide()

		-- Enable Blizz location messsages.
		_G.ZoneTextFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		_G.ZoneTextFrame:RegisterEvent("ZONE_CHANGED_INDOORS")
		_G.ZoneTextFrame:RegisterEvent("ZONE_CHANGED")

		self:CancelAllTimers()

		--self.FlightMode.bottom.timeFlying.txt:SetText("00:00")
		--self.FlightMode.bottom.requestStop:EnableMouse(true)
		--self.FlightMode.bottom.requestStop.img:SetVertexColor(1, 1, 1, .7)
		--self.FlightMode.message:Hide()
		--self.FlightMode.message:SetAlpha(1)
		--self.FlightMode.message:SetWidth(10)
		--self.FlightMode.message.text:SetAlpha(0)

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

		-- revert Left Chat
		if E.private.chat.enable then
			_G.LeftChatPanel:SetParent(E.UIParent)

			_G.LeftChatPanel:ClearAllPoints()
			_G.LeftChatPanel:SetPoint("BOTTOMLEFT", _G.LeftChatMover, "BOTTOMLEFT")
			_G.LeftChatPanel:SetFrameStrata('BACKGROUND')

			_G.RightChatPanel:SetParent(E.UIParent)
			_G.RightChatPanel:Show()

			LO:RepositionChatDataPanels()
			LO:ToggleChatPanels()
		end
	end
end

function module:OnEvent(event, ...)
	local forbiddenArea = module:CheckFlightMapID()
	if forbiddenArea then return end

	if event == "LFG_PROPOSAL_SHOW" or event == "UPDATE_BATTLEFIELD_STATUS" then
		if event == "UPDATE_BATTLEFIELD_STATUS" then
			local status = GetBattlefieldStatus(...)
			if status == "confirm" then
				module:SetFlightMode(false)
			end
		else
			module:SetFlightMode(false)
		end
		return
	end

	if IsInInstance() then return end

	if UnitOnTaxi("player") then
		module:SetFlightMode(true)
	else
		module:SetFlightMode(false)
	end
end

function module:Toggle()
	if E.db.mui.flightMode.enable then
		self:RegisterEvent("UPDATE_BONUS_ACTIONBAR", "OnEvent")
		self:RegisterEvent("UPDATE_MULTI_CAST_ACTIONBAR", "OnEvent")
		self:RegisterEvent("LFG_PROPOSAL_SHOW", "OnEvent")
		self:RegisterEvent("UPDATE_BATTLEFIELD_STATUS", "OnEvent")
		self:RegisterEvent("PLAYER_ENTERING_WORLD", "OnEvent")
	else
		self:UnregisterEvent("UPDATE_BONUS_ACTIONBAR")
		self:UnregisterEvent("UPDATE_MULTI_CAST_ACTIONBAR")
		self:UnregisterEvent("LFG_PROPOSAL_SHOW")
		self:UnregisterEvent("UPDATE_BATTLEFIELD_STATUS")
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
end

function module:Initialize()
	module.db = E.db.mui.flightMode
	MER:RegisterDB(self, "flightMode")

	if IsAddOnLoaded("ElvUI_BenikUI") then return end
	if module.db.enable ~= true then return end

	function module:ForUpdateAll()
		module.db = E.db.mui.flightMode
	end
	module:ForUpdateAll()

	module.FlightMode = CreateFrame("Frame", "mUIFlightModeFrame", UIParent)
	module.FlightMode:SetFrameLevel(1)
	module.FlightMode:SetFrameStrata('BACKGROUND')
	module.FlightMode:SetAllPoints(UIParent)
	module.FlightMode:Hide()

	module.FlightMode.Top = CreateFrame('Frame', nil, module.FlightMode, 'BackdropTemplate')
	module.FlightMode.Top:SetFrameLevel(0)
	module.FlightMode.Top:SetFrameStrata("HIGH")
	module.FlightMode.Top:Point('TOP', module.FlightMode, 'TOP', 0, E.Border)
	module.FlightMode.Top:CreateBackdrop('Transparent')
	module.FlightMode.Top:SetBackdropBorderColor(.3, .3, .3, 1)
	module.FlightMode.Top:Width(GetScreenWidth() + (E.Border*2))
	module.FlightMode.Top:Height(40)
	module.FlightMode.Top:Styling()

	E["frames"][module.FlightMode.Top] = true
	module.FlightMode.Top.ignoreFrameTemplates = true
	module.FlightMode.Top.ignoreBackdropColors = true

	module.FlightMode.Top.CloseButton = CreateFrame('Button', nil, module.FlightMode.Top, 'BackdropTemplate')
	module.FlightMode.Top.CloseButton:Size(24)
	module.FlightMode.Top.CloseButton:Point('RIGHT', module.FlightMode.Top, 'RIGHT', -6, 0)

	module.FlightMode.Top.CloseButton.img = module.FlightMode.Top.CloseButton:CreateTexture(nil, 'OVERLAY')
	module.FlightMode.Top.CloseButton.img:Point('CENTER')
	module.FlightMode.Top.CloseButton.img:SetTexture('Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\close.tga')
	module.FlightMode.Top.CloseButton.img:SetVertexColor(1, 1, 1, .7)

	module.FlightMode.Top.CloseButton:SetScript('OnEnter', function()
		_G.GameTooltip:SetOwner(module.FlightMode.Top.CloseButton, 'ANCHOR_BOTTOMLEFT', -4, -4)
		_G.GameTooltip:ClearLines()
		_G.GameTooltip:AddLine(L['Exit FlightMode'])
		_G.GameTooltip:Show()

		module.FlightMode.Top.CloseButton.img:SetVertexColor(unpack(E.media.rgbvaluecolor))
	end)

	module.FlightMode.Top.CloseButton:SetScript('OnLeave', function()
		module.FlightMode.Top.CloseButton.img:SetVertexColor(1, 1, 1, .7)
		_G.GameTooltip:Hide()
	end)

	module.FlightMode.Top.CloseButton:SetScript('OnClick', function()
		module:SetFlightMode(false)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
	end)

	module.FlightMode.Panel = CreateFrame('Frame', nil, module.FlightMode, 'BackdropTemplate')
	module.FlightMode.Panel:Point('BOTTOM', E.UIParent, 'BOTTOM', 0, 100)
	module.FlightMode.Panel:Size((GetScreenWidth()/2), 80)
	module.FlightMode.Panel:CreateBackdrop('Transparent')
	module.FlightMode.Panel:SetFrameStrata('FULLSCREEN')
	module.FlightMode.Panel:Styling()

	module.FlightMode.PanelIcon = CreateFrame('Frame', nil, module.FlightMode.Panel, 'BackdropTemplate')
	module.FlightMode.PanelIcon:Size(70)
	module.FlightMode.PanelIcon:Point('CENTER', module.FlightMode.Panel, 'TOP', 0, 0)

	E["frames"][module.FlightMode.Panel] = true
	module.FlightMode.Panel.ignoreFrameTemplates = true
	module.FlightMode.Panel.ignoreBackdropColors = true

	module.FlightMode.PanelIcon.Texture = module.FlightMode.PanelIcon:CreateTexture(nil, 'ARTWORK')
	module.FlightMode.PanelIcon.Texture:Point('TOPLEFT', 2, -2)
	module.FlightMode.PanelIcon.Texture:Point('BOTTOMRIGHT', -2, 2)
	module.FlightMode.PanelIcon.Texture:SetTexture('Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\mUI1.tga')

	module.FlightMode.MERVersion = module.FlightMode.Panel:CreateFontString(nil, 'OVERLAY')
	module.FlightMode.MERVersion:Point('CENTER', module.FlightMode.Panel, 'CENTER', 0, -10)
	module.FlightMode.MERVersion:FontTemplate(nil, 24, 'OUTLINE')
	module.FlightMode.MERVersion:SetText(MER.Title.."|cFF00c0fa"..MER.Version.."|r")


	module:Toggle()
end

MER:RegisterModule(module:GetName())
