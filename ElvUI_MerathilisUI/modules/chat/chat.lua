local MER, E, L, V, P, G = unpack(select(2, ...))
local MERC = E:NewModule("muiChat")
local CH = E:GetModule("Chat")
MERC.modName = L["Chat"]

-- Cache global variables
-- Lua functions
local _G = _G
local format, gsub = string.format, string.gsub
-- WoW API / Variable
local ChatTypeInfo = ChatTypeInfo
local GetRealmName = GetRealmName
local strsplit = strsplit

-- GLOBALS: ChatFrame_DisplayGMOTD, ChatFrame_DisplayGMOTD, GUILD_MOTD_TEMPLATE

local ChatFrame_AddMessageEventFilter = ChatFrame_AddMessageEventFilter

function MERC:RemoveCurrentRealmName(msg, author, ...)
	local realmName = gsub(GetRealmName(), " ", "")

	if msg and msg:find("-" .. realmName) then
		return false, gsub(msg, "%-"..realmName, ""), author, ...
	end
end

-- Hook to the BNet Toast Frame
local BN_TOAST_TYPE_FRIEND_ONLINE = 10
local BNCustomToasts = {}
local MATCH_STRING = ERR_FRIEND_ONLINE_SS:format(".+", "(.+)"):gsub("%[","%%[")
local guildMembers = {}

hooksecurefunc("BNToastFrame_AddToast", function(toastType, toastData)
	if toastType == BN_TOAST_TYPE_FRIEND_ONLINE then -- This data gets added to the original toasts table by the original function, but removed once BNToastFrame_Show is called
		local toast = {}
		toast.toastType = toastType
		toast.toastData = toastData
		BNToastFrame_RemoveToast(toastType, toastData)
		tinsert(BNCustomToasts, toast)
	end
end)

hooksecurefunc("BNToastFrame_Show", function()
	local frame = BNToastFrame
	frame:Hide()

	local i, toast = next(BNCustomToasts)

	local topLine = BNToastFrameTopLine
	local middleLine = BNToastFrameMiddleLine
	local bottomLine = BNToastFrameBottomLine

	if toastType == BN_TOAST_TYPE_FRIEND_ONLINE and (i and toast) then
		local toastType = toast.toastType
		local toonName = toast.toastData
		tremove(BNCustomToasts, i)

		if (toonName and toonName ~= "") then
			toonName = "|TInterface\\ChatFrame\\UI-ChatIcon-WOW:14:14:0:-1|t"..toonName
			middleLine:SetText(toonName, "Gildenmember")
			middleLine:SetTextColor(FRIENDS_BNET_NAME_COLOR.r, FRIENDS_BNET_NAME_COLOR.g, FRIENDS_BNET_NAME_COLOR.b)
			middleLine:Show()
		else
			middleLine:Hide()
		end

		BNToastFrameIconTexture:SetTexCoord(0, 0.25, 0.5, 1)
		topLine:Show()
		topLine:SetText("")
		topLine:SetTextColor(FRIENDS_BNET_NAME_COLOR.r, FRIENDS_BNET_NAME_COLOR.g, FRIENDS_BNET_NAME_COLOR.b)
		bottomLine:Show()
		bottomLine:SetText(BN_TOAST_ONLINE)
		bottomLine:SetTextColor(FRIENDS_GRAY_COLOR.r, FRIENDS_GRAY_COLOR.g, FRIENDS_GRAY_COLOR.b)
		BNToastFrameDoubleLine:Hide()
	end

	if (middleLine:IsShown() and bottomLine:IsShown()) then
		bottomLine:SetPoint("TOPLEFT", middleLine, "BOTTOMLEFT", 0, -4)
		BNToastFrame:SetHeight(63)
	else
		bottomLine:SetPoint("TOPLEFT", topLine, "BOTTOMLEFT", 0, -4)
		BNToastFrame:SetHeight(50)
	end

	BNToastFrame_UpdateAnchor(true)
	frame:Show()
	PlaySound(SOUNDKIT.UI_BNET_TOAST)
	frame.toastType = toastType
	frame.toastData = toastData
	frame.animIn:Play()
	BNToastFrameGlowFrame.glow:Show()
	BNToastFrameGlowFrame.glow.animIn:Play()
	frame.waitAndAnimOut:Stop()	--Just in case it's already animating out, but we want to reinstate it.
	if ( frame:IsMouseOver() ) then
		frame.waitAndAnimOut.animOut:SetStartDelay(1)
	else
		frame.waitAndAnimOut.animOut:SetStartDelay(frame.duration)
		frame.waitAndAnimOut:Play()
	end
end)

local f = CreateFrame("Frame")
f:RegisterEvent("CHAT_MSG_SYSTEM")
f:RegisterEvent("GUILD_ROSTER_UPDATE")
f:SetScript("OnEvent", function(self, event, ...)
	self[event](self, ...)
end)

function f:CHAT_MSG_SYSTEM(msg)
	local name = msg:match(MATCH_STRING)
	if name and guildMembers[name] then
		BNToastFrame_AddToast(BN_TOAST_TYPE_FRIEND_ONLINE, name)
	end
end

function f:GUILD_ROSTER_UPDATE()
	wipe(guildMembers)
	local name
	for i = 1, GetNumGuildMembers() do
		name = GetGuildRosterInfo(i)
		guildMembers[name] = true
	end
end

function MERC:Initialize()
	if E.private.chat.enable ~= true then return; end

	_G["ERR_FRIEND_ONLINE_SS"] = "|Hplayer:%s|h[%s]|h "..L["has come |cff298F00online|r."]
	_G["ERR_FRIEND_OFFLINE_S"] = "[%s] "..L["has gone |cffff0000offline|r."]
	_G["GUILD_MOTD_TEMPLATE"] = "|cff00c0faGMOTD|r: %s"

	-- Remove the Realm Name from system messages
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", MERC.RemoveCurrentRealmName)

	E:GetModule("muiSkins"):CreateGradient(_G["LeftChatPanel"].backdrop)
	if not (_G["LeftChatPanel"]).backdrop.stripes then
		E:GetModule("muiSkins"):CreateStripes(_G["LeftChatPanel"].backdrop)
	end

	E:GetModule("muiSkins"):CreateGradient(_G["RightChatPanel"].backdrop)
	if not (_G["RightChatPanel"]).backdrop.stripes then
		E:GetModule("muiSkins"):CreateStripes(_G["RightChatPanel"].backdrop)
	end
end
hooksecurefunc(CH, "Initialize", MERC.Initialize)

local function InitializeCallback()
	MERC:Initialize()
end

E:RegisterModule(MERC:GetName(), InitializeCallback)