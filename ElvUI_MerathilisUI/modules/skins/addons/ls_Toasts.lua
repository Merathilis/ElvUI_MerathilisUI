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
		texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\icon-border",
	},
	bg = {
		alliance = {
			texture = {0.14, 0.14, 0.14, .45},
		},
		archaeology = {
			texture = {0.14, 0.14, 0.14, .45},
		},
		collection = {
			texture = {0.14, 0.14, 0.14, .45},
		},
		default = {
			texture = {0.14, 0.14, 0.14, .45},
		},
		dungeon = {
			texture = {0.14, 0.14, 0.14, .45},
		},
		horde = {
			texture = {0.14, 0.14, 0.14, .45},
		},
		legendary = {
			texture = {0.14, 0.14, 0.14, .45},
		},
		legion = {
			texture = {0.14, 0.14, 0.14, .45},
		},
		recipe = {
			texture = {0.14, 0.14, 0.14, .45},
		},
		store = {
			texture = {0.14, 0.14, 0.14, .45},
		},
		transmog = {
			texture = {0.14, 0.14, 0.14, .45},
		},
		upgrade = {
			texture = {0.14, 0.14, 0.14, .45},
		},
		worldquest = {
			texture = {0.14, 0.14, 0.14, .45},
		},
	},
})
LST:SetSkin("MerathilisUI")

hooksecurefunc(LST, "ApplySkin", function(_, toast)
	if not toast.skinned then
		toast:Styling()
		toast.skinned = true
	end
end)