local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local AFK = E:GetModule('AFK')
local LSM = LibStub('LibSharedMedia-3.0')
local MER = E:GetModule('MerathilisUI');

local SPACING = (E.PixelMode and 1 or 5)

local classColor = RAID_CLASS_COLORS[E.myclass]

AFK.InitializeMerAfk = AFK.Initialize
if IsAddOnLoaded("ElvUI_BenikUI") then
	function AFK:Initialize()
		self:InitializeMerAfk()
		
		-- MerathilisUI Name
		self.AFKMode.top.merathilisui = self.AFKMode.top:CreateFontString(nil, 'OVERLAY')
		self.AFKMode.top.merathilisui:FontTemplate(nil, 24, 'OUTLINE')
		self.AFKMode.top.merathilisui:SetText("MerathilisUI")
		self.AFKMode.top.merathilisui:SetPoint("CENTER", self.AFKMode.top, "CENTER", 0, -120)
		self.AFKMode.top.merathilisui:SetTextColor(classColor.r, classColor.g, classColor.b)
		-- Version
		self.AFKMode.top.btext = self.AFKMode.top:CreateFontString(nil, 'OVERLAY')
		self.AFKMode.top.btext:FontTemplate(nil, 14)
		self.AFKMode.top.btext:SetText(format("v%s", MER.Version))
		self.AFKMode.top.btext:SetPoint("TOP", self.AFKMode.top.merathilisui, "BOTTOM")
		self.AFKMode.top.btext:SetTextColor(colors.white)
	end
end
