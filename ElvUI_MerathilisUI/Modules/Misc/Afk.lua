local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local S = MER:GetModule("MER_Skins")
local AFK = E:GetModule("AFK")

local _G = _G
local tonumber, unpack = tonumber, unpack
local format = string.format
local floor = math.floor
local date = date

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local GetGameTime = GetGameTime
local GetTime = GetTime
local GetGuildInfo = GetGuildInfo
local IsInGuild = IsInGuild
local GetScreenWidth, GetScreenHeight = GetScreenWidth, GetScreenHeight
local GetCurrentCalendarTime = C_DateAndTime.GetCurrentCalendarTime

local function Player_Model(self)
	self:ClearModel()
	self:SetUnit("player")
	self:SetFacing(1)
	self:SetCamDistanceScale(8)
	self:SetAlpha(1)
	self:SetAnimation(71)
end

local function ConvertTime(h, m)
	local AmPm
	if E.global.datatexts.settings.Time.time24 == true then
		return h, m, -1
	else
		if h >= 12 then
			if h > 12 then
				h = h - 12
			end
			AmPm = 1
		else
			if h == 0 then
				h = 12
			end
			AmPm = 2
		end
	end
	return h, m, AmPm
end

local function CreateTime()
	local hour, hour24, minute, ampm =
		tonumber(date("%I")), tonumber(date("%H")), tonumber(date("%M")), date("%p"):lower()
	local sHour, sMinute = ConvertTime(GetGameTime())

	local localTime = format("|cffb3b3b3%s|r %d:%02d|cffb3b3b3%s|r", TIMEMANAGER_TOOLTIP_LOCALTIME, hour, minute, ampm)
	local localTime24 = format("|cffb3b3b3%s|r %02d:%02d", TIMEMANAGER_TOOLTIP_LOCALTIME, hour24, minute)
	local realmTime =
		format("|cffb3b3b3%s|r %d:%02d|cffb3b3b3%s|r", TIMEMANAGER_TOOLTIP_REALMTIME, sHour, sMinute, ampm)
	local realmTime24 = format("|cffb3b3b3%s|r %02d:%02d", TIMEMANAGER_TOOLTIP_REALMTIME, sHour, sMinute)

	if E.global.datatexts.settings.Time.localTime then
		if E.global.datatexts.settings.Time.time24 == true then
			return localTime24
		else
			return localTime
		end
	else
		if E.global.datatexts.settings.Time.time24 == true then
			return realmTime24
		else
			return realmTime
		end
	end
end

local monthAbr = {
	[1] = L["Jan"],
	[2] = L["Feb"],
	[3] = L["Mar"],
	[4] = L["Apr"],
	[5] = L["May"],
	[6] = L["Jun"],
	[7] = L["Jul"],
	[8] = L["Aug"],
	[9] = L["Sep"],
	[10] = L["Oct"],
	[11] = L["Nov"],
	[12] = L["Dec"],
}

local daysAbr = {
	[1] = L["Sun"],
	[2] = L["Mon"],
	[3] = L["Tue"],
	[4] = L["Wed"],
	[5] = L["Thu"],
	[6] = L["Fri"],
	[7] = L["Sat"],
}

-- Create Date
local function CreateDate()
	local date = GetCurrentCalendarTime()
	local presentWeekday = date.weekday
	local presentMonth = date.month
	local presentDay = date.monthDay
	local presentYear = date.year

	if AFK.AFKMode.DateText then
		AFK.AFKMode.DateText:SetFormattedText(
			"%s, %s %d, %d",
			daysAbr[presentWeekday],
			monthAbr[presentMonth],
			presentDay,
			presentYear
		)
	end
end

function AFK:UpdateLogOff()
	local timePassed = GetTime() - self.startTime
	local minutes = floor(timePassed / 60)
	local neg_seconds = -timePassed % 60

	if minutes - 29 == 0 and floor(neg_seconds) == 0 then
		self:CancelTimer(self.logoffTimer)
		if self.AFKMode.count then
			self.AFKMode.count:SetFormattedText("%s: |cfff0ff0000:00|r", L["Logout Timer"])
		end
	else
		if self.AFKMode.count then
			self.AFKMode.count:SetFormattedText(
				"%s: |cfff0ff00%02d:%02d|r",
				L["Logout Timer"],
				minutes - 29,
				neg_seconds
			)
		end
	end
end

local function UpdateTimer()
	local createdTime = CreateTime()
	local time = GetTime() - AFK.startTime

	-- Set Clock
	if AFK.AFKMode.ClockText then
		AFK.AFKMode.ClockText:SetFormattedText(createdTime)
	end

	-- Set Date
	CreateDate()
end
hooksecurefunc(AFK, "UpdateTimer", UpdateTimer)

AFK.SetAFKMER = AFK.SetAFK
function AFK:SetAFK(status)
	self:SetAFKMER(status)
	if E.db.mui.general.AFK ~= true then
		return
	end

	local guildName = GetGuildInfo("player")

	if status then
		if IsInGuild() then
			if AFK.AFKMode.Guild then
				AFK.AFKMode.Guild:SetText(
					guildName and F.String.FastGradientHex("<" .. guildName .. ">", "06c910", "33ff3d") or ""
				)
			end
		else
			if AFK.AFKMode.Guild then
				AFK.AFKMode.Guild:SetText(L["No Guild"])
			end
		end

		AFK.startTime = GetTime()
		AFK.logoffTimer = AFK:ScheduleRepeatingTimer("UpdateLogOff", 1)

		AFK.isAFK = true
	elseif AFK.isAFK then
		self:CancelTimer(AFK.logoffTimer)

		self.AFKMode.count:SetFormattedText("%s: |cfff0ff00-30:00|r", L["Logout Timer"])
		AFK.isAFK = false
	end
end

local function Initialize()
	if E.db.general.afk ~= true or E.db.mui.general.AFK ~= true then
		return
	end

	local _, classunit = UnitClass("player")
	local colorDB = E.db.mui.gradient

	-- Hide ElvUI Elements
	AFK.AFKMode.bottom:Hide() -- Bottom panel
	AFK.AFKMode.bottom.LogoTop:Hide()
	AFK.AFKMode.bottom.LogoBottom:Hide()

	-- move the chat lower
	AFK.AFKMode.chat:ClearAllPoints()
	AFK.AFKMode.chat:SetPoint("TOPLEFT", AFK.AFKMode.top, "BOTTOMLEFT", 4, -10)

	if not AFK.AFKMode.Panel then
		AFK.AFKMode.Panel = CreateFrame("Frame", nil, AFK.AFKMode, "BackdropTemplate")
		AFK.AFKMode.Panel:Point("BOTTOM", E.UIParent, "BOTTOM", 0, 100)
		AFK.AFKMode.Panel:Size((GetScreenWidth() / 2), 80)
		AFK.AFKMode.Panel:CreateBackdrop("Transparent")
		AFK.AFKMode.Panel:SetFrameStrata("FULLSCREEN")
		MER:CreateInnerNoise(AFK.AFKMode.Panel)
		S:CreateBackdropShadow(AFK.AFKMode.Panel)

		E["frames"][AFK.AFKMode.Panel] = true
		AFK.AFKMode.Panel.ignoreFrameTemplates = true
		AFK.AFKMode.Panel.ignoreBackdropColors = true
	end

	if not AFK.AFKMode.Panel.crest then
		AFK.AFKMode.Panel.crest = AFK.AFKMode.Panel:CreateTexture(nil, "ARTWORK")
		AFK.AFKMode.Panel.crest:SetDrawLayer("ARTWORK")
		AFK.AFKMode.Panel.crest:Point("BOTTOM", AFK.AFKMode.Panel, "TOP", 0, -30)
		AFK.AFKMode.Panel.crest:SetTexture(I.Media.Textures.PepoBedge)
		AFK.AFKMode.Panel.crest:Size(64)
	end

	AFK.AFKMode.MERVersion = AFK.AFKMode.Panel:CreateFontString(nil, "OVERLAY")
	AFK.AFKMode.MERVersion:Point("CENTER", AFK.AFKMode.Panel, "CENTER", 0, -10)
	AFK.AFKMode.MERVersion:FontTemplate(nil, 24, "SHADOWOUTLINE")
	AFK.AFKMode.MERVersion:SetText(MER.Title .. "|cFF00c0fa" .. MER.Version .. "|r")

	AFK.AFKMode.DateText = AFK.AFKMode.Panel:CreateFontString(nil, "OVERLAY")
	AFK.AFKMode.DateText:Point("RIGHT", AFK.AFKMode.Panel, "RIGHT", -5, 24)
	AFK.AFKMode.DateText:FontTemplate(nil, 15, "SHADOWOUTLINE")

	AFK.AFKMode.ClockText = AFK.AFKMode.Panel:CreateFontString(nil, "OVERLAY")
	AFK.AFKMode.ClockText:Point("RIGHT", AFK.AFKMode.Panel, "RIGHT", -5, 0)
	AFK.AFKMode.ClockText:FontTemplate(nil, 20, "SHADOWOUTLINE")

	AFK.AFKMode.count = AFK.AFKMode.Panel:CreateFontString(nil, "OVERLAY")
	AFK.AFKMode.count:Point("RIGHT", AFK.AFKMode.Panel, "RIGHT", -5, -26)
	AFK.AFKMode.count:FontTemplate(nil, 14, "SHADOWOUTLINE")

	AFK.AFKMode.PlayerName = AFK.AFKMode.Panel:CreateFontString(nil, "OVERLAY")
	AFK.AFKMode.PlayerName:Point("LEFT", AFK.AFKMode.Panel, "LEFT", 5, 20)
	AFK.AFKMode.PlayerName:FontTemplate(nil, 24, "SHADOWOUTLINE")

	local coloredClass
	if colorDB.enable then
		if colorDB.customColor.enableClass then
			AFK.AFKMode.PlayerName:SetText(F.GradientNameCustom(E.myname, classunit))
			coloredClass = F.GradientNameCustom(E.myLocalizedClass:gsub("%-.+", "*"), classunit)
		else
			AFK.AFKMode.PlayerName:SetText(F.GradientName(E.myname, classunit))
			coloredClass = F.GradientName(E.myLocalizedClass:gsub("%-.+", "*"), classunit)
		end
	else
		AFK.AFKMode.PlayerName:SetText(E.myname)
		AFK.AFKMode.PlayerName:SetTextColor(F.r, F.g, F.b or 1, 1, 1)

		local color = E:ClassColor(E.myclass)
		coloredClass = ("|cff%02x%02x%02x%s"):format(
			color.r * 255,
			color.g * 255,
			color.b * 255,
			E.myLocalizedClass:gsub("%-.+", "*")
		)
	end

	AFK.AFKMode.Guild = AFK.AFKMode.Panel:CreateFontString(nil, "OVERLAY")
	AFK.AFKMode.Guild:Point("LEFT", AFK.AFKMode.Panel, "LEFT", 5, 0)
	AFK.AFKMode.Guild:FontTemplate(nil, 16, "SHADOWOUTLINE")

	AFK.AFKMode.PlayerInfo = AFK.AFKMode.Panel:CreateFontString(nil, "OVERLAY")
	AFK.AFKMode.PlayerInfo:Point("LEFT", AFK.AFKMode.Panel, "LEFT", 5, -25)
	AFK.AFKMode.PlayerInfo:FontTemplate(nil, 15, "SHADOWOUTLINE")
	AFK.AFKMode.PlayerInfo:SetText(_G.LEVEL .. " " .. E.mylevel .. " " .. E.myLocalizedFaction .. " " .. coloredClass)

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
		playerModel.tex:SetTexture(I.General.MediaPath .. "Textures\\bubble")

		playerModel.tex.text = playerModel:CreateFontString(nil, "OVERLAY")
		playerModel.tex.text:FontTemplate(nil, 20, "SHADOWOUTLINE")
		playerModel.tex.text:SetText("AFK ... maybe!?")
		playerModel.tex.text:SetPoint("CENTER", playerModel.tex, "CENTER", 0, 10)
		playerModel.tex.text:SetJustifyH("CENTER")
		playerModel.tex.text:SetJustifyV("MIDDLE")
		playerModel.tex.text:SetTextColor(unpack(E["media"].rgbvaluecolor))
		playerModel.tex.text:SetShadowOffset(2, -2)
	end
end

hooksecurefunc(AFK, "Initialize", Initialize)
