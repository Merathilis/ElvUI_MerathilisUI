local E, L, V, P, G = unpack(ElvUI);

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API

-- Global variables that we don't cache, list th styleCharacter, CharacterStatsPane

local function styleMisc()
	if E.private.skins.blizzard.enable ~= true then return end

	_G["AlwaysUpFrame1"]:ClearAllPoints()
	_G["AlwaysUpFrame1"]:SetPoint("CENTER", E.UIParent, "TOP", -80, -70) --e.g. Violat Hold
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, _, addon)
	if addon == "ElvUI_MerathilisUI" then
		E:Delay(1, styleMisc)
		self:UnregisterEvent("ADDON_LOADED")
	end
end)