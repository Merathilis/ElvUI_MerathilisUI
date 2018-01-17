local MER, E, L, V, P, G = unpack(select(2, ...))
local AFK = E:GetModule("AFK")

-- Cache global variables
-- WoW API / Variables
local CreateFrame = CreateFrame
local GetScreenWidth, GetScreenHeight = GetScreenWidth, GetScreenHeight
local IsAddOnLoaded = IsAddOnLoaded

local npc = 15358 -- Lurky

AFK.InitializemUIAFK = AFK.Initialize
function AFK:Initialize()
	if E.db.general.afk ~= true or E.db.mui.general.AFK ~= true then return end
	self:InitializemUIAFK()

	if IsAddOnLoaded("ElvUI_BenikUI") then
		-- WoW logo
		self.AFKMode.top.wowlogo:Hide() -- Hide BenikUIs top logo

		-- mUI logo
		self.AFKMode.top.logo = CreateFrame("Frame", nil, self.AFKMode) -- need this to upper the logo layer
		self.AFKMode.top.logo:SetPoint("TOP", self.AFKMode.top, "TOP", 0, -5)
		self.AFKMode.top.logo:SetFrameStrata("MEDIUM")
		self.AFKMode.top.logo:Size(120, 120)
		self.AFKMode.top.logo.tex = self.AFKMode.top.logo:CreateTexture(nil, "OVERLAY")
		self.AFKMode.top.logo.tex:SetTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\mUI1.tga")
		self.AFKMode.top.logo.tex:SetInside()

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
end