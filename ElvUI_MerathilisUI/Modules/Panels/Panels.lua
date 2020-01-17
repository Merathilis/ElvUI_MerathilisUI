local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:NewModule("Panels")
local AB = E:GetModule("ActionBars")
local MERS = MER:GetModule("muiSkins")

--Cache global variables
--Lua functions
local _G = _G
local unpack = unpack
--WoW API / Variables
local CreateFrame = CreateFrame
local GameTooltip = GameTooltip
local InCombatLockdown = InCombatLockdown
-- GLOBALS:

local r, g, b = unpack(E.media.rgbvaluecolor)

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

-- Panels
function module:CreatePanels()
	local topPanel = CreateFrame("Frame", "MER_TopPanel", E.UIParent)
	topPanel:SetFrameStrata("BACKGROUND")
	topPanel:SetPoint("TOP", 0, 3)
	topPanel:SetPoint("LEFT", E.UIParent, "LEFT", -8, 0)
	topPanel:SetPoint("RIGHT", E.UIParent, "RIGHT", 8, 0)
	topPanel:SetHeight(15)
	topPanel:SetTemplate("Transparent")
	topPanel:Styling()

	local bottomPanel = CreateFrame("Frame", "MER_BottomPanel", E.UIParent)
	bottomPanel:SetFrameStrata("BACKGROUND")
	bottomPanel:SetPoint("BOTTOM", 0, -3)
	bottomPanel:SetPoint("LEFT", E.UIParent, "LEFT", -8, 0)
	bottomPanel:SetPoint("RIGHT", E.UIParent, "RIGHT", 8, 0)
	bottomPanel:SetHeight(15)
	bottomPanel:SetTemplate("Transparent")
	bottomPanel:Styling()

	local topLeftStyle = CreateFrame("Frame", "MER_TopLeftStyle", E.UIParent)
	topLeftStyle:SetFrameStrata("BACKGROUND")
	topLeftStyle:SetFrameLevel(2)
	topLeftStyle:SetSize(_G.LeftChatPanel:GetWidth(), 4)
	topLeftStyle:SetPoint("TOPLEFT", E.UIParent, "TOPLEFT", 2, -8)
	MERS:SkinPanel(topLeftStyle)
	MER_TopLeftStyle = topLeftStyle
	topLeftStyle:Hide()

	local TopLeftStylePanel = CreateFrame("Frame", "MER_TopLeftExtraStyle", E.UIParent)
	TopLeftStylePanel:SetPoint("TOPLEFT", E.UIParent, "TOPLEFT", 2, -14)
	MER:CreateGradientFrame(TopLeftStylePanel, _G.LeftChatPanel:GetWidth(), 36, "Horizontal", 0, 0, 0, .5, 0)
	MER_TopLeftExtraStyle = TopLeftStylePanel
	TopLeftStylePanel:Hide()

	local TopLeftStylePanel1 = CreateFrame("Frame", nil, TopLeftStylePanel)
	TopLeftStylePanel1:SetPoint("TOP", TopLeftStylePanel, "BOTTOM")
	MER:CreateGradientFrame(TopLeftStylePanel1, _G.LeftChatPanel:GetWidth(), E.mult, "Horizontal", r, g, b, .7, 0)

	local bottomLeftSytle = CreateFrame("Frame", "MER_BottomLeftStyle", E.UIParent)
	bottomLeftSytle:SetFrameStrata("BACKGROUND")
	bottomLeftSytle:SetFrameLevel(2)
	bottomLeftSytle:SetSize(_G.LeftChatPanel:GetWidth(), 4)
	bottomLeftSytle:SetPoint("BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 2, 10)
	MERS:SkinPanel(bottomLeftSytle)
	MER_BottomLeftStyle = bottomLeftSytle
	bottomLeftSytle:Hide()

	local BottomLeftStylePanel = CreateFrame("Frame", "MER_BottomLeftExtraStyle", E.UIParent)
	BottomLeftStylePanel:SetPoint("BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 2, 16)
	MER:CreateGradientFrame(BottomLeftStylePanel, _G.LeftChatPanel:GetWidth(), 28, "Horizontal", 0, 0, 0, .5, 0)
	MER_BottomLeftExtraStyle = BottomLeftStylePanel
	BottomLeftStylePanel:Hide()

	local BottomLeftStylePanel1 = CreateFrame("Frame", nil, BottomLeftStylePanel)
	BottomLeftStylePanel1:SetPoint("BOTTOM", BottomLeftStylePanel, "TOP")
	MER:CreateGradientFrame(BottomLeftStylePanel1, _G.LeftChatPanel:GetWidth(), E.mult, "Horizontal", r, g, b, .7, 0)

	local topRightStyle = CreateFrame("Frame", "MER_TopRightStyle", E.UIParent)
	topRightStyle:SetFrameStrata("BACKGROUND")
	topRightStyle:SetFrameLevel(2)
	topRightStyle:SetSize(_G.LeftChatPanel:GetWidth(), 4)
	topRightStyle:SetPoint("TOPRIGHT", E.UIParent, "TOPRIGHT", -2, -8)
	MERS:SkinPanel(topRightStyle)
	MER_TopRightStyle = topRightStyle
	topRightStyle:Hide()

	local TopRightStylePanel = CreateFrame("Frame", "MER_TopRightExtraStyle", E.UIParent)
	TopRightStylePanel:SetPoint("TOPRIGHT", E.UIParent, "TOPRIGHT", -2, -14)
	MER:CreateGradientFrame(TopRightStylePanel, _G.LeftChatPanel:GetWidth(), 36, "Horizontal", 0, 0, 0, 0, .5)
	MER_TopRightExtraStyle = TopRightStylePanel
	TopRightStylePanel:Hide()

	local TopRightStylePanel1 = CreateFrame("Frame", nil, TopRightStylePanel)
	TopRightStylePanel1:SetPoint("TOP", TopRightStylePanel, "BOTTOM")
	MER:CreateGradientFrame(TopRightStylePanel1, _G.LeftChatPanel:GetWidth(), E.mult, "Horizontal", r, g, b, 0, .7)

	local bottomRightStyle = CreateFrame("Frame", "MER_BottomRightStyle", E.UIParent)
	bottomRightStyle:SetFrameStrata("BACKGROUND")
	bottomRightStyle:SetFrameLevel(2)
	bottomRightStyle:SetSize(_G.LeftChatPanel:GetWidth(), 4)
	bottomRightStyle:SetPoint("BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -2, 10)
	MERS:SkinPanel(bottomRightStyle)
	MER_BottomRightStyle = bottomRightStyle
	bottomRightStyle:Hide()

	local BottomRightStylePanel = CreateFrame("Frame", "MER_BottomRightExtraStyle", E.UIParent)
	BottomRightStylePanel:SetPoint("BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -2, 16)
	MER:CreateGradientFrame(BottomRightStylePanel, _G.LeftChatPanel:GetWidth(), 28, "Horizontal", 0, 0, 0, 0, .5)
	MER_BottomRightExtraStyle = BottomRightStylePanel
	BottomRightStylePanel:Hide()

	local BottomRightStylePanel1 = CreateFrame("Frame", nil, BottomRightStylePanel)
	BottomRightStylePanel1:SetPoint("BOTTOM", BottomRightStylePanel, "TOP")
	MER:CreateGradientFrame(BottomRightStylePanel1, _G.LeftChatPanel:GetWidth(), E.mult, "Horizontal", r, g, b, 0, .7)

	local MerathilisUIButton1 = CreateFrame("Button", "MER_Button1", E.UIParent)
	MerathilisUIButton1:RegisterForClicks("AnyUp")
	MerathilisUIButton1:Size(14, 14)
	MerathilisUIButton1:Point("LEFT", bottomLeftSytle, "RIGHT", 2, 0)
	E:GetModule("Skins"):HandleButton(MerathilisUIButton1)
	MER_Button1 = MerathilisUIButton1

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
	if not E.db.mui.panels.bottomLeftPanel then MerathilisUIButton1:Hide() end

	local MerathilisUIButton2 = CreateFrame("Button", "MER_Button2", E.UIParent)
	MerathilisUIButton2:RegisterForClicks("AnyUp")
	MerathilisUIButton2:Size(14, 14)
	MerathilisUIButton2:Point("RIGHT", bottomRightStyle, "LEFT", -2, 0)
	E:GetModule("Skins"):HandleButton(MerathilisUIButton2)
	MER_Button2 = MerathilisUIButton2

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
	if not E.db.mui.panels.bottomRightPanel then MerathilisUIButton2:Hide() end

	module:UpdatePanels()
end

function module:UpdatePanels()
	if E.db.mui.panels.topLeftPanel then
		MER_TopLeftStyle:Show()
		MER_TopLeftExtraStyle:Show()
	else
		MER_TopLeftStyle:Hide()
		MER_TopLeftExtraStyle:Hide()
	end

	if E.db.mui.panels.bottomLeftPanel then
		MER_BottomLeftStyle:Show()
		MER_BottomLeftExtraStyle:Show()
		MER_Button1:Show()
	else
		MER_BottomLeftStyle:Hide()
		MER_BottomLeftExtraStyle:Hide()
		MER_Button1:Hide()
	end

	if E.db.mui.panels.topRightPanel then
		MER_TopRightStyle:Show()
		MER_TopRightExtraStyle:Show()
	else
		MER_TopRightStyle:Hide()
		MER_TopRightExtraStyle:Hide()
	end

	if E.db.mui.panels.bottomRightPanel then
		MER_BottomRightStyle:Show()
		MER_BottomRightExtraStyle:Show()
		MER_Button2:Show()
	else
		MER_BottomRightStyle:Hide()
		MER_BottomRightExtraStyle:Hide()
		MER_Button2:Hide()
	end
end

function module:Initialize()
	local db = E.db.mui.panels
	MER:RegisterDB(self, "panels")

	self:CreatePanels()

	function module:ForUpdateAll()
		local db = E.db.mui.panels
		self:UpdatePanels()
	end
	self:ForUpdateAll()
end

MER:RegisterModule(module:GetName())
