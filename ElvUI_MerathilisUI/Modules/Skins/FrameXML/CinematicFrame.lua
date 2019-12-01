local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

--Cache global variables
local _G = _G
--WoW API / Variables
local UIParent = UIParent
-- GLOBALS:

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true then return end

end

S:AddCallback("mUICinematic", LoadSkin)
