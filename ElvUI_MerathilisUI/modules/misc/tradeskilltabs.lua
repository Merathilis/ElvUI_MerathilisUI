local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI')

local itemDisplay = 30
local numTabs = 0
local f = CreateFrame("Frame", "TST")
f:RegisterEvent("TRADE_SKILL_LIST_UPDATE")
f:RegisterEvent("PLAYER_LOGIN")

local function isCurrentTab(self)
	if self.tooltip and IsCurrentSpell(self.tooltip) then self:SetChecked(true) else self:SetChecked(false) end
end

-- Add Tab Button
local function addTab(id, index, isSub)
	local name, _, icon = GetSpellInfo(id)
	if (not name) or (not icon) then return end

	local tab = _G["TSTab" .. index] or CreateFrame("CheckButton", "TSTab" .. index, TradeSkillFrame, "SpellBookSkillLineTabTemplate, SecureActionButtonTemplate")
	tab:StripTextures()
	tab:SetTemplate("Default")
	tab:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
	tab:GetNormalTexture():SetInside()
	tab:SetPoint("TOPLEFT", TradeSkillFrame, "TOPRIGHT", 1, -44 * index + (-50 * isSub))
	tab.pushed = true;
	tab:CreateBackdrop("Default")
	tab.backdrop:SetAllPoints()
	tab:StyleButton(true)
	MER:StyleOutside(tab)

	tab:SetScript("OnEvent", isCurrentTab)
	tab:RegisterEvent("CURRENT_SPELL_CAST_CHANGED")

	tab.id = id
	tab.tooltip = name
	tab:SetAttribute("type", "spell")
	tab:SetAttribute("spell", name)
	tab:SetNormalTexture(icon)
	tab:Show()

	tab.isSkinned = true

	isCurrentTab(tab)
end

-- Remove Tab Buttons
local function removeTabs()
	for i = 1, numTabs do
		local tab = _G["TSTab" .. i]
		if tab and tab:IsShown() then
			tab:UnregisterEvent("CURRENT_SPELL_CAST_CHANGED")
			tab:Hide()
		end
	end
end

-- Check Profession Useable
local function isUseable(id)
	local name = GetSpellInfo(id)
	return IsUsableSpell(name)
end

-- Update Profession Tabs
local function updateTabs()
	local mainTabs, subTabs = {}, {}

	local _, class = UnitClass("player")
	if class == "DEATHKNIGHT" and isUseable(53428) then mainTabs[1] = 53428 elseif class == "ROGUE" and isUseable(1804) then subTabs[1] = 1804 end

	local prof1, prof2, arch, fishing, cooking, firstaid = GetProfessions()
	local profs = {prof1, prof2, cooking, firstaid}
	for _, prof in pairs(profs) do
		local num, offset, _, _, _, spec = select(5, GetProfessionInfo(prof))
		if (spec and spec ~= 0) then num = 1 end
		for i = 1, num do
			if not IsPassiveSpell(offset + i, BOOKTYPE_PROFESSION) then
				local _, id = GetSpellBookItemInfo(offset + i, BOOKTYPE_PROFESSION)
				if (i == 1) then mainTabs[#mainTabs + 1] = id else subTabs[#subTabs + 1] = id end
			end
		end
	end

	local sameTabs = true
	for i = 1, #mainTabs do
		local tab = _G["TSTab" .. i]
		if tab and not (tab.id == mainTabs[i]) then
			sameTabs = false
			break
		end
	end

	if not sameTabs or not (numTabs == #mainTabs + #subTabs) then
		removeTabs()
		numTabs = #mainTabs + #subTabs
		for i = 1, numTabs do addTab(mainTabs[i] or subTabs[i - #mainTabs], i, mainTabs[i] and 0 or 1) end
	end
end

-- SearchBoxFix
hooksecurefunc("ChatEdit_InsertLink", function(link)
	if link and TradeSkillFrame and TradeSkillFrame:IsShown() then
		local text = strmatch(link, "|h%[(.+)%]|h|r")
		if text then
			text = strmatch(text, ":%s(.+)") or text
			TradeSkillFrame.SearchBox:SetText(text:lower())
		end
	end
end)

-- Fix Legion RecipeLink
local getRecipe = C_TradeSkillUI.GetRecipeLink
C_TradeSkillUI.GetRecipeLink = function(link)
	if link and (link ~= "") then return getRecipe(link) end
end

-- Initalizise
f:SetScript("OnEvent", function(self, event, ...)
	if E.db.mui.misc.tradeTabs ~= true then return end
	if (event == "TRADE_SKILL_LIST_UPDATE") then
		if TradeSkillFrame and TradeSkillFrame.RecipeList then
			if TradeSkillFrame.RecipeList.buttons and #TradeSkillFrame.RecipeList.buttons < (itemDisplay + 2) then HybridScrollFrame_CreateButtons(TradeSkillFrame.RecipeList, "TradeSkillRowButtonTemplate", 0, 0) end
			if not InCombatLockdown() then updateTabs() end
		end
	end
end)