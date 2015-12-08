local E, L, V, P, G = unpack(ElvUI)
local MER = E:GetModule('MerathilisUI');

-- Cache global variables
local gsub = gsub
local GetItemIcon = GetItemIcon

function MER:AddLootIcons(event, message, ...)
	local function IconForLink(link)
		local texture = GetItemIcon(link)
		return (E.db.muiLoot.lootIcon.position == "LEFT") and "\124T" .. texture .. ":" .. E.db.muiLoot.lootIcon.size .. "\124t" .. link or link .. "\124T" .. texture .. ":" .. E.db.muiLoot.lootIcon.size .. "\124t"
	end
	message = gsub(message, "(\124c%x+\124Hitem:.-\124h\124r)", IconForLink)
	return false, message, ...
end

function MER:LootIconToogle()
	if E.db.muiLoot.lootIcon.enable then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", MER.AddLootIcons)
	else
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_LOOT", MER.AddLootIcons)
	end
end

function MER:LoadLoot()
	if E.db.muiLoot.lootIcon then
		self:LootIconToogle()
	end
end
