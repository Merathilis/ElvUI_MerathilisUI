local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local MERLT = E:NewModule('MuiLoot', 'AceHook-3.0', 'AceEvent-3.0')

-- Credits belong to Darth Predator (ElvUI_SLE)
-- Cache global variables
local gsub = gsub
local GetItemIcon = GetItemIcon

function MERLT:AddLootIcons(event, message, ...)
	local function IconForLink(link)
		local texture = GetItemIcon(link)
		return (E.db.muiLoot.lootIcon.position == "LEFT") and "\124T" .. texture .. ":" .. E.db.muiLoot.lootIcon.size .. "\124t" .. link or link .. "\124T" .. texture .. ":" .. E.db.muiLoot.lootIcon.size .. "\124t"
	end
	message = gsub(message, "(\124c%x+\124Hitem:.-\124h\124r)", IconForLink)
	return false, message, ...
end

function MERLT:LootIconToggle()
	if E.db.muiLoot.lootIcon.enable then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", MERLT.AddLootIcons)
	else
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_LOOT", MERLT.AddLootIcons)
	end
end

function MERLT:Initialize()
	if E.db.muiLoot.lootIcon.enable then
		MERLT:LootIconToggle()
	end
end

E:RegisterModule(MERLT:GetName())
