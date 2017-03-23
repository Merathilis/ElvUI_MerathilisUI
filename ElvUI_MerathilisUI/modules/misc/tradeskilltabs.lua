local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule("MerathilisUI")

-- Cache global variables
-- Lua functions
local _G = _G
local pairs, ipairs, select, unpack = pairs, ipairs, select, unpack
local tinsert = table.insert
-- WoW API / Variables
local GetProfessions = GetProfessions
local GetProfessionInfo = GetProfessionInfo
local GetSpellBookItemInfo = GetSpellBookItemInfo
local GetSpellCooldown = GetSpellCooldown
local GetSpellInfo = GetSpellInfo
local InCombatLockdown = InCombatLockdown
local IsAddOnLoaded = IsAddOnLoaded
local IsCurrentSpell = IsCurrentSpell
local IsPassiveSpell = IsPassiveSpell
local UnitClass = UnitClass
-- Global variables that we don"t cache, list them here for the mikk"s Find Globals script
-- GLOBALS: GameTooltip, CreateFrame, BOOKTYPE_PROFESSION

local TradeTabs = CreateFrame("Frame", "TradeTabs")

local whitelist = {
	[171] = true, -- Alchemy
	[164] = true, -- Blacksmithing
	[185] = true, -- Cooking
	[333] = true, -- Enchanting
	[202] = true, -- Engineering
	[129] = true, -- First Aid
	[773] = true, -- Inscription
	[755] = true, -- Jewelcrafting
	[165] = true, -- Leatherworking
	[186] = true, -- Mining
	[197] = true, -- Tailoring
	[182] = true, -- Herbalism
	[393] = true, -- Skinning
}

local onlyPrimary = {
	[171] = true, -- Alchemy
	[202] = true, -- Engineering
	[182] = true, -- Herbalism
	[393] = true, -- Skinning
}

local RUNEFORGING = 53428 -- Runeforging spellid

function TradeTabs:OnEvent(event, addon)
	if not E.db.mui["misc"] then E.db.mui["misc"] = {} end -- prevent a stupid lua error
	if not E.db.mui["misc"]["tradeTabs"] then return end
	if event == "ADDON_LOADED" and addon ~= "Blizzard_TradeSkillUI" then return end
	self:UnregisterEvent(event)

	if InCombatLockdown() then
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
	else
		self:Initialize()
	end
end

local function buildSpellList()
	local p1, p2, arch, fishing, cooking, firstaid = GetProfessions()
	local profs = {p1, p2, cooking, firstaid}
	local tradeSpells = {}
	local extras = 0

	for _, prof in pairs(profs) do
		local name, icon, _, _, abilities, offset, skillLine = GetProfessionInfo(prof)
		if whitelist[skillLine] then
			if onlyPrimary[skillLine] then
				abilities = 1
			end

			for i = 1, abilities do
				if not IsPassiveSpell(i + offset, BOOKTYPE_PROFESSION) then
					if i > 1 then
						tinsert(tradeSpells, i + offset)
						extras = extras + 1
					else
						tinsert(tradeSpells, #tradeSpells + 1 - extras, i + offset)
					end
				end
			end
		end
	end

	return tradeSpells
end

function TradeTabs:Initialize()
	if self.initialized or not IsAddOnLoaded("Blizzard_TradeSkillUI") then return end

	local parent = _G["TradeSkillFrame"]
	local tradeSpells = buildSpellList()
	local i = 1
	local prev

	-- if player is a DK, insert runeforging at the top
	if select(2, UnitClass("player")) == "DEATHKNIGHT" then
		prev = self:CreateTab(i, parent, RUNEFORGING)
		prev:SetPoint("TOPLEFT", parent, "TOPRIGHT", 1, -44)
		i = i + 1
	end

	for i, slot in ipairs(tradeSpells) do
		local _, spellID = GetSpellBookItemInfo(slot, BOOKTYPE_PROFESSION)
		local tab = self:CreateTab(i, parent, spellID)
		i = i + 1

		local point,relPoint,x,y = "TOPLEFT", "BOTTOMLEFT", 0, -17
		if not prev then
			prev, relPoint, x, y = parent, "TOPRIGHT", 2, -44
		end
		tab:SetPoint(point, prev, relPoint, x, y)

		prev = tab
	end

	self.initialized = true
end

local function onEnter(self)
	GameTooltip:SetOwner(self,"ANCHOR_RIGHT") GameTooltip:SetText(self.tooltip) 
	self:GetParent():LockHighlight()
end

local function onLeave(self)
	GameTooltip:Hide()
	self:GetParent():UnlockHighlight()
end

local function updateSelection(self)
	if IsCurrentSpell(self.spell) then
		self:SetChecked(true)
		self.clickStopper:Show()
	else
		self:SetChecked(false)
		self.clickStopper:Hide()
	end

	-- CD monitoring
	if not self.CD then
		self.CD = CreateFrame("Cooldown", nil, self, "CooldownFrameTemplate")
		self.CD:SetAllPoints()
		self.CD:SetReverse(true)
	end
	local start, duration = GetSpellCooldown(self.spell)
	if duration > 1.5 then	-- not for GCD
		self.CD:SetCooldown(start, duration)
	end
end

local function createClickStopper(button)
	local f = CreateFrame("Frame", nil, button)
	f:SetAllPoints(button)
	f:EnableMouse(true)
	f:SetScript("OnEnter", onEnter)
	f:SetScript("OnLeave", onLeave)
	button.clickStopper = f
	f.tooltip = button.tooltip
	f:Hide()
end

function TradeTabs:CreateTab(i, parent, spellID)
	local spell, _, texture = GetSpellInfo(spellID)
	local button = CreateFrame("CheckButton", "TradeTabsTab"..i, parent, "SpellBookSkillLineTabTemplate, SecureActionButtonTemplate")
	button.tooltip = spell
	button.spellID = spellID
	button.spell = spell
	button:Show()
	button:SetAttribute("type", "spell")
	button:SetAttribute("spell", spell)

	button:SetNormalTexture(texture)
	button:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
	button:GetNormalTexture():SetInside()
	button:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
	button:GetRegions():Hide()
	MER:StyleOutside(button)
	button:SetScript("OnEvent", updateSelection)
	button:RegisterEvent("TRADE_SKILL_SHOW")
	button:RegisterEvent("TRADE_SKILL_CLOSE")
	button:RegisterEvent("CURRENT_SPELL_CAST_CHANGED")

	createClickStopper(button)
	updateSelection(button)
	return button
end

TradeTabs:RegisterEvent("ADDON_LOADED")
TradeTabs:SetScript("OnEvent", TradeTabs.OnEvent)
