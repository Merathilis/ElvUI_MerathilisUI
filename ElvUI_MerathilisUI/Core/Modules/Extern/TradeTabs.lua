local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local S = E:GetModule('Skins')
if not E.Retail then return end

---------------------------------
-- Credits: ProfessionTabs by Beoko
---------------------------------
local _G = _G
local next, unpack = next, unpack
local format = string.format

local CreateFrame = CreateFrame
local IsCurrentSpell = IsCurrentSpell

local tabs, spells = {}, {}

local handler = CreateFrame("Frame")
handler:SetScript("OnEvent", function(self, event) self[event](self, event) end)
handler:RegisterEvent("TRADE_SKILL_SHOW")
handler:RegisterEvent("TRADE_SKILL_CLOSE")
handler:RegisterEvent("TRADE_SHOW")
handler:RegisterEvent("SKILL_LINES_CHANGED")
handler:RegisterEvent("CURRENT_SPELL_CAST_CHANGED")

local defaults = {
	-- Primary Professions
	[171] = {true, false},	-- Alchemy
	[164] = {true, false},	-- Blacksmithing
	[333] = {true, true},	-- Enchanting
	[202] = {true, false},	-- Engineering
	[182] = {false, false},	-- Herbalism
	[773] = {true, true},	-- Inscription
	[755] = {true, true},	-- Jewelcrafting
	[165] = {true, false},	-- Leatherworking
	[186] = {true, false},	-- Mining
	[393] = {false, false},	-- Skinning
	[197] = {true, false},	-- Tailoring

	-- Secondary Professions
	[794] = {false, false},	-- Archaeology
	[185] = {true, true},	-- Cooking
	[129] = {true, false},	-- First Aid
	[356] = {false, false},	-- Fishing
}

if E.myclass == "DEATHKNIGHT" then spells[#spells + 1] = 53428 end	-- Runeforging
if E.myclass == "ROGUE" then spells[#spells + 1] = 1804 end			-- Pick Lock

local function UpdateSelectedTabs(object)
	if not handler:IsEventRegistered("CURRENT_SPELL_CAST_CHANGED") then
		handler:RegisterEvent("CURRENT_SPELL_CAST_CHANGED")
	end

	for index = 1, #tabs[object] do
		local tab = tabs[object][index]
		tab:SetChecked(IsCurrentSpell(tab.name))
	end
end

local function ResetTabs(object)
	for index = 1, #tabs[object] do
		tabs[object][index]:Hide()
	end

	tabs[object].index = 0
end

local function UpdateTab(object, name, rank, texture, hat)
	local index = tabs[object].index + 1
	local tab = tabs[object][index] or CreateFrame("CheckButton", "ProTabs"..tabs[object].index, object, "SpellBookSkillLineTabTemplate, SecureActionButtonTemplate")

	tab:ClearAllPoints()

	tab:SetPoint("TOPLEFT", object, "TOPRIGHT", 1, (-44 * index) + 44)

	tab:DisableDrawLayer("BACKGROUND")
	tab:SetNormalTexture(texture)
	tab:GetNormalTexture():ClearAllPoints()
	tab:GetNormalTexture():SetPoint("TOPLEFT", 2, -2)
	tab:GetNormalTexture():SetPoint("BOTTOMRIGHT", -2, 2)
	tab:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))

	tab:CreateBackdrop()
	tab.backdrop:SetAllPoints()
	tab:StyleButton(true)

	if hat then
		tab:SetAttribute("type", "toy")
		tab:SetAttribute("toy", 134020)
	else
		tab:SetAttribute("type", "spell")
		tab:SetAttribute("spell", name)
	end

	tab:Show()

	tab.name = name
	tab.tooltip = rank and rank ~= "" and format("%s (%s)", name, rank) or name

	tabs[object][index] = tabs[object][index] or tab
	tabs[object].index = tabs[object].index + 1
end

local function GetProfessionRank(currentSkill, skillLineName)
	if skillLineName then
		return skillLineName
	end

	if currentSkill <= 74 then
		return APPRENTICE
	end

	for index = #ranks, 1, -1 do
		local requiredSkill, title = ranks[index][1], ranks[index][2]

		if currentSkill >= requiredSkill then
			return title
		end
	end
end

local function HandleProfession(object, professionID, hat)
	if professionID then
		local _, _, currentSkill, _, numAbilities, offset, skillID, _, _, _, skillLineName = GetProfessionInfo(professionID)

		if defaults[skillID] then
			for index = 1, numAbilities do
				if defaults[skillID][index] then
					local name = GetSpellBookItemName(offset + index, "profession")
					local rank = GetProfessionRank(currentSkill, skillLineName)
					local texture = GetSpellBookItemTexture(offset + index, "profession")

					if name and rank and texture then
						UpdateTab(object, name, rank, texture)
					end
				end
			end
		end

		if hat and PlayerHasToy(134020) then
			UpdateTab(object, GetSpellInfo(67556), nil, 236571, true)
		end
	end
end

local function HandleTabs(object)
	if not object then return end
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

		for index = 1, #spells do
			if IsSpellKnown(spells[index]) then
				local name, rank, texture = GetSpellInfo(spells[index])
				UpdateTab(object, name, rank, texture)
			end
		end
	end

	UpdateSelectedTabs(object)
end

function handler:TRADE_SKILL_SHOW(event)
	local owner = _G.ATSWFrame or _G.MRTSkillFrame or _G.SkilletFrame or _G.TradeSkillFrame

	if (IsAddOnLoaded("TradeSkillDW") or IsAddOnLoaded("TradeSkillMaster")) and owner == _G.TradeSkillFrame then
		self:UnregisterEvent(event)
	else
		HandleTabs(owner)
		self[event] = function() for object in next, tabs do UpdateSelectedTabs(object) end end
	end
end

function handler:TRADE_SKILL_CLOSE(event)
	for object in next, tabs do
		if object:IsShown() then
			UpdateSelectedTabs(object)
		end
	end
end

function handler:TRADE_SHOW(event)
	local owner = _G.TradeFrame

	HandleTabs(owner)
	self[event] = function() UpdateSelectedTabs(owner) end
end

function handler:PLAYER_REGEN_ENABLED(event)
	self:UnregisterEvent(event)

	for object in next, tabs do HandleTabs(object) end
end

function handler:SKILL_LINES_CHANGED()
	for object in next, tabs do HandleTabs(object) end
end

function handler:CURRENT_SPELL_CAST_CHANGED(event)
	local numShown = 0

	for object in next, tabs do
		if object:IsShown() then
			numShown = numShown + 1
			UpdateSelectedTabs(object)
		end
	end

	if numShown == 0 then self:UnregisterEvent(event) end
end
