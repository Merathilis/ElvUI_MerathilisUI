local MER, E, L, V, P, G = unpack(select(2, ...))
local MERL = MER:NewModule("mUILayout", "AceHook-3.0", "AceEvent-3.0")
local CH = E:GetModule("Chat")
local DT = E:GetModule("DataTexts")
local LO = E:GetModule("Layout")

--Cache global variables
--Lua functions
local _G = _G
local unpack = unpack
--WoW API / Variables
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local GameTooltip = _G["GameTooltip"]
local PlaySound = PlaySound
local SOUNDKIT = SOUNDKIT
local hooksecurefunc = hooksecurefunc
-- GLOBALS:

function MERL:CreateChatButtons()
	if E.db.mui.chat.chatButton ~= true or E.private.chat.enable ~= true then return end

	-- Maybe add option to adjust how much the chat panel expands
	E.db.mui.chat.expandPanel = 150
	E.db.mui.chat.panelHeight = E.db.mui.chat.panelHeight or E.db.chat.panelHeight

	local panelBackdrop = E.db.chat.panelBackdrop
	local ChatButton = CreateFrame("Frame", "mUIChatButton", _G["LeftChatPanel"].backdrop)
	ChatButton:ClearAllPoints()
	ChatButton:SetPoint("TOPLEFT", _G["LeftChatPanel"].backdrop, "TOPLEFT", 4, -8)
	ChatButton:Size(13, 13)
	if E.db.chat.panelBackdrop == "HIDEBOTH" or E.db.chat.panelBackdrop == "LEFT" then
		ChatButton:SetAlpha(0)
	else
		ChatButton:SetAlpha(0.55)
	end
	ChatButton:SetFrameLevel(_G["LeftChatPanel"]:GetFrameLevel() + 5)

	ChatButton.tex = ChatButton:CreateTexture(nil, "OVERLAY")
	ChatButton.tex:SetInside()
	ChatButton.tex:SetTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\chatButton")

	ChatButton:SetScript("OnMouseUp", function (self, btn)
		if InCombatLockdown() then return end
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
		if GameTooltip:IsForbidden() then return end

		self:SetAlpha(0.8)
		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT", 0, 6)
		GameTooltip:ClearLines()
		if E.db.mui.chat.isExpanded then
			GameTooltip:AddLine(MER:cOption(L["BACK"]))
		else
			GameTooltip:AddLine(MER:cOption(L["Expand the chat"]))
		end
		GameTooltip:Show()
		if InCombatLockdown() then GameTooltip:Hide() end
	end)

	ChatButton:SetScript("OnLeave", function(self)
		if E.db.chat.panelBackdrop == "HIDEBOTH" or E.db.chat.panelBackdrop == "LEFT" then
			self:SetAlpha(0)
		else
			self:SetAlpha(0.55)
		end
		GameTooltip:Hide()
	end)

	ChatButton:RegisterEvent("ADDON_LOADED")
	ChatButton:SetScript("OnEvent", function(self, event, addon)
		if event == "ADDON_LOADED" and addon == "ElvUI_OptionsUI" then
			E.Options.args.chat.args.panels.args.panelHeight.set = function(info, value) E.db.chat.panelHeight = value; E.db.mui.chat.panelHeight = value; CH:PositionChats(); end
			self:UnregisterEvent(event)
		end
	end)
end

function MERL:ShadowOverlay()
	-- Based on ncShadow
	if E.db.mui.general.shadowOverlay ~= true then return end

	self.f = CreateFrame("Frame", MER.Title.."ShadowBackground")
	self.f:SetPoint("TOPLEFT")
	self.f:SetPoint("BOTTOMRIGHT")
	self.f:SetFrameLevel(0)
	self.f:SetFrameStrata("BACKGROUND")

	self.f.tex = self.f:CreateTexture()
	self.f.tex:SetTexture([[Interface\Addons\ElvUI_MerathilisUI\media\textures\Overlay]])
	self.f.tex:SetAllPoints(self.f)

	self.f:SetAlpha(0.7)
end

function MERL:CreateSeparators()
	if E.db.mui.chat.seperators ~= true then return end

	--Left Chat Tab Separator
	local ltabseparator = CreateFrame('Frame', 'LeftChatTabSeparator', _G.LeftChatPanel)
	ltabseparator:SetFrameStrata('BACKGROUND')
	ltabseparator:SetFrameLevel(_G.LeftChatPanel:GetFrameLevel() + 2)
	ltabseparator:Size(E.db.chat.panelWidth - 10, 1)
	ltabseparator:Point('TOP', _G.LeftChatPanel, 0, -24)
	ltabseparator:SetTemplate('Transparent')

	--Right Chat Tab Separator
	local rtabseparator = CreateFrame('Frame', 'RightChatTabSeparator', _G.RightChatPanel)
	rtabseparator:SetFrameStrata('BACKGROUND')
	rtabseparator:SetFrameLevel(_G.RightChatPanel:GetFrameLevel() + 2)
	rtabseparator:Size(E.db.chat.panelWidthRight - 10, 1)
	rtabseparator:Point('TOP', _G.RightChatPanel, 0, -24)
	rtabseparator:SetTemplate('Transparent')
end
hooksecurefunc(LO, "CreateChatPanels", MERL.CreateSeparators)

function MERL:ToggleChatPanels()
	local panelHeight = E.db.chat.panelHeight
	local rightHeight = E.db.chat.separateSizes and E.db.chat.panelHeightRight

	_G.LeftChatMover:Height(panelHeight)
	_G.RightChatMover:Height((rightHeight or panelHeight))
end
hooksecurefunc(LO, "ToggleChatPanels", MERL.ToggleChatPanels)

function MERL:RefreshChatMovers()
	local Left = _G.LeftChatPanel:GetPoint()
	local Right = _G.RightChatPanel:GetPoint()

	_G.LeftChatPanel:Point(Left, _G.LeftChatMover, 0, 0)
	_G.RightChatPanel:Point(Right, _G.RightChatMover, 0, 0)
end
hooksecurefunc(LO, "RefreshChatMovers", MERL.RefreshChatMovers)

function MERL:SetDataPanelStyle()
	E.Chat:PositionChats()
end

local f = CreateFrame('Frame')
f:RegisterEvent('PLAYER_ENTERING_WORLD')
f:SetScript('OnEvent', function(self)
	self:UnregisterEvent('PLAYER_ENTERING_WORLD')
	hooksecurefunc(LO, "SetDataPanelStyle", MERL.SetDataPanelStyle)
	LO:SetDataPanelStyle()
end)

function MERL:Initialize()
	self:CreateChatButtons()
	self:ShadowOverlay()
end

MER:RegisterModule(MERL:GetName())
