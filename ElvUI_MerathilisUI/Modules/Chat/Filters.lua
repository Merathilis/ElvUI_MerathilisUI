local MER, E, L, V, P, G = unpack(select(2, ...))
local MERC = MER:GetModule("muiChat")

-- Cache global variables
-- Lua functions
local _G = _G
local split, strfind, strmatch, gmatch, gsub, sub = string.split, string.find, string.match, string.gmatch, string.gsub, string.sub
local pairs, ipairs, tonumber = pairs, ipairs, tonumber
local min, max, tremove = math.min, math.max, table.remove
-- WoW API / Variable
local GetCVarBool = GetCVarBool
local SetCVar = SetCVar
local GetInstanceInfo = GetInstanceInfo
local IsGuildMember = IsGuildMember
local IsInInstance = IsInInstance
local C_FriendList_IsFriend = C_FriendList.IsFriend
local C_BattleNet_GetGameAccountInfoByGUID = C_BattleNet.GetGameAccountInfoByGUID
local IsGUIDInGroup = IsGUIDInGroup
local C_Timer_After = C_Timer.After
local Ambiguate = Ambiguate
local UnitIsUnit = UnitIsUnit
local GetTime = GetTime
local ChatFrame_AddMessageEventFilter = ChatFrame_AddMessageEventFilter
local ChatFrame_RemoveMessageEventFilter = ChatFrame_RemoveMessageEventFilter
-- GLOBALS:

-- Filter Chat symbols
local msgSymbols = {'`', '～', '＠', '＃', '^', '＊', '！', '？', '。', '|', ' ', '—', '——', '￥', '’', '‘', '“', '”', '【', '】', '『', '』', '《', '》', '〈', '〉', '（', '）', '〔', '〕', '、', '，', '：', ',', '_', '/', '~', '%-', '%.'}

local FilterList = {}
function MERC:UpdateFilterList()
	MER:SplitList(FilterList, E.db.mui.chat.filter.keywords, true)
end

-- ECF strings compare
local last, this = {}, {}
function MERC:CompareStrDiff(sA, sB) -- arrays of bytes
	local len_a, len_b = #sA, #sB
	for j = 0, len_b do
		last[j+1] = j
	end
	for i = 1, len_a do
		this[1] = i
		for j = 1, len_b do
			this[j+1] = (sA[i] == sB[j]) and last[j] or (min(last[j+1], this[j], last[j]) + 1)
		end
		for j = 0, len_b do
			last[j+1] = this[j+1]
		end
	end
	return this[len_b+1] / max(len_a, len_b)
end

MER.BadBoys = {} -- debug
local chatLines, prevLineID, filterResult = {}, 0, false
function MERC:GetFilterResult(event, msg, name, flag, guid)
	if name == E.myname or (event == 'CHAT_MSG_WHISPER' and flag == 'GM') or flag == 'DEV' then
		return
	elseif guid and (IsGuildMember(guid) or C_BattleNet_GetGameAccountInfoByGUID(guid) or C_FriendList_IsFriend(guid) or (IsInInstance() and IsGUIDInGroup(guid))) then
		return
	end

	if MER.BadBoys[name] and MER.BadBoys[name] >= 5 then return true end

	local filterMsg = gsub(msg, '|H.-|h(.-)|h', '%1')
	filterMsg = gsub(filterMsg, '|c%x%x%x%x%x%x%x%x', '')
	filterMsg = gsub(filterMsg, '|r', '')

	-- Trash Filter
	for _, symbol in ipairs(msgSymbols) do
		filterMsg = gsub(filterMsg, symbol, '')
	end

	local matches = 0
	for keyword in pairs(FilterList) do
		if keyword ~= '' then
			local _, count = gsub(filterMsg, keyword, '')
			if count > 0 then
				matches = matches + 1
			end
		end
	end

	if matches >= 1 then
		return true
	end

	-- ECF Repeat Filter
	local msgTable = {name, {}, GetTime()}
	if filterMsg == '' then filterMsg = msg end
	for i = 1, #filterMsg do
		msgTable[2][i] = filterMsg:byte(i)
	end
	local chatLinesSize = #chatLines
	chatLines[chatLinesSize+1] = msgTable
	for i = 1, chatLinesSize do
		local line = chatLines[i]
		if line[1] == msgTable[1] and ((msgTable[3] - line[3] < .6) or MERC:CompareStrDiff(line[2], msgTable[2]) <= .1) then
			tremove(chatLines, i)
			return true
		end
	end
	if chatLinesSize >= 30 then tremove(chatLines, 1) end
end

function MERC:UpdateChatFilter(event, msg, author, _, _, _, flag, _, _, _, _, lineID, guid)
	if lineID == 0 or lineID ~= prevLineID then
		prevLineID = lineID

		local name = Ambiguate(author, 'none')
		filterResult = MERC:GetFilterResult(event, msg, name, flag, guid)
		if filterResult then MER.BadBoys[name] = (MER.BadBoys[name] or 0) + 1 end
	end

	return filterResult
end

-- Block addon msg
local addonBlockList = {
	'EUI[:_]',
	'<iLvl>',
	'<LFG>',
	'=>',
	'：.+>',
	'%*%*.+%*%*',
}

local cvar
local function toggleCVar(value)
	value = tonumber(value) or 1
	SetCVar(cvar, value)
end

function MERC:ToggleChatBubble(party)
	cvar = 'chatBubbles'..(party and 'Party' or '')
	if not GetCVarBool(cvar) then return end
	toggleCVar(0)
	C_Timer_After(.01, toggleCVar)
end

function MERC:UpdateAddOnBlocker(event, msg, author)
	local name = Ambiguate(author, 'none')
	if UnitIsUnit(name, 'player') then return end

	for _, word in ipairs(addonBlockList) do
		if strfind(msg, word) then
			if event == 'CHAT_MSG_SAY' or event == 'CHAT_MSG_YELL' then
				MERC:ToggleChatBubble()
			elseif event == 'CHAT_MSG_PARTY' or event == 'CHAT_MSG_PARTY_LEADER' then
				MERC:ToggleChatBubble(true)
			end
			return true
		end
	end
end

-- Filter azerite message on island expeditions
local azerite = _G.ISLANDS_QUEUE_WEEKLY_QUEST_PROGRESS:gsub('%%d/%%d ', '')
local function filterAzeriteGain(_, _, msg)
	if strfind(msg, azerite) then
		return true
	end
end

local function isPlayerOnIslands()
	local _, instanceType, _, _, maxPlayers = GetInstanceInfo()
	if instanceType == 'scenario' and (maxPlayers == 3 or maxPlayers == 6) then
		ChatFrame_AddMessageEventFilter('CHAT_MSG_SYSTEM', filterAzeriteGain)
	else
		ChatFrame_RemoveMessageEventFilter('CHAT_MSG_SYSTEM', filterAzeriteGain)
	end
end

function MERC:ChatFilter()
	if E.db.mui.chat.filter.enable then
		self:UpdateFilterList()

		ChatFrame_AddMessageEventFilter('CHAT_MSG_CHANNEL', self.UpdateChatFilter)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_SAY', self.UpdateChatFilter)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_YELL', self.UpdateChatFilter)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_WHISPER', self.UpdateChatFilter)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_EMOTE', self.UpdateChatFilter)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_TEXT_EMOTE', self.UpdateChatFilter)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_RAID', self.UpdateChatFilter)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_RAID_LEADER', self.UpdateChatFilter)
	end

	if E.db.mui.chat.filter.blockAddOnAlerts then
		ChatFrame_AddMessageEventFilter('CHAT_MSG_SAY', self.UpdateAddOnBlocker)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_WHISPER', self.UpdateAddOnBlocker)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_EMOTE', self.UpdateAddOnBlocker)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_PARTY', self.UpdateAddOnBlocker)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_PARTY_LEADER', self.UpdateAddOnBlocker)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_RAID', self.UpdateAddOnBlocker)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_RAID_LEADER', self.UpdateAddOnBlocker)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_INSTANCE_CHAT', self.UpdateAddOnBlocker)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_INSTANCE_CHAT_LEADER', self.UpdateAddOnBlocker)
		ChatFrame_AddMessageEventFilter('CHAT_MSG_CHANNEL', self.UpdateAddOnBlocker)
	end
	MER:RegisterEvent('PLAYER_ENTERING_WORLD', isPlayerOnIslands)
end
