local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local COMP = MER:GetModule("mUICompatibility")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API / Variables
local hooksecurefunc = hooksecurefunc


if not COMP.AS then return end
local AS = unpack(AddOnSkins)

local function DbmDecor(event)
	if E.private.muiSkins.addonSkins.dbm ~= true then return end

	local function StyleRangeFrame(self, range, filter, forceshow, redCircleNumPlayers)
		if DBM.Options.DontShowRangeFrame and not forceshow then return end

		if not _G.DBMRangeCheckRadar.IsStyled then
			_G.DBMRangeCheckRadar:Styling()

			_G.DBMRangeCheckRadar.IsStyled = true
		end

		if not _G.DBMRangeCheck.IsStyled then
			_G.DBMRangeCheck:SetTemplate('Transparent')
			_G.DBMRangeCheck:Styling()

			_G.DBMRangeCheck.IsStyled = true
		end
	end

	local function StyleInfoFrame(self, maxLines, event, ...)
		if DBM.Options.DontShowInfoFrame and (event or 0) ~= "test" then return end

		if not _G.DBMInfoFrame.IsStyled then
			_G.DBMInfoFrame:Styling()

			_G.DBMInfoFrame.IsStyled = true
		end
	end

	hooksecurefunc(DBM.RangeCheck, 'Show', StyleRangeFrame)
	hooksecurefunc(DBM.InfoFrame, 'Show', StyleInfoFrame)
end

if AS:CheckAddOn('DBM-Core') then AS:RegisterSkin('DBM', DbmDecor, 'ADDON_LOADED') end
