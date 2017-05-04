local E, L, V, P, G = unpack(ElvUI);
local S = E:GetModule("Skins");
local MERS = E:GetModule("muiSkins")

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API / Variables
local IsAddOnLoaded = IsAddOnLoaded
-- GLOBALS:

local function stylePremadeGroupsFilter()
	if E.private.muiSkins.addonSkins.pgf ~= true or not IsAddOnLoaded("PremadeGroupsFilter") then return; end

	MERS:StyleOutside(_G["PremadeGroupsFilterDialog"])
end

S:AddCallbackForAddon("PremadeGroupsFilter", "mUIPremadeGroupsFilter", stylePremadeGroupsFilter)