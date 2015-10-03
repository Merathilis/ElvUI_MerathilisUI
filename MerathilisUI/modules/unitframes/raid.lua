local E, L, V, P, G, _ = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local UF = E:GetModule('UnitFrames');

local BORDER = E.Border;

function MER:UpdateRaidFrames(frame, db)
	if not frame.emptyBar then
		frame.emptyBar = CreateFrame('Frame', frame:GetName()..'EmptyBar', frame)
		frame.emptyBar:SetTemplate('Default')
		frame.emptyBar:SetFrameStrata('BACKGROUND')
	end
	local bar = frame.emptyBar
	
	local EMPTY_BARS_HEIGHT = 25

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
			bar:Point('TOPLEFT', power, 'BOTTOMLEFT', -BORDER, -3)
			bar:Point('BOTTOMRIGHT', power, 'BOTTOMRIGHT', BORDER, -EMPTY_BARS_HEIGHT)
		end

		if USE_PORTRAIT and not USE_PORTRAIT_OVERLAY then
			bar:Point("TOPRIGHT", frame.Portrait.backdrop, "TOPRIGHT", 0, -4)
		end
	end
end

function MER:InitRaid()
	hooksecurefunc(UF, 'Update_RaidFrame', MER.UpdateRaidFrames)
end
