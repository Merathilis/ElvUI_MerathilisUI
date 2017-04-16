local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule("MerathilisUI");
local MERC = E:GetModule('muiChat')

--Cache global variables
--Lua functions
local _G = _G
local tonumber = tonumber
local find, gsub, match, gmatch, upper = string.find, string.gsub, string.match, string.gmatch, string.upper
local tconcat, tinsert = table.concat, table.insert

--WoW API / Variables
local CreateFrame = CreateFrame
local GetItemInfo = GetItemInfo
local IsAddOnLoaded = IsAddOnLoaded

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: ChatFrame_AddMessageEventFilter, filter, tooltip, escapeSearchString, ItemHasSockets
-- GLOBALS: LE_ITEM_CLASS_WEAPON, LE_ITEM_CLASS_GEM, LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_RELIC, _
-- GLOBALS: GameFontNormal

local MER_RELIC_TOOLTIP_TYPE_PATTERN = _G["RELIC_TOOLTIP_TYPE"]:gsub('%%s', '(.+)')
local MER_ITEM_LEVEL_PATTERN = _G["ITEM_LEVEL"]:gsub('%%d', '(%%d+)')

function filter(self, event, message, user, ...)
	for itemLink in message:gmatch("|%x+|Hitem:.-|h.-|h|r") do
		local itemName, _, quality, _, _, itemType, itemSubType, _, itemEquipLoc, _, _, itemClassId, itemSubClassId = GetItemInfo(itemLink)
		if (quality ~= nil and (itemClassId == LE_ITEM_CLASS_WEAPON or itemClassId == LE_ITEM_CLASS_GEM or itemClassId == LE_ITEM_CLASS_ARMOR)) then
			local itemString = match(itemLink, "item[%-?%d:]+")
			local _, _, color = find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
			local iLevel = MER:GetRealILVL(itemLink)

			local attrs = {}
			if (itemSubType ~= nil) then
				if (itemClassId == LE_ITEM_CLASS_ARMOR and itemSubClassId == 0) then
				-- don't display Miscellaneous for rings, necks and trinkets
				elseif (itemClassId == LE_ITEM_CLASS_ARMOR and itemEquipLoc == "INVTYPE_CLOAK") then
				-- don't display Cloth for cloaks
				else
					tinsert(attrs, itemSubType:sub(0, 1)) 
				end
				if (itemClassId == LE_ITEM_CLASS_GEM and itemSubClassId == LE_ITEM_ARMOR_RELIC) then 
					local relicType = MER:GetRelicType(itemLink)
					tinsert(attrs, relicType)
				end
			end
			if (itemEquipLoc ~= nil and _G[itemEquipLoc] ~= nil) then tinsert(attrs, _G[itemEquipLoc]) end
			if (iLevel ~= nil) then 
				local txt = iLevel
				if (ItemHasSockets(itemLink)) then txt = txt .. "+S" end
				tinsert(attrs, txt)
			end

			local newItemName = itemName.." ("..tconcat(attrs, " ")..")"
			local newLink = "|cff"..color.."|H"..itemString.."|h["..newItemName.."]|h|r"

			message = gsub(message, escapeSearchString(itemLink), newLink)
		end
	end
	return false, message, user, ...
end

-- Inhibit Regular Expression magic characters ^$()%.[]*+-?)
function escapeSearchString(str)
	return str:gsub("(%W)","%%%1")
end

-- function borrowed from PersonalLootHelper
local function CreateEmptyTooltip()
    local tip = CreateFrame('GameTooltip')
	local leftside = {}
	local rightside = {}
	local L, R
	for i = 1, 6 do
		L, R = tip:CreateFontString(), tip:CreateFontString()
		L:SetFontObject(GameFontNormal)
		R:SetFontObject(GameFontNormal)
		tip:AddFontStrings(L, R)
		leftside[i] = L
		rightside[i] = R
	end
	tip.leftside = leftside
	tip.rightside = rightside
	return tip
end

-- function borrowed from PersonalLootHelper
function MER:GetRelicType(item)
	local relicType = nil

	if item ~= nil then
		tooltip = tooltip or CreateEmptyTooltip()
		tooltip:SetOwner(E.UIParent, 'ANCHOR_NONE')
		tooltip:ClearLines()
		tooltip:SetHyperlink(item)
		local t = tooltip.leftside[2]:GetText()

		local index = 1
		local t
		while not relicType and tooltip.leftside[index] do
			t = tooltip.leftside[index]:GetText()
			if t ~= nil then
				relicType = t:match(MER_RELIC_TOOLTIP_TYPE_PATTERN)
			end
			index = index + 1
		end

		tooltip:Hide()
	end

	return relicType
end

-- function borrowed from PersonalLootHelper
function MER:GetRealILVL(item)
	local realILVL = nil

	if item ~= nil then
		tooltip = tooltip or CreateEmptyTooltip()
		tooltip:SetOwner(E.UIParent, 'ANCHOR_NONE')
		tooltip:ClearLines()
		tooltip:SetHyperlink(item)
		local t = tooltip.leftside[2]:GetText()
		if t ~= nil then
--			realILVL = t:match('Item Level (%d+)')
			realILVL = t:match(MER_ITEM_LEVEL_PATTERN)
		end
		-- ilvl can be in the 2nd or 3rd line dependng on the tooltip; if we didn't find it in 2nd, try 3rd
		if realILVL == nil then
			t = tooltip.leftside[3]:GetText()
			if t ~= nil then
--				realILVL = t:match('Item Level (%d+)')
				realILVL = t:match(MER_ITEM_LEVEL_PATTERN)
			end
		end
		tooltip:Hide()

		-- if realILVL is still nil, we couldn't find it in the tooltip - try grabbing it from getItemInfo, even though
		--   that doesn't return upgrade levels
		if realILVL == nil then
			_, _, _, realILVL, _, _, _, _, _, _, _ = GetItemInfo(item)
		end
	end

	if realILVL == nil then
		return 0
	else
		return tonumber(realILVL)
	end
end

function ItemHasSockets(itemLink)
	local result = false
	local tooltip = CreateFrame("GameTooltip", "ItemLinkLevelSocketTooltip", nil, "GameTooltipTemplate")
	tooltip:SetOwner(E.UIParent, 'ANCHOR_NONE')
	tooltip:ClearLines()
	for i = 1, 30 do
		local texture = _G[tooltip:GetName().."Texture"..i]
		if texture then
			texture:SetTexture(nil)
		end
	end
	tooltip:SetHyperlink(itemLink)
	for i = 1, 30 do
		local texture = _G[tooltip:GetName().."Texture"..i]
		local textureName = texture and texture:GetTexture()

		if textureName then
			local canonicalTextureName = gsub(upper(textureName), "\\", "/")
			result = find(canonicalTextureName, escapeSearchString("ITEMSOCKETINGFRAME/UI-EMPTYSOCKET-"))
		end
	end
	return result
end

local function eventHandler(self, event, ...)

	ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", filter);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND", filter);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND_LEADER", filter);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", filter);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", filter);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", filter);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", filter);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", filter);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", filter);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", filter);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", filter);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", filter);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", filter);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING", filter);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", filter);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filter);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", filter)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", filter);
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", filter); -- BNet Whisper don't seems to work
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER_INFORM", filter); -- BNet Whisper don't seems to work
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(_, event)
	if IsAddOnLoaded("ItemLinkLevel") or E.db.mui.general.ItemLevelLink ~= true then return end
	if event == "PLAYER_LOGIN" then
		eventHandler()
		f:UnregisterEvent("PLAYER_LOGIN")
	end
end)



