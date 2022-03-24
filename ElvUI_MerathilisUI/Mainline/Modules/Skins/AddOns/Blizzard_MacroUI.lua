local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

--Cache global variables
local _G = _G
--WoW API / Variables
-- GLOBALS:

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.macro ~= true or E.private.muiSkins.blizzard.macro ~= true then return end

	_G.MacroFrame:Styling()
	MER:CreateBackdropShadow(_G.MacroFrame)
	_G.MacroPopupFrame:Styling()
	MER:CreateBackdropShadow(_G.MacroPopupFrame)
end

S:AddCallbackForAddon("Blizzard_MacroUI", "mUIMacro", LoadSkin)
