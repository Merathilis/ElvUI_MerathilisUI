local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_UnitFrames')
local S = MER:GetModule('MER_Skins')
local UF = E.UnitFrames

local hooksecurefunc = hooksecurefunc

local MAX_BOSS_FRAMES = 8
local units = { "Player", "Target", "Focus", "Pet" }

function module:Configure_Castbar(frame)
	if not frame.Castbar then
		return
	end

	local db = frame.db.castbar

	if frame.Castbar.backdrop and not  frame.Castbar.__MERSkin then
		frame.Castbar.backdrop:Styling(false, false, true)
		frame.Castbar.__MERSkin = true
	end

	if not frame.Castbar.MERShadowBackdrop then
		frame.Castbar.MERShadowBackdrop = CreateFrame("Frame", nil, frame.Castbar)
		frame.Castbar.MERShadowBackdrop:SetFrameStrata(frame.Castbar.backdrop:GetFrameStrata())
		frame.Castbar.MERShadowBackdrop:SetFrameLevel(frame.Castbar.backdrop:GetFrameLevel() or 1)
	end

	local MERBg = frame.Castbar.MERShadowBackdrop
	local iconBg = frame.Castbar.ButtonIcon.bg

	if not db.iconAttached then
		if not MERBg.mode or MERBg.mode ~= "NotAttach" then
			-- Icon shadow
			S:CreateShadow(frame.Castbar.ButtonIcon.bg)
			if frame.Castbar.ButtonIcon.bg.MERshadow then
				frame.Castbar.ButtonIcon.bg.MERshadow:Show()
			end

			-- Bar shadow
			MERBg:ClearAllPoints()
			MERBg:SetAllPoints(frame.Castbar.backdrop)
			MERBg.mode = "NotAttach"
		end
	else
		if not MERBg.mode or MERBg.mode ~= "Attach" then
			-- Disable icon shadow
			if frame.Castbar.ButtonIcon.bg.MERshadow then
				frame.Castbar.ButtonIcon.bg.MERshadow:Hide()
			end

			if frame.ORIENTATION == "LEFT" then
				-- |-- Icon --| ---------------- Time Bar ---------------|
				-- |---------------- MERShadowBackdrop ------------------|
				MERBg:ClearAllPoints()
				MERBg:Point("TOPRIGHT", frame.Castbar.backdrop, "TOPRIGHT")
				MERBg:Point("BOTTOMRIGHT", frame.Castbar.backdrop, "BOTTOMRIGHT")
				MERBg:Point("TOPLEFT", iconBg, "TOPLEFT")
				MERBg:Point("BOTTOMLEFT", iconBg, "BOTTOMLEFT")
				MERBg.mode = "Attach"
			elseif frame.ORIENTATION == "RIGHT" then
				-- |----------------- Time Bar ---------------|-- Icon --|
				-- |---------------- MERShadowBackdrop ------------------|
				MERBg:ClearAllPoints()
				MERBg:Point("TOPLEFT", frame.Castbar.backdrop, "TOPLEFT")
				MERBg:Point("BOTTOMLEFT", frame.Castbar.backdrop, "BOTTOMLEFT")
				MERBg:Point("TOPRIGHT", iconBg, "TOPRIGHT")
				MERBg:Point("BOTTOMRIGHT", iconBg, "BOTTOMRIGHT")
				MERBg.mode = "Attach"
			end
		end
	end

	S:CreateShadow(MERBg)
end

local function ConfigureCastbarSpark(unit, unitframe)
	local castbar = unitframe.Castbar
	if not castbar then
		return
	end

	local db = E.db.mui and E.db.mui.unitframes and E.db.mui.unitframes.castbar and E.db.mui.unitframes.castbar.spark

	castbar.Spark_:SetTexture(E.LSM:Fetch('statusbar', db.texture))
	castbar.Spark_:SetBlendMode('BLEND')
	castbar.Spark_:SetWidth(db.width or 3)
	castbar.Spark_:SetVertexColor(db.color.r, db.color.g, db.color.b, db.color.a or 1, 1, 1, 1)
end

local function ConfigureCastbar(unit, unitframe)
	local db = E.db.unitframe.units[unit].castbar

	if unit == 'player' or unit == 'target' then
		ConfigureCastbarSpark(unit, unitframe)
	end
end

function module:UpdateSettings(unit)
	if unit then
		local unitFrameName = 'ElvUF_'..E:StringTitle(unit)
		local unitframe = _G[unitFrameName]
		ConfigureCastbar(unit, unitframe)
	end
end

function module:UpdateAllCastbars()
	local db = E.db.mui and E.db.mui.unitframes and E.db.mui.unitframes.castbar

	if not db.enable or not db.spark.enable then
		return
	end

	module:UpdateSettings('player')
	module:UpdateSettings('target')
	module:UpdateSettings('focus')
	module:UpdateSettings('pet')

	if not E.Classic then
		module:UpdateSettings('arena')
		module:UpdateSettings('boss')
	end
end

function module:PostCast(unit, unitframe)
	local db = E.db.mui and E.db.mui.unitframes and E.db.mui.unitframes.castbar
	local castTexture = E.LSM:Fetch("statusbar", db.texture)
	local _, class = UnitClass(unit)

	if not self.isTransparent then
		self:SetStatusBarTexture(castTexture)
	end

	if not self.notInterruptible then
		if E.Retail then
			self:GetStatusBarTexture():SetGradient("HORIZONTAL", CreateColor(F.ClassGradient[class].r2, F.ClassGradient[class].g2, F.ClassGradient[class].b2, 1), CreateColor(F.ClassGradient[class].r1, F.ClassGradient[class].g1, F.ClassGradient[class].b1, 1))
		else
			self:GetStatusBarTexture():SetGradientAlpha("HORIZONTAL", F.ClassGradient[class].r2, F.ClassGradient[class].g2, F.ClassGradient[class].b2, 1, F.ClassGradient[class].r1, F.ClassGradient[class].g1, F.ClassGradient[class].b1, 1)
		end
	elseif self.notInterruptible then
		if E.Retail then
			self:GetStatusBarTexture():SetGradient("HORIZONTAL", CreateColor(F.ClassGradient["BADTHREAT"].r2, F.ClassGradient["BADTHREAT"].g2, F.ClassGradient["BADTHREAT"].b2, 1), CreateColor(F.ClassGradient["BADTHREAT"].r1, F.ClassGradient["BADTHREAT"].g1, F.ClassGradient["BADTHREAT"].b1, 1))
		else
			self:GetStatusBarTexture():SetGradientAlpha("HORIZONTAL", F.ClassGradient["BADTHREAT"].r2, F.ClassGradient["BADTHREAT"].g2, F.ClassGradient["BADTHREAT"].b2, 1, F.ClassGradient["BADTHREAT"].r1, F.ClassGradient["BADTHREAT"].g1, F.ClassGradient["BADTHREAT"].b1, 1)
		end
	end
end

function module:PostCastInterruptible(unit, unitframe)
	local db = E.db.mui and E.db.mui.unitframes and E.db.mui.unitframes.castbar
	if unit == "vehicle" or unit == "player" then return end

	local castTexture = E.LSM:Fetch("statusbar", db.texture)

	if not self.isTransparent then
		self:SetStatusBarTexture(castTexture)
	end

	if not self.notInterruptible then
		if E.Retail then
			self:GetStatusBarTexture():SetGradient("HORIZONTAL", CreateColor(F.ClassGradient[class].r2, F.ClassGradient[class].g2, F.ClassGradient[class].b2, 1), CreateColor(F.ClassGradient[class].r1, F.ClassGradient[class].g1, F.ClassGradient[class].b1, 1))
		else
			self:GetStatusBarTexture():SetGradientAlpha("HORIZONTAL", F.ClassGradient[class].r2, F.ClassGradient[class].g2, F.ClassGradient[class].b2, 1, F.ClassGradient[class].r1, F.ClassGradient[class].g1, F.ClassGradient[class].b1, 1)
		end
	elseif self.notInterruptible then
		if E.Retail then
			self:GetStatusBarTexture():SetGradient("HORIZONTAL", CreateColor(F.ClassGradient["BADTHREAT"].r2, F.ClassGradient["BADTHREAT"].g2, F.ClassGradient["BADTHREAT"].b2, 1), CreateColor(F.ClassGradient["BADTHREAT"].r1, F.ClassGradient["BADTHREAT"].g1, F.ClassGradient["BADTHREAT"].b1, 1))
		else
			self:GetStatusBarTexture():SetGradientAlpha("HORIZONTAL", F.ClassGradient["BADTHREAT"].r2, F.ClassGradient["BADTHREAT"].g2, F.ClassGradient["BADTHREAT"].b2, 1, F.ClassGradient["BADTHREAT"].r1, F.ClassGradient["BADTHREAT"].g1, F.ClassGradient["BADTHREAT"].b1, 1)
		end
	end
end

function module:CastBarHooks()
	local db = E.db.mui and E.db.mui.unitframes and E.db.mui.unitframes.castbar

	if db and not db.enable then
		return
	end

	for _, unit in pairs(units) do
		local unitframe = _G["ElvUF_" .. unit]
		local castbar = unitframe and unitframe.Castbar
		if castbar then
			hooksecurefunc(castbar, "PostCastStart", module.PostCast)
			hooksecurefunc(castbar, "PostCastInterruptible", module.PostCastInterruptible)
		end
	end

	if not E.Classic then
		for i = 1, 5 do
			local castbar = _G["ElvUF_Arena" .. i].Castbar
			if castbar then
				hooksecurefunc(castbar, "PostCastStart", module.PostCast)
				hooksecurefunc(castbar, "PostCastInterruptible", module.PostCastInterruptible)
			end
		end

		for i = 1, MAX_BOSS_FRAMES do
			local castbar = _G["ElvUF_Boss" .. i].Castbar
			if castbar then
				hooksecurefunc(castbar, "PostCastStart", module.PostCast)
				hooksecurefunc(castbar, "PostCastInterruptible", module.PostCastInterruptible)
			end
		end
	end
end
