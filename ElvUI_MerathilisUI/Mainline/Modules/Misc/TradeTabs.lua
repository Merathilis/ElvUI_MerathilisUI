local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Misc')
local S = MER:GetModule('MER_Skins')

local pairs, tinsert, select = pairs, tinsert, select
local GetSpellCooldown, GetSpellInfo, GetItemCooldown, GetItemCount, GetItemInfo = GetSpellCooldown, GetSpellInfo, GetItemCooldown, GetItemCount, GetItemInfo
local IsPassiveSpell, IsCurrentSpell, IsPlayerSpell, UseItemByName = IsPassiveSpell, IsCurrentSpell, IsPlayerSpell, UseItemByName
local GetProfessions, GetProfessionInfo, GetSpellBookItemInfo = GetProfessions, GetProfessionInfo, GetSpellBookItemInfo
local PlayerHasToy, C_ToyBox_IsToyUsable, C_ToyBox_GetToyInfo = PlayerHasToy, C_ToyBox.IsToyUsable, C_ToyBox.GetToyInfo
local C_TradeSkillUI_GetOnlyShowSkillUpRecipes, C_TradeSkillUI_SetOnlyShowSkillUpRecipes = C_TradeSkillUI.GetOnlyShowSkillUpRecipes, C_TradeSkillUI.SetOnlyShowSkillUpRecipes
local C_TradeSkillUI_GetOnlyShowMakeableRecipes, C_TradeSkillUI_SetOnlyShowMakeableRecipes = C_TradeSkillUI.GetOnlyShowMakeableRecipes, C_TradeSkillUI.SetOnlyShowMakeableRecipes

local BOOKTYPE_PROFESSION = BOOKTYPE_PROFESSION
local RUNEFORGING_ID = 53428
local PICK_LOCK = 1804
local CHEF_HAT = 134020
local THERMAL_ANVIL = 87216
local ENCHANTING_VELLUM = 38682

local tabList = {}

local onlyPrimary = {
	[171] = true, -- Alchemy
	[182] = true, -- Herbalism
	[186] = true, -- Mining
	[202] = true, -- Engineering
	[356] = true, -- Fishing
	[393] = true, -- Skinning
}

function module:UpdateProfessions()
	local prof1, prof2, _, fish, cook = GetProfessions()
	local profs = { prof1, prof2, fish, cook }

	if E.myclass == "DEATHKNIGHT" then
		module:TradeTabs_Create(RUNEFORGING_ID)
	elseif E.myclass == "ROGUE" and IsPlayerSpell(PICK_LOCK) then
		module:TradeTabs_Create(PICK_LOCK)
	end

	local isCook
	for _, prof in pairs(profs) do
		local _, _, _, _, numSpells, spelloffset, skillLine = GetProfessionInfo(prof)
		if skillLine == 185 then
			isCook = true
		end

		numSpells = onlyPrimary[skillLine] and 1 or numSpells
		if numSpells > 0 then
			for i = 1, numSpells do
				local slotID = i + spelloffset
				if not IsPassiveSpell(slotID, BOOKTYPE_PROFESSION) then
					local spellID = select(2, GetSpellBookItemInfo(slotID, BOOKTYPE_PROFESSION))
					if i == 1 then
						module:TradeTabs_Create(spellID)
					else
						module:TradeTabs_Create(spellID)
					end
				end
			end
		end
	end

	if isCook and PlayerHasToy(CHEF_HAT) and C_ToyBox_IsToyUsable(CHEF_HAT) then
		module:TradeTabs_Create(nil, CHEF_HAT)
	end
	if GetItemCount(THERMAL_ANVIL) > 0 then
		module:TradeTabs_Create(nil, nil, THERMAL_ANVIL)
	end
end

function module:TradeTabs_Update()
	for _, tab in pairs(tabList) do
		local spellID = tab.spellID
		local itemID = tab.itemID

		if IsCurrentSpell(spellID) then
			tab:SetChecked(true)
			tab.cover:Show()
		else
			tab:SetChecked(false)
			tab.cover:Hide()
		end

		local start, duration
		if itemID then
			start, duration = GetItemCooldown(itemID)
		else
			start, duration = GetSpellCooldown(spellID)
		end
		if start and duration and duration > 1.5 then
			tab.CD:SetCooldown(start, duration)
		end
	end
end

function module:TradeTabs_Reskin()
	for _, tab in pairs(tabList) do
		tab:SetCheckedTexture(E.media.normTex)
		tab:GetCheckedTexture():SetVertexColor(F.r, F.g, F.b, .65)
		tab:GetRegions():Hide()
		S:CreateBDFrame(tab)
		local texture = tab:GetNormalTexture()
		if texture then texture:SetTexCoord(unpack(E.TexCoords)) end
	end
end

local index = 1
function module:TradeTabs_Create(spellID, toyID, itemID)
	local name, _, texture
	if toyID then
		_, name, texture = C_ToyBox_GetToyInfo(toyID)
	elseif itemID then
		name, _, _, _, _, _, _, _, _, texture = GetItemInfo(itemID)
	else
		name, _, texture = GetSpellInfo(spellID)
	end
	if not name then
		return
	end

	local tab = CreateFrame("CheckButton", nil, _G.ProfessionsFrame, "SpellBookSkillLineTabTemplate, SecureActionButtonTemplate")
	tab.tooltip = name
	tab.spellID = spellID
	tab.itemID = toyID or itemID
	tab.type = (toyID and "toy") or (itemID and "item") or "spell"
	tab:RegisterForClicks("AnyDown")

	if spellID == 818 then-- cooking fire
		tab:SetAttribute("type", "macro")
		tab:SetAttribute("macrotext", "/cast [@player]" .. name)
	else
		tab:SetAttribute("type", tab.type)
		tab:SetAttribute(tab.type, spellID or name)
	end

	tab:SetNormalTexture(texture)
	tab:GetHighlightTexture():SetColorTexture(F.r, F.g, F.b, 0.5)
	tab:Show()

	tab.CD = CreateFrame("Cooldown", nil, tab, "CooldownFrameTemplate")
	tab.CD:SetAllPoints()

	tab.cover = CreateFrame("Frame", nil, tab)
	tab.cover:SetAllPoints()
	tab.cover:EnableMouse(true)

	tab:SetPoint("TOPLEFT", _G.ProfessionsFrame, "TOPRIGHT", 3, -index * 42)
	tinsert(tabList, tab)

	index = index + 1
end

function module:TradeTabs_FilterIcons()
	local buttonList = {
		[1] = {"Atlas:bags-greenarrow", TRADESKILL_FILTER_HAS_SKILL_UP, C_TradeSkillUI_GetOnlyShowSkillUpRecipes, C_TradeSkillUI_SetOnlyShowSkillUpRecipes},
		[2] = {"Interface\\RAIDFRAME\\ReadyCheck-Ready", CRAFT_IS_MAKEABLE, C_TradeSkillUI_GetOnlyShowMakeableRecipes, C_TradeSkillUI_SetOnlyShowMakeableRecipes},
	}

	local function filterClick(self)
		local value = self.__value
		if value[3]() then
			value[4](false)
			self.bg:SetBackdropBorderColor(F.r, F.g, F.b)
		else
			value[4](true)
			self.bg:SetBackdropBorderColor(1, 0.8, 0)
		end
	end

	local buttons = {}
	for index, value in pairs(buttonList) do
		local bu = CreateFrame("Button", nil, _G.ProfessionsFrame.CraftingPage, "BackdropTemplate")
		bu:SetSize(22, 22)
		bu:SetPoint("BOTTOMRIGHT", _G.ProfessionsFrame.CraftingPage.RecipeList.FilterButton, "TOPRIGHT", -(index - 1) * 27, 10)
		F.PixelIcon(bu, value[1], true)
		bu.Icon = bu:CreateTexture(nil, "ARTWORK")
		local atlas = string.match(value[1], "Atlas:(.+)$")
		if atlas then
			bu.Icon:SetAtlas(atlas)
		else
			bu.Icon:SetTexture(value[1])
		end
		bu.Icon:SetAllPoints()
		bu.Icon:SetTexCoord(E.TexCoords[1], E.TexCoords[2], E.TexCoords[3], E.TexCoords[4])
		F.AddTooltip(bu, "ANCHOR_TOP", value[2])
		bu.__value = value
		bu:SetScript("OnClick", filterClick)

		buttons[index] = bu
	end

	local function updateFilterStatus()
		for index, value in pairs(buttonList) do
			if value[3]() then
				buttons[index].bg:SetBackdropBorderColor(1, 0.8, 0)
			else
				buttons[index].bg:SetBackdropBorderColor(F.r, F.g, F.b)
			end
		end
	end

	MER:RegisterEvent("TRADE_SKILL_LIST_UPDATE", updateFilterStatus)
end

local init
function module:TradeTabs_OnLoad()
	init = true

	module:UpdateProfessions()

	module:TradeTabs_Reskin()
	module:TradeTabs_Update()
	MER:RegisterEvent("TRADE_SKILL_SHOW", module.TradeTabs_Update)
	MER:RegisterEvent("TRADE_SKILL_CLOSE", module.TradeTabs_Update)
	MER:RegisterEvent("CURRENT_SPELL_CAST_CHANGED", module.TradeTabs_Update)

	module:TradeTabs_FilterIcons()
	module:TradeTabs_QuickEnchanting()

	MER:UnregisterEvent("PLAYER_REGEN_ENABLED", module.TradeTabs_OnLoad)
end

local isEnchanting
local tooltipString = "|cffffffff%s(%d)"
function module:TradeTabs_QuickEnchanting()
	if _G.ProfessionsFrame.CraftingPage.ValidateControls then
		hooksecurefunc(_G.ProfessionsFrame.CraftingPage, "ValidateControls", function(self)
			isEnchanting = nil
			local currentRecipeInfo = self.SchematicForm:GetRecipeInfo()
			if currentRecipeInfo and currentRecipeInfo.alternateVerb then
				local professionInfo = _G.ProfessionsFrame:GetProfessionInfo()
				if professionInfo and professionInfo.parentProfessionID == 333 then
					isEnchanting = true
					self.CreateButton.tooltipText = format(tooltipString, "Right click to use Vellum", GetItemCount(ENCHANTING_VELLUM))
				end
			end
		end)
	end

	local createButton = _G.ProfessionsFrame.CraftingPage.CreateButton
	createButton:RegisterForClicks("AnyUp")
	createButton:HookScript("OnClick", function(_, btn)
		if btn == "RightButton" and isEnchanting then
			UseItemByName(ENCHANTING_VELLUM)
		end
	end)
end

function module:TradeTabs()
	module.db = E.db.mui.misc.tradeTabs

	if not _G.ProfessionsFrame then
		return
	end

	if not module.db or not (E.private.skins.blizzard.enable and E.private.skins.blizzard.tradeskill) then
		return
	end

	_G.ProfessionsFrame:HookScript("OnShow", function()
		if init then
			return
		end
		if InCombatLockdown() then
			MER:RegisterEvent("PLAYER_REGEN_ENABLED", module.TradeTabs_OnLoad)
		else
			module:TradeTabs_OnLoad()
		end
	end)
end

module:AddCallback("TradeTabs")
