local MER, E, L, V, P, G = unpack(select(2, ...))
local MERTT = MER:GetModule("mUITooltip")

-- Cache global variables
-- Lua functions
local _G = _G
local ipairs, select = ipairs, select
local strmatch, format = strmatch, string.format
local tinsert, twipe = table.insert, table.wipe

-- WoW API / Variables
local GetSpellInfo = GetSpellInfo
local C_AzeriteEmpoweredItem_GetPowerInfo = C_AzeriteEmpoweredItem.GetPowerInfo
local C_AzeriteEmpoweredItem_IsAzeriteEmpoweredItemByID = C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID
local C_AzeriteEmpoweredItem_GetAllTierInfoByItemID = C_AzeriteEmpoweredItem.GetAllTierInfoByItemID
local IsAddOnLoaded = IsAddOnLoaded
-- GLOBALS:

-- Credit: AzeriteTooltip, by jokair9. Ported from NDui by siweia
local tipList, powerList, powerCache, tierCache = {}, {}, {}, {}

local iconString = "|T%s:18:22:0:0:64:64:5:59:5:59"
local function getIconString(icon, known)
	if known then
		return format(iconString..":255:255:255|t", icon)
	else
		return format(iconString..":120:120:120|t", icon)
	end
end

function MERTT:Azerite_ScanTooltip()
	twipe(tipList)
	twipe(powerList)

	for i = 9, self:NumLines() do
		local line = _G[self:GetName().."TextLeft"..i]
		local text = line:GetText()
		local powerName = text and strmatch(text, "%- (.+)")
		if powerName then
			tinsert(tipList, i)
			powerList[i] = powerName
		end
	end
end

function MERTT:Azerite_PowerToSpell(id)
	local spellID = powerCache[id]
	if not spellID then
		local powerInfo = C_AzeriteEmpoweredItem_GetPowerInfo(id)
		if powerInfo and powerInfo.spellID then
			spellID = powerInfo.spellID
			powerCache[id] = spellID
		end
	end
	return spellID
end

function MERTT:Azerite_UpdateItem()
	local link = select(2, self:GetItem())
	if not link then return end
	if not C_AzeriteEmpoweredItem_IsAzeriteEmpoweredItemByID(link) then return end

	local allTierInfo = tierCache[link]
	if not allTierInfo then
		allTierInfo = C_AzeriteEmpoweredItem_GetAllTierInfoByItemID(link)
		tierCache[link] = allTierInfo
	end
	if not allTierInfo then return end

	MERTT.Azerite_ScanTooltip(self)
	if #tipList == 0 then return end

	local index = 1
	for i = 1, #allTierInfo do
		local powerIDs = allTierInfo[i].azeritePowerIDs
		if powerIDs[1] == 13 then break end

		local lineIndex = tipList[index]
		if not lineIndex then break end

		local tooltipText = ""
		for _, id in ipairs(powerIDs) do
			local spellID = MERTT:Azerite_PowerToSpell(id)
			if not spellID then break end

			local name, _, icon = GetSpellInfo(spellID)
			local found = name == powerList[lineIndex]
			if found then
				tooltipText = tooltipText.." "..getIconString(icon, true)
			else
				tooltipText = tooltipText.." "..getIconString(icon)
			end
		end

		if tooltipText ~= "" then
			local line = _G[self:GetName().."TextLeft"..lineIndex]
			if E.db.mui.tooltip.azerite.onlyIcons then
				line:SetText(tooltipText)
				_G[self:GetName().."TextLeft"..lineIndex+1]:SetText("")
			else
				line:SetText(line:GetText().."\n "..tooltipText)
			end
		end

		index = index + 1
	end
end

function MERTT:AzeriteArmor()
	if not E.db.mui.tooltip.azerite.enable or IsAddOnLoaded("AzeriteTooltip") then return end

	_G.GameTooltip:HookScript("OnTooltipSetItem", MERTT.Azerite_UpdateItem)
	_G.ItemRefTooltip:HookScript("OnTooltipSetItem", MERTT.Azerite_UpdateItem)
	_G.ShoppingTooltip1:HookScript("OnTooltipSetItem", MERTT.Azerite_UpdateItem)
	_G.EmbeddedItemTooltip:HookScript("OnTooltipSetItem", MERTT.Azerite_UpdateItem)
	_G.GameTooltipTooltip:HookScript("OnTooltipSetItem", MERTT.Azerite_UpdateItem)
end
