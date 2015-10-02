local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local MER = E:GetModule('MerathilisUI');

-- Code taken from "Simple Loot Announcer" by Mazzop
if IsAddOnLoaded("simplelootannouncer") then return end

local t = 1
local loottemp = {}
local sockets = {3, 497, 523, 563, 564, 565, 572}
local warforged = {44, 448, 499, 546, 547, 560, 561, 562, 571}

local function Announce()
local masterlooterRaidID = select(3, GetLootMethod())
if (masterlooterRaidID ~= nil and UnitName("raid"..masterlooterRaidID) == UnitName("player")) or IsLeftControlKeyDown() then
local n = 0
local check = false
local loot = GetLootInfo()

for i = 1, GetNumLootItems() do
	if GetLootSlotType(i) == 1 then
		for j = 1, t do
			if GetLootSourceInfo(i) == loottemp[j] then 
				check = true
			break
			end
		end
	end
end

if check == false or IsLeftControlKeyDown() then

t = GetNumLootItems()
for i = 1, t do
	loot[i]["check"] = 0
	if GetLootSlotType(i) == 1 and loot[i]["quality"] >= 4 and not (bit.band(GetItemFamily(loot[i]["item"] or '') or 0, 0x0040) > 0) then
		local link = GetLootSlotLink(i)
		local ilvl = select(4, GetItemInfo(link))
		loot[i]["upgrade"] = ""
		local itemstring = string.match(link, "item[%-?%d:]+")
		local numbonuses = select(14, strsplit(":", itemstring))
		numbonuses = tonumber(numbonuses)
		local bonus = {}
		for j = 1, numbonuses do
			bonus[j] = select(14 + j, strsplit(":", itemstring))
			bonus[j] = tonumber(bonus[j])
			for k = 1, #warforged do											--Warforged
				if bonus[j] == warforged[k] then
					loot[i]["upgrade"] = loot[i]["upgrade"]..":"..ilvl
				end
			end
			for k = 1, #sockets do															--Socket
				if bonus[j] == sockets[k] then
					loot[i]["upgrade"] = loot[i]["upgrade"].." o"
				end
			end
			if bonus[j] == 40 then loot[i]["upgrade"] = loot[i]["upgrade"].." +"..STAT_AVOIDANCE end						--Avoidance
			if bonus[j] == 41 then loot[i]["upgrade"] = loot[i]["upgrade"].." +"..STAT_LIFESTEAL end						--Leech
			if bonus[j] == 42 then loot[i]["upgrade"] = loot[i]["upgrade"].." +"..STAT_SPEED end							--Speed
			if bonus[j] == 43 then loot[i]["upgrade"] = loot[i]["upgrade"].." +"..STAT_STURDINESS end						--Indestructible
		end
		loot[i]["check"] = 1
		for k = 1, i-1 do
			if loot[k]["item"] == loot[i]["item"] and loot[k]["upgrade"] == loot[i]["upgrade"] then
				loot[i]["check"] = 0
				loot[k]["quantity"] = loot[i]["quantity"] + loot[k]["quantity"]
			end
		end
	end
end

for i = 1, t do
	loot[i]["item"] = GetLootSlotLink(i)
	if loot[i]["check"] == 1 then
		n = n + 1
		if loot[i]["quantity"] == 1 then
			SendChatMessage(n..". "..loot[i]["item"]..loot[i]["upgrade"], "RAID")
		else
			SendChatMessage(n..". "..loot[i]["item"].."x"..loot[i]["quantity"].."  "..loot[i]["upgrade"], "RAID")
		end
	end
end

end

for i = 1, t do
	loottemp[i] = GetLootSourceInfo(i)
end

end
end

local LootAnnouncer = CreateFrame("Frame")
LootAnnouncer:RegisterEvent("LOOT_OPENED")
LootAnnouncer:SetScript("OnEvent", function(self, event)
	if E.db.muiMisc.LootAnnouncer then
		Announce()
	end
end)