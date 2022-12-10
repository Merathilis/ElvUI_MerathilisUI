--[[
LICENSE
	cargBags: An inventory framework addon for World of Warcraft

	Copyright (C) 2010  Constantin "Cargor" Schomburg <xconstruct@gmail.com>

	cargBags is free software; you can redistribute it and/or
	modify it under the terms of the GNU General Public License
	as published by the Free Software Foundation; either version 2
	of the License, or (at your option) any later version.

	cargBags is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with cargBags; if not, write to the Free Software
	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

DESCRIPTION
	An infotext-module which can display several things based on tags.

	Supported tags:
		space - specify a formatstring as arg #1, using "free" / "max" / "used"
		item - count of the item in arg #1 (itemID, itemLink, itemName)
			shards - "sub-tag" of item, displays soul shard info
		ammo - count of ammo slot
		currency - displays the currency with id arg #1
			currencies - displays all tracked currencies
		money - formatted money display

	The space-tag still needs .bags defined in the plugin!
	e.g. tagDisplay.bags = cargBags:ParseBags("backpack+bags")

DEPENDENCIES
	mixins/api-common.lua

CALLBACKS
	:OnTagUpdate(event) - When the tag is updated
]]
local _, ns = ...
local MER, F, E, L, V, P, G = unpack(ns)
local cargBags = ns.cargBags

local GetContainerNumFreeSlots = C_Container.GetContainerNumFreeSlots

local tagPool, tagEvents, object = {}, {}
local function tagger(tag, ...) return object.tags[tag] and object.tags[tag](object, ...) or "" end

--MER
local function GetTextureStrByAtlas(info, sizeX, sizeY)
	local file = info and info.file
	if not file then return end

	local width, height, txLeft, txRight, txTop, txBottom = info.width, info.height, info.leftTexCoord, info.rightTexCoord,
		info.topTexCoord, info.bottomTexCoord
	local atlasWidth = width / (txRight - txLeft)
	local atlasHeight = height / (txBottom - txTop)

	return format("|T%s:%d:%d:0:0:%d:%d:%d:%d:%d:%d|t", file, (sizeX or 0), (sizeY or 0), atlasWidth, atlasHeight,
		atlasWidth * txLeft, atlasWidth * txRight, atlasHeight * txTop, atlasHeight * txBottom)
end

-- Update the space display
local function updater(self, event)
	object = self
	self:SetText(self.tagString:gsub("%[([^%]:]+):?(.-)%]", tagger))

	if(self.OnTagUpdate) then self:OnTagUpdate(event) end
end

local function setTagString(self, tagString)
	self.tagString = tagString
	for tag in tagString:gmatch("%[([^%]:]+):?.-]") do
		if(self.tagEvents[tag]) then
			for _, event in pairs(self.tagEvents[tag]) do
				self.implementation:RegisterEvent(event, self, updater)
			end
		end
	end
end

cargBags:RegisterPlugin("TagDisplay", function(self, tagString, parent)
	parent = parent or self
	tagString = tagString or ""

	local plugin = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	plugin.implementation = self.implementation
	plugin.SetTagString = setTagString
	plugin.tags = tagPool
	plugin.tagEvents = tagEvents
	plugin.iconValues = "16:16:0:0"
	plugin.forceEvent = function(event) updater(plugin, event) end

	setTagString(plugin, tagString)

	self.implementation:RegisterEvent("BAG_UPDATE", plugin, updater)
	return plugin
end)

local function createIcon(icon, iconValues)
	if(type(iconValues) == "table") then
		iconValues = table.concat(iconValues, ":")
	end
	return ("|T%s:%s|t"):format(icon, iconValues)
end

-- Tags
local function GetNumFreeSlots(name)
	if name == "Bag" then
		local totalFree, freeSlots, bagFamily = 0
		for i = 0, 4 do -- reagent bank excluded
			freeSlots, bagFamily = GetContainerNumFreeSlots(i)
			if bagFamily == 0 then
				totalFree = totalFree + freeSlots
			end
		end
		return totalFree
	elseif name == "Bank" then
		local numFreeSlots = GetContainerNumFreeSlots(-1)
		for bagID = 6, 12 do
			numFreeSlots = numFreeSlots + GetContainerNumFreeSlots(bagID)
		end
		return numFreeSlots
	elseif name == "Reagent" then
		return GetContainerNumFreeSlots(-3)
	elseif name == "BagReagent" then
		return GetContainerNumFreeSlots(5)
	end
end

tagPool["space"] = function(self)
	local str = GetNumFreeSlots(self.__name)
	return str
end

tagPool["item"] = function(self, item)
	local bags = GetItemCount(item, nil)
	local total = GetItemCount(item, true)
	local bank = total-bags

	if(total > 0) then
		return bags .. (bank and " ("..bank..")") .. createIcon(GetItemIcon(item), self.iconValues)
	end
end

tagPool["currency"] = function(self, id)
	local _, count, icon = C_CurrencyInfo.GetBackpackCurrencyInfo(id)

	if(count) then
		return count .. createIcon(icon, self.iconValues)
	end
end
tagEvents["currency"] = { "CURRENCY_DISPLAY_UPDATE" }

tagPool["currencies"] = function(self)
	local str
	for i=1, GetNumWatchedTokens() do
		local curr = self.tags["currency"](self, i)
		if(curr) then
			str = (str and str.." " or "")..curr
		end
	end
	return str
end
tagEvents["currencies"] = tagEvents["currency"]

local atlasCache = {}
local function createAtlasCoin(coin)
	local str = atlasCache[coin]
	if not str then
		local info = C_Texture.GetAtlasInfo("coin-"..coin)
		if info then
			str = GetTextureStrByAtlas(info, 16, 16)
			atlasCache[coin] = str
		end
	end
	return str
end

tagPool["money"] = function()
	local money = GetMoney() or 0
	local str = ""
	local gold, silver, copper = floor(money/1e4), floor(money/100) % 100, money % 100

	if gold > 0 then str = str..BreakUpLargeNumbers(gold)..createAtlasCoin("gold").." " end
	if silver > 0 then str = str..silver..createAtlasCoin("silver").." " end
	if copper > 0 then str = str..copper..createAtlasCoin("copper").." " end

	return str
end
tagEvents["money"] = { "PLAYER_MONEY" }
