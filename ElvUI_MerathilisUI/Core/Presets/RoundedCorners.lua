local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

-- Cropped to the unit frames and action bars, at the width : height of the preset cards
local PREVIEW_COORDS = { 0.28, 0.74, 0.655, 0.945 }

F.Presets.Register({
	key = "rounded",
	name = L["Rounded Corners"],
	desc = L["The MerathilisUI layout with rounded health, power, class and cast bars on all unit frames."],
	base = "gradient",
	preview = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\Presets\RoundedCorners.tga]],
	previewCoords = PREVIEW_COORDS,
	apply = function()
		-- Every unit and bar the module knows is on by default, the preset only turns it on
		E.db.mui.unitframes.roundedCorners.enable = true
	end,
})
