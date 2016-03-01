local E, L, V, P, G = unpack(ElvUI);
local MUIC = E:NewModule('muiCastbar', 'AceTimer-3.0', 'AceEvent-3.0')
local UF = E:GetModule('UnitFrames');

-- Cache global variables
-- GLOBALS: hooksecurefunc
local _G = _G

-- attach Castbar Icon to InfoPanel (temp solution)
local function attachIcon(unit, unitframe)
	local cdb = E.db.unitframe.units[unit].castbar;
	local castbar = unitframe.Castbar
	
	if cdb.icon == true and cdb.insideInfoPanel and unitframe.USE_INFO_PANEL then
		castbar.ButtonIcon.bg:ClearAllPoints()
		if unit == 'player' then
			castbar.Icon.bg:Point("LEFT", _G["InfoPanel"], "RIGHT", 2, 0)
		elseif unit == 'target' then
			castbar.Icon.bg:Point("RIGHT", _G["InfoPanel"], "LEFT", -2, 0)
		end
	end
end

--Initiate update/reset of castbar
local function ConfigureCastbar(unit, unitframe)
	local db = E.db.unitframe.units[unit].castbar;
	local castbar = unitframe.Castbar
	
	if unit == 'player' or unit == 'target' then
		if db.insideInfoPanel and unitframe.USE_INFO_PANEL then
			attachIcon(unit, unitframe)
		end
	end
end

--Initiate update of unit
function MUIC:UpdateSettings(unit)
	if unit == 'player' or unit == 'target' then
		local unitFrameName = "ElvUF_"..E:StringTitle(unit)
		local unitframe = _G[unitFrameName]
		ConfigureCastbar(unit, unitframe)
	end
end

-- Function to be called when registered events fire
function MUIC:UpdateAllCastbars()
	MUIC:UpdateSettings("player")
	MUIC:UpdateSettings("target")
end

function MUIC:Initialize()
	--ElvUI UnitFrames are not enabled, stop right here!
	if E.private.unitframe.enable ~= true then return end

	--Profile changed, update castbar overlay settings
	hooksecurefunc(E, "UpdateAll", function()
		--Delay it a bit to allow all db changes to take effect before we update
		self:ScheduleTimer('UpdateAllCastbars', 0.5)
	end)

	--Castbar was modified, re-apply settings
	hooksecurefunc(UF, "Configure_Castbar", function(self, frame, preventLoop)
		if preventLoop then return; end

		local unit = frame.unitframeType
		if unit and (unit == 'player' or unit == 'target') and E.db.unitframe.units[unit].castbar.insideInfoPanel then
			MUIC:UpdateSettings(unit)
		end
	end)
end

E:RegisterModule(MUIC:GetName())
