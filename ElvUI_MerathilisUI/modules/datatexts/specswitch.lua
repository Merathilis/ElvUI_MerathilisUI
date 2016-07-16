local E, L, V, P, G = unpack(ElvUI);
local DT = E:GetModule('DataTexts')

-- Cache global variables
-- Lua functions
local _G = _G
local select = select
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
local SetActiveSpecGroup = SetActiveSpecGroup
local GetNumSpecGroups = GetNumSpecGroups
local GetSpecializationInfoByID = GetSpecializationInfoByID
local GetLootSpecialization = GetLootSpecialization
local CreateFrame = CreateFrame
local SELECT_LOOT_SPECIALIZATION = SELECT_LOOT_SPECIALIZATION
local LOOT_SPECIALIZATION_DEFAULT = LOOT_SPECIALIZATION_DEFAULT

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: LOOT, SPECIALIZATION, EasyMenu

local lastPanel, active
local displayString = '';
local talent = {}
local activeString = join("", "|cff00FF00" , ACTIVE_PETS, "|r")
local inactiveString = join("", "|cffFF0000", FACTION_INACTIVE, "|r")

local menuFrame = CreateFrame("Frame", "LootSpecializationDatatextClickMenu", E.UIParent, "UIDropDownMenuTemplate")

local function SetCurrentEquipmentSet(set)
	if GetNumEquipmentSets() == 0 then return false end
	for i = 1, GetNumEquipmentSets() do
		local name, _, _, isEquipped, _, _, _, _, _ = GetEquipmentSetInfo(i)
		if set == name then
			if not isEquipped then
				UseEquipmentSet(set)
			end
			return true
		end
	end
	return false
end

local function SwitchGear()	
	
	if GetSpecialization(false, false, active) then
		local set = select(2, GetSpecializationInfo(GetSpecialization(false, false, active == 1 and 2 or 1)))
		SetCurrentEquipmentSet(set)
	end
	
end

local function specializationClick(self, specialization)
	_G["CloseDropDownMenus"]()
	SetLootSpecialization(specialization)
end

local function setCLick(self,set)
	_G["CloseDropDownMenus"]()
	UseEquipmentSet(set)
end

local function specCLick(self,spec)
	_G["CloseDropDownMenus"]()
	
	if not(spec==active) then
		SwitchGear()
		SetActiveSpecGroup(active == 1 and 2 or 1)
	end
	
end

local menuList = {
	{ notCheckable = false, func = specializationClick, arg1=0, checked = false},
	{ notCheckable = false },
	{ notCheckable = false },
	{ notCheckable = false },
	{ notCheckable = false }
}

local specList = {}

local setList = {}

local menu = {
	{ text = OPTIONS_MENU, isTitle = true, notCheckable = true},
	{ text = _G.SPECIALIZATION, hasArrow = true, notCheckable = true,
		menuList = specList,
	},
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
	if not specIndex then return end
	
	active = GetActiveSpecGroup()
	
	local talent, loot = '', ''
	if GetSpecialization(false, false, active) then
		talent = format('|T%s:14:14:0:0:64:64:4:60:4:60|t', select(4, GetSpecializationInfo(GetSpecialization(false, false, active))))
	end
	
	local specialization = GetLootSpecialization()
	if specialization == 0 then
		local specIndex = GetSpecialization();
		
		if specIndex then
			local specID, _, _, texture = GetSpecializationInfo(specIndex);
			loot = format('|T%s:14:14:0:0:64:64:4:60:4:60|t', texture)
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
	
	if not (GetNumEquipmentSets() == 0) then
		DT.tooltip:AddLine(' ')
		DT.tooltip:AddLine(join("", "|cffFFFFFF" , _G.BAG_FILTER_EQUIPMENT, ":|r"))
		
		for i = 1, GetNumEquipmentSets() do
			local name, texture, _, isEquipped, _, _, _, _, _ = GetEquipmentSetInfo(i)
			local icon = format('|T%s:14:14:0:0:64:64:4:60:4:60|t', texture)
			DT.tooltip:AddDoubleLine(format('%s %s', icon, name), (isEquipped and activeString or inactiveString) )
		end
		
	end
	
	DT.tooltip:AddLine(' ')
	DT.tooltip:AddLine(L["|cffFFFFFFLeft Click:|r Change Talent Specialization"])
	DT.tooltip:AddLine(L["|cffFFFFFFRight Click:|r Change Loot Specialization"])	
	
	DT.tooltip:Show()
end

local function OnClick(self, button)
	
	local lootSpecialization = GetLootSpecialization()
	
	_G["lootSpecializationName"] = select(2,GetSpecializationInfoByID(lootSpecialization))
	
	local specIndex = GetSpecialization();
	if not specIndex then return end
	
	if button == "LeftButton" then
		SwitchGear()
		SetActiveSpecGroup(active == 1 and 2 or 1)
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
				local icon = format('|T%s:14:14:0:0:64:64:4:60:4:60|t', texture)
				menuList[index + 1].text = join("",icon," ", name)
				menuList[index + 1].func = specializationClick
				menuList[index + 1].arg1 = id
				menuList[index + 1].notCheckable = false
				menuList[index + 1].checked = (name == _G["lootSpecializationName"] and true or false)
			else
				menuList[index + 1] = nil
			end
		end
		
		if not (GetNumEquipmentSets() == 0) then 
			
			for i = 1, GetNumEquipmentSets() do
				local name, texture, _, isEquipped, _, _, _, _, _ = GetEquipmentSetInfo(i)
				local icon = format('|T%s:14:14:0:0:64:64:4:60:4:60|t', texture)
				
				setList[i]={}
				setList[i].notCheckable = false
				setList[i].text = join("",icon," ", name)
				setList[i].checked = (isEquipped and true or false)
				setList[i].func = setCLick
				setList[i].arg1 = name
			end
		else
			--menu[3] = nil
		end		
		
		for i = 1, GetNumSpecGroups() do
			if GetSpecialization(false, false, i) then
				local specID, name, _, texture = GetSpecializationInfo(GetSpecialization(false, false, i));
				local icon = format('|T%s:14:14:0:0:64:64:4:60:4:60|t', texture)
				
				specList[i]={}
				specList[i].notCheckable = false
				specList[i].text = join("",icon," ", name)
				specList[i].checked = (i == active and true or false)
				specList[i].func = specCLick
				specList[i].arg1 = i
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

--[[
DT:RegisterDatatext(name, events, eventFunc, updateFunc, clickFunc, onEnterFunc)

name - name of the datatext (required)
events - must be a table with string values of event names to register
eventFunc - function that gets fired when an event gets triggered
	updateFunc - onUpdate script target function
		click - function to fire when clicking the datatext
			onEnterFunc - function to fire OnEnter
				]]
DT:RegisterDatatext('MUI Talent/Loot Specialization',{"PLAYER_ENTERING_WORLD", "CHARACTER_POINTS_CHANGED", "PLAYER_TALENT_UPDATE", "ACTIVE_TALENT_GROUP_CHANGED", 'PLAYER_LOOT_SPEC_UPDATED'}, OnEvent, nil, OnClick, OnEnter)
