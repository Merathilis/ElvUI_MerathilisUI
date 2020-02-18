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

-- Style Panels
function module:CreatePanels()
	local topPanel = CreateFrame("Frame", "MER_TopPanel", E.UIParent)
	topPanel:SetFrameStrata("BACKGROUND")
	topPanel:SetPoint("TOP", 0, 3)
	topPanel:SetPoint("LEFT", E.UIParent, "LEFT", -8, 0)
	topPanel:SetPoint("RIGHT", E.UIParent, "RIGHT", 8, 0)
	topPanel:SetHeight(15)
	topPanel:SetTemplate("Transparent")
	topPanel:Styling()
	MER_TopPanel = topPanel
	topPanel:Hide()

	local bottomPanel = CreateFrame("Frame", "MER_BottomPanel", E.UIParent)
	bottomPanel:SetFrameStrata("BACKGROUND")
	bottomPanel:SetPoint("BOTTOM", 0, -3)
	bottomPanel:SetPoint("LEFT", E.UIParent, "LEFT", -8, 0)
	bottomPanel:SetPoint("RIGHT", E.UIParent, "RIGHT", 8, 0)
	bottomPanel:SetHeight(15)
	bottomPanel:SetTemplate("Transparent")
	bottomPanel:Styling()
	MER_BottomPanel = bottomPanel
	bottomPanel:Hide()

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

	module:UpdatePanels()

end

function module:UpdatePanels()
	if E.db.mui.panels.topPanel then
		MER_TopPanel:Show()
	else
		MER_TopPanel:Hide()
	end

	if E.db.mui.panels.bottomPanel then
		MER_BottomPanel:Show()
	else
		MER_BottomPanel:Hide()
	end

	if E.db.mui.panels.stylePanels.topLeftPanel and E.db.mui.panels.stylePanels.topLeftExtraPanel then
		MER_TopLeftStyle:Show()
		MER_TopLeftExtraStyle:Show()
	elseif E.db.mui.panels.stylePanels.topLeftPanel and not E.db.mui.panels.stylePanels.topLeftExtraPanel then
		MER_TopLeftStyle:Show()
		MER_TopLeftExtraStyle:Hide()
	else
		MER_TopLeftStyle:Hide()
		MER_TopLeftExtraStyle:Hide()
	end

	if E.db.mui.panels.stylePanels.bottomLeftPanel and E.db.mui.panels.stylePanels.bottomLeftExtraPanel then
		MER_BottomLeftStyle:Show()
		MER_BottomLeftExtraStyle:Show()
	elseif E.db.mui.panels.stylePanels.bottomLeftPanel and not E.db.mui.panels.stylePanels.bottomLeftExtraPanel then
		MER_BottomLeftStyle:Show()
		MER_BottomLeftExtraStyle:Hide()
	else
		MER_BottomLeftStyle:Hide()
		MER_BottomLeftExtraStyle:Hide()
	end

	if E.db.mui.panels.stylePanels.topRightPanel and E.db.mui.panels.stylePanels.topRightExtraPanel then
		MER_TopRightStyle:Show()
		MER_TopRightExtraStyle:Show()
	elseif E.db.mui.panels.stylePanels.topRightPanel and not E.db.mui.panels.stylePanels.topRightExtraPanel then
		MER_TopRightStyle:Show()
		MER_TopRightExtraStyle:Hide()
	else
		MER_TopRightStyle:Hide()
		MER_TopRightExtraStyle:Hide()
	end

	if E.db.mui.panels.stylePanels.bottomRightPanel and E.db.mui.panels.stylePanels.bottomRightExtraPanel then
		MER_BottomRightStyle:Show()
		MER_BottomRightExtraStyle:Show()
	elseif E.db.mui.panels.stylePanels.bottomRightPanel and not E.db.mui.panels.stylePanels.bottomRightExtraPanel then
		MER_BottomRightStyle:Show()
		MER_BottomRightExtraStyle:Hide()
	else
		MER_BottomRightStyle:Hide()
		MER_BottomRightExtraStyle:Hide()
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
