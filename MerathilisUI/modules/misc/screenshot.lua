local E, L, V, P, G, _ = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

-- Automatic achievement screenshot
local function OnEvent(self, event, ...)
	if not E.db.Merathilis.Screenshot then return end
	C_Timer.After(1, function() Screenshot() end)
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ACHIEVEMENT_EARNED")
frame:SetScript("OnEvent", OnEvent)
