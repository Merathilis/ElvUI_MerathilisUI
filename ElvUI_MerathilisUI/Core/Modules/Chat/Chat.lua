local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Chat')
local CH = E:GetModule('Chat')

local format = format

local r, g, b = unpack(E.media.rgbvaluecolor)

function CH:ChatFrame_SystemEventHandler(chat, event, message, ...)
	if event == "GUILD_MOTD" then
		if message and message ~= "" then
			local info = ChatTypeInfo["GUILD"]
			local GUILD_MOTD = "GMOTD"
			chat:AddMessage(format('|cff00c0fa%s|r: %s', GUILD_MOTD, message), info.r, info.g, info.b, info.id)
		end
		return true
	else
		return ChatFrame_SystemEventHandler(chat, event, message, ...)
	end
end

-- Hide communities chat. Useful for streamers
-- Credits Nnogga
local commOpen = CreateFrame("Frame", nil, UIParent)
commOpen:RegisterEvent("ADDON_LOADED")
commOpen:RegisterEvent("CHANNEL_UI_UPDATE")
commOpen:SetScript("OnEvent", function(self, event, addonName)
	if event == "ADDON_LOADED" and addonName == "Blizzard_Communities" then
		--create overlay
		local f = CreateFrame("Button", nil, UIParent)
		f:SetFrameStrata("HIGH")

		f.tex = f:CreateTexture(nil, "BACKGROUND")
		f.tex:SetAllPoints()
		f.tex:SetColorTexture(0.1, 0.1, 0.1, 1)

		f.text = f:CreateFontString()
		f.text:FontTemplate(nil, 20, "OUTLINE")
		f.text:SetShadowOffset(-2, 2)
		f.text:SetText(L["Chat Hidden. Click to show"])
		f.text:SetTextColor(r, g, b)
		f.text:SetJustifyH("CENTER")
		f.text:SetJustifyV("MIDDLE")
		f.text:Height(20)
		f.text:Point("CENTER", f, "CENTER", 0, 0)

		f:EnableMouse(true)
		f:RegisterForClicks("AnyUp")
		f:SetScript("OnClick",function(...)
			f:Hide()
		end)

		--toggle
		local function toggleOverlay()
			if _G.CommunitiesFrame:GetDisplayMode() == _G.COMMUNITIES_FRAME_DISPLAY_MODES.CHAT and E.db.mui.chat.general.hideChat then
				f:SetAllPoints(_G.CommunitiesFrame.Chat.InsetFrame)
				f:Show()
			else
				f:Hide()
			end
		end

		local function hideOverlay()
			f:Hide()
		end
		toggleOverlay() --run once

		--hook
		hooksecurefunc(_G.CommunitiesFrame, "SetDisplayMode", toggleOverlay)
		hooksecurefunc(_G.CommunitiesFrame, "Show", toggleOverlay)
		hooksecurefunc(_G.CommunitiesFrame, "Hide", hideOverlay)
		hooksecurefunc(_G.CommunitiesFrame, "OnClubSelected", toggleOverlay)
	end
end)

function module:Configure_All()
	module:Configure_ChatFade()
end

function module:Initialize()
	self.db = E.db.mui.chat
	if not self.db or not E.private.chat.enable then
		return
	end

	if self.db.general.customOnlineMessage then
		_G["ERR_FRIEND_ONLINE_SS"] = "%s "..L["ERR_FRIEND_ONLINE"]
		_G["ERR_FRIEND_OFFLINE_S"] = "%s "..L["ERR_FRIEND_OFFLINE"]

		_G["BN_INLINE_TOAST_FRIEND_ONLINE"] = "%s"..L["BN_INLINE_TOAST_FRIEND_ONLINE"]
		_G["BN_INLINE_TOAST_FRIEND_OFFLINE"] = "%s"..L["BN_INLINE_TOAST_FRIEND_OFFLINE"]
	end

	module:ChatStyle()

	if E.Retail then
		module:ChatFilter()
	end
	module:DamageMeterFilter()
	module:LoadChatFade()

	--Custom Emojis
	local t = "|TInterface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\chatEmojis\\%s:16:16|t"

	-- Twitch Emojis
	CH:AddSmiley(':monkaomega:', format(t, 'monkaomega'))
	CH:AddSmiley(':salt:', format(t, 'salt'))
end

MER:RegisterModule(module:GetName())
