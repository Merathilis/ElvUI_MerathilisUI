local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Panels')
local AB = E:GetModule('ActionBars')
local MERS = MER:GetModule('MER_Skins')

--Cache global variables
--Lua functions
local _G = _G
local unpack = unpack
--WoW API / Variables
local CreateFrame = CreateFrame
local GameTooltip = GameTooltip
local InCombatLockdown = InCombatLockdown
-- GLOBALS:

function module:SkinPanel(panel)
	local color = {r = 1, g = 1, b = 1}
	if E.db.mui.panels.colorType == "CUSTOM" then
		color = E.db.mui.panels.customColor
	elseif E.db.mui.panels.colorType == "CLASS" then
		color = RAID_CLASS_COLORS[E.myclass]
	end

	panel.tex = panel:CreateTexture(nil, "ARTWORK")
	panel.tex:SetAllPoints()
	panel.tex:SetTexture(E.media.blankTex)
	panel.tex:SetGradient("VERTICAL", color.r, color.g, color.b)
end

-- Style Panels
function module:CreatePanels()
	local panelSize = E.db.mui.panels.panelSize or 427
	local topPanelHeight = E.db.mui.panels.topPanelHeight or 15
	local bottomPanelHeight = E.db.mui.panels.bottomPanelHeight or 15

	local topPanel = CreateFrame("Frame", "MER_TopPanel", E.UIParent, 'BackdropTemplate')
	topPanel:SetFrameStrata("BACKGROUND")
	topPanel:Point("TOP", 0, 3)
	topPanel:Point("LEFT", E.UIParent, "LEFT", -8, 0)
	topPanel:Point("RIGHT", E.UIParent, "RIGHT", 8, 0)
	topPanel:Height(topPanelHeight)
	topPanel:SetTemplate("Transparent")
	topPanel:Styling()
	topPanel:EnableMouse(false)
	MER_TopPanel = topPanel
	topPanel:Hide()

	local bottomPanel = CreateFrame("Frame", "MER_BottomPanel", E.UIParent, 'BackdropTemplate')
	bottomPanel:SetFrameStrata("BACKGROUND")
	bottomPanel:Point("BOTTOM", 0, -3)
	bottomPanel:Point("LEFT", E.UIParent, "LEFT", -8, 0)
	bottomPanel:Point("RIGHT", E.UIParent, "RIGHT", 8, 0)
	bottomPanel:Height(bottomPanelHeight)
	bottomPanel:SetTemplate("Transparent")
	bottomPanel:Styling()
	bottomPanel:EnableMouse(false)
	MER_BottomPanel = bottomPanel
	bottomPanel:Hide()

	local topLeftStyle = CreateFrame("Frame", "MER_TopLeftStyle", E.UIParent, 'BackdropTemplate')
	topLeftStyle:SetFrameStrata("BACKGROUND")
	topLeftStyle:SetFrameLevel(2)
	topLeftStyle:Size(panelSize, 4)
	topLeftStyle:Point("TOPLEFT", E.UIParent, "TOPLEFT", 2, -8)
	MER_TopLeftStyle = topLeftStyle
	MER:CreateShadow(topLeftStyle)
	topLeftStyle:Hide(topLeftStyle)

	local TopLeftStylePanel = CreateFrame("Frame", "MER_TopLeftExtraStyle", E.UIParent, 'BackdropTemplate')
	TopLeftStylePanel:Point("TOPLEFT", E.UIParent, "TOPLEFT", 2, -14)
	MER_TopLeftExtraStyle = TopLeftStylePanel
	TopLeftStylePanel:Hide()

	local TopLeftStylePanel1 = CreateFrame("Frame", nil, TopLeftStylePanel, 'BackdropTemplate')
	TopLeftStylePanel1:Point("TOP", TopLeftStylePanel, "BOTTOM")
	MER_TopLeftExtraStyle1 = TopLeftStylePanel1

	local bottomLeftSytle = CreateFrame("Frame", "MER_BottomLeftStyle", E.UIParent, 'BackdropTemplate')
	bottomLeftSytle:SetFrameStrata("BACKGROUND")
	bottomLeftSytle:SetFrameLevel(2)
	bottomLeftSytle:Size(panelSize, 4)
	bottomLeftSytle:Point("BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 2, 10)
	MER_BottomLeftStyle = bottomLeftSytle
	MER:CreateShadow(bottomLeftSytle)
	bottomLeftSytle:Hide()

	local BottomLeftStylePanel = CreateFrame("Frame", "MER_BottomLeftExtraStyle", E.UIParent, 'BackdropTemplate')
	BottomLeftStylePanel:Point("BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 2, 16)
	MER_BottomLeftExtraStyle = BottomLeftStylePanel
	BottomLeftStylePanel:Hide()

	local BottomLeftStylePanel1 = CreateFrame("Frame", nil, BottomLeftStylePanel, 'BackdropTemplate')
	BottomLeftStylePanel1:Point("BOTTOM", BottomLeftStylePanel, "TOP")
	MER_BottomLeftStylePanel1 = BottomLeftStylePanel1

	local topRightStyle = CreateFrame("Frame", "MER_TopRightStyle", E.UIParent, 'BackdropTemplate')
	topRightStyle:SetFrameStrata("BACKGROUND")
	topRightStyle:SetFrameLevel(2)
	topRightStyle:Size(panelSize, 4)
	topRightStyle:Point("TOPRIGHT", E.UIParent, "TOPRIGHT", -2, -8)
	MER_TopRightStyle = topRightStyle
	MER:CreateShadow(topRightStyle)
	topRightStyle:Hide()

	local TopRightStylePanel = CreateFrame("Frame", "MER_TopRightExtraStyle", E.UIParent, 'BackdropTemplate')
	TopRightStylePanel:Point("TOPRIGHT", E.UIParent, "TOPRIGHT", -2, -14)
	MER_TopRightExtraStyle = TopRightStylePanel
	TopRightStylePanel:Hide()

	local TopRightStylePanel1 = CreateFrame("Frame", nil, TopRightStylePanel, 'BackdropTemplate')
	TopRightStylePanel1:Point("TOP", TopRightStylePanel, "BOTTOM")
	MER_TopRightStylePanel1 = TopRightStylePanel1

	local bottomRightStyle = CreateFrame("Frame", "MER_BottomRightStyle", E.UIParent, 'BackdropTemplate')
	bottomRightStyle:SetFrameStrata("BACKGROUND")
	bottomRightStyle:SetFrameLevel(2)
	bottomRightStyle:Size(panelSize, 4)
	bottomRightStyle:Point("BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -2, 10)
	MER_BottomRightStyle = bottomRightStyle
	MER:CreateShadow(bottomRightStyle)
	bottomRightStyle:Hide()

	local BottomRightStylePanel = CreateFrame("Frame", "MER_BottomRightExtraStyle", E.UIParent, 'BackdropTemplate')
	BottomRightStylePanel:Point("BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -2, 16)
	MER_BottomRightExtraStyle = BottomRightStylePanel
	BottomRightStylePanel:Hide()

	local BottomRightStylePanel1 = CreateFrame("Frame", nil, BottomRightStylePanel, 'BackdropTemplate')
	BottomRightStylePanel1:Point("BOTTOM", BottomRightStylePanel, "TOP")
	MER_BottomRightStylePanel1 = BottomRightStylePanel1

	module:UpdatePanels()
	module:UpdateColors()
	module:Resize()
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

function module:UpdateColors()
	local panelSize = E.db.mui.panels.panelSize or 427
	local topPanelHeight = E.db.mui.panels.topPanelHeight or 15
	local bottomPanelHeight = E.db.mui.panels.bottomPanelHeight or 15

	local color = {r = 1, g = 1, b = 1}
	if E.db.mui.panels.colorType == "CUSTOM" then
		color = E.db.mui.panels.customColor
	elseif E.db.mui.panels.colorType == "CLASS" then
		color = RAID_CLASS_COLORS[E.myclass]
	end

	module:SkinPanel(MER_TopLeftStyle)
	module:SkinPanel(MER_BottomLeftStyle)
	module:SkinPanel(MER_TopRightStyle)
	module:SkinPanel(MER_BottomRightStyle)

	MER:CreateGradientFrame(MER_TopLeftExtraStyle, panelSize, 36, "Horizontal", 0, 0, 0, .5, 0)
	MER:CreateGradientFrame(MER_TopLeftExtraStyle1, panelSize, E.mult, "Horizontal", color.r, color.g, color.b, .7, 0)
	MER:CreateGradientFrame(MER_BottomLeftExtraStyle, panelSize, 28, "Horizontal", 0, 0, 0, .5, 0)
	MER:CreateGradientFrame(MER_BottomLeftStylePanel1, panelSize, E.mult, "Horizontal", color.r, color.g, color.b, .7, 0)
	MER:CreateGradientFrame(MER_TopRightExtraStyle, panelSize, 36, "Horizontal", 0, 0, 0, 0, .5)
	MER:CreateGradientFrame(MER_TopRightStylePanel1, panelSize, E.mult, "Horizontal", color.r, color.g, color.b, 0, .7)
	MER:CreateGradientFrame(MER_BottomRightExtraStyle, panelSize, 28, "Horizontal", 0, 0, 0, 0, .5)
	MER:CreateGradientFrame(MER_BottomRightStylePanel1, panelSize, E.mult, "Horizontal", color.r, color.g, color.b, 0, .7)
end

function module:Resize()
	local panelSize = E.db.mui.panels.panelSize or 427
	local topPanelHeight = E.db.mui.panels.topPanelHeight or 15
	local bottomPanelHeight = E.db.mui.panels.bottomPanelHeight or 15

	MER_TopPanel:Height(topPanelHeight)
	MER_BottomPanel:Height(bottomPanelHeight)

	MER_TopLeftStyle:Size(panelSize, 4)
	MER_TopLeftExtraStyle:Size(panelSize, 36)
	MER_TopLeftExtraStyle1:Size(panelSize, E.mult)

	MER_BottomLeftStyle:Size(panelSize, 4)
	MER_BottomLeftExtraStyle:Size(panelSize, 28)
	MER_BottomLeftStylePanel1:Size(panelSize, E.mult)

	MER_TopRightStyle:Size(panelSize, 4)
	MER_TopRightExtraStyle:Size(panelSize, 36)
	MER_TopRightStylePanel1:Size(panelSize, E.mult)

	MER_BottomRightStyle:Size(panelSize, 4)
	MER_BottomRightExtraStyle:Size(panelSize, 28)
	MER_BottomRightStylePanel1:Size(panelSize, E.mult)
end

function module:Initialize()
	local db = E.db.mui.panels

	self:CreatePanels()
	self:Resize()

	function module:ForUpdateAll()
		local db = E.db.mui.panels
		self:UpdatePanels()
		self:Resize()
	end
	self:ForUpdateAll()
end

MER:RegisterModule(module:GetName())
