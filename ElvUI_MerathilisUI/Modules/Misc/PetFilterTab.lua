local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc") ---@class Misc
local MERS = MER:GetModule("MER_Skins")

local ipairs = ipairs

local IsShiftKeyDown = IsShiftKeyDown
local C_PetJournal_SetPetTypeFilter = C_PetJournal.SetPetTypeFilter
local C_PetJournal_IsPetTypeChecked = C_PetJournal.IsPetTypeChecked
local C_PetJournal_SetAllPetTypesChecked = C_PetJournal.SetAllPetTypesChecked
local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded

local PET_TYPE_SUFFIX = PET_TYPE_SUFFIX

function module:PetTabs_Click(button)
	local activeCount = 0
	for petType in ipairs(PET_TYPE_SUFFIX) do
		local btn = _G["PetJournalQuickFilterButton" .. petType]
		if button == "LeftButton" then
			if self == btn then
				btn.isActive = not btn.isActive
			elseif not IsShiftKeyDown() then
				btn.isActive = false
			end
		elseif button == "RightButton" and (self == btn) then
			btn.isActive = not btn.isActive
		end

		if btn.isActive then
			btn.backdrop:SetBackdropBorderColor(F.r, F.g, F.b)
			activeCount = activeCount + 1
		else
			F.SetBorderColor(btn.backdrop)
		end
		C_PetJournal_SetPetTypeFilter(btn.petType, btn.isActive)
	end

	if activeCount == 0 then
		C_PetJournal_SetAllPetTypesChecked(true)
	end
end

function module:PetTabs_Create()
	PetJournal.ScrollBox:SetPoint("TOPLEFT", PetJournalLeftInset, 3, -60)

	-- Create the pet type buttons, sorted according weakness
	-- Humanoid > Dragonkin > Magic > Flying > Aquatic > Elemental > Mechanical > Beast > Critter > Undead
	local activeCount = 0
	for petIndex, petType in ipairs({ 1, 2, 6, 3, 9, 7, 10, 8, 5, 4 }) do
		local btn = CreateFrame("Button", "PetJournalQuickFilterButton" .. petIndex, PetJournal, "BackdropTemplate")
		btn:SetSize(24, 24)
		btn:SetPoint("TOPLEFT", PetJournalLeftInset, 6 + 25 * (petIndex - 1), -33)
		F.PixelIcon(btn, "Interface\\ICONS\\Pet_Type_" .. PET_TYPE_SUFFIX[petType], true)

		if C_PetJournal_IsPetTypeChecked(petType) then
			btn.isActive = true
			btn.backdrop:SetBackdropBorderColor(F.r, F.g, F.b)
			activeCount = activeCount + 1
		else
			btn.isActive = false
		end
		btn.petType = petType
		btn:SetScript("OnMouseUp", module.PetTabs_Click)
	end

	if activeCount == #PET_TYPE_SUFFIX then
		for petIndex in ipairs(PET_TYPE_SUFFIX) do
			local btn = _G["PetJournalQuickFilterButton" .. petIndex]
			btn.isActive = false
			F.SetBorderColor(btn.backdrop)
		end
	end
end

function module:PetTabs_Load(addon)
	if addon == "Blizzard_Collections" then
		module:PetTabs_Create()
		MER:UnregisterEvent(self, module.PetTabs_Load)
	end
end

function module:PetFilterTab()
	self.db = F.GetDBFromPath("mui.misc.petFilterTab")
	if not self.db then
		return
	end

	if C_AddOns_IsAddOnLoaded("Blizzard_Collections") then
		module:PetTabs_Create()
	else
		MER:RegisterEvent("ADDON_LOADED", module.PetTabs_Load)
	end
end

module:AddCallback("PetFilterTab")
