local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule("MerathilisUI");
local AFK = E:GetModule("AFK")
local muiAFK = E:NewModule("muiAFK");

-- Cache global variables
-- WoW API / Variables
local CreateFrame = CreateFrame
local GetScreenWidth, GetScreenHeight = GetScreenWidth, GetScreenHeight
local IsAddOnLoaded = IsAddOnLoaded
local PlaySound = PlaySound

local npc = 15358 -- Lurky

function muiAFK:Initialize()
	if E.db.general.afk ~= true or not IsAddOnLoaded("ElvUI_BenikUI") or E.db.mui.general.AFK ~= true then return; end

	-- NPC Model
	AFK.AFKMode.bottom.npcHolder = CreateFrame("Frame", nil, AFK.AFKMode.bottom)
	AFK.AFKMode.bottom.npcHolder:SetSize(150, 150)
	AFK.AFKMode.bottom.npcHolder:SetPoint("BOTTOMLEFT", AFK.AFKMode.bottom, "BOTTOMLEFT", 200, 100)

	AFK.AFKMode.bottom.npc = CreateFrame("PlayerModel", "ElvUIAFKNPCModel", AFK.AFKMode.bottom.npcHolder)
	AFK.AFKMode.bottom.npc:SetCreature(npc)
	AFK.AFKMode.bottom.npc:SetPoint("CENTER", AFK.AFKMode.bottom.npcHolder, "CENTER")
	AFK.AFKMode.bottom.npc:SetSize(GetScreenWidth() * 2, GetScreenHeight() * 2)
	AFK.AFKMode.bottom.npc:SetCamDistanceScale(6)
	AFK.AFKMode.bottom.npc:SetFacing(6.9)
	AFK.AFKMode.bottom.npc:SetAnimation(69)
	AFK.AFKMode.bottom.npc:SetFrameStrata("HIGH")
	AFK.AFKMode.bottom.npc:SetScript("OnShow", function()
	PlaySound("MurlocAggro", "Master")
	end)
	AFK.AFKMode.bottom.npc:Show()

	-- MerathilisUI Name
	AFK.AFKMode.bottom.merathilisui = AFK.AFKMode.top:CreateFontString(nil, "OVERLAY")
	AFK.AFKMode.bottom.merathilisui:FontTemplate(nil, 24)
	AFK.AFKMode.bottom.merathilisui:SetText("MerathilisUI")
	AFK.AFKMode.bottom.merathilisui:SetPoint("LEFT", AFK.AFKMode.bottom, "LEFT", 130, 8)
	AFK.AFKMode.bottom.merathilisui:SetTextColor(MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b)

	-- Version
	AFK.AFKMode.bottom.btext = AFK.AFKMode.top:CreateFontString(nil, "OVERLAY")
	AFK.AFKMode.bottom.btext:FontTemplate(nil, 10)
	AFK.AFKMode.bottom.btext:SetFormattedText("v%s", MER.Version)
	AFK.AFKMode.bottom.btext:SetPoint("TOP", AFK.AFKMode.bottom.merathilisui, "BOTTOM")
	AFK.AFKMode.bottom.btext:SetTextColor(0.7, 0.7, 0.7)
end

E:RegisterModule(muiAFK:GetName());
