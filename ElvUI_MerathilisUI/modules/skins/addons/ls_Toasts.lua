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
		color = {0, 0, 0, .75},
		offset = 0,
		size = 1,
		texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\toast-border",
	},
	icon = {
		tex_coords = {.08, .92, .08, .92},
	},
	icon_border = {
		color = {0, 0, 0, 1},
		size = 1,
		offset = 1,
		texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\icon-border",
	},
	icon_highlight = {
		hidden = true,
	},
	icon_text_1 = {
		color = {1, 1, 1},
		flags = "OUTLINE",
		shadow = false,
	},
	icon_text_2 = {
		color = {1, 1, 1},
		flags = "OUTLINE",
		shadow = false,
	},
	dragon = {
		hidden = true,
	},
	bonus = {
		hidden = false,
	},
	skull = {
		hidden = false,
	},
	slot = {
		tex_coords = {.08, .92, .08, .92},
		texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\icon-border",
	},
	bg = {
		alliance = {
			texture = {0.15, 0.15, 0.15, .75},
		},
		archaeology = {
			texture = {0.15, 0.15, 0.15, .75},
		},
		collection = {
			texture = {0.15, 0.15, 0.15, .75},
		},
		default = {
			texture = {0.15, 0.15, 0.15, .75},
		},
		dungeon = {
			texture = {0.15, 0.15, 0.15, .75},
		},
		horde = {
			texture = {0.15, 0.15, 0.15, .75},
		},
		legendary = {
			texture = {0.15, 0.15, 0.15, .75},
		},
		legion = {
			texture = {0.15, 0.15, 0.15, .75},
		},
		recipe = {
			texture = {0.15, 0.15, 0.15, .75},
		},
		store = {
			texture = {0.15, 0.15, 0.15, .75},
		},
		transmog = {
			texture = {0.15, 0.15, 0.15, .75},
		},
		upgrade = {
			texture = {0.15, 0.15, 0.15, .75},
		},
		worldquest = {
			texture = {0.15, 0.15, 0.15, .75},
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