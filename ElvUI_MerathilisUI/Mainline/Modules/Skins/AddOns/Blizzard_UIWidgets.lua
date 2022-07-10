local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local function LoadSkin()
	if not module:CheckDB("warboard", "warboard") then
		return
	end

end

--S:AddCallbackForAddon("Blizzard_UIWidgets", LoadSkin)
