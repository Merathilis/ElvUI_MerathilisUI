local E, L, V, P, G, _ = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

-- Quest Rewards
local QuestReward = CreateFrame("Frame")
QuestReward:SetScript("OnEvent", function(self, event, ...) self[event](...) end)

local metatable = {
	__call = function(methods, ...)
		for _, method in next, methods do method(...) end
	end
}

local modifier = false
function QuestReward:Register(event, method, override)
	local newmethod
	local methods = self[event]

	if methods then
		self[event] = setmetatable({methods, newmethod or method}, metatable)
	else
		self[event] = newmethod or method
		self:RegisterEvent(event)
	end
end

local cashRewards = {
	[45724] = 1e5, -- Champion's Purse
	[64491] = 2e6, -- Royal Reward
}

QuestReward:Register("QUEST_COMPLETE", function()
	local choices = GetNumQuestChoices()
	if choices > 1 then
		local bestValue, bestIndex = 0

		for index = 1, choices do
			local link = GetQuestItemLink("choice", index)
			if link then
				local _, _, _, _, _, _, _, _, _, _, value = GetItemInfo(link)
				value = cashRewards[tonumber(string.match(link, "item:(%d+):"))] or value

				if value > bestValue then bestValue, bestIndex = value, index end
			else
				choiceQueue = "QUEST_COMPLETE"
				return GetQuestItemInfo("choice", index)
			end
		end

		if bestIndex then QuestInfoItem_OnClick(QuestInfoRewardsFrame.RewardButtons[bestIndex]) end
	end
end, true)

-- Fixes for Blizzard issues
hooksecurefunc("StaticPopup_Show", function(which)
	if which == "DEATH" and not UnitIsDeadOrGhost("player") then StaticPopup_Hide("DEATH") end
end)

local function FixTradeSkillReagents()
	local function TradeSkillReagent_OnClick(self)
		if IsModifiedClick() then
			local link, name = GetTradeSkillReagentItemLink(TradeSkillFrame.selectedSkill, self:GetID())
			if not link then
				name, link = GameTooltip:GetItem()
				if name == self.name:GetText() then HandleModifiedItemClick(link) end
			end
		end
	end
	
	for i = 1, 8 do _G["TradeSkillReagent"..i]:HookScript("OnClick", TradeSkillReagent_OnClick) end
end

if TradeSkillReagent1 then
	FixTradeSkillReagents()
else
	local f = CreateFrame("Frame")
	f:RegisterEvent("ADDON_LOADED")
	f:SetScript("OnEvent", function(f, e, a)
		if a == "Blizzard_TradeSkillUI" then
			FixTradeSkillReagents()
			f:UnregisterAllEvents()
			f:SetScript("OnEvent", nil)
		end
	end)
end

-- Taintfix for Talents & gylphs
local function hook()
	PlayerTalentFrame_Toggle = function()
	if not PlayerTalentFrame:IsShown() then
		ShowUIPanel(PlayerTalentFrame)
		TalentMicroButtonAlert:Hide()
	else
		PlayerTalentFrame_Close()
	end 
end

for i = 1, 10 do
	local tab = _G["PlayerTalentFrameTab"..i]
	if not tab then break end
		tab:SetScript("PreClick", function()
			for index = 1, STATICPOPUP_NUMDIALOGS, 1 do
				local frame = _G["StaticPopup"..index]
				if not issecurevariable(frame, "which") then
					local info = StaticPopupDialogs[frame.which]
					if (frame:IsShown() and info) and not issecurevariable(info, "OnCancel") then info.OnCancel() end
					frame:Hide()
					frame.which = nil
				end
			end
		end)
	end
end

if IsAddOnLoaded("Blizzard_TalentUI") then
	hook()
else
	local f = CreateFrame("Frame")
	f:RegisterEvent("ADDON_LOADED")
	f:SetScript("OnEvent", function(self, event, addon)
		if addon=="Blizzard_TalentUI" then 
			self:UnregisterEvent("ADDON_LOADED")
			hook()
		end
	end)
end

-- RaidInfoBugfix
function RaidInfoFrame_Update(scrollToSelected)
	RaidInfoFrame_UpdateSelectedIndex();
	
	local scrollFrame = RaidInfoScrollFrame;
	local savedInstances = GetNumSavedInstances();
	local savedWorldBosses = GetNumSavedWorldBosses();
	local instanceName, instanceID, instanceReset, instanceDifficulty, locked, extended, instanceIDMostSig, isRaid, maxPlayers, difficultyName;
	local frameName, frameNameText, frameID, frameReset, width;
	local offset = HybridScrollFrame_GetOffset(scrollFrame);
	local buttons = scrollFrame.buttons;
	local numButtons = #buttons;
	local buttonHeight = buttons[1]:GetHeight();
	
	if ( scrollToSelected == true and RaidInfoFrame.selectedIndex ) then --Using == true in case the HybridScrollFrame .update is changed to pass in the parent.
		local button = buttons[RaidInfoFrame.selectedIndex - offset]
		if ( not button or (button:GetTop() > scrollFrame:GetTop()) or (button:GetBottom() < scrollFrame:GetBottom()) ) then
			local scrollFrame = RaidInfoScrollFrame;
			local buttonHeight = scrollFrame.buttons[1]:GetHeight();
			local scrollValue = min(((RaidInfoFrame.selectedIndex - 1) * buttonHeight), scrollFrame.range)
			if ( scrollValue ~= scrollFrame.scrollBar:GetValue() ) then
				scrollFrame.scrollBar:SetValue(scrollValue);
			end
		end
	end

	offset = HybridScrollFrame_GetOffset(scrollFrame);	--May have changed in the previous section to move selected parts into view.

	local mouseIsOverScrollFrame = scrollFrame:IsVisible() and scrollFrame:IsMouseOver();

	for i=1, numButtons do
		local frame = buttons[i];
		local index = i + offset;

		if ( index <= savedInstances + savedWorldBosses) then
			if (index <= savedInstances) then
				instanceName, instanceID, instanceReset, instanceDifficulty, locked, extended, instanceIDMostSig, isRaid, maxPlayers, difficultyName = GetSavedInstanceInfo(index);
				frame.worldBossID = nil;
				frame.instanceID = instanceID;
				--frame.longInstanceID = string.format("%x%x", instanceIDMostSig, instanceID);
				frame.longInstanceID = instanceIDMostSig .. '.' .. instanceID
			else
				instanceName, instanceID, instanceReset = GetSavedWorldBossInfo(index - savedInstances);
				locked = true;
				extended = false;
				difficultyName = RAID_INFO_WORLD_BOSS;
				frame.worldBossID = instanceID;
				frame.instanceID = nil;
				frame.longInstanceID = nil;
			end
			
			frame:SetID(index);

			if ( RaidInfoFrame.selectedIndex == index ) then
				frame:LockHighlight();
			else
				frame:UnlockHighlight();
			end

			frame.difficulty:SetText(difficultyName);

			if ( extended or locked ) then
				frame.reset:SetText(SecondsToTime(instanceReset, true, nil, 3));
				frame.name:SetText(instanceName);
			else
				frame.reset:SetFormattedText("|cff808080%s|r", RAID_INSTANCE_EXPIRES_EXPIRED);
				frame.name:SetFormattedText("|cff808080%s|r", instanceName);
			end
			
			if ( extended ) then
				frame.extended:Show();
			else
				frame.extended:Hide();
			end
			
			frame:Show();
			
			if ( mouseIsOverScrollFrame and frame:IsMouseOver() ) then
				RaidInfoInstance_OnEnter(frame);
			end
		else
			frame:Hide();
		end	
	end
	HybridScrollFrame_Update(scrollFrame, (savedInstances + savedWorldBosses) * buttonHeight, scrollFrame:GetHeight());
end

function RaidInfoFrame_UpdateSelectedIndex()
	if (RaidInfoFrame.selectedRaidID) then
		local savedInstances = GetNumSavedInstances();
		for index=1, savedInstances do
			local instanceName, instanceID, instanceReset, instanceDifficulty, locked, extended, instanceIDMostSig = GetSavedInstanceInfo(index);
			if ( (instanceIDMostSig .. '.' .. instanceID) == RaidInfoFrame.selectedRaidID ) then
				RaidInfoFrame.selectedIndex = index;
				RaidInfoExtendButton:Enable();
				if ( extended ) then
					RaidInfoExtendButton.doExtend = false;
					RaidInfoExtendButton:SetText(UNEXTEND_RAID_LOCK);
				else
					RaidInfoExtendButton.doExtend = true;
					if ( locked ) then
						RaidInfoExtendButton:SetText(EXTEND_RAID_LOCK);
					else
						RaidInfoExtendButton:SetText(REACTIVATE_RAID_LOCK);
					end
				end
				return;
			end
		end
	elseif (RaidInfoFrame.selectedWorldBossID) then
		local savedInstances = GetNumSavedWorldBosses();
		for index=1, savedInstances do
			local _, worldBossID, _ = GetSavedWorldBossInfo(index);
			if (worldBossID == RaidInfoFrame.selectedWorldBossID) then
				RaidInfoExtendButton:SetText(EXTEND_RAID_LOCK);
				RaidInfoExtendButton:Disable();
				RaidInfoFrame.selectedIndex = index + GetNumSavedInstances();
				return;
			end
		end
	end
	RaidInfoFrame.selectedIndex = nil;
	RaidInfoExtendButton:Disable();
end

RaidInfoScrollFrame.update = RaidInfoFrame_Update
RaidInfoScrollFrame:SetScript('OnShow', RaidInfoFrame_Update)
RaidInfoFrame_Update()

-- Automatic achievement screenshot
if IsAddOnLoaded('ElvUI') then
	local function TakeScreen(delay, func, ...)
		local waitTable = {}
		local waitFrame = CreateFrame("Frame", "WaitFrame", UIParent)
		waitFrame:SetScript("onUpdate", function (self, elapse)
			local count = #waitTable
			local i = 1
			while (i <= count) do
				local waitRecord = tremove(waitTable, i)
				local d = tremove(waitRecord, 1)
				local f = tremove(waitRecord, 1)
				local p = tremove(waitRecord, 1)
				if d > elapse then
					tinsert(waitTable, i, {d-elapse, f, p})
					i = i + 1
				else
					count = count - 1
					f(unpack(p))
				end
			end
		end)
		tinsert(waitTable, {delay, func, {...}})
	end

	local function OnEvent(...) TakeScreen(1, Screenshot) end

	local frame = CreateFrame("Frame")
	frame:RegisterEvent("ACHIEVEMENT_EARNED")
	frame:SetScript("OnEvent", OnEvent)
end

-- Hide header art & restyle text(From DuffedUI)
if IsAddOnLoaded("Blizzard_ObjectiveTracker") then
	hooksecurefunc("ObjectiveTracker_Update", function(reason, id)
		if ObjectiveTrackerFrame.MODULES then
			for i = 1, #ObjectiveTrackerFrame.MODULES do
				ObjectiveTrackerFrame.MODULES[i].Header.Background:SetAtlas(nil)
				ObjectiveTrackerFrame.MODULES[i].Header.Text:SetFont(STANDARD_TEXT_FONT, 15)
				ObjectiveTrackerFrame.MODULES[i].Header.Text:ClearAllPoints()
				ObjectiveTrackerFrame.MODULES[i].Header.Text:SetPoint("RIGHT", ObjectiveTrackerFrame.MODULES[i].Header, -62, 0)
				ObjectiveTrackerFrame.MODULES[i].Header.Text:SetJustifyH("LEFT")
			end
		end
	end)
end

-- Force readycheck warning
local ShowReadyCheckHook = function(self, initiator)
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
ForceWarning:SetScript("OnEvent", function(self, event)
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
StaticPopupDialogs.PARTY_INVITE_XREALM.hideOnEscape = nil
StaticPopupDialogs.CONFIRM_SUMMON.hideOnEscape = nil
StaticPopupDialogs.ADDON_ACTION_FORBIDDEN.button1 = nil
StaticPopupDialogs.TOO_MANY_LUA_ERRORS.button1 = nil
PetBattleQueueReadyFrame.hideOnEscape = nil
PVPReadyDialog.leaveButton:Hide()
PVPReadyDialog.enterButton:ClearAllPoints()
PVPReadyDialog.enterButton:SetPoint("BOTTOM", PVPReadyDialog, "BOTTOM", 0, 25)

-- Auto select current event boss from LFD tool(EventBossAutoSelect by Nathanyel)
LFDParentFrame:HookScript("OnShow",function()
	for i=1,GetNumRandomDungeons() do
		local id,name=GetLFGRandomDungeonInfo(i)
		local isHoliday=select(15,GetLFGDungeonInfo(id))
		if(isHoliday and not GetLFGDungeonRewards(id)) then LFDQueueFrame_SetType(id) end
	end
end)
