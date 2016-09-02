local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');
local LSM = LibStub('LibSharedMedia-3.0');
local S = E:GetModule('Skins');

-- Cache global variables
-- Lua functions

-- WoW API / Variables

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: hooksecurefunc, QUEST_TRACKER_MODULE, BonusObjectiveTrackerProgressBar_PlayFlareAnim

local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])
local otf = ObjectiveTrackerFrame

local function ObjectiveTrackerReskin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.objectiveTracker ~= true or E.private.muiSkins.blizzard.objectivetracker ~= true then return end

	-- Underlines and header text
	hooksecurefunc("ObjectiveTracker_AddBlock", function(moduleHeader)
		if otf.MODULES then
			for i = 1, #otf.MODULES do
				if moduleHeader then
					local module = otf.MODULES[i]
					module.Header.Underline = MER:Underline(otf.MODULES[i].Header, true, 1)
					module.Header.Text:SetFont(LSM:Fetch("font", "Merathilis Roboto-Black"), 12, "OUTLINE")
					module.Header.Text:SetVertexColor(classColor.r, classColor.g, classColor.b)
				end
			end
		end
	end)
end
hooksecurefunc(S, "Initialize", ObjectiveTrackerReskin)