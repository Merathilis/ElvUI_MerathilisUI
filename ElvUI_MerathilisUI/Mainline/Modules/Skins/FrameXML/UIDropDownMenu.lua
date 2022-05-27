local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local unpack = unpack
local hooksecurefunc = hooksecurefunc

local r, g, b = unpack(E["media"].rgbvaluecolor)

function module:UIDropDownMenu()
	if E.private.skins.blizzard.enable ~= true then return end

	hooksecurefunc("UIDropDownMenu_SetIconImage", function(icon, texture)
		if texture:find("Divider") then
			icon:SetColorTexture(r, g, b, .8)
			icon:SetHeight(1)
		end
	end)
end

module:AddCallback("UIDropDownMenu")
