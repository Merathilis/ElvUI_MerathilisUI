local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G

local CreateColor = CreateColor

local function ReskinHeader(header)
	header.flashAnim.Play = E.noop
	for i = 4, 18 do
		select(i, header.button:GetRegions()):SetTexture()
	end
	S:HandleButton(header.button)
	header.descriptionBG:SetAlpha(0)
	header.descriptionBGBottom:SetAlpha(0)
	header.description:SetTextColor(1, 1, 1)
	header.button.title:SetTextColor(1, 1, 1)
	header.button.title.SetTextColor = E.noop
	header.button.expandedIcon:SetWidth(20)
end

local function ReskinSectionHeader()
	local index = 1
	while true do
		local header = _G["EncounterJournalInfoHeader" .. index]
		if not header then return end
		if not header.IsSkinned then
			ReskinHeader(header)
			S:HandleIcon(header.button.abilityIcon)
			header.styled = true
		end

		index = index + 1
	end
end

local function LoadSkin()
	if not module:CheckDB("encounterjournal", "encounterjournal") then
		return
	end

	local EncounterJournal = _G.EncounterJournal
	EncounterJournal:Styling()
	module:CreateShadow(EncounterJournal)

	-- Bottom tabs
	local tabs = {
		_G.EncounterJournalMonthlyActivitiesTab,
		_G.EncounterJournalSuggestTab,
		_G.EncounterJournalDungeonTab,
		_G.EncounterJournalRaidTab,
		_G.EncounterJournalLootJournalTab
	}

	for _, tab in pairs(tabs) do
		module:ReskinTab(tab)
	end

	local SuggestFrame = _G.EncounterJournalSuggestFrame
	-- Suggestion 1
	local suggestion1 = SuggestFrame.Suggestion1
	if suggestion1 then
		suggestion1.bg:Hide()
		suggestion1:SetTemplate('Transparent')
		module:CreateGradient(suggestion1)
		suggestion1.icon:SetPoint("TOPLEFT", 135, -15)

		local centerDisplay = suggestion1.centerDisplay
		centerDisplay.title.text:SetTextColor(1, 1, 1)
		centerDisplay.description.text:SetTextColor(.9, .9, .9)

		local reward = suggestion1.reward
		reward.text:SetTextColor(.9, .9, .9)
	end


	for i = 2, 3 do
		local suggestion = SuggestFrame["Suggestion" .. i]

		suggestion.bg:Hide()
		suggestion:SetTemplate('Transparent')
		module:CreateGradient(suggestion)
		suggestion.icon:SetPoint("TOPLEFT", 10, -10)

		local centerDisplay = suggestion.centerDisplay

		centerDisplay:ClearAllPoints()
		centerDisplay:SetPoint("TOPLEFT", 85, -10)
		centerDisplay.title.text:SetTextColor(1, 1, 1)
		centerDisplay.description.text:SetTextColor(.9, .9, .9)
	end

	hooksecurefunc("EJSuggestFrame_RefreshDisplay", function()
		local self = SuggestFrame

		if #self.suggestions > 0 then
			local suggestion = self.Suggestion1
			local data = self.suggestions[1]
			suggestion.iconRing:Hide()

			if data.iconPath then
				suggestion.icon:SetMask("")
				suggestion.icon:SetTexCoord(unpack(E.TexCoords))
			end
		end

		if #self.suggestions > 1 then
			for i = 2, #self.suggestions do
				local suggestion = self["Suggestion" .. i]
				if not suggestion then break end

				local data = self.suggestions[i]
				suggestion.iconRing:Hide()

				if data.iconPath then
					suggestion.icon:SetMask("")
					suggestion.icon:SetTexCoord(unpack(E.TexCoords))
				end
			end
		end
	end)

	for _, name in next, { "overviewTab", "modelTab", "bossTab", "lootTab" } do
		local tab = EncounterJournal.encounter.info[name]
		tab.backdrop:Styling()
		module:CreateGradient(tab.backdrop)
		module:CreateBackdropShadow(tab)
	end

	-- Encounter Frame
	_G.EncounterJournalEncounterFrameInfo:DisableDrawLayer("BACKGROUND")
	_G.EncounterJournalInstanceSelectBG:Hide()
	_G.EncounterJournalEncounterFrameInfoModelFrameShadow:Hide()
	_G.EncounterJournalEncounterFrameInfoModelFrame.dungeonBG:Hide()

	_G.EncounterJournalEncounterFrameInfoEncounterTitle:SetTextColor(1, .8, 0)

	_G.EncounterJournal.encounter.instance.LoreScrollingFont:SetTextColor(CreateColor(1, 1, 1))
	_G.EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChild.overviewDescription.Text:SetTextColor("P", 1, 1, 1)

	_G.EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollChildDescription:SetTextColor(1, 1, 1)
	_G.EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildHeader:Hide()
	_G.EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildTitle:SetFontObject("GameFontNormalLarge")
	_G.EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildLoreDescription:SetTextColor(1, 1, 1)
	_G.EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildTitle:SetTextColor(1, .8, 0)

	_G.EncounterJournalEncounterFrameInfoModelFrame:CreateBackdrop('Transparent')
	_G.EncounterJournalEncounterFrameInfoCreatureButton1:SetPoint("TOPLEFT", EncounterJournalEncounterFrameInfoModelFrame, 0, -35)

	hooksecurefunc(EncounterJournal.encounter.info.BossesScrollBox, "Update", function(self)
		for i = 1, self.ScrollTarget:GetNumChildren() do
			local child = select(i, self.ScrollTarget:GetChildren())
			if not child.styled then
				S:HandleButton(child)
				local hl = child:GetHighlightTexture()
				hl:SetColorTexture(F.r, F.g, F.b, .25)
				hl:SetInside(child.backdrop)

				child.text:SetTextColor(1, 1, 1)
				child.text.SetTextColor = E.noop
				child.creature:SetPoint("TOPLEFT", 0, -4)

				child.styled = true
			end
		end
	end)
	hooksecurefunc("EncounterJournal_ToggleHeaders", ReskinSectionHeader)

	hooksecurefunc("EncounterJournal_SetUpOverview", function(self, _, index)
		local header = self.overviews[index]
		if not header.styled then
			ReskinHeader(header)
			header.styled = true
		end
	end)

	hooksecurefunc("EncounterJournal_SetBullets", function(object)
		local parent = object:GetParent()
		if parent.Bullets then
			for _, bullet in pairs(parent.Bullets) do
				if not bullet.styled then
					bullet.Text:SetTextColor("P", 1, 1, 1)
					bullet.styled = true
				end
			end
		end
	end)

	hooksecurefunc(EncounterJournal.encounter.info.LootContainer.ScrollBox, "Update", function(self)
		for i = 1, self.ScrollTarget:GetNumChildren() do
			local child = select(i, self.ScrollTarget:GetChildren())
			if not child.IsSkinned then
				if child.boss then child.boss:SetTextColor(1, 1, 1) end
				if child.slot then child.slot:SetTextColor(1, 1, 1) end
				if child.armorType then child.armorType:SetTextColor(1, 1, 1) end

				if child.backdrop then
					module:CreateGradient(child.backdrop)
				end

				child.IsSkinned = true
			end
		end
	end)

end

S:AddCallbackForAddon("Blizzard_EncounterJournal", LoadSkin)
