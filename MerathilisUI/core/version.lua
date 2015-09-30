local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

local check = function(self, event, prefix, message, channel, sender)
	if event == "CHAT_MSG_ADDON" then
		if prefix ~= "MUIVersion" or sender == E.MyName then return end
		if tonumber(message) ~= nil and tonumber(message) > tonumber(MER.Version) then
			StaticPopup_Show("OUTDATED")
			print("|cffff0000" .. L["UI"]["Outdated"] .. "|r")
			self:UnregisterEvent("CHAT_MSG_ADDON")
		end
	else
		if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
			SendAddonMessage("MUIVersion", tonumber(MER.Version), "INSTANCE_CHAT")
		elseif IsInRaid(LE_PARTY_CATEGORY_HOME) then
			SendAddonMessage("MUIVersion", tonumber(MER.Version), "RAID")
		elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
			SendAddonMessage("MUIVersion", tonumber(MER.Version), "PARTY")
		elseif IsInGuild() then
			SendAddonMessage("MUIVersion", tonumber(MER.Version), "GUILD")
		end
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("GROUP_ROSTER_UPDATE")
frame:RegisterEvent("CHAT_MSG_ADDON")
frame:SetScript("OnEvent", check)
RegisterAddonMessagePrefix("MUIVersion")

-- Whisper UI version
local whisp = CreateFrame("Frame")
whisp:RegisterEvent("CHAT_MSG_WHISPER")
whisp:RegisterEvent("CHAT_MSG_BN_WHISPER")
whisp:SetScript("OnEvent", function(self, event, text, name, ...)
	if text:lower():match("ui_version") then
		if event == "CHAT_MSG_WHISPER" then
			SendChatMessage("MerathilisUI" .. MER.Version, "WHISPER", nil, name)
		elseif event == "CHAT_MSG_BN_WHISPER" then
			BNSendWhisper(select(11, ...), "MerathilisUI" .. MER.Version)
		end
	end
end)
