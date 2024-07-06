local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Chat")

local _G = _G
local strfind, gsub = string.find, string.gsub
local pairs, ipairs, tonumber = pairs, ipairs, tonumber
local min, max, tremove = math.min, math.max, table.remove

local GetCVarBool = GetCVarBool
local SetCVar = SetCVar
local IsGuildMember = IsGuildMember
local IsInInstance = IsInInstance
local IsFriend = C_FriendList.IsFriend
local GetGameAccountInfoByGUID = C_BattleNet.GetGameAccountInfoByGUID
local IsGUIDInGroup = IsGUIDInGroup
local After = C_Timer.After
local Ambiguate = Ambiguate
local UnitIsUnit = UnitIsUnit
local GetTime = GetTime
local ChatFrame_AddMessageEventFilter = ChatFrame_AddMessageEventFilter

-- Filter Chat symbols
local msgSymbols = {
	"`",
	"～",
	"＠",
	"＃",
	"^",
	"＊",
	"！",
	"？",
	"。",
	"|",
	" ",
	"—",
	"——",
	"￥",
	"’",
	"‘",
	"“",
	"”",
	"【",
	"】",
	"『",
	"』",
	"《",
	"》",
	"〈",
	"〉",
	"（",
	"）",
	"〔",
	"〕",
	"、",
	"，",
	"：",
	",",
	"_",
	"/",
	"~",
	"%-",
	"%.",
}

local FilterList = {}
function module:UpdateFilterList()
	F.SplitList(FilterList, E.db.mui.chat.filter.keywords, true)
end

-- ECF strings compare
local last, this = {}, {}
function module:CompareStrDiff(sA, sB) -- arrays of bytes
	local len_a, len_b = #sA, #sB
	for j = 0, len_b do
		last[j + 1] = j
	end
	for i = 1, len_a do
		this[1] = i
		for j = 1, len_b do
			this[j + 1] = (sA[i] == sB[j]) and last[j] or (min(last[j + 1], this[j], last[j]) + 1)
		end
		for j = 0, len_b do
			last[j + 1] = this[j + 1]
		end
	end
	return this[len_b + 1] / max(len_a, len_b)
end

MER.BadBoys = {} -- debug
local chatLines, prevLineID, filterResult = {}, 0, false
function module:GetFilterResult(event, msg, name, flag, guid)
	if name == E.myname or (event == "CHAT_MSG_WHISPER" and flag == "GM") or flag == "DEV" then
		return
	elseif
		guid
		and (
			IsGuildMember(guid)
			or GetGameAccountInfoByGUID(guid)
			or IsFriend(guid)
			or (IsInInstance() and IsGUIDInGroup(guid))
		)
	then
		return
	end

	if MER.BadBoys[name] and MER.BadBoys[name] >= 5 then
		return true
	end

	local filterMsg = gsub(msg, "|H.-|h(.-)|h", "%1")
	filterMsg = gsub(filterMsg, "|c%x%x%x%x%x%x%x%x", "")
	filterMsg = gsub(filterMsg, "|r", "")

	-- Trash Filter
	for _, symbol in ipairs(msgSymbols) do
		filterMsg = gsub(filterMsg, symbol, "")
	end

	local matches = 0
	for keyword in pairs(FilterList) do
		if keyword ~= "" then
			local _, count = gsub(filterMsg, keyword, "")
			if count > 0 then
				matches = matches + 1
			end
		end
	end

	if matches >= 1 then
		return true
	end

	-- ECF Repeat Filter
	local msgTable = { name, {}, GetTime() }
	if filterMsg == "" then
		filterMsg = msg
	end
	for i = 1, #filterMsg do
		msgTable[2][i] = filterMsg:byte(i)
	end
	local chatLinesSize = #chatLines
	chatLines[chatLinesSize + 1] = msgTable
	for i = 1, chatLinesSize do
		local line = chatLines[i]
		if
			line[1] == msgTable[1]
			and ((msgTable[3] - line[3] < 0.6) or module:CompareStrDiff(line[2], msgTable[2]) <= 0.1)
		then
			tremove(chatLines, i)
			return true
		end
	end
	if chatLinesSize >= 30 then
		tremove(chatLines, 1)
	end
end

function module:UpdateChatFilter(event, msg, author, _, _, _, flag, _, _, _, _, lineID, guid)
	if lineID == 0 or lineID ~= prevLineID then
		prevLineID = lineID

		local name = Ambiguate(author, "none")
		filterResult = module:GetFilterResult(event, msg, name, flag, guid)
		if filterResult then
			MER.BadBoys[name] = (MER.BadBoys[name] or 0) + 1
		end
	end

	return filterResult
end

-- Block addon msg
local addonBlockList = {
	"EUI[:_]",
	"<iLvl>",
	"<LFG>",
	"=>",
	"：.+>",
	"%*%*.+%*%*",
}

local cvar
local function toggleCVar(value)
	value = tonumber(value) or 1
	SetCVar(cvar, value)
end

function module:ToggleChatBubble(party)
	cvar = "chatBubbles" .. (party and "Party" or "")
	if not GetCVarBool(cvar) then
		return
	end
	toggleCVar(0)
	After(0.01, toggleCVar)
end

function module:UpdateAddOnBlocker(event, msg, author)
	local name = Ambiguate(author, "none")
	if UnitIsUnit(name, "player") then
		return
	end

	for _, word in ipairs(addonBlockList) do
		if strfind(msg, word) then
			if event == "CHAT_MSG_SAY" or event == "CHAT_MSG_YELL" then
				module:ToggleChatBubble()
			elseif event == "CHAT_MSG_PARTY" or event == "CHAT_MSG_PARTY_LEADER" then
				module:ToggleChatBubble(true)
			end
			return true
		end
	end
end
function module:ChatFilter()
	if E.db.mui.chat.filter.enable then
		self:UpdateFilterList()

		ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", self.UpdateChatFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", self.UpdateChatFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", self.UpdateChatFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", self.UpdateChatFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", self.UpdateChatFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_TEXT_EMOTE", self.UpdateChatFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", self.UpdateChatFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", self.UpdateChatFilter)
	end

	if E.db.mui.chat.filter.blockAddOnAlerts then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", self.UpdateAddOnBlocker)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", self.UpdateAddOnBlocker)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", self.UpdateAddOnBlocker)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", self.UpdateAddOnBlocker)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", self.UpdateAddOnBlocker)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", self.UpdateAddOnBlocker)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", self.UpdateAddOnBlocker)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", self.UpdateAddOnBlocker)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", self.UpdateAddOnBlocker)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", self.UpdateAddOnBlocker)
	end
end
