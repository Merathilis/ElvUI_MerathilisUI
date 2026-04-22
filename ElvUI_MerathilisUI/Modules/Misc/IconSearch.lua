local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc") ---@class Misc
local S = E:GetModule("Skins")

local ipairs = ipairs
local tinsert, twipe = table.insert, table.wipe

local C_CurrencyInfo_GetCurrencyInfo = C_CurrencyInfo.GetCurrencyInfo
local C_Spell_GetSpellTexture = C_Spell.GetSpellTexture
local C_Item_GetItemIconByID = C_Item.GetItemIconByID
local GetPvpTalentInfoByID = GetPvpTalentInfoByID
local GetAchievementInfo = GetAchievementInfo

local results = {}

function module:IconSearch_DoSearch(frame, str)
	local buttons = frame.SearchResults.buttons
	for i = 1, #buttons do
		local button = buttons[i]
		button.icon = nil
		button:Hide()
	end

	twipe(results)

	local id = tonumber(str)
	if not id then
		return
	end

	local spell = C_Spell_GetSpellTexture(id)
	if spell then
		tinsert(results, spell)
	end

	local item = C_Item_GetItemIconByID(id)
	if item then
		tinsert(results, item)
	end

	local pvptal = select(3, GetPvpTalentInfoByID(id))
	if pvptal then
		tinsert(results, pvptal)
	end

	local achievement = select(10, GetAchievementInfo(id))
	if achievement then
		tinsert(results, achievement)
	end

	local info = C_CurrencyInfo_GetCurrencyInfo(id)
	if info and info.iconFileID then
		tinsert(results, info.iconFileID)
	end

	if frame:GetIndexOfIcon(id) then
		tinsert(results, id)
	end

	if #results > 0 then
		for i, icon in ipairs(results) do
			local button = buttons[i]
			button.icon = icon
			button.Icon:SetTexture(icon)
			button:Show()
		end
	end
end

local function SearchBox_OnEscapePressed(self)
	self:SetText("")
end

local function SearchBox_OnTextChanged(self)
	local text = self:GetText()
	local frame = self.__owner
	if text and text ~= "" then
		module:IconSearch_DoSearch(frame, text)
		frame.IconSelector:Hide()
	else
		frame.IconSelector:Show()
	end
end

local function Button_OnClick(self)
	if not self.icon then
		return
	end

	local frame = self.__owner
	frame.IconSelector:SetSelectedIndex(frame:GetIndexOfIcon(self.icon))
	frame.IconSelector:ScrollToSelectedIndex()
	frame.BorderBox.SelectedIconArea.SelectedIconButton:SetIconTexture(self.icon)
	frame.SearchBox:SetText("")
end

local function IconSelector_OnShow(self)
	self:GetParent().SearchResults:Hide()
end

local function IconSelector_OnHide(self)
	self:GetParent().SearchResults:Show()
end

function module:IconSearch_Setup()
	if not self.SearchBox then
		local editbox = CreateFrame("EditBox", nil, self, "SearchBoxTemplate")
		S:HandleEditBox(editbox)
		editbox:SetSize(160, 20)
		editbox.__owner = self
		editbox:SetMaxLetters(10)
		editbox:SetPoint("TOPRIGHT", -80, -35)
		editbox:HookScript("OnEscapePressed", SearchBox_OnEscapePressed)
		editbox:HookScript("OnTextChanged", SearchBox_OnTextChanged)
		self.SearchBox = editbox

		local helpInfo = CreateFrame("Frame", nil, editbox)
		helpInfo:SetOutside(editbox.searchIcon, 6, 6)
		helpInfo.title = L["IconSearch"]
		F.AddTooltip(helpInfo, "ANCHOR_RIGHT", L["IconSearchTip"], "info")

		local resultFrame = CreateFrame("Frame", nil, self)
		resultFrame:SetFrameStrata("HIGH")
		resultFrame:SetSize(494, 375)
		resultFrame:SetPoint("TOPLEFT", self.IconSelector, "TOPLEFT")
		resultFrame:Hide()
		self.SearchResults = resultFrame

		local buttons = {}
		for i = 1, 10 do
			local button = CreateFrame("Button", nil, resultFrame)
			button.__owner = self
			button:SetSize(36, 36)
			button.Icon = button:CreateTexture(nil, "ARTWORK")
			button.Icon:SetSize(36, 36)
			button.Icon:SetPoint("CENTER", 0, -1)
			button:SetHighlightTexture(0)
			local hl = button:GetHighlightTexture()
			hl:SetColorTexture(1, 1, 1, 0.25)
			hl:SetAllPoints(button.Icon)
			S:HandleIcon(button.Icon)
			button:SetScript("OnClick", Button_OnClick)
			button:Hide()
			buttons[i] = button

			if i == 1 then
				button:SetPoint("TOPLEFT", 5, -5)
			else
				button:SetPoint("LEFT", buttons[i - 1], "RIGHT", 10, 0)
			end
		end
		resultFrame.buttons = buttons

		self.IconSelector:HookScript("OnShow", IconSelector_OnShow)
		self.IconSelector:HookScript("OnHide", IconSelector_OnHide)
		self.BorderBox.SelectedIconArea.SelectedIconText:Hide()
	end
end

function module:IconSearch()
	hooksecurefunc(IconSelectorPopupFrameTemplateMixin, "OnShow", module.IconSearch_Setup)
end

module:AddCallback("IconSearch")
