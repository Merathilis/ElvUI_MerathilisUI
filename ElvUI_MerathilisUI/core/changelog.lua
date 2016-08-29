local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local S = E:GetModule('Skins');
local LSM = LibStub('LibSharedMedia-3.0');

-- Cache global variables
-- Lua functions
local pairs, tostring = pairs, tostring
local gmatch, tinsert = gmatch, table.insert
-- WoW API / Variables
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: UISpecialFrames, MerathilisUIChangeLog, PlaySound, MerathilisUIData

local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])
local flat = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\Flat]]

-- Don't show the frame if my install isn't finished
if E.db.mui.installed == nil then return; end

local ChangeLog = CreateFrame("frame")
local ChangeLogData = [=[|cffff7d0av2.14|r, xx.08.2016

|cffff7d0aChanges:|r
 |cffff7d0a•|r Rearrange customTexts in install.
 |cffff7d0a•|r Color my UI name in the TOC file.
 |cffff7d0a•|r Add font file to core, it will replace some blizz default fonts.
 |cffff7d0a•|r More work on the ObjectiveTracker.
 |cffff7d0a•|r Add Tooltips for spells in the LocPanel. And some code adjustments.
 |cffff7d0a•|r Enhance the skins options.
 |cffff7d0a•|r Completly overhaul my install file.
 |cffff7d0a•|r Add a classIcon for the target frame. Disabled by default.
 |cffff7d0a•|r Enable new eliteIcon on Nameplates for FRIENDLY/ENEMY_NPC's.
 
|cffff7d0aNotes:|r
 |cffff7d0a•|r The Heal Layout is not finished yet. Will work on it in the future.
 |cffff7d0a•|r The LocPanel can cause a lua error on profle switch. A reload fixes this. (WIP)
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
MER:CreateSoftShadow(frame)
frame:Hide()

local title = CreateFrame("Frame", nil, frame)
title:SetPoint("BOTTOM", frame, "TOP", 0, 3)
title:SetSize(450, 20)
title:SetTemplate("Transparent")
MER:CreateSoftShadow(title)

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
title.style.color:SetVertexColor(classColor.r, classColor.g, classColor.b)
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

function MER:OnCheckVersion(self)
	if not MerathilisUIData["Version"] or (MerathilisUIData["Version"] and MerathilisUIData["Version"] ~= MER.Version) then
		MerathilisUIData["Version"] = MER.Version
		MerathilisUIChangeLog:Show()
	end
end

ChangeLog:RegisterEvent("PLAYER_ENTERING_WORLD")
ChangeLog:SetScript("OnEvent", function(self, event, ...)
	MER:OnCheckVersion()
end)