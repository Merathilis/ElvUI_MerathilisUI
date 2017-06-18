local E, L, V, P, G = unpack(ElvUI);
local MUF = E:GetModule("muiUnits");
local UF = E:GetModule("UnitFrames");

function MUF:Configure_Portrait(frame, isPlayer)
	local portrait = frame.Portrait
	local db = frame.db

	if frame.USE_PORTRAIT then
		if frame.USE_PORTRAIT_OVERLAY then
			if db.portrait.style == "3D" then
				portrait:SetFrameLevel(frame.Health:GetFrameLevel())
			else
				portrait:SetParent(frame.Health)
			end

			portrait:SetAllPoints(frame.Health)
			portrait:SetAlpha(0.3)
			portrait.backdrop:Hide()
		else
			portrait:SetAlpha(1)
			portrait.backdrop:ClearAllPoints()
			portrait.backdrop:Show()

			if db.portrait.style == "3D" then
				portrait:SetFrameLevel(frame.Health:GetFrameLevel() -4) --Make sure portrait is behind Health and Power
			else
				portrait:SetParent(frame)
			end

			if frame.PORTRAIT_TRANSPARENCY then
				portrait.backdrop:SetTemplate("Transparent")
			else
				portrait.backdrop:SetTemplate('Default', true)
			end

			if portrait.backdrop.style then
				if frame.PORTRAIT_STYLING then
					portrait.backdrop.style:ClearAllPoints()
					portrait.backdrop.style:Point("TOPLEFT", portrait, "TOPLEFT", (E.PixelMode and -1 or -2), frame.PORTRAIT_STYLING_HEIGHT)
					portrait.backdrop.style:Point("BOTTOMRIGHT", portrait, "TOPRIGHT", (E.PixelMode and 1 or 2), (E.PixelMode and 0 or 2))
					portrait.backdrop.style:Show()

					if isPlayer then
						if frame.USE_POWERBAR then
							local r, g, b = frame.Power:GetStatusBarColor()
							portrait.backdrop.style:SetBackdropColor(r, g, b, (E.db.mui.colors.styleAlpha or 1))
						end
					end
				else
					portrait.backdrop.style:Hide()
				end
			end

			if frame.PORTRAIT_DETACHED then
				frame.portraitmover:Width(frame.DETACHED_PORTRAIT_WIDTH)
				frame.portraitmover:Height(frame.DETACHED_PORTRAIT_HEIGHT)
				portrait.backdrop:SetAllPoints(frame.portraitmover)

				if portrait.backdrop.shadow then
					if frame.PORTRAIT_SHADOW then
						portrait.backdrop.shadow:Show()
					else
						portrait.backdrop.shadow:Hide()
					end
				end

				if db.portrait.style == "3D" then
					portrait.backdrop:SetFrameStrata(frame.DETACHED_PORTRAIT_STRATA)
					portrait:SetFrameStrata(portrait.backdrop:GetFrameStrata())
				end
				
				if not frame.portraitmover.mover then
					frame.portraitmover:ClearAllPoints()
					if frame.unit == "player" then
						frame.portraitmover:Point("TOPRIGHT", frame, "TOPLEFT", -frame.BORDER, 0)
						E:CreateMover(frame.portraitmover, "mUIPlayerPortraitMover", L["Player Portrait"], nil, nil, nil, "ALL,SOLO")
					elseif frame.unit == "target" then
						frame.portraitmover:Point("TOPLEFT", frame, "TOPRIGHT", frame.BORDER, 0)
						E:CreateMover(frame.portraitmover, "mUITargetPortraitMover", L["Target Portrait"], nil, nil, nil, "ALL,SOLO")
					end
					frame.portraitmover:ClearAllPoints()
					frame.portraitmover:SetPoint("BOTTOMLEFT", frame.portraitmover.mover, "BOTTOMLEFT")
				else
					frame.portraitmover:ClearAllPoints()
					frame.portraitmover:SetPoint("BOTTOMLEFT", frame.portraitmover.mover, "BOTTOMLEFT")
				end
			else
				portrait:SetAlpha(1)
				portrait.backdrop:Show()
				if db.portrait.style == '3D' then
					portrait.backdrop:SetFrameStrata(frame:GetFrameStrata())
					portrait:SetFrameStrata(portrait.backdrop:GetFrameStrata())
					portrait:SetFrameLevel(frame.Health:GetFrameLevel() -4) --Make sure portrait is behind Health and Power
				end

				if frame.ORIENTATION == "LEFT" then
					portrait.backdrop:Point("TOPLEFT", frame, "TOPLEFT", frame.SPACING, frame.PORTRAIT_HEIGHT or frame.USE_MINI_CLASSBAR and -(frame.CLASSBAR_YOFFSET+frame.SPACING) or -frame.SPACING)
					if frame.PORTRAIT_AND_INFOPANEL then
						portrait.backdrop:Point("BOTTOMRIGHT", frame.InfoPanel, "BOTTOMLEFT", - frame.SPACING*3, -frame.BORDER)
					elseif frame.USE_MINI_POWERBAR or frame.USE_POWERBAR_OFFSET or not frame.USE_POWERBAR or frame.USE_INSET_POWERBAR or frame.POWERBAR_DETACHED then
						portrait.backdrop:Point("BOTTOMRIGHT", frame.Health.backdrop, "BOTTOMLEFT", frame.BORDER - frame.SPACING*3, 0)
					else
						portrait.backdrop:Point("BOTTOMRIGHT", frame.Power.backdrop, "BOTTOMLEFT", frame.BORDER - frame.SPACING*3, 0)
					end
				elseif frame.ORIENTATION == "RIGHT" then
					portrait.backdrop:Point("TOPRIGHT", frame, "TOPRIGHT", -frame.SPACING, frame.PORTRAIT_HEIGHT or frame.USE_MINI_CLASSBAR and -(frame.CLASSBAR_YOFFSET+frame.SPACING) or -frame.SPACING)
					if frame.PORTRAIT_AND_INFOPANEL then
						portrait.backdrop:Point("BOTTOMLEFT", frame.InfoPanel, "BOTTOMRIGHT", frame.SPACING*3, -frame.BORDER)
					elseif frame.USE_MINI_POWERBAR or frame.USE_POWERBAR_OFFSET or not frame.USE_POWERBAR or frame.USE_INSET_POWERBAR or frame.POWERBAR_DETACHED then
						portrait.backdrop:Point("BOTTOMLEFT", frame.Health.backdrop, "BOTTOMRIGHT", -frame.BORDER + frame.SPACING*3, 0)
					else
						portrait.backdrop:Point("BOTTOMLEFT", frame.Power.backdrop, "BOTTOMRIGHT", -frame.BORDER + frame.SPACING*3, 0)
					end
				end
			end
			portrait:SetInside(portrait.backdrop, frame.BORDER)
		end
	end
end

-- Portrait Alpha setting. Idea: Vxt, Credit: Blazeflack
local function OnConfigure_Portrait(self, frame)
	if frame.USE_PORTRAIT then
		local portrait = frame.Portrait
		if frame.USE_PORTRAIT_OVERLAY then
			portrait:SetAlpha(E.db.mui.unitframes.misc.portraitTransparency)
		else
			portrait:SetAlpha(1)
		end
	end
end

local function OnPortraitUpdate(self)
	local frame = self:GetParent()
	local db = frame.db
	if not db then return end

	if frame.USE_PORTRAIT_OVERLAY then
		self:SetAlpha(E.db.mui.unitframes.misc.portraitTransparency)
	else
		self:SetAlpha(1)
	end
end

hooksecurefunc(UF, "Configure_Portrait", OnConfigure_Portrait)
hooksecurefunc(UF, "PortraitUpdate", OnPortraitUpdate)

local function ResetPostUpdate()
	for unit, unitName in pairs(UF.units) do
		local frameNameUnit = E:StringTitle(unitName)
		frameNameUnit = frameNameUnit:gsub("t(arget)", "T%1")

		local unitframe = _G['ElvUF_'..frameNameUnit]
		if unitframe then
			if unitframe.Portrait2D then unitframe.Portrait2D.PostUpdate = UF.PortraitUpdate end
			if unitframe.Portrait3D then unitframe.Portrait3D.PostUpdate = UF.PortraitUpdate end
		end
	end

	for unit, unitgroup in pairs(UF.groupunits) do
		local frameNameUnit = E:StringTitle(unit)
		frameNameUnit = frameNameUnit:gsub('t(arget)', 'T%1')

		local unitframe = _G["ElvUF_"..frameNameUnit]
		if unitframe then
			if unitframe.Portrait2D then unitframe.Portrait2D.PostUpdate = UF.PortraitUpdate end
			if unitframe.Portrait3D then unitframe.Portrait3D.PostUpdate = UF.PortraitUpdate end
		end
	end

	for _, header in pairs(UF.headers) do
		for i = 1, header:GetNumChildren() do
			local group = select(i, header:GetChildren())
			--group is Tank/Assist Frames, but for Party/Raid we need to go deeper
			if group.Portrait2D then group.Portrait2D.PostUpdate = UF.PortraitUpdate end
			if group.Portrait3D then group.Portrait3D.PostUpdate = UF.PortraitUpdate end

			for j = 1, group:GetNumChildren() do
				--Party/Raid unitbutton
				local unitbutton = select(j, group:GetChildren())
				if unitbutton.Portrait2D then unitbutton.Portrait2D.PostUpdate = UF.PortraitUpdate end
				if unitbutton.Portrait3D then unitbutton.Portrait3D.PostUpdate = UF.PortraitUpdate end
			end
		end
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent(event)
	ResetPostUpdate()
end) 