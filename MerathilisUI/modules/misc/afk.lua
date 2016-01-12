local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local AFK = E:GetModule('AFK');

-- Cache global variables
local CreateFrame = CreateFrame
local GetScreenWidth, GetScreenHeight = GetScreenWidth, GetScreenHeight
local IsAddOnLoaded = IsAddOnLoaded

if not IsAddOnLoaded("ElvUI_BenikUI") then return end;

local SPACING = (E.PixelMode and 1 or 5)
local classColor = RAID_CLASS_COLORS[E.myclass]
local npc = 15358 -- Lurky

AFK.InitializeMerAfk = AFK.Initialize
function AFK:Initialize()
	self:InitializeMerAfk()
	
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
	self.AFKMode.bottom.npc:SetScript("OnShow", function()
		PlaySound("MurlocAggro", "Master")
	end)
	self.AFKMode.bottom.npc:Show()
	
	-- MerathilisUI Name
	self.AFKMode.bottom.merathilisui = self.AFKMode.top:CreateFontString(nil, 'OVERLAY')
	self.AFKMode.bottom.merathilisui:FontTemplate(nil, 24)
	self.AFKMode.bottom.merathilisui:SetText("MerathilisUI")
	self.AFKMode.bottom.merathilisui:SetPoint("LEFT", self.AFKMode.bottom, "LEFT", 130, 8)
	self.AFKMode.bottom.merathilisui:SetTextColor(classColor.r, classColor.g, classColor.b)
	-- Version
	self.AFKMode.bottom.btext = self.AFKMode.top:CreateFontString(nil, 'OVERLAY')
	self.AFKMode.bottom.btext:FontTemplate(nil, 10)
	self.AFKMode.bottom.btext:SetFormattedText("v%s", MER.Version)
	self.AFKMode.bottom.btext:SetPoint("TOP", self.AFKMode.bottom.merathilisui, "BOTTOM")
	self.AFKMode.bottom.btext:SetTextColor(0.7, 0.7, 0.7)
end
