local MER, E, L, V, P, G = unpack(select(2, ...))

-- Cache global variables
-- Lua functions

-- WoW API / Variables
local C_TimerAfter = C_Timer.After
local C_Calendar_GetDate = C_Calendar.GetDate
local CreateFrame = CreateFrame
-- Global variables that we don"t cache, list them here for the mikk"s Find Globals script
-- GLOBALS: MUISplashScreen

-- Splash Screen
local function HideSplashScreen()
	MUISplashScreen:Hide()
	MER:CheckVersion()
end

local function FadeSplashScreen()
	E:Delay(2, function()
		E:UIFrameFadeOut(MUISplashScreen, 2, 1, 0)
		MUISplashScreen.fadeInfo.finishedFunc = HideSplashScreen
	end)
end

local function ShowSplashScreen()
	E:UIFrameFadeIn(MUISplashScreen, 4, 0, 1)
	MUISplashScreen.fadeInfo.finishedFunc = FadeSplashScreen
end

local function CreateSplashScreen()
	local f = CreateFrame("Frame", "MUISplashScreen", E.UIParent)
	f:Size(300, 150)
	f:SetPoint("CENTER", 0, 100)
	f:SetFrameStrata("TOOLTIP")
	f:SetAlpha(0)

	f.bg = f:CreateTexture(nil, "BACKGROUND")
	f.bg:SetTexture([[Interface\LevelUp\LevelUpTex]])
	f.bg:SetPoint("BOTTOM")
	f.bg:Size(400, 240)
	f.bg:SetTexCoord(0.00195313, 0.63867188, 0.03710938, 0.23828125)
	f.bg:SetVertexColor(1, 1, 1, 0.7)

	f.lineTop = f:CreateTexture(nil, "BACKGROUND")
	f.lineTop:SetDrawLayer("BACKGROUND", 2)
	f.lineTop:SetTexture([[Interface\LevelUp\LevelUpTex]])
	f.lineTop:SetPoint("TOP")
	f.lineTop:Size(418, 7)
	f.lineTop:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)

	f.lineBottom = f:CreateTexture(nil, "BACKGROUND")
	f.lineBottom:SetDrawLayer("BACKGROUND", 2)
	f.lineBottom:SetTexture([[Interface\LevelUp\LevelUpTex]])
	f.lineBottom:SetPoint("BOTTOM")
	f.lineBottom:Size(418, 7)
	f.lineBottom:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)

	f.logo = f:CreateTexture(nil, "OVERLAY")
	f.logo:Size(125, 125)
	f.logo:SetTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\mUI1.tga")
	f.logo:Point("CENTER", f, "CENTER")

	f.version = MER:CreateText(f, "OVERLAY", 14, nil, "CENTER")
	f.version:FontTemplate(nil, 14, nil)
	f.version:Point("TOP", f.logo, "BOTTOM", 0, 10)
	f.version:SetFormattedText("v%s", MER.Version)
	f.version:SetTextColor(1, 0.5, 0.25, 1)
end

function MER:SplashScreen()
	if not E.db.mui.general.splashScreen then return end
	CreateSplashScreen()

	-- Only show the SplashScreen once a day
	local db = E.private.muiMisc.session
	local date = C_Calendar_GetDate()
	local presentWeekday = date.weekday
	if presentWeekday == db.day then return end


	-- Show only Splash Screen if the install is completed
	if (E.db.mui.installed == true and E.db.mui.general.splashScreen) then
		C_TimerAfter(6, ShowSplashScreen)
	end
	db.day = presentWeekday
end