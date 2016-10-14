local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

-- Cache global variables
-- Lua functions

-- WoW API / Variables

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function OnVignetteAdded(self, event, id)
	if not id then return end
	self.vignettes = self.vignettes or {}
	if self.vignettes[id] then return end

	local x, y, name, icon = C_Vignettes.GetVignetteInfoFromInstanceID(id)
	local left, right, top, bottom = GetObjectIconTextureCoords(icon)
	PlaySoundFile("Sound\\Interface\\RaidWarning.ogg")
	local str = "|TInterface\\MINIMAP\\ObjectIconsAtlas:0:0:0:0:256:256:"..(left*256)..":"..(right*256)..":"..(top*256)..":"..(bottom*256).."|t"
	RaidNotice_AddMessage(RaidWarningFrame, str..name..L[" spotted!"], ChatTypeInfo["RAID_WARNING"])

	MER:Print(str..name, L[" spotted!"])
	self.vignettes[id] = true
end


function MER:LoadVignette()
	if E.db.mui.misc.vignette then
		local eventHandler = CreateFrame("Frame")
		eventHandler:RegisterEvent("VIGNETTE_ADDED")
		eventHandler:SetScript("OnEvent", OnVignetteAdded)
	end
end