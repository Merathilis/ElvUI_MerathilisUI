local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
if not IsAddOnLoaded("ElvUI_BenikUI") then return end;

local MER = E:GetModule('MerathilisUI');
local AFK = E:GetModule('AFK')

local SPACING = (E.PixelMode and 1 or 5)

local classColor = RAID_CLASS_COLORS[E.myclass]

AFK.InitializeMerAfk = AFK.Initialize
function AFK:Initialize()
	self:InitializeMerAfk()
	
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
