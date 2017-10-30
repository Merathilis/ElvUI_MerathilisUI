local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")
if not IsAddOnLoaded("ElvUI_BenikUI") then return; end

-- Cache global variables
-- Lua functions
local _G = _G
local pairs = pairs
-- WoW API / Variables
local CreateFrame = CreateFrame
-- GLOBALS: 

local function styleBenikUI()
	if E.private.muiSkins.addonSkins.bui ~= true then return; end

	if _G["BuiLeftChatDTPanel"] then
		_G["BuiLeftChatDTPanel"]:Styling(true, true)
	end

	if _G["BuiMiddleDTPanel"] then
		_G["BuiMiddleDTPanel"]:Styling(true, true)
	end

	if _G["BuiRightChatDTPanel"] then
		_G["BuiRightChatDTPanel"]:Styling(true, true)
	end

	if _G["BuiTaxiButton"] then
		_G["BuiTaxiButton"]:Styling(true, true)
	end

	-- Style the datapanel buttons
	local f = CreateFrame("Frame")
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:SetScript("OnEvent", function(self, event)
		if event then
			for i = 1, 4 do
				local button = _G["BuiButton_"..i]
				button:Styling(true, true)
			end
			f:UnregisterEvent("PLAYER_ENTERING_WORLD")
		end
	end)
end

S:AddCallbackForAddon("ElvUI_BenikUI", "mUIBenikUI", styleBenikUI)