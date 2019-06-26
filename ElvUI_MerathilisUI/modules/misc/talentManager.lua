local MER, E, L, V, P, G = unpack(select(2, ...))
local MI = MER:GetModule("mUIMisc")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local pairs = pairs
local tinsert, tremove = table.insert, table.remove
--WoW API / Variables
local GetActiveSpecGroup = GetActiveSpecGroup
local GetNumSpecializations = GetNumSpecializations
local GetMaxTalentTier = GetMaxTalentTier
local GetTalentInfo = GetTalentInfo
local GetSpecialization = GetSpecialization
local UnitClass = UnitClass
-- GLOBALS:

local const__numTalentCols = 3
local cdn, playerClass, cid = UnitClass("player")
local DB = {}

local function table_length(t)
	local count = 0
	for k, v in pairs(t) do
		count = count + 1
	end
	return count
end

function DB:Verify()
	if MERData == nil then MERData = {} end
	if MERData[playerClass] == nil then MERData[playerClass] = {} end
	if MERData[playerClass].specs == nil then MERData[playerClass].specs = {} end
	for i = 1, GetNumSpecializations() do
		if MERData[playerClass].specs[i] == nil then MERData[playerClass].specs[i] = {} end
		if MERData[playerClass].specs[i].profiles == nil then MERData[playerClass].specs[i].profiles = {} end
	end
end

function DB:GetProfile(index)
	return MERData[playerClass].specs[GetSpecialization()].profiles[index]
end

function DB:GetAllProfiles()
	return MERData[playerClass].specs[GetSpecialization()].profiles
end

function DB:InsertProfile(profile)
	tinsert(MERData[playerClass].specs[GetSpecialization()].profiles, profile)
end

function DB:RemoveProfile(index)
	tremove(MERData[playerClass].specs[GetSpecialization()].profiles, index)
end

function GetTalentInfos()
	local talentInfos = {}
	local k = 1
	for i = 1, GetMaxTalentTier() do
		for j = 1, const__numTalentCols do
			local talentID, name, texture, selected, available, spellid, tier, column = GetTalentInfo(i, j, GetActiveSpecGroup())
			talentInfos[k] = {}
			talentInfos[k].talentID = talentID
			talentInfos[k].name = name
			talentInfos[k].texture = texture
			talentInfos[k].selected = selected
			talentInfos[k].available = available
			talentInfos[k].spellid = spellid
			talentInfos[k].tier = tier
			talentInfos[k].column = column
			k = k + 1
		end
	end
	return talentInfos
end

function AddProfile(name)
	DB:Verify()
	local talentInfos = GetTalentInfos()
	local profile = {}
	profile.name = name
	profile.talents = {}
	local i = 1
	for k, v in pairs(talentInfos) do
		if v.selected == true then
			profile.talents[i] = v.talentID
			i = i + 1
		end
	end
	if i > 8 then
		MER:Print(L["Error: Too many talents selected"])
	end
	DB:InsertProfile(profile)
	BuildFrame()
	MER:Print(L["Added a new profile: "] .. "'" .. profile.name .. "'")
end

function SaveProfile(index)
	if table_length(DB:GetAllProfiles()) == 0 then
		return
	end

	if index ~= "new" then
		local profile = DB:GetProfile(index)
		if profile == nil then
			MER:Print(L["Unable to load the selected profile"])
			return
		end

		local talentInfos = GetTalentInfos()
		local i = 1
		for k, v in pairs(talentInfos) do
			if v.selected == true then
				profile.talents[i] = v.talentID
				i = i + 1
			end
		end
		MER:Print(L["Saved profile: "] .. "'" .. profile.name .. "'")
	end
end

function PopupHandler_AddProfile(sender)
	AddProfile(sender.editBox:GetText())
end

function RemoveProfile(index)
	local key = nil
	local i = 1
	for k, v in pairs(DB:GetProfile(index)) do
		if i == index then
			key = k
		end
		i = i + 1
	end
	local name = DB:GetProfile(index).name
	DB:RemoveProfile(index)
	BuildFrame()
	MER:Print(L["Removed a profile: "] .. "'" .. name .. "'")
end

function PopupHandler_RemoveProfile(sender)
	RemoveProfile(TalentProfiles_profilesDropDown.selectedID)
end

StaticPopupDialogs["TALENTPROFILES_ADD_PROFILE"] = {
	text = L["Enter Profile Name: "],
	button1 = SAVE,
	button2 = CANCEL,
	OnAccept = PopupHandler_AddProfile,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
	hasEditBox = true,
}

function StaticPopupShow_Add()
	StaticPopup_Show("TALENTPROFILES_ADD_PROFILE")
end

StaticPopupDialogs["TALENTPROFILES_REMOVE_PROFILE"] = {
	text = L["Do you want to remove the profile '%s'?"],
	button1 = YES,
	button2 = NO,
	OnAccept = PopupHandler_RemoveProfile,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}
function StaticPopupShow_Remove()
	local index = TalentProfiles_profilesDropDown.selectedID
	local name = DB:GetProfile(index).name
	StaticPopup_Show("TALENTPROFILES_REMOVE_PROFILE", name)
end

function ActivateProfile(index)
	if index ~= "new" then
		local profile = DB:GetProfile(index)
		if profile == nil or profile.talents == nil then
			MER:Print(L["Unable to load talent configuration for the selected profile"])
			return
		end
		for i = 1, GetMaxTalentTier() do
			LearnTalent(profile.talents[i])
		end
		MER:Print(L["Activated profile: "] .. "'" .. profile.name .. "'")
	end
end

function Handler_ActivateProfile(sender)
	DB:Verify()
	if table_length(DB:GetAllProfiles()) == 0 then
		return
	end
	ActivateProfile(TalentProfiles_profilesDropDown.selectedID)
end

function Handler_SaveProfile(sender)
	SaveProfile(TalentProfiles_profilesDropDown.selectedID)
end

function Handler_RemoveProfile(sender)
	DB:Verify()
	if table_length(DB:GetAllProfiles()) == 0 then
		return
	end
	StaticPopupShow_Remove()
end

function ProfilesDropDown_OnClick(sender)
	UIDropDownMenu_SetSelectedID(TalentProfiles_profilesDropDown, sender:GetID())
end

function ProfilesDropDown_OnClick_NewProfile(sender)
	StaticPopupShow_Add()
end

function ProfilesDropDown_Initialise(sender, level)
	DB:Verify()
	local items = DB:GetAllProfiles()
	local i = 1
	for k, v in pairs(items) do
		local info = UIDropDownMenu_CreateInfo()
		info.text = v.name
		info.value = i
		info.func = ProfilesDropDown_OnClick
		UIDropDownMenu_AddButton(info, level)
		i = i + 1
	end

	local info = UIDropDownMenu_CreateInfo()
	info.text = " " .. L["Add new profile"]
	info.value = "new"
	info.func = ProfilesDropDown_OnClick_NewProfile
	info.rgb = {1.0, 0.0, 1.0, 1.0}
	UIDropDownMenu_AddButton(info, level)
end

function BuildFrame()
	local btn_sepX = 10
	local btn_offsetY = 0
	local btn_width = 80
	local btn_height = 23

	local mainFrame = TalentProfiles_main
	if TalentProfiles_main == nil then
		mainFrame = CreateFrame("Frame", "TalentProfiles_main", PlayerTalentFrame)
		mainFrame:SetSize(PlayerTalentFrame.TopTileStreaks:GetWidth(), PlayerTalentFrame.TopTileStreaks:GetHeight())
		mainFrame:SetPoint("CENTER", PlayerTalentFrame.TopTileStreaks, "CENTER", 0, 0)
	end

	local dropdown = TalentProfiles_profilesDropDown
	if TalentProfiles_profilesDropDown == nil then
		dropdown = CreateFrame("Button", "TalentProfiles_profilesDropDown", TalentProfiles_main, "UIDropDownMenuTemplate")
		dropdown:SetPoint("TOPLEFT", TalentProfiles_main, "TOPLEFT", 60, -13)
		S:HandleDropDownBox(dropdown, 165)
		TalentProfiles_profilesDropDownButton:SetWidth(TalentProfiles_profilesDropDownButton:GetHeight())
		TalentProfiles_profilesDropDown:SetScript("OnClick", function(...) TalentProfiles_profilesDropDownButton:Click() end)
		TalentProfiles_profilesDropDown:SetHeight(btn_height)
	end
	UIDropDownMenu_Initialize(dropdown, ProfilesDropDown_Initialise)
	UIDropDownMenu_SetSelectedID(dropdown, 1)
	dropdown:Show()

	local btnApply = TalentProfiles_btnApply
	if TalentProfiles_btnApply == nil then
		btnApply = CreateFrame("Button", "TalentProfiles_btnApply", TalentProfiles_main, "UIPanelButtonTemplate")
		btnApply:SetSize(btn_width, btn_height)
		btnApply:SetText(APPLY)
		btnApply:SetPoint("TOPLEFT", dropdown, "TOPRIGHT", 0, -3)
		S:HandleButton(btnApply)

		btnApply:SetScript("OnClick", Handler_ActivateProfile)
		btnApply:Show()
	end
	local btnSave = TalentProfiles_btnSave
	if TalentProfiles_btnSave == nil then
		btnSave = CreateFrame("Button", "TalentProfiles_btnSave", TalentProfiles_main, "UIPanelButtonTemplate")
		btnSave:SetSize(btn_width, btn_height)
		btnSave:SetText(SAVE)
		btnSave:SetPoint("TOPLEFT", btnApply, "TOPRIGHT", btn_sepX, 0)
		S:HandleButton(btnSave)
		btnSave:SetScript("OnClick", Handler_SaveProfile)
		btnSave:Show()
	end
	local btnRemove = TalentProfiles_btnRemove
	if TalentProfiles_btnRemove == nil then
		btnRemove = CreateFrame("Button", "TalentProfiles_btnRemove", TalentProfiles_main, "UIPanelButtonTemplate")
		btnRemove:SetSize(btn_width, btn_height)
		btnRemove:SetText(REMOVE)
		btnRemove:SetPoint("TOPLEFT", btnSave, "TOPRIGHT", btn_sepX, 0)
		S:HandleButton(btnRemove)
		btnRemove:SetScript("OnClick", Handler_RemoveProfile)
		btnRemove:Show()
	end
end

function MI:ToggleTalentFrame()
	self.hooks.ToggleTalentFrame()

	if PlayerTalentFrame == nil then
		return
	end

	local selectedTab = PanelTemplates_GetSelectedTab(PlayerTalentFrame)
	if selectedTab == 2 then
		BuildFrame()
		TalentProfiles_main:SetShown(PlayerTalentFrame:IsVisible())
	end
end

function MI:PanelTemplates_SetTab(...)
	self.hooks.PanelTemplates_SetTab(...)
	if PlayerTalentFrame == nil then
		return
	end

	local selectedTab = PanelTemplates_GetSelectedTab(PlayerTalentFrame)
	if selectedTab == 2 then
		BuildFrame()
		TalentProfiles_main:Show()
	else
		if TalentProfiles_main ~= nil then
			TalentProfiles_main:Hide()
		end
	end
end

function DB:Migrate()
	if MERDataPerChar ~= nil then
		if MERDataPerChar.specs == nil then
			MERDataPerChar = nil
			return
		end

		local count = 0
		for k_spec, spec in pairs(MERDataPerChar.specs) do
			if spec.profiles == nil then
				MER:Print(L["Migration: Info: No profiles found for spec #"] .. k)
			else
				for k_profile, profile in pairs(spec.profiles) do
					tinsert(MERData[playerClass].specs[k_spec].profiles, profile)
					MER:Print(L["Migration: Info: Migrated profile "] .. profile.name)
					count = count + 1
				end
			end
		end
		MERDataPerChar = nil
		MER:Print(L["Migration: Done: Successfully migrated "] .. count .. " profiles")
	end
end

function MI:LoadTalentProfiles()
	if E.db.mui.misc.talentManager ~= true or E.private.skins.blizzard.talent ~= true then return end

	DB:Verify()
	DB:Migrate()
	self:RawHook("ToggleTalentFrame", true)
	self:SecureHook("PanelTemplates_SetTab")
end
