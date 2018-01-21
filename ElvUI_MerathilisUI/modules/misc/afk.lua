local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local AFK = E:GetModule("AFK")

-- Cache global variables
-- Lua Variables
local tonumber = tonumber
local format = string.format
-- WoW API / Variables
local CreateFrame = CreateFrame
local GetGameTime = GetGameTime
local GetScreenWidth, GetScreenHeight = GetScreenWidth, GetScreenHeight
local GetGuildInfo = GetGuildInfo
local IsAddOnLoaded = IsAddOnLoaded
local IsInGuild = IsInGuild
local date = date

local function Player_Model(self)
	self:ClearModel()
	self:SetUnit("player")
	self:SetFacing(1)
	self:SetCamDistanceScale(8)
	self:SetAlpha(1)
	self:SetAnimation(71)
	UIFrameFadeIn(self, 1, self:GetAlpha(), 1)
end

-- Create Time
local function createTime()
	local hour, hour24, minute, ampm = tonumber(date("%I")), tonumber(date("%H")), tonumber(date("%M")), date("%p"):lower()
	local sHour, sMinute = GetGameTime()

	local localTime = format("|cffb3b3b3%s|r %d|cFF00c0fa:|r%02d|cffb3b3b3%s|r", TIMEMANAGER_TOOLTIP_LOCALTIME, hour, minute, ampm)
	local localTime24 = format("|cffb3b3b3%s|r %02d|cFF00c0fa:|r%02d", TIMEMANAGER_TOOLTIP_LOCALTIME, hour24, minute)
	local realmTime = format("|cffb3b3b3%s|r %d|cFF00c0fa:|r%02d|cffb3b3b3%s|r", TIMEMANAGER_TOOLTIP_REALMTIME, sHour, sMinute, ampm)
	local realmTime24 = format("|cffb3b3b3%s|r %02d|cFF00c0fa:|r%02d", TIMEMANAGER_TOOLTIP_REALMTIME, sHour, sMinute)

	if E.db.datatexts.localtime then
		if E.db.datatexts.time24 then
			return localTime24
		else
			return localTime
		end
	else
		if E.db.datatexts.time24 then
			return realmTime24
		else
			return realmTime
		end
	end
end

AFK.mUISetAFK = AFK.SetAFK
function AFK:SetAFK(status)
	self:mUISetAFK(status)

	if(status) then
		if(IsInGuild()) then
			local guildName = GetGuildInfo("player")
			self.AFKMode.bottomPanel.guild:SetText("|cFF00c0fa<".. guildName ..">|r")
		else
			self.AFKMode.bottomPanel.guild:SetText(L["No Guild"])
		end
	end
end


AFK.UpdateTimermUI = AFK.UpdateTimer
function AFK:UpdateTimer()
	self:UpdateTimermUI()

	local createdTime = createTime()

	-- Set time
	self.AFKMode.topPanel.time:SetFormattedText(createdTime)
end

AFK.InitializemUIAFK = AFK.Initialize
function AFK:Initialize()
	if E.db.general.afk ~= true or E.db.mui.general.AFK ~= true then return end
	self:InitializemUIAFK()

	-- Hide ElvUI Elements
	self.AFKMode.bottom:Hide() -- Bottom panel

	-- Bottom Panel
	self.AFKMode.bottomPanel = CreateFrame("Frame", nil, self.AFKMode)
	self.AFKMode.bottomPanel:SetFrameLevel(0)
	self.AFKMode.bottomPanel:Point("BOTTOM", self.AFKMode, "BOTTOM", 0, -E.Border)
	self.AFKMode.bottomPanel:Width(GetScreenWidth() + (E.Border*2))
	self.AFKMode.bottomPanel:Height(GetScreenHeight() * (1 / 10))
	MERS:CreateBD(self.AFKMode.bottomPanel, .5)
	self.AFKMode.bottomPanel:Styling()

	self.AFKMode.bottomPanel.ignoreFrameTemplates = true
	self.AFKMode.bottomPanel.ignoreBackdropColors = true
	E["frames"][self.AFKMode.bottomPanel] = true

	-- Bottom Panel Style
	self.AFKMode.bottomPanel.topLeftStyle = CreateFrame("Frame", nil, self.AFKMode)
	self.AFKMode.bottomPanel.topLeftStyle:SetFrameLevel(2)
	self.AFKMode.bottomPanel.topLeftStyle:Point("TOPLEFT", self.AFKMode.bottomPanel, "TOPLEFT", 10, 2)
	self.AFKMode.bottomPanel.topLeftStyle:SetSize(E.screenwidth*2/9, 4)
	MERS:SkinPanel(self.AFKMode.bottomPanel.topLeftStyle)

	self.AFKMode.bottomPanel.topRightStyle = CreateFrame("Frame", nil, self.AFKMode)
	self.AFKMode.bottomPanel.topRightStyle:SetFrameLevel(2)
	self.AFKMode.bottomPanel.topRightStyle:Point("TOPRIGHT", self.AFKMode.bottomPanel, "TOPRIGHT", -10, 2)
	self.AFKMode.bottomPanel.topRightStyle:SetSize(E.screenwidth*2/9, 4)
	MERS:SkinPanel(self.AFKMode.bottomPanel.topRightStyle)

	-- Bottom AFK Title
	self.AFKMode.bottomPanel.AFKtitle = self.AFKMode.bottomPanel:CreateFontString(nil, "OVERLAY")
	self.AFKMode.bottomPanel.AFKtitle:FontTemplate(nil, 20)
	self.AFKMode.bottomPanel.AFKtitle:SetText("|cFF00c0fa"..L["Are you still there? ... Hello?"].."|r")
	self.AFKMode.bottomPanel.AFKtitle:SetPoint("BOTTOM", self.AFKMode.bottomPanel, "BOTTOM", 0, 10)

	local className = E.myclass
	self.AFKMode.bottomPanel.faction = self.AFKMode.bottomPanel:CreateTexture(nil, "OVERLAY")
	self.AFKMode.bottomPanel.faction:SetPoint("RIGHT", self.AFKMode.bottomPanel, "LEFT", 90, 10)
	self.AFKMode.bottomPanel.faction:SetTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\classIcons\\CLASS-"..className)
	self.AFKMode.bottomPanel.faction:SetSize(80, 80)

	-- Bottom Player Name
	self.AFKMode.bottomPanel.name = self.AFKMode.bottomPanel:CreateFontString(nil, "OVERLAY")
	self.AFKMode.bottomPanel.name:FontTemplate(nil, 22)
	self.AFKMode.bottomPanel.name:SetFormattedText("%s", E.myname)
	self.AFKMode.bottomPanel.name:SetPoint("LEFT", self.AFKMode.bottomPanel.faction, "RIGHT", 0, 10)
	self.AFKMode.bottomPanel.name:SetTextColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)

	-- Bottom Guild Name
	self.AFKMode.bottomPanel.guild = self.AFKMode.bottomPanel:CreateFontString(nil, "OVERLAY")
	self.AFKMode.bottomPanel.guild:FontTemplate(nil, 16)
	self.AFKMode.bottomPanel.guild:Point("TOPLEFT", self.AFKMode.bottomPanel.name, "BOTTOMLEFT", -5, -6)
	self.AFKMode.bottomPanel.guild:SetText(L["No Guild"])

	-- Top Panel
	self.AFKMode.topPanel = CreateFrame("Frame", nil, self.AFKMode)
	self.AFKMode.topPanel:SetFrameLevel(0)
	self.AFKMode.topPanel:Point("TOP", self.AFKMode, "TOP", 0, E.Border)
	self.AFKMode.topPanel:Width(GetScreenWidth() + (E.Border*2))
	self.AFKMode.topPanel:Height(GetScreenHeight() * (1 / 10))
	MERS:CreateBD(self.AFKMode.topPanel, .5)
	self.AFKMode.topPanel:Styling()

	self.AFKMode.topPanel.ignoreFrameTemplates = true
	self.AFKMode.topPanel.ignoreBackdropColors = true
	E["frames"][self.AFKMode.topPanel] = true

	-- Top Panel Style
	self.AFKMode.topPanel.topLeftStyle = CreateFrame("Frame", nil, self.AFKMode)
	self.AFKMode.topPanel.topLeftStyle:SetFrameLevel(2)
	self.AFKMode.topPanel.topLeftStyle:Point("BOTTOMLEFT", self.AFKMode.topPanel, "BOTTOMLEFT", 10, -2)
	self.AFKMode.topPanel.topLeftStyle:SetSize(E.screenwidth*2/9, 4)
	MERS:SkinPanel(self.AFKMode.topPanel.topLeftStyle)

	self.AFKMode.topPanel.topRightStyle = CreateFrame("Frame", nil, self.AFKMode)
	self.AFKMode.topPanel.topRightStyle:SetFrameLevel(2)
	self.AFKMode.topPanel.topRightStyle:Point("BOTTOMRIGHT", self.AFKMode.topPanel, "BOTTOMRIGHT", -10, -2)
	self.AFKMode.topPanel.topRightStyle:SetSize(E.screenwidth*2/9, 4)
	MERS:SkinPanel(self.AFKMode.topPanel.topRightStyle)

	-- ElvUI Logo
	self.AFKMode.bottom.logo:ClearAllPoints()
	self.AFKMode.bottom.logo:SetParent(self.AFKMode.topPanel)
	self.AFKMode.bottom.logo:Point("LEFT", self.AFKMode.topPanel, "LEFT", 25, 8)
	self.AFKMode.bottom.logo:SetSize(120, 55)

	-- ElvUI Version
	self.AFKMode.topPanel.eversion = self.AFKMode.topPanel:CreateFontString(nil, "OVERLAY")
	self.AFKMode.topPanel.eversion:FontTemplate(nil, 10)
	self.AFKMode.topPanel.eversion:SetText("|cFF00c0fa"..E.version.."|r")
	self.AFKMode.topPanel.eversion:SetPoint("TOP", self.AFKMode.bottom.logo, "BOTTOM")
	self.AFKMode.topPanel.eversion:SetTextColor(0.7, 0.7, 0.7)

	-- MerathilisUI Logo
	self.AFKMode.topPanel.mUILogo = self.AFKMode.topPanel:CreateTexture(nil, "OVERLAY")
	self.AFKMode.topPanel.mUILogo:SetTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\mUI1.tga")
	self.AFKMode.topPanel.mUILogo:SetPoint("RIGHT", self.AFKMode.topPanel, "RIGHT", -25, 8)
	self.AFKMode.topPanel.mUILogo:Size(75, 80)

	-- MerathilisUI Version
	self.AFKMode.topPanel.mversion = self.AFKMode.topPanel:CreateFontString(nil, "OVERLAY")
	self.AFKMode.topPanel.mversion:FontTemplate(nil, 10)
	self.AFKMode.topPanel.mversion:SetText("|cFF00c0fa"..MER.Version.."|r")
	self.AFKMode.topPanel.mversion:SetPoint("TOP", self.AFKMode.topPanel.mUILogo, "BOTTOM")
	self.AFKMode.topPanel.mversion:SetTextColor(0.7, 0.7, 0.7)

	-- Time
	self.AFKMode.topPanel.time = self.AFKMode.topPanel:CreateFontString(nil, "OVERLAY")
	self.AFKMode.topPanel.time:FontTemplate(nil, 16)
	self.AFKMode.topPanel.time:SetText("")
	self.AFKMode.topPanel.time:SetPoint("CENTER", self.AFKMode.topPanel, "CENTER", 0, 0)
	self.AFKMode.topPanel.time:SetJustifyH("CENTER")
	self.AFKMode.topPanel.time:SetTextColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)

	-- Player Model
	if not modelHolder then
		local modelHolder = CreateFrame("Frame", nil, self.AFKMode.bottomPanel)
		modelHolder:SetSize(150, 150)
		modelHolder:SetPoint("BOTTOMRIGHT", self.AFKMode.bottomPanel, "BOTTOMRIGHT", -150, 180)

		playerModel = CreateFrame("PlayerModel", nil, modelHolder)
		playerModel:SetSize(GetScreenWidth() * 2, GetScreenHeight() * 2) --YES, double screen size. This prevents clipping of models.
		playerModel:SetPoint("CENTER", modelHolder, "CENTER")
		playerModel:SetScript("OnShow", Player_Model)
		playerModel:SetFrameLevel(3)
		playerModel.isIdle = nil

		-- Speech Bubble
		playerModel.tex = playerModel:CreateTexture(nil, "BACKGROUND")
		playerModel.tex:SetPoint("TOP", modelHolder, "TOP", 30, 80)
		playerModel.tex:SetTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\bubble.blp")

		playerModel.tex.text = playerModel:CreateFontString(nil, "OVERLAY")
		playerModel.tex.text:SetFont(E.LSM:Fetch("font", "Merathilis BadaBoom"), 20, "OUTLINE")
		playerModel.tex.text:SetText("AFK ... maybe!?")
		playerModel.tex.text:SetPoint("CENTER", playerModel.tex, "CENTER", 0, 10)
		playerModel.tex.text:SetJustifyH("CENTER")
		playerModel.tex.text:SetJustifyV("CENTER")
		playerModel.tex.text:SetTextColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)
		playerModel.tex.text:SetShadowOffset(2, -2)
	end

	E:UpdateBorderColors()
end