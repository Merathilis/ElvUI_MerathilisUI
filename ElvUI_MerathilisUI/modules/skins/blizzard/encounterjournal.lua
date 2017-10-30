local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule('Skins')

-- Cache global variables
-- Lua functions
local _G = _G
local ipairs, pairs, select, unpack = ipairs, pairs, select, unpack
-- WoW API / Variables
local CreateFrame = CreateFrame
-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: styleEncounterJournal, hooksecurefunc

function styleEncounterJournal()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.encounterjournal ~= true or E.private.muiSkins.blizzard.encounterjournal ~= true then return end

	local EJ = _G["EncounterJournal"]
	local EncounterInfo = EJ.encounter.info
	EncounterInfo.instanceTitle:SetTextColor(unpack(E.media.rgbvaluecolor))
	EncounterInfo.encounterTitle:SetTextColor(unpack(E.media.rgbvaluecolor))

	_G["EncounterJournalEncounterFrameInfo"]:DisableDrawLayer("BACKGROUND")
	_G["EncounterJournal"]:DisableDrawLayer("BORDER")
	_G["EncounterJournalInset"]:DisableDrawLayer("BORDER")
	_G["EncounterJournalNavBar"]:DisableDrawLayer("BORDER")
	_G["EncounterJournalSearchResults"]:DisableDrawLayer("BORDER")
	_G["EncounterJournal"]:DisableDrawLayer("OVERLAY")
	_G["EncounterJournalInstanceSelectSuggestTab"]:DisableDrawLayer("OVERLAY")
	_G["EncounterJournalInstanceSelectDungeonTab"]:DisableDrawLayer("OVERLAY")
	_G["EncounterJournalInstanceSelectRaidTab"]:DisableDrawLayer("OVERLAY")

	_G["EncounterJournalNavBar"]:GetRegions():Hide()
	_G["EncounterJournalNavBarOverlay"]:Hide()

	if EJ.navBar.backdrop then
		EJ.navBar.backdrop:Hide()
	end

	EJ.backdrop:Styling(true, true)

	_G["EncounterJournalEncounterFrameInfoCreatureButton1"]:SetPoint("TOPLEFT", _G["EncounterJournalEncounterFrameInfoModelFrame"], 0, -35)

	do
		local numBossButtons = 1
		local bossButton

		hooksecurefunc("EncounterJournal_DisplayInstance", function()
			bossButton = _G["EncounterJournalBossButton"..numBossButtons]
			while bossButton do
				MERS:Reskin(bossButton, true)

				bossButton.text:SetTextColor(1, 1, 1)
				bossButton.text.SetTextColor = MER.dummy

				local hl = bossButton:GetHighlightTexture()
				hl:SetColorTexture(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b, .2)
				hl:SetPoint("TOPLEFT", 2, -1)
				hl:SetPoint("BOTTOMRIGHT", 0, 1)

				bossButton.creature:SetPoint("TOPLEFT", 0, -4)

				numBossButtons = numBossButtons + 1
				bossButton = _G["EncounterJournalBossButton"..numBossButtons]
			end

			-- move last tab
			local _, point = _G["EncounterJournalEncounterFrameInfoModelTab"]:GetPoint()
			_G["EncounterJournalEncounterFrameInfoModelTab"]:SetPoint("TOP", point, "BOTTOM", 0, 1)
		end)
	end

	hooksecurefunc("EncounterJournal_ToggleHeaders", function(self)
		local index = 1
		local header = _G["EncounterJournalInfoHeader"..index]
		while header do
			if not header.styled then
				header.flashAnim.Play = MER.dummy

				header.descriptionBG:SetAlpha(0)
				header.descriptionBGBottom:SetAlpha(0)
				for i = 4, 18 do
					select(i, header.button:GetRegions()):SetTexture("")
				end

				header.description:SetTextColor(1, 1, 1)
				header.button.title:SetTextColor(1, 1, 1)
				header.button.title.SetTextColor = MER.dummy
				header.button.expandedIcon:SetTextColor(1, 1, 1)
				header.button.expandedIcon.SetTextColor = MER.dummy

				MERS:Reskin(header.button, true)

				header.button.abilityIcon:SetTexCoord(.08, .92, .08, .92)
				header.button.bg = MERS:CreateBG(header.button.abilityIcon)

				if header.button.abilityIcon:IsShown() then
					header.button.bg:Show()
				else
					header.button.bg:Hide()
				end

				header.styled = true
			end

			if header.button.abilityIcon:IsShown() then
				header.button.bg:Show()
			else
				header.button.bg:Hide()
			end

			index = index + 1
			header = _G["EncounterJournalInfoHeader"..index]
		end
	end)

	hooksecurefunc("EncounterJournal_SetUpOverview", function(self, role, index)
		local header = self.overviews[index]
		if not header.styled then
			header.flashAnim.Play = MER.dummy

			header.descriptionBG:SetAlpha(0)
			header.descriptionBGBottom:SetAlpha(0)
			for i = 4, 18 do
				select(i, header.button:GetRegions()):SetTexture("")
			end

			header.button.title:SetTextColor(1, 1, 1)
			header.button.title.SetTextColor = MER.dummy
			header.button.expandedIcon:SetTextColor(1, 1, 1)
			header.button.expandedIcon.SetTextColor = MER.dummy

			-- Blizzard already uses .tex for this frame, so we can't do highlights
			MERS:Reskin(header.button, true)

			header.styled = true
		end
	end)

	hooksecurefunc("EncounterJournal_SetBullets", function(object, description)
		local parent = object:GetParent()

		if parent.Bullets then
			for _, bullet in pairs(parent.Bullets) do
				if not bullet.styled then
					bullet.Text:SetTextColor(1, 1, 1)
					bullet.styled = true
				end
			end
		end
	end)

	for _, tabName in pairs({"EncounterJournalInstanceSelectSuggestTab", "EncounterJournalInstanceSelectDungeonTab", "EncounterJournalInstanceSelectRaidTab","EncounterJournalInstanceSelectLootJournalTab"}) do
		local tab = _G[tabName]

		MERS:ReskinTab(tab)
	end

	-- From Aurora
	local LootJournal = _G["EncounterJournal"].LootJournal
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

	local function rewardOnEnter()
		for i = 1, 2 do
			local item = _G["EncounterJournalTooltip"]["Item"..i]
			if item:IsShown() then
				if item.IconBorder:IsShown() then
					-- item.newBg:SetVertexColor(item.IconBorder:GetVertexColor())
					item.IconBorder:Hide()
				else
					item.newBg:SetVertexColor(0, 0, 0)
				end
			end
		end
	end

	local suggestFrame = _G["EncounterJournal"].suggestFrame

	--[[ Suggestion 1 ]]
	local suggestion = suggestFrame.Suggestion1

	suggestion.bg:Hide()
	MERS:CreateBD(suggestion, .25)

	suggestion.icon:SetPoint("TOPLEFT", 135, -15)
	MERS:CreateBG(suggestion.icon)

	local centerDisplay = suggestion.centerDisplay

	centerDisplay.title.text:SetTextColor(1, 1, 1)
	centerDisplay.description.text:SetTextColor(.9, .9, .9)

	S:HandleButton(suggestion.button)

	local reward = suggestion.reward

	reward:HookScript("OnEnter", rewardOnEnter)
	reward.text:SetTextColor(.9, .9, .9)
	reward.iconRing:Hide()
	reward.iconRingHighlight:SetTexture("")
	MERS:CreateBG(reward.icon)

	--[[ Suggestion 2 and 3 ]]

	for i = 2, 3 do
		local suggestion = suggestFrame["Suggestion"..i]

		suggestion.bg:Hide()

		MERS:CreateBD(suggestion, .25)

		suggestion.icon:SetPoint("TOPLEFT", 10, -10)
		MERS:CreateBG(suggestion.icon)

		local centerDisplay = suggestion.centerDisplay

		centerDisplay:ClearAllPoints()
		centerDisplay:SetPoint("TOPLEFT", 85, -10)
		centerDisplay.title.text:SetTextColor(1, 1, 1)
		centerDisplay.description.text:SetTextColor(.9, .9, .9)

		S:HandleButton(centerDisplay.button)

		local reward = suggestion.reward

		reward:HookScript("OnEnter", rewardOnEnter)
		reward.iconRing:Hide()
		reward.iconRingHighlight:SetTexture("")
		MERS:CreateBG(reward.icon)
	end

	-- Hook functions
	hooksecurefunc("EJSuggestFrame_RefreshDisplay", function()
		local self = suggestFrame

		if #self.suggestions > 0 then
			local suggestion = self.Suggestion1
			local data = self.suggestions[1]

			suggestion.iconRing:Hide()

			if data.iconPath then
				suggestion.icon:SetMask("")
				suggestion.icon:SetTexture(data.iconPath)
				suggestion.icon:SetTexCoord(.08, .92, .08, .92)
			end
		end

		if #self.suggestions > 1 then
			for i = 2, #self.suggestions do
				local suggestion = self["Suggestion"..i]
				if not suggestion then break end

				local data = self.suggestions[i]

				suggestion.iconRing:Hide()

				if data.iconPath then
					suggestion.icon:SetMask("")
					suggestion.icon:SetTexture(data.iconPath)
					suggestion.icon:SetTexCoord(.08, .92, .08, .92)
				end
			end
		end
	end)

	hooksecurefunc("EJSuggestFrame_UpdateRewards", function(suggestion)
		local rewardData = suggestion.reward.data
		if rewardData then
			local texture = rewardData.itemIcon or rewardData.currencyIcon or [[Interface\Icons\achievement_guildperk_mobilebanking]]
			suggestion.reward.icon:SetMask("")
			suggestion.reward.icon:SetTexture(texture)
			suggestion.reward.icon:SetTexCoord(.08, .92, .08, .92)
		end
	end)
end

S:AddCallbackForAddon("Blizzard_EncounterJournal", "mUIEncounterJournal", styleEncounterJournal)