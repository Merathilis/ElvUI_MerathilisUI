local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

local _G = _G

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.macro ~= true or E.private.mui.skins.blizzard.macro ~= true then return end

	_G.MacroFrame:Styling()
	MER:CreateBackdropShadow(_G.MacroFrame)
	_G.MacroPopupFrame:Styling()
	MER:CreateBackdropShadow(_G.MacroPopupFrame)
end

S:AddCallbackForAddon("Blizzard_MacroUI", "mUIMacro", LoadSkin)
