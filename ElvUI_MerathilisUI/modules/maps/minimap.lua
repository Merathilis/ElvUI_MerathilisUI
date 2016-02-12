local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

-- Cache global variables
-- GLOBALS: Minimap

local function blipIcons()
	Minimap:SetBlipTexture("Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\blipIcons.tga")
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event)
	if not E.db.muiMisc.minimapblip then return; end
	if event == "PLAYER_ENTERING_WORLD" then
		blipIcons()
		f:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
end)
