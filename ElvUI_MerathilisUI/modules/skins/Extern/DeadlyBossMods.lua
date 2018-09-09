local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local COMP = MER:GetModule("mUICompatibility")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions

-- WoW API / Variables

if not COMP.AS then return end
local AS = unpack(AddOnSkins)

local function DbmDecor(event)
	--if not E.db.benikui.general.benikuiStyle or not E.db.benikuiSkins.addonSkins.dbm then return end

	local function StyleRangeFrame(self, range, filter, forceshow, redCircleNumPlayers)
		--if DBM.Options.DontShowRangeFrame and not forceshow then return end

		if DBMRangeCheckRadar and not DBMRangeCheckRadar.IsStyled then
			DBMRangeCheckRadar:Styling()
			DBMRangeCheckRadar.IsStyled = true
			print("style")
		end

		if DBMRangeCheck and not DBMRangeCheck.IsStyled then
			DBMRangeCheck:SetTemplate('Transparent')
			DBMRangeCheck:Styling()
			DBMRangeCheck.IsStyled = true
			print("style")
		end
	end

	local function StyleInfoFrame(self, maxLines, event, ...)
		if DBM.Options.DontShowInfoFrame and (event or 0) ~= "test" then return end

		if DBMInfoFrame then
			DBMInfoFrame:Styling()
		end
	end

	hooksecurefunc(DBM.RangeCheck, 'Show', StyleRangeFrame)
	hooksecurefunc(DBM.InfoFrame, 'Show', StyleInfoFrame)
end

if AS:CheckAddOn('DBM-Core') then AS:RegisterSkin('DBM', DbmDecor, 2) end
