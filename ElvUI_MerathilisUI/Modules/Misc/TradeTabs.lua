local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc")

local _G = _G
local next, pairs, unpack = next, pairs, unpack

local CreateFrame = CreateFrame
local GetProfessions = GetProfessions
local GetProfessionInfo = GetProfessionInfo
local PlayerHasToy = PlayerHasToy

local C_AddOns_IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local C_Spell_IsCurrentSpell = C_Spell.IsCurrentSpell
local C_Spell_GetSpellInfo = C_Spell.GetSpellInfo
local C_Spell_GetSpellTexture = C_Spell.GetSpellTexture
local C_SpellBook_GetSpellBookItemName = C_SpellBook.GetSpellBookItemName
local C_SpellBook_GetSpellBookItemTexture = C_SpellBook.GetSpellBookItemTexture
local C_SpellBook_GetSpellBookItemInfo = C_SpellBook.GetSpellBookItemInfo
local C_TradeSkillUI_GetOnlyShowSkillUpRecipes = C_TradeSkillUI.GetOnlyShowSkillUpRecipes
local C_TradeSkillUI_SetOnlyShowSkillUpRecipes = C_TradeSkillUI.SetOnlyShowSkillUpRecipes
local C_TradeSkillUI_GetOnlyShowMakeableRecipes = C_TradeSkillUI.GetOnlyShowMakeableRecipes
local C_TradeSkillUI_SetOnlyShowMakeableRecipes = C_TradeSkillUI.SetOnlyShowMakeableRecipes
local C_ToyBox_IsToyUsable = C_ToyBox.IsToyUsable

local tabs, spells = {}, {}

local handler = CreateFrame("Frame")
handler:SetScript("OnEvent", function(self, event)
	self[event](self, event)
end)

local function FilterIcons()
	local buttonList = {
		[1] = {
			"Professions-Icon-Skill-High",
			_G.TRADESKILL_FILTER_HAS_SKILL_UP,
			C_TradeSkillUI_GetOnlyShowSkillUpRecipes,
			C_TradeSkillUI_SetOnlyShowSkillUpRecipes,
		},
		[2] = {
			"Interface\\RAIDFRAME\\ReadyCheck-Ready",
			_G.CRAFT_IS_MAKEABLE,
			C_TradeSkillUI_GetOnlyShowMakeableRecipes,
			C_TradeSkillUI_SetOnlyShowMakeableRecipes,
		},
	}

	local function filterClick(self)
		local value = self.__value
		if value[3]() then
			value[4](false)
			self:SetBackdropBorderColor(unpack(E.media.bordercolor))
		else
			value[4](true)
			self:SetBackdropBorderColor(1, 0.8, 0)
		end
	end

	local buttons = {}
	for index, value in pairs(buttonList) do
		local button = CreateFrame("Button", nil, _G.ProfessionsFrame.CraftingPage.RecipeList, "BackdropTemplate")
		button:SetSize(22, 22)
		button:SetPoint(
			"BOTTOMRIGHT",
			_G.ProfessionsFrame.CraftingPage.RecipeList.FilterButton,
			"TOPRIGHT",
			-(index - 1) * 27,
			10
		)
		button:CreateBackdrop()
		button.Icon = button:CreateTexture(nil, "OVERLAY")
		if index == 1 then
			button.Icon:SetAtlas(value[1])
		else
			button.Icon:SetTexture(value[1])
		end
		button.Icon:SetPoint("TOPLEFT", button, 2, -2)
		button.Icon:SetPoint("BOTTOMRIGHT", button, -2, 2)

		local tooltip_hide = function(self)
			GameTooltip:Hide()
			if self.backdrop then
				self.backdrop:SetVertexColor(0.1, 0.1, 0.1, 1)
			end
		end

		local tooltip_show = function(self)
			GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT", 0, 3)
			GameTooltip:ClearLines()
			GameTooltip:SetText(value[2])
			if self.backdrop then
				self.backdrop:SetVertexColor(1, 1, 1, 0.3)
			end
		end
		button:SetScript("OnEnter", tooltip_show)
		button:SetScript("OnLeave", tooltip_hide)

		button.__value = value
		button:SetScript("OnClick", filterClick)

		buttons[index] = button
	end

	function handler:TRADE_SKILL_LIST_UPDATE()
		for index, value in pairs(buttonList) do
			if value[3]() then
				buttons[index]:SetBackdropBorderColor(1, 0.8, 0)
			else
				buttons[index]:SetBackdropBorderColor(unpack(E.media.bordercolor))
			end
		end
	end
	handler:RegisterEvent("TRADE_SKILL_LIST_UPDATE")
end

local defaults = {
	-- Primary Professions
	[171] = { true, false }, -- Alchemy
	[164] = { true, false }, -- Blacksmithing
	[333] = { true, true }, -- Enchanting
	[202] = { true, false }, -- Engineering
	[182] = { true, false }, -- Herbalism
	[773] = { true, true }, -- Inscription
	[755] = { true, true }, -- Jewelcrafting
	[165] = { true, false }, -- Leatherworking
	[186] = { true, false }, -- Mining
	[393] = { true, false }, -- Skinning
	[197] = { true, false }, -- Tailoring

	-- Secondary Professions
	[794] = { false, false }, -- Archaeology
	[185] = { true, true }, -- Cooking
	[356] = { false, false }, -- Fishing
}

if E.myclass == "DEATHKNIGHT" then
	spells[#spells + 1] = 53428
end -- Runeforging
if E.myclass == "ROGUE" then
	spells[#spells + 1] = 1804
end -- Pick Lock

local function UpdateSelectedTabs(object)
	if not handler:IsEventRegistered("CURRENT_SPELL_CAST_CHANGED") then
		handler:RegisterEvent("CURRENT_SPELL_CAST_CHANGED")
	end

	for index = 1, #tabs[object] do
		local tab = tabs[object][index]
		if tab.spellID and C_Spell_IsCurrentSpell(tab.spellID) then
			tab:Disable()
			tab:SetChecked(true)
		else
			tab:Enable()
			tab:SetChecked(false)
		end
	end
end

local function ResetTabs(object)
	for index = 1, #tabs[object] do
		tabs[object][index]:Hide()
	end

	tabs[object].index = 0
end

local function UpdateTab(object, name, texture, spellID)
	local index = tabs[object].index + 1
	local tab = tabs[object][index]
		or CreateFrame("CheckButton", "ProTabs" .. tabs[object].index, object, "SecureActionButtonTemplate")
	tab:RegisterForClicks("LeftButtonUp", "LeftButtonDown")

	tab:SetSize(36, 36)
	tab:ClearAllPoints()

	if not tab.icon then
		tab.icon = tab:CreateTexture("$parentIcon")
		tab.icon:SetAllPoints()

		tab:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
		tab:GetHighlightTexture():SetBlendMode("ADD")
		tab:SetCheckedTexture("Interface\\Buttons\\CheckButtonHilight")
		tab:GetCheckedTexture():SetBlendMode("ADD")
	end

	tab:SetPoint("TOPLEFT", object, "TOPRIGHT", 1, (-44 * index) + 44)
	tab:SetTemplate()
	tab:StyleButton()
	tab.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	tab.icon:ClearAllPoints()
	tab.icon:SetPoint("TOPLEFT", 2, -2)
	tab.icon:SetPoint("BOTTOMRIGHT", -2, 2)

	tab.icon:SetTexture(texture)

	if texture == 236571 then -- Chef's Hat
		tab:SetAttribute("type", "toy")
		tab:SetAttribute("toy", 134020)
	elseif texture == 135805 then -- Cooking Fire
		tab:SetAttribute("type", "macro")
		tab:SetAttribute("macrotext", "/cast [@player]" .. name)
	else
		tab:SetAttribute("type", "spell")
		tab:SetAttribute("spell", spellID or name)
	end

	tab:Show()

	tab.name = name
	tab.spellID = spellID

	tab:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 5, -7)
		GameTooltip:SetText(name)
		GameTooltip:Show()
	end)

	tab:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	tabs[object][index] = tabs[object][index] or tab
	tabs[object].index = tabs[object].index + 1
end

local function HandleProfession(object, professionID, hat)
	if professionID then
		local _, _, _, _, numAbilities, offset, skillID = GetProfessionInfo(professionID)

		if defaults[skillID] then
			for index = 1, numAbilities do
				if defaults[skillID][index] then
					local name = C_SpellBook_GetSpellBookItemName(offset + index, 0)
					local texture = C_SpellBook_GetSpellBookItemTexture(offset + index, 0)
					local spellID = C_SpellBook_GetSpellBookItemInfo(offset + index, 0).spellID

					if name and texture then
						UpdateTab(object, name, texture, spellID)
					end
				end
			end
		end

		if hat and PlayerHasToy(134020) and C_ToyBox_IsToyUsable(134020) then
			UpdateTab(object, E:GetSpellInfo(67556), C_Spell_GetSpellTexture(67556), 134020)
		end
	end
end

local function HandleTabs(object)
	if not object then
		return
	end
	tabs[object] = tabs[object] or {}

	if InCombatLockdown() then
		handler:RegisterEvent("PLAYER_REGEN_ENABLED")
	else
		local firstProfession, secondProfession, archaeology, fishing, cooking = GetProfessions()

		ResetTabs(object)

		HandleProfession(object, firstProfession)
		HandleProfession(object, secondProfession)
		HandleProfession(object, archaeology)
		HandleProfession(object, fishing)
		HandleProfession(object, cooking, true)

		-- Runuforging and Pick Lock
		for index = 1, #spells do
			if IsSpellKnown(spells[index]) then
				local name = E:GetSpellInfo(spells[index])
				local texture = C_Spell_GetSpellTexture(spells[index])
				UpdateTab(object, name, texture, spells[index])
			end
		end
	end

	UpdateSelectedTabs(object)
end

local isLoaded
function handler:TRADE_SKILL_SHOW(event)
	local owner = ATSWFrame or MRTSkillFrame or SkilletFrame or _G.ProfessionsFrame

	if C_AddOns_IsAddOnLoaded("TradeSkillDW") and owner == _G.ProfessionsFrame then
		self:UnregisterEvent(event)
	else
		HandleTabs(owner)
		UpdateSelectedTabs(owner)
		if not isLoaded then
			FilterIcons()
			isLoaded = true
		end
	end
end

function handler:TRADE_SKILL_CLOSE()
	for object in next, tabs do
		if object:IsShown() then
			UpdateSelectedTabs(object)
		end
	end
end

function handler:TRADE_SHOW(event)
	local owner = _G.TradeFrame

	HandleTabs(owner)
	self[event] = function()
		UpdateSelectedTabs(owner)
	end
end

function handler:PLAYER_REGEN_ENABLED(event)
	self:UnregisterEvent(event)

	for object in next, tabs do
		HandleTabs(object)
	end
end

function handler:SKILL_LINES_CHANGED()
	for object in next, tabs do
		HandleTabs(object)
	end
end

function handler:CURRENT_SPELL_CAST_CHANGED(event)
	local numShown = 0

	for object in next, tabs do
		if object:IsShown() then
			numShown = numShown + 1
			UpdateSelectedTabs(object)
		end
	end

	if numShown == 0 then
		self:UnregisterEvent(event)
	end
end

function module:TradeTabs()
	if not E.db.mui.misc.tradeTabs then
		return
	end

	handler:RegisterEvent("TRADE_SKILL_SHOW")
	handler:RegisterEvent("TRADE_SKILL_CLOSE")
	handler:RegisterEvent("TRADE_SHOW")
	handler:RegisterEvent("SKILL_LINES_CHANGED")
	handler:RegisterEvent("CURRENT_SPELL_CAST_CHANGED")
end

module:AddCallback("TradeTabs")
