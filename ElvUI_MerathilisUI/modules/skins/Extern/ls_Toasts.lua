local MER, E, L, V, P, G = unpack(select(2, ...))

-- Cache global variables
-- Lua functions
local unpack = unpack
-- WoW API / Variables
-- GLOBALS:

if not IsAddOnLoaded("ls_Toasts") then return end
local LST = unpack(ls_Toasts)

LST:RegisterSkin("MerathilisUI", {
	name = "|cffff7d0aMerathilisUI|r",
	template = "elv-no-art",
	border = {
		texture = {0, 0, 0, 0.75},
	},
	icon = {
		tex_coords = {.08, .92, .08, .92},
	},
	icon_border = {
		offset = 1,
		texture = {1, 1, 1, 1},
	},
	icon_highlight = {
		hidden = true,
	},
	icon_text_1 = {
		flags = "OUTLINE",
	},
	icon_text_2 = {
		flags = "OUTLINE",
	},
	dragon = {
		hidden = true,
	},
	slot = {
		tex_coords = {.08, .92, .08, .92},
	},
	bg = {
		default = {
			texture = {0, 0, 0, 0.75},
		},
	},
})

hooksecurefunc(LST, "ApplySkin", function(_, toast)
	if not toast.skinned then
		toast:Styling()
		toast.skinned = true
	end
end)