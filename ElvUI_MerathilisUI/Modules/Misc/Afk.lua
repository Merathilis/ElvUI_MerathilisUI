local MER, E, L, V, P, G = unpack(select(2, ...))
local AFK = E:GetModule("AFK")
local COMP = MER:GetModule("mUICompatibility")

-- Cache global variables
-- Lua Variables
local _G = _G
local unpack = unpack
local format = string.format
local floor = math.floor
local date = date
-- WoW API / Variables
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local GetTime = GetTime
local GetGuildInfo = GetGuildInfo
local IsInGuild = IsInGuild
local GetScreenWidth, GetScreenHeight = GetScreenWidth, GetScreenHeight

-- Credits: DuffedUI

local function Player_Model(self)
	self:ClearModel()
	self:SetUnit("player")
	self:SetFacing(1)
	self:SetCamDistanceScale(8)
	self:SetAlpha(1)
	self:SetAnimation(71)
end

local function SetAFK(status)
	if E.db.mui.general.AFK ~= true then return end

	local guildName = GetGuildInfo("player") or ""
	if(status) then
		if(IsInGuild()) then
			if AFK.AFKMode.Guild then
				AFK.AFKMode.Guild:SetText("|cFF00c0fa<".. guildName ..">|r")
			end
		else
			if AFK.AFKMode.Guild then
				AFK.AFKMode.Guild:SetText(L["No Guild"])
			end
		end
		AFK.startTime = GetTime()

		AFK.isAFK = true
	elseif(AFK.isAFK) then
		AFK.isAFK = false
	end
end
hooksecurefunc(AFK, "SetAFK", SetAFK)

-- AFK-Timer
local function UpdateTimer()
	local time = GetTime() - AFK.startTime
	AFK.AFKMode.AFKTimer:SetText(format('%02d' .. MER.InfoColor ..':|r%02d', floor(time/60), time % 60))
end

local function Initialize()
	if E.db.general.afk ~= true or E.db.mui.general.AFK ~= true then return end

	-- Compatibility
	if (COMP.SLE and E.private.sle.module.screensaver) or (COMP.BUI and E.db.benikui.misc.afkMode) then return end

	AFK.Initialized = true

	-- Hide ElvUI Elements
	AFK.AFKMode.bottom:Hide() -- Bottom panel
	AFK.AFKMode.bottom.LogoTop:Hide()
	AFK.AFKMode.bottom.LogoBottom:Hide()

	-- move the chat lower
	AFK.AFKMode.chat:ClearAllPoints()
	AFK.AFKMode.chat:SetPoint("TOPLEFT", AFK.AFKMode.top, "BOTTOMLEFT", 4, -10)

	AFK.AFKMode.Panel = CreateFrame('Frame', nil, AFK.AFKMode)
	AFK.AFKMode.Panel:Point('BOTTOM', E.UIParent, 'BOTTOM', 0, 100)
	AFK.AFKMode.Panel:Size((GetScreenWidth()/2), 80)
	AFK.AFKMode.Panel:CreateBackdrop('Transparent')
	AFK.AFKMode.Panel:SetFrameStrata('FULLSCREEN')
	AFK.AFKMode.Panel:Styling()

	E["frames"][AFK.AFKMode.Panel] = true
	AFK.AFKMode.Panel.ignoreFrameTemplates = true
	AFK.AFKMode.Panel.ignoreBackdropColors = true

	AFK.AFKMode.PanelIcon = CreateFrame('Frame', nil, AFK.AFKMode.Panel)
	AFK.AFKMode.PanelIcon:Size(70)
	AFK.AFKMode.PanelIcon:Point('CENTER', AFK.AFKMode.Panel, 'TOP', 0, 0)

	AFK.AFKMode.PanelIcon.Texture = AFK.AFKMode.PanelIcon:CreateTexture(nil, 'ARTWORK')
	AFK.AFKMode.PanelIcon.Texture:Point('TOPLEFT', 2, -2)
	AFK.AFKMode.PanelIcon.Texture:Point('BOTTOMRIGHT', -2, 2)
	AFK.AFKMode.PanelIcon.Texture:SetTexture('Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\mUI1.tga')

	AFK.AFKMode.MERVersion = AFK.AFKMode.Panel:CreateFontString(nil, 'OVERLAY')
	AFK.AFKMode.MERVersion:Point('CENTER', AFK.AFKMode.Panel, 'CENTER', 0, -10)
	AFK.AFKMode.MERVersion:FontTemplate(nil, 24, 'OUTLINE')
	AFK.AFKMode.MERVersion:SetText(MER.Title.."|cFF00c0fa"..MER.Version.."|r")

	AFK.AFKMode.DateText = AFK.AFKMode.Panel:CreateFontString(nil, 'OVERLAY')
	AFK.AFKMode.DateText:Point('RIGHT', AFK.AFKMode.Panel, 'RIGHT', -5, 24)
	AFK.AFKMode.DateText:FontTemplate(nil, 15, 'OUTLINE')

	AFK.AFKMode.ClockText = AFK.AFKMode.Panel:CreateFontString(nil, 'OVERLAY')
	AFK.AFKMode.ClockText:Point('RIGHT', AFK.AFKMode.Panel, 'RIGHT', -5, 0)
	AFK.AFKMode.ClockText:FontTemplate(nil, 20, 'OUTLINE')

	AFK.AFKMode.AFKTimer = AFK.AFKMode.Panel:CreateFontString(nil, 'OVERLAY')
	AFK.AFKMode.AFKTimer:Point('RIGHT', AFK.AFKMode.Panel, 'RIGHT', -5, -26)
	AFK.AFKMode.AFKTimer:FontTemplate(nil, 16, 'OUTLINE')

	-- Dynamic time & date
	local interval = 0
	AFK.AFKMode.Panel:SetScript('OnUpdate', function(self, elapsed)
		interval = interval - elapsed
		if interval <= 0 then
			AFK.AFKMode.ClockText:SetText(format('%s', date('%H' .. MER.InfoColor .. ':|r%M' .. MER.InfoColor .. ':|r%S')))
			AFK.AFKMode.DateText:SetText(format('%s', date(MER.InfoColor .. '%a|r %b' .. MER.InfoColor .. '/|r%d')))
			UpdateTimer()
			interval = 0.5
		end
	end)

	AFK.AFKMode.PlayerName = AFK.AFKMode.Panel:CreateFontString(nil, 'OVERLAY')
	AFK.AFKMode.PlayerName:Point('LEFT', AFK.AFKMode.Panel, 'LEFT', 5, 20)
	AFK.AFKMode.PlayerName:FontTemplate(nil, 26, 'OUTLINE')
	AFK.AFKMode.PlayerName:SetTextColor(unpack(E["media"].rgbvaluecolor))
	AFK.AFKMode.PlayerName:SetText(E.myname)

	AFK.AFKMode.Guild = AFK.AFKMode.Panel:CreateFontString(nil, 'OVERLAY')
	AFK.AFKMode.Guild:Point('LEFT', AFK.AFKMode.Panel, 'LEFT', 5, 0)
	AFK.AFKMode.Guild:FontTemplate(nil, 18, 'OUTLINE')

	local color = E:ClassColor(E.myclass)
	local coloredClass = ("|cff%02x%02x%02x%s"):format(color.r * 255, color.g * 255, color.b * 255, E.myLocalizedClass:gsub("%-.+", "*"))
	AFK.AFKMode.PlayerInfo = AFK.AFKMode.Panel:CreateFontString(nil, 'OVERLAY')
	AFK.AFKMode.PlayerInfo:Point('LEFT', AFK.AFKMode.Panel, 'LEFT', 5, -20)
	AFK.AFKMode.PlayerInfo:FontTemplate(nil, 15, 'OUTLINE')
	AFK.AFKMode.PlayerInfo:SetText(_G.LEVEL .. ' ' .. E.mylevel .. ' '.. E.myLocalizedFaction .. ' ' .. coloredClass)

	-- Player Model
	if not AFK.AFKMode.ModelHolder then
		local modelHolder = CreateFrame("Frame", nil, AFK.AFKMode.Panel)
		modelHolder:SetSize(150, 150)
		modelHolder:SetPoint("RIGHT", AFK.AFKMode.Panel, "RIGHT", 250, 100)

		local playerModel = CreateFrame("PlayerModel", nil, modelHolder)
		playerModel:SetSize(GetScreenWidth() * 2, GetScreenHeight() * 2) --YES, double screen size. This prevents clipping of models.
		playerModel:SetPoint("CENTER", modelHolder, "CENTER")
		playerModel:SetScript("OnShow", Player_Model)
		playerModel:SetFrameLevel(3)
		playerModel.isIdle = nil

		-- Speech Bubble
		playerModel.tex = playerModel:CreateTexture(nil, "BACKGROUND")
		playerModel.tex:SetPoint("TOP", modelHolder, "TOP", 30, 80)
		playerModel.tex:SetTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\bubble")

		playerModel.tex.text = playerModel:CreateFontString(nil, "OVERLAY")
		playerModel.tex.text:FontTemplate(E.LSM:Fetch("font", "Merathilis BadaBoom"), 20, "OUTLINE")
		playerModel.tex.text:SetText("AFK ... maybe!?")
		playerModel.tex.text:SetPoint("CENTER", playerModel.tex, "CENTER", 0, 10)
		playerModel.tex.text:SetJustifyH("CENTER")
		playerModel.tex.text:SetJustifyV("CENTER")
		playerModel.tex.text:SetTextColor(unpack(E["media"].rgbvaluecolor))
		playerModel.tex.text:SetShadowOffset(2, -2)
	end

	E:UpdateBorderColors()

	AFK:Toggle()
	AFK.isActive = false
end

hooksecurefunc(AFK, "Initialize", Initialize)
