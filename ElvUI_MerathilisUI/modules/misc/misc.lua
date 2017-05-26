local MER, E, L, V, P, G = unpack(select(2, ...))
local MI = E:NewModule("mUIMisc", "AceHook-3.0", "AceEvent-3.0", "AceConsole-3.0");
MI.modName = L["Misc"]

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

	-- Always show the Text on the PlayerPowerBarAlt
	PlayerPowerBarAlt:HookScript("OnShow", function()
		local statusFrame = PlayerPowerBarAlt.statusFrame
		if statusFrame.enabled then
			statusFrame:Show()
			UnitPowerBarAltStatus_UpdateText(statusFrame)
		end
	end)

	-- Try to fix JoinBattleField taint
	CreateFrame("Frame"):SetScript("OnUpdate", function(self, elapsed)
		if LFRBrowseFrame.timeToClear then
			LFRBrowseFrame.timeToClear = nil
		end
	end)
end

function MI:Initialize()
	self:LoadMisc()
	self:LoadGMOTD()
	self:LoadMailInputBox()
	self:LoadMoverTransparancy()
	self:LoadTST()
	self:LoadsumAuctions()
	self:LoadQuestReward()
end

local function InitializeCallback()
	MI:Initialize()
end

E:RegisterModule(MI:GetName(), InitializeCallback)