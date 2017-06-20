local MER, E, L, V, P, G = unpack(select(2, ...))
local AFK = E:GetModule("AFK")

-- Cache global variables
-- WoW API / Variables
local CreateFrame = CreateFrame
local GetScreenWidth, GetScreenHeight = GetScreenWidth, GetScreenHeight
local IsAddOnLoaded = IsAddOnLoaded
local PlaySound = PlaySound

local npc = 15358 -- Lurky

-- Create Time
local function createTime()
	local hour, hour24, minute, ampm = tonumber(date("%I")), tonumber(date("%H")), tonumber(date("%M")), date("%p"):lower()
	local sHour, sMinute = GetGameTime()

	local localTime = format("|cffb3b3b3%s|r %d:%02d|cffb3b3b3%s|r", TIMEMANAGER_TOOLTIP_LOCALTIME, hour, minute, ampm)
	local localTime24 = format("|cffb3b3b3%s|r %02d:%02d", TIMEMANAGER_TOOLTIP_LOCALTIME, hour24, minute)
	local realmTime = format("|cffb3b3b3%s|r %d:%02d|cffb3b3b3%s|r", TIMEMANAGER_TOOLTIP_REALMTIME, sHour, sMinute, ampm)
	local realmTime24 = format("|cffb3b3b3%s|r %02d:%02d", TIMEMANAGER_TOOLTIP_REALMTIME, sHour, sMinute)

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
local function createDate()
	local curDayName, curMonth, curDay, curYear = CalendarGetDate()
	AFK.AFKMode.top.date:SetFormattedText("%s, %s %d, %d", daysAbr[curDayName], monthAbr[curMonth], curDay, curYear)
end

local active
local function getSpec()
	local specIndex = GetSpecialization();
	if not specIndex then return end

	active = GetActiveSpecGroup()

	local talent = ''
	local i = GetSpecialization(false, false, active)
	if i then
		i = select(2, GetSpecializationInfo(i))
		if(i) then
			talent = format('%s', i)
		end
	end

	return format('%s', talent)
end

local function getItemLevel()
	local level = UnitLevel("player");
	local _, equipped = GetAverageItemLevel()
	local ilvl = ''
	if (level >= MIN_PLAYER_LEVEL_FOR_ITEM_LEVEL_DISPLAY) then
		ilvl = format('\n%s: %d', ITEM_UPGRADE_STAT_AVERAGE_ITEM_LEVEL, equipped)
	end
	return ilvl
end

function AFK:UpdateLogOff()
	local timePassed = GetTime() - self.startTime
	local minutes = floor(timePassed/60)
	local neg_seconds = -timePassed % 60

	self.AFKMode.top.Status:SetValue(floor(timePassed))
end

AFK.UpdateTimermUI = AFK.UpdateTimer
function AFK:UpdateTimer()
	self:UpdateTimermUI()

	local createdTime = createTime()

	-- Set Date
	createDate()

	-- Set time
	self.AFKMode.top.time:SetFormattedText(createdTime)
end

AFK.mUISetAFK = AFK.SetAFK
function AFK:SetAFK(status)
	self:mUISetAFK(status)

	if(status) then
		local level = UnitLevel('player')
		local race = UnitRace('player')
		local localizedClass = UnitClass('player')
		local spec = getSpec()
		local ilvl = getItemLevel()
		self.AFKMode.top:SetHeight(0)
		self.AFKMode.top.anim.height:Play()
		self.AFKMode.bottom:SetHeight(0)
		self.AFKMode.bottom.anim.height:Play()
		self.logoffTimer = self:ScheduleRepeatingTimer("UpdateLogOff", 1)
		self.AFKMode.bottom.name:SetFormattedText("%s - %s\n%s %s %s %s %s%s", E.myname, E.myrealm, LEVEL, level, race, spec, localizedClass, ilvl)
	end
end

AFK.InitializemUIAFK = AFK.Initialize
function AFK:Initialize()
	if E.db.general.afk ~= true or E.db.mui.general.AFK ~= true then return end
	self:InitializemUIAFK()

	local level = UnitLevel("player")
	local race = UnitRace("player")
	local localizedClass = UnitClass("player")
	local className = E.myclass
	local spec = getSpec()
	local ilvl = getItemLevel()

	-- Create Top frame
	self.AFKMode.top = CreateFrame("Frame", nil, self.AFKMode)
	self.AFKMode.top:SetFrameLevel(0)
	self.AFKMode.top:SetTemplate("Transparent")
	self.AFKMode.top:ClearAllPoints()
	self.AFKMode.top:SetPoint("TOP", self.AFKMode, "TOP", 0, E.Border)
	self.AFKMode.top:SetWidth(GetScreenWidth() + (E.Border*2))

	--Top Animation
	self.AFKMode.top.anim = CreateAnimationGroup(self.AFKMode.top)
	self.AFKMode.top.anim.height = self.AFKMode.top.anim:CreateAnimation("Height")
	self.AFKMode.top.anim.height:SetChange(GetScreenHeight() * (1 / 20))
	self.AFKMode.top.anim.height:SetDuration(1)
	self.AFKMode.top.anim.height:SetSmoothing("Bounce")

	-- move the chat lower
	self.AFKMode.chat:SetPoint("TOPLEFT", self.AFKMode.top.style, "TOPLEFT", 4, -4)

	if IsAddOnLoaded("ElvUI_BenikUI") then
		-- WoW logo
		self.AFKMode.top.wowlogo = CreateFrame('Frame', nil, self.AFKMode) -- need this to upper the logo layer
		self.AFKMode.top.wowlogo:SetPoint("TOP", self.AFKMode.top, "TOP", 0, -5)
		self.AFKMode.top.wowlogo:SetFrameStrata("MEDIUM")
		self.AFKMode.top.wowlogo:SetSize(300, 150)
		self.AFKMode.top.wowlogo.tex = self.AFKMode.top.wowlogo:CreateTexture(nil, 'OVERLAY')
		self.AFKMode.top.wowlogo.tex:SetAtlas("Glues-WoW-LegionLogo")
		self.AFKMode.top.wowlogo.tex:SetInside()
	else
		-- mUI logo
		self.AFKMode.top.logo = CreateFrame("Frame", nil, self.AFKMode) -- need this to upper the logo layer
		self.AFKMode.top.logo:SetPoint("TOP", self.AFKMode.top, "TOP", 0, -5)
		self.AFKMode.top.logo:SetFrameStrata("MEDIUM")
		self.AFKMode.top.logo:Size(120, 120)
		self.AFKMode.top.logo.tex = self.AFKMode.top.logo:CreateTexture(nil, "OVERLAY")
		self.AFKMode.top.logo.tex:SetTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\mUI1.tga")
		self.AFKMode.top.logo.tex:SetInside()
	end

	-- Server/Local Time text
	self.AFKMode.top.time = self.AFKMode.top:CreateFontString(nil, "OVERLAY")
	self.AFKMode.top.time:FontTemplate(nil, 16)
	self.AFKMode.top.time:SetText("")
	self.AFKMode.top.time:SetPoint("RIGHT", self.AFKMode.top, "RIGHT", -20, 0)
	self.AFKMode.top.time:SetJustifyH("LEFT")
	self.AFKMode.top.time:SetTextColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)

	-- Date text
	self.AFKMode.top.date = self.AFKMode.top:CreateFontString(nil, "OVERLAY")
	self.AFKMode.top.date:FontTemplate(nil, 16)
	self.AFKMode.top.date:SetText("")
	self.AFKMode.top.date:SetPoint("LEFT", self.AFKMode.top, "LEFT", 20, 0)
	self.AFKMode.top.date:SetJustifyH("RIGHT")
	self.AFKMode.top.date:SetTextColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)

	-- Statusbar on Top frame decor showing time to log off (30mins)
	self.AFKMode.top.Status = CreateFrame("StatusBar", nil, self.AFKMode.top)
	self.AFKMode.top.Status:SetStatusBarTexture((E["media"].normTex))
	self.AFKMode.top.Status:SetMinMaxValues(0, 1800)
	self.AFKMode.top.Status:SetStatusBarColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b, 1)
	self.AFKMode.top.Status:SetFrameLevel(2)
	self.AFKMode.top.Status:Point("TOPRIGHT", self.AFKMode.top, "BOTTOMRIGHT", 0, E.PixelMode and 5 or 7)
	self.AFKMode.top.Status:Point("BOTTOMLEFT", self.AFKMode.top, "BOTTOMLEFT", 0, E.PixelMode and 1 or 2)
	self.AFKMode.top.Status:SetValue(0)

	self.AFKMode.bottom.time:Hide()

	-- Bottom Frame Animation
	self.AFKMode.bottom.anim = CreateAnimationGroup(self.AFKMode.bottom)
	self.AFKMode.bottom.anim.height = self.AFKMode.bottom.anim:CreateAnimation("Height")
	self.AFKMode.bottom.anim.height:SetChange(GetScreenHeight() * (1 / 9))
	self.AFKMode.bottom.anim.height:SetDuration(1)
	self.AFKMode.bottom.anim.height:SetSmoothing("Bounce")

	-- Move the factiongroup sign to the center
	self.AFKMode.bottom.factionb = CreateFrame('Frame', nil, self.AFKMode) -- need this to upper the faction logo layer
	self.AFKMode.bottom.factionb:SetPoint("BOTTOM", self.AFKMode.bottom, "TOP", 0, -40)
	self.AFKMode.bottom.factionb:SetFrameStrata("MEDIUM")
	self.AFKMode.bottom.factionb:SetFrameLevel(10)
	self.AFKMode.bottom.factionb:SetSize(220, 220)
	self.AFKMode.bottom.faction:ClearAllPoints()
	self.AFKMode.bottom.faction:SetParent(self.AFKMode.bottom.factionb)
	self.AFKMode.bottom.faction:SetInside()
	-- Apply class texture rather than the faction
	self.AFKMode.bottom.faction:SetTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\classIcons\\CLASS-"..className)

	-- Add more info in the name and position it to the center
	self.AFKMode.bottom.name:ClearAllPoints()
	self.AFKMode.bottom.name:SetPoint("TOP", self.AFKMode.bottom.factionb, "BOTTOM", 0, 5)
	self.AFKMode.bottom.name:SetFormattedText("%s - %s\n%s %s %s %s %s%s", E.myname, E.myrealm, LEVEL, level, race, spec, localizedClass, ilvl)
	self.AFKMode.bottom.name:SetJustifyH("CENTER")
	self.AFKMode.bottom.name:FontTemplate(nil, 18)

	-- Lower the guild text size a bit
	self.AFKMode.bottom.guild:ClearAllPoints()
	self.AFKMode.bottom.guild:SetPoint("TOP", self.AFKMode.bottom.name, "BOTTOM", 0, -6)
	self.AFKMode.bottom.guild:FontTemplate(nil, 12)
	self.AFKMode.bottom.guild:SetJustifyH("CENTER")

	-- Add ElvUI name
	self.AFKMode.bottom.logotxt = self.AFKMode.bottom:CreateFontString(nil, 'OVERLAY')
	self.AFKMode.bottom.logotxt:FontTemplate(nil, 24)
	self.AFKMode.bottom.logotxt:SetText("ElvUI")
	self.AFKMode.bottom.logotxt:SetPoint("LEFT", self.AFKMode.bottom, "LEFT", 25, 8)
	self.AFKMode.bottom.logotxt:SetTextColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)

	-- ElvUI version
	self.AFKMode.bottom.etext = self.AFKMode.bottom:CreateFontString(nil, 'OVERLAY')
	self.AFKMode.bottom.etext:FontTemplate(nil, 10)
	self.AFKMode.bottom.etext:SetFormattedText("v%s", E.version)
	self.AFKMode.bottom.etext:SetPoint("TOP", self.AFKMode.bottom.logotxt, "BOTTOM")
	self.AFKMode.bottom.etext:SetTextColor(0.7, 0.7, 0.7)
	-- Hide ElvUI logo
	self.AFKMode.bottom.logo:Hide()

	if IsAddOnLoaded("ElvUI_BenikUI") then
		-- MerathilisUI Name
		self.AFKMode.bottom.merathilisui = self.AFKMode.top:CreateFontString(nil, "OVERLAY")
		self.AFKMode.bottom.merathilisui:FontTemplate(nil, 24)
		self.AFKMode.bottom.merathilisui:SetText("MerathilisUI")
		self.AFKMode.bottom.merathilisui:SetPoint("LEFT", self.AFKMode.bottom, "LEFT", 130, 8)
		self.AFKMode.bottom.merathilisui:SetTextColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)
		-- Version
		self.AFKMode.bottom.btext = self.AFKMode.top:CreateFontString(nil, "OVERLAY")
		self.AFKMode.bottom.btext:FontTemplate(nil, 10)
		self.AFKMode.bottom.btext:SetFormattedText("v%s", MER.Version)
		self.AFKMode.bottom.btext:SetPoint("TOP", self.AFKMode.bottom.merathilisui, "BOTTOM")
		self.AFKMode.bottom.btext:SetTextColor(0.7, 0.7, 0.7)
	else
		-- Add MerathilisUI name
		self.AFKMode.bottom.mUI = self.AFKMode.bottom:CreateFontString(nil, 'OVERLAY')
		self.AFKMode.bottom.mUI:FontTemplate(nil, 24)
		self.AFKMode.bottom.mUI:SetText("MerathilisUI")
		self.AFKMode.bottom.mUI:SetPoint("RIGHT", self.AFKMode.bottom, "RIGHT", -25, 8)
		self.AFKMode.bottom.mUI:SetTextColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)
		-- Version
		self.AFKMode.bottom.btext = self.AFKMode.bottom:CreateFontString(nil, 'OVERLAY')
		self.AFKMode.bottom.btext:FontTemplate(nil, 10)
		self.AFKMode.bottom.btext:SetFormattedText("v%s", MER.Version)
		self.AFKMode.bottom.btext:SetPoint("TOP", self.AFKMode.bottom.mUI, "BOTTOM")
		self.AFKMode.bottom.btext:SetTextColor(0.7, 0.7, 0.7)
	end

	-- NPC Model
	self.AFKMode.bottom.npcHolder = CreateFrame("Frame", nil, self.AFKMode.bottom)
	self.AFKMode.bottom.npcHolder:SetSize(150, 150)
	self.AFKMode.bottom.npcHolder:SetPoint("BOTTOMLEFT", self.AFKMode.bottom, "BOTTOMLEFT", 200, 100)

	self.AFKMode.bottom.npc = CreateFrame("PlayerModel", "ElvUIAFKNPCModel", self.AFKMode.bottom.npcHolder)
	self.AFKMode.bottom.npc:SetCreature(npc)
	self.AFKMode.bottom.npc:SetPoint("CENTER", self.AFKMode.bottom.npcHolder, "CENTER")
	self.AFKMode.bottom.npc:SetSize(GetScreenWidth() * 2, GetScreenHeight() * 2)
	self.AFKMode.bottom.npc:SetCamDistanceScale(6)
	self.AFKMode.bottom.npc:SetFacing(6.9)
	self.AFKMode.bottom.npc:SetAnimation(69)
	self.AFKMode.bottom.npc:SetFrameStrata("HIGH")
	self.AFKMode.bottom.npc:Show()
end
