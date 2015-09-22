local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local MER = E:GetModule('MerathilisUI');

-- Credits to Haleth (RareAlert)
if IsAddOnLoaded("RareAlert") then return end

local blacklist = {
	[971] = true, -- Alliance garrison
	[976] = true, -- Horde garrison
}

local f = CreateFrame("Frame")
f:RegisterEvent("VIGNETTE_ADDED")
f:SetScript("OnEvent", function()
	if E.db.Merathilis.RareAlert then
		if blacklist[GetCurrentMapAreaID()] then return end

		PlaySoundFile("Interface\\AddOns\\MerathilisUI\\media\\sounds\\warning.ogg")
		RaidNotice_AddMessage(RaidWarningFrame, L["Rare spotted!"], ChatTypeInfo["RAID_WARNING"])
	end
end)