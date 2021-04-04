local MER, E, _, V, P, G = unpack(select(2, ...))
local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale or 'enUS')
local module = MER:GetModule('MER_Misc')
local S = E:GetModule('Skins')

local _G = _G
local pairs, select = pairs, select
local twipe = table.wipe
local tinsert = table.insert
local strfind = string.find
local gsub = gsub
local collectgarbage = collectgarbage

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local C_FriendList_GetNumWhoResults = C_FriendList.GetNumWhoResults
local C_FriendList_GetWhoInfo = C_FriendList.GetWhoInfo
local C_PetJournalSetFilterChecked = C_PetJournal.SetFilterChecked
local C_PetJournalSetAllPetTypesChecked = C_PetJournal.SetAllPetTypesChecked
local C_PetJournalSetAllPetSourcesChecked = C_PetJournal.SetAllPetSourcesChecked
local GetBattlefieldStatus = GetBattlefieldStatus
local GetCurrentMapDungeonLevel = GetCurrentMapDungeonLevel
local GetCurrentMapAreaID = GetCurrentMapAreaID
local GetGuildInfo = GetGuildInfo
local GetQuestDifficultyColor = GetQuestDifficultyColor
local GetLFGDungeonInfo = GetLFGDungeonInfo
local GetLFGDungeonRewards = GetLFGDungeonRewards
local GetLFGRandomDungeonInfo = GetLFGRandomDungeonInfo
local GetMapInfo = GetMapInfo
local GetMaxBattlefieldID = GetMaxBattlefieldID
local GetNumRandomDungeons = GetNumRandomDungeons
local GetNumGroupMembers = GetNumGroupMembers
local GetRealZoneText = GetRealZoneText
local GetSpecialization = GetSpecialization
local SetMapByID = SetMapByID
local UnitLevel = UnitLevel
local UnitRace = UnitRace
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitSetRole = UnitSetRole
local InCombatLockdown = InCombatLockdown
local PlaySound, PlaySoundFile = PlaySound, PlaySoundFile
local UpdateAddOnMemoryUsage = UpdateAddOnMemoryUsage
local StaticPopupSpecial_Hide = StaticPopupSpecial_Hide
local HybridScrollFrame_GetOffset = HybridScrollFrame_GetOffset
local LFDQueueFrame_SetType = LFDQueueFrame_SetType
local UIDropDownMenu_GetSelectedID = UIDropDownMenu_GetSelectedID
local SOUNDKIT = SOUNDKIT
local RaidNotice_AddMessage = RaidNotice_AddMessage

function module:LoadMisc()
	-- Force readycheck warning
	local ShowReadyCheckHook = function(_, initiator)
		if initiator ~= "player" then
			PlaySound(SOUNDKIT.READY_CHECK or 8960)
		end
	end
	hooksecurefunc("ShowReadyCheck", ShowReadyCheckHook)

	-- Force other warning
	local ForceWarning = CreateFrame("Frame")
	ForceWarning:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
	ForceWarning:RegisterEvent("PET_BATTLE_QUEUE_PROPOSE_MATCH")
	ForceWarning:RegisterEvent("LFG_PROPOSAL_SHOW")
	ForceWarning:SetScript("OnEvent", function(_, event)
		if event == "UPDATE_BATTLEFIELD_STATUS" then
			for i = 1, GetMaxBattlefieldID() do
				local status = GetBattlefieldStatus(i)
				if status == "confirm" then
					PlaySound(SOUNDKIT.UI_PET_BATTLES_PVP_THROUGH_QUEUE or 36609)
					break
				end
				i = i + 1
			end
		elseif event == "PET_BATTLE_QUEUE_PROPOSE_MATCH" then
			PlaySound(SOUNDKIT.UI_PET_BATTLES_PVP_THROUGH_QUEUE or 36609)
		elseif event == "LFG_PROPOSAL_SHOW" then
			PlaySound(SOUNDKIT.READY_CHECK or 8960)
		end
	end)

	-- Misclicks for some popups
	_G.StaticPopupDialogs.RESURRECT.hideOnEscape = nil
	_G.StaticPopupDialogs.AREA_SPIRIT_HEAL.hideOnEscape = nil
	_G.StaticPopupDialogs.PARTY_INVITE.hideOnEscape = nil
	_G.StaticPopupDialogs.CONFIRM_SUMMON.hideOnEscape = nil
	_G.StaticPopupDialogs.ADDON_ACTION_FORBIDDEN.button1 = nil
	_G.StaticPopupDialogs.TOO_MANY_LUA_ERRORS.button1 = nil
	_G["PetBattleQueueReadyFrame"].hideOnEscape = nil
	if (_G.PVPReadyDialog) then
		_G.PVPReadyDialog.leaveButton:Hide()
		_G.PVPReadyDialog.enterButton:ClearAllPoints()
		_G.PVPReadyDialog.enterButton:SetPoint("BOTTOM", _G.PVPReadyDialog, "BOTTOM", 0, 25)
		_G.PVPReadyDialog.label:SetPoint("TOP", 0, -22)
	end

	-- Auto select current event boss from LFD tool(EventBossAutoSelect by Nathanyel)
	local firstLFD
	_G["LFDParentFrame"]:HookScript("OnShow", function()
		if not firstLFD then
			firstLFD = 1
			for i = 1, GetNumRandomDungeons() do
				local id = GetLFGRandomDungeonInfo(i)
				local isHoliday = select(15, GetLFGDungeonInfo(id))
				if isHoliday and not GetLFGDungeonRewards(id) then
					LFDQueueFrame_SetType(id)
				end
			end
		end
	end)
end

function module:SetRole()
	local spec = GetSpecialization()
	if UnitLevel("player") >= 10 and not InCombatLockdown() then
		if spec == nil and UnitGroupRolesAssigned("player") ~= "NONE" then
			UnitSetRole("player", "NONE")
		elseif spec ~= nil then
			if GetNumGroupMembers() > 0 then
				if UnitGroupRolesAssigned("player") ~= E:GetPlayerRole() then
					UnitSetRole("player", E:GetPlayerRole())
				end
			end
		end
	end
end

-- Colors
local function classColor(class, showRGB)
	local color = MER.ClassColors[E.UnlocalizedClasses[class] or class]
	if not color then color = E.UnlocalizedClasses['PRIEST'] end

	if showRGB then
		return color.r, color.g, color.b
	else
		return '|c'..color.colorStr
	end
end

local function diffColor(level)
	return MER:RGBToHex(GetQuestDifficultyColor(level))
end

local blizzHexColors = {}
for class, color in pairs(RAID_CLASS_COLORS) do
	blizzHexColors[color.colorStr] = class
end

-- Whoframe
local columnTable = {}
local function UpdateWhoList()
	local scrollFrame = _G.WhoListScrollFrame
	local offset = HybridScrollFrame_GetOffset(scrollFrame)
	local buttons = scrollFrame.buttons
	local numButtons = #buttons
	local numWhos = C_FriendList_GetNumWhoResults()

	local playerZone = GetRealZoneText()
	local playerGuild = GetGuildInfo('player')
	local playerRace = UnitRace('player')

	for i = 1, numButtons do
		local button = buttons[i]
		local index = offset + i
		if index <= numWhos then
			local nameText = button.Name
			local levelText = button.Level
			local variableText = button.Variable

			local info = C_FriendList_GetWhoInfo(index)
			local guild, level, race, zone, class = info.fullGuildName, info.level, info.raceStr, info.area, info.filename
			if zone == playerZone then zone = '|cff00ff00'..zone end
			if guild == playerGuild then guild = '|cff00ff00'..guild end
			if race == playerRace then race = '|cff00ff00'..race end

			twipe(columnTable)
			tinsert(columnTable, zone)
			tinsert(columnTable, guild)
			tinsert(columnTable, race)

			nameText:SetTextColor(classColor(class, true))
			levelText:SetText(diffColor(level)..level)
			variableText:SetText(columnTable[UIDropDownMenu_GetSelectedID(_G.WhoFrameDropDown)])
		end
	end
end

-- FrameXML/RaidWarning.lua
do
	local AddMessage = RaidNotice_AddMessage
	RaidNotice_AddMessage = function(frame, message, ...)
		if strfind(message, '|cff') then
			for hex, class in pairs(blizzHexColors) do
				local color = MER.ClassColors[class]
				message = gsub(message, hex, color.colorStr)
			end
		end
		return AddMessage(frame, message, ...)
	end
end

function module:Initialize()
	local db = E.db.mui.misc
	MER:RegisterDB(self, "misc")

	E.RegisterCallback(module, "RoleChanged", "SetRole")
	self:RegisterEvent("GROUP_ROSTER_UPDATE", "SetRole")
	_G.RolePollPopup:SetScript("OnShow", function() StaticPopupSpecial_Hide(_G.RolePollPopup) end)

	self:LoadMisc()
	self:LoadGMOTD()
	self:LoadQuest()
	self:LoadnameHover()
	self:ItemLevel()
	self:AddAlerts()
	self:ReputationInit()
	self:WowHeadLinks()
	self:SplashScreen()
	self:CreateMawWidgetFrame()

	hooksecurefunc('WhoList_Update', UpdateWhoList)
	hooksecurefunc(_G.WhoListScrollFrame, 'update', UpdateWhoList)
end

MER:RegisterModule(module:GetName())
