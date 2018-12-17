local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")
if not IsAddOnLoaded("ProjectAzilroka") then return end

-- Cache global variables
-- Lua functions
local _G = _G
local CreateFrame = CreateFrame
-- WoW API / Variables
-- GLOBALS:

local function styleProjectAzilroka()
	if E.private.muiSkins.addonSkins.pa ~= true then return end

	local f = CreateFrame("Frame")
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:SetScript("OnEvent", function(self, event)
		if event then
			local stFrame = _G.stAMFrame
			if stFrame then
				stFrame:Styling()
				stFrame.AddOns:SetTemplate("Transparent")
			end
			f:UnregisterEvent("PLAYER_ENTERING_WORLD")
		end
	end)
end

S:AddCallbackForAddon("ProjectAzilroka", "ADDON_LOADED", styleProjectAzilroka)
