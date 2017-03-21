local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule("MerathilisUI")

-- Cache global variables
-- Lua functions
local _G = _G
local pairs, unpack = pairs, unpack
local ceil = ceil
-- WoW API / Variables
local AttachGlyphToSpell = AttachGlyphToSpell
local SpellBookFrame = _G["SpellBookFrame"]
local SpellBookPageText = _G["SpellBookPageText"]
local GetCurrentGlyphNameForSpell = GetCurrentGlyphNameForSpell
local GetPendingGlyphName = GetPendingGlyphName
local GetSpellDescription = GetSpellDescription
local GetSpellBookItemInfo = GetSpellBookItemInfo
local GetSpellBookItemName = GetSpellBookItemName
local GetSpellTabInfo = GetSpellTabInfo
local HasAttachedGlyph = HasAttachedGlyph
local HasPendingGlyphCast = HasPendingGlyphCast
local HasPetSpells = HasPetSpells
local IsPassiveSpell = IsPassiveSpell
local IsPendingGlyphRemoval = IsPendingGlyphRemoval
local IsTalentSpell = IsTalentSpell
local ToggleSpellAutocast = ToggleSpellAutocast
-- GLOBALS: hooksecurefunc, SpellButton_UpdateSelection, SpellFlyout, BOOKTYPE_PET, BOOKTYPE_PROFESSION, BOOKTYPE_SPELL, BOOKTYPE_SPELLBOOK
-- GLOBALS: SpellBookFrame_Update, CreateFrame, TALENT, TALENT_PASSIVE, SPELL_PASSIVE, MAX_SPELLS, StaticPopup_Show, spellName
-- GLOBALS: SpellBook_GetSpellBookSlot, SPELLBOOK_PAGENUMBERS, SPELLS_PER_PAGE, OldSpellBookFrame_Update

function styleSpellBook()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.spellbook ~= true or E.private.muiSkins.blizzard.spellbook ~= true then return end

	if SpellBookFrame.pagebackdrop then
		SpellBookFrame.pagebackdrop:Hide()
	end

	SpellBookPageText:SetTextColor(unpack(E.media.rgbvaluecolor))

	local professionheaders = {
		"PrimaryProfession1",
		"PrimaryProfession2",
		"SecondaryProfession1",
		"SecondaryProfession2",
		"SecondaryProfession3",
		"SecondaryProfession4"
	}

	for _, header in pairs(professionheaders) do
		_G[header.."Missing"]:SetTextColor(1, 0.8, 0)
		_G[header.."Missing"]:SetShadowColor(0, 0, 0)
		_G[header.."Missing"]:SetShadowOffset(1, -1)
		_G[header].missingText:SetTextColor(0.6, 0.6, 0.6)
	end

	hooksecurefunc("SpellButton_UpdateButton", function(self)
		if self.SpellSubName then
			self.SpellSubName:SetTextColor(unpack(E.media.rgbvaluecolor))
		end
	end)
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, _, addon)
	if addon == "ElvUI_MerathilisUI" then
		E:Delay(1, styleSpellBook)
		self:UnregisterEvent("ADDON_LOADED")
	end
end)

-- Credits to Kerbaal (SpellBook Search)
-- SpellBook Search
if IsAddOnLoaded("SpellBookSearch") then return end

MER.spells = {}

local function UpdateSearch()
	SpellBookFrame_Update()
end

local function SearchBox_OnTextChanged(self, userInput)
	MER.SearchBox_OldOnTextChanged(self, userInput)
	SpellBookFrame_Update()
end

local function dbgprnt (...)
  --return print(...)
end

function MER:getOrCreateSearchBox()
	if (MER.SearchBox ~= nil) then
		return MER.SearchBox
	end

	MER.SearchBox = CreateFrame("EditBox", "SearchBox", SpellBookFrame, "SearchBoxTemplate")
	MER.SearchBox:SetWidth(150)
	MER.SearchBox:SetHeight(20)
	MER.SearchBox:SetPoint("TOPRIGHT", SpellBookFrame, "TOPRIGHT", -25, -1)
	MER.SearchBox:Show()
	MER.SearchBox.Left:Hide()
	MER.SearchBox.Right:Hide()
	MER.SearchBox.Middle:Hide()

	MER.SearchBox:SetScript("OnEnterPressed", UpdateSearch)
	MER.SearchBox_OldOnTextChanged = MER.SearchBox:GetScript("OnTextChanged")
	MER.SearchBox:SetScript("OnTextChanged", SearchBox_OnTextChanged)

	return MER.SearchBox;
end

function MER:updateSearchBox()
	local box = MER:getOrCreateSearchBox()
	if (SpellBookFrame.bookType ~= BOOKTYPE_SPELL) then
		box:Hide()
	else
		box:Show()
	end
end

local function GetFullSpellName(slot, bookType)
	local spellName, subSpellName = GetSpellBookItemName(slot, bookType);
	local isPassive = IsPassiveSpell(slot, bookType);

	if (not subSpellName) then
		subSpellName = ""
	end

	if ( subSpellName == "" ) then
		if ( IsTalentSpell(slot, bookType) ) then
			if ( isPassive ) then
				subSpellName = TALENT_PASSIVE
			else
				subSpellName = TALENT
			end
		elseif ( isPassive ) then
			subSpellName = SPELL_PASSIVE;
		end
	end

	return spellName .. " " .. subSpellName
end

OldSpellBookFrame_Update = SpellBookFrame_Update

function MER:findSpells()
	if (SpellBookFrame.bookType ~= BOOKTYPE_SPELL) then
		MER.spells = {};
		MER.numSpells = j;
		return
	end

	if ( not SpellBookFrame.selectedSkillLine ) then
		SpellBookFrame.selectedSkillLine = 2;
	end

	local _, _, offset, numSlots, _, _ = GetSpellTabInfo(SpellBookFrame.selectedSkillLine);

	MER.spells = {};
	local j = 1
	dbgprnt ("Indexing from" .. offset .. "up to " .. (numSlots+offset)
	.. " on " .. SpellBookFrame.bookType)
	for i=1,numSlots do

		local slotType, spellID = GetSpellBookItemInfo(i+offset, SpellBookFrame.bookType);
		local fullSpellName = GetFullSpellName(i+offset, SpellBookFrame.bookType);
		local searchText = MER:getOrCreateSearchBox():GetText():gsub("%s+", "")
		local desc = GetSpellDescription(spellID)

		dbgprnt(spellName)
		if searchText == "" or
			fullSpellName:lower():match(searchText:lower()) then
			MER.spells[offset+j] = i+offset;
			j = j + 1
		end
	end
	MER.numSpells = j
end

function SpellBookFrame_Update()
	MER:updateSearchBox()
	MER:findSpells()
	OldSpellBookFrame_Update()
end

function SpellBook_GetCurrentPage()
	local currentPage, maxPages;
	local numPetSpells = HasPetSpells() or 0;
	if ( SpellBookFrame.bookType == BOOKTYPE_PET ) then
		currentPage = SPELLBOOK_PAGENUMBERS[BOOKTYPE_PET];
		maxPages = ceil(numPetSpells/SPELLS_PER_PAGE);
	elseif ( SpellBookFrame.bookType == BOOKTYPE_SPELL) then
		currentPage = SPELLBOOK_PAGENUMBERS[SpellBookFrame.selectedSkillLine];
		local _, _, _, numSlots = GetSpellTabInfo(SpellBookFrame.selectedSkillLine);
		maxPages = ceil(MER.numSpells/SPELLS_PER_PAGE);
	end
	return currentPage, maxPages;
end

function SpellBook_GetSpellBookSlot(spellButton)
	local id = spellButton:GetID()
	if ( SpellBookFrame.bookType == BOOKTYPE_PROFESSION) then
		return id + spellButton:GetParent().spellOffset;
	elseif ( SpellBookFrame.bookType == BOOKTYPE_PET ) then
		local slot = id + (SPELLS_PER_PAGE * (SPELLBOOK_PAGENUMBERS[BOOKTYPE_PET] - 1));
		local slotType, slotID = GetSpellBookItemInfo(slot, SpellBookFrame.bookType);
		return slot, slotType, slotID;
	else
		local relativeSlot = id + ( SPELLS_PER_PAGE * (SPELLBOOK_PAGENUMBERS[SpellBookFrame.selectedSkillLine] - 1))
		if ( SpellBookFrame.selectedSkillLineNumSlots and relativeSlot <= SpellBookFrame.selectedSkillLineNumSlots) then
			local slot = SpellBookFrame.selectedSkillLineOffset + relativeSlot;
			dbgprnt("Slot" .. slot)
			local filteredSlot = MER.spells[slot];
			if filteredSlot then
				dbgprnt(" to " .. filteredSlot)
				local slotType, slotID = GetSpellBookItemInfo(MER.spells[slot], SpellBookFrame.bookType);
				local spellName, subSpellName = GetSpellBookItemName(MER.spells[slot], SpellBookFrame.bookType)
				dbgprnt(spellName)
				return filteredSlot, slotType, slotID;
			end
			return nil, nil
		else
			return nil, nil
		end
	end
end

function SpellButton_OnClick(self, button)
	local slot, slotType = SpellBook_GetSpellBookSlot(self);
	if ( slot > MAX_SPELLS or slotType == "FUTURESPELL") then
		return;
	end

	if ( HasPendingGlyphCast() and SpellBookFrame.bookType == BOOKTYPE_SPELL ) then
		local slotType, spellID = GetSpellBookItemInfo(slot, SpellBookFrame.bookType);
		if (slotType == "SPELL") then
			if ( HasAttachedGlyph(spellID) ) then
				if ( IsPendingGlyphRemoval() ) then
					StaticPopup_Show("CONFIRM_GLYPH_REMOVAL", nil, nil, {name = GetCurrentGlyphNameForSpell(spellID), id = spellID});
				else
					StaticPopup_Show("CONFIRM_GLYPH_PLACEMENT", nil, nil, {name = GetPendingGlyphName(), currentName = GetCurrentGlyphNameForSpell(spellID), id = spellID});
				end
			else
				AttachGlyphToSpell(spellID);
			end
		elseif (slotType == "FLYOUT") then
			SpellFlyout:Toggle(spellID, self, "RIGHT", 1, false, self.offSpecID, true);
			SpellFlyout:SetBorderColor(181/256, 162/256, 90/256);
		end
		return;
	end

	if (self.isPassive) then
		return;
	end

	if ( button ~= "LeftButton" and SpellBookFrame.bookType == BOOKTYPE_PET ) then
		if ( self.offSpecID == 0 ) then
			ToggleSpellAutocast(slot, SpellBookFrame.bookType);
		end
	else
		local _, id = GetSpellBookItemInfo(slot, SpellBookFrame.bookType);
		if (slotType == "FLYOUT") then
			SpellFlyout:Toggle(id, self, "RIGHT", 1, false, self.offSpecID, true);
			SpellFlyout:SetBorderColor(181/256, 162/256, 90/256);
		else
			if ( SpellBookFrame.bookType ~= BOOKTYPE_SPELLBOOK or self.offSpecID == 0 ) then
				--CastSpell(slot, SpellBookFrame.bookType);
			end
		end
		SpellButton_UpdateSelection(self);
	end
end