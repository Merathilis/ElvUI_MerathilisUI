local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local COMP = MER:GetModule("mUICompatibility")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions

-- WoW API / Variables

--if not COMP.AS then return end

local function DbmDecor(event)
	--if not E.db.benikui.general.benikuiStyle or not E.db.benikuiSkins.addonSkins.dbm then return end

	local function StyleRangeFrame(self, range, filter, forceshow, redCircleNumPlayers)
		if DBM.Options.DontShowRangeFrame and not forceshow then return end

		if DBMRangeCheckRadar then
			if not DBMRangeCheckRadar.style then
				DBMRangeCheckRadar:Styling()
			end
		end

		if DBMRangeCheck then
			DBMRangeCheck:SetTemplate('Transparent')
			if not DBMRangeCheck.style then
				DBMRangeCheck:Styling()
			end
		end
	end

	local function StyleInfoFrame(self, maxLines, event, ...)
		if DBM.Options.DontShowInfoFrame and (event or 0) ~= "test" then return end

		if DBMInfoFrame and not DBMInfoFrame.style then
			DBMInfoFrame:Styling()
		end
	end

	hooksecurefunc(DBM.RangeCheck, 'Show', StyleRangeFrame)
	hooksecurefunc(DBM.InfoFrame, 'Show', StyleInfoFrame)
end
if IsAddOnLoaded("AddOnSkins") then
	local AS = unpack(AddOnSkins)
	if AS:CheckAddOn('DBM-Core') then AS:RegisterSkin('DBM', DbmDecor, 2) end
end
