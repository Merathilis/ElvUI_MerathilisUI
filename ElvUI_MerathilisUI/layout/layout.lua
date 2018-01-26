local MER, E, L, V, P, G = unpack(select(2, ...))
local MERL = E:NewModule("mUILayout", "AceHook-3.0", "AceEvent-3.0")
local MERS = E:GetModule("muiSkins")
local LSM = LibStub("LibSharedMedia-3.0")
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
local BACK = BACK
local PlaySound = PlaySound
--Global variables that we don"t cache, list them here for mikk"s FindGlobals script
-- GLOBALS: RightChatTab, RightChatPanel, ChatTab_Datatext_Panel

local cp = "|cFF00c0fa" -- +
local cm = "|cff9a1212" -- -

local PANEL_HEIGHT = 19;

function MERL:LoadLayout()
	--Create extra panels
	MERL:CreateExtraDataBarPanels()
end
hooksecurefunc(LO, "Initialize", MERL.LoadLayout)

function MERL:CreateExtraDataBarPanels()
	local chattab = CreateFrame("Frame", "ChatTab_Datatext_Panel", RightChatPanel)
	chattab:SetPoint("TOPRIGHT", RightChatTab, "TOPRIGHT", 0, 0)
	chattab:SetPoint("BOTTOMLEFT", RightChatTab, "BOTTOMLEFT", 0, 0)
	E.FrameLocks["ChatTab_Datatext_Panel"] = true
	DT:RegisterPanel(chattab, 3, "ANCHOR_TOPLEFT", -3, 4)

	local mUIMiddleDTPanel = CreateFrame("Frame", "mUIMiddleDTPanel", E.UIParent)
	E.FrameLocks["mUIMiddleDTPanel"] = true
	DT:RegisterPanel(mUIMiddleDTPanel, 3, "ANCHOR_BOTTOM", 0, 0)
end

function MERL:ToggleChatPanel()
	local db = E.db.mui.datatexts.rightChatTabDatatextPanel

	if db.enable then
		ChatTab_Datatext_Panel:Show()
	else
		ChatTab_Datatext_Panel:Hide()
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
	mUIMiddleDTPanel:SetFrameStrata("HIGH")
	mUIMiddleDTPanel:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, 2)
	mUIMiddleDTPanel:Width(E.db.mui.datatexts.middle.width or 400)
	mUIMiddleDTPanel:Height(E.db.mui.datatexts.middle.height or PANEL_HEIGHT)
	E:CreateMover(mUIMiddleDTPanel, "mUIMiddleDTPanelMover", L["MerathilisUI Middle DataText"])
end

function MERL:CreateChatButton()
	if E.db.mui.chat.chatButton ~= true then return end
	local panelBackdrop = E.db.chat.panelBackdrop
	local ChatButton = CreateFrame("Frame", "mUIChatButton", _G["LeftChatPanel"])
	ChatButton:ClearAllPoints()
	ChatButton:Point("TOPLEFT", 3, -5)
	ChatButton:Size(14, 14)
	if E.db.chat.panelBackdrop == "HIDEBOTH" or E.db.chat.panelBackdrop == "LEFT" then
		ChatButton:SetAlpha(0)
	else
		ChatButton:SetAlpha(0.35)
	end
	ChatButton:SetFrameLevel(_G["LeftChatPanel"]:GetFrameLevel() + 5)
 
	ChatButton.tex = ChatButton:CreateTexture(nil, "OVERLAY")
	ChatButton.tex:SetInside()
	ChatButton.tex:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\media\textures\chatButton.blp]])
 
	ChatButton:SetScript("OnMouseUp", function (self, btn)
		if InCombatLockdown() then return end
		if btn == "LeftButton" then
			if E.db.mui.chat.isExpanded then
				E.db.chat.panelHeight = E.db.mui.chat.panelHeight
				E.db.mui.chat.isExpanded = false
				CH:PositionChat(true, true)
			else
				E.db.chat.panelHeight = 400
				CH:PositionChat(true, true)
				E.db.mui.chat.isExpanded = true
			end
		end
	end)
 
	ChatButton:SetScript("OnEnter", function(self)
		self:SetAlpha(0.65)
		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT", 0, 6)
		GameTooltip:ClearLines()
		if E.db.mui.chat.isExpanded then
			GameTooltip:AddLine(MER:cOption(BACK))
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
			self:SetAlpha(0.35)
		end
		GameTooltip:Hide()
	end)
 
	ChatButton:RegisterEvent("PLAYER_LEAVING_WORLD")
	ChatButton:RegisterEvent("ADDON_LOADED")
	ChatButton:SetScript("OnEvent", function(self, event, addon)
		if event == "ADDON_LOADED" and addon == "ElvUI_Config" then
			E.Options.args.chat.args.panels.args.panelHeight.set = function(info, value) E.db.chat.panelHeight = value; E.db.mui.chat.panelHeight = value; E:GetModule("Chat"):PositionChat(true); end
			self:UnregisterEvent(event)
		end
		if event == "PLAYER_LEAVING_WORLD" then
			E.db.chat.panelHeight = E.db.mui.chat.panelHeight or 146
			E.db.mui.chat.isExpanded = false
			CH:PositionChat(true)
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
			button.text:SetText(cm.."-|r")
		else
			button.text:SetText(cp.."+|r")
		end
	end

	if button == MerathilisUIButton2 then
		if E.db.actionbar.bar3.enabled == true then
			button.text:SetText(cm.."-|r")
		else
			button.text:SetText(cp.."+|r")
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

-- Panels
function MERL:CreatePanels()
	if E.db.mui.general.panels then
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
		topLeftStyle:SetSize(E.screenwidth*2/9, 4)
		topLeftStyle:SetPoint("TOPLEFT", E.UIParent, "TOPLEFT", 10, -10)
		MERS:SkinPanel(topLeftStyle)

		local topRightStyle = CreateFrame("Frame", MER.Title.."TopRightStyle", E.UIParent)
		topRightStyle:SetFrameStrata("BACKGROUND")
		topRightStyle:SetFrameLevel(2)
		topRightStyle:SetSize(E.screenwidth*2/9, 4)
		topRightStyle:SetPoint("TOPRIGHT", E.UIParent, "TOPRIGHT", -10, -10)
		MERS:SkinPanel(topRightStyle)

		local bottomLeftSytle = CreateFrame("Frame", MER.Title.."BottomLeftStyle", E.UIParent)
		bottomLeftSytle:SetFrameStrata("BACKGROUND")
		bottomLeftSytle:SetFrameLevel(2)
		bottomLeftSytle:SetSize(E.screenwidth*2/9, 4)
		bottomLeftSytle:SetPoint("BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 10, 10)
		MERS:SkinPanel(bottomLeftSytle)

		local bottomRightStyle = CreateFrame("Frame", MER.Title.."BottomRightStyle", E.UIParent)
		bottomRightStyle:SetFrameStrata("BACKGROUND")
		bottomRightStyle:SetFrameLevel(2)
		bottomRightStyle:SetSize(E.screenwidth*2/9, 4)
		bottomRightStyle:SetPoint("BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -10, 10)
		MERS:SkinPanel(bottomRightStyle)

		local MerathilisUIButton1 = CreateFrame("Button", "MerathilisUIButton1", E.UIParent)
		MerathilisUIButton1:SetTemplate("Default", true)
		MerathilisUIButton1:RegisterForClicks("AnyUp")
		MerathilisUIButton1:Size(12, 12)
		MerathilisUIButton1:Point("LEFT", bottomLeftSytle, "RIGHT", 2, 0)
		MerathilisUIButton1:StyleButton()

		MerathilisUIButton1.text = MerathilisUIButton1:CreateFontString(nil, "OVERLAY")
		MerathilisUIButton1.text:SetFont(E["media"].normFont, 11)
		MerathilisUIButton1.text:Point("CENTER", 1, 0)
		if E.db.actionbar.bar5.enabled == true then -- double check for login
			MerathilisUIButton1.text:SetText(cm.."-|r")
		else
			MerathilisUIButton1.text:SetText(cp.."+|r")
		end

		MerathilisUIButton1:SetScript("OnClick", function(self, btn)
			if btn == "LeftButton" then
				UpdateBar5(self, _G["ElvUI_Bar5"])
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
			end
		end)

		local MerathilisUIButton2 = CreateFrame("Button", "MerathilisUIButton2", E.UIParent)
		MerathilisUIButton2:SetTemplate("Default", true)
		MerathilisUIButton2:RegisterForClicks("AnyUp")
		MerathilisUIButton2:Size(12, 12)
		MerathilisUIButton2:Point("RIGHT", bottomRightStyle, "LEFT", -2, 0)
		MerathilisUIButton2:StyleButton()

		MerathilisUIButton2.text = MerathilisUIButton2:CreateFontString(nil, "OVERLAY")
		MerathilisUIButton2.text:SetFont(E["media"].normFont, 11)
		MerathilisUIButton2.text:Point("CENTER", 0, 0)
		if E.db.actionbar.bar3.enabled == true then -- double check for login
			MerathilisUIButton2.text:SetText(cm.."-|r")
		else
			MerathilisUIButton2.text:SetText(cp.."+|r")
		end

		MerathilisUIButton2:SetScript("OnClick", function(self, btn)
			if btn == "LeftButton" then
				UpdateBar3(self, _G["ElvUI_Bar3"])
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
			end
		end)
	end
end

function MERL:regEvents()
	self:ToggleChatPanel()
	self:MiddleDatatextLayout()
	self:MiddleDatatextDimensions()
end

function MERL:Initialize()
	self:CreatePanels()
	self:ChangeLayout()
	self:regEvents()
	self:CreateChatButton()
end

local function InitializeCallback()
	MERL:Initialize()
end

E:RegisterModule(MERL:GetName(), InitializeCallback)