local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local MERS = E:GetModule("muiSkins")
local S = E:GetModule('Skins')

-- Cache global variables
-- Lua functions
local _G = _G
local pairs, unpack = pairs, unpack

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: styleEncounterJournal

function styleEncounterJournal()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.encounterjournal ~= true or E.private.muiSkins.blizzard.encounterjournal ~= true then return end

	local EJ = _G["EncounterJournal"]
	local EncounterInfo = EJ.encounter.info
	EncounterInfo.instanceTitle:SetTextColor(unpack(E.media.rgbvaluecolor))
	EncounterInfo.encounterTitle:SetTextColor(unpack(E.media.rgbvaluecolor))

	local Tabs = {
		_G["EncounterJournalEncounterFrameInfoBossTab"],
		_G["EncounterJournalEncounterFrameInfoLootTab"],
		_G["EncounterJournalEncounterFrameInfoModelTab"],
		_G["EncounterJournalEncounterFrameInfoOverviewTab"]
	}

	for _, Tab in pairs(Tabs) do
		Tab:GetNormalTexture():SetTexture(nil)
		Tab:GetPushedTexture():SetTexture(nil)
		Tab:GetDisabledTexture():SetTexture(nil)
		Tab:GetHighlightTexture():SetTexture(nil)
		MERS:StyleOutside(Tab.backdrop)
	end

	-- From Aurora
	local LootJournal = EncounterJournal.LootJournal
	LootJournal:DisableDrawLayer("BACKGROUND")

	local itemsLeftSide = LootJournal.LegendariesFrame.buttons
	local itemsRightSide = LootJournal.LegendariesFrame.rightSideButtons
	for _, items in ipairs({itemsLeftSide, itemsRightSide}) do
		for i = 1, #items do
			local item = items[i]

			item.ItemType:SetTextColor(1, 1, 1)
			item.Background:SetAlpha(0)

			item.Icon:SetPoint("TOPLEFT", 1, -1)
			item.Icon:SetTexCoord(unpack(E.TexCoords))
			item.Icon:SetDrawLayer("OVERLAY")
			MERS:CreateBG(item.Icon)

			local bg = CreateFrame("Frame", nil, item)
			bg:SetPoint("TOPLEFT")
			bg:SetPoint("BOTTOMRIGHT", 0, 1)
			bg:SetFrameLevel(item:GetFrameLevel() - 1)
			MERS:CreateBD(bg, .25)
		end
	end

	local ItemSetsFrame = LootJournal.ItemSetsFrame
	hooksecurefunc(ItemSetsFrame, "UpdateList", function()
		local itemSets = ItemSetsFrame.buttons
		for i = 1, #itemSets do
			local itemSet = itemSets[i]

			itemSet.ItemLevel:SetTextColor(1, 1, 1)
			itemSet.Background:Hide()

			if not itemSet.bg then
				local bg = CreateFrame("Frame", nil, itemSet)
				bg:SetPoint("TOPLEFT")
				bg:SetPoint("BOTTOMRIGHT", 0, 1)
				bg:SetFrameLevel(itemSet:GetFrameLevel() - 1)
				MERS:CreateBD(bg, .25)
				itemSet.bg = bg
			end

			local items = itemSet.ItemButtons
			for j = 1, #items do
				local item = items[j]

				item.Border:Hide()
				item.Icon:SetPoint("TOPLEFT", 1, -1)

				item.Icon:SetTexCoord(.08, .92, .08, .92)
				item.Icon:SetDrawLayer("OVERLAY")
				MERS:CreateBG(item.Icon)
			end
		end
	end)
end

S:AddCallbackForAddon("Blizzard_EncounterJournal", "mUIEncounterJournal", styleEncounterJournal)