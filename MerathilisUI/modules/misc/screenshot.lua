local E, L, V, P, G, _ = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

-- Cache global variables
local CreateFrame = CreateFrame

if E.db.muiMisc == nil then E.db.muiMisc = {} end
if not E.db.muiMisc.Screenshot ~= true then return end

-- Take screenshots of defined events (Sinaris)
local function OnEvent(self, event, ...)
	C_Timer.After(1, function() Screenshot() end)
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ACHIEVEMENT_EARNED")
frame:SetScript("OnEvent", OnEvent)
