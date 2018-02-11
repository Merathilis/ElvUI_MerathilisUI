local MER, E, L, V, P, G = unpack(select(2, ...))

-- Cache global variables
-- Lua functions
local unpack = unpack
-- WoW API / Variables
local IsAddOnLoaded = IsAddOnLoaded
-- GLOBALS:

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function()
	f:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if E.private.muiSkins.addonSkins.ls ~= true then return end
	if IsAddOnLoaded("ls_Toasts") then
		local LST = unpack(ls_Toasts)

		LST:RegisterSkin("MerathilisUI", function(toast)
			toast.Border:SetAlpha(1)
			toast.Border:SetVertexColor(0, 0, 0, .75)
			toast.TextBG:SetAlpha(1)

			toast.Icon:SetTexCoord(unpack(E.TexCoords))
			toast.Title:FontTemplate(nil, 12, "OUTLINE")
			toast.Title:SetPoint("TOPLEFT", 55, -12)

			if not toast.skinned then
				toast.Border:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\media\textures\toast-border.tga]])
				toast.BG:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\media\textures\gradient.tga]])
				toast.BG:SetAlpha(.5)
				toast.BG:SetVertexColor(0.15, 0.15, 0.15)

				local stripes = toast:CreateTexture(nil, "BORDER")
				stripes:SetPoint("TOPLEFT", toast.BG, 1, -1)
				stripes:SetPoint("BOTTOMRIGHT", toast.BG, -1, 1)
				stripes:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\media\textures\stripes]], true, true)
				stripes:SetHorizTile(true)
				stripes:SetVertTile(true)
				stripes:SetBlendMode("ADD")

				toast.skinned = true
			end

			local r, g, b = toast.IconBorder:GetVertexColor()
			if r > 0.99 and g > 0.99 and b > 0.99 then
				toast.IconBorder:SetVertexColor(0, 0, 0, 1)
				toast.IconBorder:SetTexture([[Interface\AddOns\ElvUI_MerathilisUI\media\textures\icon-border.tga]])
			end
			toast.IconBorder:SetTexture([[Interface\AddOns\ls_Toasts_MerathilisUI\media\icon-border.tga]])
			toast.IconBorder:SetTexCoord(0, 1, 0, 1)
		end)
		LST:SetSkin("MerathilisUI")
	end
end)