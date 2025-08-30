local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local UF = E:GetModule("UnitFrames")

local _G = _G
local ipairs = ipairs

local CreateFrame = CreateFrame

function module:ElvUI_UnitFrames_UpdateNameSettings(_, f)
	if not E.private.mui.skins.enable or not E.private.mui.skins.shadow.enable then
		return
	end

	if f.Health.backdrop and not f.Health.backdrop.MERshadow then
		self:CreateBackdropShadow(f.Health, true) -- only gets created on the Health Element, might look like shit with Power/InfoPanel enabled
	end
end

function module:ElvUI_UnitFrames_Configure_Threat(_, f)
	local threat = f.ThreatIndicator
	if not threat then
		return
	end
	threat.PostUpdate = function(self, unit, status, r, g, b)
		UF.UpdateThreat(self, unit, status, r, g, b)
		local parent = self:GetParent()
		if not unit or parent.unit ~= unit then
			return
		end
		if parent.db and parent.db.threatStyle == "GLOW" then
			if parent.Health and parent.Health.backdrop and parent.Health.backdrop.MERshadow then
				parent.Health.backdrop.MERshadow:SetShown(not threat.MainGlow:IsShown())
			end
			if
				parent.Power
				and parent.Power.backdrop
				and parent.Power.backdrop.MERshadow
				and parent.USE_POWERBAR_OFFSET
			then
				parent.Power.backdrop.MERshadow:SetShown(not threat.MainGlow:IsShown())
			end
		end
	end
end

function module:ElvUI_UnitFrames_Configure_Power(_, f)
	if f.USE_POWERBAR then
		local shadow = f.Power.backdrop.MERshadow
		if f.USE_MINI_POWERBAR or f.USE_POWERBAR_OFFSET then
			if not shadow then
				self:CreateBackdropShadow(f, true)
			else
				shadow:Show()
			end
		elseif f.USE_INSET_POWERBAR or f.POWERBAR_DETACHED then
			if not shadow then
				self:CreateBackdropShadow(f.Power, true)
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

function module:ElvUI_UnitFrames_PostUpdateAura(uf, _, button)
	if uf.isNameplate then
		return
	end

	if not button.__MERSkin then
		self:CreateLowerShadow(button)
		self:BindShadowColorWithBorder(button)

		button.__MERSkin = true
	end
end

function module:ElvUI_UnitFrames_Configure_AuraBars(_, f)
	local auraBars = f.AuraBars
	local db = f.db
	if db.aurabar.enable then
		for _, statusBar in ipairs(auraBars) do
			self:ElvUI_UnitFrames_Construct_AuraBars(nil, statusBar)
		end
	end
end

function module:ElvUI_UnitFrames_Construct_AuraBars(_, f)
	if f.MERShadowBackdrop then
		return
	end

	f.MERShadowBackdrop = CreateFrame("Frame", nil, f)
	f.MERShadowBackdrop:SetFrameStrata(f:GetFrameStrata())
	f.MERShadowBackdrop:OffsetFrameLevel(1, f)

	-- |-- Icon --| --------------- Status Bar ---------------|
	-- |----------------- MERShadowBackdrop ------------------|

	-- Right
	f.MERShadowBackdrop:Point("TOPRIGHT", f, "TOPRIGHT", 1, -1)
	f.MERShadowBackdrop:Point("BOTTOMRIGHT", f, "BOTTOMRIGHT", 1, 1)

	-- Left
	if f.icon and f.icon:IsShown() then
		f.MERShadowBackdrop:Point("TOPLEFT", f.icon, "TOPLEFT", -1, 1)
		f.MERShadowBackdrop:Point("BOTTOMLEFT", f.icon, "BOTTOMLEFT", -1, -1)
	else
		f.MERShadowBackdrop:Point("TOPLEFT", f, "TOPLEFT", -1, 1)
		f.MERShadowBackdrop:Point("BOTTOMLEFT", f, "BOTTOMLEFT", -1, -1)
	end

	self:CreateShadow(f.MERShadowBackdrop)
end

function module:ElvUI_UnitFrames()
	if not E.private.unitframe.enable then
		return
	end

	-- Update shadow of unit frames with low frequency
	self:SecureHook(UF, "UpdateNameSettings", "ElvUI_UnitFrames_UpdateNameSettings")

	-- Auto hide/show shadow on oUF updating threat
	self:SecureHook(UF, "Configure_Threat", "ElvUI_UnitFrames_Configure_Threat")

	-- Separated power bar
	self:SecureHook(UF, "Configure_Power", "ElvUI_UnitFrames_Configure_Power")

	-- Auras
	self:SecureHook(UF, "PostUpdateAura", "ElvUI_UnitFrames_PostUpdateAura")

	-- Status bar
	self:SecureHook(UF, "Configure_AuraBars", "ElvUI_UnitFrames_Configure_AuraBars")
	self:SecureHook(UF, "Construct_AuraBars", "ElvUI_UnitFrames_Construct_AuraBars")
end

module:AddCallback("ElvUI_UnitFrames")
