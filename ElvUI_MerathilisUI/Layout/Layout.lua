local MER, E, L, V, P, G = unpack(select(2, ...))
local MERL = MER:NewModule("mUILayout", "AceHook-3.0", "AceEvent-3.0")
local MERS = MER:GetModule("muiSkins")
local AB = E:GetModule("ActionBars")
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

--Global variables that we don"t cache, list them here for mikk"s FindGlobals script
-- GLOBALS: RightChatTab, RightChatPanel, ChatTab_Datatext_Panel

local PANEL_HEIGHT = 19
local r, g, b = unpack(E.media.rgbvaluecolor)

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

local function ShowOrHideBar5(bar, button)
	if E.db.actionbar.bar5.enabled == true then
		E.db.actionbar.bar5.enabled = false
	elseif E.db.actionbar.bar5.enabled == false then
		E.db.actionbar.bar5.enabled = true
	end
	AB:UpdateButtonSettings("bar5")
end

local function ShowOrHideBar3(bar, button)
	if E.db.actionbar.bar3.enabled == true then
		E.db.actionbar.bar3.enabled = false
	elseif E.db.actionbar.bar3.enabled == false then
		E.db.actionbar.bar3.enabled = true
	end
	AB:UpdateButtonSettings("bar3")
end

local function MoveButtonBar(button, bar)
	if button == MerathilisUIButton1 then
		if E.db.actionbar.bar5.enabled == true then
			button.tex:SetTexture([[Interface\AddOns\ElvUI\media\textures\MinusButton.blp]])
		else
			button.tex:SetTexture([[Interface\AddOns\ElvUI\media\textures\PlusButton.blp]])
		end
	end

	if button == MerathilisUIButton2 then
		if E.db.actionbar.bar3.enabled == true then
			button.tex:SetTexture([[Interface\AddOns\ElvUI\media\textures\MinusButton.blp]])
		else
			button.tex:SetTexture([[Interface\AddOns\ElvUI\media\textures\PlusButton.blp]])
		end
	end
end

local function UpdateBar5(self, bar)
	if InCombatLockdown() then MER:Print(ERR_NOT_IN_COMBAT) return end
	local button = self

	ShowOrHideBar5(bar, button)
	MoveButtonBar(button, bar)
end

local function UpdateBar3(self, bar)
	if InCombatLockdown() then MER:Print(ERR_NOT_IN_COMBAT) return end
	local button = self

	ShowOrHideBar3(bar, button)
	MoveButtonBar(button, bar)
end

local function ChatPanels_OnEnter(self)
	if GameTooltip:IsForbidden() then return end

	GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT', 0, 4)
	GameTooltip:ClearLines()
	GameTooltip:AddDoubleLine(L["Left Click:"], L["Toggle ActionBar"], 1, 1, 1)
	GameTooltip:AddDoubleLine(L["Right Click"], L["Toggle Middle DT"], 1, 1, 1)
	GameTooltip:Show()
end

local function ChatPanels_OnLeave(self)
	if GameTooltip:IsForbidden() then return end

	GameTooltip:Hide()
end

-- Panels
function MERL:CreatePanels()
	if E.db.mui.general.panels ~= true then return end

	local topPanel = CreateFrame("Frame", MER.Title.."TopPanel", E.UIParent)
	topPanel:SetFrameStrata("BACKGROUND")
	topPanel:SetPoint("TOP", 0, 3)
	topPanel:SetPoint("LEFT", E.UIParent, "LEFT", -8, 0)
	topPanel:SetPoint("RIGHT", E.UIParent, "RIGHT", 8, 0)
	topPanel:SetHeight(15)
	topPanel:SetTemplate("Transparent")
	topPanel:Styling()

	local bottomPanel = CreateFrame("Frame", MER.Title.."BottomPanel", E.UIParent)
	bottomPanel:SetFrameStrata("BACKGROUND")
	bottomPanel:SetPoint("BOTTOM", 0, -3)
	bottomPanel:SetPoint("LEFT", E.UIParent, "LEFT", -8, 0)
	bottomPanel:SetPoint("RIGHT", E.UIParent, "RIGHT", 8, 0)
	bottomPanel:SetHeight(15)
	bottomPanel:SetTemplate("Transparent")
	bottomPanel:Styling()

	local topLeftStyle = CreateFrame("Frame", MER.Title.."TopLeftStyle", E.UIParent)
	topLeftStyle:SetFrameStrata("BACKGROUND")
	topLeftStyle:SetFrameLevel(2)
	topLeftStyle:SetSize(_G.LeftChatPanel:GetWidth(), 4)
	topLeftStyle:SetPoint("TOPLEFT", E.UIParent, "TOPLEFT", 2, -8)
	MERS:SkinPanel(topLeftStyle)

	local bottomLeftSytle = CreateFrame("Frame", MER.Title.."BottomLeftStyle", E.UIParent)
	bottomLeftSytle:SetFrameStrata("BACKGROUND")
	bottomLeftSytle:SetFrameLevel(2)
	bottomLeftSytle:SetSize(_G.LeftChatPanel:GetWidth(), 4)
	bottomLeftSytle:SetPoint("BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 2, 10)
	MERS:SkinPanel(bottomLeftSytle)

	local topRightStyle = CreateFrame("Frame", MER.Title.."TopRightStyle", E.UIParent)
	topRightStyle:SetFrameStrata("BACKGROUND")
	topRightStyle:SetFrameLevel(2)
	topRightStyle:SetSize(_G.LeftChatPanel:GetWidth(), 4)
	topRightStyle:SetPoint("TOPRIGHT", E.UIParent, "TOPRIGHT", -2, -8)
	MERS:SkinPanel(topRightStyle)

	local bottomRightStyle = CreateFrame("Frame", MER.Title.."BottomRightStyle", E.UIParent)
	bottomRightStyle:SetFrameStrata("BACKGROUND")
	bottomRightStyle:SetFrameLevel(2)
	bottomRightStyle:SetSize(_G.LeftChatPanel:GetWidth(), 4)
	bottomRightStyle:SetPoint("BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -2, 10)
	MERS:SkinPanel(bottomRightStyle)

	local MerathilisUIButton1 = CreateFrame("Button", "MerathilisUIButton1", E.UIParent)
	MerathilisUIButton1:RegisterForClicks("AnyUp")
	MerathilisUIButton1:Size(14, 14)
	MerathilisUIButton1:Point("LEFT", bottomLeftSytle, "RIGHT", 2, 0)
	E:GetModule("Skins"):HandleButton(MerathilisUIButton1)

	MerathilisUIButton1.tex = MerathilisUIButton1:CreateTexture(nil, "OVERLAY")
	MerathilisUIButton1.tex:SetInside()
	if E.db.actionbar.bar5.enabled == true then -- double check for login
		MerathilisUIButton1.tex:SetTexture([[Interface\AddOns\ElvUI\media\textures\MinusButton.blp]])
	else
		MerathilisUIButton1.tex:SetTexture([[Interface\AddOns\ElvUI\media\textures\PlusButton.blp]])
	end
	MerathilisUIButton1:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight", "ADD")

	MerathilisUIButton1:SetScript("OnClick", function(self, btn)
		if btn == "LeftButton" then
			UpdateBar5(self, _G["ElvUI_Bar5"])
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
		elseif btn == "RightButton" then
			if E.db.mui.datatexts.middle.enable and mUIMiddleDTPanel:IsShown() then
				mUIMiddleDTPanel:Hide()
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
			else
				mUIMiddleDTPanel:Show()
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
			end
		end
	end)

	MerathilisUIButton1:SetScript("OnEnter", ChatPanels_OnEnter)
	MerathilisUIButton1:SetScript("OnLeave", ChatPanels_OnLeave)

	local MerathilisUIButton2 = CreateFrame("Button", "MerathilisUIButton2", E.UIParent)
	MerathilisUIButton2:RegisterForClicks("AnyUp")
	MerathilisUIButton2:Size(14, 14)
	MerathilisUIButton2:Point("RIGHT", bottomRightStyle, "LEFT", -2, 0)
	E:GetModule("Skins"):HandleButton(MerathilisUIButton2)

	MerathilisUIButton2.tex = MerathilisUIButton2:CreateTexture(nil, "OVERLAY")
	MerathilisUIButton2.tex:SetInside()
	if E.db.actionbar.bar3.enabled == true then -- double check for login
		MerathilisUIButton2.tex:SetTexture([[Interface\AddOns\ElvUI\media\textures\MinusButton.blp]])
	else
		MerathilisUIButton2.tex:SetTexture([[Interface\AddOns\ElvUI\media\textures\PlusButton.blp]])
	end
	MerathilisUIButton2:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight", "ADD")

	MerathilisUIButton2:SetScript("OnClick", function(self, btn)
		if btn == "LeftButton" then
			UpdateBar3(self, _G["ElvUI_Bar3"])
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
		elseif btn == "RightButton" then
			if E.db.mui.datatexts.middle.enable and mUIMiddleDTPanel:IsShown() then
				mUIMiddleDTPanel:Hide()
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
			else
				mUIMiddleDTPanel:Show()
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
			end
		end
	end)

	MerathilisUIButton2:SetScript("OnEnter", ChatPanels_OnEnter)
	MerathilisUIButton2:SetScript("OnLeave", ChatPanels_OnLeave)
end

function MERL:CreateStylePanels()
	if E.db.mui.general.panels ~= true or E.db.mui.general.stylePanels ~= true then return end

	-- Style Background for RaidBuffReminder / Raid Manager
	local TopLeftStylePanel = CreateFrame("Frame", nil, E.UIParent)
	TopLeftStylePanel:SetPoint("TOPLEFT", E.UIParent, "TOPLEFT", 2, -14)
	MER:CreateGradientFrame(TopLeftStylePanel, _G.LeftChatPanel:GetWidth(), 36, "Horizontal", 0, 0, 0, .5, 0)

	local TopLeftStylePanel1 = CreateFrame("Frame", nil, TopLeftStylePanel)
	TopLeftStylePanel1:SetPoint("TOP", TopLeftStylePanel, "BOTTOM")
	MER:CreateGradientFrame(TopLeftStylePanel1, _G.LeftChatPanel:GetWidth(), E.mult, "Horizontal", r, g, b, .7, 0)

	-- Style for the BuffFrame
	local TopRightStylePanel = CreateFrame("Frame", nil, E.UIParent)
	TopRightStylePanel:SetPoint("TOPRIGHT", E.UIParent, "TOPRIGHT", -2, -14)
	MER:CreateGradientFrame(TopRightStylePanel, _G.LeftChatPanel:GetWidth(), 36, "Horizontal", 0, 0, 0, 0, .5)

	local TopRightStylePanel1 = CreateFrame("Frame", nil, TopRightStylePanel)
	TopRightStylePanel1:SetPoint("TOP", TopRightStylePanel, "BOTTOM")
	MER:CreateGradientFrame(TopRightStylePanel1, _G.LeftChatPanel:GetWidth(), E.mult, "Horizontal", r, g, b, 0, .7)

	-- Style under the left chat.
	local BottomLeftStylePanel = CreateFrame("Frame", nil, E.UIParent)
	BottomLeftStylePanel:SetPoint("BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 2, 16)
	MER:CreateGradientFrame(BottomLeftStylePanel, _G.LeftChatPanel:GetWidth(), 28, "Horizontal", 0, 0, 0, .5, 0)

	local BottomLeftStylePanel1 = CreateFrame("Frame", nil, BottomLeftStylePanel)
	BottomLeftStylePanel1:SetPoint("BOTTOM", BottomLeftStylePanel, "TOP")
	MER:CreateGradientFrame(BottomLeftStylePanel1, _G.LeftChatPanel:GetWidth(), E.mult, "Horizontal", r, g, b, .7, 0)

	-- Style under the right chat.
	local BottomRightStylePanel = CreateFrame("Frame", nil, E.UIParent)
	BottomRightStylePanel:SetPoint("BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -2, 16)
	MER:CreateGradientFrame(BottomRightStylePanel, _G.LeftChatPanel:GetWidth(), 28, "Horizontal", 0, 0, 0, 0, .5)

	local BottomRightStylePanel1 = CreateFrame("Frame", nil, BottomRightStylePanel)
	BottomRightStylePanel1:SetPoint("BOTTOM", BottomRightStylePanel, "TOP")
	MER:CreateGradientFrame(BottomRightStylePanel1, _G.LeftChatPanel:GetWidth(), E.mult, "Horizontal", r, g, b, 0, .7)
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
	self:CreatePanels()
	self:CreateStylePanels()
	self:ChangeLayout()
	self:regEvents()
	self:CreateChatButtons()
	self:ShadowOverlay()
end

MER:RegisterModule(MERL:GetName())
