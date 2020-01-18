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

local PANEL_HEIGHT = 19

function MERL:LoadLayout()
	--Create extra panels
	MERL:CreateExtraDataBarPanels()
end
hooksecurefunc(LO, "Initialize", MERL.LoadLayout)

function MERL:CreateExtraDataBarPanels()
	local chattab = CreateFrame("Frame", "ChatTab_Datatext_Panel", _G.RightChatPanel)
	chattab:SetPoint("TOPRIGHT", _G.RightChatTab, "TOPRIGHT", 0, 0)
	chattab:SetPoint("BOTTOMLEFT", _G.RightChatTab, "BOTTOMLEFT", 0, 0)
	E.FrameLocks["ChatTab_Datatext_Panel"] = true
	DT:RegisterPanel(chattab, 3, "ANCHOR_TOPLEFT", -3, 4)

	local mUIMiddleDTPanel = CreateFrame("Frame", "mUIMiddleDTPanel", E.UIParent)
	E.FrameLocks["mUIMiddleDTPanel"] = true
	DT:RegisterPanel(mUIMiddleDTPanel, 3, "ANCHOR_BOTTOM", 0, 0)
end

function MERL:ToggleChatPanel()
	local db = E.db.mui.datatexts.rightChatTabDatatextPanel

	if db.enable then
		_G.ChatTab_Datatext_Panel:Show()
	else
		_G.ChatTab_Datatext_Panel:Hide()
	end
end

function MERL:MiddleDatatextLayout()
	local db = E.db.mui.datatexts.middle

	if db.enable then
		mUIMiddleDTPanel:Show()
	else
		mUIMiddleDTPanel:Hide()
	end

	if not db.backdrop then
		mUIMiddleDTPanel:SetTemplate("NoBackdrop")
	else
		if db.transparent then
			mUIMiddleDTPanel:SetTemplate("Transparent")
		else
			mUIMiddleDTPanel:SetTemplate("Default", true)
		end
	end
end

function MERL:MiddleDatatextDimensions()
	local db = E.db.mui.datatexts.middle
	mUIMiddleDTPanel:Width(db.width)
	mUIMiddleDTPanel:Height(db.height)
	DT:UpdateAllDimensions()
end

function MERL:ChangeLayout()
	-- Middle DT Panel
	mUIMiddleDTPanel:SetFrameStrata("MEDIUM")
	mUIMiddleDTPanel:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, 2)
	mUIMiddleDTPanel:Width(E.db.mui.datatexts.middle.width or 400)
	mUIMiddleDTPanel:Height(E.db.mui.datatexts.middle.height or PANEL_HEIGHT)
	E:CreateMover(mUIMiddleDTPanel, "mUIMiddleDTPanelMover", L["MerathilisUI Middle DataText"], nil, nil, nil, 'ALL,SOLO,MERATHILISUI', nil, 'mui,modules,datatexts')
end

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
				CH:PositionChat(true)
				E.db.mui.chat.isExpanded = false
			else
				E.db.chat.panelHeight = E.db.chat.panelHeight + E.db.mui.chat.expandPanel
				CH:PositionChat(true)
				E.db.mui.chat.isExpanded = true
			end
		end
	end)

	ChatButton:SetScript("OnEnter", function(self)
		if GameTooltip:IsForbidden() then return end

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
			E.Options.args.chat.args.panels.args.panelHeight.set = function(info, value) E.db.chat.panelHeight = value; E.db.mui.chat.panelHeight = value; CH:PositionChat(true); end
			self:UnregisterEvent(event)
		end
	end)
end

function MERL:regEvents()
	self:ToggleChatPanel()
	self:MiddleDatatextLayout()
	self:MiddleDatatextDimensions()
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

function MERL:Initialize()
	self:ChangeLayout()
	self:regEvents()
	self:CreateChatButtons()
	self:ShadowOverlay()
end

MER:RegisterModule(MERL:GetName())
