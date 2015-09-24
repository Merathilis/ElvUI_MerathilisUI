local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local MER = E:GetModule('MerathilisUI');

-- Credits to Haleth (RareAlert)
if IsAddOnLoaded("RareAlert") then return end

local blacklist = {
	971, -- Alliance garrison
	976, -- Horde garrison
	1152, -- FW Horde Garrison Level 1
	1330, -- FW Horde Garrison Level 2
	1153, -- FW Horde Garrison Level 3
	1154, -- FW Horde Garrison Level 4
	1158, -- SMV Alliance Garrison Level 1
	1331, -- SMV Alliance Garrison Level 2
	1159, -- SMV Alliance Garrison Level 3
	1160, -- SMV Alliance Garrison Level 4
}

local f = CreateFrame("Frame")
f:RegisterEvent("VIGNETTE_ADDED")
f:SetScript("OnEvent", function()
	if E.db.mui.RareAlert then
	
		if (tContains(blacklist, GetCurrentMapAreaID())) then return end
		PlaySound("RaidWarning", "master"); 
		RaidNotice_AddMessage(RaidWarningFrame, L["Rare spotted!"], ChatTypeInfo["RAID_WARNING"])
	end
end)
