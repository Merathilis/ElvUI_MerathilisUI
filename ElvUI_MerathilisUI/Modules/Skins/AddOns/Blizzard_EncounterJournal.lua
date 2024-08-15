local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local _G = _G

local CreateColor = CreateColor

local function ReplaceBlackColor(text, r, g, b)
	if r == 0 and g == 0 and b == 0 then
		text:SetTextColor(0.7, 0.7, 0.7)
	end
end

local function HandleText(button)
	local container = button.TextContainer
	if container and not container.IsSkinned then
		hooksecurefunc(container.NameText, "SetTextColor", ReplaceBlackColor)
		hooksecurefunc(container.ConditionsText, "SetTextColor", ReplaceBlackColor)

		container.IsSkinned = true
	end
end

function module:Blizzard_EncounterJournal()
	if not module:CheckDB("encounterjournal", "encounterjournal") then
		return
	end

	local EncounterJournal = _G.EncounterJournal
	module:CreateShadow(EncounterJournal)

	-- Bottom tabs
	local tabs = {
		_G.EncounterJournalMonthlyActivitiesTab,
		_G.EncounterJournalSuggestTab,
		_G.EncounterJournalDungeonTab,
		_G.EncounterJournalRaidTab,
		_G.EncounterJournalLootJournalTab,
	}

	for _, tab in pairs(tabs) do
		module:ReskinTab(tab)
	end

	local SuggestFrame = _G.EncounterJournalSuggestFrame
	-- Suggestion 1
	local suggestion1 = SuggestFrame.Suggestion1
	if suggestion1 then
		suggestion1.bg:Hide()
		suggestion1:SetTemplate("Transparent")
		suggestion1.icon:SetPoint("TOPLEFT", 135, -15)

		local centerDisplay = suggestion1.centerDisplay
		centerDisplay.title.text:SetTextColor(1, 1, 1)
		centerDisplay.description.text:SetTextColor(0.9, 0.9, 0.9)

		local reward = suggestion1.reward
		reward.text:SetTextColor(0.9, 0.9, 0.9)
	end

	for i = 2, 3 do
		local suggestion = SuggestFrame["Suggestion" .. i]

		suggestion.bg:Hide()
		suggestion:SetTemplate("Transparent")
		suggestion.icon:SetPoint("TOPLEFT", 10, -10)

		local centerDisplay = suggestion.centerDisplay

		centerDisplay:ClearAllPoints()
		centerDisplay:SetPoint("TOPLEFT", 85, -10)
		centerDisplay.title.text:SetTextColor(1, 1, 1)
		centerDisplay.description.text:SetTextColor(0.9, 0.9, 0.9)
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
				if not suggestion then
					break
				end

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
		local info = _G.EncounterJournal.encounter.info
		local tab = info[name]
		module:CreateBackdropShadow(tab)

		tab:ClearAllPoints()
		if name == "overviewTab" then
			tab:SetPoint("TOPLEFT", _G.EncounterJournalEncounterFrameInfo, "TOPRIGHT", 13, -55)
			hooksecurefunc(tab, "Point", function(self)
				self:ClearAllPoints()
				self:SetPoint("TOPLEFT", _G.EncounterJournalEncounterFrameInfo, "TOPRIGHT", 13, -55)
			end)
		elseif name == "lootTab" then
			tab:SetPoint("TOPLEFT", _G.EncounterJournal.encounter.info.overviewTab, "BOTTOMLEFT", 0, -4)
			hooksecurefunc(tab, "Point", function(self)
				self:ClearAllPoints()
				tab:SetPoint("TOPLEFT", _G.EncounterJournal.encounter.info.overviewTab, "BOTTOMLEFT", 0, -4)
			end)
		elseif name == "bossTab" then
			tab:SetPoint("TOPLEFT", _G.EncounterJournal.encounter.info.lootTab, "BOTTOMLEFT", 0, -4)
			hooksecurefunc(tab, "Point", function(self)
				self:ClearAllPoints()
				tab:SetPoint("TOPLEFT", _G.EncounterJournal.encounter.info.lootTab, "BOTTOMLEFT", 0, -4)
			end)
		elseif name == "modelTab" then
			tab:SetPoint("TOPLEFT", _G.EncounterJournal.encounter.info.bossTab, "BOTTOMLEFT", 0, -4)
			hooksecurefunc(tab, "Point", function(self)
				self:ClearAllPoints()
				tab:SetPoint("TOPLEFT", _G.EncounterJournal.encounter.info.bossTab, "BOTTOMLEFT", 0, -4)
			end)
		end
	end

	-- Encounter Frame
	_G.EncounterJournalEncounterFrameInfo:DisableDrawLayer("BACKGROUND")
	_G.EncounterJournalInstanceSelectBG:Hide()
	_G.EncounterJournalEncounterFrameInfoModelFrameShadow:Hide()
	_G.EncounterJournalEncounterFrameInfoModelFrame.dungeonBG:Hide()

	_G.EncounterJournalEncounterFrameInfoEncounterTitle:SetTextColor(1, 0.8, 0)

	_G.EncounterJournal.encounter.instance.LoreScrollingFont:SetTextColor(CreateColor(1, 1, 1))
	_G.EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChild.overviewDescription.Text:SetTextColor(
		"P",
		1,
		1,
		1
	)

	_G.EncounterJournalEncounterFrameInfoDetailsScrollFrameScrollChildDescription:SetTextColor(1, 1, 1)
	_G.EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildHeader:Hide()
	_G.EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildTitle:SetFontObject("GameFontNormalLarge")
	_G.EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildLoreDescription:SetTextColor(1, 1, 1)
	_G.EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildTitle:SetTextColor(1, 0.8, 0)

	_G.EncounterJournalEncounterFrameInfoModelFrame:CreateBackdrop("Transparent")
	_G.EncounterJournalEncounterFrameInfoCreatureButton1:SetPoint(
		"TOPLEFT",
		EncounterJournalEncounterFrameInfoModelFrame,
		0,
		-35
	)

	hooksecurefunc(EncounterJournal.encounter.info.BossesScrollBox, "Update", function(self)
		for i = 1, self.ScrollTarget:GetNumChildren() do
			local child = select(i, self.ScrollTarget:GetChildren())
			if not child.styled then
				S:HandleButton(child)
				local hl = child:GetHighlightTexture()
				hl:SetColorTexture(F.r, F.g, F.b, 0.25)
				hl:SetInside(child.backdrop)

				child.text:SetTextColor(1, 1, 1)
				child.text.SetTextColor = E.noop
				child.creature:SetPoint("TOPLEFT", 0, -4)

				child.styled = true
			end
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

	-- Monthly activities
	local ActivitiesFrame = _G.EncounterJournalMonthlyActivitiesFrame
	if ActivitiesFrame then
		hooksecurefunc(ActivitiesFrame.ScrollBox, "Update", function(self)
			self:ForEachFrame(HandleText)
		end)

		ActivitiesFrame.ShadowLeft:SetAlpha(0)
		ActivitiesFrame.ShadowRight:SetAlpha(0)

		ActivitiesFrame.FilterList:SetTemplate("Transparent")
		ActivitiesFrame.ScrollBox:SetTemplate("Transparent")
	end
end

module:AddCallbackForAddon("Blizzard_EncounterJournal")
