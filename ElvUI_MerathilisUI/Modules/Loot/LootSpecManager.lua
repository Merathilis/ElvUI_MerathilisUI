local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Loot") ---@class Loot
local S = E:GetModule("Skins")
local MS = MER:GetModule("MER_Skins")
local WS = W:GetModule("Skins")

local _G = _G
local ipairs, select = ipairs, select
local tinsert, tsort = tinsert, table.sort

local GetExpansionLevel = GetExpansionLevel
local GetSpecializationInfoForClassID = GetSpecializationInfoForClassID
local EJ_GetCurrentTier = EJ_GetCurrentTier
local EJ_GetEncounterInfoByIndex = EJ_GetEncounterInfoByIndex
local EJ_GetInstanceInfo = EJ_GetInstanceInfo
local EJ_GetInstanceByIndex = EJ_GetInstanceByIndex
local EJ_GetNumTiers = EJ_GetNumTiers
local EJ_GetTierInfo = EJ_GetTierInfo
local EJ_InstanceIsRaid = EJ_InstanceIsRaid
local EJ_GetCurrentInstance = EJ_GetCurrentInstance
local EJ_SelectInstance = EJ_SelectInstance
local SetLootSpecialization = SetLootSpecialization
local C_ChallengeMode_GetActiveChallengeMapID = C_ChallengeMode.GetActiveChallengeMapID
local C_ChallengeMode_GetActiveKeystoneInfo = C_ChallengeMode.GetActiveKeystoneInfo
local C_ChallengeMode_GetMapTable = C_ChallengeMode.GetMapTable
local C_ChallengeMode_GetMapUIInfo = C_ChallengeMode.GetMapUIInfo
local C_SpecializationInfo_GetNumSpecializationsForClassID = C_SpecializationInfo.GetNumSpecializationsForClassID

module.Data = {
	Raid = {},
	MythicPlus = {},
}

module.RaidIDs = {}

module.CheckBoxes = {
	Raid = {},
	MythicPlus = {},
}

module.DiffNames = {
	[14] = "Normal",
	[15] = "Heroic",
	[16] = "Mythic",
	[17] = "LFR",
}

local SPACING = 24
local IGNORE = -1

local function GetExpansionEJTier(expansion)
	local tier = ExpansionEnumToEJTierDataTableId and ExpansionEnumToEJTierDataTableId[expansion]
	if tier then
		return tier
	end

	for i = 1, EJ_GetNumTiers() do
		if EJ_GetTierInfo(i) == _G["EXPANSION_NAME" .. expansion] then
			return i
		end
	end
end

local function GetEncounterList(instanceID)
	EJ_SelectInstance(instanceID)
	local dungeonAreaMapID = select(7, EJ_GetInstanceInfo())
	if not dungeonAreaMapID or dungeonAreaMapID == 0 then
		return
	end

	local list = {}
	local i = 1
	local name, _, _, _, _, _, encounterID = EJ_GetEncounterInfoByIndex(i, instanceID)
	while name do
		tinsert(list, { name = name, id = encounterID })
		i = i + 1
		name, _, _, _, _, _, encounterID = EJ_GetEncounterInfoByIndex(i, instanceID)
	end
	return list
end

function module:UpdateRaidData()
	module.CurrentTier = EJ_GetCurrentTier()

	local maxTier = GetExpansionEJTier(GetExpansionLevel()) or EJ_GetNumTiers()
	EJ_SelectTier(maxTier)

	local index = 1
	local raidInstID, name = EJ_GetInstanceByIndex(index, true)
	while raidInstID do
		local encounters = GetEncounterList(raidInstID)
		if encounters then
			tinsert(module.Data.Raid, 1, { id = raidInstID, name = name, encounters = encounters })
			module.RaidIDs[raidInstID] = true
		end

		index = index + 1
		raidInstID, name = EJ_GetInstanceByIndex(index, true)
	end
end

function module:UpdateMythicPlusData()
	local mapIDs = C_ChallengeMode_GetMapTable()
	tsort(mapIDs)
	for _, mapID in ipairs(mapIDs) do
		local name = C_ChallengeMode_GetMapUIInfo(mapID)
		if name then
			tinsert(module.Data.MythicPlus, { id = mapID, name = name })
		end
	end
end

function module:GetSpecIcons()
	local classID = select(3, UnitClass("player"))
	local specs = {}
	for i = 1, C_SpecializationInfo_GetNumSpecializationsForClassID(classID) do
		local id, _, _, icon = GetSpecializationInfoForClassID(classID, i)
		if not id then
			break
		end

		tinsert(specs, { id = id, icon = icon })
	end
	return specs
end

function module:GetRaidSpec(encounter, diffID)
	local diffName = module.DiffNames[diffID]

	return diffName and module.db.Encounters[diffName][encounter] or IGNORE
end

function module:GetSpecSetting(type, id)
	if type == "Raid" then
		return module.db.Encounters[module.db.Current][id] or IGNORE
	elseif type == "MythicPlus" then
		return module.db.MythicPlus[id] or IGNORE
	end
end

function module:SetSpecSetting(type, id, spec)
	if type == "Raid" then
		module.db.Encounters[module.db.Current][id] = spec
	elseif type == "MythicPlus" then
		module.db.MythicPlus[id] = spec
	end
end

function module:SetLootSpec(spec)
	if spec == IGNORE then
		return false
	end

	SetLootSpecialization(spec)
	return true
end

-- GUI
local function CreateSpecIcon(parent, icon, x)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetSize(SPACING - 2, SPACING - 2)
	frame:SetPoint("TOPRIGHT", parent, "TOPRIGHT", x, 0)

	local texture = frame:CreateTexture(nil, "ARTWORK")
	texture:SetTexture(icon)
	texture:SetAllPoints()
	S:HandleIcon(texture)
	frame.icon = texture

	return frame
end

local function CreateHeader(parent, title, specs, y)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetSize(parent:GetWidth(), SPACING)
	frame:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, y)

	frame.title = F.CreateFS(frame, 18, title, "system", "LEFT", 10, 0)
	frame.ignore = CreateSpecIcon(frame, "Interface\\BUTTONS\\UI-GroupLoot-Pass-Up", -4)
	for i, spec in ipairs(specs) do
		frame["spec" .. i] = CreateSpecIcon(frame, spec.icon, -4 - i * (SPACING + 4))
	end

	return frame
end

local function CreateCheckbox(parent, offset, id, spec, type)
	local box = F.CreateCheckBox(parent)
	box:SetPoint("TOPRIGHT", parent, "TOPRIGHT", offset, 0)
	box.id = id
	box.spec = spec
	box:SetScript("OnClick", function(self)
		for _, bu in pairs(parent.buttons) do
			bu:SetChecked(bu == self)
		end
		module:SetSpecSetting(type, id, spec)
	end)

	tinsert(parent.buttons, box)
	tinsert(module.CheckBoxes[type], box)

	return box
end

local function CreateSubGroup(parent, y, specs, info, type)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetSize(parent:GetWidth(), SPACING)
	frame:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, y)
	frame.name = F.CreateFS(frame, 14, info.name, false, "LEFT", 30, 0)
	frame.buttons = {}

	frame.ignore = CreateCheckbox(frame, -2, info.id, IGNORE, type)
	for i, spec in ipairs(specs) do
		frame["spec" .. i] = CreateCheckbox(frame, -2 - i * (SPACING + 4), info.id, spec.id, type)
	end

	return frame
end

function module:CreateGUI()
	if module.GUI then
		module.GUI:Show()
		return
	end
	if not next(module.Data.MythicPlus) then
		return
	end

	local gui = CreateFrame("Frame", "MER_LSMFrame", UIParent)
	tinsert(UISpecialFrames, "MER_LSMFrame")
	gui:SetWidth(370)
	gui:SetHeight(505)
	gui:SetPoint("CENTER")
	gui:SetFrameStrata("HIGH")
	gui:SetFrameLevel(5)
	gui:SetTemplate("Transparent")
	WS:CreateShadow(gui)

	F.CreateFS(gui, 18, "LootSpecManager", "info", "TOP", 0, -10)

	local scroll = CreateFrame("ScrollFrame", nil, gui, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", 0, -70)
	scroll:SetPoint("BOTTOMRIGHT", -30, 50)
	scroll.child = CreateFrame("Frame", nil, scroll)
	scroll.child:SetSize(340, 1)
	scroll:SetScrollChild(scroll.child)
	S:HandleScrollBar(scroll.ScrollBar)

	local specs = module:GetSpecIcons()
	local offset = -5

	-- Raid
	for _, instance in ipairs(module.Data.Raid) do
		CreateHeader(scroll.child, instance.name, specs, offset)
		offset = offset - SPACING

		for _, boss in ipairs(instance.encounters) do
			CreateSubGroup(scroll.child, offset, specs, boss, "Raid")
			offset = offset - SPACING
		end

		offset = offset - 10
	end

	-- Mythic+
	CreateHeader(scroll.child, L["Mythic+"], specs, offset)
	offset = offset - SPACING

	for _, instance in ipairs(module.Data.MythicPlus) do
		CreateSubGroup(scroll.child, offset, specs, instance, "MythicPlus")
		offset = offset - SPACING
	end

	local close = MS.CreateButton(gui, 80, 20)
	close:SetText(CLOSE or L["Close"])
	close:SetPoint("BOTTOMRIGHT", -20, 15)
	close:SetScript("OnClick", function()
		gui:Hide()
	end)
	gui.close = close

	local helpInfo = F.CreateHelpInfo(gui)
	helpInfo:SetPoint("TOPRIGHT", -5, -5)
	helpInfo.title = L["LootSpecManager"]
	F.AddTooltip(helpInfo, "ANCHOR_RIGHT", L["LootSpecManagerTips"], "info")
	gui.help = helpInfo

	local current = CreateFrame("Frame", "MER_LootSpecCurrentDropdown", gui, "UIDropDownMenuTemplate")
	current:SetPoint("TOPLEFT", _G.MER_LSMFrame, "TOPLEFT", 2, -30)
	S:HandleDropDownBox(_G.MER_LootSpecCurrentDropdown, 150)
	UIDropDownMenu_Initialize(current, function()
		local function callback(self)
			E.db.mui.lootSpecManager.Current = self.value
			module:RefreshGUI()
			UIDropDownMenu_SetSelectedValue(current, self.value)
		end

		local function make_button(info, value, text)
			info.text = text
			info.value = value
			info.func = callback
			info.checked = false
			info.isNotRadio = false
			UIDropDownMenu_AddButton(info)
		end

		local info = UIDropDownMenu_CreateInfo()
		make_button(info, "Mythic", PLAYER_DIFFICULTY6)
		make_button(info, "Heroic", PLAYER_DIFFICULTY2)
		make_button(info, "Normal", PLAYER_DIFFICULTY1)
		make_button(info, "LFR", PLAYER_DIFFICULTY3)
	end)
	UIDropDownMenu_SetSelectedValue(current, E.db.mui.lootSpecManager.Current)
	gui.current = current

	module.GUI = gui
	module.GUI.CheckBoxes = module.CheckBoxes
	module:RefreshGUI()
end

function module:RefreshGUI()
	for type, checkboxes in pairs(module.CheckBoxes) do
		for _, cb in pairs(checkboxes) do
			cb:SetChecked(module:GetSpecSetting(type, cb.id) == cb.spec)
		end
	end
end

function module:EncounterStart(id, _, diffID)
	if C_ChallengeMode_GetActiveKeystoneInfo() ~= 0 then
		return
	end

	local spec = module:GetRaidSpec(id, diffID)
	if module:SetLootSpec(spec) then
		MER:Print(L["LootSpecManagerRaidStart"])
	end
end

function module:MythicPlusStart()
	local mapID = C_ChallengeMode_GetActiveChallengeMapID()
	if not mapID then
		return
	end

	local spec = module.db.MythicPlus[mapID] or IGNORE
	if module:SetLootSpec(spec) then
		MER:Print(L["LootSpecManagerM+Start"])
	end
end

function module:UpdateData()
	if
		module.Data.Raid[1]
		and next(module.Data.Raid[1].encounters)
		and next(module.Data.MythicPlus)
	then
		module:UnregisterEvent("UPDATE_INSTANCE_INFO", module.UpdateData)

		if module.CurrentTier then
			E:Delay(1, EJ_SelectTier, module.CurrentTier)
		end

		return
	end

	wipe(module.Data.Raid)
	wipe(module.Data.MythicPlus)
	wipe(module.RaidIDs)

	module:UpdateRaidData()
	module:UpdateMythicPlusData()
end

function module:TogglePanel()
	if module.GUI then
		F:TogglePanel(module.GUI)
	else
		module:CreateGUI()
	end
end

local function IsMythicPlusDungeon()
	return (EJ_GetCurrentTier() == EJ_GetNumTiers()) and not EJ_InstanceIsRaid()
end

local function IsCurrentExpansionRaid(instanceID)
	return module.RaidIDs[instanceID] == true
end

function module:CreateEJButton()
	local parent = _G.EncounterJournalEncounterFrameInfo and _G.EncounterJournalEncounterFrameInfo.LootContainer
	if not parent then
		return
	end

	local bu = F.CreateGear(parent)
	bu:SetPoint("RIGHT", parent.filter, "LEFT", -4, 0)
	F.AddTooltip(bu, "ANCHOR_RIGHT", L["LootSpecManager"], "info")
	bu:SetScript("OnClick", module.TogglePanel)

	hooksecurefunc("EncounterJournal_SetTab", function()
		bu:SetShown(IsMythicPlusDungeon() or IsCurrentExpansionRaid(EJ_GetCurrentInstance()))
	end)
end

function module:Initialize()
	module.db = E.db.mui.lootSpecManager

	RequestRaidInfo()
	module:RegisterEvent("UPDATE_INSTANCE_INFO", module.UpdateData)
	module:RegisterEvent("ENCOUNTER_START", module.EncounterStart)
	module:RegisterEvent("CHALLENGE_MODE_START", module.MythicPlusStart)
	local misc = MER:GetModule("MER_Misc")
	misc:AddCallbackForAddon("Blizzard_EncounterJournal", module.CreateEJButton)
end

MER:AddCommand("LSM", "/lsm", function()
	if not E.db.mui.lootSpecManager.enable then
		return
	end

	module:CreateGUI()
end)

MER:RegisterModule(module:GetName())
