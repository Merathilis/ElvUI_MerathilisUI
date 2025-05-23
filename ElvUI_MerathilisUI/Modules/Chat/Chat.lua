local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Chat")
local LA = MER:GetModule("MER_Layout")
local CH = E:GetModule("Chat")
local LO = E:GetModule("Layout")
local S = E:GetModule("Skins")

local _G = _G
local format = string.format

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local InCombatLockdown = InCombatLockdown

function module:StyleVoicePanel()
	if _G.ElvUIChatVoicePanel then
		S:CreateShadow(_G.ElvUIChatVoicePanel)
	end
end

function module:CreateSeparators()
	module.db = E.db.mui.chat
	if
		(not module.db and module.db.enable)
		or module.db.seperators and not module.db.seperators.enable
		or not E.private.chat.enable
	then
		return
	end

	--Left Chat Tab Separator
	local ltabseparator = CreateFrame("Frame", "LeftChatTabSeparator", _G.LeftChatPanel, "BackdropTemplate")
	ltabseparator:SetFrameStrata("BACKGROUND")
	ltabseparator:OffsetFrameLevel(2, _G.LeftChatPanel)
	ltabseparator:Height(1)
	ltabseparator:Point("TOPLEFT", _G.LeftChatPanel, 5, -24)
	ltabseparator:Point("TOPRIGHT", _G.LeftChatPanel, -5, -24)
	ltabseparator:SetTemplate("Transparent")
	ltabseparator:Hide()
	_G.LeftChatTabSeparator = ltabseparator

	--Right Chat Tab Separator
	local rtabseparator = CreateFrame("Frame", "RightChatTabSeparator", _G.RightChatPanel, "BackdropTemplate")
	rtabseparator:SetFrameStrata("BACKGROUND")
	rtabseparator:OffsetFrameLevel(2, _G.RightChatPanel)
	rtabseparator:Height(1)
	rtabseparator:Point("TOPLEFT", _G.RightChatPanel, 5, -24)
	rtabseparator:Point("TOPRIGHT", _G.RightChatPanel, -5, -24)
	rtabseparator:SetTemplate("Transparent")
	rtabseparator:Hide()
	_G.RightChatTabSeparator = rtabseparator

	module:UpdateSeperators()
end

hooksecurefunc(LO, "CreateChatPanels", module.CreateSeparators)

function module:UpdateSeperators()
	if not E.db.mui.chat.seperators.enable then
		return
	end

	local myVisibility = E.db.mui.chat.seperators.visibility
	-- local elvVisibility = E.db.chat.panelBackdrop -- TO DO: Fix ElvUIs visibility

	if myVisibility == "SHOWBOTH" then
		if _G.LeftChatTabSeparator then
			_G.LeftChatTabSeparator:Show()
		end
		if _G.RightChatTabSeparator then
			_G.RightChatTabSeparator:Show()
		end
	elseif myVisibility == "HIDEBOTH" then
		if _G.LeftChatTabSeparator then
			_G.LeftChatTabSeparator:Hide()
		end
		if _G.RightChatTabSeparator then
			_G.RightChatTabSeparator:Hide()
		end
	elseif myVisibility == "LEFT" then
		if _G.LeftChatTabSeparator then
			_G.LeftChatTabSeparator:Show()
		end
		if _G.RightChatTabSeparator then
			_G.RightChatTabSeparator:Hide()
		end
	elseif myVisibility == "RIGHT" then
		if _G.LeftChatTabSeparator then
			_G.LeftChatTabSeparator:Hide()
		end
		if _G.RightChatTabSeparator then
			_G.RightChatTabSeparator:Show()
		end
	end
end

hooksecurefunc(LO, "CreateChatPanels", module.UpdateSeperators)

function module:CreateChatButtons()
	if not E.db.mui.chat.chatButton or not E.private.chat.enable then
		return
	end

	E.db.mui.chat.expandPanel = 150
	E.db.mui.chat.panelHeight = E.db.mui.chat.panelHeight or E.db.chat.panelHeight

	local panelBackdrop = E.db.chat.panelBackdrop
	local ChatButton = CreateFrame("Frame", "mUIChatButton", _G["LeftChatPanel"].backdrop)
	ChatButton:ClearAllPoints()
	ChatButton:Point("TOPLEFT", _G["LeftChatPanel"].backdrop, "TOPLEFT", 4, -8)
	ChatButton:Size(13, 13)

	if E.db.chat.panelBackdrop == "HIDEBOTH" or E.db.chat.panelBackdrop == "ONLYRIGHT" then
		ChatButton:SetAlpha(0)
	else
		ChatButton:SetAlpha(0.55)
	end
	ChatButton:OffsetFrameLevel(5, _G.LeftChatPanel)

	ChatButton.tex = ChatButton:CreateTexture(nil, "OVERLAY")
	ChatButton.tex:SetInside()
	ChatButton.tex:SetTexture(I.General.MediaPath .. "Textures\\chatButton.tga")

	ChatButton:SetScript("OnMouseUp", function(_, btn)
		if InCombatLockdown() then
			return
		end
		if btn == "LeftButton" then
			if E.db.mui.chat.isExpanded then
				E.db.chat.panelHeight = E.db.chat.panelHeight - E.db.mui.chat.expandPanel
				CH:PositionChats()
				E.db.mui.chat.isExpanded = false
			else
				E.db.chat.panelHeight = E.db.chat.panelHeight + E.db.mui.chat.expandPanel
				CH:PositionChats()
				E.db.mui.chat.isExpanded = true
			end
		end
	end)

	ChatButton:SetScript("OnEnter", function(self)
		if GameTooltip:IsForbidden() then
			return
		end

		self:SetAlpha(0.8)
		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT", 0, 6)
		GameTooltip:ClearLines()
		if E.db.mui.chat.isExpanded then
			GameTooltip:AddLine(F.cOption(L["BACK"]), "orange")
		else
			GameTooltip:AddLine(F.cOption(L["Expand the chat"]), "orange")
		end
		GameTooltip:Show()
		if InCombatLockdown() then
			GameTooltip:Hide()
		end
	end)

	ChatButton:SetScript("OnLeave", function(self)
		if E.db.chat.panelBackdrop == "HIDEBOTH" or E.db.chat.panelBackdrop == "ONLYRIGHT" then
			self:SetAlpha(0)
		else
			self:SetAlpha(0.55)
		end
		GameTooltip:Hide()
	end)
end

function module:AddCustomEmojis()
	--Custom Emojis
	local t = "|T" .. I.General.MediaPath .. "textures\\chatEmojis\\%s:16:16|t"

	-- Twitch Emojis
	CH:AddSmiley(":monkaomega:", format(t, "monkaomega"))
	CH:AddSmiley(":salt:", format(t, "salt"))
	CH:AddSmiley(":sadge:", format(t, "sadge"))
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
		f.text:FontTemplate(nil, 20, "SHADOWOUTLINE")
		f.text:SetShadowOffset(-2, 2)
		f.text:SetText(L["Chat Hidden. Click to show"])
		f.text:SetTextColor(F.r, F.g, F.b)
		f.text:SetJustifyH("CENTER")
		f.text:SetJustifyV("MIDDLE")
		f.text:Height(20)
		f.text:Point("CENTER", f, "CENTER", 0, 0)

		f:EnableMouse(true)
		f:RegisterForClicks("AnyUp")
		f:SetScript("OnClick", function(...)
			f:Hide()
		end)

		--toggle
		local function toggleOverlay()
			if
				_G.CommunitiesFrame:GetDisplayMode() == COMMUNITIES_FRAME_DISPLAY_MODES.CHAT and E.db.mui.chat.hideChat
			then
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

function module:UpdateEditboxAnchors()
	for _, name in pairs(CHAT_FRAMES) do
		local frame = _G[name]
		local editbox = frame and frame.editBox
		if not editbox then
			break
		end

		editbox:ClearAllPoints()

		if E.db.datatexts.leftChatPanel and E.db.chat.editBoxPosition == "BELOW_CHAT" then
			editbox:SetAllPoints(LeftChatDataPanel)
		elseif E.db.mui.chat.enable and _G.MERDummyChat and E.db.mui.chat.editBoxPosition == "BELOW_CHAT" then
			editbox:SetAllPoints(MERDummyChat)
		elseif
			E.ActionBars.Initialized
			and E.db.actionbar.bar1.backdrop
			and E.db.mui.chat.editBoxPosition == "EAB_1"
		then
			LA:PositionEditBoxHolder(ElvUI_Bar1)
			editbox:SetAllPoints(MERDummyEditBoxHolder)
		elseif
			E.ActionBars.Initialized
			and E.db.actionbar.bar2.backdrop
			and E.db.mui.chat.editBoxPosition == "EAB_2"
		then
			LA:PositionEditBoxHolder(ElvUI_Bar2)
			editbox:SetAllPoints(MERDummyEditBoxHolder)
		elseif
			E.ActionBars.Initialized
			and E.db.actionbar.bar3.backdrop
			and E.db.mui.chat.editBoxPosition == "EAB_3"
		then
			LA:PositionEditBoxHolder(ElvUI_Bar3)
			editbox:SetAllPoints(MERDummyEditBoxHolder)
		elseif
			E.ActionBars.Initialized
			and E.db.actionbar.bar4.backdrop
			and E.db.mui.chat.editBoxPosition == "EAB_4"
		then
			LA:PositionEditBoxHolder(ElvUI_Bar4)
			editbox:SetAllPoints(MERDummyEditBoxHolder)
		elseif
			E.ActionBars.Initialized
			and E.db.actionbar.bar5.backdrop
			and E.db.mui.chat.editBoxPosition == "EAB_5"
		then
			LA:PositionEditBoxHolder(ElvUI_Bar5)
			editbox:SetAllPoints(MERDummyEditBoxHolder)
		elseif
			E.ActionBars.Initialized
			and E.db.actionbar.bar6.backdrop
			and E.db.mui.chat.editBoxPosition == "EAB_6"
		then
			LA:PositionEditBoxHolder(ElvUI_Bar6, true)
			editbox:SetAllPoints(MERDummyEditBoxHolder)
		else
			editbox:SetAllPoints(LeftChatTab)
		end
	end
end

function module:Initialize()
	module.db = E.db.mui.chat
	if (not module.db and module.db.enable) or not E.private.chat.enable then
		return
	end

	module:StyleVoicePanel()
	module:UpdateSeperators()
	module:CreateChatButtons()
	module:UpdateEditboxAnchors()
	hooksecurefunc(CH, "UpdateEditboxAnchors", module.UpdateEditboxAnchors)
end

MER:RegisterModule(module:GetName())
