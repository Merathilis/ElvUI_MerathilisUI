local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_UnitFrames')
local S = MER:GetModule('MER_Skins')
local UF = E.UnitFrames

local hooksecurefunc = hooksecurefunc

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
