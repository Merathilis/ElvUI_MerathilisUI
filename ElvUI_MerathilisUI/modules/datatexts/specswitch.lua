local E, L, V, P, G = unpack(ElvUI);
local DT = E:GetModule('DataTexts')

-- Cache global variables
-- Lua functions
local _G = _G
local select = select
local twipe = table.wipe
local format = string.format
local join = string.join
-- WoW API / Variables
local GetActiveSpecGroup = GetActiveSpecGroup
local GetNumEquipmentSets = GetNumEquipmentSets
local GetSpecialization = GetSpecialization
local GetEquipmentSetInfo = GetEquipmentSetInfo
local UseEquipmentSet = UseEquipmentSet
local GetSpecializationInfo = GetSpecializationInfo
local SetLootSpecialization = SetLootSpecialization
local GetNumSpecGroups = GetNumSpecGroups
local GetSpecializationInfoByID = GetSpecializationInfoByID
local GetLootSpecialization = GetLootSpecialization
local CreateFrame = CreateFrame
local SELECT_LOOT_SPECIALIZATION = SELECT_LOOT_SPECIALIZATION
local LOOT_SPECIALIZATION_DEFAULT = LOOT_SPECIALIZATION_DEFAULT
local InCombatLockdown = InCombatLockdown
local IsShiftKeyDown = IsShiftKeyDown
local LoadAddOn = LoadAddOn

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: LOOT, SPECIALIZATION, EasyMenu, SpecButton_OnClick, PlayerTalentFrame
-- GLOBALS: PlayerTalentFrameSpecializationLearnButton, ShowUIPanel, HideUIPanel
-- GLOBALS: StaticPopup_Show

local lastPanel, active
local displayString = '';
local talent = {}
local activeString = join("", "|cff00FF00" , ACTIVE_PETS, "|r")
local inactiveString = join("", "|cffFF0000", FACTION_INACTIVE, "|r")

local menuFrame = CreateFrame("Frame", "LootSpecializationDatatextClickMenu", E.UIParent, "UIDropDownMenuTemplate")

local function specializationClick(self, specialization)
	_G["CloseDropDownMenus"]()
	SetLootSpecialization(specialization)
end

local function setClick(self,set)
	_G["CloseDropDownMenus"]()
	UseEquipmentSet(set)
end

local menuList = {
	{ notCheckable = false, func = specializationClick, arg1=0, checked = false},
	{ notCheckable = false },
	{ notCheckable = false },
	{ notCheckable = false },
	{ notCheckable = false }
}

local specList = {
	{ text = SPECIALIZATION, isTitle = true, notCheckable = true },
	{ notCheckable = true },
	{ notCheckable = true },
	{ notCheckable = true },
	{ notCheckable = true },
}

local setList = {}

local menu = {
	{ text = OPTIONS_MENU, isTitle = true, notCheckable = true},
	{ text = SELECT_LOOT_SPECIALIZATION, hasArrow = true, notCheckable = true,
		menuList = menuList,
	},
	{ text = _G.BAG_FILTER_EQUIPMENT, hasArrow = true, notCheckable = true,
		menuList = setList,
	},
}

local function OnEvent(self, event)
	lastPanel = self
	
	local specIndex = GetSpecialization();
	if not specIndex then
		self.text:SetText('N/A')
		return
	end
	
	active = GetActiveSpecGroup()
	
	local talent, loot = '', ''
	local i = GetSpecialization(false, false, active)
	if i then
		i = select(4, GetSpecializationInfo(i))
		if(i) then
			talent = format('|T%s:14:14:0:0:64:64:4:60:4:60|t', i)
		end
	end
	
	local specialization = GetLootSpecialization()
	if specialization == 0 then
		local specIndex = GetSpecialization();
		
		if specIndex then
			local specID, _, _, texture = GetSpecializationInfo(specIndex);
			if texture then
				loot = format('|T%s:14:14:0:0:64:64:4:60:4:60|t', texture)
			else
				loot = 'N/A'
			end
		else
			loot = 'N/A'
		end
	else
		local specID, _, _, texture = GetSpecializationInfoByID(specialization);
		if specID then
			loot = format('|T%s:14:14:0:0:64:64:4:60:4:60|t', texture)
		else
			loot = 'N/A'
		end
	end
	
	self.text:SetFormattedText('%s: %s %s: %s', L["Spec"], talent, LOOT, loot)
end

local function OnEnter(self)
	if not InCombatLockdown() then
		DT:SetupTooltip(self)
		
		DT.tooltip:AddLine(format('|cffFFFFFF%s:|r', SPECIALIZATION))
		for i = 1, GetNumSpecGroups() do
			if GetSpecialization(false, false, i) then
				local specID, name, _, texture = GetSpecializationInfo(GetSpecialization(false, false, i));
				local icon = format('|T%s:14:14:0:0:64:64:4:60:4:60|t', texture)
				DT.tooltip:AddDoubleLine( format("%s %s", icon, name), ( i == active and activeString or inactiveString) )
			end
		end
		
		DT.tooltip:AddLine(' ')
		local specialization = GetLootSpecialization()
		if specialization == 0 then
			local specIndex = GetSpecialization();
			
			if specIndex then
				local specID, name, _, texture = GetSpecializationInfo(specIndex);
				local icon = format('|T%s:14:14:0:0:64:64:4:60:4:60|t', texture)
				DT.tooltip:AddLine(format('|cffFFFFFF%s:|r', SELECT_LOOT_SPECIALIZATION))
				DT.tooltip:AddLine(format(join("", "%s ", LOOT_SPECIALIZATION_DEFAULT), icon, name))
			end
		else
			local specID, name, _, texture = GetSpecializationInfoByID(specialization);
			if specID then
				local icon = format('|T%s:14:14:0:0:64:64:4:60:4:60|t', texture)
				DT.tooltip:AddLine(format('|cffFFFFFF%s:|r' , SELECT_LOOT_SPECIALIZATION))
				DT.tooltip:AddLine(format('%s %s', icon, name))
			end
		end
		
		if GetNumEquipmentSets() > 0 then
			DT.tooltip:AddLine(' ')
			DT.tooltip:AddLine(join("", "|cffFFFFFF" , _G.BAG_FILTER_EQUIPMENT, ":|r"))
			
			for i = 1, GetNumEquipmentSets() do
				local name, texture, _, isEquipped, _, _, _, _, _ = GetEquipmentSetInfo(i)
				local icon = format('|T%s:14:14:0:0:64:64:4:60:4:60|t', texture or "")
				DT.tooltip:AddDoubleLine(format('%s %s', icon, name), (isEquipped and activeString or inactiveString))
			end
			
		end
		
		DT.tooltip:AddLine(' ')
		DT.tooltip:AddLine(L["|cffFFFFFFLeft Click:|r Change Talent Specialization"])
		DT.tooltip:AddLine(L["|cffFFFFFFShift + Click:|r Show Talent Specialization UI"]) -- should be translated in ElvUI
		DT.tooltip:AddLine(L["|cffFFFFFFRight Click:|r Change Loot Specialization"])
		
		DT.tooltip:Show()
	end
end

local function SetSpec(id)
	local spec = _G["PlayerTalentFrameSpecializationSpecButton"..id]
	SpecButton_OnClick(spec)
	local learn = PlayerTalentFrameSpecializationLearnButton

	StaticPopup_Show("CONFIRM_LEARN_SPEC", nil, nil, learn:GetParent())
end

local function OnClick(self, button)
	local lootSpecialization = GetLootSpecialization()
	_G["lootSpecializationName"] = select(2,GetSpecializationInfoByID(lootSpecialization))
	
	local specIndex = GetSpecialization();
	if not specIndex then return end
	
	if button == "LeftButton" then
		DT.tooltip:Hide()
		if not PlayerTalentFrame then
			LoadAddOn("Blizzard_TalentUI")
		end
		
		if IsShiftKeyDown() then 
			if not PlayerTalentFrame:IsShown() then
				ShowUIPanel(PlayerTalentFrame)
			else
				HideUIPanel(PlayerTalentFrame)
			end
		else
			for index = 1, 4 do
				local id, name, _, texture = GetSpecializationInfo(index);
				if ( id ) then
					specList[index + 1].text = format('|T%s:14:14:0:0:64:64:4:60:4:60|t  %s', texture, name)
					specList[index + 1].func = function() SetSpec(index) end
				else
					specList[index + 1] = nil
				end
			end
			EasyMenu(specList, menuFrame, "cursor", -15, -7, "MENU", 2)
		end
	else
		DT.tooltip:Hide()
		local specID, specName, _, texture = GetSpecializationInfo(specIndex);
		local icon = format('|T%s:14:14:0:0:64:64:4:60:4:60|t', texture)
		menuList[1].text = join("", icon, " ", format(LOOT_SPECIALIZATION_DEFAULT, specName));
		menuList[1].notCheckable = false
		menuList[1].checked = (lootSpecialization == 0 and true or false)
		
		for index = 1, 4 do
			local id, name, _, texture = GetSpecializationInfo(index);
			if ( id ) then
				local icon = format('|T%s:14:14:0:0:64:64:4:60:4:60|t', texture or "")
				menuList[index + 1].text = join("",icon," ", name)
				menuList[index + 1].func = specializationClick
				menuList[index + 1].arg1 = id
				menuList[index + 1].notCheckable = false
				menuList[index + 1].checked = (name == _G["lootSpecializationName"] and true or false)
			else
				menuList[index + 1] = nil
			end
		end
		
		twipe(setList)
		if (GetNumEquipmentSets() >= 1) then 
			for i = 1, GetNumEquipmentSets() do
				local name, texture, _, isEquipped, _, _, _, _, _ = GetEquipmentSetInfo(i)
				local icon = format('|T%s:14:14:0:0:64:64:4:60:4:60|t', texture or "")
				
				setList[i]={}
				setList[i].notCheckable = false
				setList[i].text = join("",icon," ", name)
				setList[i].checked = (isEquipped and true or false)
				setList[i].func = setClick
				setList[i].arg1 = name
			end
		end
		
		EasyMenu(menu, menuFrame, "cursor", 0, 0, "MENU", 2)
	end
end

local function ValueColorUpdate(hex, r, g, b)
	displayString = join("", "|cffFFFFFF%s:|r ")
	
	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E['valueColorUpdateFuncs'][ValueColorUpdate] = true

DT:RegisterDatatext('MUI Talent/Loot Specialization',{"PLAYER_ENTERING_WORLD", "CHARACTER_POINTS_CHANGED", "PLAYER_TALENT_UPDATE", "ACTIVE_TALENT_GROUP_CHANGED", 'PLAYER_LOOT_SPEC_UPDATED'}, OnEvent, nil, OnClick, OnEnter)
