local MER, E, L, V, P, G = unpack(select(2, ...))

-- Cache global variables
-- Lua functions
local unpack = unpack
-- WoW API / Variables

-- GLOBALS:
if not IsAddOnLoaded("ls_Toasts") then return end
local LST = unpack(ls_Toasts)

-- if E.private.muiSkins.addonSkins.ls ~= true then return end
LST:RegisterSkin("MerathilisUI", {
	name = "|cffff7d0aMerathilisUI|r",
	template = "elv-no-art",
	border = {
		color = {0, 0, 0, .75},
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
	dragon = {
		hidden = true,
	},
	bonus = {
		hidden = false,
	},
	skull = {
		hidden = false,
	},
	bg = {
		alliance = {
			color = {0, 0, 0, 1},
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\stripes",
		},
		archaeology = {
			color = {0, 0, 0, 1},
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\stripes",
		},
		collection = {
			color = {0, 0, 0, 1},
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\stripes",
		},
		default = {
			color = {0, 0, 0, 1},
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\stripes",
		},
		dungeon = {
			color = {0, 0, 0, 1},
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\stripes",
		},
		horde = {
			color = {0, 0, 0, 1},
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\stripes",
		},
		legendary = {
			color = {0, 0, 0, 1},
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\stripes",
		},
		legion = {
			color = {0, 0, 0, 1},
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\stripes",
		},
		recipe = {
			color = {0, 0, 0, 1},
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\stripes",
		},
		store = {
			color = {0, 0, 0, 1},
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\stripes",
		},
		transmog = {
			color = {0, 0, 0, 1},
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\stripes",
		},
		upgrade = {
			color = {0, 0, 0, 1},
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\stripes",
		},
		worldquest = {
			color = {0, 0, 0, 1},
			texture = "Interface\\AddOns\\ElvUI_MerathilisUI\\media\\textures\\stripes",
		},
	},
})
LST:SetSkin("MerathilisUI")