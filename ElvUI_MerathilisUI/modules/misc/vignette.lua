local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule("MerathilisUI");
local M = E:GetModule("mUIMisc")

-- Cache global variables
-- Lua functions

-- WoW API / Variables
local C_Vignettes = C_Vignettes
local GetObjectIconTextureCoords = GetObjectIconTextureCoords
local ChatTypeInfo = ChatTypeInfo
local PlaySoundFile = PlaySoundFile
-- Global variables that we don"t cache, list them here for the mikk"s Find Globals script
-- GLOBALS: RaidNotice_AddMessage, RaidWarningFrame

local function OnVignetteAdded(self, _, id)
	if not id then return end
	self.vignettes = self.vignettes or {}
	if self.vignettes[id] then return end

	local _, _, name, icon = C_Vignettes.GetVignetteInfoFromInstanceID(id)
	local left, right, top, bottom = GetObjectIconTextureCoords(icon)
	PlaySoundFile("Sound\\Interface\\RaidWarning.ogg")
	local str = "|TInterface\\MINIMAP\\ObjectIconsAtlas:0:0:0:0:256:256:"..(left*256)..":"..(right*256)..":"..(top*256)..":"..(bottom*256).."|t"
	RaidNotice_AddMessage(RaidWarningFrame, str..name..L[" spotted!"], ChatTypeInfo["RAID_WARNING"])

	MER:Print(str..name, L[" spotted!"])
	self.vignettes[id] = true
end

function M:LoadVignette()
	if E.db.mui.misc.vignette then
		local eventHandler = CreateFrame("Frame")
		eventHandler:RegisterEvent("VIGNETTE_ADDED")
		eventHandler:SetScript("OnEvent", OnVignetteAdded)
	end
end