local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.warboard ~= true or E.private.mui.skins.blizzard.warboard ~= true then return end

end

--S:AddCallbackForAddon("Blizzard_UIWidgets", LoadSkin)
