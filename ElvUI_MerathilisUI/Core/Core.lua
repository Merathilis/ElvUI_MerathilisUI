local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local _G = _G
local format = string.format
local pairs, select = pairs, select
local pcall = pcall
local tinsert = table.insert

local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local GetAddOnMetadata = C_AddOns.GetAddOnMetadata
local GetBuildInfo = GetBuildInfo
local GetCurrentCombatTextEventInfo = GetCurrentCombatTextEventInfo
local GetMaxLevelForPlayerExpansion = GetMaxLevelForPlayerExpansion
local InCombatLockdown = InCombatLockdown
local GetCVarBool = C_CVar.GetCVarBool
local GetSpecializationInfoForClassID = GetSpecializationInfoForClassID

local C_Timer_NewTimer = C_Timer.NewTimer

local RegisterCVar = C_CVar.RegisterCVar
local SetCVar = C_CVar.SetCVar
local IsEnabled = C_AddOnProfiler.IsEnabled

MER.dummy = function()
	return
end
MER.ElvUIVersion = tonumber(E.version)
MER.RequiredVersion = tonumber(GetAddOnMetadata("ElvUI_MerathilisUI", "X-ElvUIVersion"))

MER.IsRetail = select(4, GetBuildInfo()) >= 100207
MER.IsNewPatch = select(4, GetBuildInfo()) >= 110000 -- 11.0
MER.IsPTR = select(4, GetBuildInfo()) == 102007 -- 10.2.7

MER.Locale = GetLocale()
MER.ChineseLocale = strsub(MER.Locale, 0, 2) == "zh"
MER.MaxLevelForPlayerExpansion = GetMaxLevelForPlayerExpansion()

-- Masque support
MER.MSQ = _G.LibStub("Masque", true)

MER.Logo = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\mUI.tga]]
MER.LogoSmall = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\mUI1.tga]]

MER.ClassColor = _G.RAID_CLASS_COLORS[E.myclass]

MER.LeftButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:230:307|t "
MER.RightButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:333:411|t "
MER.ScrollButton = " |TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:127:204|t "

MER.ProfileVersion = nil
MER.RegisteredModules = {}
MER.Changelog = {}

MER.UseKeyDown = GetCVarBool("ActionButtonUseKeyDown")

-- Config Helper
MER.Values = {
	FontFlags = E.Libs.ACH.FontValues,
}

if not E.Retail then
	E.PopupDialogs.WRONGWOWVERSION = {
		text = MER.Title
			.. L[" does not support this game version, please uninstall it and don't ask for support. Thanks!"],
		--button1 = OKAY,
		timeout = 0,
		whileDead = 1,
		hideOnEscape = false,
	}
	E:StaticPopup_Show("WRONGWOWVERSION")
end

E.PopupDialogs.MERATHILISUI_BUTTON_FIX_RELOAD = {
	text = format(
		"%s\n%s\n\n|cffaaaaaa%s|r",
		format(L["%s detects CVar %s has been changed."], MER.Title, "|cff209ceeActionButtonUseKeyDown|r"),
		L["It will cause some buttons not work properly before UI reloading."],
		format(
			L["You can disable this alert in [%s]-[%s]-[%s]"],
			MER.Title,
			L["Advanced Settings"],
			L["Blizzard Fixes"]
		)
	),
	button1 = L["Reload UI"],
	button2 = _G.CANCEL,
	OnAccept = _G.ReloadUI,
}

_G.BINDING_HEADER_MER = "|cffff7d0aMerathilisUI|r"
for i = 1, 5 do
	_G["BINDING_HEADER_AUTOBUTTONBAR" .. i] = L["Auto Button Bar" .. " " .. i]
	for j = 1, 12 do
		_G[format("BINDING_NAME_CLICK AutoButtonBar%dButton%d:LeftButton", i, j)] = L["Button"] .. " " .. j
	end
end

-- Register own Modules
function MER:RegisterModule(name)
	if not name then
		F.Developer.ThrowError("The name of module is required!")
		return
	end

	if self.initialized then
		self:GetModule(name):Initialize()
	else
		tinsert(self.RegisteredModules, name)
	end
end

function MER:InitializeModules()
	E:UpdateCooldownSettings("all")

	for _, moduleName in pairs(MER.RegisteredModules) do
		local module = self:GetModule(moduleName)
		if module.Initialize then
			pcall(module.Initialize, module)
		end
	end

	self:LoadCommands()

	local function onAllEvents()
		F.Event.ContinueAfterElvUIUpdate(function()
			-- Set initialized
			self.initialized = true
			F.Event.TriggerEvent("MER.Initialized")

			F.Event.RunNextFrame(function()
				self.DelayedWorldEntered = true

				F.Developer.PrintDelayedMessages()
			end, 5)

			F.Event.ContinueOutOfCombat(function()
				self.initializedSafe = true
				F.Event.TriggerEvent("MER.InitializedSafe")
			end)
		end)
	end

	local events = { "PLAYER_ENTERING_WORLD" }
	tinsert(events, "FIRST_FRAME_RENDERED")

	F.Event.ContinueAfterAllEvents(onAllEvents, F.Table.SafeUnpack(events))
end

function MER:UpdateModules()
	self:UpdateScripts()

	for _, moduleName in pairs(self.RegisteredModules) do
		local module = MER:GetModule(moduleName)
		if module.ProfileUpdate then
			pcall(module.ProfileUpdate, module)
		end
	end
end

function MER:AddMoverCategories()
	tinsert(E.ConfigModeLayouts, #E.ConfigModeLayouts + 1, "MERATHILISUI")
	E.ConfigModeLocalizedStrings["MERATHILISUI"] = format("|cffff7d0a%s |r", "MerathilisUI")
end

function MER:CheckElvUIVersion()
	-- ElvUI versions check
	if E.version < 99999 then
		if MER.ElvUIVersion < 1 or (MER.ElvUIVersion < MER.RequiredVersion) then
			E:StaticPopup_Show("VERSION_OUTDATED")
			return false -- If ElvUI Version is outdated stop right here. So things don't get broken.
		elseif MER.ElvUIVersion > MER.RequiredVersion + 0.03 then
			E:StaticPopup_Show("VERSION_MISMATCH")
			return false
		end
	end

	return true
end

function MER:CheckInstalledVersion()
	if InCombatLockdown() then
		return
	end

	if self.showChangeLog then
		E:StaticPopup_Show("MERATHILIS_OPEN_CHANGELOG")
		self.showChangeLog = false
	end
end

function MER:UpdateProfiles(_)
	self:UpdateScripts()

	F.Event.TriggerEvent("MER.DatabaseUpdate")
end

function MER:FixGame()
	local db = E.global.mui.advancedOptions
	if not db then
		return
	end

	-- Button Fix
	if db.cvarAlert then
		self:RegisterEvent("CVAR_UPDATE", function(_, cvar, value)
			if cvar == "ActionButtonUseKeyDown" and MER.UseKeyDown ~= (value == "1") then
				E:StaticPopup_Show("MERATHILISUI_BUTTON_FIX_RELOAD")
			end
		end)
	end

	if db.guildNews then
		-- https://nga.178.com/read.php?tid=42399961
		local newsRequireUpdate, newsTimer
		_G.CommunitiesFrameGuildDetailsFrameNews:SetScript("OnEvent", function(frame, event)
			if event == "GUILD_NEWS_UPDATE" then
				if newsTimer then
					newsRequireUpdate = true
				else
					_G.CommunitiesGuildNewsFrame_OnEvent(frame, event)

					-- After 1 second, if guild news still need to be updated, update again
					newsTimer = C_Timer_NewTimer(1, function()
						if newsRequireUpdate then
							_G.CommunitiesGuildNewsFrame_OnEvent(frame, event)
						end
						newsTimer = nil
					end)
				end
			else
				_G.CommunitiesGuildNewsFrame_OnEvent(frame, event)
			end
		end)
	end

	if db.advancedCLEUEventTrace then
		local function LogEvent(self, event, ...)
			if event == "COMBAT_LOG_EVENT_UNFILTERED" or event == "COMBAT_LOG_EVENT" then
				self:LogEvent_Original(event, CombatLogGetCurrentEventInfo())
			elseif event == "COMBAT_TEXT_UPDATE" then
				self:LogEvent_Original(event, (...), GetCurrentCombatTextEventInfo())
			else
				self:LogEvent_Original(event, ...)
			end
		end

		local function OnEventTraceLoaded()
			EventTrace.LogEvent_Original = EventTrace.LogEvent
			EventTrace.LogEvent = LogEvent
		end

		if EventTrace then
			OnEventTraceLoaded()
		else
			local frame = CreateFrame("Frame")
			frame:RegisterEvent("ADDON_LOADED")
			frame:SetScript("OnEvent", function(self, event, ...)
				if event == "ADDON_LOADED" and (...) == "Blizzard_EventTrace" then
					OnEventTraceLoaded()
					self:UnregisterAllEvents()
				end
			end)
		end
	end
end

MER.SpecializationInfo = {}

MER.RealRegion = (function()
	local region = GetCurrentRegionName()
	if region == "KR" and MER.ChineseLocale then
		region = "TW" -- Fix taiwan server region issue
	end

	return region
end)()

MER.CurrentRealmID = GetRealmID()
MER.CurrentRealmName = GetRealmName()

function MER:InitializeMetadata()
	for classID = 1, 13 do
		local class = {}
		for specIndex = 1, 4 do
			local data = { GetSpecializationInfoForClassID(classID, specIndex) }
			if #data > 0 then
				tinsert(class, { specID = data[1], name = data[2], icon = data[4], role = data[5] })
			end
		end

		tinsert(MER.SpecializationInfo, class)
	end
end
