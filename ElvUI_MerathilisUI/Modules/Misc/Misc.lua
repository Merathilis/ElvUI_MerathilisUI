local MER, E, _, V, P, G = unpack(select(2, ...))
local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale or 'enUS')
local module = MER:GetModule('MER_Misc')
local S = E:GetModule('Skins')
local LCG = LibStub('LibCustomGlow-1.0')

local _G = _G
local select = select
local collectgarbage = collectgarbage

local CreateFrame = CreateFrame
local C_PetJournalSetFilterChecked = C_PetJournal.SetFilterChecked
local C_PetJournalSetAllPetTypesChecked = C_PetJournal.SetAllPetTypesChecked
local C_PetJournalSetAllPetSourcesChecked = C_PetJournal.SetAllPetSourcesChecked
local GetBattlefieldStatus = GetBattlefieldStatus
local GetCurrentMapDungeonLevel = GetCurrentMapDungeonLevel
local GetCurrentMapAreaID = GetCurrentMapAreaID
local GetLFGDungeonInfo = GetLFGDungeonInfo
local GetLFGDungeonRewards = GetLFGDungeonRewards
local GetLFGRandomDungeonInfo = GetLFGRandomDungeonInfo
local GetMapInfo = GetMapInfo
local GetMaxBattlefieldID = GetMaxBattlefieldID
local GetNumRandomDungeons = GetNumRandomDungeons
local GetNumGroupMembers = GetNumGroupMembers
local GetSpecialization = GetSpecialization
local SetMapByID = SetMapByID
local UnitLevel = UnitLevel
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitSetRole = UnitSetRole
local InCombatLockdown = InCombatLockdown
local PlaySound, PlaySoundFile = PlaySound, PlaySoundFile
local UpdateAddOnMemoryUsage = UpdateAddOnMemoryUsage
local StaticPopupSpecial_Hide = StaticPopupSpecial_Hide

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
	StaticPopupDialogs.RESURRECT.hideOnEscape = nil
	StaticPopupDialogs.AREA_SPIRIT_HEAL.hideOnEscape = nil
	StaticPopupDialogs.PARTY_INVITE.hideOnEscape = nil
	StaticPopupDialogs.CONFIRM_SUMMON.hideOnEscape = nil
	StaticPopupDialogs.ADDON_ACTION_FORBIDDEN.button1 = nil
	StaticPopupDialogs.TOO_MANY_LUA_ERRORS.button1 = nil
	_G["PetBattleQueueReadyFrame"].hideOnEscape = nil
	if (PVPReadyDialog) then
		PVPReadyDialog.leaveButton:Hide()
		PVPReadyDialog.enterButton:ClearAllPoints()
		PVPReadyDialog.enterButton:SetPoint("BOTTOM", PVPReadyDialog, "BOTTOM", 0, 25)
		PVPReadyDialog.label:SetPoint("TOP", 0, -22)
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

function module:WorldQuestStuff()
	if not E.private.actionbar.enable then return end

	local r, g, b = unpack(E.media.rgbvaluecolor)
	local color = {r, g, b, 1}

	local hasFound
	local function ResetActionButtons()
		if not hasFound then return end
		for i = 1, 3 do
			LCG.PixelGlow_Stop(_G["ActionButton"..i])
		end
		hasFound = nil
	end

	MER:RegisterEvent("CHAT_MSG_MONSTER_SAY", function(_, msg)
		if not GetOverrideBarSkin() or not C_QuestLog.GetLogIndexForQuestID(59585) then
			ResetActionButtons()
			return
		end

		msg = gsub(msg, "[.%.]", "")

		for i = 1, 3 do
			local button = _G["ActionButton"..i]
			local _, spellID = GetActionInfo(button.action)
			local name = spellID and GetSpellInfo(spellID)
			if name and name == msg then
				LCG.PixelGlow_Start(button, color, nil, 0.5, nil, 1)
			else
				LCG.PixelGlow_Stop(button)
			end
		end

		hasFound = true
	end)
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
	self:WorldQuestStuff() -- in testing
end

MER:RegisterModule(module:GetName())
