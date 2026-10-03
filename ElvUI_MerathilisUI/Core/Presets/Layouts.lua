local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local PREVIEW_PATH = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\Install\]]
-- The installer screenshots, cropped to the unit frames and action bars like on its cards
local PREVIEW_COORDS = { 0.22, 0.78, 0.55, 0.95 }

-- The two installer layouts as they are
F.Presets.Register({
	key = "gradient",
	name = L["Gradient"],
	desc = L["The MerathilisUI layout with gradient health bars in the class color."],
	base = "gradient",
	preview = PREVIEW_PATH .. "Gradient.tga",
	previewCoords = PREVIEW_COORDS,
})

F.Presets.Register({
	key = "dark",
	name = L["Dark"],
	desc = L["The MerathilisUI layout with dark health bars and the class color on their backdrop."],
	base = "dark",
	preview = PREVIEW_PATH .. "Dark.tga",
	previewCoords = PREVIEW_COORDS,
})
