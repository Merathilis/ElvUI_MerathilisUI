local MER, E, L, V, P, G = unpack(select(2, ...))
local MERA = MER:NewModule("mUIAnnounce", "AceEvent-3.0")
local LSM = LibStub("LibSharedMedia-3.0")
MERA.modName = L["Announce"]

--Cache global variables
--Lua functions
local _G = _G
local unpack, string = unpack, string
local format, upper = string.format, string.upper
--WoW API / Variables
local CreateFrame = CreateFrame
local UnitIsDead = UnitIsDead
local SetCVar = SetCVar
local GetSpellInfo = GetSpellInfo
local GetSpellLink = GetSpellLink
local IsInRaid = IsInRaid
local IsPartyLFG = IsPartyLFG
local UnitInRaid = UnitInRaid
local UnitInParty = UnitInParty
local UnitName = UnitName
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: LE_PARTY_CATEGORY_HOME, LE_PARTY_CATEGORY_INSTANCE, LEAVING_COMBAT, ENTERING_COMBAT
-- GLOBALS: UIErrorsFrame, ChatTypeInfo, CombatText

local iconsize = 24

function MERA:PLAYER_REGEN_ENABLED()
	if (UnitIsDead("player")) then return end
	self:AlertRun(LEAVING_COMBAT.." !", 0.1, 1, 0.1)
end

function MERA:PLAYER_REGEN_DISABLED()
	if (UnitIsDead("player")) then return end
	self:AlertRun(ENTERING_COMBAT.." !", 1, 0.1, 0.1)
end

function MERA:CHAT_MSG_SKILL(event, message)
	UIErrorsFrame:AddMessage(message, ChatTypeInfo["SKILL"].r, ChatTypeInfo["SKILL"].g, ChatTypeInfo["SKILL"].b)
end

-------------------------------------------------------------------------------------
-- Credit Alleykat
-- Entering combat and alertrun function (can be used in anther ways)
------------------------------------------------------------------------------------
local speed = .057799924 -- how fast the text appears
local font = LSM:Fetch("font", "Expressway")
local fontflag = "OUTLINE" -- for pixelfont stick to this else OUTLINE or THINOUTLINE
local fontsize = 24 -- font size

local GetNextChar = function(word,num)
	local c = word:byte(num)
	local shift
	if not c then return "",num end
	if (c > 0 and c <= 127) then
		shift = 1
	elseif (c >= 192 and c <= 223) then
		shift = 2
	elseif (c >= 224 and c <= 239) then
		shift = 3
	elseif (c >= 240 and c <= 247) then
		shift = 4
	end
	return word:sub(num,num+shift-1),(num+shift)
end

local updaterun = CreateFrame("Frame")

local flowingframe = CreateFrame("Frame", nil, E.UIParent)
flowingframe:SetFrameStrata("HIGH")
flowingframe:SetPoint("CENTER", E.UIParent, 0, 140) -- where we want the textframe
flowingframe:SetHeight(64)

local flowingtext = flowingframe:CreateFontString(nil,"OVERLAY")
flowingtext:SetFont(font, fontsize, fontflag)
flowingtext:SetShadowOffset(1.5, -1.5)

local rightchar = flowingframe:CreateFontString(nil,"OVERLAY")
rightchar:SetFont(font, 60, fontflag)
rightchar:SetShadowOffset(1.5, -1.5)
rightchar:SetJustifyH("LEFT") -- left or right

local count, len, step, word, stringE, a, backstep

local nextstep = function()
	a,step = GetNextChar (word,step)
	flowingtext:SetText(stringE)
	stringE = stringE..a
	a = upper(a)
	rightchar:SetText(a)
end

local backrun = CreateFrame("Frame")
backrun:Hide()

local updatestring = function(self,t)
	count = count - t
	if count < 0 then
		count = speed
		if step > len then
			self:Hide()
			flowingtext:SetText(stringE)
			rightchar:SetText()
			flowingtext:ClearAllPoints()
			flowingtext:SetPoint("RIGHT")
			flowingtext:SetJustifyH("RIGHT")
			rightchar:ClearAllPoints()
			rightchar:SetPoint("RIGHT",flowingtext,"LEFT")
			rightchar:SetJustifyH("RIGHT")
			self:Hide()
			count = 1.456789
			backrun:Show()
		else
			nextstep()
		end
	end
end

updaterun:SetScript("OnUpdate",updatestring)
updaterun:Hide()

local backstepf = function()
	local a = backstep
	local firstchar
	local texttemp = ""
	local flagon = true
	while a <= len do
		local u
		u,a = GetNextChar(word,a)
		if flagon == true then
			backstep = a
			flagon = false
			firstchar = u
		else
			texttemp = texttemp..u
		end
	end
	flowingtext:SetText(texttemp)
	firstchar = upper(firstchar)
	rightchar:SetText(firstchar)
end

local rollback = function(self,t)
	count = count - t
	if count < 0 then
		count = speed
		if backstep > len then
			self:Hide()
			flowingtext:SetText()
			rightchar:SetText()
		else
			backstepf()
		end
	end
end

backrun:SetScript("OnUpdate",rollback)

function MERA:AlertRun(f, r, g, b)
	flowingframe:Hide()
	updaterun:Hide()
	backrun:Hide()

	flowingtext:SetText(f)
	local l = flowingtext:GetWidth()

	local color1 = r or 1
	local color2 = g or 1
	local color3 = b or 1

	flowingtext:SetTextColor(color1*.95, color2*.95, color3*.95) -- color in RGB(red green blue)(alpha)
	rightchar:SetTextColor(color1, color2, color3)

	word = f
	len = f:len()
	step,backstep = 1,1
	count = speed
	stringE = ""
	a = ""

	flowingtext:SetText("")
	flowingframe:SetWidth(l)
	flowingtext:ClearAllPoints()
	flowingtext:SetPoint("LEFT")
	flowingtext:SetJustifyH("LEFT")
	rightchar:ClearAllPoints()
	rightchar:SetPoint("LEFT",flowingtext,"RIGHT")
	rightchar:SetJustifyH("LEFT")

	rightchar:SetText("")
	updaterun:Show()
	flowingframe:Show()
end

function MERA:Initialize()
	if E.db.mui.general.CombatState then
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
	end

	if E.db.mui.misc.announce then
		self:RegisterEvent("CHAT_MSG_SKILL")
	end

	SetCVar("floatingCombatTextCombatState", "1")
end

local function InitializeCallback()
	MERA:Initialize()
end

MER:RegisterModule(MERA:GetName(), InitializeCallback)
