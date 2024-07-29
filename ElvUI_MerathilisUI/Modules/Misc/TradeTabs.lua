local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc")
local S = MER:GetModule("MER_Skins")

local _G = _G
local pairs, unpack, tinsert = pairs, unpack, tinsert

local GetItemCooldown = C_Item.GetItemCooldown
local GetSpellCooldown = C_Spell.GetSpellCooldown
local IsPassiveSpell = C_Spell.IsSpellPassive
local IsCurrentSpell = C_Spell.IsCurrentSpell
local GetSpellBookItemInfo = C_SpellBook.GetSpellBookItemInfo
local GetItemCount = C_Item.GetItemCount
local GetItemInfo = C_Item.GetItemInfo
local PlayerHasToy = PlayerHasToy
local IsToyUsable = C_ToyBox.IsToyUsable
local GetToyInfo = C_ToyBox.GetToyInfo
local GetSpellName = C_Spell.GetSpellName
local GetSpellTexture = C_Spell.GetSpellTexture
local GetOnlyShowSkillUpRecipes, SetOnlyShowSkillUpRecipes =
	C_TradeSkillUI.GetOnlyShowSkillUpRecipes, C_TradeSkillUI.SetOnlyShowSkillUpRecipes
local GetOnlyShowMakeableRecipes, SetOnlyShowMakeableRecipes =
	C_TradeSkillUI.GetOnlyShowMakeableRecipes, C_TradeSkillUI.SetOnlyShowMakeableRecipes

local BOOKTYPE_PROFESSION = BOOKTYPE_PROFESSION or 0
local RUNEFORGING_ID = 53428
local PICK_LOCK = 1804
local CHEF_HAT = 134020
local THERMAL_ANVIL = 87216
local tabList = {}

local onlyPrimary = {
	[164] = true, -- Blacksmithing
	[165] = true, -- Leatherworking
	[171] = true, -- Alchemy
	[182] = true, -- Herbalism
	[186] = true, -- Mining
	[197] = true, -- Tailoring
	[202] = true, -- Engineering
	[333] = true, -- Enchanting
	[356] = true, -- Fishing
	[393] = true, -- Skinning
	[755] = true, -- Jewelcrafting
	[773] = true, -- Inscription
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
					local spellID = GetSpellBookItemInfo(slotID, BOOKTYPE_PROFESSION).spellID
					if i == 1 then
						module:TradeTabs_Create(spellID)
					else
						module:TradeTabs_Create(spellID)
					end
				end
			end
		end
	end

	if isCook and PlayerHasToy(CHEF_HAT) and IsToyUsable(CHEF_HAT) then
		module:TradeTabs_Create(nil, CHEF_HAT)
	end
	if GetItemCount(THERMAL_ANVIL) > 0 then
		module:TradeTabs_Create(nil, nil, THERMAL_ANVIL)
	end
end

function module:TradeTabs_Update()
	for _, tab in pairs(tabList) do
		local spellID = tab.spellID or 0
		local itemID = tab.itemID or 0

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
			local cooldownInfo = GetSpellCooldown(spellID)
			start = cooldownInfo and cooldownInfo.startTime
			duration = cooldownInfo and cooldownInfo.duration
		end
		if start and duration and duration > 1.5 then
			tab.CD:SetCooldown(start, duration)
		end
	end
end

function module:TradeTabs_Reskin()
	for _, tab in pairs(tabList) do
		tab:CreateBackdrop()
		tab.backdrop:SetAllPoints()
		tab:StyleButton(true)

		local normalTexture = tab:GetNormalTexture()
		if normalTexture then
			normalTexture:ClearAllPoints()
			normalTexture:SetPoint("TOPLEFT", 2, -2)
			normalTexture:SetPoint("BOTTOMRIGHT", -2, 2)
			normalTexture:SetTexCoord(unpack(E.TexCoords))
		end
	end
end

local index = 1
function module:TradeTabs_Create(spellID, toyID, itemID)
	local name, _, texture
	if toyID then
		_, name, texture = GetToyInfo(toyID)
	elseif itemID then
		name, _, _, _, _, _, _, _, _, texture = GetItemInfo(itemID)
	else
		name, texture = GetSpellName(spellID), GetSpellTexture(spellID)
	end
	if not name then
		return
	end -- precaution

	local tab = CreateFrame("CheckButton", nil, ProfessionsFrame, "SecureActionButtonTemplate")
	tab:SetSize(32, 32)
	tab.tooltip = name
	tab.spellID = spellID
	tab.itemID = toyID or itemID
	tab.type = (toyID and "toy") or (itemID and "item") or "spell"
	tab:RegisterForClicks("AnyDown")
	if spellID == 818 then -- cooking fire
		tab:SetAttribute("type", "macro")
		tab:SetAttribute("macrotext", "/cast [@player]" .. name)
	else
		tab:SetAttribute("type", tab.type)
		tab:SetAttribute(tab.type, spellID or name)
	end
	tab:SetNormalTexture(texture)
	tab:SetHighlightTexture(E.media.normTex)
	tab:GetHighlightTexture():SetVertexColor(1, 1, 1, 0.25)
	tab:Show()

	tab.CD = CreateFrame("Cooldown", nil, tab, "CooldownFrameTemplate")
	tab.CD:SetAllPoints()

	tab.cover = CreateFrame("Frame", nil, tab)
	tab.cover:SetAllPoints()
	tab.cover:EnableMouse(true)

	tab:SetPoint("TOPLEFT", ProfessionsFrame, "TOPRIGHT", 3, -index * 42)

	tinsert(tabList, tab)
	index = index + 1
end

function module:TradeTabs_FilterIcons()
	local buttonList = {
		[1] = {
			"Atlas:bags-greenarrow",
			TRADESKILL_FILTER_HAS_SKILL_UP,
			GetOnlyShowSkillUpRecipes,
			SetOnlyShowSkillUpRecipes,
		},
		[2] = {
			"Interface\\RAIDFRAME\\ReadyCheck-Ready",
			CRAFT_IS_MAKEABLE,
			GetOnlyShowMakeableRecipes,
			SetOnlyShowMakeableRecipes,
		},
	}

	local function filterClick(self)
		local value = self.__value
		if value[3]() then
			value[4](false)
			self.backdrop:SetBackdropBorderColor(0, 0, 0)
		else
			value[4](true)
			self.backdrop:SetBackdropBorderColor(1, 0.8, 0)
		end
	end

	local buttons = {}
	for index, value in pairs(buttonList) do
		local bu = CreateFrame("Button", nil, ProfessionsFrame.CraftingPage.RecipeList, "BackdropTemplate")
		bu:SetSize(22, 22)
		bu:SetPoint(
			"BOTTOMRIGHT",
			ProfessionsFrame.CraftingPage.RecipeList.FilterButton,
			"TOPRIGHT",
			-(index - 1) * 27,
			10
		)
		S:PixelIcon(bu, value[1], true)
		F.AddTooltip(bu, "ANCHOR_TOP", value[2])
		bu.__value = value
		bu:SetScript("OnClick", filterClick)

		buttons[index] = bu
	end

	local function updateFilterStatus()
		for index, value in pairs(buttonList) do
			if value[3]() then
				buttons[index].backdrop:SetBackdropBorderColor(1, 0.8, 0)
			else
				buttons[index].backdrop:SetBackdropBorderColor(0, 0, 0)
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

	MER:UnregisterEvent("PLAYER_REGEN_ENABLED", module.TradeTabs_OnLoad)
end

local function LoadTradeTabs()
	if init then
		return
	end

	if InCombatLockdown() then
		MER:RegisterEvent("PLAYER_REGEN_ENABLED", module.TradeTabs_OnLoad)
	else
		module:TradeTabs_OnLoad()
	end
end

function module:TradeTabs()
	if not E.db.mui.misc.tradeTabs then
		return
	end

	if ProfessionsFrame then
		ProfessionsFrame:HookScript("OnShow", LoadTradeTabs)
	else
		MER:RegisterEvent("ADDON_LOADED", function(_, addon)
			if addon == "Blizzard_Professions" then
				LoadTradeTabs()
			end
		end)
	end
end

module:AddCallback("TradeTabs")
