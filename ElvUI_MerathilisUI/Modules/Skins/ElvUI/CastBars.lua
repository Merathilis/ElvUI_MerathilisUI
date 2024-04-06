local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local UF = E:GetModule("UnitFrames")

local _G = _G

local CreateFrame = CreateFrame

function module:ElvUI_UnitFrames_SkinCastBar(_, frame)
	if not frame.Castbar then
		return
	end

	local db = frame.db.castbar

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
			self:CreateShadow(frame.Castbar.ButtonIcon.bg)
			if frame.Castbar.ButtonIcon.bg.shadow then
				frame.Castbar.ButtonIcon.bg.shadow:Show()
			end

			-- Bar shadow
			MERBg:ClearAllPoints()
			MERBg:SetAllPoints(frame.Castbar.backdrop)

			MERBg.mode = "NotAttach"
		end
	else
		if not MERBg.mode or MERBg.mode ~= "Attach" then
			-- Disable icon shadow
			if frame.Castbar.ButtonIcon.bg.shadow then
				frame.Castbar.ButtonIcon.bg.shadow:Hide()
			end

			-- |-- Icon --| ---------------- Time Bar ---------------|
			-- |---------------- MERShadowBackdrop ------------------|
			MERBg:ClearAllPoints()
			MERBg:Point("TOPRIGHT", frame.Castbar.backdrop, "TOPRIGHT")
			MERBg:Point("BOTTOMRIGHT", frame.Castbar.backdrop, "BOTTOMRIGHT")
			MERBg:Point("TOPLEFT", iconBg, "TOPLEFT")
			MERBg:Point("BOTTOMLEFT", iconBg, "BOTTOMLEFT")

			MERBg.mode = "Attach"
		end
	end

	self:CreateShadow(MERBg)
end

function module:ElvUI_CastBars()
	if not E.private.unitframe.enable then
		return
	end

	self:SecureHook(UF, "Configure_Castbar", "ElvUI_UnitFrames_SkinCastBar")
end

module:AddCallback("ElvUI_CastBars")
