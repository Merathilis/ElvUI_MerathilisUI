local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local MERS = E:GetModule("muiSkins");
local S = E:GetModule('Skins');
local LSM = LibStub('LibSharedMedia-3.0');

-- Cache global variables
-- Lua functions
local tinsert = table.insert
-- WoW API / Variables
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: UISpecialFrames, MerathilisUIChangeLog, PlaySound, MerathilisUIData

local flat = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\Flat]]

-- Don't show the frame if my install isn't finished
if E.db.mui.installed == nil then return; end

local ChangeLog = CreateFrame("frame")
local ChangeLogData = [=[|cffff7d0av2.35|r, 24.04.2017

|cffff7d0aChanges:|r
 |cffff7d0a•|r Delete the spell tolerance script.
 |cffff7d0a•|r Update the quest module to select the quest reward with the highest price.
 
|cffff7d0aNotes:|r
 |cffff7d0a•|r Have a nice day! ^o^
]=];

local frame = CreateFrame("Frame", "MerathilisUIChangeLog", E.UIParent)
frame:SetPoint("CENTER", UIParent, "BOTTOM", 0, 350)
frame:SetSize(450, 300)
frame:SetTemplate("Transparent")
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
frame:SetClampedToScreen(true)
MERS:CreateSoftShadow(frame)
frame:Hide()

local title = CreateFrame("Frame", nil, frame)
title:SetPoint("BOTTOM", frame, "TOP", 0, 3)
title:SetSize(450, 20)
title:SetTemplate("Transparent")
MERS:CreateSoftShadow(title)

title.text = title:CreateFontString(nil, "OVERLAY")
title.text:SetPoint("CENTER", title, 0, 0)
title.text:SetFont(LSM:Fetch("font", "Merathilis Roboto-Black"), 14, "OUTLINE")
title.text:SetText("|cffff7d0aMerathilisUI|r - ChangeLog " .. MER.Version)

title.style = CreateFrame("Frame", nil, title)
title.style:SetTemplate("Default", true)
title.style:SetFrameStrata("TOOLTIP")
title.style:SetInside()
title.style:Point("TOPLEFT", title, "BOTTOMLEFT", 0, 1)
title.style:Point("BOTTOMRIGHT", title, "BOTTOMRIGHT", 0, (E.PixelMode and -4 or -7))

title.style.color = title.style:CreateTexture(nil, "OVERLAY")
title.style.color:SetVertexColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)
title.style.color:SetInside()
title.style.color:SetTexture(flat)

local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
close:Point("TOPRIGHT", frame, "TOPRIGHT", 0, 26)
close:SetSize(24, 24)
close:SetScript("OnClick", function()
	frame:Hide()
end)
S:HandleCloseButton(close)

local data = frame:CreateFontString(nil, "OVERLAY")
data:SetPoint("TOP", frame, "TOP", 0, -5)
data:SetWidth(frame:GetRight() - frame:GetLeft() - 10)
data:FontTemplate(E['media'].muiFont, 11, "OUTLINE")
data:SetText(ChangeLogData)
data:SetJustifyH("LEFT")
frame:SetHeight(data:GetHeight() + 30)

function MER:ToggleChangeLog()
	if MerathilisUIChangeLog:IsShown() then
		MerathilisUIChangeLog:Hide()
	elseif not InCombatLockdown() then
		MerathilisUIChangeLog:Show()
		PlaySound("igMainMenuOptionCheckBoxOff")
		tinsert(UISpecialFrames, "MerathilisUIChangeLog")
	end
end

function MER:OnCheckVersion()
	if not MERData["Version"] or (MERData["Version"] and MERData["Version"] ~= MER.Version) then
		MERData["Version"] = MER.Version
		MerathilisUIChangeLog:Show()
	end
end

ChangeLog:RegisterEvent("PLAYER_ENTERING_WORLD")
ChangeLog:SetScript("OnEvent", function()
	if MERData == nil then MERData = {} end
	MER:OnCheckVersion()
end)