local MER, E, L, V, P, G = unpack(select(2, ...))
local MERB = E:NewModule("mUIBags", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")
MERB.modName = L["Bags"]

--Cache global variables
--Lua Variables
local select = select
local format = string.format
--WoW API / Variables
local CreateFrame = CreateFrame
local GetContainerNumFreeSlots = GetContainerNumFreeSlots
local PlaySound = PlaySound
local IsReagentBankUnlocked = IsReagentBankUnlocked
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

function MERB:Initialize()
	if E.private.bags.enable then return end

end

local function InitializeCallback()
	MERB:Initialize()
end

-- E:RegisterModule(MERB:GetName(), InitializeCallback)