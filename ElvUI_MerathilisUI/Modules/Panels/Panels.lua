local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Panels")
local Style = MER:GetModule("MER_Style")
local WS = W:GetModule("Skins")

local CreateFrame = CreateFrame
local CreateColor = CreateColor
local RAID_CLASS_COLORS = RAID_CLASS_COLORS

local function GetPanelColor()
	local db = E.db.mui.panels
	if db.colorType == "CUSTOM" then
		return db.customColor
	elseif db.colorType == "CLASS" then
		return RAID_CLASS_COLORS[E.myclass]
	end
	return nil -- default white handled below
end

function module:SkinPanel(panel)
	if not panel then
		return
	end

	local color = GetPanelColor()
	local r, g, b = 1, 1, 1
	if color then
		r, g, b = color.r, color.g, color.b
	end

	-- Reuse existing texture (UpdateColors can run often via options)
	local tex = panel.tex
	if not tex then
		tex = panel:CreateTexture(nil, "ARTWORK")
		tex:SetAllPoints()
		tex:SetTexture(E.media.blankTex)
		panel.tex = tex
	end

	tex:SetGradient("VERTICAL", CreateColor(r, g, b, 1), CreateColor(0, 0, 0, 1))
end

local function SetStyleVisibility(style, extra, enabled, extraEnabled)
	if enabled then
		style:Show()
		if extraEnabled then
			extra:Show()
		else
			extra:Hide()
		end
	else
		style:Hide()
		extra:Hide()
	end
end

function module:CreatePanels()
	if self.panelsCreated then
		return
	end

	local db = E.db.mui.panels
	local panelSize = db.panelSize or 427
	local topPanelHeight = db.topPanelHeight or 15
	local bottomPanelHeight = db.bottomPanelHeight or 15

	local topPanel = CreateFrame("Frame", "MER_TopPanel", E.UIParent, "BackdropTemplate")
	topPanel:SetFrameStrata("BACKGROUND")
	topPanel:Point("TOP", 0, 3)
	topPanel:Point("LEFT", E.UIParent, "LEFT", -8, 0)
	topPanel:Point("RIGHT", E.UIParent, "RIGHT", 8, 0)
	topPanel:Height(topPanelHeight)
	topPanel:SetTemplate("Transparent")
	topPanel:EnableMouse(false)
	topPanel:Hide()

	local bottomPanel = CreateFrame("Frame", "MER_BottomPanel", E.UIParent, "BackdropTemplate")
	bottomPanel:SetFrameStrata("BACKGROUND")
	bottomPanel:Point("BOTTOM", 0, -3)
	bottomPanel:Point("LEFT", E.UIParent, "LEFT", -8, 0)
	bottomPanel:Point("RIGHT", E.UIParent, "RIGHT", 8, 0)
	bottomPanel:Height(bottomPanelHeight)
	bottomPanel:SetTemplate("Transparent")
	bottomPanel:EnableMouse(false)
	bottomPanel:Hide()

	-- Top Left
	local topLeftStyle = CreateFrame("Frame", "MER_TopLeftStyle", E.UIParent, "BackdropTemplate")
	topLeftStyle:SetFrameStrata("BACKGROUND")
	topLeftStyle:SetFrameLevel(2)
	topLeftStyle:Size(panelSize, 4)
	topLeftStyle:Point("TOPLEFT", E.UIParent, "TOPLEFT", 2, -8)
	WS:CreateShadow(topLeftStyle)
	topLeftStyle:Hide()

	local topLeftExtra = CreateFrame("Frame", "MER_TopLeftExtraStyle", E.UIParent, "BackdropTemplate")
	topLeftExtra:Point("TOPLEFT", E.UIParent, "TOPLEFT", 2, -14)
	topLeftExtra:Hide()

	local topLeftExtraLine = CreateFrame("Frame", nil, topLeftExtra, "BackdropTemplate")
	topLeftExtraLine:Point("TOP", topLeftExtra, "BOTTOM")
	_G.MER_TopLeftExtraStyle1 = topLeftExtraLine

	-- Bottom Left
	local bottomLeftStyle = CreateFrame("Frame", "MER_BottomLeftStyle", E.UIParent, "BackdropTemplate")
	bottomLeftStyle:SetFrameStrata("BACKGROUND")
	bottomLeftStyle:SetFrameLevel(2)
	bottomLeftStyle:Size(panelSize, 4)
	bottomLeftStyle:Point("BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 2, 10)
	WS:CreateShadow(bottomLeftStyle)
	bottomLeftStyle:Hide()

	local bottomLeftExtra = CreateFrame("Frame", "MER_BottomLeftExtraStyle", E.UIParent, "BackdropTemplate")
	bottomLeftExtra:Point("BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", 2, 16)
	bottomLeftExtra:Hide()

	local bottomLeftExtraLine = CreateFrame("Frame", nil, bottomLeftExtra, "BackdropTemplate")
	bottomLeftExtraLine:Point("BOTTOM", bottomLeftExtra, "TOP")
	_G.MER_BottomLeftStylePanel1 = bottomLeftExtraLine

	-- Top Right
	local topRightStyle = CreateFrame("Frame", "MER_TopRightStyle", E.UIParent, "BackdropTemplate")
	topRightStyle:SetFrameStrata("BACKGROUND")
	topRightStyle:SetFrameLevel(2)
	topRightStyle:Size(panelSize, 4)
	topRightStyle:Point("TOPRIGHT", E.UIParent, "TOPRIGHT", -2, -8)
	WS:CreateShadow(topRightStyle)
	topRightStyle:Hide()

	local topRightExtra = CreateFrame("Frame", "MER_TopRightExtraStyle", E.UIParent, "BackdropTemplate")
	topRightExtra:Point("TOPRIGHT", E.UIParent, "TOPRIGHT", -2, -14)
	topRightExtra:Hide()

	local topRightExtraLine = CreateFrame("Frame", nil, topRightExtra, "BackdropTemplate")
	topRightExtraLine:Point("TOP", topRightExtra, "BOTTOM")
	_G.MER_TopRightStylePanel1 = topRightExtraLine

	-- Bottom Right
	local bottomRightStyle = CreateFrame("Frame", "MER_BottomRightStyle", E.UIParent, "BackdropTemplate")
	bottomRightStyle:SetFrameStrata("BACKGROUND")
	bottomRightStyle:SetFrameLevel(2)
	bottomRightStyle:Size(panelSize, 4)
	bottomRightStyle:Point("BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -2, 10)
	WS:CreateShadow(bottomRightStyle)
	bottomRightStyle:Hide()

	local bottomRightExtra = CreateFrame("Frame", "MER_BottomRightExtraStyle", E.UIParent, "BackdropTemplate")
	bottomRightExtra:Point("BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -2, 16)
	bottomRightExtra:Hide()

	local bottomRightExtraLine = CreateFrame("Frame", nil, bottomRightExtra, "BackdropTemplate")
	bottomRightExtraLine:Point("BOTTOM", bottomRightExtra, "TOP")
	_G.MER_BottomRightStylePanel1 = bottomRightExtraLine

	-- Keep globals for external/profile references (named frames already register them)
	_G.MER_TopPanel = topPanel
	_G.MER_BottomPanel = bottomPanel
	_G.MER_TopLeftStyle = topLeftStyle
	_G.MER_TopLeftExtraStyle = topLeftExtra
	_G.MER_BottomLeftStyle = bottomLeftStyle
	_G.MER_BottomLeftExtraStyle = bottomLeftExtra
	_G.MER_TopRightStyle = topRightStyle
	_G.MER_TopRightExtraStyle = topRightExtra
	_G.MER_BottomRightStyle = bottomRightStyle
	_G.MER_BottomRightExtraStyle = bottomRightExtra

	self.panelsCreated = true

	self:UpdatePanels()
	self:UpdateColors()
	self:Resize()
end

function module:UpdatePanels()
	local db = E.db.mui.panels
	local style = db.stylePanels

	if db.topPanel then
		_G.MER_TopPanel:Show()
	else
		_G.MER_TopPanel:Hide()
	end

	if db.bottomPanel then
		_G.MER_BottomPanel:Show()
	else
		_G.MER_BottomPanel:Hide()
	end

	SetStyleVisibility(_G.MER_TopLeftStyle, _G.MER_TopLeftExtraStyle, style.topLeftPanel, style.topLeftExtraPanel)
	SetStyleVisibility(
		_G.MER_BottomLeftStyle,
		_G.MER_BottomLeftExtraStyle,
		style.bottomLeftPanel,
		style.bottomLeftExtraPanel
	)
	SetStyleVisibility(_G.MER_TopRightStyle, _G.MER_TopRightExtraStyle, style.topRightPanel, style.topRightExtraPanel)
	SetStyleVisibility(
		_G.MER_BottomRightStyle,
		_G.MER_BottomRightExtraStyle,
		style.bottomRightPanel,
		style.bottomRightExtraPanel
	)
end

function module:UpdateColors()
	local db = E.db.mui.panels
	local panelSize = db.panelSize or 427
	local color = GetPanelColor()
	local r, g, b = 1, 1, 1
	if color then
		r, g, b = color.r, color.g, color.b
	end

	self:SkinPanel(_G.MER_TopLeftStyle)
	self:SkinPanel(_G.MER_BottomLeftStyle)
	self:SkinPanel(_G.MER_TopRightStyle)
	self:SkinPanel(_G.MER_BottomRightStyle)

	Style:CreateGradientFrame(_G.MER_TopLeftExtraStyle, panelSize, 36, "Horizontal", 0, 0, 0, 0.5, 0, 0, 0, 0)
	Style:CreateGradientFrame(_G.MER_TopLeftExtraStyle1, panelSize, E.mult, "Horizontal", r, g, b, 0.7, r, g, b, 0)
	Style:CreateGradientFrame(_G.MER_BottomLeftExtraStyle, panelSize, 28, "Horizontal", 0, 0, 0, 0.5, 0, 0, 0, 0)
	Style:CreateGradientFrame(_G.MER_BottomLeftStylePanel1, panelSize, E.mult, "Horizontal", r, g, b, 0.7, r, g, b, 0)
	Style:CreateGradientFrame(_G.MER_TopRightExtraStyle, panelSize, 36, "Horizontal", 0, 0, 0, 0, 0, 0, 0, 0.5)
	Style:CreateGradientFrame(_G.MER_TopRightStylePanel1, panelSize, E.mult, "Horizontal", r, g, b, 0, r, g, b, 0.7)
	Style:CreateGradientFrame(_G.MER_BottomRightExtraStyle, panelSize, 28, "Horizontal", 0, 0, 0, 0, 0, 0, 0, 0.5)
	Style:CreateGradientFrame(_G.MER_BottomRightStylePanel1, panelSize, E.mult, "Horizontal", r, g, b, 0, r, g, b, 0.7)
end

function module:Resize()
	local db = E.db.mui.panels
	local panelSize = db.panelSize or 427
	local topPanelHeight = db.topPanelHeight or 15
	local bottomPanelHeight = db.bottomPanelHeight or 15

	_G.MER_TopPanel:Height(topPanelHeight)
	_G.MER_BottomPanel:Height(bottomPanelHeight)

	_G.MER_TopLeftStyle:Size(panelSize, 4)
	_G.MER_TopLeftExtraStyle:Size(panelSize, 36)
	_G.MER_TopLeftExtraStyle1:Size(panelSize, E.mult)

	_G.MER_BottomLeftStyle:Size(panelSize, 4)
	_G.MER_BottomLeftExtraStyle:Size(panelSize, 28)
	_G.MER_BottomLeftStylePanel1:Size(panelSize, E.mult)

	_G.MER_TopRightStyle:Size(panelSize, 4)
	_G.MER_TopRightExtraStyle:Size(panelSize, 36)
	_G.MER_TopRightStylePanel1:Size(panelSize, E.mult)

	_G.MER_BottomRightStyle:Size(panelSize, 4)
	_G.MER_BottomRightExtraStyle:Size(panelSize, 28)
	_G.MER_BottomRightStylePanel1:Size(panelSize, E.mult)
end

function module:Initialize()
	self:CreatePanels()
end

MER:RegisterModule(module:GetName())
