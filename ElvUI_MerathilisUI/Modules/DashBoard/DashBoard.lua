local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:NewModule("MERDashBoard", "AceEvent-3.0", "AceHook-3.0")
local DT = E:GetModule("DataTexts")
local LSM = E.LSM or E.Libs.LSM

-- ALL CREDITS TO THE AMAZING BENIK <3

-- Cache global variables
-- Lua functions
local _G = _G
local pairs, unpack = pairs, unpack
-- WoW API / Variables
local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded
--GLOBALS:

local DASH_HEIGHT = 20
local DASH_SPACING = 3
local SPACING = 1
local r, g, b = unpack(E.media.rgbvaluecolor)

-- Dashboards bar frame tables
module.SystemDB = {}

function module:EnableDisableCombat(holder, option)
	local db = E.db.mui.dashboard[option]

	if db.combat then
		holder:RegisterEvent("PLAYER_REGEN_DISABLED")
		holder:RegisterEvent("PLAYER_REGEN_ENABLED")
	else
		holder:UnregisterEvent("PLAYER_REGEN_DISABLED")
		holder:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end
end

function module:UpdateHolderDimensions(holder, option, tableName)
	local db = E.db.mui.dashboard[option]
	holder:SetWidth(db.width)

	for _, frame in pairs(tableName) do
		frame:SetWidth(db.width)
	end
end

function module:ToggleTransparency(holder, option)
	local db = E.db.mui.dashboard[option]

	if not db.backdrop then
		holder.backdrop:SetTemplate("NoBackdrop")
	elseif db.transparency then
		holder.backdrop:SetTemplate("Transparent")
	else
		holder.backdrop:SetTemplate()
	end
end

function module:FontStyle(tableName)
	for _, frame in pairs(tableName) do
		if E.db.mui.dashboard.dashfont.useDTfont then
			frame.Text:FontTemplate(LSM:Fetch('font', E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
		else
			frame.Text:FontTemplate(LSM:Fetch('font', E.db.mui.dashboard.dashfont.dbfont), E.db.mui.dashboard.dashfont.dbfontsize, E.db.mui.dashboard.dashfont.dbfontflags)
		end
	end
end

function module:FontColor(tableName)
	for _, frame in pairs(tableName) do
		if E.db.mui.dashboard.textColor == 1 then
			frame.Text:SetTextColor(MER.r, MER.g, MER.b)
		else
			frame.Text:SetTextColor(MER:unpackColor(E.db.mui.dashboard.customTextColor))
		end
	end
end

function module:BarColor(tableName)
	for _, frame in pairs(tableName) do
		if E.db.mui.dashboard.barColor == 1 then
			frame.Status:SetStatusBarColor(MER.r, MER.g, MER.b)
		else
			frame.Status:SetStatusBarColor(E.db.mui.dashboard.customBarColor.r, E.db.mui.dashboard.customBarColor.g, E.db.mui.dashboard.customBarColor.b)
		end
	end
end

function module:CreateDashboardHolder(holderName, option)
	local db = E.db.mui.dashboard[option]

	local holder = CreateFrame("Frame", holderName, E.UIParent)
	holder:CreateBackdrop("Transparent")
	holder:SetFrameStrata("BACKGROUND")
	holder:SetFrameLevel(5)
	holder.backdrop:Styling()
	holder:Hide()

	holder.bar = CreateFrame("Frame", nil, E.UIParent)
	holder.bar:SetPoint("TOPLEFT", holder, "TOPLEFT", 0, 2)
	holder.bar:SetPoint("BOTTOMRIGHT", holder, "TOPRIGHT", 0, -1)
	MER:CreateGradientFrame(holder.bar, holder:GetWidth(), 2, "Horizontal", r, g, b, .7, 0)

	if db.combat then
		holder:SetScript('OnEvent',function(self, event)
			if event == 'PLAYER_REGEN_DISABLED' then
				E:UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
			elseif event == 'PLAYER_REGEN_ENABLED' then
				E:UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
				self:Show()
			end
		end)
	end
	module:EnableDisableCombat(holder, option)

	E.FrameLocks[holder] = true

	return holder
end

function module:CreateDashboard(name, barHolder, option)
	local bar = CreateFrame('Button', nil, barHolder)
	bar:SetHeight(DASH_HEIGHT)
	bar:SetWidth(E.db.mui.dashboard[option].width or 150)
	bar:SetPoint('TOPLEFT', barHolder, 'TOPLEFT', SPACING, -SPACING)
	bar:EnableMouse(true)

	bar.dummy = CreateFrame('Frame', nil, bar)
	bar.dummy:SetPoint('BOTTOMLEFT', bar, 'BOTTOMLEFT', 2, (E.PixelMode and 2 or 0))
	bar.dummy:SetPoint('BOTTOMRIGHT', bar, 'BOTTOMRIGHT', (E.PixelMode and -24 or -28), 0)
	bar.dummy:SetHeight(E.PixelMode and 3 or 5)

	bar.dummy.dummyStatus = bar.dummy:CreateTexture(nil, 'OVERLAY')
	bar.dummy.dummyStatus:SetInside()
	bar.dummy.dummyStatus:SetTexture(E['media'].normTex)
	bar.dummy.dummyStatus:SetVertexColor(1, 1, 1, .2)

	bar.Status = CreateFrame('StatusBar', nil, bar.dummy)
	bar.Status:SetStatusBarTexture(E['media'].normTex)
	bar.Status:SetInside()

	bar.spark = bar.Status:CreateTexture(nil, 'OVERLAY', nil)
	bar.spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
	bar.spark:SetSize(12, 6)
	bar.spark:SetBlendMode('ADD')
	bar.spark:SetPoint('CENTER', bar.Status:GetStatusBarTexture(), 'RIGHT')

	bar.Text = bar.Status:CreateFontString(nil, 'OVERLAY')
	bar.Text:FontTemplate()
	bar.Text:SetPoint('CENTER', bar, 'CENTER', -10, (E.PixelMode and 1 or 3))
	bar.Text:SetWidth(bar:GetWidth() - 20)
	bar.Text:SetWordWrap(false)

	bar.IconBG = CreateFrame('Button', nil, bar)
	bar.IconBG:SetTemplate('Transparent')
	bar.IconBG:SetSize(E.PixelMode and 18 or 20)
	bar.IconBG:SetPoint('BOTTOMRIGHT', bar, 'BOTTOMRIGHT', (E.PixelMode and -2 or -3), SPACING)

	bar.IconBG.Icon = bar.IconBG:CreateTexture(nil, 'ARTWORK')
	bar.IconBG.Icon:SetInside()
	bar.IconBG.Icon:SetTexCoord(unpack(E.TexCoords))

	return bar
end

function module:Initialize()
	if IsAddOnLoaded("ElvUI_BenikUI") then return end

	module.db = E.db.mui.dashboard
	MER:RegisterDB(self, "dashboard")

	function module:ForUpdateAll()
		module.db = E.db.mui.dashboard
	end
	self:ForUpdateAll()

	module:LoadSystem()
end

MER:RegisterModule(module:GetName())
