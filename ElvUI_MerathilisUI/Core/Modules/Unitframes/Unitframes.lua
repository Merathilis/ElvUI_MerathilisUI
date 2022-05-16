local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_UnitFrames')
local UF = E:GetModule('UnitFrames')

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc

function module:ADDON_LOADED(event, addon)
	if addon ~= "ElvUI_Config" then return end

	module:UnregisterEvent(event)
end

function module:CreateHighlight(self)
	if not E.db.mui.unitframes.highlight then return end

	local hl = self:CreateTexture(nil, "BACKGROUND")
	hl:SetAllPoints()
	hl:SetTexture("Interface\\PETBATTLES\\PetBattle-SelectedPetGlow")
	hl:SetTexCoord(0, 1, .5, 1)
	hl:SetVertexColor(1, 1, .6)
	hl:SetBlendMode("ADD")
	hl:Hide()
	self.Highlight = hl

	self:HookScript("OnEnter", function()
		self.Highlight:Show()
	end)
	self:HookScript("OnLeave", function()
		self.Highlight:Hide()
	end)
end

function module:UnitFrames_UpdateNameSettings(_, f)
	if f.shadow then return end

	MER:CreateBackdropShadow(f.Health, true)
end

function module:UnitFrames_Configure_Threat(_, f)
	if f.shadow then return end

	local threat = f.ThreatIndicator
	if not threat then return end

	threat.PostUpdate = function(self, unit, status, r, g, b)
		UF.UpdateThreat(self, unit, status, r, g, b)
		local parent = self:GetParent()
		if not unit or parent.unit ~= unit then
			return
		end
		if parent.db and parent.db.threatStyle == "GLOW" then
			if parent.Health and parent.Health.backdrop and parent.Health.backdrop.shadow then
				parent.Health.backdrop.shadow:SetShown(not threat.MainGlow:IsShown())
			end
			if parent.Power and parent.Power.backdrop and parent.Power.backdrop.shadow and parent.USE_POWERBAR_OFFSET then
				parent.Power.backdrop.shadow:SetShown(not threat.MainGlow:IsShown())
			end
		end
	end
end

function module:UnitFrames_Configure_Power(_, f)
	if f.shadow then return end

	if f.USE_POWERBAR then
		local shadow = f.Power.backdrop.shadow
		if f.POWERBAR_DETACHED then
			if not shadow then
				MER:CreateBackdropShadow(f.Power, true)
			else
				shadow:Show()
			end
		else
			if shadow then
				shadow:Hide()
			end
		end
	end
end

function module:UnitFrames_Configure_ClassBar(_, f)
	if f.shadow then return end

	local bars = f[f.ClassBar]
	if bars and not bars.backdrop.shadow then
		MER:CreateShadow(bars.backdrop)
	end

	if f.shadow then
		f.shadow:ClearAllPoints()
		if f.USE_MINI_CLASSBAR and not f.CLASSBAR_DETACHED then
			f.shadow:Point('TOPLEFT', f.Health.backdrop, 'TOPLEFT')
			f.shadow:Point('BOTTOMRIGHT', f, 'BOTTOMRIGHT')
			bars.backdrop.shadow:Show()
		elseif not f.CLASSBAR_DETACHED then
			bars.backdrop.shadow:Hide()
		else
			bars.backdrop.shadow:Show()
		end
	end
end

function module:UnitFrames_UpdateAuraSettings(_, _, a)
	MER:CreateShadow(a)
end

function module:CreateUFShadows()
	self:SecureHook(UF, "UpdateNameSettings", "UnitFrames_UpdateNameSettings")
	self:SecureHook(UF, "Configure_Threat", "UnitFrames_Configure_Threat")
	self:SecureHook(UF, "Configure_Power", "UnitFrames_Configure_Power")
	self:SecureHook(UF, "Configure_ClassBar", "UnitFrames_Configure_ClassBar")
	self:SecureHook(UF, "UpdateAuraSettings", "UnitFrames_UpdateAuraSettings")
end

function module:StyleUFs()
	local db = E.db.mui.unitframes

	-- Player
	self:InitPlayer()
	self:InitPower()
	self:InitCastBar()

	-- Target
	self:InitTarget()

	-- TargetTarget
	self:InitTargetTarget()

	-- Pet
	self:InitPet()

	-- Focus
	self:InitFocus()

	-- FocusTarget
	self:InitFocusTarget()

	-- Party
	self:InitParty()

	-- Raid
	self:InitRaid()

	-- Raid40
	self:InitRaid40()

	-- Boss
	self:InitBoss()

	--Shadows
	self:CreateUFShadows()
end

function module:Initialize()
	if E.private.unitframe.enable ~= true then return end

	local db = E.db.mui.unitframes

	-- Units
	self:StyleUFs()

	-- RaidIcons
	hooksecurefunc(UF, "Configure_RaidIcon", module.Configure_RaidIcon)

	-- Auras
	self:LoadAuras()

	-- RoleIcons
	self:Configure_RoleIcons()

	self:RegisterEvent("ADDON_LOADED")
end

MER:RegisterModule(module:GetName())
