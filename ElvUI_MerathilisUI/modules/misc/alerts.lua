local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule("mUIMisc")

--Cache global variables
--Lua functions
local _G = _G
local tonumber = tonumber
local twipe = table.wipe
local format = string.format
local gsub = gsub
local strsplit = strsplit
local Ambiguate = Ambiguate
--WoW API / Variables
local C_ChatInfo_SendAddonMessage = C_ChatInfo.SendAddonMessage
local C_ChatInfo_RegisterAddonMessagePrefix = C_ChatInfo.RegisterAddonMessagePrefix
local CreateFrame = CreateFrame
local IsInGuild = IsInGuild
local IsPartyLFG = IsPartyLFG
local IsInRaid = IsInRaid
local SendChatMessage = SendChatMessage
local UnitDebuff = UnitDebuff
-- GLOBALS:

local function msgChannel()
	return IsPartyLFG() and "INSTANCE_CHAT" or IsInRaid() and "RAID" or "PARTY"
end

function module:VersionCheck()
	if not E.db.mui.misc.alerts.versionCheck then return end

	local f = CreateFrame("Frame", nil, nil, "MicroButtonAlertTemplate")
	f:SetPoint("BOTTOMLEFT", _G.ChatFrame1, "TOPLEFT", 20, 70)
	f.Text:SetText("")
	f:Hide()

	local DetectVersion = E.db.mui.misc.alerts.detectVersion

	local function CompareVersion(new, old)
		local new1, new2 = strsplit(".", new)
		new1, new2 = tonumber(new1), tonumber(new2)
		local old1, old2 = strsplit(".", old)
		old1, old2 = tonumber(old1), tonumber(old2)
		if new1 > old1 or new2 > old2 then
			return "IsNew"
		elseif new1 < old1 or new2 < old2 then
			return "IsOld"
		end
	end

	local checked
	local function UpdateVersionCheck(_, ...)
		local prefix, msg, distType, author = ...
		if prefix ~= "MERVersionCheck" then return end
		if Ambiguate(author, "none") == E.myname then return end

		local status = CompareVersion(msg, DetectVersion)
		if status == "IsNew" then
			E.db.mui.general.detectVersion = msg
		elseif status == "IsOld" then
			C_ChatInfo_SendAddonMessage("MERVersionCheck", DetectVersion, distType)
		end

		if not checked then
			if CompareVersion(DetectVersion, MER.Version) == "IsNew" then
				local release = gsub(DetectVersion, "(%d)$", "0")
				f.Text:SetText(format(L["Outdated MER"], release))
				f:Show()
			end
			checked = true
		end
	end

	MER:RegisterEvent("CHAT_MSG_ADDON", UpdateVersionCheck)
	C_ChatInfo_RegisterAddonMessagePrefix("MERVersionCheck")
	if IsInGuild() then
		C_ChatInfo_SendAddonMessage("MERVersionCheck", MER.Version, "GUILD")
	end
end

function module:UunatAlert()
	local data = {}
	local function isBuffBlock()
		for i = 1, 40 do
			local name, _, _, _, _, _, _, _, _, spellID = UnitDebuff("player", i)
			if not name then break end
			if name and spellID == 284733 then
				return true
			end
		end
	end

	MER:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", function(_, ...)
		if not E.db.mui.misc.alerts.UunatAlert then return end
		local _, eventType, _, _, _, _, _, _, destName, _, _, spellID = ...
		if eventType == "SPELL_DAMAGE" and spellID == 285214 and not isBuffBlock() then
			data[destName] = (data[destName] or 0) + 1
			SendChatMessage(format(L["UunatAlertString"], destName, data[destName]), msgChannel())
		end
	end)

	MER:RegisterEvent("ENCOUNTER_END", function()
		twipe(data)
	end)
end

function module:AddAlerts()
	self:VersionCheck()
	self:UunatAlert()
end
