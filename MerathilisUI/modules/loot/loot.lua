local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local MERLT = E:NewModule('MuiLoot', 'AceHook-3.0', 'AceEvent-3.0')

-- Credits belong to Darth Predator (ElvUI_SLE)
-- Cache global variables
local gsub = gsub
local GetItemIcon = GetItemIcon

MERLT.IconChannels = {
	"CHAT_MSG_BN_WHISPER",
	"CHAT_MSG_BN_WHISPER_INFORM",
	"CHAT_MSG_BN_CONVERSATION",
	"CHAT_MSG_CHANNEL",
	"CHAT_MSG_EMOTE",
	"CHAT_MSG_GUILD",
	"CHAT_MSG_INSTANCE_CHAT",
	"CHAT_MSG_INSTANCE_CHAT_LEADER",
	"CHAT_MSG_LOOT",
	"CHAT_MSG_OFFICER",
	"CHAT_MSG_PARTY",
	"CHAT_MSG_PARTY_LEADER",
	"CHAT_MSG_RAID",
	"CHAT_MSG_RAID_LEADER",
	"CHAT_MSG_RAID_WARNING",
	"CHAT_MSG_SAY",
	"CHAT_MSG_SYSTEM",
	"CHAT_MSG_WHISPER",
	"CHAT_MSG_WHISPER_INFORM",
	"CHAT_MSG_YELL",
}

function MERLT:AddLootIcons(event, message, ...)
	if E.db.muiLoot.lootIcon.channels[event] then
		local function IconForLink(link)
			local texture = GetItemIcon(link)
			return (E.db.muiLoot.lootIcon.position == "LEFT") and "\124T" .. texture .. ":" .. E.db.muiLoot.lootIcon.size .. "\124t" .. link or link .. "\124T" .. texture .. ":" .. E.db.muiLoot.lootIcon.size .. "\124t"
		end
		message = gsub(message, "(\124c%x+\124Hitem:.-\124h\124r)", IconForLink)
	end
	return false, message, ...
end

function MERLT:LootIconToggle()
	if E.db.muiLoot.lootIcon.enable then
		for i = 1, #MERLT.IconChannels do
			ChatFrame_AddMessageEventFilter(MERLT.IconChannels[i], MERLT.AddLootIcons)
		end
		-- ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", MERLT.AddLootIcons)
	else
		for i = 1, #MERLT.IconChannels do
			ChatFrame_RemoveMessageEventFilter(MERLT.IconChannels[i], MERLT.AddLootIcons)
		end
		-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_LOOT", MERLT.AddLootIcons)
	end
end

function MERLT:Initialize()
	if E.db.muiLoot.lootIcon.enable then
		MERLT:LootIconToggle()
	end
end

E:RegisterModule(MERLT:GetName())
