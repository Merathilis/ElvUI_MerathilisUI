local E, L, V, P, G, _ = unpack(ElvUI);
local UFM = E:GetModule('MuiUnits');
local UF = E:GetModule('UnitFrames');

local BORDER = E.Border;

function UFM:UpdateRaidFrames(frame, db)
	if not frame.emptyBar then
		frame.emptyBar = CreateFrame('Frame', frame:GetName()..'EmptyBar', frame)
		frame.emptyBar:SetTemplate('Transparent')
		frame.emptyBar:SetFrameStrata('BACKGROUND')
	end
	local bar = frame.emptyBar

	local EMPTY_BARS_HEIGHT = E.db.muiUnitframes.EmptyBar.groupHeight

	local USE_POWERBAR = db.power.enable
	local USE_MINI_POWERBAR = db.power.width == 'spaced' and USE_POWERBAR
	local USE_INSET_POWERBAR = db.power.width == 'inset' and USE_POWERBAR
	local USE_POWERBAR_OFFSET = db.power.offset ~= 0 and USE_POWERBAR
	local POWERBAR_OFFSET = db.power.offset
	local POWERBAR_HEIGHT = db.power.height

	local USE_PORTRAIT = db.portrait and db.portrait.enable or false
	local USE_PORTRAIT_OVERLAY = (db.portrait and db.portrait.overlay) and USE_PORTRAIT

	-- Empty Bar
	do
		local health = frame.Health
		local power = frame.Power

		if USE_POWERBAR_OFFSET then
			bar:Point('TOPLEFT', power, 'BOTTOMLEFT', -BORDER, -3)
			bar:Point('BOTTOMRIGHT', power, 'BOTTOMRIGHT', BORDER, -EMPTY_BARS_HEIGHT)
		elseif USE_MINI_POWERBAR or USE_INSET_POWERBAR then
			bar:Point('TOPLEFT', health, 'BOTTOMLEFT', -BORDER, -3)
			bar:Point('BOTTOMRIGHT', health, 'BOTTOMRIGHT', BORDER, -EMPTY_BARS_HEIGHT)
		elseif POWERBAR_DETACHED or not USE_POWERBAR then
			bar:Point('TOPLEFT', health.backdrop, 'BOTTOMLEFT', 0, -1)
			bar:Point('BOTTOMRIGHT', health.backdrop, 'BOTTOMRIGHT', 0, -EMPTY_BARS_HEIGHT)
		else
			bar:Point('TOPLEFT', power, 'BOTTOMLEFT', -BORDER, 0)
			bar:Point('BOTTOMRIGHT', power, 'BOTTOMRIGHT', BORDER, -EMPTY_BARS_HEIGHT)
		end

		if USE_PORTRAIT and not USE_PORTRAIT_OVERLAY then
			bar:Point("TOPRIGHT", frame.Portrait.backdrop, "TOPRIGHT", 0, -4)
		end
	end

	--Threat
	do
		local threat = frame.Threat

		if db.threatStyle ~= 'NONE' and db.threatStyle ~= nil then
			if db.threatStyle == "GLOW" then
				threat:SetFrameStrata('BACKGROUND')
				threat.glow:ClearAllPoints()
				threat.glow:SetBackdropBorderColor(0, 0, 0, 0)
				if E.db.muiUnitframes.EmptyBar.threat then
					threat.glow:Point("TOPLEFT", bar, "TOPLEFT", -4, 4)
					threat.glow:Point("TOPRIGHT", bar, "TOPRIGHT", 4, 4)
				else
					threat.glow:Point("TOPLEFT", frame.Health.backdrop, "TOPLEFT", -4, 4)
					threat.glow:Point("TOPRIGHT", frame.Health.backdrop, "TOPRIGHT", 4, 4)
				end
				threat.glow:Point("BOTTOMLEFT", bar, "BOTTOMLEFT", -4, -4)
				threat.glow:Point("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 4, -4)

				if USE_MINI_POWERBAR or USE_POWERBAR_OFFSET or USE_INSET_POWERBAR then
					threat.glow:Point("BOTTOMLEFT", bar, "BOTTOMLEFT", -4, -4)
					threat.glow:Point("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 4, -4)
				end

				if USE_PORTRAIT and not USE_PORTRAIT_OVERLAY then
					threat.glow:Point("TOPRIGHT", frame.Portrait.backdrop, "TOPRIGHT", 4, -4)
					threat.glow:Point("BOTTOMRIGHT", frame.Portrait.backdrop, "BOTTOMRIGHT", 4, -4)
				end
			elseif db.threatStyle == "ICONTOPLEFT" or db.threatStyle == "ICONTOPRIGHT" or db.threatStyle == "ICONBOTTOMLEFT" or db.threatStyle == "ICONBOTTOMRIGHT" or db.threatStyle == "ICONTOP" or db.threatStyle == "ICONBOTTOM" or db.threatStyle == "ICONLEFT" or db.threatStyle == "ICONRIGHT" then
				threat:SetFrameStrata('HIGH')
				local point = db.threatStyle
				point = point:gsub("ICON", "")

				threat.texIcon:ClearAllPoints()
				threat.texIcon:SetPoint(point, frame.Health, point)
			end
		end
	end

	--Target Glow
	do
		local tGlow = frame.TargetGlow
		tGlow:ClearAllPoints()
		tGlow:Point("TOPLEFT", -4, 4)
		tGlow:Point("TOPRIGHT", 4, 4)

		if USE_MINI_POWERBAR then
			tGlow:Point("BOTTOMLEFT", -4, -4 + (POWERBAR_HEIGHT/2))
			tGlow:Point("BOTTOMRIGHT", 4, -4 + (POWERBAR_HEIGHT/2))
		else
			tGlow:Point("BOTTOMLEFT", bar, "BOTTOMLEFT", -4, -4)
			tGlow:Point("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 4, -4)
		end

		if USE_POWERBAR_OFFSET then
			tGlow:Point("TOPLEFT", -4+POWERBAR_OFFSET, 4)
			tGlow:Point("TOPRIGHT", 4, 4)
			tGlow:Point("BOTTOMLEFT", -4+POWERBAR_OFFSET, -4+POWERBAR_OFFSET)
			tGlow:Point("BOTTOMRIGHT", 4, -4+POWERBAR_OFFSET)
		end
	end
end
