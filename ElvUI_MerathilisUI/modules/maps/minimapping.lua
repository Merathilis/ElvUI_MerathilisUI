local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

-- Cache global variables
-- Lua functions
local format = string.format
local select = select
local time = time

-- WoW API / Variables
local CreateFrame = CreateFrame
local CUSTOM_CLASS_COLORS = CUSTOM_CLASS_COLORS
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local UnitClass = UnitClass
local UnitName = UnitName
local UIFrameFlash = UIFrameFlash

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local PingFrame = CreateFrame("Frame")
local PingText = PingFrame:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
PingText:SetPoint("CENTER", Minimap, "CENTER", 0, -30)
PingText:SetJustifyH("CENTER")

local function OnEvent(self, event, unit)
	if UnitName(unit) ~= E.myname then
		if self.timer and time() - self.timer > 1 or not self.timer then
			local Class = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS[select(2, UnitClass(unit))]
			PingText:SetText(format("|cffff0000*|r %s |cffff0000*|r", UnitName(unit)))
			PingText:SetTextColor(Class.r, Class.g, Class.b)
			UIFrameFlash(self, 0.2, 2.8, 5, false, 0, 5)
			self.timer = time()
		end
	end
end

function MER:LoadMinimapPing()
	if E.db.mui.misc.minimapping then
		PingFrame:RegisterEvent("MINIMAP_PING")
		PingFrame:SetScript("OnEvent", OnEvent)
	end
end