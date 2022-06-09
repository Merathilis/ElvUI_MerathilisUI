local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local unpack = unpack
local hooksecurefunc = hooksecurefunc

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function LoadSkin()
	if not module:CheckDB("misc", "misc") then
		return
	end

	hooksecurefunc("UIDropDownMenu_SetIconImage", function(icon, texture)
		if texture:find("Divider") then
			icon:SetColorTexture(r, g, b, .8)
			icon:SetHeight(1)
		end
	end)
end

S:AddCallback("UIDropDownMenu", LoadSkin)
