local E, L, V, P, G = unpack(ElvUI);
local MI = E:NewModule("mUIMisc", "AceHook-3.0", "AceEvent-3.0");

E.mUIMisc = MI;

-- Cache global variables
-- Lua functions
local _G = _G
local select = select
-- WoW API / Variables
local CreateFrame = CreateFrame
local GetBattlefieldStatus = GetBattlefieldStatus
local GetLFGDungeonInfo = GetLFGDungeonInfo
local GetLFGDungeonRewards = GetLFGDungeonRewards
local GetLFGRandomDungeonInfo = GetLFGRandomDungeonInfo
local GetMaxBattlefieldID = GetMaxBattlefieldID
local GetNumRandomDungeons = GetNumRandomDungeons
local PlaySound, PlaySoundFile = PlaySound, PlaySoundFile

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: LFDQueueFrame_SetType, IDLE_MESSAGE, ForceQuit

function MI:LoadMisc()
	-- Force readycheck warning
	local ShowReadyCheckHook = function(_, initiator)
		if initiator ~= "player" then
			PlaySound("ReadyCheck", "Master")
		end
	end
	hooksecurefunc("ShowReadyCheck", ShowReadyCheckHook)

	-- Force other warning
	local ForceWarning = CreateFrame("Frame")
	ForceWarning:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
	ForceWarning:RegisterEvent("PET_BATTLE_QUEUE_PROPOSE_MATCH")
	ForceWarning:RegisterEvent("LFG_PROPOSAL_SHOW")
	ForceWarning:RegisterEvent("RESURRECT_REQUEST")
	ForceWarning:SetScript("OnEvent", function(_, event)
		if event == "UPDATE_BATTLEFIELD_STATUS" then
			for i = 1, GetMaxBattlefieldID() do
				local status = GetBattlefieldStatus(i)
				if status == "confirm" then
					PlaySound("PVPTHROUGHQUEUE", "Master")
					break
				end
				i = i + 1
			end
		elseif event == "PET_BATTLE_QUEUE_PROPOSE_MATCH" then
			PlaySound("PVPTHROUGHQUEUE", "Master")
		elseif event == "LFG_PROPOSAL_SHOW" then
			PlaySound("ReadyCheck", "Master")
		elseif event == "RESURRECT_REQUEST" then
			PlaySoundFile("Sound\\Spells\\Resurrection.wav", "Master")
		end
	end)

	-- Misclicks for some popups
	StaticPopupDialogs.RESURRECT.hideOnEscape = nil
	StaticPopupDialogs.AREA_SPIRIT_HEAL.hideOnEscape = nil
	StaticPopupDialogs.PARTY_INVITE.hideOnEscape = nil
	StaticPopupDialogs.CONFIRM_SUMMON.hideOnEscape = nil
	StaticPopupDialogs.ADDON_ACTION_FORBIDDEN.button1 = nil
	StaticPopupDialogs.TOO_MANY_LUA_ERRORS.button1 = nil
	PetBattleQueueReadyFrame.hideOnEscape = nil
	PVPReadyDialog.leaveButton:Hide()
	PVPReadyDialog.enterButton:ClearAllPoints()
	PVPReadyDialog.enterButton:SetPoint("BOTTOM", PVPReadyDialog, "BOTTOM", 0, 25)

	-- Auto select current event boss from LFD tool(EventBossAutoSelect by Nathanyel)
	local firstLFD
	LFDParentFrame:HookScript("OnShow", function()
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

	-- Force quit
	local CloseWoW = CreateFrame("Frame")
	CloseWoW:RegisterEvent("CHAT_MSG_SYSTEM")
	CloseWoW:SetScript("OnEvent", function(_, event, msg)
		if event == "CHAT_MSG_SYSTEM" then
			if msg and msg == IDLE_MESSAGE then
				ForceQuit()
			end
		end
	end)

	-- Display combat state changes
	local CombatState = CreateFrame("Frame")
	CombatState:RegisterEvent("PLAYER_REGEN_ENABLED")
	CombatState:RegisterEvent("PLAYER_REGEN_DISABLED")
	CombatState:SetScript("OnEvent", function(self, event)
		if not E.db.mui.general.CombatState then return end
		if event == "PLAYER_REGEN_DISABLED" then
			UIErrorsFrame:AddMessage("+ " .. COMBAT, 255, 0, 0)
		elseif event == "PLAYER_REGEN_ENABLED" then
			UIErrorsFrame:AddMessage("- " .. COMBAT, 0, 255, 0)
		end
	end)
end

function MI:Initialize()
	self:LoadMisc()
	self:LoadGameMenu()
	self:LoadGMOTD()
	self:LoadMailInputBox()
	self:LoadMerchant()
	self:LoadMoverTransparancy()
	self:LoadQuestReward()
	self:LoadTST()
	self:LoadsumAuctions()
	self:LoadVignette()
end

E:RegisterModule(MI:GetName())