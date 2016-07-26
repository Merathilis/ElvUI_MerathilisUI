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
-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: UISpecialFrames

local ChangeLog = CreateFrame("frame")
local ChangeLogData = [=[|cffff7d0av2.03|r, 25.07.2016

|cffff7d0a•|r Remove GameMenu Button. (ElvUI's Button is enough) 
|cffff7d0a•|r Fix a lua error in speccswitch datatext if there is no texture selected. 
|cffff7d0a•|r Install: Add missing settings for ActionBar6. (damn it) 
|cffff7d0a•|r Skins: Delete skining of SLE, will be part in BenikUI. 
|cffff7d0a•|r Skins: Add skins for gossip frame & quest frame (taken from AddOnSkins)]=];

local frame = CreateFrame("Frame", "MerathilisUIChangeLog", E.UIParent)
frame:SetPoint("CENTER")
frame:SetSize(400, 300)
frame:SetTemplate("Transparent")
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
frame:SetClampedToScreen(true)
frame:Hide()

local title = CreateFrame("Frame", nil, frame)
title:SetPoint("BOTTOM", frame, "TOP", 0, 3)
title:SetSize(400, 20)
title:SetTemplate("Transparent")
title.text = title:CreateFontString(nil, "OVERLAY")
title.text:SetPoint("CENTER", title, 0, 0)
title.text:SetFont(LSM:Fetch("font", 'Merathilis Prototype'), 16, 'OUTLINE')
title.text:SetText("|cffff7d0aMerathilisUI|r - ChangeLog " .. MER.Version)

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
data:FontTemplate(E['media'].muiFont, 11)
data:SetText(ChangeLogData)
frame:SetHeight(data:GetHeight() + 30)

function MER:ToggleChangeLog()
	if MerathilisUIChangeLog:IsShown() then
		MerathilisUIChangeLog:Hide()
	else
		MerathilisUIChangeLog:Show()
	end
end
