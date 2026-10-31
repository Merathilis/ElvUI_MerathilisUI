local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_BagCategories") ---@class BagCategories

-------------------------------------------------------------------------------
--  Offline Bank: saves what every character carries account-wide, so the
--  viewer (OfflineView.lua) can show it anywhere and item tooltips can list who
--  owns how many. Works without the categorized bags, only the viewer needs them.
--
--  Store: MER_BagsInventoryDB, its own saved variable, so profile exports never
--  carry inventories.
--    chars[key] = { name, realm, class, faction, guid, guild,
--                   bags, bank, equip, mail = { container... },
--                   bagsTime, bankTime, equipTime, mailTime }
--    warband    = { time, tabs = { container... } }
--    guilds[key] = { name, realm, time, tabs = { container... } }
--    container  = { size, name?, icon?, items = { [slot] = item string },
--                   counts = { [slot] = count } } (counts only above 1)
--  bags[i] is bag i - 1 (false while that bag slot is empty), bank[i] and
--  tabs[i] are the i-th tab. Pets and keystones keep their whole link, their
--  item string alone cannot name them.
--
--  Read only: bags save after BAG_UPDATE_DELAYED when something changed, the
--  banks and the mail while they are open. Nothing is saved, hooked or listened
--  to while both switches are off.
-------------------------------------------------------------------------------

local _G = _G
local ipairs, next, pairs, select, tonumber, type = ipairs, next, pairs, select, tonumber, type
local format, gsub, sort, tconcat, tinsert, wipe = format, gsub, sort, table.concat, tinsert, wipe

local C_Timer = C_Timer
local CreateFrame = CreateFrame
local GetAutoCompleteRealms = GetAutoCompleteRealms
local GetGuildBankItemInfo = GetGuildBankItemInfo
local GetGuildBankItemLink = GetGuildBankItemLink
local GetGuildBankTabInfo = GetGuildBankTabInfo
local GetCurrentGuildBankTab = GetCurrentGuildBankTab
local GetGuildInfo = GetGuildInfo
local GetInboxItem = GetInboxItem
local GetInboxItemLink = GetInboxItemLink
local GetInboxNumItems = GetInboxNumItems
local GetInventoryItemLink = GetInventoryItemLink
local GetNumGuildBankTabs = GetNumGuildBankTabs
local QueryGuildBankTab = QueryGuildBankTab
local UnitClass = UnitClass
local UnitGUID = UnitGUID
local time = time

local C_Container_GetContainerItemInfo = C_Container.GetContainerItemInfo
local C_Container_GetContainerItemLink = C_Container.GetContainerItemLink
local C_Container_GetContainerNumSlots = C_Container.GetContainerNumSlots

local PIT = Enum.PlayerInteractionType
local BANK_TYPE_CHARACTER = Enum.BankType and Enum.BankType.Character
local BANK_TYPE_ACCOUNT = Enum.BankType and Enum.BankType.Account

local GUILD_TAB_SLOTS = 98 -- local to Blizzard_GuildBankUI, MAX_GUILDBANK_SLOTS_PER_TAB
local GUILD_QUERY_STEP = 0.3 -- the tabs answer one by one, a burst of queries goes unanswered
local EQUIP_SLOTS = 19

local Offline = {}
module.Offline = Offline

local empty = {}

local function Settings()
	return E.global.mui.bags.offline
end

function Offline.Enabled()
	return not E.Forever and Settings().enable
end

function Offline.CountsEnabled()
	return not E.Forever and Settings().tooltip
end

local function Active()
	return Offline.Enabled() or Offline.CountsEnabled()
end

-------------------------------------------------------------------------------
--  Item strings
-------------------------------------------------------------------------------
-- "item:..." for items, the whole link for anything else
local function ItemString(link)
	return link:match("|H(item:[^|]+)|h") or link
end

-- Item ID from a string or link, pet cages count as the cage item
local function ItemID(s)
	local kind, id = s:match("^(%a+):(%d+)")
	if not kind then
		kind, id = s:match("|H(%a+):(%d+)")
	end
	if kind == "battlepet" then
		return 82800
	end
	return tonumber(id)
end
Offline.ItemID = ItemID

-------------------------------------------------------------------------------
--  Store
-------------------------------------------------------------------------------
local rev = 0 -- goes up on every write, the tooltip index and its lines follow it
local listeners = {}
local index, indexRev -- tooltip index, below
local Patch -- below, with the tooltip index

function Offline.Store()
	local db = _G.MER_BagsInventoryDB
	if type(db) ~= "table" then
		db = { v = 1 }
		_G.MER_BagsInventoryDB = db
	end
	db.chars = db.chars or {}
	db.guilds = db.guilds or {}
	db.warband = db.warband or {}
	db.warband.tabs = db.warband.tabs or {}
	return db
end

local function OwnKey()
	return format("%s-%s", E.myname, E.myrealm)
end
Offline.CurrentKey = OwnKey

function Offline.Char(key)
	return key and Offline.Store().chars[key]
end

function Offline.Warband()
	return Offline.Store().warband
end

function Offline.Guild(key)
	return key and Offline.Store().guilds[key]
end

-- Something changed, so the viewer and the tooltip catch up. patched: the index
-- was already fixed up in place for this write.
local function Changed(what, patched)
	local current = patched and index and indexRev == rev
	rev = rev + 1
	if current then
		indexRev = rev
	end
	for _, callback in ipairs(listeners) do
		callback(what)
	end
end

function Offline.OnChange(callback)
	tinsert(listeners, callback)
end

function Offline.CanForget(key)
	return key ~= nil and key ~= OwnKey()
end

function Offline.Forget(key)
	if Offline.CanForget(key) then
		Offline.Store().chars[key] = nil
		Changed("forget")
	end
end

local function SortCharacters(a, b)
	if a.realm ~= b.realm then
		return a.realm < b.realm
	end
	return a.name < b.name
end

-- Characters for the picker by realm, then name, the current one flagged
function Offline.Characters()
	local list, own = {}, OwnKey()
	for key, c in pairs(Offline.Store().chars) do
		tinsert(list, { key = key, name = c.name or key, realm = c.realm or "", class = c.class, current = key == own })
	end
	sort(list, SortCharacters)
	return list
end

local function GuildKey()
	local name = GetGuildInfo("player")
	return name and format("%s-%s", name, E.myrealm)
end

local function MyEntry()
	local chars, key = Offline.Store().chars, OwnKey()
	local c = chars[key]
	if not c then
		c = {}
		chars[key] = c
	end
	c.name, c.realm, c.class, c.faction = E.myname, E.myrealm, select(2, UnitClass("player")), E.myfaction
	c.guild = GuildKey()

	-- A rename keeps the GUID: the old entry goes and the bank moves over, the
	-- rest saves again at once. A new character under a reused name has another
	-- GUID and starts empty.
	local guid = UnitGUID("player")
	if guid and c.guid ~= guid then
		local moved = c.guid ~= nil
		if moved then
			c.bags, c.bank, c.equip, c.mail = nil, nil, nil, nil
			c.bagsTime, c.bankTime, c.equipTime, c.mailTime = nil, nil, nil, nil
		end
		c.guid = guid
		for otherKey, other in pairs(chars) do
			if otherKey ~= key and other.guid == guid then
				if c.bank == nil then
					c.bank, c.bankTime = other.bank, other.bankTime
				end
				chars[otherKey] = nil
				moved = true
			end
		end
		if moved then
			Changed("forget")
		end
	end
	return c
end

-- One container's items, nil when the game says it has no slots
local function ReadContainer(bagID)
	local size = C_Container_GetContainerNumSlots(bagID) or 0
	if size <= 0 then
		return nil
	end
	local items, counts = {}, {}
	for slot = 1, size do
		local info = C_Container_GetContainerItemInfo(bagID, slot)
		local link = info and (info.hyperlink or C_Container_GetContainerItemLink(bagID, slot))
		if link then
			items[slot] = ItemString(link)
			if (info.stackCount or 1) > 1 then
				counts[slot] = info.stackCount
			end
		end
	end
	return { size = size, items = items, counts = counts }
end

local function SameMap(a, b)
	for k, v in pairs(a) do
		if b[k] ~= v then
			return false
		end
	end
	for k in pairs(b) do
		if a[k] == nil then
			return false
		end
	end
	return true
end

-- True when two saved containers hold the same items
local function Same(x, y)
	if type(x) ~= type(y) then
		return false
	end
	if type(x) ~= "table" then
		return x == y
	end
	return x.size == y.size
		and x.name == y.name
		and x.icon == y.icon
		and SameMap(x.items, y.items)
		and SameMap(x.counts, y.counts)
end

-------------------------------------------------------------------------------
--  Snapshots: only the containers that changed get read again
-------------------------------------------------------------------------------
local BAGS, BAG_POS = {}, {} -- the backpack, the four bags and the reagent bag
local CHAR_BANK, CHAR_POS, WARBAND_BANK, WARBAND_POS = {}, {}, {}, {}
local dirty = {} -- bag IDs to read on the next save

local function BuildBagLists()
	if #BAGS > 0 then
		return
	end
	for _, id in ipairs(module.BAG_IDS) do
		tinsert(BAGS, id)
	end
	tinsert(BAGS, module.ReagentContainer)
	for i, id in ipairs(BAGS) do
		BAG_POS[id] = i
	end
	for i, id in ipairs(module.BankBagIDs) do
		CHAR_BANK[i], CHAR_POS[id] = id, i
	end
	for i, id in ipairs(module.WarbandBagIDs) do
		WARBAND_BANK[i], WARBAND_POS[id] = id, i
	end
end

local function MarkAll(ids)
	for _, id in ipairs(ids) do
		dirty[id] = true
	end
end

-- Reads the dirty ones of ids into list, true when anything changed
local function SaveList(list, ids, positions, field, owner, meta)
	local changed = false
	for _, id in ipairs(ids) do
		if dirty[id] then
			dirty[id] = nil
			local i = positions[id]
			local new = ReadContainer(id)
			if new and meta then
				local data = meta[i]
				new.name, new.icon = data and data.name, data and data.icon
			end
			-- Bag slots can be empty (false), unbought bank tabs just stay unsaved
			if not new and not meta then
				new = false
			end
			if new ~= nil and not Same(list[i], new) then
				Patch(list[i], new, field, owner)
				list[i] = new
				changed = true
			end
		end
	end
	return changed
end

local function SaveBags()
	local c = MyEntry()
	c.bagsTime = time()
	c.bags = c.bags or {}
	-- Most bag updates move nothing we keep (cooldowns, locks)
	if SaveList(c.bags, BAGS, BAG_POS, "bags", OwnKey()) then
		Changed("bags", true)
	end
end

local function SaveSingle(field, timeField, new)
	local c = MyEntry()
	c[timeField] = time()
	c[field] = c[field] or {}
	if not Same(c[field][1], new) then
		Patch(c[field][1], new, field, OwnKey())
		c[field][1] = new
		Changed(field, true)
	end
end

local function SaveEquipped()
	local items = {}
	for slot = 1, EQUIP_SLOTS do
		local link = GetInventoryItemLink("player", slot)
		if link then
			items[slot] = ItemString(link)
		end
	end
	SaveSingle("equip", "equipTime", { size = EQUIP_SLOTS, items = items, counts = {} })
end

local function SaveMail()
	local items, counts, n = {}, {}, 0
	for mail = 1, GetInboxNumItems() do
		for attachment = 1, _G.ATTACHMENTS_MAX_RECEIVE or 16 do
			local link = GetInboxItemLink(mail, attachment)
			if link then
				local count = select(4, GetInboxItem(mail, attachment))
				n = n + 1
				items[n] = ItemString(link)
				if (count or 1) > 1 then
					counts[n] = count
				end
			end
		end
	end
	SaveSingle("mail", "mailTime", { size = n, items = items, counts = counts })
end

local function Meta(bankType)
	return C_Bank and C_Bank.FetchPurchasedBankTabData and C_Bank.FetchPurchasedBankTabData(bankType)
end

local atBank, atCharBank, atMail, atGuildBank = false, false, false, false

local function SaveBanks()
	if not atBank then
		return
	end
	local changed = false
	if atCharBank then
		local c = MyEntry()
		c.bankTime = time()
		c.bank = c.bank or {}
		changed = SaveList(c.bank, CHAR_BANK, CHAR_POS, "bank", OwnKey(), Meta(BANK_TYPE_CHARACTER) or {})
	end
	if C_Bank.FetchBankLockedReason(BANK_TYPE_ACCOUNT) == nil then
		local warband = Offline.Warband()
		warband.time = time()
		warband.money = C_Bank.FetchDepositedMoney(BANK_TYPE_ACCOUNT)
		if SaveList(warband.tabs, WARBAND_BANK, WARBAND_POS, "warband", nil, Meta(BANK_TYPE_ACCOUNT) or {}) then
			changed = true
		end
	end
	if changed then
		Changed("bank", true)
	end
end

local function ReadGuildTab(tab)
	local items, counts = {}, {}
	for slot = 1, GUILD_TAB_SLOTS do
		local link = GetGuildBankItemLink(tab, slot)
		if link then
			items[slot] = ItemString(link)
			local count = select(2, GetGuildBankItemInfo(tab, slot))
			if (count or 1) > 1 then
				counts[slot] = count
			end
		end
	end
	return items, counts
end

local function SaveGuildBank()
	local key = atGuildBank and GuildKey()
	if not key then
		return
	end
	local guilds = Offline.Store().guilds
	local guild = guilds[key]
	if not guild then
		guild = { name = GetGuildInfo("player"), realm = E.myrealm, tabs = {} }
		guilds[key] = guild
	end
	guild.time = time()

	local changed, current = false, GetCurrentGuildBankTab()
	for tab = 1, GetNumGuildBankTabs() do
		local name, icon, canView = GetGuildBankTabInfo(tab)
		if canView then
			local items, counts = ReadGuildTab(tab)
			-- A tab whose answer has not landed yet reads empty, only the tab
			-- the player looks at can be trusted to really be empty
			if tab == current or next(items) then
				local new = { size = GUILD_TAB_SLOTS, name = name, icon = icon, items = items, counts = counts }
				if not Same(guild.tabs[tab], new) then
					Patch(guild.tabs[tab], new, key, key, true)
					guild.tabs[tab] = new
					changed = true
				end
			end
		end
	end
	if changed then
		Changed("guild", true)
	end
end

-- The tabs the player never clicks hold no data until they are asked for
local function QueryGuildTabs()
	for tab = 1, GetNumGuildBankTabs() do
		if select(3, GetGuildBankTabInfo(tab)) then
			C_Timer.After((tab - 1) * GUILD_QUERY_STEP, function()
				if atGuildBank then
					QueryGuildBankTab(tab)
				end
			end)
		end
	end
end

-- A burst of updates only saves once
local pending = {}
local SAVERS = { bags = SaveBags, bank = SaveBanks, equip = SaveEquipped, mail = SaveMail, guild = SaveGuildBank }

local function Flush()
	for what, saver in pairs(SAVERS) do
		if pending[what] then
			pending[what] = nil
			-- A save queued just before both switches went off is dropped
			if Active() then
				saver()
			end
		end
	end
end

local flushQueued = false
local function FlushQueued()
	flushQueued = false
	Flush()
end

local function Queue(what)
	pending[what] = true
	if not flushQueued then
		flushQueued = true
		C_Timer.After(0.5, FlushQueued)
	end
end

-------------------------------------------------------------------------------
--  Events, only registered while an option needs them
-------------------------------------------------------------------------------
local events = CreateFrame("Frame")
events:SetScript("OnEvent", function(_, event, arg)
	if event == "BAG_UPDATE" then
		if BAG_POS[arg] then
			dirty[arg] = true
		elseif atBank and (CHAR_POS[arg] or WARBAND_POS[arg]) then
			dirty[arg] = true
			Queue("bank")
		end
	elseif event == "BAG_UPDATE_DELAYED" then
		Queue("bags")
	elseif event == "BAG_CONTAINER_UPDATE" then
		MarkAll(BAGS)
		Queue("bags")
	elseif event == "PLAYER_EQUIPMENT_CHANGED" then
		Queue("equip")
	elseif event == "MAIL_INBOX_UPDATE" then
		if atMail then
			Queue("mail")
		end
	elseif event == "GUILDBANKBAGSLOTS_CHANGED" then
		if atGuildBank then
			Queue("guild")
		end
	elseif event == "PLAYER_INTERACTION_MANAGER_FRAME_SHOW" then
		if arg == PIT.Banker or arg == PIT.AccountBanker then
			atBank, atCharBank = true, arg == PIT.Banker
			MarkAll(CHAR_BANK)
			MarkAll(WARBAND_BANK)
			Queue("bank")
		elseif arg == PIT.MailInfo then
			atMail = true
			Queue("mail")
		elseif arg == PIT.GuildBanker then
			atGuildBank = true
			QueryGuildTabs()
		end
	elseif event == "PLAYER_INTERACTION_MANAGER_FRAME_HIDE" then
		if arg == PIT.Banker or arg == PIT.AccountBanker or arg == PIT.MailInfo or arg == PIT.GuildBanker then
			Flush() -- saved before the contents go unreadable
			if arg == PIT.MailInfo then
				atMail = false
			elseif arg == PIT.GuildBanker then
				atGuildBank = false
			else
				atBank, atCharBank = false, false
			end
		end
	elseif atBank then
		-- A tab bought or renamed, arg = its bank type. Slot changes come
		-- through BAG_UPDATE with the tab's bag ID.
		if arg == BANK_TYPE_ACCOUNT then
			MarkAll(WARBAND_BANK)
			Queue("bank")
		elseif arg == BANK_TYPE_CHARACTER then
			MarkAll(CHAR_BANK)
			Queue("bank")
		end
	end
end)

local EVENTS = {
	"BAG_UPDATE",
	"BAG_UPDATE_DELAYED",
	"BAG_CONTAINER_UPDATE",
	"PLAYER_EQUIPMENT_CHANGED",
	"MAIL_INBOX_UPDATE",
	"GUILDBANKBAGSLOTS_CHANGED",
	"PLAYER_INTERACTION_MANAGER_FRAME_SHOW",
	"PLAYER_INTERACTION_MANAGER_FRAME_HIDE",
	"BANK_TABS_CHANGED",
	"BANK_TAB_SETTINGS_UPDATED",
}

local listening = false
local function SyncEvents()
	local on = Active()
	if on == listening then
		return
	end
	listening = on
	for _, event in ipairs(EVENTS) do
		if on then
			events:RegisterEvent(event)
		else
			events:UnregisterEvent(event)
		end
	end
	if on then
		BuildBagLists()
		MarkAll(BAGS)
		Queue("bags")
		Queue("equip")
	end
end

-- Every saved inventory goes, this character saves again right away
function Offline.Wipe()
	_G.MER_BagsInventoryDB = nil
	index = nil
	Changed("forget")
	if listening then
		MarkAll(BAGS)
		Queue("bags")
		Queue("equip")
	end
end

-------------------------------------------------------------------------------
--  Tooltip item counts
-------------------------------------------------------------------------------
local FIELDS = { "bags", "bank", "equip", "mail" }
local FIELD_LABELS = { bags = L["Bags"], bank = L["Bank"], equip = L["Equipped"], mail = L["Mail"] }

-- index.chars[itemID][key] = { bags, bank, equip, mail }, index.guilds[itemID][key] = n,
-- index.warband[itemID] = n. sign -1 takes a container back out.
local function AddToChars(t, field, owner, sign)
	local into = index.chars
	for slot, s in pairs(t.items) do
		local id = ItemID(s)
		if id then
			local row = into[id]
			if not row then
				row = {}
				into[id] = row
			end
			local entry = row[owner]
			if not entry then
				entry = {}
				row[owner] = entry
			end
			entry[field] = (entry[field] or 0) + (t.counts[slot] or 1) * sign
			if entry[field] <= 0 then
				entry[field] = nil
			end
			if not next(entry) then
				row[owner] = nil
			end
			if not next(row) then
				into[id] = nil
			end
		end
	end
end

local function AddToGuild(t, owner, sign)
	local into = index.guilds
	for slot, s in pairs(t.items) do
		local id = ItemID(s)
		if id then
			local row = into[id]
			if not row then
				row = {}
				into[id] = row
			end
			local n = (row[owner] or 0) + (t.counts[slot] or 1) * sign
			row[owner] = n > 0 and n or nil
			if not next(row) then
				into[id] = nil
			end
		end
	end
end

local function AddToWarband(t, sign)
	local into = index.warband
	for slot, s in pairs(t.items) do
		local id = ItemID(s)
		if id then
			local n = (into[id] or 0) + (t.counts[slot] or 1) * sign
			into[id] = n > 0 and n or nil
		end
	end
end

local function Index()
	if index and indexRev == rev then
		return index
	end
	index = { chars = {}, guilds = {}, warband = {} }
	indexRev = rev
	local db = Offline.Store()
	for key, c in pairs(db.chars) do
		for _, field in ipairs(FIELDS) do
			for _, t in ipairs(c[field] or empty) do
				if t then
					AddToChars(t, field, key, 1)
				end
			end
		end
	end
	for key, guild in pairs(db.guilds) do
		for _, t in pairs(guild.tabs) do
			AddToGuild(t, key, 1)
		end
	end
	for _, t in pairs(db.warband.tabs) do
		AddToWarband(t, 1)
	end
	return index
end

-- One container swapped for another: the index is fixed up in place instead of
-- rebuilt on the next hover (Changed keeps it current)
function Patch(old, new, field, owner, isGuild)
	if not (index and indexRev == rev) then
		return
	end
	if isGuild then
		if old then
			AddToGuild(old, owner, -1)
		end
		AddToGuild(new, owner, 1)
	elseif owner then
		if old then
			AddToChars(old, field, owner, -1)
		end
		if new then
			AddToChars(new, field, owner, 1)
		end
	else
		if old then
			AddToWarband(old, -1)
		end
		AddToWarband(new, 1)
	end
end

local function NormalRealm(realm)
	return gsub(realm or "", "[%s%-]", "")
end

local connectedRealms
local function IsShownRealm(realm)
	if Settings().tooltipScope ~= "CONNECTED" then
		return true
	end
	if not connectedRealms then
		connectedRealms = { [NormalRealm(E.myrealm)] = true }
		for _, name in ipairs(GetAutoCompleteRealms() or empty) do
			connectedRealms[NormalRealm(name)] = true
		end
	end
	return connectedRealms[NormalRealm(realm)]
end

local function IsShownChar(c)
	if not IsShownRealm(c.realm) then
		return false
	end
	return not Settings().tooltipOwnFaction or c.faction == nil or c.faction == E.myfaction
end

local function SortLines(a, b)
	return a.n > b.n
end

local function ClassLine(c)
	local color = c.class and E:ClassColor(c.class)
	return color and color.r or 1, color and color.g or 1, color and color.b or 1
end

-- Two characters of one name on other realms get their realm added
local sameName = {}
local function CountNames(row, db)
	wipe(sameName)
	for key in pairs(row) do
		local c = db.chars[key]
		if c and c.name then
			sameName[c.name] = (sameName[c.name] or 0) + 1
		end
	end
end

local function CharLine(c, entry)
	local parts, n = {}, 0
	for _, field in ipairs(FIELDS) do
		local count = entry[field]
		if count then
			tinsert(parts, format("%s %d", FIELD_LABELS[field], count))
			n = n + count
		end
	end
	local name = c.name or "?"
	if (sameName[name] or 0) > 1 and c.realm then
		name = format("%s-%s", name, c.realm)
	end
	local r, g, b = ClassLine(c)
	return { left = name, right = tconcat(parts, "  "), r = r, g = g, b = b, n = n }
end

local function BuildLines(id)
	local idx = Index()
	local row, guildRow, warband = idx.chars[id], idx.guilds[id], idx.warband[id]
	if not (row or guildRow or warband) then
		return false
	end

	local db, lines, total = Offline.Store(), {}, 0
	CountNames(row or empty, db)
	for key, entry in pairs(row or empty) do
		local c = db.chars[key]
		if c and IsShownChar(c) then
			local line = CharLine(c, entry)
			tinsert(lines, line)
			total = total + line.n
		end
	end
	sort(lines, SortLines)

	for key, n in pairs(guildRow or empty) do
		local guild = db.guilds[key]
		if guild and IsShownRealm(guild.realm) then
			tinsert(lines, { left = guild.name, right = n, r = 0.25, g = 1, b = 0.25 })
			total = total + n
		end
	end
	if warband then
		tinsert(lines, { left = L["Warband Bank"], right = warband, r = 0.4, g = 0.78, b = 1 })
		total = total + warband
	end

	if #lines == 0 then
		return false
	end
	if #lines > 1 then
		tinsert(lines, { left = _G.TOTAL, right = total, r = 1, g = 0.82, b = 0, isTotal = true })
	end
	return lines
end

-- Finished lines per item ID, until the next write
local lineCache, lineRev = {}, -1

-- Also used by the viewer's All Characters tab, which needs them with the
-- tooltip option off too
function Offline.AddCountLines(tooltip, id)
	if lineRev ~= rev then
		wipe(lineCache)
		lineRev = rev
	end
	local lines = lineCache[id]
	if lines == nil then
		lines = BuildLines(id)
		lineCache[id] = lines
	end
	if not lines then
		return
	end

	tooltip:AddLine(" ")
	for _, line in ipairs(lines) do
		local value = line.isTotal and 1 or 0.8
		tooltip:AddDoubleLine(line.left, line.right, line.r, line.g, line.b, value, value, value)
	end
end

local function OnItemTooltip(tooltip, data)
	if not (listening and Offline.CountsEnabled()) then
		return
	end
	if (tooltip ~= _G.GameTooltip and tooltip ~= _G.ItemRefTooltip) or tooltip:IsForbidden() then
		return
	end
	local id = data and data.id
	if type(id) == "number" and not E:IsSecretValue(id) then
		Offline.AddCountLines(tooltip, id)
	end
end

-- The post call cannot be unhooked, it just bails while off
local hooked = false
local function SyncTooltip()
	if hooked or not (listening and Offline.CountsEnabled()) then
		return
	end
	hooked = true
	_G.TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnItemTooltip)

	-- Built a moment after login, not inside the first hover
	C_Timer.After(3, function()
		if listening and Offline.CountsEnabled() then
			Index()
		end
	end)
end

---Called on load and from the options
function module:UpdateOffline()
	SyncEvents()
	SyncTooltip()
	Changed("settings")
end

-- Every saved container, for the viewer's All Characters tab
function Offline.EachContainer(callback)
	local db = Offline.Store()
	for _, c in pairs(db.chars) do
		for _, field in ipairs(FIELDS) do
			for _, t in ipairs(c[field] or empty) do
				if t then
					callback(t)
				end
			end
		end
	end
	for _, guild in pairs(db.guilds) do
		for _, t in pairs(guild.tabs) do
			callback(t)
		end
	end
	for _, t in pairs(db.warband.tabs) do
		callback(t)
	end
end
